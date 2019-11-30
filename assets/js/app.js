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

let ul = document.getElementById('msg-list');        // list of messages.
let msg = document.getElementById('msg');            // message input field
let id = document.getElementById("chat_config").getAttribute("user_id");
let name = document.getElementById("chat_config").getAttribute("user_name");
let friends = document.querySelectorAll(".list-group-item");
let target = '';
console.log(id);
console.log(name)

let channel = socket.channel('popo:lobby', {id: id}); // connect to chat "popo"

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
})

channel.join(); // join the channel.


// "listen" for the [Enter] keypress event to send a message:
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

friends.forEach(function(friend) {
  friend.addEventListener('click', function() {
    msg.style.visibility = "visible";
    target = friend.getAttribute("id");
    console.log(target);
    channel.push('msg_history', {
      from: id,
      to: target,
    });
  })
})

