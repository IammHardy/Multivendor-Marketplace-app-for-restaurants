class AddApprovedToTestimonials < ActiveRecord::Migration[8.0]
  def change
    add_column :testimonials, :approved, :boolean, default: true
  end
end
