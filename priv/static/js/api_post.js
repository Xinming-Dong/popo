document.body.onload = function() {showPosition()};



function showPosition() {
        if(navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var positionInfo = "Got your current position!";	
		document.getElementById('latitude').value=position.coords.latitude;
		document.getElementById('longitude').value=position.coords.longitude;
                // document.getElementById("result").innerHTML = positionInfo;
        document.getElementById('lat').value = "<% var lat = position.coords.latitude %>";
		    
            });
        } else {
            alert("Sorry, your browser does not support HTML5 geolocation.");
        }
}

// function getLongtitude(){
//     if(navigator.geolocation) {
//         position = navigator.geolocation.getCurrentPosition;
//         return position.coords.longitude;
//     } else {
//         return null;
//     }
// }
    
// function getLatitude(){
//     if(navigator.geolocation) {
//         position = navigator.geolocation.getCurrentPosition;
//         return position.coords.latitude;
//     } else {
//         return null;
//     }
        
// }

// function getLocations() {
//     if(navigator.geolocation) {
//         navigator.geolocation.getCurrentPosition(function(position) {
//             latlng1 = position.coords.latitude.toString()+","+position.coords.longitude.toString();
        
        
//         axios.get('/posts/locations/'+ latlng1)
//         .then(function (response) {
//             if(response.statusText === "OK") {
//                 locations = response.data.locations;
//                 text = '<%= select f, :location, [';
//                 len = locations.length
//                 for(i = 0; i < len - 1; i++) {
//                     l  = locations[i];
//                     text += "\"" + l + "\"" + ","
//                 }
//                 text += "\""+locations[len -1] +"\""+ '] %>'
                
//                 document.getElementById("locations").innerHTML = text
//             }
//         });
//     });
//     } else {
//         console.log("no")
//     }
// }
