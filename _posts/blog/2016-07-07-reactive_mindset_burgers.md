---
layout: post
title: "Building a Reactive Mindset"
description: Building a Reactive Mindset with the help of Donald Duck and his nephews.
modified:
categories: blog
author: florina_muntenescu
excerpt: What do Donald Duck and reactive programming have in common? Burgers! Check out why.
tags: [Android, RxJava]
date: 2016-07-19T15:39:55-04:00
---
Here's another way of explaining reactive programming: this time with Donald Duck and his nephews.

## Donald Duck and His Little Helpers

Donald Duck decided to switch from cinema to the food industry and open up a burger joint. But, he's not doing this alone; his three nephews - Huey, Dewey and Louie - are helping him. Each of them is doing exactly one thing:

* Huey gives Donald Duck buns.
* Dewey gives Donald Duck pieces of raw meat
* Louie gives Donald slices of tomatoes

<center>
<picture>
	<a href="/images/blog/reactive_mindset_burgers/nephews.png"><img src="/images/blog/reactive_mindset_burgers/nephews.png" alt="Huey, Dewey and Louie" width="350"></a>
	<figcaption>Huey, Dewey and Louie</figcaption>
</picture>
</center>

As soon as the restaurant opens, the nephews start working, continuously supplying Donald with buns, meat and tomato slices.

With every new piece of meat that Donald gets, he first needs to make sure that the meat hasn't gone bad, and use only the fresh meat for his burgers. Then, every piece of fresh meat needs to be cooked.

<center>
<picture>
	<a href="/images/blog/reactive_mindset_burgers/filter_map_meat.png"><img src="/images/blog/reactive_mindset_burgers/filter_map_meat.png" alt="filter and map" width="350"></a>
	<figcaption>Filter the meat pieces and cook them</figcaption>
</picture>
</center>

The next step is to make the burger. Donald needs to take the first bun given by Huey, together with the first piece of cooked meat and with the first slice of tomato given by Louie and then "zip" together the first burger.

For the second burger, he will use the second bun from Huey, the second piece of cooked meat and the second slice of tomato. The processing time took by each of the nephews is different. Louie will be providing tomato slices faster than Dewey can cook the meat. As a result, Donald has to wait for it to be ready, in order to make the burger. Because he doesn't want to throw away any tomato slices, he will always use the first one on the row, given by Louie.

<center>
<picture>
	<a href="/images/blog/reactive_mindset_burgers/zip_burgers.png"><img src="/images/blog/reactive_mindset_burgers/zip_burgers.png" alt="zip burgers" width="350"></a>
	<figcaption>Combine the bun, the meat and the slice of tomato to make the burger</figcaption>
</picture>
</center>

## ReactiveX and Buns, Meat & Tomato Slices

In ReactiveX the buns, tomato slices and the meat are streams of data. By composing multiple streams we create a new one, composed of burgers. The class that emits a stream of data is called ``Observable``. So this means that we will have an ``Observable`` of buns, an ``Observable`` of meat, an ``Observable`` of tomato slices and in the end, an ``Observable`` of burgers.

<center>
<picture>
	<a href="/images/blog/reactive_mindset_burgers/streams_of_data.png"><img src="/images/blog/reactive_mindset_burgers/streams_of_data.png" alt="streams of data" width="350"></a>
	<figcaption>The buns, pieces of meat, slices of tomato and the burgers are streams of data</figcaption>
</picture>
</center>

Donald Duck's customer, Mickey Mouse, he gets to consume the burger. So, Mickey Mouse is the one that acts upon the emitted items by the burger ``Observable``. In ReactiveX, this is the ``Subscriber`` class.

The actions performed on the streams: filtering the meat that has gone bad and cooking the meat - so applying a function to every element of the stream - are called ``operators``.

When developing using ReactiveX you have to switch from a pull based approach to a push based one. In this example, Donald Duck does not pull buns from Huey. He does not request buns. Rather, Donald is just waiting for buns that are pushed to him by his nephew.

<center>
<picture>
	<a href="/images/blog/reactive_mindset_burgers/pull_bun.png"><img src="/images/blog/reactive_mindset_burgers/pull_bun.png" alt="pull based development" width="350"></a>
	<figcaption>Donald Duck doesn't request buns from Huey</figcaption>
</picture>
</center>

We don't have an exact set of data that we can operate on, but rather we operate on each emission of a stream. This means that if we want to work only on fresh meat, we cannot do:
{% highlight java %}
for(Meat meat: meatList){
    if(isMeatFresh(meat)){
        meatList.remove(meat);
    }
}

{% endhighlight %}
because we don't have that ``meatList``. We have an ``Observable`` that emits meat pieces and from those, we are only interested in cooking the pieces that have not gone bad, the others need to be ``filter``ed out.
{% highlight java %}
Observable.from(meatSource)
          .filter(meat -> isMeatFresh(meat))
{% endhighlight %}

Similar, when we want to cook the meat, we cannot just apply a function to a set of data, because we don't have that set of data.
{% highlight java %}
for(Meat meat: meatList){
    meat = cook(meat);
}
{% endhighlight %}

But what we can do, is to apply a function to every emission of the filtered meat stream, by using the ``map`` operator.
{% highlight java %}
Observable.from(meatSource)
          .filter(meat -> isMeatFresh(meat))
          .map(meat -> cook(meat));
{% endhighlight %}

## Make a Reactive Burger

Huey, Dewey and Louie create three ``Observable``s: ``bunObservable``, ``meatObservable`` and the ``tomatoObservable``. Donald will create the ``burgerObservable``:
{% highlight java %}
Observable<Burger> burgerObservable =
	Observable.zip(bunObservable,
                  meatObservable,
                  tomatoObservable,
                  (bun, meat, tomato) -> makeBurger(bun, meat, tomato));
{% endhighlight %}
The ``zip`` operator is the one that will one that will combine the emissions of each ``Observable``: a bun, a meat and a tomato slice. In order to do that, it needs to know how to make the burger using the three ingredients. This is defined in the ``makeBurger`` method.

## Mickey Mouse Gets His Burger

If Donald Duck is the one that produces burgers and Mickey Mouse is the one that consumes it, how do the they get to Mickey?? This is done using the ``subscribe`` method.
{% highlight java %}
burgerObservable.subscribe(mickeySubscriber);
{% endhighlight %}
Like this, we are saying that every emission of the burgerObservable should be handled by mickeySubscriber.

Mickey Mouse knows how to handle three situations:

* ``onNext(Burger burger)`` - what to do when he gets a burger.
* ``onError(Throwable error)`` - what to do in case of an error, for example, when the burger was burned.
* ``onComplete()`` - what to do when the nephews have gone home for the day.

In code, this would look like this:
{% highlight java %}
burgerObservable.subscribe(
		        burger -> eatBurger(burger), //onNext
		        error -> complain(error), //onError
		        () -> leaveBurgerJoint()); //onComplete
{% endhighlight %}
Every time Mickey Mouse gets a new burger, he will eat it. Whenever something bad happened with the burger, Mickey will complain. When there are no more burgers to be eaten, Mickey Mouse will leave the burger joint.

## Dining Area vs. Kitchen
Overall, the burger making and consuming would look, in RxJava, like this:

{% highlight java %}
Observable.zip(bunObservable, meatObservable, tomatoObservable,
     	          (bun, meat, tomato) -> makeBurger(bun, meat, tomato))
	  .subscribe(burger -> eatBurger(burger),
		     error -> complain(error));
{% endhighlight %}

Mickey Mouse orders the burger in the dining area of the restaurant. By default, in ReactiveX, the event stream would be processed on the same thread. So, this means that the preparation of the burger would also happen in the dining area. But this should actually happen in the kitchen! This also allows Donald Duck to make more burgers while Mickey Mouse eats his burger - so this happens in parallel.
ReactiveX provides two methods that allow defining on which thread the operations should be executed and on which thread the result should be handled: ``observeOn`` and ``subscribeOn``.
Donald Duck prepares the burger in the kitchen: ``subscribeOn(kitchen)``. Mickey Mouse eats the burger in the dining area: ``observeOn(dining area)``.
The "kitchen" should be a background thread and the "dining area" should be the UI thread.

{% highlight java %}
Observable.zip(bunObservable, meatObservable, tomatoObservable,
     	        (bun, meat, tomato) -> makeBurger(bun, meat, tomato))
	  .subscribeOn(Schedulers.computation())
	  .observeOn(AndroidSchedulers.mainThread())
	  .subscribe(burger -> eatBurger(burger),
		     error -> complain(error));
{% endhighlight %}

## Reactive Burger Conclusion

Replace the burger joint with your own context; Huey, Dewey, and Louie with your own data sources; the buns, the meat and the tomato slices with your own model data. The concepts are still the same - streams of data that are fairly easy to manipulate and to compose, at the same time, being able to handle the working threads. The ReactiveX implementations of reactive programming in Java, JavaScript, Swift or C# work great for both backend and frontend and offer a paradigm that can be used when programming any event-driven software. We, at upday, love it on Android!
