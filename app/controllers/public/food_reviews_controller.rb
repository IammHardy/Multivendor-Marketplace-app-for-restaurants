class Public::FoodReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @food = Food.friendly.find(params[:food_id]) # or Food.find(params[:food_id]) if no friendly_id
    @review = @food.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to public_food_path(@food), notice: "Review submitted successfully."
    else
      redirect_to public_food_path(@food), alert: @review.errors.full_messages.join(", ")
    end
  end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
