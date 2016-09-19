---
layout: post
title: "Android Architecture Patterns Part 2:</br>Model-View-Presenter"
description: What MVP is, how to implement it in Android, advantages and disadvantages.
modified:
categories: blog
author: florina_muntenescu
excerpt: The MVP pattern became one of the most popular patterns in Android in the last couple of years. Let's see what MVP is, how to apply it in Android and some of its advantages and disadvantages.
tags: [Android, Architecture, MVP]
date: 2016-09-05T10:39:55-04:00
---

In order to support developers in making good architecture choices, Google offers <a href="https://github.com/googlesamples/android-architecture">Android Architecture Blueprints</a> - a set of various implementations of the same application. For now, the samples contain different types of Model-View-Presenter implementations. I worked together with <a href="https://github.com/erikhellman">Erik Hellman</a> on the <a href="https://github.com/googlesamples/android-architecture/tree/todo-mvp-rxjava/">MVP & RxJava</a> sample.

The aim of this article is to explain what MVP is, how we applied it in the Architecture Blueprints and most of all, what are its advantages and disadvantages.

## The Model-View-Presenter Pattern

Here are the roles of every component:

* **Model** - the data layer. Is responsible for handling the business logic and communication with the network and database layers.
* **View** -  the UI layer. Displays the data and notifies the Presenter about user actions.
* **Presenter** -  retrieves the data from the Model, applies the UI logic and manages the state of the View, by telling the View what to display and by reacting to user input notifications from the View.

The implementation of the View is abstracted and the Presenter holds a reference to an interface of the View class. Presenters usually also tend to be abstracted and interfaces containing the contracts between the Views and the Presenters are created.

<center>
<picture>
	<a href="/images/blog/model_view_presenter/mvp.png"><img src="/images/blog/model_view_presenter/mvp.png" alt="Model-View-Presenter Architecture"></a>
	<figcaption>Model-View-Presenter class structure</figcaption>
</picture>
</center>

## The Model-View-Presenter Pattern & RxJava In Android

### Model

### View

### Presenter




### Advantages

The <a href="https://upday.github.io/blog/model-view-controller/">Model-View-Controller pattern</a> has two main disadvantages: the View has a reference to both the Controller and the Model; and does not provide only one class to handle the UI logic, this responsibility being shared between the Controller and the View or the Model. The Model-View-Presenter pattern fixes both of these issues by breaking the connection that the View has with the Model and creating only **one class that handles** everything related to **the presentation of the View** - the Presenter.


### Disadvantages

god class
