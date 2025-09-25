class Vendors::RegistrationsController < Devise::RegistrationsController
  layout "vendor"
  before_action :set_vendor, except: [:step1, :step1_create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # --- STEP 1: Account Information ---
  def step1
    @vendor = Vendor.new
  end

  def step1_create
    @vendor = Vendor.new(vendor_params_step1)
    @vendor.status = :pending_approval
    @vendor.validation_step = 1

    if @vendor.save
      session[:vendor_id] = @vendor.id
      redirect_to step2_vendor_registration_path
    else
      render :step1
    end
  end

  # --- STEP 2: Business Details ---
  def step2
    # Load vendor from session
  end

  def step2_update
    @vendor.validation_step = 2

    if @vendor.update(vendor_params_step2)
      redirect_to step3_vendor_registration_path
    else
      render :step2
    end
  end

  # --- STEP 3: Compliance & Verification ---
  def step3; end

  def step3_update
    @vendor.validation_step = 3

    if @vendor.update(vendor_params_step3)
      redirect_to step4_vendor_registration_path
    else
      render :step3
    end
  end

  def step4
  # Ensure @vendor is set by before_action or redirect
  unless @vendor&.persisted?
    redirect_to step1_vendor_registration_path, alert: "Please start registration from Step 1"
  end
end


 def step4_update
  # @vendor is already set by before_action :set_vendor
  @vendor.validation_step = 4

  if @vendor.update(vendor_params_step4)
    # Send pending approval email
    VendorMailer.with(vendor: @vendor).pending_approval_email.deliver_now
    VendorMailer.with(vendor: @vendor).new_vendor_notification.deliver_now
    redirect_to complete_vendor_registration_path
  else
    render :step4
  end
end

  # --- STEP 5: Completion ---
  def complete
    @vendor = Vendor.find(session[:vendor_id])
    session.delete(:vendor_id)
  end

  # --- AJAX Email Check ---
  def check_email
    exists = Vendor.exists?(email: params[:email])
    render json: { exists: exists }
  end

  private

def set_vendor
  @vendor = Vendor.find_by(id: session[:vendor_id])
  unless @vendor
    redirect_to step1_vendor_registration_path, alert: "Please start registration from Step 1"
  end
end


  # --- Strong Parameters ---
  def vendor_params_step1
    params.require(:vendor).permit(:name, :email, :password, :phone)
  end

  def vendor_params_step2
    params.require(:vendor).permit(:business_type, :contact_person, :address, :city, :state, :opening_hours)
  end

  def vendor_params_step3
    params.require(:vendor).permit(:cac_number, :bio, :whatsapp, :id_card)
  end

  def vendor_params_step4
    params.require(:vendor).permit(:bank_name, :account_name, :account_number, :payout_method, :profile_image, :banner_image)
  end

  protected

  def configure_permitted_parameters
    attrs = [:name, :email, :phone, :address, :contact_person, :business_type,
             :bio, :whatsapp, :bank_name, :account_name, :account_number,
             :payout_method, :city, :opening_hours, :cac_number, :id_card,
             :profile_image, :banner_image, :state]
    devise_parameter_sanitizer.permit(:sign_up, keys: attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: attrs)
  end
end
