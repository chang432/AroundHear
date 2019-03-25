
# AroundHear

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)

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

* Be able to login with spotify api
* Be able to see yourself and the general location of other users on a map
* Be able to click on a user in your set radius and listen to whatever they are listening to currently or access their profile
* Be able to chat with users in your radius
* Be able to see the song title of what other users are listening to in your radius
* Be able to logout
* Be able to play/broadcast your music in real time to other users in the set radius
* Be able to view your spotify lists and search for songs on spotify
* Be able to send a like to a user currently playing music in the radius
* Be able to receive a notification of a like from another user while you are playing music
* Be able to edit and view your own profile

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
:------------------------------------------------------------:|:---------------------------------------------------------:|-----------------------------------------------------------:
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

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype
