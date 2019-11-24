var latitude;
var longtitude;

function getLongtitude(){
	return longtitude;
}

function getLatitude(){
	return latitude;
}

document.body.onload = function() {showPosition()};
function showPosition() {
        if(navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var positionInfo = "Your current position is (" + "Latitude: " + position.coords.latitude + ", " + "Longitude: " + position.coords.longitude + ")";	
		document.getElementById('latitude').value=position.coords.latitude;
		document.getElementById('longitude').value=position.coords.longitude;
                document.getElementById("result").innerHTML = positionInfo;
		var latlon = position.coords.latitude + "," + position.coords.longitude;

  var img_url = "https://maps.googleapis.com/maps/api/staticmap?center="+latlon+"&zoom=15&size=600x300&sensor=false&key=AIzaSyBD687lI9Zy6weGMG3JV4F0tjPd63QxfyU";

  document.getElementById("mapholder").innerHTML = "<img src='"+img_url+"'>";
            });
        } else {
            alert("Sorry, your browser does not support HTML5 geolocation.");
        }
    }
