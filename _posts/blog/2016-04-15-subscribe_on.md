---
layout: post
title: "RxJava: subscribeOn vs observeOn"
modified:
categories: blog
author: tomek_polanski
excerpt:
tags: [RxJava]
image:
date: 2016-04-14T13:00:55-01:00
---


## RxJava: subscribeOn vs observeOn

One of the strongest aspects of RxJava is the simple way to schedule work on a desired thread using either ``subscribeOn`` or ``observeOn``. While they seem simple enough at a glance, understanding how they work is crucial to achieving your desired threading assignment.  


### observeOn:
This method simply changes the thread of all operators further **downstream** (in the calls that come after). Let’s assume code is run from a UI thread: 

<picture>
	<img src="/images/ObserveOn.gif" alt="image">
</picture>

One of the most frequent misconceptions is that ``observeOn`` also acts upstream, but really it acts only downstream - things that happen after the ``observeOn`` call - unlike ``subscribeOn``.  

### subscribeOn:
This only influences the thread that is used when the ``Observable`` is subscribed to and it will stay on it downstream.  


``` java
just("Some String") // Computation
.map(str -> str.length()) // Computation
.map(length -> 2 * length) // Computation
.subscribeOn(Schedulers.computation()) // -- changing the thread
.subscribe(number -> Log.d("", "Number " + number)); // Computation
```
<br />
**Position does not matter**

``subscribeOn`` can be put in any place in the stream because it affects only the time of subscription. For example, the code from above is equal to this one:

``` java
just("Some String") // Computation
    .subscribeOn(Schedulers.computation()) // note the different order
    .map(str -> str.length()) // Computation
    .map(length -> 2 * length) // Computation
    .subscribe(number -> Log.d("", "Number " + number)); // Computation
```
<br />
**Methods that obey the contact with ``subscribeOn``** 

The most basic example is ``Observable.create``. All the work specified inside ``create`` body will be run on the thread specified in ``subscribeOn``. 

Another example is ``Observable.just``, ``Observable.from`` or ``Observable.range``.  It is important to note that all of those methods accept values, so do not use blocking methods to create those values, as ``subscribeOn`` won’t affect it! 
If you want to use a blocking function, use ``Observable.defer`` as it accepts functions that will be evaluated lazily:
``` java
Observable.defer(() -> Observable.just(blockingMethod()));
```

One important fact is that ``subscribeOn`` does not work with ``Subject``s.  (We will return to this in a future post).  

<br />
**Multiple subscribeOn** 

If there are multiple instances of ``subscribeOn`` in the stream,  only the first one will be used:

``` java
just("Some String")
    .map(str -> str.length())
    .subscribeOn(Schedulers.computation()) // changing to computation
    .subscribeOn(Schedulers.io()) // won’t change the thread to IO
    .subscribe(number -> Log.d("", "Number " + number)); 
```
<br />
**``Subscribe`` and ``subscribeOn``** 

People think that ``subscribeOn`` has something to do with ``Observable.subscribe``, but really it does not have anything special to do with it.  Remember, it only affects the subscription phase!

<br />

Knowing how ``subscribeOn`` and ``observeOn`` work, makes the Rx code much more easy to reason with. This understanding will allow you to use it correctly which should give you predictable results in your threading allocations.


