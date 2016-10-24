---
layout: post
title: "Reactive Frustrations"
modified:
categories: blog
author: tomek_polanski
excerpt: See what frustrations you will encounter while using RxJava. Documentation, anonymous classes, forgetting to subscribe, are just some we've dealt with while using RxJava. Here's how we handled them.
tags: [RxJava, Android] 
image:
date: 2016-10-24T00:00:55-01:00
---

Most of us, who use Rx in daily projects, really enjoy it. That’s why we and so many others talk and write about Rx. Most material out there about Rx is aimed towards new adopters, to encourage them to give it a try.
This kind of material, introduces Rx in a really positive light, but like with everything, Rx is not unicorns and rainbows. It’s not a silver bullet, you will encounter things that will annoy you.

In this post, I would like to share some of our frustrations that we’ve encountered while using RxJava and show that despite that, it is an awesome tool, but there will be some bumps along the way.


### Documentation

When you are new to Rx, the first thing that you will do is to read the documentation.
In RxJava you will encounter this kind of documentation:

*Converts an `Observable` that emits `Observables` into an `Observable` that emits the items emitted by the most recently emitted of those `Observables`*.
<p align="right">
-  <i>switchOnNext</i>
</p>

It is completely accurate. For an experienced Rx developer, it is helpful. Unfortunately, a new adopter might be really confused.

Learning Rx is hard. I would encourage you to find an experienced developer that could explain things to you. <a href="http://rxmarbles.com/">RxMarbles</a> is also a useful tool to visualize the operator behaviors.


### Anonymous classes

This is not so much related to Rx, but rather about how we are used to developing for Android.
In the past we were fine with using anonymous inner classes like this:

{% highlight java %}
button.setOnClickListener(new View.OnClickListener() {
	@Override
	public void onClick(final View v) {
		Log.d("", "Hi");
	}
});
{% endhighlight %}

Before Rx, we didn’t need so many of them, but now almost every operator in RxJava requires a function.

Do yourself a favour and use either <a href="https://github.com/orfjackal/retrolambda">Retrolambda</a>, <a href="https://kotlinlang.org/">Kotlin</a> or <a href="https://source.android.com/source/jack.html">Jack</a> (when it’s ready):


{% highlight java %}
button.setOnClickListener(v -> Log.d("", "Hi"));
{% endhighlight %}


### Forgetting to subscribe

Time and time again, you write your reactive code and after you’re done, you will run your application.
Then the `Observable` won’t trigger. It won’t emit any event and you will wonder why.

The first thing you need to check is if you have subscribed to the `Observable`.

`Observables` are lazy, they will not emit events unless you subscribe.
Don’t feel too bad; forgetting to subscribe is a mistake made by both junior and senior Rx developers.


### Reasoning about the code

The biggest challenge when working with Rx is to understand the code, to know how it will behave at runtime.

How does the following code behave?

{% highlight java %}
Observable.combineLatest(first,
                         second,
                         (f, s) -> f + s)
          .subscribe(result -> Log.d("", result));
{% endhighlight %}


Here we combine the last emissions of `first` and `second` `Observables` and combine them.
Just by looking at this code, we do not know if the `Log.d` call will be ever executed.
`combineLatest` requires both `Observables` to emit at least one item. Here we would need to go up the stream for both source `Observables` to know if they would ever emit any event.

Here’s another example:

{% highlight java %}
Observable.concat(first, second)
          .subscribe(result -> Log.d("", result));
{% endhighlight %}


`concat` subscribes to `first` and emits its values. If `first` completes, then it would subscribe to `second` and do the same thing.
The question that we could ask here is: will elements from `second` be ever emitted?

This question is valid as we do not know if first will ever complete. Again we would need to check upstream to see how first is created to have the answer.

There are two approaches to tackle this problem: with types or with proper naming.
Here I will suggest our naming conventions.

In our current project, we use three main naming conventions:

* `...Once` - when there is only one value emitted and after that, the complete event will come (similar to `Single`)

* `...Stream` - the stream might emit values or might never emit any value, but we are sure that it never completes

* `...OnceAndStream` - the stream will emit value as fast as it can after subscription. After that, it might emit values, but it will never complete.

With this approach it’s way easier to reason about the code:

{% highlight java %}
Observable.combineLatest(firstOnce,
                         secondOnceAndStream,
                         (f, s) -> f + s)
          .subscribe(result -> Log.d("", result));
{% endhighlight %}

Here we can see that the `combineLatest` will for sure emit at least one value. Other example:

{% highlight java %}
Observable.concat(firstOnce, secondStream)
          .subscribe(result -> Log.d("", result));
{% endhighlight %}

And here we see that the `secondStream` will be subscribed to as `firstOnce` completes.

On the other hand, if we have code like this:

{% highlight java %}
Observable.concat(firstStream, secondStream)
          .subscribe(result -> Log.d("", result));
{% endhighlight %}

We know that something is not right as the `firstStream` will never complete and there is something wrong with this code.

Using these naming conventions with `Observables` and `Flowables` improve code clarity, but they should not be used with other Rx types like `Single`, `Completable`, and `Maybe`.


### `...map` operators

RxJava contains a massive amount of methods/operators. Among those operators, there are some that at the first glance look and behave the same way, but in reality, they should be used in different cases and could be easily misused.

`flatMap`, `switchMap`, and `concatMap`

If you do not know the difference, let me draw an analogy it:

At a developer conference, there are multiple speakers and one announcer.
The role of the announcer is to introduce speakers and to invite them on the stage. After speakers are introduced, they come on the stage and give their speech.

`flatMap`

In the case of `flatMap`, whenever the announcer decides, she invites a speaker on the stage. That means that she can allow multiple speakers on the stage, at the same time, resulting in a really noisy conference.

`switchMap`

The announcer could be a bit impatient. Whenever she chooses to invite a speaker, she will interrupt the current speaker on stage and ask them to stop. Next, she will invite a new speaker to take the floor. In this case, only one talk at a time is possible.

`concatMap`

With `concatMap`, the announcer is fair - she might want to invite a new speaker while the previous talk hasn’t finished, but she won’t. She will wait for the current one to finish, even if that speaker takes too long, and then will invite the next one. Again, only one speech at a time.

<br />

That’s it for now. Hope you’ve learnt something new and it will prevent you from repeating our mistakes.
Stay tuned for more in the next post.
