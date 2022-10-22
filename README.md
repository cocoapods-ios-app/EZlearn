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
Anyone seeking to learn a new skill, concept, or subject is the typical user. This person has a goal to learn something but does not have the time to find the resources online or does not know how to find them. Just by typing the name of a subject, or skill, or concept, the person has access to videos, articles, and links to learn. This person then select the videos and links he wants from the list and the app creates a folder for that person with all the saved links, videos and articles. This person can access that folder at anytime. 

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

* [ ] User must be able to add learning goals
* [ ] User must be able to save resources on learning goals in a folder
* [ ] User must be able to search for resources on the app
* [ ] User must be able to link those resources to the learning goals

**Optional Nice-to-have Stories**

* [ ] User can share their learning goals together
* [ ] User can contribute to other users' public learning goals

### 2. Screen Archetypes

<img src="https://i.imgur.com/nIhADim.png" height=500>
   * Allowing users to have multiple folders
   * Allowing users to create new folders

<img src="https://i.imgur.com/99XC3WM.png" height=500>
   * Overview of a folder's homescreen

### 3. Navigation

**Tab Navigation** (Tab to Screen)

<img src="https://i.imgur.com/nIhADim.png" height=500>
   * User's homescreen 
 
<img src="https://i.imgur.com/ipDMugu.png" height=500>
   * Allowing users to search for studying resources and add them to their respective folders
 
<img src="https://i.imgur.com/RD6Uque.png" height=500>
   * Allowing users to create accounts to store their resources and access from any other IOS devices

**Flow Navigation** (Screen to Screen)

* <img src="https://i.imgur.com/nIhADim.png" height=200>
   * <img src="https://i.imgur.com/QAtuVsB.png" height=200>
   * <img src="https://i.imgur.com/pIBzvjh.png" height=200>
   * <img src="https://i.imgur.com/pjgGC9t.png" height=200>
   * 

## Wireframes
![](https://media.discordapp.net/attachments/1028838792636923974/1030690471137251368/IMG_2027.jpg?width=576&height=569)


### [BONUS] Interactive Prototype

## Schema 
[This section will be completed in Unit 9]
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
