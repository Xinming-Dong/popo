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
            });
        } else {
            alert("Sorry, your browser does not support HTML5 geolocation.");
        }
    }
document.forms[0].submit();
