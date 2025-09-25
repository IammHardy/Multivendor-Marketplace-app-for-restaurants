class VendorReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vendor

  def create
    @review = @vendor.vendor_reviews.build(review_params)
    @review.user = current_user

    if @review.save
      redirect_to vendor_path(@vendor), notice: "Review submitted successfully."
    else
      redirect_to vendor_path(@vendor), alert: @review.errors.full_messages.to_sentence
    end
  end

  private

  def set_vendor
    @vendor = Vendor.find(params[:vendor_id])
  end

  def review_params
    params.require(:vendor_review).permit(:rating, :comment)
  end
end
