let map;

function initMap() {
    // Initialize the map with a default center location
    map = new google.maps.Map(document.getElementById("map"), {
        center: { lat: 18.517597480689297, lng: 73.85736357448046 },
        zoom: 12,
    });

    // Fetch location data from the server
    fetch("getLocations.jsp")
        .then((response) => response.json())
        .then((locations) => {
            // Add a marker for each location
            locations.forEach((location) => {
                const marker = new google.maps.Marker({
                    position: { lat: location.lat, lng: location.lng },
                    map: map,
                    title: location.title,
                });

                // Create an InfoWindow for each marker
                const infoWindow = new google.maps.InfoWindow({
                    content: `<h3>${location.title}</h3><p>${location.description}</p>`,
                });

                // Add click event to show InfoWindow on marker click
                marker.addListener("click", () => {
                    infoWindow.open(map, marker);
                });
            });
        })
        .catch((error) => console.error("Error fetching locations:", error));
}
