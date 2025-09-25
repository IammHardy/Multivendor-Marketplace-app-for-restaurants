# app/controllers/vendor/profiles_controller.rb
class Vendor::ProfilesController < Vendor::BaseController
  before_action :authenticate_vendor!

  def edit
    @vendor = current_vendor
  end

  def update
    @vendor = current_vendor
    if @vendor.update(vendor_params)
      redirect_to vendor_dashboard_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def vendor_params
    params.require(:vendor).permit(
      :name, :phone, :address, :bio, :profile_image, :banner_image, :id_card,
      :city, :state, :opening_hours, :business_type, :cac_number, :contact_person
    )
  end
end
