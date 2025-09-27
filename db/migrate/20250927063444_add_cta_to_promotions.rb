class AddCtaToPromotions < ActiveRecord::Migration[8.0]
  def change
    add_column :promotions, :cta_text, :string
    add_column :promotions, :cta_url, :string
  end
end
