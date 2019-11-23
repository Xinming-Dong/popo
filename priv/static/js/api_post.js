
function showPosition() {
        if(navigator.geolocation) {
            navigator.geolocation.getCurrentPosition(function(position) {
                var positionInfo = "Got your current position!";	
		document.getElementById('latitude').value=position.coords.latitude;
		document.getElementById('longitude').value=position.coords.longitude;
                document.getElementById("result").innerHTML = positionInfo;
		    
            });
        } else {
            alert("Sorry, your browser does not support HTML5 geolocation.");
        }
    }
