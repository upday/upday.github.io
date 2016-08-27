---
layout: post
title: "Model-View-Controller in Android"
description: How MVC was, is and should be implemented in Android
modified:
categories: blog
author: florina_muntenescu
excerpt: How MVC was, is and should be implemented in Android.
tags: [Android, Architecture, MVC]
date: 2016-07-23T15:39:55-04:00
---

A year ago, when the majority of the current Android team started working at upday, the application was far from being the robust, stable app that we wanted to be. When tried to understand why our code was in such a bad shape and we found two main culprits: a constant change of the UI and the lack of an architecture that allows that flexibility. The app was already at its fourth redesign in six months. The design pattern chose seemed to be Model-View-Controller but was then already a mutant, far from how it should be.
Let's discover together what the Model-View-Controller pattern is; how it's been applied in Android along the years; how it should be applied so it can maximize testability; and some of its advantages and disadvantages and pitfalls.


### MVC

### MVC in Android
Around 2011, when Android started becoming more and more popular, architecture questions naturally appeared. Since MVM was the most popular pattern for web, no wonder that developers were trying to apply it to Android too. If you search on StackOverflow for questions like "How to apply MVC in Android", one of the most popular answer was stating that in Android, an Activity is both the view and the controller. Crazy, right? In the same time, given that in those ages, the emphasis on testing was close to none, Fragments were not yet available and good examples were scarce, there's no wonder that this happened.

## How MVC should be applied in Android
Nowadays, the question of how to apply the MVC patterns has an answer easier to find.  The Activities, Fragments and Views should be the Views in the MVC world. The Controllers should be separate classes that don't extend any Android class, and same for the Models.
One problem arrises in how to connect the Controller to the View, since the Controller needs to tell the View to update.
In the passive model MVC architecture, the Controller  needs to hold a reference to the View.
The easiest way of doing this, while focusing on testing, is to have a BaseView interface, that the Activity/Fragment/View would extend. So, the Controller would have an reference to the BaseView.
The the active model MVC architecture, the ``Observer`` pattern is used, so the Controller has a reference to an Observer interface.

### Advantages

The Model-View-Controller pattern highly supports the separation of concerns which increases the testability of the code.
The Model classes should have no reference to any Android classes therefore straightforward to unit test.
The Controller should not extend or implement any Android classes and should have a reference to an interface class either of the View or of the Observer, depending on the active or passive model used. In this way, unit testing the Controller is also possible.
If the Views respect the ``single responsibility principle`` then their role is just to update the Controller for every user event and just display data from the model, without implementing any business logic. In this case, UI tests should be enough to cover the functionalities of the View.

### Disadvantages and pitfalls

## Lifecycle when having references to the Controller and the Model ????


## Putting logic in the Views
Since the View, according to the MVC pattern, needs to get the data to be displayed from the Model, means that the View also needs to have a reference to the Model. This is where one of the MVC pitfalls tends to appear, and where it actually did in our case. The Model should be exposing only the data that needs to be displayed, hiding any business logic from the View.
For example, if we have a ``User``, with first name and last name, and in the View we need to display it as "Lastname, Firstname" (e.g. "Doe, John"), inside the View, the code should be like this:

```java
String name = userModel.getDisplayName();
nameTextView.setText(name);
```

Unfortunately, in a lot of cases, developers end up with code like this:

```java
String firstName = userModel.getFirstName();
String lastName = userModel.getLastName();
nameTextView.setText(lastName + ", " + firstName)
```

### Conclusion
Although at the beginning, the Model-View-Controller pattern seemed to have confused a lot of developers and led to code that was hard, if not impossible to unit test, when correctly implemented, MVC can be the right solution.
