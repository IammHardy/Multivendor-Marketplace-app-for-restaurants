class Vendor::NotificationsController < Vendor::BaseController
  def index
    @notifications = []
     render layout: layout_for_turbo # placeholder until you connect real notifications
  end
end
