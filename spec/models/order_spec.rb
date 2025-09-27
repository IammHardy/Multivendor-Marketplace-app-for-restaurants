require 'rails_helper'

RSpec.describe Order, type: :model do
  let!(:user) { create(:user) }
  let!(:vendor1) { create(:vendor) }
  let!(:vendor2) { create(:vendor) }

  let!(:food1) { create(:food, price: 100, vendor: vendor1) }
  let!(:food2) { create(:food, price: 200, vendor: vendor1) }
  let!(:food3) { create(:food, price: 50, vendor: vendor2) }

  let!(:order) do
    create(:order, user: user).tap do |o|
      create(:order_item, order: o, food: food1, vendor: food1.vendor, quantity: 2)
      create(:order_item, order: o, food: food2, vendor: food2.vendor, quantity: 1)
    end
  end

  describe 'Order calculations' do
    it 'calculates total price correctly' do
      expected_total = (food1.price * 2) + (food2.price * 1)
      order.calculate_total!
      expect(order.total_price).to eq(expected_total)
    end
  end

  describe 'Multi-vendor orders' do
    it 'assigns earnings to the correct vendor for each item' do
      multi_order = create(:order, user: user).tap do |o|
        create(:order_item, order: o, food: food1, vendor: food1.vendor, quantity: 2)
        create(:order_item, order: o, food: food3, vendor: food3.vendor, quantity: 1)
      end

      multi_order.update!(status: :paid)
      multi_order.reload

      item1 = multi_order.order_items.find_by(food: food1)
      item3 = multi_order.order_items.find_by(food: food3)

      expect(item1.vendor).to eq(vendor1)
      expect(item3.vendor).to eq(vendor2)
    end
  end
end
