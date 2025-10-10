import consumer from "./consumer"

document.addEventListener("turbo:load", () => {
  document.querySelectorAll("[data-order-id]").forEach(el => {
    const orderId = el.dataset.orderId;

    consumer.subscriptions.create(
      { channel: "OrderStatusChannel", order_id: orderId },
      {
        received(data) {
          const statusEl = document.querySelector(`#order-status-${orderId}`);
          if(statusEl) {
            statusEl.textContent = data.status;
          }
        }
      }
    );
  });
});
