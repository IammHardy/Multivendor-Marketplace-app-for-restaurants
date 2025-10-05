class Admin::PromotionsController < Admin::BaseController
  before_action :set_promotion, only: [:edit, :update, :destroy]

  def index
    @promotions = Promotion.includes(:vendor, :food).order(created_at: :desc)
  end

  def edit; end

  def update
    if @promotion.update(promotion_params)
      redirect_to admin_promotions_path, notice: "Promotion updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @promotion.destroy
    redirect_to admin_promotions_path, notice: "Promotion deleted successfully!"
  end

  private

  def set_promotion
    @promotion = Promotion.find(params[:id])
  end

  def promotion_params
    params.require(:promotion).permit(:active, :starts_at, :ends_at, :title, :description, :cta_text, :cta_url, :image)
  end
end
