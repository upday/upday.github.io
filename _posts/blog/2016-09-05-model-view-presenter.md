---
layout: post
title: "Model-View-Presenter Pattern in Android"
description: What MVP is, how to implement it in Android, advantages and disadvantages.
modified:
categories: blog
author: florina_muntenescu
excerpt: The MVP pattern became one of the most popular patterns in Android in the last couple of years. Let's see what MVP is, how to apply it in Android and some of its advantages and disadvantages.
tags: [Android, Architecture, MVP]
date: 2016-09-05T10:39:55-04:00
---

The initial implementation of the upday app with the Model-View-Controller pattern proved to be a failure. We needed an architecture that allows us to react fast to UI changes. Could the Model-View-Presenter pattern be our solution? Let's discover what this pattern is; how it can be applied in Android and most of all, what are its advantages and disadvantages.

## The Model-View-Presenter Pattern

Deriving from Model-View-Controller, the MVP pattern solves the main disadvantages of MVC: the Presenter is the intermediary between the Model and the View, holding all the UI logic. Here are the roles of every component:

* *Model* - the data layer, responsible for handling the business logic and communication with the network and database layers.
* *View* -  
