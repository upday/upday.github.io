---
layout: post
title: "Android Architecture Patterns Part 2:</br>Model-View-Presenter"
description: What MVP is, how to implement it in Android with the help of Google's Android Architecture Blueprints.
modified:
categories: blog
author: florina_muntenescu
excerpt: The MVP pattern became one of the most popular patterns in Android in the last couple of years. Let's see what MVP is and how we applied it in the Google's Android Architecture Blueprints.
tags: [Android, Architecture, MVP]
date: 2016-09-05T10:39:55-04:00
---

In order to support developers in making good architecture choices, Google offers <a href="https://github.com/googlesamples/android-architecture">Android Architecture Blueprints</a> - a set of various implementations of the same application. For now, the samples contain different types of Model-View-Presenter implementations. I worked together with <a href="https://github.com/erikhellman">Erik Hellman</a> on the <a href="https://github.com/googlesamples/android-architecture/tree/todo-mvp-rxjava/">MVP & RxJava</a> sample.

Read more to find out what MVP is, how we applied it in the Architecture Blueprints and most of all, what are its advantages and disadvantages.

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

The Model receives as parameters in the constructor **interfaces of the local and remote data sources** that are then mocked in the tests, with the help of Mockito. Since the Model does not contain any reference to Android classes, it is easy to unit test. For example, to test that `getTasks` requests data from the local source, we implemented the following test:

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

The View works with the Presenter to display the data and it notifies the Presenter about the user's actions. In MVP Activities, Fragments and custom Android views can be Views. Our choice was to use Fragments.

All Views implement the same BaseView interface that allows setting a Presenter.
{% highlight java %}
public interface BaseView<T> {

    void setPresenter(T presenter);

}
{% endhighlight %}

The View notifies the Presenter that it's ready to be updated by calling the `subscribe` method of the Presenter in `onResume`. The View calls `presenter.unsubscribe()` in `onPause` to tell the Presenter that it's no longer interested in being updated.
If the implementation of the View is an Android custom view, then the `subscribe` and `unsubscribe` methods have to be called on `onAttachedToWindow` and `onDetachedFromWindow`.
User actions, like button clicks, will trigger corresponding methods in the Presenter, this being the one that decides what should happen next.

The Views are tested with Espresso. The statistics screen, for example, needs to display the number of active and completed tasks. The test that checks that this is done correctly first puts some tasks in the `TaskRepository`; then launches the `StatisticsActivity` and checks content of the views:
{% highlight java %}
@Before
public void setup() {
    // Given some tasks
    TasksRepository.destroyInstance();
    TasksRepository repository = Injection.provideTasksRepository(
			InstrumentationRegistry.getContext());
    repository.saveTask(new Task("Title1", "", false));
    repository.saveTask(new Task("Title2", "", true));

    // Lazily start the Activity from the ActivityTestRule
    Intent startIntent = new Intent();
    mStatisticsActivityTestRule.launchActivity(startIntent);
}

@Test
public void Tasks_ShowsNonEmptyMessage() throws Exception {
    // Check that the active and completed tasks text is displayed
    Context context = InstrumentationRegistry.getTargetContext();
    String expectedActiveTaskText = context
	.getString(R.string.statistics_active_tasks);
    onView(withText(containsString(expectedActiveTaskText)))
	.check(matches(isDisplayed()));
    String expectedCompletedTaskText = context
	.getString(R.string.statistics_completed_tasks);
    onView(withText(containsString(expectedCompletedTaskText)))
	.check(matches(isDisplayed()));
}
{% endhighlight %}

### Presenter

The Presenter and its corresponding View are created by the Activity. References to the View and to the `TaskRepository` - the Model - are given to the constructor of the Presenter. In the implementation of the constructor, the Presenter will call the `setPresenter` method of the View.

All Presenters implement the same BasePresenter interface.

{% highlight java %}
public interface BasePresenter {

    void subscribe();

    void unsubscribe();

}
{% endhighlight %}

When the `subscribe` method is called, the Presenter starts requesting the data from the Model, then it applies the UI logic to the received data and sets it to the View. For example, in the `StatisticsPresenter`, all tasks are requested from the `TaskRepository` then the retrieved tasks will be used to compute the number of active and completed tasks. These numbers will be used as parameters for the `showStatistics(int numberOfActiveTasks, int numberOfCompletedTasks)` method of the View.

A unit test to check that indeed the `showStatistics` method is called with the correct values is easy to implement. We are mocking the `TaskRepository` and the `StatisticsContract.View` and give the mocked objects as parameters to the constructor of a `StatisticsPresenter` object. The test implementation is:

{% highlight java %}
@Test
public void loadNonEmptyTasksFromRepository_CallViewToDisplay() {
    // Given an initialized StatisticsPresenter with
    // 1 active and 2 completed tasks
    setTasksAvailable(TASKS);

    // When loading of Tasks is requested
    mStatisticsPresenter.subscribe();

    // Then the correct data is passed on to the view
    verify(mStatisticsView).showStatistics(1, 2);
}
{% endhighlight %}

The role of the `unsubscribe` method is to clear all the subscriptions of the Presenter, avoiding memory leaks.

Apart from `subscribe` and `unsubscribe`, each Presenter exposes other methods, corresponding to the user actions in the View. For example, the `AddEditTaskPresenter`, adds methods like `createTask`, that would be called when the user presses the button that creates a new task. This ensures that all the user actions and consequently all the UI logic go through the Presenter and then can be unit tested.

## Conclusion

The <a href="https://upday.github.io/blog/model-view-controller/">Model-View-Controller pattern</a> has two main disadvantages: the View has a reference to both the Controller and the Model; and does not provide only one class to handle the UI logic, this responsibility being shared between the Controller and the View or the Model. The Model-View-Presenter pattern fixes both of these issues by breaking the connection that the View has with the Model and creating only **one class that handles** everything related to **the presentation of the View** - the Presenter. A class that is easy to unit test.
