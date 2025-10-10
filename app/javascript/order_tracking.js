document.addEventListener("turbo:load", () => {
  const path = window.location.pathname;

  // ✅ Only run on /orders/:id or /orders/:id/track
  if (!/^\/orders\/\d+(\/track)?$/.test(path)) return;

  const mapContainer = document.getElementById("map");
  if (!mapContainer) return;

  // ✅ Cleanup before initializing
  if (window._riderInterval) clearInterval(window._riderInterval);
  if (window._leafletMap) {
    window._leafletMap.remove();
    window._leafletMap = null;
  }

  mapContainer.innerHTML = "";
  delete mapContainer._leaflet_id;

  if (typeof L === "undefined") {
    console.error("❌ Leaflet (L) is not defined — check imports in application.js");
    return;
  }

  // ✅ Initialize map
  const map = L.map(mapContainer).setView([9.0765, 7.3986], 13);
  window._leafletMap = map;

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 19,
    attribution: "&copy; OpenStreetMap contributors",
  }).addTo(map);

  // --- Icons ---
  const riderIcon = L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/2972/2972185.png",
    iconSize: [40, 40],
    iconAnchor: [20, 40],
  });

  const pickupIcon = L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/190/190411.png", // 🏪 Restaurant
    iconSize: [35, 35],
    iconAnchor: [17, 35],
  });

  const destinationIcon = L.icon({
    iconUrl: "https://cdn-icons-png.flaticon.com/512/684/684908.png", // 🏠 Customer
    iconSize: [35, 35],
    iconAnchor: [17, 35],
  });

  let riderMarker = null;
  let pickupMarker = null;
  let destinationMarker = null;
  let routeLine = null;

  async function fetchRiderLocation() {
    try {
      const orderId = path.match(/\d+/)[0];
      const res = await fetch(`/orders/${orderId}/track.json`);
      if (!res.ok) throw new Error(`HTTP ${res.status}`);

      const data = await res.json();

      // --- Update order status with colors ---
      const statusEl = document.getElementById("status");
      if (statusEl && data.status) {
        let color = "text-gray-600";
        if (data.status === "delivered") color = "text-green-600";
        else if (data.status === "on_the_way") color = "text-yellow-500";
        else if (data.status === "pending") color = "text-red-500";

        statusEl.className = color + " font-semibold";
        statusEl.textContent = data.status.replace(/_/g, " ").toUpperCase();
      }

      // --- Draw pickup + destination markers ---
      if (data.pickup_lat && data.pickup_lng && !pickupMarker) {
        pickupMarker = L.marker([data.pickup_lat, data.pickup_lng], { icon: pickupIcon })
          .addTo(map)
          .bindPopup("Restaurant Pickup");
      }

      if (data.destination_lat && data.destination_lng && !destinationMarker) {
        destinationMarker = L.marker([data.destination_lat, data.destination_lng], { icon: destinationIcon })
          .addTo(map)
          .bindPopup("Customer Destination");
      }

      // --- Rider live tracking ---
      if (data.lat && data.lng) {
        const lat = parseFloat(data.lat);
        const lng = parseFloat(data.lng);

        if (!riderMarker) {
          riderMarker = L.marker([lat, lng], { icon: riderIcon }).addTo(map);
          map.fitBounds(
            [
              [data.pickup_lat, data.pickup_lng],
              [data.destination_lat, data.destination_lng],
            ],
            { padding: [50, 50] }
          );
        } else {
          const oldPos = riderMarker.getLatLng();
          const newPos = L.latLng(lat, lng);
          const stepCount = 20;
          let step = 0;
          const move = setInterval(() => {
            step++;
            const interpLat = oldPos.lat + (newPos.lat - oldPos.lat) * (step / stepCount);
            const interpLng = oldPos.lng + (newPos.lng - oldPos.lng) * (step / stepCount);
            riderMarker.setLatLng([interpLat, interpLng]);
            if (step >= stepCount) clearInterval(move);
          }, 100);
        }
      }

      // --- Draw or update route line ---
      if (pickupMarker && destinationMarker && riderMarker) {
        const routeCoords = [
          pickupMarker.getLatLng(),
          riderMarker.getLatLng(),
          destinationMarker.getLatLng(),
        ];

        if (routeLine) {
          routeLine.setLatLngs(routeCoords);
        } else {
          routeLine = L.polyline(routeCoords, { color: "#FF6B00", weight: 4, opacity: 0.7 }).addTo(map);
        }
      }
    } catch (err) {
      console.error("🚨 Error fetching rider location:", err);
    }
  }

  // ✅ Initial + interval updates
  fetchRiderLocation();
  window._riderInterval = setInterval(fetchRiderLocation, 5000);
});

// ✅ Cleanup before Turbo caches the page
document.addEventListener("turbo:before-cache", () => {
  if (window._leafletMap) {
    window._leafletMap.remove();
    window._leafletMap = null;
  }
  if (window._riderInterval) {
    clearInterval(window._riderInterval);
    window._riderInterval = null;
  }
});
