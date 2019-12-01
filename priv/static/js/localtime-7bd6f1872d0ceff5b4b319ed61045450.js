document.body.onload = function() {localizeDateStr()};
function localizeDateStr() { 
    var utcstrs = document.getElementsByClassName("time");
    var i;
    for (i = 0; i < utcstrs.length; i++) {
        var res = utcstrs[i];
        var utcstr = res.getAttribute("value");
        var utcdate = new Date(utcstr);
        var localtime = new Date(Date.UTC(utcdate.getFullYear(), utcdate.getMonth(), utcdate.getDate(), utcdate.getHours(), 
        utcdate.getMinutes(), utcdate.getSeconds()))
        res.innerHTML=localtime.toLocaleString("en-US");
    }
} 