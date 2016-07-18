---
layout: post
title: "MVVM + RxJava: Common mistakes"
modified:
categories: blog
author: lucia_payo
excerpt: Issues to take into account when using MVVM + RxJava architecture
tags: [RxJava, MVVM]
image:
date: 2016-07-17T15:39:55-04:00
---

MVVM + RxJava is a great formula for an app architecture. At upday we recognised this and used it in our app, making it scalable and maintainable. Despite this, we’ve had to learn a few lessons the hard way.

In this blog post, I’ll be sharing two of these learnings using the actual specific scenarios that  inspired them. As a result, I’ll be drilling right down into the details of the code. Now, if you’re a little short on time, here are the two take-ways:

1. **Expose states instead of events.**
2. **Everything should go through the view model.**

If you’re ready to learn more about the “how and why”, let’s go!

## Expose states and not events

The core feature of upday is to show news to the user in a way that is easy to read and fluid. With this specification the ViewPager seemed a good choice, we could present the news in form of cards one after the other. More specifically we need to implement the following behaviors:

1. Scroll to a certain position.
2. Replace/update the elements in the ViewPager.
3. Replace/update the elements in the ViewPager AND scroll to a certain position.

Reading those requirements it seems very natural to have an Rx stream with the position and a different Rx stream with the set of cards. All we need to do is to expose these two streams in the view model so the Fragment can subscribe to them and issue the received events to the adapter and/or ViewPager.

So this is the plan: do the processing of the position and the data set separately in background threads inside the view model, expose these streams and subscribe to them in the Fragment, switch to the main thread only to receive the events and modify the views. In theory this should work, we are separating business logic from framework related logic pretty well, we are making the Fragment very dumb so we can unit test most of the logic via the view model. We are also doing all the processing in background threads, only using the main thread when is necessary. What could go wrong?

{% highlight java %}
public class NewsFragment extends Fragment {

    private NewsViewModel mViewModel;
    private ViewPagerAdapter mAdapter;
    private ViewPager mViewPager;
    private final CompositeSubscription mSubscription = new CompositeSubscription();

    // Set up fragment (onCreate, etc.)

    @Override
    public void onResume() {
        super.onResume();
        mSubscription.add(subscribeToPositionChanges());
        mSubscription.add(subscribeToCardChanges());
    }

    private Subscription subscribeToPositionChanges() {
        return mViewModel.getPositionStream()
                         .observeOn(AndroidSchedulers.mainThread())
                         .subscribe(mViewPager::setCurrentItem,
                                    this::handleError);
    }

    private Subscription subscribeToCardChanges() {
        return mViewModel.getSetOfCardsStream()
                         .observeOn(AndroidSchedulers.mainThread())
                         .subscribe(mAdapter::update,
                                    this::handleError);
    }

    @Override
    public void onPause() {
        mSubscription.clear();
        super.onPause();
    }
}

{% endhighlight %}

We did exactly this and started receiving bug reports indicating a wrong end state in the ViewPager. Those types of bugs usually have the feared characteristic of not being 100% reproducible. We had to face the brutal reality: we had race conditions, but why? We have a neat architecture using MVVM, everything is unit tested and we use RxJava to send events.

The best way to explain what was happening is with an example. So imagine that we initially have a data set with 5 items in the ViewPager and the actual position is 3.
<center>
<picture>
<img src="/images/InitialState.png" width="1000">
</picture>
</center>
Now, the user performs an action and the final expected state is to have 9 elements in the ViewPager centered at position 7. All the RxJava events trigger after the user action, **we don't have any control over when things happen**, naïvely, we just sit there and hope that everything is setup correctly and, somehow, it comes together in the end. But it doesn't. Actually in some cases the position stream emits a 7 before the data set stream emits the 9 elements. The position event is captured by the fragment that tells the ViewPager to move to the position 7 but it only has 5 elements, how can it move to position 7? It can’t, so it simply ignores the command. It does not fail, it doesn't let you know in any way.
<center>
<picture>
<img src="/images/PositionEmits.png" width="1000">
</picture>
</center>
Right after this the data set event comes, but it is too late already, even though the adapter is going to replace the data set the ViewPager is not going to be centered in the right position.
<center>
<picture>
<img src="/images/DataSetEmits.png" width="1000">
</picture>
</center>
Of course, this isn't always the case, sometimes the data set event will come first and everything will work as expected. This is due to the asynchronous nature of our architecture. The view model is doing the processing of the data in background threads so when the user action comes, the position and the data set will be processed with no guarantee of which will finish first.

After all it wasn't such a great idea to expose two parallel streams with events. What should we do then? The answer is simple, **expose one stream per view that emits states instead of events**. Both the position and the data set should be wrapped up together so the ViewPager never receives one without the other. This is true for any view with intradependent state. You would never expose two separate streams for a TextView, one that sets the text and another one that emits the position of the letter that should be highlighted in bold, but for some reason it’s much easier to make this mistake with a ViewPager or lists.

## Everything goes through the view model

Sometimes upday receives breaking news in the form of push notifications so the user can know immediately that something important happened in the world. The expected behavior when the user taps on the notification is to open upday and show the card for the breaking news. Practically this means to open the top news Fragment and center its ViewPager in the position of the breaking news. Typically this type of news is placed in the first position, so for simplicity’s sake let's assume all we need to do is to set the position of the ViewPager to 0.

We have a mechanism to capture the actions of the user in the push notifications that transforms them into a Rx stream so, why not subscribe to it directly in the Fragment? The operation here is trivial: when the stream emits an event the ViewPager should just scroll to position 0, there is no logic or transformation in-between that needs to be unit tested.

{% highlight java %}
breakingNewsStream().observeOn(AndroidSchedulers.mainThread())
                    .subscribe(event -> mViewPager.setCurrentItem(0),
                               this::handleError);
{% endhighlight %}

First of all, this is already breaking the previous rule of states instead of events since it is setting the position only, but even though we had a stream of ViewPager's states it would still be wrong. The reason is that the view model is not aware of what just happened and we could have other things relying on what the view model says the current state is. So the next natural step here would be to notify the view model about what just happened.

{% highlight java %}
breakingNewsStream().observeOn(AndroidSchedulers.mainThread())
                    .subscribe(event -> {
                                   mViewPager.setCurrentItem(0);
                                   mViewModel.notifyCurrentPosition(0);
                               },
                               this::handleError);
{% endhighlight %}

At this point we could think we did a great job, we solved the issue. The view model now knows what is going on and we can handle this state change properly. But again the reality is quite different and by doing this we have just shot ourselves in the foot. If we ever were to add other effects based on what the view model thinks the ViewPager's state is, then we have again created a race condition. There is a window of time where the view model has been "notified" but the state has not yet been processed due to the asynchronous nature of the events.

The problem here is that we haven't followed the natural pattern of our MVVM architecture. The view model transforms the data into something that is easy to use in the Views or any other consumer, this means **the view should know about the changes always after the view model.** In this example the View knows about the changes before the view model, making the later unreliable.

So basically, it doesn't matter how trivial or easy an operation is, **everything should go through the view model,** this way other stuff that is based on the view model’s state can happen reliably.
