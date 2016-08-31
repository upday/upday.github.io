---
layout: post
title: "Model-View-Controller in Android"
description: Discover what Model-View-Controller is, how it should be implemented and some of its ups and downs.
modified:
categories: blog
author: florina_muntenescu
excerpt: The Model-View-Controller pattern is one of the first ones to be applied in Android. Discover what it is, how it should be implemented and some of its ups and downs.
tags: [Android, Architecture, MVC]
date: 2016-07-23T15:39:55-04:00
---

A year ago, when the majority of the current Android team started working at upday, the application was far from being the robust, stable app that we wanted it to be. We tried to understand why our code was in such bad shape and we found two main culprits: continuous changing of the UI and the lack of an architecture that supported the flexibility that we needed. The app was already at its fourth redesign in six months. The design pattern chosen seemed to be Model-View-Controller but was then already a "mutant", far from how it should be.

Let's discover together what the Model-View-Controller pattern is; how it has been applied in Android along the years; how it should be applied so it can maximize testability; and some of its advantages, disadvantages and pitfalls.

## The Model-View-Controller Pattern

In a world where the user interface logic tends to change more often than the business logic, the desktop and Web developers needed a way of separating user interface functionality. The MVC pattern was their solution.

* **Model** - the data layer, responsible of managing the business logic and handling network or database API.
* **View** - the UI layer - a visualization of the data from the model.
* **Controller** - gets notified of the user's behavior and updates the model as needed.

<center>
<picture>
	<a href="/images/blog/mvc/mvc.png"><img src="/images/blog/mvc/mvc.png" alt="Model-View-Controller Architecture" width="350"></a>
	<figcaption>Model-View-Controller class structure</figcaption>
</picture>
</center>

So, this means that both the controller and the view depend on the model: the first to update the data, the latter to get the data. But, most important for the desktop and Web devs at that time: the model was separated and could be tested independently of the UI.
Several variants of MVC appeared. The best known ones are related to whether the model is passive or is actively notifying that it has changed. Here are more details:

### Passive Model

In a passive model version, the controller is the only class that manipulates the model.
Based on the user's actions, the controller has to modify the model. After the model has been updated, the controller will notify the view that it also needs to update. At that point, the view will request the data from the model.

<center>
<picture>
	<a href="/images/blog/mvc/mvc_passive_model_sequence.png"><img src="/images/blog/mvc/mvc_passive_model_sequence.png" alt="Model-View-Controller Passive Model Sequence" width="350"></a>
	<figcaption>Model-View-Controller - passive model - behavior</figcaption>
</picture>
</center>

### Active Model

For the cases when the controller is not the only class that modifies the model, the model needs a way to notify the view, and any other classes, about updates. This is achieved with the help of the Observer pattern.
The model contains a collection of observers that are interested in updates. The view implements the observer interface and registers as an observer to the model.

<center>
<picture>
	<a href="/images/blog/mvc/mvc_active_model.png"><img src="/images/blog/mvc/mvc_active_model.png" alt="Model-View-Controller Active Model Class Structure" width="350"></a>
	<figcaption>Model-View-Controller - active model - class structure</figcaption>
</picture>
</center>

Every time the model updates, it will also iterate through the collection of observers and call the `update` method. The implementation of this method in the view will then trigger the request of the latest data from the model.

<center>
<picture>
	<a href="/images/blog/mvc/mvc_active_model_sequence.png"><img src="/images/blog/mvc/mvc_active_model_sequence.png" alt="Model-View-Controller Active Model Sequence" width="350"></a>
	<figcaption>Model-View-Controller - active model - behavior</figcaption>
</picture>
</center>

## Model-View-Controller in Android
In around 2011, when Android started to become more and more popular, architecture questions naturally appeared. Since MVC was one of the most popular UI patterns at that time, developers tried to apply it to Android too.

If you search on StackOverflow for questions like "How to apply MVC in Android", one of the most popular answers stated that in Android, an Activity is both the view and the controller.
Looking back, this sounds almost crazy! But, at that point, the main emphasis was on making the model testable and usually the implementation choice for the view and the controller was dependent on the platform.

### How Should MVC Be Applied in Android
Nowadays, the question of how to apply the MVC patterns has an answer that is easier to find. The Activities, Fragments and Views should be the views in the MVC world. The controllers should be separate classes that don't extend or use any Android class, and same for the models.

One problem arises when connecting the controller to the view, since the controller needs to tell the view to update. In the passive model MVC architecture, the Controller  needs to hold a reference to the View.
The easiest way of doing this, while focusing on testing, is to have a BaseView interface, that the Activity/Fragment/View would extend. So, the Controller would have a reference to the BaseView.

## Advantages

The Model-View-Controller pattern highly supports the separation of concerns which increases the testability of the code.

The model classes don't have any reference to Android classes and are therefore straightforward to unit test.
The controller doesn't extend or implement any Android classes and should have a reference to an interface class of the View. In this way, unit testing of the controller is also possible.

If the views respect the **single responsibility principle** then their role is just to update the controller for every user event and just display data from the model, without implementing any business logic. In this case, UI tests should be enough to cover the functionalities of the View.

## Disadvantages and Pitfalls

### The View Depends On The Controller And On The Model

The dependence of the view on the model starts being a downside in complex views. In order to minimize the logic in the view, the model should be able to provide testable methods for every element that gets to be displayed.
In an active model implementation, this exponentially increases the number of classes and methods, given that Observers for every type of data would be required.

Given that the view depends on both the controller and the model, changes in the UI logic might require updates in several classes, decreasing the flexibility of the pattern.

### Putting Logic In The Views

According to the MVC pattern, the view gets data to be displayed from the mode. This is where one of the MVC pitfalls tends to appear and where it actually did in our case. The model should be exposing only the data that needs to be displayed, hiding any business logic from the View.

Consider the following example: we have a ``User``, with first name and last name. In the View we need to display the user name as "Lastname, Firstname" (e.g. "Doe, John").

In the implementation of the view, the code should be like this:

{% highlight java %}
String name = userModel.getDisplayName();
nameTextView.setText(name);
{% endhighlight %}

Unfortunately, in a lot of cases, developers end up with code like this:

{% highlight java %}
String firstName = userModel.getFirstName();
String lastName = userModel.getLastName();
nameTextView.setText(lastName + ", " + firstName)
{% endhighlight %}

The first code snippet, says that the model exposes directly the name that needs to be displayed, hiding the logic in the model. Since the model has no reference to Android classes it can easily be unit tested.
In the second code snippet, the view is the one that handles the UI logic, making it impossible to unit test.

### Conclusion
Although at the beginning, the Model-View-Controller pattern seemed to have confused a lot of developers and led to code that was difficult, if not impossible to unit test. However, when correctly implemented, MVC can be a possible solution. Still, the dependence of the view to the model tends to increase the complexity of the code considerably.
