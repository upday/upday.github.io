---
layout: post
title: "Animations and Touch Events"
description: View animations vs property animations and touch events handling
modified:
categories: blog
author: florina_muntenescu
excerpt: Did you ever had problems with touch events on views after they were animated? Here's why.
tags: [Android, Animations, Touch Events]
image:
date: 2016-05-20T15:39:55-04:00
---

Android offers two main animation frameworks: **view animation** and **property animation**. Each of these is fairly easy to implement. However, the main difference can be seen when you need to handle touch events on views that have changed their position after animation. Let’s see how both of these animation frameworks work, how they can be implemented and which one you should use for touch events.

## Task
When tapping a ``View``, we need to translate it up by 75% of its height. When tapping on the area where the ``View`` was initially, our ``View`` should slide back down.

<center>
<iframe width="250" height="444" src="/videos/animations_touch/slide_animations.mp4"></iframe>
<figcaption>Translate a view up and down by 75%.</figcaption>
</center>

## View Animations

**View animations** provide an easy to use API for animating the contents of a view object. This framework supports translation, rotation, growing and shrinking of a view. You can define these animations either in XML or programmatically.

The implementation of the view translation animation in **XML** contains the following in the animation resource file:

{% highlight XML %}
<set android:fillAfter="true"
     android:shareInterpolator="false">
    <translate
        android:duration="@android:integer/config_longAnimTime"
        android:fromAlpha="0.0"
        android:fromXDelta="0%"
        android:fromYDelta="0%"
        android:toAlpha="1.0"
        android:toXDelta="0%"
        android:toYDelta="-75%" />
</set>
{% endhighlight %}

Then then animation needs to be loaded in the code.
{% highlight java %}
Animation animation = AnimationUtils.loadAnimation(getContext(), R.anim.translate_up);
view.startAnimation(animation);
{% endhighlight %}

Translating a view **programmatically** requires defining the animation and just calling start on the view that needs to be animated.
{% highlight java %}
TranslateAnimation animation = new TranslateAnimation(0, 0, 0, toYDelta);
animation.setFillAfter(true);
animation.setDuration(getResources().getInteger(android.R.integer.config_longAnimTime));
view.startAnimation(animation);
{% endhighlight %}
Where the ``toYDelta`` is the change in Y axis that needs to be applied.

## Property Animations

The **property animation** framework was introduced in Android 3.0 and allows the animation of any object, not just ``View``s. It offers a broader function scope - for example, the background color of a ``View`` can also be animated - and has a slightly better performance than the view animations.

Implementing a view translation can be easily done programmatically.
{% highlight java %}
view.animate().translationYBy(animateByPx);
{% endhighlight %}
Where the ``animateByPx`` is the amount of pixels the view is translated on the Y axis.

## Handling Touch Events

The main difference between view and property animations lies in whether the ``View`` is modified or not. With view animations, the ``View`` gets drawn in another position, but the actual ``View`` does not move. So, this means that the view will not react to touch events on the area where it is drawn, but rather in the area where it was before the animation started.
With property animations, the object actually gets moved. Therefore it will react to touch events on its new location on the screen.

For a better understanding on how the touch area changes, we have implemented a selector for our ``View``’s background, allowing us to set two different colors depending on the pressed state of the view: pink for pressed and blue for not pressed.

Here's what happens after translating the ``View`` using view animations: when touching the area that is above the original location of the ``View``, the ``View`` does not react. The touch events are caught by the area outside it.
<center>
<iframe width="250" height="444" src="/videos/animations_touch/view_animation_touch_outside.mp4"></iframe>
<figcaption>Touch events on the new position of the view, after a view animation was applied.</figcaption>
</center>

When touching the area containing the initial position of the ``View``, we see that the area of the ``View``that is still drawn over the original position reacts to our touch events.
<center>
<iframe width="250" height="444" src="/videos/animations_touch/view_animation_touch_old_location.mp4"></iframe>
<figcaption>Touch events on the initial position of the view, after a view animation was applied.</figcaption>
</center>

With the property animations implementation we see that the ``View`` reacts to touch events exactly as expected, no matter where the touch events happen.
<center>
<iframe width="250" height="444" src="/videos/animations_touch/property_animation.mp4"></iframe>
<figcaption>Touch events with property animations.</figcaption>
</center>

## Conclusion

Both view and property animations are easy to implement. Use the one that’s more convenient for you, but when needing to implement touch events on a ``View`` that was already animated, you should use **property animations**.

Check out the implementation of view and property translation animations in this <a href="https://github.com/florina-muntenescu/Playground">GitHub repo</a>.
See the <a href="https://developer.android.com/guide/topics/graphics/view-animation.html">view animation</a> and <a href="https://developer.android.com/guide/topics/graphics/prop-animation.html">property animation</a> Android API guides for detailed information.    
