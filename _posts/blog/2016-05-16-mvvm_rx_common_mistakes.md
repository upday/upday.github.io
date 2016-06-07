---
published: false
---

MVVM + RxJava is a great formula for an app architecture, in upday we recognised this and used it in our app making it escalable and maintanable. But not all that giltters is gold and this decision also brought us some problems. In this post I'd like to **share a couple of mistakes we made while using this type of architecture and how to avoid them.**

## Expose states and not events

The core feature of upday is to show news to the user in a way that is easy to read and fluid, with this specification the ViewPager seemed a good choice, we could present the news in form of cards one after the other. Now, there are some more specific use cases we needed to cover that involve the following:
1. Scroll to certain position keeping the same elements in the ViewPager.
2. Replace or update the elements in the ViewPager but keep the actual position.
3. Replace/update the elements in the ViewPager AND reset the position.

Reading those requirements it seems very natural to have a stream with events for the position and different stream with events for the set of cards, it also feels right since RxJava is event driven. All we need to do is to expose this two streams in the ViewModel so the Fragment can subscribe to them and issue the received events to the adapter and/or ViewPager. In theory this should work, what could go wrong?

```java
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
                  .subscribe(mViewPager::setCurrentItem);
    }
    
    private Subscription subscribeToCardChanges() {
        return mViewModel.getSetOfCardsStream()
                         .observeOn(AndroidSchedulers.mainThread())
                         .subscribe(mAdapter::update);
    }

    @Override
    public void onPause() {
        mSubscription.clear();
        super.onPause();
    }
}

```

We did exactly this and we started receiving bugs reports that had to do with wrong end state of the ViewPager. Those bugs would usually have the so feared characteristic of not being 100% reproducible, they happen sometimes and there is no way to reproduce them in a consistent way. We had to face the crude reallity, we had race conditions but why? We have a neat architecture using MVVM, everything is JUnit tested in the ViewModel and we use RxJava to send events which is what is meant for.

The best way to explain what was happening is with an example. So imagine that we initially have a data set with 10 items in the ViewPager and the actual position is 5. Now, the user performs an action and the final expected state is to have 20 elements in the ViewPager centered in position 15. All the RxJava asynchronous magic triggers, we don't have any control over it, we just trust that everything is correctly set up and it somehow comes together in the end. But it doesn't. Actually the position stream emits a 15 before the data set stream emits the 20 elements. The position event is captured by the fragment that tells the ViewPager to move to the position 15 but it only has 10 elements, how can it move to position 15? so it simply ignores the command. It does not fail, it doesn't let you know in any way, it ignores you. Right after this the data set event comes, but it is too late already, even though the adapter is going to replace the data set the ViewPager is not going to be centered in the right position. This of course isn't always the case, sometimes the data set event will come first and everything will work as expected. This is due to the nature of RxJava, it is asynchronous, things are executed independently and the order can change from one execution to the next.

// Pictures with the events that explains the scenario described above.

After all it wasn't such a great idea to expose two separate streams with events. What should we do then? The answer is simple, **expose one stream per view that emits states of the view instead of events on how to modify the view**. Both the position and the data set should be wrapped up together so the view pager never receives one without the other. This is true for any view, you would never expose two separate streams for a TextView, one that sets the text and another one that emits the position of the letter that should be highlighted in bold, but for some reason it is more easy to make this mistake with ViewPager or lists.

## Everything goes through the ViewModel

Sometimes, upday receives breaking news in form of push notifications so the user can know immediately if something important happened in the world. The expected behavior when the user taps on the notification is to open upday and show the card for the breaking new. Practically this means to open top news fragment and center its ViewPager in the position of the breaking that is typically the first one so for simplicity in the example let's assume all we need to do is to set the position of the ViewPager to 0.

We have a mechanism to capture the actions of the user in the push notifications that transforms them into a Rx stream so, why not subscribe to it directly in the Fragment? The operation here is trivial, when the stream emits an event the ViewPager should just scroll to position 0, there is no logic or transformation between that needs to be JUnit tested.

```java
breakingNewStream
	.observeOn(AndroidSchedulers.mainThread())
    .subscribe(event -> mViewPager.setCurrentItem(0));
```

First of all, this is already breaking the previous rule of states instead of events since it is setting the position only. Even though we had a stream of ViewPager' states it would still be wrong. The reason is that in MVVM there are many things relying on what the ViewModel says the actual state is and in this case the ViewModel is not aware of what just happened in the ViewPager, it has no idea that the current position is 0. So the next natural step here would be notifify the ViewModel about what just happened.

```java
breakingNewStream
	.observeOn(AndroidSchedulers.mainThread())
    .subscribe(event -> {mViewPager.setCurrentItem(0);
    					 mViewModel.notifyCurrentPosition(0);});
```

At this point we can think we did a great job, we solved the issue, the ViewModel now knows what is going on and we can handle this state change properly. But the reality is quite different, by doing this we just shot ourselves in the foot. If we have or we are planning to have other  effects based on what the ViewModel thinks the ViewPager's state is what we just did introduced a race condition. There is a window of time where the ViewModel has been "notified" but the state is still not effective due to the asynchronous nature of Rx. (Should I elaborate a bit more here why there is a race condition? I am assuming it is clear that the other stuff relying on the ViewModel's state are also using Rx streams and the position change doesn't have to be propagated immediately).

The problem here is that we haven't followed the natural steps our MVVM architecture is meant for. The ViewModel transforms the data into something that is easy to use in the Views or any other consumer, this means **the View should know about the changes always after the ViewModel.** In this example the View knows about the changes before the ViewModel making the former unreliable. So basically, it doesn't matter how trivial or easy an operation is, **everything should go through the ViewModel**, this way other stuff that is based on the ViewModel's state can happen reliably.
