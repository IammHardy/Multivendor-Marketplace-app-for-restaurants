namespace :backfill do
  desc "Fill vendor_id in order_items from food"
  task order_items: :environment do
    OrderItem.find_each do |item|
      if item.food&.vendor_id
        item.update_columns(vendor_id: item.food.vendor_id) # skips validations
      end
    end
    puts "✅ Backfill complete!"
  end
end
