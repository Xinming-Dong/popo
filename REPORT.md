# Popo - Location Based Chat and Life-Sharing Application


# 1 Introduction and App Description

Popo is a chatting and life-sharing application focusing on location-based
social interaction with strangers. This application allows you to find nearby
users and starting a chat with them. Users are allowed to send messages to any
user visible in the nearby areas(of 800 meter radius). If they enjoy the chat,
they are able to send/accept friend requests and become friends. If two users
did not become friends before one of them leave the nearby area or log out, they
will not be visible to each other anymore. If they become friends, they are able
to chat to each other at any place. The design idea of Popo is to encourage
stranger interaction and find interesting people around you. 

Popo also support location based life-sharing posts. Users are able to post
their thoughts and pictures, and add the name of a certain nearby locations as a
tag to the post. When creating a new post, popo will obtain users’ locations and
provides a list of options of nearby locations for the users to choose from.
These locations includes points of interests such as restaurants and landmarks.
Different levels of administrative regions are also included in the options of
locations if the user prefer a vaguer location. Users are also able to see all
the posts of a certain location, and all the posts sent by the nearby users. 

 As the basic functionalities, Popo also supports user registration and login
 with email and password. Users can also upload a picture as their personal
 profile. 

The server side logic of this application was built using Elixir and Phoenix
template, and the client side was built using Javascript. We also used Postgres
database to store the user account info, posts and messages. The browser side
location service is provided by the HTML5 Geolocation API, and the server side
location services are provided by Google MAP API, Google Geocode API and Google
MAP Places API. 


# 2 Features


## 2.1 Required features:

2.1.1 Password and authentication


User accounts are stored in the Postgres database with name, email and hashed
password for the purpose of local authentication. Passwords are hashed using
Argon2 to provide more security. 

2.1.2 Postgres database design

Items stored in the postgres database include:


*   User: name, email, password, location coordinate
*   Profile: has one to one relationship with user, including date of birth,
    gender, self introduction and profile picture. All the fields are optional. 
*   Friend: store many to many relationships of users
*   Message: content, from(user_id), to(user_id)
*   Post: text description, picture, location coordinates, location name, all
    fields are optional. 

2.1.3 Server side External API calls


In order to show current user and nearby users’ locations on a map, the POPO
application makes server side calls to the Google Static Map API. This call
returns an image of the google map centered at user’s current location, which
includes marks of current and nearby users’ locations. 


Moreover, the server makes calls to the Google Geocode API and Google Places API
using the store coordinates of the user. Calls to the Google Reverse Geocode API
return lists of addresses of the coordinates, which includes the name of
administrative regions of user’s location. Calls to the Google Places API return
lists of names of nearby points of interests. The radius is set to 200 meters as
initial value, and if got no result, the radius will increase iteratively until
at least 3 results are returned. The maximum radius are 20 kilometres. This
strategy ensures the user could have a reasonable number of locations to choose
from, no matter if they are at dense urban areas or sparse rural regions. 
    	

2.2 Additional Features:

2.2.1 Using Phoenix Channels to implement real-time chat


Popo allows real-time chatting and add friends, which are accomplished by
Phoenix Channels. When users arrives chat page, they can choose a friend to chat
with, while when they are in nearby user page, they can either make requests to
add friends or chat with strangers. Triggered by users requests, the browser
will notify their target users with message boxes. 

	

2.2.2 Do something interesting with the HTML5 geolocation API


As a location based application, Popo use the HTML5 Geolocation API to get the
current location of the user from the browser side. This location is then stored
in the database through the Phoenix form template as the user location
coordinates. This location will only be updated when the user start a search of
nearby person, or when they start to create a new post.


2.2.3 Using HTTPosion and Poison Elixir Library


For the purpose of access the external API from the server side, we utilized the
HTTPoison library to send HTTP request and get responses. Moreover, Poison
library is used to decode the JSON responses received from the external API. 

2.3 Beyond Project Requirements

2.3.1 Migrating from Http to Https


During the process of testing the application, we realize that the HTML5
geolocation API no longer works on the insecure origins. Therefore, we need to
migrate the Http to Https, which is a secure version of the HTTP protocol. Https
can protect the data transfer between browser and server by encrypting it using
an SSL(Secure Sockets Layer) Certificat. 


In order to do so, we installed the “Let’s Encrypt”(a free SSL certificate
service) in our server and add the certificate to our application’s domain. 


2.3.2 Showing Posts in local time


When posts are created and added to the database, the created time are also
stored in the database. However, it is stored as the UTC time for the
unification purpose. When showing the posts timestamp in the browser, we
implemented the functionality that allow it shows as the user’s local time. 


# 3 Complex Parts and Challenges

3.1 Real Time chatting with Strangers


As for channel, we choose to put all users in the same channel, and intercept
messages every time when a message needs to be sent to some specific users.
Moreover, to distinguish different users, we assign a user id to each of the
sockets when joining the channel.


For better chatting-with-stranger experience, Popo will notify the chosen
stranger with a message box when the first message is sent. This requires the
browser and channel to distinguish the first chatting message with others. In
JavaScript, we just check whether there is any content in the chat area. And in
the Phoenix Channel, we send a flag which tells whether this is the first chat
message from JavaScript as part of payload to channel functions. Then the
channel function will push different message back to clients.

3.2 Adding Friends


When users make requests to add friends with strangers, this application
provides the two users a way to communicate back and forth. Firstly, A user can
send an application to another one by clicking the add button. Then, the target
user will receive a confirmation window, where they can agree or disagree with
the request. Lastly, the user who sent the application will see the result in a
message box.


There are mainly two challenges. One is that the server has to make sure whether
the two users are friends or not, and the other is judging whether the pair of
users should be added to the database for future reference according to user’s
response.


For the first one, the Phoenix Channel delivers different messages according to
different search results in friend pairs table. Then, every user attached to the
channel intercepts the outgoing messages, fetching their own response. If the
browser gets a “friend exists”, which means the users are already friends and
the message is sent back to the user who make request, a message box will prompt
and no further response will be made, while if the browser gets a “add friend”,
which means the two users are not friends and the message is intercepted by the
targeted user, a confirmation box will prompt out. 


As for the second challenge, we add an attribute “accept” to the payload sent to
Phoenix Channel according to which button the target user clicked in the
confirmation box. Therefore the Phoenix Channel apply changes to “Friends” table
in the database according to payload attributes, and simply broadcast the
message, then the user who made the application intercept the message and show
messages accordingly in the browser.

3.3 Obtaining Nearby Places when Creating Posts


One of the features we want to provide is having a list of names of the nearby
places for the user to choose from when they are creating a new post. This
functionality requires several steps. Firstly, it requires a browser call to the
HTML5 Geolocation to get user’s current coordinate. Secondly, it requires
sending this coordinate information to the server. Thirdly, it requires the
server to use this coordinate to send an HTTP request to the Google API, and get
the nearby place names. Lastly, it requires the server to show these place names
as options in the create post page. 


The challenge is that the Phoenix template is static, therefore, in order to
have the options of places shown in the create post page, we should already have
the coordinate information by the time the create post page is rendered. 


Therefore, we need to render a page to get the coordinate after user clicks
“create new post” and before the actual create post page is rendered. Also, this
intermediate page should be invisible to the user. 


To achieve this, after user clicks the “create new post” link, they are direct
to a phoenix form template which update the User table in the database. It only
updates the longitude and latitude of the current user. This form template is
auto filled and submit by javascript functions using the current location
information received from the HTML5 Geolocation API, and current user’s
coordinate is updated in the database. Then the server side use this information
stored in the database to get the place list and the user is directed to the
create post page rendered with this list. Since the first page needs no action
from the user, has no visible elements, and will auto redirect after form is
auto submitted, so from the user’s view, this page does not exist. User will
experience a small delay before they reach the create post page. 

3.4  Render Google Map API response as image


After getting the user's current location by HTML5 Geolocation, all the nearby
users can be obtained as a result of a query in database. In addition to listing
all the nearby users, we intend to visualize the locations of them on a map. 


We utilize Google Map API to achieve it. It is called in the server side with
the help of the library HTTPoison to issue the request, passing all the users’
locations to the API. The image in binary string of the google map centered at
the user’s current location is returned as the response. It also includes marks
of the current and nearby users’ locations. To render it in html page, the
binary string of the image need to be encoded into base64 by Base.encode64, and
embedded into data URI “data:image/png;base64,...”

3.5 UI/UX Design


We should consider how to design a simple but effective UI/UX minimizes the risk
that our project will not be used by Users because they do not see any value in
it or cannot figure out how to use even if they wanted to use it.

	


# 4 Meta Information



*   Who was on your team?

    Xinming Dong, Weihan Liu, Chihao Sun, Rouni Yin

*   What’s the URL of your deployed app?

    popo.weihanliu.space 


    popo.elephantdong.com


    popo.yrn95.fun


    popo.mrchs0119.fun

*   What’s the URL of your github repository with the code for your deployed app?

    https://github.com/Xinming-Dong/popo

*   Is your app deployed and working?

    Yes.

*   For each team member, what work did that person do on the project?

    Xinming Dong: 


    Weihan Liu: Complete post related functionalities, participated in writing report and deployment. 


    Rouni Yin: Complete user related functionalities, and participate in writing report and slides.


    Chihao Sun: Complete design and implementation of UI and participate in writing report.



