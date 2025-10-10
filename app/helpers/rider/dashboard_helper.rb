module Rider::DashboardHelper
  def delivery_status_label(order)
    case order.delivery_status
    when "pending"
      content_tag(:span, "Pending", class: "text-yellow-600")
    when "assigned"
      content_tag(:span, "Accepted", class: "text-blue-600")
    when "picked_up"
      content_tag(:span, "In Progress", class: "text-orange-600")
    when "delivered"
      content_tag(:span, "Completed", class: "text-green-600")
    end
  end
end
