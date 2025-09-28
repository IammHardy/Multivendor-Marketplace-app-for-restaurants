class ApplicationController < ActionController::Base
  helper_method :current_cart

  before_action :store_user_location!, if: :storable_location?
  before_action :load_food_subcategories
  before_action :load_main_categories
  before_action :set_unread_counts


  before_action :update_last_seen

def update_last_seen
  if user_signed_in?
    current_user.update_column(:last_seen_at, Time.current)
  elsif vendor_signed_in?
    current_vendor.update_column(:last_seen_at, Time.current)
  end
end

  private

  def set_unread_counts
  if user_signed_in?
    if current_user.is_a?(User)
      # Unread messages for a customer
      @unread_conversations_count = Conversation.joins(:messages)
        .where(user_id: current_user.id, messages: { read: false })
        .distinct.count

# New support tickets (only for Users, not vendors)
@new_support_tickets_count = current_user.support_tickets.where(status: "new").count


    elsif current_user.is_a?(Vendor)
      # Unread messages for a vendor
      @unread_conversations_count = Conversation.joins(:messages)
        .where(vendor_id: current_user.id, messages: { read: false })
        .distinct.count

      # Vendors may not have support tickets; set to 0
      @new_support_tickets_count = 0
    end
  else
    @unread_conversations_count = 0
    @new_support_tickets_count = 0
  end
end


  # Devise: redirect after sign in
  def after_sign_in_path_for(resource)
    merge_guest_cart_with(resource) if session[:cart_id] && resource.is_a?(User)

    if resource.is_a?(User) && resource.admin?
      admin_dashboard_path
    elsif resource.is_a?(Vendor)
      vendor_dashboard_path # redirect Vendors to their dashboard
    else
      stored_location_for(resource) || root_path
    end
  end

  # Current cart helper
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

  # Merge guest cart items into signed-in user's cart
  def merge_guest_cart_with(user)
    return unless user.is_a?(User)

    guest_cart = Cart.find_by(id: session[:cart_id])
    return unless guest_cart && guest_cart.user.nil?

    if user.cart
      guest_cart.cart_items.each do |item|
        existing_item = user.cart.cart_items.find_by(food_id: item.food_id)
        if existing_item
          existing_item.update(quantity: existing_item.quantity + item.quantity)
        else
          item.update(cart_id: user.cart.id)
        end
      end
      guest_cart.destroy
    else
      guest_cart.update(user: user)
    end

    session[:cart_id] = user.cart.id
  end

  # Determine if the current request URL should be stored for redirect
  def storable_location?
    request.get? &&
      is_navigational_format? &&
      !devise_controller? &&
      !request.xhr?
  end

  # Store the user location for Devise
  def store_user_location!
    store_location_for(:user, request.fullpath)
  end

  # Load Food subcategories for header menu
  def load_food_subcategories
    food_category = Category.find_by(name: "Food")
    @food_subcategories = food_category ? food_category.children : []
  end

  # Load main categories for header menu
  def load_main_categories
    @main_categories = Category.where(parent_id: nil)
  end

  # Admin access check
  def check_admin
    redirect_to root_path, alert: "Access denied." unless current_user&.admin?
  end
end
