function initMap(){
    map = new google.maps.Map(document.getElementById('map'),{
        center: {lat: 18.517597480689297, lng: 73.85736357448046},
        zoom: 18,
        mapId: '76139607a3c83f60'
    });

//18.517597480689297, 73.85736357448046

new google.maps.Marker({
    position: {lat: 18.49187728727935, lng: 73.83710753316682},
    map,
    title: "Friendship Garden",
    icon:{
        url:"images/zoo.png",
        scaledSize: new google.maps.Size(50, 50)
    }
  });
  new google.maps.Marker({
    // 18.47546266084185, 73.84291839162817
    position: {lat: 18.47546266084185, lng: 73.84291839162817},
    map,
    title: "Taljai Tekadi",
    icon:{
        url:"webapp/images/temple.png",
        scaledSize: new google.maps.Size(50, 50)
    }
  });

}