
# AroundHear

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)


## Sprint 4
Be able to chat with users in your radious                    |Be able to see the sond tittle of what other users are listening in your set radius       |Be able to click on a user in your set radius and listen to whatever they are listening to currently or access their profile      
:------------------------------------------------------------:|:---------------------------------------------------------:|-----------------------------------------------------------:
<img src="http://g.recordit.co/B9UnJckTjf.gif" width=250><br> | <img src="https://imgur.com/nHF3Un1.gif" width=250><br> | <img src="https://i.imgur.com/EtNyQbw.png" width=250><br> 


## Sprint 3
See list of users in your radius                             |Spotify Playlist       |User Story here      
:------------------------------------------------------------:|:---------------------------------------------------------:|-----------------------------------------------------------:
<img src="http://g.recordit.co/OiRa2h0Gcb.gif" width=250><br> | <img src="https://imgur.com/nHF3Un1.gif" width=250><br> | <img src="https://i.imgur.com/EtNyQbw.png" width=250><br> 



## Sprint 2
Get user location from GPS                                    |Edit and view profile       |Spotify API         
:------------------------------------------------------------:|:---------------------------------------------------------:|-----------------------------------------------------------:
<img src="http://g.recordit.co/80NKwhAlQG.gif" width=250><br> | <img src="https://i.imgur.com/lcgaunk.gif" width=250><br> | <img src="https://i.imgur.com/N46w2yC.jpg" width=250><br> 



## Sprint 1
Sign Up & Sign Out                                            |Sign In       |Spotify API         
:------------------------------------------------------------:|:---------------------------------------------------------:|-----------------------------------------------------------:
<img src="http://g.recordit.co/nrAeEm7utZ.gif" width=250><br> | <img src="http://g.recordit.co/XwGI83krFB.gif" width=250><br> | <img src="https://i.imgur.com/c4hun8Z.gif" width=250><br> 



## Overview
### Description
A music social media app that lets users listen to what other users are currently listening to based on proximity.

### App Evaluation

- **Category:** 
  - Music
  - Entertainment
- **Mobile:**
  - Is location based
  - Uses a map
  - Uses spotify application
- **Story:**
  - App has entertainment value
  - Friends and peers would definitely use at least once
  - Allows users to discover new music/genres
- **Market:**
  - Pretty large (anyone who listens to music on spotify premium)
  - Size and scale starts small with college students and can be expanded to any location with dense population
  - Does not provide huge valute to niche group of people since the app is targeted at general spotify users
  - Starting defined audience is college students
- **Habit:**
  - Pretty addicting for bored students in class (its a fun distraction)
  - Would be used a couple times a day
  - Users consume app
- **Scope:**
  - It will be doable but challenging to complete the basic functionalities
  - Stripped down version of this app is still interesting to build
  - Product is clearly defined

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

- [x] Be able to login with spotify api
- [x] Get users location from GPS and update it on realtime database
- [x] Be able to see list of users in your radious
- [x] Be able to click on a user in your set radius and listen to whatever they are listening to currently or access their profile
- [x] Be able to chat with users in your radius
- [x] Be able to see the song title of what other users are listening to in your radius
- [x] Be able to logout
- [x] be able to sign in or sign up
* Be able to play/broadcast your music in real time to other users in the set radius
- [x] Be able to view your spotify lists and search for songs on spotify
- [x] Be able to listen to music from spotify
* Be able to send a like to a user currently playing music in the radius
* Be able to receive a notification of a like from another user while you are playing music
- [x] Be able to edit and view your own profile

**Optional Nice-to-have Stories**

* Be able to create music rooms where multiple users can listen to the same song in sync and chat
* Be able to friend other users
* Be able to set a profile picture
* Be able to join and search for music rooms
* Be able to see another user’s profile including music rooms, number of likes, favorite song

### 2. Screen Archetypes

* Login Screen
  * Be able to login with spotify api
* Map Screen
  * Be able to see yourself and the general location of other users on a map
  * Be able to click on a user in your set radius and listen to whatever they are listening to currently or access their profile
* Profile Screen
  * Be able to edit and view your own profile
  * Other Users Profile Screen
  * Be able to chat with users in your radius
* Chat Screen
  * User can view a list of previous chats with other users
  * User can continue to chat with other users
* Music Screen
  * Be able to see the song title of what other users are listening to in your radius
  * Be able to send a like to a user currently playing music in the radius
* My Music Screen
  * Be able to play/broadcast your music in real time to other users in the set radius
  * Be able to view your spotify lists and search for songs on spotify

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Map of nearby users
* User profile
* Spotify library

**Flow Navigation** (Screen to Screen)

* Login screen
  => Main Interface
* Main Interface
  => Main screen
  => Profile screen
  => Play screen
* Play Screen
  => Other user profile
  => Other user play screen
* Profile Screen
  => Chat screen

## Wireframes
[Add picture of your hand sketched wireframes in this section]
<img src="https://i.imgur.com/dA3iY2U.jpg" width=600>
<img src="https://i.imgur.com/3PGZinx.jpg" width=600>

## Data Models

* User

Property|Type|Description
:--------------:|:----------------:|:------------------:
id|int|Unique id for a use
username|String|Username from spotify
password|String|Users password
author|String|Full name of user
image|File|Profile picture of the user
email|String|Users email
description|String|Description of user’s music taste
listeners|int[] |A list of people that listen to a given user
favoriteSongs|String|Users favorite song on profile
musicRooms|String[]|A list of music rooms a user is following
currentMusic|String|Music the user is currently listening to/last played song
chatIds|int[]|A list of chat ids the user is currently in
Coordinates|geoLocation|Location of the user

* Chat

Property|Type|Description
:--------------:|:----------------:|:------------------:
chatId|int|Unique identifier for each conversation between two users
messages|String[]|Conversation between users

* Listeners

Property|Type|Description
:--------------:|:----------------:|:------------------:
id|String|The user that is being listened to
listenerId|String[]|A list of user ids that are listeners

## Parse Network Requests

**Login Screen**

  * Get - check if user already exists
  * Get - authorize Spotify
  
**Sign Up**

  * Post - send login information and add into database if nonexistent 
  
**Home Screen**

  * Post - current geo location constantly
  * Get - users’ locations in your radius	
  * Get - current music
  * Get - profile picture
  
**Profile Page**

  * Put - profile picture
  * Get - user’s name
  * Get - description
  * Get - # of listeners
  * Get - # of listenTo’s
  * Get - favorite songs
  
**Chat Screen**

  * Get - chat log
  * Get - current music
  
**Message Screen**

  * Get - message log
  * Post - message(s)
  
**Play Screen**

  * Get - current song
  * Get - album cover
  * Get - name
  * Post - in order to like a song
  * Get - when someone likes a message
  
**My Music Screen**

  * Get - user’s playlist
  * Get - user’s current songs



