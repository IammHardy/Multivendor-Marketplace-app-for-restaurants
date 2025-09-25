class Admin::VendorsController < Admin::BaseController
  before_action :set_vendor, only: [:show, :edit, :update, :destroy, :approve, :reject]

  # List all vendors
  def index
    @vendors = Vendor.order(:created_at).page(params[:page]).per(10)
  end

 # app/controllers/admin/vendors_controller.rb
def approve
  @vendor = Vendor.find(params[:id])
  if @vendor.update(status: "active")  # or whatever attribute you use
    redirect_to admin_vendor_path(@vendor), notice: "Vendor approved successfully."
  else
    redirect_to admin_vendor_path(@vendor), alert: "Failed to approve vendor."
  end
end


  # Reject a vendor
  def reject
    if @vendor.update(status: :rejected)
      VendorMailer.with(vendor: @vendor).rejected_email.deliver_later
      flash[:alert] = "Vendor rejected and notified."
    else
      flash[:alert] = "Failed to reject vendor."
    end
    redirect_to admin_vendors_path
  end

  # Show vendor details
  def show
    @total_orders        = @vendor.order_items.select(:order_id).distinct.count
    @total_earnings      = @vendor.vendor_earnings.sum(:amount)
    @platform_commission = @vendor.vendor_earnings.sum(:platform_commission) rescue 0
    @recent_orders       = @vendor.order_items.includes(:order, :food).order(created_at: :desc).limit(10)
  end

  def new
    @vendor = Vendor.new
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      redirect_to admin_vendors_path, notice: "Vendor created successfully."
    else
      render :new
    end
  end

  def edit; end

  def update
    if @vendor.update(vendor_params)
      redirect_to admin_vendors_path, notice: "Vendor updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @vendor.destroy
    redirect_to admin_vendors_path, notice: "Vendor deleted successfully."
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:id])
  end

  def vendor_params
    params.require(:vendor).permit(
      :name, :email, :phone, :address, :contact_person,
      :business_type, :status, :city, :state
    )
  end
end
