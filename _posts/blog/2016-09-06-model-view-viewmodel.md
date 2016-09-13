---
layout: post
title: "Model-View-ViewModel Pattern in Android"
description: Discover what Model-View-ViewModel is, how it should be implemented and some of its ups and downs.
modified:
categories: blog
author: florina_muntenescu
excerpt: Our choice for the upday app: the Model-View-ViewModel pattern. Find out what it is, how we applied it in Android and why do we consider it perfect for us.
tags: [Android, Architecture, MVVM]
date: 2016-09-04T15:39:55-04:00
---
After four different designs in the first six months from the first upday code line, we learned one important lesson: we need an architecture pattern that allows fast reaction at design changes! Our end solution was Model-View-ViewModel. Discover with me what MVVM is; how are we applying it in upday and what makes is so perfect for us.

## The Model-View-ViewModel Pattern

The main players in the MVVM pattern are:

* The *View* - that informs the ViewModel about the user's actions
* The *ViewModel* - exposes streams of data relevant to the View
* The *DataModel* - abstracts the data source. The ViewModel works with the DataModel to get and save the data.  

At a first glance, MVVM seems very similar to the Model-View-Presenter pattern because both of them do a great job in abstracting the view's state and behavior. But, if the Presentation Model abstracts a view independent from a specific user-interface platform, the MVVM pattern was created by Microsoft to simplify the event driven programming of user interfaces.

If, in the MVP pattern, the Presenter was telling the View directly what to display, in MVVM, ViewModel exposes streams of events to which the Views can bind to. Also, the Views are notifying the ViewModel about different actions. Therefore, the MVVM pattern supports two-way data binding between the View and ViewModel and there is many-to-one relationship between View and ViewModel. View has a reference to ViewModel but ViewModel has no information about the View.


/////// architecture diagram image

## Model-View-ViewModel In upday

A short look at the Android posts on the upday blog will easily tell you what our favorite library is: RxJava. So there's no wonder that RxJava is the backbone of upday's code. The event driven part required by MVVM is done using RxJava’s `Observable`s. Here's how we apply MVVM in upday, with the help of RxJava:

### DataModel

The DataModel exposes data easily consumable through event streams - RxJava's `Observable`s. It composes data from multiple sources, like the network layer, database or shared preferences; and exposes them to whoever needs it. The DataModels hold the entire business logic.

### ViewModel

The ViewModel is a model for the View of the app, an abstraction of the View. The ViewModel retrieves from the DataModel the necessary data, applies the UI logic and then exposes relevant data for the View to consume, together with behaviors for the View. Similar to the DataModel, the ViewModel exposes the data via `Observable`s.

We've learned two things about the ViewModel the hard way:

* The ViewModel should expose states for the View, rather than just events. For example, if we need to display the name and the email address of a `User`, rather than creating two streams for this, we create a `DisplayableUser` object that encapsulates the two fields. The stream will emit again, every time the display name or the email change. Like this, we ensure that our View always displays the current state of the `User`.

* Make sure that every action of the user goes through the ViewModel and that any possible logic of the View is moved in the ViewModel.

We shared more details about these two topics in a blog post about <a href="https://upday.github.io/mvvm_rx_common_mistakes">common mistakes in MVVM + RxJava</a>.  

### View

The View is the actual user interface in the app. It can be an `Activity`, a `Fragment` or any custom Android `View`. For `Activities` and `Fragment`s, we are binding and un-binding from the event sources on `onResume()` and `onPause()`.

{% highlight java %}
    private final CompositeSubscription mSubscription = new CompositeSubscription();

    @Override
    public void onResume() {
        super.onResume();
        mSubscription.add(mViewModel.getSomeData()
                         .observeOn(AndroidSchedulers.mainThread())
                         .subscribe(this::updateView,
                                    this::handleError));
    }

    @Override
    public void onPause() {
        mSubscription.clear();
        super.onPause();
    }
}
{% endhighlight %}

In case the MVVM View is a custom Android `View`, the binding is done in the constructor. To ensure that the subscription is not preserved, leading to possible memory leaks, the un-binding happens in `onDetachedFromWindow`.

{% highlight java %}
    private final CompositeSubscription mSubscription = new CompositeSubscription();

    public MyView(Context context,
									MyViewModel viewModel) {
				....
        mSubscription.add(mViewModel.getSomeData()
                         .observeOn(AndroidSchedulers.mainThread())
                         .subscribe(this::updateView,
                                    this::handleError));
    }

    @Override
    public void onDetachedFromWindow() {
        mSubscription.clear();
        super.onDetachedFromWindow();
    }
}
{% endhighlight %}

## Testability Of The Model-View-ViewModel Classes

One of the main reasons why we love the Model-View-ViewModel pattern is its high degree of testability.

### DataModel

Our strong emphasis on single responsibility principle leads to creating a DataModel for every feature in the app. For example, we have an ArticleDataModel that contains references to the API service and to the database layer. This DataModel handles the business logic ensuring that the latest news from the database are retrieved, by applying an age filter. The inversion of control pattern, heavily applied in our code, and the lack of any Android classes, make the DataModel easy to unit test.

### ViewModel

The ViewModel exposes streams of data to whoever needs to consume it, we see the Views and the unit tests as two different types of data consumers. 
The ViewModel is completely separated from the UI, therefore straightforward to unit test.
If the ViewModel needs access to Android classes, we create wrappers, that we call `Provider`s. For example, for resources, we created a `IResourceProvider`, that exposes methods like `String getString(@StringRes final int id)`. The implementation of the `IResourceProvider` will contain a reference to the `Context` but, the ViewModel will only get a reference to a `IResourceProvider`, injected.

### View

Given that the logic in the UI is minimal, the Views are easy to test with Espresso. We are also using libraries like DaggerMock and MockWebServer to help us better test the UI.

## Is MVVM The Right Solution?  

We've been using MVVM together with RxJava for almost a year now. We've seen that since the View is just a consumer of the ViewModel, then it was easy to just replace different UI elements, with minimum, to even zero, changes in other classes.

We've also learnt how important separation of concerns is, and that we should split the code more, creating small Views and small ViewModels, that only have specific responsibilities. Like this, when our UI requirements changed more, we could just replace some UI elements with new ones, with little changes in the Views that contain the small ones.  

## Conclusion

MVVM combines the advantages of separation of concerns, provided by MVP, while leveraging the advantages of data bindings. Therefore, the result is a pattern where the model drives as much as the operations as possible, minimizing the logic in the view.
For us, the way we implemented the Model-View-ViewModel pattern, helped us a lot
