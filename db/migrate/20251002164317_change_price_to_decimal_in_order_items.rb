class ChangePriceToDecimalInOrderItems < ActiveRecord::Migration[8.0]
  def change
    change_column :order_items, :price, :decimal, precision: 10, scale: 2
  end
end
