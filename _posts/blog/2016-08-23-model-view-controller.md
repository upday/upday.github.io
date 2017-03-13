---
layout: post
title: "Android Architecture Patterns Part 1: Model-View-Controller"
description: Discover what Model-View-Controller is, how it should be implemented and some of its ups and downs.
modified:
categories: blog
author: florina_muntenescu
excerpt: The Model-View-Controller pattern is one of the first ones to be applied in Android. Discover what it is, how it should be implemented and some of its advantages and disadvantages.
tags: [Android, Architecture, MVC]
date: 2016-09-04T15:39:55-04:00
---

A year ago, when the majority of the current Android team started working at upday, the application was far from being the robust, stable app that we wanted it to be. We tried to understand why our code was in such bad shape and we found two main culprits: continuous changing of the UI and the lack of an architecture that supported the flexibility that we needed. The app was already at its fourth redesign in six months. The design pattern chosen seemed to be Model-View-Controller but was then already a "mutant", far from how it should be.

Let's discover together what the Model-View-Controller pattern is; how it has been applied in Android over the years; how it should be applied so it can maximize testability; and some of its advantages and disadvantages.

## The Model-View-Controller Pattern

In a world where the user interface logic tends to change more often than the business logic, the desktop and Web developers needed a way of separating user interface functionality. The MVC pattern was their solution.

* **Model** - the data layer, responsible for managing the business logic and handling network or database API.
* **View** - the UI layer - a visualization of the data from the Model.
* **Controller** - the logic layer,  gets notified of the user's behavior and updates the Model as needed.

<center>
<picture>
	<a href="/images/blog/mvc/mvc.png"><img src="/images/blog/mvc/mvc.png" alt="Model-View-Controller Architecture" width="350"></a>
	<figcaption>Model-View-Controller class structure</figcaption>
</picture>
</center>

So, this means that both the Controller and the View depend on the Model: the Controller to update the data, the View to get the data. But, most important for the desktop and Web devs at that time: the Model was separated and could be tested independently of the UI.
Several variants of MVC appeared. The best-known ones are related to whether the Model is passive or is actively notifying that it has changed. Here are more details:

### Passive Model

In the Passive Model version, the Controller is the only class that manipulates the Model.
Based on the user's actions, the Controller has to modify the Model. After the Model has been updated, the Controller will notify the View that it also needs to update. At that point, the View will request the data from the Model.

<center>
<picture>
	<a href="/images/blog/mvc/mvc_passive_model_sequence.png"><img src="/images/blog/mvc/mvc_passive_model_sequence.png" alt="Model-View-Controller Passive Model Sequence" width="350"></a>
	<figcaption>Model-View-Controller - passive Model - behavior</figcaption>
</picture>
</center>

### Active Model

For the cases when the Controller is not the only class that modifies the Model, the Model needs a way to notify the View, and other classes, about updates. This is achieved with the help of the Observer pattern.
The Model contains a collection of observers that are interested in updates. The View implements the observer interface and registers as an observer to the Model.

<center>
<picture>
	<a href="/images/blog/mvc/mvc_active_model.png"><img src="/images/blog/mvc/mvc_active_model.png" alt="Model-View-Controller Active Model Class Structure" width="350"></a>
	<figcaption>Model-View-Controller - active Model - class structure</figcaption>
</picture>
</center>

Every time the Model updates, it will also iterate through the collection of observers and call the `update` method. The implementation of this method in the View will then trigger the request of the latest data from the Model.

<center>
<picture>
	<a href="/images/blog/mvc/mvc_active_model_sequence.png"><img src="/images/blog/mvc/mvc_active_model_sequence.png" alt="Model-View-Controller Active Model Sequence" width="350"></a>
	<figcaption>Model-View-Controller - active Model - behavior</figcaption>
</picture>
</center>

### Model-View-Controller in Android

In around 2011, when Android started to become more and more popular, architecture questions naturally appeared. Since MVC was one of the most popular UI patterns at that time, developers tried to apply it to Android too.

If you search on StackOverflow for questions like "How to apply MVC in Android", one of the most popular answers stated that in Android, an Activity is both the View and the Controller.
Looking back, this sounds almost crazy! But, at that point, the main emphasis was on making the Model testable and usually the implementation choice for the View and the Controller was dependent on the platform.

### How Should MVC Be Applied in Android

Nowadays, the question of how to apply the MVC patterns has an answer that is easier to find. The Activities, Fragments and Views should be the Views in the MVC world. The Controllers should be separate classes that don't extend or use any Android class, and same for the Models.

One problem arises when connecting the Controller to the View, since the Controller needs to tell the View to update. In the passive Model MVC architecture, the Controller  needs to hold a reference to the View.
The easiest way of doing this, while focusing on testing, is to have a BaseView interface, that the Activity/Fragment/View would extend. So, the Controller would have a reference to the BaseView.

## Advantages

The Model-View-Controller pattern highly supports the separation of concerns. This advantage not only increases the testability of the code but it also makes it easier to extend, allowing a fairly easy implementation of new features.

The Model classes don't have any reference to Android classes and are therefore straightforward to unit test.
The Controller doesn't extend or implement any Android classes and should have a reference to an interface class of the View. In this way, unit testing of the Controller is also possible.

If the Views respect the **single responsibility principle** then their role is just to update the Controller for every user event and just display data from the Model, without implementing any business logic. In this case, UI tests should be enough to cover the functionalities of the View.

## Disadvantages

### The View Depends On The Controller And On The Model

The dependence of the View on the Model starts being a downside in complex Views. In order to minimize the logic in the View, the Model should be able to provide testable methods for every element that gets to be displayed.
In an active Model implementation, this exponentially increases the number of classes and methods, given that Observers for every type of data would be required.

Given that the View depends on both the Controller and the Model, changes in the UI logic might require updates in several classes, decreasing the flexibility of the pattern.

### Who Handles The UI Logic?

According to the MVC pattern, the Controller updates the Model and the View gets the data to be displayed from the Model. But who decides on how to display the data? Is it the Model or the View?
Consider the following example: we have a ``User``, with first name and last name. In the View we need to display the user name as "Lastname, Firstname" (e.g. "Doe, John").

If the Model's role is to just provide the "raw" data, it means that the code in the View would be:

{% highlight java %}
String firstName = userModel.getFirstName();
String lastName = userModel.getLastName();
nameTextView.setText(lastName + ", " + firstName)
{% endhighlight %}

So this means that it would be the View's responsibility of handling the UI logic. But this makes the UI logic impossible to unit test.

The other approach is to have the Model expose only the data that needs to be displayed, hiding any business logic from the View. But then, we end up with Models that handle both business and UI logic. It would be unit testable, but then the Model ends up, implicitly being dependent on the View.

{% highlight java %}
String name = userModel.getDisplayName();
nameTextView.setText(name);
{% endhighlight %}

### Conclusion

In the early days of Android the Model-View-Controller pattern seemed to have confused a lot of developers and led to code that was difficult, if not impossible to unit test.

The dependence of the View from the Model and having logic in the View steered our code-base to a state from which it was impossible to recover without refactoring completely the app. What was the new approach in architecture and why? Find out in by reading <a href="https://upday.github.io/blog/model-view-presenter/">this blog post</a>.

----

## Have you noticed? <a href="http://upday.github.io/jobs/" target="blank">upday is hiring!</a> Come work with us.
