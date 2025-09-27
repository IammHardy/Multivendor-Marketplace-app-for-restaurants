# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :authenticate_user!  # if using Devise

  def new
    @food = Food.find(params[:food_id])
    @review = @food.reviews.build
  end

  def create
  @food = Food.friendly.find(params[:food_id])  # Use friendly find
  @review = @food.reviews.build(review_params)
  @review.user = current_user

  if @review.save
    redirect_to @food, notice: "Review added!"
  else
    render :new
  end
end

  private

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
