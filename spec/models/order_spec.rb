# spec/models/order_spec.rb
require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { create(:user) }
  let(:vendor) { create(:vendor) }
  let(:food1) { create(:food, price: 100, vendor: vendor) }
  let(:food2) { create(:food, price: 200, vendor: vendor) }

  let(:order) do
    create(:order, user: user).tap do |o|
      create(:order_item, order: o, food: food1, vendor: vendor, quantity: 2)
      create(:order_item, order: o, food: food2, vendor: vendor, quantity: 1)
    end
  end

  describe 'Order calculations' do
    it 'calculates total price correctly' do
      expected_total = (food1.price * 2) + (food2.price * 1)
      order.calculate_total!
      expect(order.total_price).to eq(expected_total)
    end
  end

  describe 'OrderItem calculations' do
    it 'calculates platform commission and vendor earnings correctly' do
      order.order_items.each(&:set_price_and_commissions)
      item = order.order_items.first
      expected_platform_commission = (item.price * 0.10).round(2)
      expected_vendor_earnings = item.price - expected_platform_commission

      expect(item.platform_commission).to eq(expected_platform_commission)
      expect(item.vendor_earnings).to eq(expected_vendor_earnings)
    end
  end

  describe 'VendorEarning creation' do
    it 'creates earnings for each order_item after payment' do
  # Setup order_items with proper commissions first
  order.order_items.each(&:set_price_and_commissions)

  # Mark order as paid (this triggers the callback)
  order.update!(status: :paid)

  order.reload

  # Now you can safely test vendor earnings
  order.order_items.each do |item|
    earning = item.vendor_earning
    expect(earning).not_to be_nil
    expect(earning.amount).to eq(item.vendor_earnings)
    expect(earning.status).to eq("pending")  # <- this should pass now
  end
end

  end

  describe 'Multi-vendor orders' do
    it 'assigns earnings to the correct vendor for each item' do
      vendor2 = create(:vendor)
      food3 = create(:food, price: 50, vendor: vendor2)
      create(:order_item, order: order, food: food3, vendor: vendor2, quantity: 1)

      order.update!(status: :paid)

      expect(order.order_items.find_by(vendor: vendor).vendor_earning.vendor).to eq(vendor)
      expect(order.order_items.find_by(vendor: vendor2).vendor_earning.vendor).to eq(vendor2)
    end
  end
end
