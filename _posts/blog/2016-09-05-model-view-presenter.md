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

Find out what MVP is, how we applied it in the Architecture Blueprints and most of all, what are its advantages and disadvantages.

## The Model-View-Presenter Pattern

Here are the roles of every component:

* **Model** - the data layer. Is responsible for handling the business logic and communication with the network and database layers.
* **View** -  the UI layer. Displays the data and notifies the Presenter about user actions.
* **Presenter** -  retrieves the data from the Model, applies the UI logic and manages the state of the View, by telling the View what to display and by reacting to user input notifications from the View.

The implementation of the View is abstracted and the Presenter holds a reference to an interface of the View class. Presenters usually tend to be abstracted also; interfaces containing the contracts between the Views and the Presenters are created.

<center>
<picture>
	<a href="/images/blog/model_view_presenter/mvp.png"><img src="/images/blog/model_view_presenter/mvp.png" alt="Model-View-Presenter Architecture"></a>
	<figcaption>Model-View-Presenter class structure</figcaption>
</picture>
</center>

## The Model-View-Presenter Pattern & RxJava In Android Architecture Blueprints

The blueprint sample is a to-do application. It lets a user create, read, update and delete to-do tasks. The asynchronous operations are handled with the help of RxJava.

### Model

The Model works with the remote and local data sources to get and save the data. This is where the business logic is handled. For example, when requesting the list of `Task`s, the Model would try to retrieve them from the local data source. If it is empty, it will query the network, save the response in the local data source and then return the list.

The retrieval of tasks is done with the help of RxJava:

{% highlight java %}
public Observable<List<Task>> getTasks(){
  ...
}
{% endhighlight %}

The Model receives as parameters in the constructor **interfaces** for the local and remote data sources that are then mocked in the tests, with the help of Mockito. Since the Model does not contain any reference to Android classes, it is easy to unit test. For example, to test that `getTasks` requests data from the local source, we have the following test:

{% highlight java %}
@Mock
private TasksDataSource mTasksRemoteDataSource;

@Mock
private TasksDataSource mTasksLocalDataSource;
...

@Test
public void getTasks_requestsAllTasksFromLocalDataSource() {
    // Given that the local data source has data available
    setTasksAvailable(mTasksLocalDataSource, TASKS);
    // And the remote data source does not have any data available
    setTasksNotAvailable(mTasksRemoteDataSource);

    // When tasks are requested from the tasks repository
    TestSubscriber<List<Task>> testSubscriber = new TestSubscriber<>();
    mTasksRepository.getTasks().subscribe(testSubscriber);

    // Then tasks are loaded from the local data source
    verify(mTasksLocalDataSource).getTasks();
    testSubscriber.assertValue(TASKS);
}
{% endhighlight %}


### View

### Presenter




### Advantages

The <a href="https://upday.github.io/blog/model-view-controller/">Model-View-Controller pattern</a> has two main disadvantages: the View has a reference to both the Controller and the Model; and does not provide only one class to handle the UI logic, this responsibility being shared between the Controller and the View or the Model. The Model-View-Presenter pattern fixes both of these issues by breaking the connection that the View has with the Model and creating only **one class that handles** everything related to **the presentation of the View** - the Presenter.


### Disadvantages

god class
