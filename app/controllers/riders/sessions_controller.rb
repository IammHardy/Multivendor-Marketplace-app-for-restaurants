class Riders::SessionsController < Devise::SessionsController
  layout "rider"

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)

    # Redirect to rider dashboard
    respond_with resource, location: rider_dashboard_path
  end
end
