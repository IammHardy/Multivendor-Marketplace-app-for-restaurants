class Vendor::PromotionsController < Vendor::BaseController
  before_action :set_promotion, only: [:edit, :update, :destroy]

  def index
    @promotions = current_vendor.promotions.order(created_at: :desc)
  end

#  def new
#   @promotion = current_vendor.promotions.new
#   @promotion.cta_url ||= vendor_foods_path # or whatever path shows their menu

  def new
  @promotion = current_vendor.promotions.new
  @promotion.cta_url ||= public_vendor_path(current_vendor.slug)
end




  def create
    @promotion = current_vendor.promotions.new(promotion_params)
    if @promotion.save
      redirect_to vendor_promotions_path, notice: "Promotion created successfully!"

    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

 def update
  if @promotion.update(promotion_params)
    redirect_to vendor_promotions_path, notice: "Promotion updated successfully!"
  else
    render :edit, status: :unprocessable_entity
  end
end

def toggle_status
  @promotion = current_vendor.promotions.find(params[:id])
  @promotion.update(active: !@promotion.active)
  redirect_to vendor_promotions_path, notice: "Promotion status updated."
end


  def destroy
    @promotion.destroy
    redirect_to vendor_promotions_path, notice: "Promotion deleted successfully!"
  end

  private

  def set_promotion
    @promotion = current_vendor.promotions.find(params[:id])
  end

  def promotion_params
    params.require(:promotion).permit(
      :title, :description, :image, :cta_text, :cta_url,
      :starts_at, :ends_at, :active, :food_id
    )
  end
end
