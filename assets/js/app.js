// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

import socket from "./socket"

let id = 0;
let name = '';
let channel;
let target = '';
// configurations
let config = document.getElementById("config");

// nearby
let nearby = document.querySelectorAll(".add_friend_btn");

// chat with friends
let ul = document.getElementById('msg-list');        // list of messages.
let msg = document.getElementById('msg');            // message input field
let friends = document.querySelectorAll(".list-group-item");

// chat with nearby
let nearby_ul = document.getElementById('nearby-msg-list');
let nearby_msg = document.getElementById('nearby_msg'); 

if(config) {
  console.log(">>>>>>>>> here we have current user, join channel");
  id = config.getAttribute("user_id");
  name = config.getAttribute("user_name");
  channel = socket.channel('popo:lobby', {id: id}); // connect to chat "popo"
  channel.join();
}


console.log("+++++++++++++++ check join channel");
channel.on('shout', function (payload) { // listen to the 'shout' event
    let li = document.createElement("li"); // create new list item DOM element
    let name = payload.name || 'guest';    // get name from payload or set default
    console.log(payload);
    li.innerHTML = "<b>" + name + "</b>: " + payload.message; // set li contents
    ul.appendChild(li);                    // append to list
  });

  channel.on('msg_history', function(payload) {
    console.log(">>>>>>>>> msg history in js");
    console.log(payload);
    let to = payload.to || 'unknown'
    document.getElementById("room-name").innerHTML = "Chat with " + to;
    let msg_list = payload.msg_list
    // ul.clean
    ul.innerHTML = '';
    // add msg
    if (msg_list) {
      msg_list.forEach(function(m) {
        let li = document.createElement("li");
        console.log(m.time);
        li.innerHTML = "<b>" + m.from + "</b>: " + m.content;
        ul.appendChild(li);
      })
    }
  });
  
  channel.on('add_friend', function(payload) {
    console.log(">>>>>>>>>>> channel on add friend");
    console.log(payload);
    let from_name = payload.from_name
    if (confirm("You have a new friend request from " + from_name)) {
      console.log("accept");
      channel.push("new_friends", {
        from: payload.from_id,
        to: payload.to,
        accept: true,
      });
    } else {
      console.log("decline");
      channel.push("new_friends", {
        from: payload.from_id,
        to: payload.to,
        accept: false,
      });
    }
  });
  
  channel.on("new_friends", function(payload) {
    let accept = payload.accept;
    console.log(">>>>>>>>>> js channel.on new_friends");
    console.log(payload);
    if (accept) {
      console.log("js channel on accept");
      window.alert("added");
      // add to friend list
    }
    else {
      console.log("js channel on decline");
      window.alert("declined");
    }
  });

  channel.on("friend_exists", function(payload) {
    console.log(">>>>>>>>>> js channel.on already exists");
    let resp = payload.msg;
    window.alert(resp);
  });

  channel.on('nearby_shout', function (payload) { // listen to the 'shout' event
    let li = document.createElement("li"); // create new list item DOM element
    let name = payload.name || 'guest';    // get name from payload or set default
    console.log(payload);
    li.innerHTML = "<b>" + name + "</b>: " + payload.message; // set li contents
    nearby_ul.appendChild(li);                    // append to list
  });

  channel.on('nearby_shout_first', function(payload) {
    if(payload.first) {
      window.alert("You've got a message from " + payload.name + ": " + payload.message + "\n" + "Click chat to start chatting.");
    }
  });
// let channel = socket.channel('popo:lobby', {id: id}); // connect to chat "popo"


// channel.join(); // join the channel.


// "listen" for the [Enter] keypress event to send a message:
if(msg) {
  msg.addEventListener('keypress', function (event) {
    if (event.keyCode == 13 && msg.value.length > 0) { // don't sent empty msg.
      console.log(">>>>>>> on press enter");
      console.log(target);
      channel.push('shout', { // send the message to the server on "shout" channel
        id: id,
        to: target,
        name: name,     // get value of "name" of person sending the message
        message: msg.value,    // get message text (value) from msg input field.
      });
      msg.value = '';         // reset the message input field for next message.
    }
  });
}

if(friends) {
  friends.forEach(function(friend) {
    friend.addEventListener('click', function() {
      msg.style.visibility = "visible";
      target = friend.getAttribute("id");
      console.log(target);
      channel.push('msg_history', {
        from: id,
        to: target,
      });
    });
  });
}

if(nearby) {
  nearby.forEach(function(near) {
    near.addEventListener('click', function() {
      
      let add_req_target = near.getAttribute("user_id");
      channel.push('add_friend', {
        from: id,
        to: add_req_target,
      });
    });
  });
}

if(nearby_msg) {
  nearby_msg.addEventListener('keypress', function (event) {
    let nearby_target = document.getElementById('nearby_chat_config').getAttribute('target');
    console.log(">>>>>>>>>>> nearby_target");
    console.log(nearby_target);
    if (event.keyCode == 13 && nearby_msg.value.length > 0) { // don't sent empty msg.
      console.log(">>>>>>>>>>>>> nearby_msg");
      console.log(nearby_ul.hasChildNodes());
      channel.push('nearby_shout', { // send the message to the server on "shout" channel
        id: id,
        to: nearby_target,
        name: name,     // get value of "name" of person sending the message
        message: nearby_msg.value,    // get message text (value) from msg input field.
        first: !nearby_ul.hasChildNodes()
      });
      nearby_msg.value = '';         // reset the message input field for next message.
    }
  });
}
