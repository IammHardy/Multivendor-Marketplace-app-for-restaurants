class Vendors::RegistrationsController < Devise::RegistrationsController
  layout "vendor"

  before_action :authenticate_vendor!, except: [
    :step1, :step1_create, :step2, :step2_update,
    :step3, :step3_update, :step4, :step4_update,
    :complete, :check_email
  ]
  before_action :set_vendor, except: [:step1, :step1_create]
  before_action :configure_permitted_parameters, if: :devise_controller?

  # === STEP 1: Account Information ===
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
      render :step1, status: :unprocessable_entity
    end
  end

  # === STEP 2: Business Details ===
  def step2; end

  def step2_update
    @vendor.validation_step = 2
    if @vendor.update(vendor_params_step2)
      redirect_to step3_vendor_registration_path
    else
      render :step2, status: :unprocessable_entity
    end
  end

  # === STEP 3: Compliance & Verification ===
  def step3; end

  def step3_update
    @vendor.validation_step = 3
    if @vendor.update(vendor_params_step3)
      redirect_to step4_vendor_registration_path
    else
      render :step3, status: :unprocessable_entity
    end
  end

  # === STEP 4: Payout Setup ===
  def step4
    unless @vendor&.persisted?
      redirect_to step1_vendor_registration_path, alert: "Please start registration from Step 1"
    end
  end

  def step4_update
    @vendor.validation_step = 4
    if @vendor.update(vendor_params_step4)
      # Send notifications
      VendorMailer.with(vendor: @vendor).pending_approval_email.deliver_later
      VendorMailer.with(vendor: @vendor).new_vendor_notification.deliver_later
      redirect_to complete_vendor_registration_path
    else
      render :step4, status: :unprocessable_entity
    end
  end

  # === STEP 5: Completion ===
  def complete
    @vendor = Vendor.find_by(id: session[:vendor_id])
    session.delete(:vendor_id)
    redirect_to new_vendor_session_path, notice: "Registration completed. Awaiting approval." unless @vendor
  end

  # === AJAX Email Check ===
  def check_email
    exists = Vendor.exists?(email: params[:email])
    render json: { exists: exists }
  end

  private

  # === Helpers ===
  def set_vendor
    @vendor = Vendor.find_by(id: session[:vendor_id])
    redirect_to step1_vendor_registration_path, alert: "Please start registration from Step 1" unless @vendor
  end

  # === Strong Parameters per step ===
  def vendor_params_step1
    params.require(:vendor).permit(:name, :email, :password, :password_confirmation, :phone)
  end

  def vendor_params_step2
    params.require(:vendor).permit(:business_type, :contact_person, :address, :city, :state, :opening_hours)
  end

  def vendor_params_step3
    params.require(:vendor).permit(:cac_number, :bio, :whatsapp, :id_card)
  end

  def vendor_params_step4
    params.require(:vendor).permit(
      :bank_name, :account_name, :account_number,
      :payout_method, :profile_image, :banner_image
    )
  end

  protected

  def configure_permitted_parameters
    attrs = [
      :name, :email, :phone, :address, :contact_person,
      :business_type, :bio, :whatsapp, :bank_name,
      :account_name, :account_number, :payout_method,
      :city, :opening_hours, :cac_number, :id_card,
      :profile_image, :banner_image, :state
    ]

    devise_parameter_sanitizer.permit(:sign_up, keys: attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: attrs)
  end
end
