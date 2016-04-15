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

One of the strongest side of RxJava is seemingly easy way to schedule work on desired thread using subscribeOn or observeOn. Understanding how each one works is crucial.

### observeOn:
This method simply changes the thread of all operators down in the stream (in the calls that come after), let’s assume code is run from UI thread: 
<picture>
	<img src="/images/ObserveOn.gif" alt="image">
	<figcaption>ObservOn</figcaption>
</picture>
One of most frequent misconceptions is that observeOn also affects upstream, but really it affects only down stream, things that happen after observeOn call,  not like subscribeOn.

### subscribeOn:
This one only influences the thread that is used when observable is subscribed to and it will stay on it until changed.  
One important fact is that subscribeOn does not work with Subjects.  About it in another post.  

``` java
just("Some String") // Computation
.map(str -> str.length()) // Computation
.map(length -> 2 * length) // Computation
.subscribeOn(Schedulers.computation()) // -- changing the thread
.subscribe(number -> Log.d("", "Number " + number)); // Computation
```

**Position does not matter**
subscribeOn can be put in any place in the stream because it affects only the time of subscription. For example,  the code from before is equal to this one:

``` java
just("Some String") // Computation
    .subscribeOn(Schedulers.computation()) // the difference
    .map(str -> str.length()) // Computation
    .map(length -> 2 * length) // Computation
    .subscribe(number -> Log.d("", "Number " + number)); // Computation
```

**Methods that work with subscribeOn** 

The most basic example is Observable.create,  all the work specified inside create body will be run on thread specified in subscribeOn. 

Another example is Observable.just, Observable.from or Observable.range.  One big remark,  all of those methods accepts values,  so do not use bocking methods to create those values as subscribeOn won’t affect it! 
If you want to use blocking function,  use Observable.defer as it accepts function that will be evaluated lazily:
``` java
    Observable.defer(() -> Observable.just(blockingMethod()));
```

**Multiple subscribeOn** 

If there are multiple subscribeOn the stream,  only the first one will be used:

``` java
just("Some String")
    .map(str -> str.length())
    .subscribeOn(Schedulers.computation()) // changing to computation
    .subscribeOn(Schedulers.io()) // won’t change the thread to IO
    .subscribe(number -> Log.d("", "Number " + number)); 
```

**Subscribe and subscribeOn** 

People think that subscribeOn has something to do with Observable.subscribe, but really it does not have anything special to do with it.  Remember it only affects subscription phase!


Ability to change the execution thread so easily is a great thing to have. Still it needs to be used responsibly as it could cause more harm than good if used irresponsibly.  
