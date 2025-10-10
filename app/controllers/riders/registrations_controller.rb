class Riders::RegistrationsController < Devise::RegistrationsController
  layout "rider"

  before_action :authenticate_rider!, except: [
    :step1, :step1_create, :step2, :step2_update,
    :step3, :step3_update, :step4, :step4_update,
    :complete
  ]
  before_action :set_rider, except: [:step1, :step1_create]
  before_action :configure_permitted_parameters, if: :devise_controller?


  def new
  redirect_to step1_rider_registration_path
end

  # === STEP 1: Account Info ===
  def step1
    @rider = Rider.new
  end

 def step1_create
  @rider = Rider.new(rider_params_step1)
  @rider.terms_accepted = true
  @rider.status = :pending
  @rider.validation_step = 1

  if @rider.save
    session[:rider_id] = @rider.id
    redirect_to step2_rider_registration_path
  else
    puts @rider.errors.full_messages
    render :step1, status: :unprocessable_entity
  end
end


  # === STEP 2: Vehicle Info ===
  def step2; end

  def step2_update
    @rider.validation_step = 2
    if @rider.update(rider_params_step2)
      redirect_to step3_rider_registration_path
    else
      puts @rider.errors.full_messages
      render :step2, status: :unprocessable_entity
    end
  end

  # === STEP 3: Banking Info ===
def step3; end

def step3_update
  @rider.validation_step = 3
  if @rider.update(rider_params_step3)
    redirect_to step4_rider_registration_path
  else
    render :step3, status: :unprocessable_entity
  end
end




  # === STEP 4: Verification (Uploads) ===
  def step4
    unless @rider&.persisted?
      redirect_to step1_rider_registration_path, alert: "Please start registration from Step 1"
    end
  end

  def step4_update
  @rider.validation_step = 4
  if @rider.update(rider_params_step4)
    # ✅ Send email notification to rider
    RiderMailer.with(rider: @rider).registration_complete.deliver_later

    # ✅ Optionally notify admin of new rider
    RiderMailer.with(rider: @rider).new_rider_notification.deliver_later

    redirect_to complete_rider_registration_path
  else
    render :step4, status: :unprocessable_entity
  end
end


  # === STEP 5: Completion ===
  def complete
    @rider = Rider.find_by(id: session[:rider_id])
    session.delete(:rider_id)
    redirect_to new_rider_session_path, notice: "Registration complete! Await admin approval." unless @rider
  end

  private

  def set_rider
    @rider = Rider.find_by(id: session[:rider_id])
    redirect_to step1_rider_registration_path, alert: "Please start from Step 1" unless @rider
  end

  # === Strong Parameters per step ===
  def rider_params_step1
    params.require(:rider).permit(:name, :email, :password, :password_confirmation, :phone, :terms_accepted)
  end

  def rider_params_step2
    params.require(:rider).permit(:vehicle_type, :license_plate)
  end

 def rider_params_step3
  params.require(:rider).permit(:address, :city, :state, :bank_name, :account_name, :account_number)
end

  def rider_params_step4
    params.require(:rider).permit(:photo, :id_card, :license_plate_image)
  end

  protected

  def configure_permitted_parameters
    attrs = [:name, :phone, :vehicle_type, :license_plate, :address, :photo, :id_card, :bank_name, :account_name, :account_number, :license_plate_image]
    devise_parameter_sanitizer.permit(:sign_up, keys: attrs)
    devise_parameter_sanitizer.permit(:account_update, keys: attrs)
  end
end
