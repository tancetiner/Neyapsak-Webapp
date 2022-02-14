# NeYapsak Webapp
NeYapsak is a web application that enables users to check the activities in their location based on some filters, save them and buy tickets!
'Ne Yapsak?' means 'What to do?' in Turkish. So this is the application to answer this crucial question!

### Table of contents

* [Motivation](#motivation)
* [Methodology](#methodology)
* [Technologies](#technologies)
* [Collaboration](#collaboration) 
* [Features](#features)
* [Commits](#commits)
* [Screenshots](#screenshots)



### Motivation
This was the term project for our course "Cs308 - Software Engineering". The main aim of this group project was to develop a "database-driven web application". We followed the regulations and requirements based on the course and our instructor Anıl Koyuncu.

### Methodology
We followed the agile software development throughout this project. A teaching assistant (Genco Coşgun) was assigned to the team as the "client". We held regular Scrum Meetings to follow each other's progress inside the team and weekly client meetings to present our development and get feedback. The project was divided into 5 sprints. The first 4 of them were 4-weeks long and the last one was an "extra" sprint that lasted for one week. At the end of each sprint, we had sprint demos with the teaching assistant and the instructor.

### Technologies
* Frontend                    -->   Flutter
* Backend                     -->   Django
* Database                    -->   sqlite3
* Tracking the sprint tasks   -->   Jira Software
* Storing the code            -->   Bitbucket

### Collaboration
This was a group project. We had 3 members. [Dora Akbulut](https://github.com/akbulutdora), [Batuhan Yıldırım](https://github.com/Batuhanyldirim) and me. Although we were aware of the 'big picture', as we were using some technologies that we've no experience with before, we tried to divide them to focus more and master them. I was mainly responsible for the backend, coding the views, and configuring the URLs in Django. 

### Features
These are from our sprint tasks. 

For regular users:
* Register to application
* Sign in
* Display the events in my city on the home screen
* Search for events via the search bar
* Filter the results by date, location, price
* Save events
* Buy tickets to events
* Show saved events on profile
* Show my tickets on my profile 

Additional features for organisator users:
* Add events
* Edit my events
* Remove my events


### Commits
Throughout the semester we worked on the project on our private Bitbucket repository and when it was finished and graded, I decided to add it to my Github profile. That's why it consists of the initial commit only.

### Screenshots


Login Screen:


![login](/screenshots/loginScreen.png)

Home Screen:
Here we can either make a search with the event name from the search bar, choose the type by pressing one of the images (festival, concert and theater). Also, we can view the recommendations application giving us based on our location.




![home](/screenshots/homeScreen.png)


Advanced Search:
User can search for the events with city, minimum and maximum price. Here we can see that user found an event by selecting 'Sinop' as the city.




![advancedSearch](/screenshots/searchResult.png)


Event Detail Screen:
Here user can see the details of the event, save the event for later, buy tickets.




![eventDetail](/screenshots/eventDetail.png)

Organiser Profile:
Here organiser users can edit or delete their own events. Regular users do not have that feature.




![organiser](/screenshots/organiserProfile.png)






