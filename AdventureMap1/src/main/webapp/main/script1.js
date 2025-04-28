let map, userMarker, infoWindow, userPosition;
let totalPoints = 0; // Track user points
let earnedBadge = ""; // Track earned badge

// Badge thresholds (in kilometers)
const BRONZE_THRESHOLD = 10;
const SILVER_THRESHOLD = 50;
const GOLD_THRESHOLD = 100;

// Function to calculate the distance between two locations (Haversine Formula)
function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Earth's radius in kilometers
    const dLat = deg2rad(lat2 - lat1);
    const dLon = deg2rad(lon2 - lon1);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
              Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
              Math.sin(dLon / 2) * Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c; // Distance in kilometers
    return distance;
}

// Convert degrees to radians
function deg2rad(deg) {
    return deg * (Math.PI / 180);
}

function initMap() {
    // Initialize the map with a default center location
    map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: 18.517597480689297, lng: 73.85736357448046 },
        zoom: 16
    });

    infoWindow = new google.maps.InfoWindow();

    // Check if geolocation is supported by the browser
    if (navigator.geolocation) {
        // Get the user's location
        navigator.geolocation.getCurrentPosition(
            (position) => {
                userPosition = {
                    lat: position.coords.latitude,
                    lng: position.coords.longitude
                };

                // Center the map on the user's location
                map.setCenter(userPosition);
                map.setZoom(14);

                // Place a marker at the user's location
                userMarker = new google.maps.Marker({
                    position: userPosition,
                    map: map,
                    title: "You are here"
                });
            },
            (error) => {
                console.error("Error getting user location:", error);
                handleLocationError(true, infoWindow, map.getCenter());
            }
        );
    } else {
        console.error("Geolocation is not supported by this browser.");
        handleLocationError(false, infoWindow, map.getCenter());
    }

    // Add a click event listener to the map
    map.addListener("click", function (event) {
        const clickedLocation = {
            lat: event.latLng.lat(),
            lng: event.latLng.lng()
        };

        if (userPosition) {
            // Calculate distance between user and clicked location
            const distance = calculateDistance(
                userPosition.lat,
                userPosition.lng,
                clickedLocation.lat,
                clickedLocation.lng
            );

            // Award badges based on distance
            awardBadge(distance);

            // Show points and badges in the InfoWindow
            infoWindow.setPosition(clickedLocation);
            infoWindow.setContent(
                `<div>
                    <strong>Clicked Location</strong><br>
                    Lat: ${clickedLocation.lat}<br>
                    Lng: ${clickedLocation.lng}<br>
                    Distance: ${distance.toFixed(2)} km<br>
                    Points: ${totalPoints}<br>
                    Badge: ${earnedBadge}
                </div>`
            );
            infoWindow.open(map);

            // Optionally, place a marker at the clicked location
            new google.maps.Marker({
                position: clickedLocation,
                map: map,
                title: "Clicked location"
            });

            // Update the badge and points in the HTML
            document.getElementById("totalPoints").innerText = totalPoints;
            document.getElementById("earnedBadge").innerText = earnedBadge;
        } else {
            alert("User location not found yet. Please wait.");
        }
    });

    // Example of predefined markers
    new google.maps.Marker({
        position: { lat: 18.49187728727935, lng: 73.83710753316682 },
        map: map,
        title: "Friendship Garden",
        icon: {
            url: "images/zoo.png",
            scaledSize: new google.maps.Size(50, 50)
        }
    });

    new google.maps.Marker({
        position: { lat: 18.47546266084185, lng: 73.84291839162817 },
        map: map,
        title: "Taljai Tekadi",
        icon: {
            url: "images/temple.png",
            scaledSize: new google.maps.Size(50, 50)
        }
    });

    new google.maps.Marker({
        position: { lat: 18.52051134666806, lng: 73.85495865351889 },
        map: map,
        title: "Shanivar Wada",
        icon: {
            url: "images/wada.png",
            scaledSize: new google.maps.Size(50, 50)
        }
    });
	
	/*18.5141341064613, 73.85375569558727*/
	
	new google.maps.Marker({
	        position: { lat: 18.5141341064613, lng: 73.85375569558727 },
	        map: map,
	        title: "Vishrambaug Wada",
	        icon: {
	            url: "images/vishrambagWada.jpeg",
	            scaledSize: new google.maps.Size(50, 50)
	        }
	    });
	

	
				
				//18.51067896864002, 73.85468401315754 kelkar sangralay
				
				new google.maps.Marker({
						        position: { lat: 18.51067896864002, lng: 73.85468401315754 },
						        map: map,
						        title: "kelkar sangralay",
						        icon: {
						            url: "images/tower-146734_1280.png",
						            scaledSize: new google.maps.Size(50, 50)
						        }
						    });
							
		    	//18.493422555065276, 73.85323223817572 Seven wonders
				
				new google.maps.Marker({
								position: { lat: 18.493422555065276, lng: 73.85323223817572 },
							    map: map,
							    title: "Seven Wonders",
								icon: {
								url: "images/sevenWonders.jpeg",
								scaledSize: new google.maps.Size(50, 50)
								}
							});

							
							//18.446456432964816, 73.86349609354293 katraj lake
							new google.maps.Marker({
								position: { lat: 18.446456432964816, lng: 73.86349609354293 },
								map: map,
								title: "Katraj lake",
								icon: {
								url: "images/brigdge.jpg",
								scaledSize: new google.maps.Size(50, 50)
								}
							});
							
							//18.41400798089387, 74.04937980787365 Malhar gad
							new google.maps.Marker({
								position: { lat: 18.41400798089387, lng: 74.04937980787365 },
								map: map,
								title: "Malhar gadha",
								icon: {
								url: "images/temple.png",
								scaledSize: new google.maps.Size(50, 50)
								}
							});
							
							//18.51644094772255, 73.85612936193124
							
							new google.maps.Marker({
								position: { lat: 18.51644094772255, lng: 73.85612936193124 },
								map: map,
								title: "Shrimant Dagdusheth Halwai Ganpati Mandir",
								icon: {
								url: "images/ganapti.jpg",
								scaledSize: new google.maps.Size(50, 50)
								}
									});
}

// Award badges based on the distance
function awardBadge(distance) {
    if (distance >= GOLD_THRESHOLD) {
        totalPoints += 100;
        earnedBadge = "Gold Badge";
    } else if (distance >= SILVER_THRESHOLD) {
        totalPoints += 50;
        earnedBadge = "Silver Badge";
    } else if (distance >= BRONZE_THRESHOLD) {
        totalPoints += 10;
        earnedBadge = "Bronze Badge";
    } else {
        totalPoints += 1; // Minor points for small distances
        earnedBadge = "No Badge";
    }
}

function handleLocationError(browserHasGeolocation, infoWindow, pos) {
    infoWindow.setPosition(pos);
    infoWindow.setContent(
        browserHasGeolocation
            ? "Error: The Geolocation service failed."
            : "Error: Your browser doesn't support geolocation."
    );
    infoWindow.open(map);
}







/*this is for quizes*/

// Slider functionality
let quizIndex = 0;
const quizzes = document.querySelectorAll('.quiz');
showQuiz(quizIndex);

function showQuiz(n) {
    quizzes.forEach((quiz, index) => {
        quiz.style.transform = `translateX(-${n * 100}%)`;
    });
}

function prevQuiz() {
    if (quizIndex > 0) {
        quizIndex--;
        showQuiz(quizIndex);
    }
}

function nextQuiz() {
    if (quizIndex < quizzes.length - 1) {
        quizIndex++;
        showQuiz(quizIndex);
    }
}

// Submit Quiz and Calculate Points
function submitQuizzes() {
    let totalPoints = 0;
    
    // Iterate through each quiz and sum the selected answer values
    quizzes.forEach(quiz => {
        const selected = quiz.querySelector('input[type="radio"]:checked');
        if (selected) {
            totalPoints += parseInt(selected.value);
        }
    });

    // Set points in session (or you can store it in the backend)
    document.getElementById('totalPoints').textContent = totalPoints;

    // Send points to the server (AJAX or form submission can be used here)
    alert(`You've earned ${totalPoints} points!`);

    // Update the points in game info section (you can extend this for server-side updates)
}


/*data storing in data base*/


function submitQuizzes() {
    let totalPoints = 0;
    quizzes.forEach(quiz => {
        const selected = quiz.querySelector('input[type="radio"]:checked');
        if (selected) {
            totalPoints += parseInt(selected.value);
        }
    });

    // Update points display
    document.getElementById('totalPoints').textContent = totalPoints;

    // Send points to server (replace URL with your backend handler)
    fetch('updatePoints.jsp', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: `points=${totalPoints}`
    }).then(response => response.text())
      .then(result => {
        alert(result);  // Show success or error message from the server
      })
      .catch(error => console.error('Error:', error));
}
