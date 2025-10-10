class Admin::RidersController < Admin::BaseController

 
 before_action :set_rider, only: [:show, :approve, :reject, :suspend, :unsuspend, :verify, :unverify, :destroy]


  def index
    @riders = Rider.order(created_at: :desc)
  end

 def show
  @rider = Rider.find(params[:id])
end


  def approve
    @rider.active!
    RiderMailer.with(rider: @rider).account_approved.deliver_later
    redirect_to admin_riders_path, notice: "Rider approved successfully."
  end

  def reject
    @rider.rejected!
    RiderMailer.with(rider: @rider).account_rejected.deliver_later
    redirect_to admin_riders_path, alert: "Rider has been rejected."
  end

  def verify
  @rider = Rider.find(params[:id])
  @rider.update(verified: true)
    RiderMailer.with(rider: @rider).account_verified.deliver_later

  redirect_to admin_rider_path(@rider), notice: "Rider verified successfully."
end

def unverify
  @rider.update(verified: false)
    RiderMailer.with(rider: @rider).account_unverified.deliver_later
  redirect_to admin_riders_path, alert: "Rider has been unverified."
end


def suspend
  @rider.suspended!
  redirect_to admin_riders_path, alert: "Rider has been suspended."
end

def unsuspend
  @rider.active!
  redirect_to admin_riders_path, notice: "Rider unsuspended successfully."
end

def destroy
  @rider = Rider.find(params[:id])
  @rider.destroy
  redirect_to admin_riders_path, alert: "Rider has been deleted successfully."
end

  private

  def set_rider
    @rider = Rider.find(params[:id])
  end
end
