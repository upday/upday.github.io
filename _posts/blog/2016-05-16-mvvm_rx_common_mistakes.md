---
published: false
---

MVVM + RxJava is a great formula for an app architecture, (insert more elaborated introduction here, something about how MVVM sepparates the logic from the views making the app more testable and something about Rx).

In this post I am going to talk about some of the most common mistakes that can be made while using MVVM + RxJava and how to avoid them.

## Expose states and not events

The core feature of upday is to show news to the user in a way that is easy to read and fluid, with this specification the ViewPager seemed a good choice, we could present the news in form of cards one after the other. Now, there are some more specific use cases we needed to cover that involve the following:
1. Scroll to certain position keeping the same elements in the ViewPager.
2. Replace or update the elements in the ViewPager but keep the actual position.
3. Replace/update the elements in the ViewPager AND reset the position.

Reading those requirements it seems very natural to have a stream with events for the position and different stream with events for the set of cards, it also feels right since RxJava is event driven. All we need to do is to expose this two streams in the ViewModel to the Fragment so it can subscribe to them and issue the received events to the adapter and/or the ViewPager. In theory this should work, what could go wrong?

// Some code of VM and Fragment

We did exactly this and we started receiving bugs from QA that had to do with wrong end state of the ViewPager. Those bugs would usually have the so feared characteristic of not being 100% reproducible, they happen sometimes and there is no way to reproduce them in a consistent way. We had to face the crude reallity, we had race conditions but why? We have a neat architecture using MVVM, everything is tested, we use RxJava to send events which is what is meant for.

The best way to explain what was happening is with an example. So imagine that we initially have a data set with 10 items in the ViewPager and the actual position is 5. Now, the user performs an action and the final expected state is to have 20 elements in the ViewPager and the position should be 15. All the RxJava asynchronous magic triggers, we don't have any control over it, we just trust that everything is correctly set up and it somehow comes together in the end. But it doesn't. Actually the position stream emits a 15 before the data set stream emits the data set with 20 elements. The position event is captured by the fragment that tells the ViewPager to move to the position 15 but it only has 10 elements, how on earth can it move to position 15? so it simply ignores the command. It does not fail, it doesn't let you know in any way, it ignores you. Right after this the data set event comes, but it is too late already, even though the adapter is going to replace the data set the ViewPager is not going to be centered in the right position. This of course isn't always the case, sometimes the data set event will come first and everything will work as expected. This is due to the nature of RxJava, it is asynchronous, things are executed independently and the order can change from one execution to the next.

// Pictures with the events that explains the scenario described above.

After all it wasn't such a great idea to expose two separate streams with events. What should we do then? The answer is simple, expose one stream per view that emits states instead of events. Both the position and the data set should be wrapped up together so the view pager never receives one without the other. This is true for any view, you would never expose two separate streams for a TextView, one that sets the text and another one that emits the position of the letter that should be highlighted in bold, but for some reason it is more easy to make this mistake with ViewPager or lists.


