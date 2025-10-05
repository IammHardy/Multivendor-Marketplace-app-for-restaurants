class Public::VendorReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @vendor = Vendor.friendly.find(params[:vendor_id])
    @review = @vendor.vendor_reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to public_vendor_path(@vendor), notice: "Review submitted successfully."
    else
      redirect_to public_vendor_path(@vendor), alert: @review.errors.full_messages.join(", ")
    end
  end

  private

  def review_params
    params.require(:vendor_review).permit(:rating, :comment)
  end
end
