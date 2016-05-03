---
layout: post
title: "Droidcon Zagreb 2016"
modified:
categories: blog
author: florina_muntenescu
excerpt: An overview of the things learned and best talks at Droidcon Zagreb 2016
tags: [Conference, RxJava, MVVM]
image:
date: 2016-05-2T15:39:55-04:00
---

Going to conferences is great - you get to learn new things and meet new people. But going as a speaker is even better! It feels like you’re doing your duty as a good developer and also give something back to the community. This is something that we want to do more at upday!


## Interesting topics and talks

Here’s an overview of some of the most interesting things I’ve learned at Droidcon Zagreb. Make sure you checkout the presentations linked.

The first day’s keynote from Wojtek Kaliciński brought a lot of insights into what’s new in Android Studio, in Google Play and about what we can expect from Android N. Google Play has a lot of features that most of the developers probably don’t know about. One example would be <a href="https://developers.google.com/analytics/devguides/collection/android/v4/">Google Analytics</a> that has a large range of tracking related functionalities, improved even more in Android N. Google offers a wide range of <a href="https://developers.google.com/products/">services for developers</a>. Make sure you check those out before you decide on any other 3rd party tools.
<br>For anyone that wonders how they should architect their projects, Google has <a href="https://github.com/googlesamples/android-architecture">Android architecture samples</a> in their GitHub repo. Examples using popular libraries like Dagger 2 and RxJava are also included.
<br>Although the preview of Android N was already released and some of its features already made public in the <a href="http://developer.android.com/preview/behavior-changes.html">behavior changes page</a>, it was great hearing more about them. The system activity restrictions brought by Doze, now have two stages and are for sure something to keep in mind when developing applications that need to run background tasks and handle Google Cloud Messages.
<br>Another important feature that developers should to pay attention to is the <a href="http://developer.android.com/preview/features/multi-window.html">multi-window support</a>. This was also again strongly emphasized by <a href="http://www.hellsoft.se/">Erik Hellman</a> in his <a href="https://speakerdeck.com/erikhellman/10-common-mistakes-that-android-developers-do">keynote</a> in the 2nd day of the conference.
The system forcibly resizes the app unless the app declares a fixed orientation, meaning that your app needs to look good in both portrait and landscape and the activity lifecycle calls have to be handled properly.

One of the most popular topics in this year’s Droidcon Zagreb was RxJava.  The talks targeted different levels of RxJava and showed how to use it also in combination with patterns such as Model-View-Presenter or Model-View-ViewModel, and libraries like Dagger 2.
Other interesting presentations covered topics like <a href="http://www.slideshare.net/AnaBaotic/safety-first-best-practices-in-app-security">security</a>,
basic elements that should be dealt with when <a href="http://www.slideshare.net/dpreussler/all-around-the-world-localization-and-internationalization-on-android-droidcon-zagreb">supporting multiple languages</a>
and building a translation pipeline. Development flow was also discussed from different angles: from tools, to <a href="https://speakerdeck.com/reisub/continuous-integration-and-deployment-on-android-plus-some-sweets">continuous integration</a> and best development practices.

It was wonderful representing upday as a speaker and being able to share the main concepts that drive the development of our app: <a href="
http://www.slideshare.net/FlorinaMuntenescu/mvvm-and-rxjava-the-perfect-mix-61526418">the Model-View-ViewModel pattern and RxJava</a>.

## Summary

The overall atmosphere of Droidcon Zagreb was great. The organizers did a good job in promoting interaction between all the participants of the conference, nurturing sharing and learning. Looking forward to Droidcon Zagreb 2017!
