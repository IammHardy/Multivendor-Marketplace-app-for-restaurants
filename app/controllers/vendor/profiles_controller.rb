# app/controllers/vendor/profiles_controller.rb
class Vendor::ProfilesController < Vendor::BaseController
  before_action :authenticate_vendor!

  def edit
    @vendor = current_vendor
  end

  def update
    @vendor = current_vendor
    if @vendor.update(vendor_params)
      redirect_to edit_vendor_profile_path, notice: "Profile updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_password
    @vendor = current_vendor
    if @vendor.update_with_password(password_params)
      # Sign in again to update session
      bypass_sign_in(@vendor)
      redirect_to edit_vendor_profile_path, notice: "Password updated successfully!"
    else
      flash.now[:alert] = "Password update failed"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(:name, :phone, :address, :bio, :profile_image, :banner_image, :id_card, :bank_name, :account_name, :account_number, :city, :state, :business_type, :opening_hours, :payout_method, :cac_number)
  end

  def password_params
    params.require(:vendor).permit(:current_password, :password, :password_confirmation)
  end
end
