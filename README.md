Original App Design Project - README Template
===

# EZlearn

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
Stop looking for good resources. Let EZlearn find them.

Anyone seeking to learn a new skill, concept, or subject is the typical user. This person has a goal to learn something but does not have the time to find the resources online or does not know how to find them. Just by typing the name of a subject, or skill, or concept, the person has access to videos to learn. This person then select the videos he wants from the list and the app creates a goal for that person with all the saved resources. This person can access these goals at anytime. 

### App Evaluation
- **Category:** Productivity
- **Mobile:** Internet Access
- **Story:** Helps users to find and save resoucres as it relates to their goals
- **Market:** Anyone seeking to learn a new skill, concept, or subject
- **Habit:** Users can find YouTube videos and other resources to save to their goals
- **Scope:** This app is meant to be used by users globally


## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* [x] User must be able to add learning goals
* [x] User must be able to link those resources to the learning goals
* [x] User must be able to search for resources on the app

**Optional Nice-to-have Stories**
* User can add reminders
* User can click to have the resource open up
* User achieves badges when they complete a set amount of goals
* User can share their learning goals together
* User can contribute to other users' public learning goals

<br />

### Milestone Three Demo
- User can change the color of a goal
- Resources can be saved to goals
- Resources open in YouTube

<img src='https://github.com/cocoapods-ios-app/EZlearn/blob/main/EZlearn-UserStory3.gif' width='340' alt='Video Walkthrough' />
<br />


### Milestone Two Demo
- A list of resources fitting the user's goal
- Resources are pulled from the YouTube API

<img src='https://github.com/cocoapods-ios-app/EZlearn/blob/main/EZlearn-UserStory2.gif' width='340' alt='Video Walkthrough' />
<br />

### Milestone One Demo
- The overall EZ interface is shown
- Goals are able to be saved

<img src='https://github.com/cocoapods-ios-app/EZlearn/blob/main/EZlearn_UserStory1.gif' width='340' alt='Video Walkthrough' />
<br />


### 2. Screen Archetypes
   * Allowing users to have multiple folders
   * Allowing users to create new folders
   * Overview of a folder's homescreen

### 3. Navigation

**Tab Navigation** (Tab to Screen)

   * User's homescreen 
 
   * Allowing users to search for studying resources and add them to their respective folders
 
   * Allowing users to create accounts to store their resources and access from any other IOS devices

**Flow Navigation** (Screen to Screen)

<img src="https://i.imgur.com/Npl5JXQ.jpg" width=576>

- Welcome Scren (Starting Screen)
    - Login
    - Sign Up
- Login Screen
    - Welcome Screen
    - Home Screen
    - Sign Up Screen
- Create Account Screen
    - Welcome Screen
    - Home Screen
- Home Screen
    - Task View
    - Add Task
    - Profile
    - Settings
- Task View
    - Home Screen
- Add Task
    - Home Screen
- Settings
    - Home Screen
- Profile Screen
    - Home Screen
    - Welcome Screen


## Wireframes
### Design 3:
<img src="https://i.imgur.com/m3g8Qd0.jpg" width=576>

### Design 2:
![](https://media.discordapp.net/attachments/1028838792636923974/1030690471137251368/IMG_2027.jpg?width=576&height=569)
### Design 1:
<img src="https://i.imgur.com/rVcGdsf.jpg" width=576>

### [BONUS] Interactive Prototype
We used Figma to design! It can be found [here](https://www.figma.com/file/YCyicA0DuhLDIQgwWVLsGE/EZlearn?node-id=0%3A1&t=lAL3swhgrcTNVAac-1).

<img src="https://i.imgur.com/1paoc4Q.gif" width=340>


## Schema 
### Models
#### Folder 

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | username      | String   | username of the account holder |
   | uniqueId      | String   | unique Id of each task created |
   | notes         | String   | additional notes for a task added to folder |
### Networking
#### List of network requests by screen
   - Search Screen
      - (Read/GET) Query of all post related to a study topic
      - (Add/POST) Add a post into a study folder
      - (Delete) Delete a post added to a study folder from that study folder
   - Create Folder Screen
      - (Create/POST) Create a new study topic folder
   - Main Profile Screen
      - (Read/GET) Query logged in user study folders
