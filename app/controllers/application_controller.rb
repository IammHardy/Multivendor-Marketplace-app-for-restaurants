class ApplicationController < ActionController::Base
  helper_method :current_cart

  # ----------------------------
  # BEFORE ACTIONS
  # ----------------------------
  before_action :store_user_location!, if: :storable_location?
  before_action :load_food_subcategories
  before_action :load_main_categories
  before_action :set_unread_counts
  before_action :update_last_seen

  # ----------------------------
  # CURRENT CART HELPER
  # ----------------------------
  def current_cart
    return @current_cart if defined?(@current_cart) && @current_cart.present?

    if session[:cart_id]
      @current_cart = Cart.find_by(id: session[:cart_id])
      return @current_cart if @current_cart
    end

    if current_user
      @current_cart = current_user.cart || current_user.create_cart
    else
      @current_cart = Cart.create
    end

    session[:cart_id] = @current_cart.id
    @current_cart
  end

  # ----------------------------
  # MERGE GUEST CART WITH SIGNED-IN USER
  # ----------------------------
  def merge_guest_cart_with(user)
    return unless user.is_a?(User)

    guest_cart = Cart.find_by(id: session[:cart_id])
    return unless guest_cart && guest_cart.user.nil?

    user_cart = user.cart || user.create_cart

    guest_cart.cart_items.each do |item|
      existing_item = user_cart.cart_items.find_by(food_id: item.food_id)

      if existing_item
        existing_item.update(
          quantity: existing_item.quantity + item.quantity,
          unit_price: item.food.price
        )
      else
        user_cart.cart_items.create!(
          food: item.food,
          quantity: item.quantity,
          unit_price: item.food.price
        )
      end
    end

    guest_cart.destroy
    session[:cart_id] = user_cart.id
  end

  # ----------------------------
  # UPDATE LAST SEEN TIMESTAMP
  # ----------------------------
  def update_last_seen
    if user_signed_in?
      current_user.update_column(:last_seen_at, Time.current)
    elsif vendor_signed_in?
      current_vendor.update_column(:last_seen_at, Time.current)
    end
  end

  # ----------------------------
  # SET UNREAD COUNTS (MESSAGES & SUPPORT TICKETS)
  # ----------------------------
  def set_unread_counts
    if user_signed_in?
      if current_user.is_a?(User)
        # Unread messages for a customer
        @unread_conversations_count = Conversation.joins(:messages)
          .where(user_id: current_user.id, messages: { read: false })
          .distinct.count

        # New support tickets
        @new_support_tickets_count = current_user.support_tickets.where(status: "new").count
      elsif current_user.is_a?(Vendor)
        # Unread messages for vendor
        @unread_conversations_count = Conversation.joins(:messages)
          .where(vendor_id: current_user.id, messages: { read: false })
          .distinct.count

        @new_support_tickets_count = 0
      end
    else
      @unread_conversations_count = 0
      @new_support_tickets_count = 0
    end
  end

  # ----------------------------
  # DEVISE REDIRECTION AFTER SIGN IN
  # ----------------------------
def after_sign_in_path_for(resource)
  merge_guest_cart_with(resource) if session[:cart_id] && resource.is_a?(User)

  if resource.is_a?(User) && resource.admin?
    admin_dashboard_path
  elsif resource.is_a?(Vendor)
    vendor_dashboard_path
  elsif resource.is_a?(Rider)
    rider_dashboard_path
  else
    stored_location_for(resource) || root_path
  end
end





  # ----------------------------
  # STORE USER LOCATION (FOR DEVlSE)
  # ----------------------------
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # ----------------------------
  # LOAD FOOD SUBCATEGORIES
  # ----------------------------
  def load_food_subcategories
    food_category = Category.find_by(name: "Food")
    @food_subcategories = food_category ? food_category.children : []
  end

  # ----------------------------
  # LOAD MAIN CATEGORIES
  # ----------------------------
  def load_main_categories
    @main_categories = Category.where(parent_id: nil)
  end

  # ----------------------------
  # ADMIN ACCESS CHECK
  # ----------------------------
  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
