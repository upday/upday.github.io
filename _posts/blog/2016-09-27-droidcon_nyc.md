---
layout: post
title: "Droidcon NYC 2016"
description: Deep knowledge from the best Android developers in the world.
modified:
categories: blog
author: florina_muntenescu
excerpt: Deep knowledge was shared by some of the best Android developers in the world at Droidcon NYC 2016. Here are some of the things we learned.
tags: [Conference, Architecture, MVC, MVP, MVVM, RecyclerView, ConstraintLayout]
date: 2016-09-27T10:39:55-04:00
---
I've just got back from Droidcon NYC were I have a talk on <a href="http://www.slideshare.net/FlorinaMuntenescu/a-journey-through-mv-wonderland-66570666">MV* architecture</a>, a topic we also started on the blog. While there, but also via the live stream, we got the chance to see more than sixty top developers from some of the most renowned companies, sharing their knowledge on the most interesting topics in Android today. Talks on subjects like performance, Material Design, architecture, deep understanding of different types of Views or Layouts and war stories were all gathered at Droidcon NYC in two intense days. Here are some of the talks, tips or libraries that we considered the most interesting. Until the videos are posted, we're providing the links to the slides, where available.


For an app like upday, that is pre-installed on Samsung devices, the **cold start time** is very important. Vikram Bodicherla from Yahoo gave some good tips about how to measure the startup time: using `SystemClock.elapsedRealTime()`; how to analyze the stack trace but also on what you can do to improve it: apply the *Most important pixel first* rule - display the most important area first.

Since we are currently starting to adopt **`RecyclerView`** in our app, there were two talks to help with it: *ListView -> RecyclerView* from Benjamin Jaeger, Facebook; and <a href="https://twitter.com/lisawrayz">Lisa Wray</a>'s talk on <a href="https://speakerdeck.com/lisawray/radical-recyclerview-droidcon-nyc-2016">Radical RecyclerView</a>. These two talks complement each other perfectly and give you the basics of what you need to know to start using RecyclerView. Two libraries on this topic are worth checking out: Genius's <a href="https://github.com/Genius/groupie">Groupie</a> and Airbnb's <a href="https://github.com/airbnb/epoxy">epoxy</a>.

If you and the **`ConstraintLayout`** are not friends just yet, then <a href="https://twitter.com/devunwired">David Smith</a>'s talk on <a href="https://speakerdeck.com/devunwired/constraintlayout-inside-and-out">ConstraintLayout, Inside and Out</a> is a must see.

<a href="https://twitter.com/danlew42">Dan Lew</a> gathered some great tips about writing *Efficient Android Layouts*. Check them out! Apply them, as soon as the video is out!

You have probably been implementing some of your own **custom views** and most likely you have been doing some things wrong. <a href="https://twitter.com/queencodemonkey">Huyen Tue Dao</a> tells you everything you need to know about <a href="https://speakerdeck.com/queencodemonkey/droidcon-nyc-2016-measure-layout-draw-repeat">Measure, Layout, Draw, Repeat: Custom Views and ViewGroups</a> in an interesting and easy to follow talk.

We've mentioned before how much we love **RxJava**, so there is no wonder that <a href="https://twitter.com/JakeWharton">Jake Wharton</a>'s talk on <a href="https://github.com/ReactiveX/RxJava/wiki/What's-different-in-2.0">RxJava 2.0</a> is high on our 'must-see' list. The slides can be found <a href="https://speakerdeck.com/jakewharton/looking-ahead-to-rxjava-2-droidcon-nyc-2016">here</a>

Even if RxJava is not your thing, there are some things that are a must to know about <a href="https://speakerdeck.com/erikhellman/multi-threading-concurrency-and-async-on-android">**multi-threading**, concurrency and async on Android</a> and <a href="https://twitter.com/ErikHellman">Erik Hellman</a> shared them.

## Wrap-Up
We loved Droidcon NYC 2016 and we are extremely honored to be part of it, alongside so many other great developers. We have learned a lot from the talks that we attended or seen via the live stream and we are sure you will too. Looking forward to Droidcon NYC 2017!

Send us a tweet at <a href="https://twitter.com/UpdayDevs">upday Dev</a> and tell us what your favorite talk was!

upday will also be present at Droidcon London 2016, with a lightning talk on <a href="https://skillsmatter.com/skillscasts/8695-optimising-the-performance-of-vectordrawables">optimising the performance of VectorDrawables</a>. We are hoping to see you there!
