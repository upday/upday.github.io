---
layout: post
title: "Vector Drawables"
description: Here's how vector drawables work and what are their limitations
modified:
categories: blog
author: florina_muntenescu
excerpt: Before you replace all your images with vector drawables, here's how they work and what issues you might have with them.
tags: [Android, UI, Vector Drawables]
image:
date: 2016-06-27T15:39:55-04:00
---

## Yey, Android supports vector graphics!

While some mobile platforms have been supporting vector graphics for a while, Android began doing this natively only starting with API level 21 and with the help of the Support Library 23.2.0 for pre-Lollipop devices. Vector drawables allow creating drawables based on XML vector graphics. Like this, the number of resources added to the project decreases and therefore also the APK size. But, before you decide to replace absolutely every PNG in your app with a vector drawable, understand how they work, what limitations they have and how can you overcome some of them.

## How do vector drawables work

Vector graphics use geometrical shapes to describe graphical elements. The vector graphics are rendered at runtime. The automatic rendering at pixel density is the one that gives smoothness to the graphics, regardless of the device capabilities. Although the XML file containing the vector drawable is usually smaller than the PNG version, the vector drawables come with a computational overhead at runtime, which may be an issue for more complex graphical elements.


## Limitations of vector drawables


### Size matters

Since the vector graphics are rendered at runtime, the initial loading and drawing of a vector drawable will be slower. This is why Android recommends using them for images of max 200x200dp.

What exactly does "slower" mean and what's the difference between drawing a vector drawable and a PNG?  
In order to actually check how long the rendering takes we've tried several approaches.

1. Using System.currentTimeMillis()

We've created a MeasurableImageView, that overrides the ``onDraw()`` method allowing to compute how long the ``super.onDraw()`` took.

{% highlight java %}
@Override
protected void onDraw(final Canvas canvas) {
    long startTime = System.currentTimeMillis();

    super.onDraw(canvas);

    long endTime = System.currentTimeMillis();
    long duration = endTime - startTime;
}
{% endhighlight %}

Then, we added our MeasurableImageView to a layout and changed the image source and the image size for our tests. We used a Samsung Galaxy S7 as a test device.

Test 1: We set the image to match the size of the screen: 1440x1960px. The vector drawable took 16ms to draw, the PNG 0ms.
Test 2: We set the image to the maximum recommended: 200x200dp so, 800x800px. The vector drawable took 3ms to draw, the PNG 0ms.

The difference in rendering time is considerable.

2. Using TraceView

Hoping to get more clear results, we decided to use TraceView. We modified the overriden ``onDraw`` method, calling ``Debug.startMethodTracing`` before the ``super.onDraw`` and stopped the tracing with ``Debug.stopMethodTracing`` right after.

{% highlight java %}
@Override
protected void onDraw(final Canvas canvas) {
    Debug.startMethodTracing("vd");
    super.onDraw(canvas);
    Debug.stopMethodTracing();
}
{% endhighlight %}

We generated 2 traces: one after setting the vector drawable as image source and the other one after using a PNG. The interesting results come from analyzing the drawing time: ``VectorDrawable.draw`` took 22.669ms real time whereas ``BitmapDrawable.draw`` took only 0.180ms.

<center>
<picture>
	<img src="/images/blog/vector_drawables/trace_png.png" alt="TraceView of a PNG">
	<figcaption>Screenshot from TraceView results when using a PNG image</figcaption>
</picture>
</center>

<center>
<picture>
	<img src="/images/blog/vector_drawables/trace_vector_drawable.png" alt="TraceView of a vector drawable">
	<figcaption>Screenshot from TraceView results when using a vector drawable</figcaption>
</picture>
</center>

3. Using HierachyViewer

At the beginning we considered this a valid way of measuring the render time. But, after seeing <a href="https://twitter.com/queencodemonkey">Huyen Tue Dao<a/>'s talk at Droidcon Berlin 2016 about <a href="https://www.youtube.com/watch?v=gwqQT5NrhUg">loving lean layout<a/> where she mentions several times actually not to trust the numbers from the HierarchyViewer, we decided skip this.


### Multiple sizes, multiple renderings

When vector drawables are drawn for the first time, a cached bitmap is created in order to optimize the re-drawing performance. This cache is re-used as long as the width and the height of the image that needs to be drawn is the same. If a VectorDrawable is used for multiple sizes, a new Bitmap will be created every time and drawn. Therefore, the best approach in this case is to create VectorDrawables for every size needed.

In order to test this, we just allow our app to support both portrait and landscape orientation. Since the size of the view changes when changing the orientation, we can see that when rotating the device, drawing the vector drawable takes 15ms in portrait and 5ms in landscape, where the view is smaller.
In the same time, when the image is just re-used by different views, we can see that drawing the vector drawable takes 15ms only the first time, afterwards, drawing takes 0ms.  


### Supported tags

Not all VectorDrawable XML tags are supported for Android 5.0 and higher, but just a limited set:

<center>
<picture>
	<img src="/images/blog/vector_drawables/tags_support.png" alt="VectorDrawables tags supported">
	<figcaption>Supported tags. Image from Android developer pages. </figcaption>
</picture>
</center>

But, the Support Library 23.2.0 and higher is offering full support for VectorDrawable XML elements.


### Resource references in VectorDrawable XML

In case you want to support referencing other resources in the VectorDrawable XML like this:

{% highlight XML %}
android:fillColor="@color/colorPrimary"
{% endhighlight %}

Be aware that only Android 5.0 and higher supports dynamic attributes.
Setting this will result in black areas instead of your desired color, on pre-API level 21 devices.

<center>
<picture class="half">
	<img src="/images/blog/vector_drawables/dynamic_res_21.png" alt="Dynamic attributes on API level 21">
	<figcaption>Dynamic attributes used on API level 21</figcaption>
</picture>
</center>

<center>
<picture>
	<img src="/images/blog/vector_drawables/dynamic_res_19.png" alt="Dynamic attributes on API level 19">
	<figcaption>Dynamic attributes used on API level 19</figcaption>
</picture>
</center>

To still change the color of your vector drawable dynamically, the solution is simple: tint your images.  

{% highlight XML %}
android:tint="@color/colorAccent"
{% endhighlight %}

Just make sure that your vector drawable is black for the path that needs to be drawn and transparent for the rest. Otherwise you might end up with unexpected colors.

### Vector Drawable preview in Android Studio looks skewed

The Vector Drawable preview either in the import preview or in the file preview might look skewed. But, don't be scared, chances are it might look good when the app is run on the device. So, make sure your check them on the device first and only change them if needed.

## Conclusion

Vector Drawables are the best way of compressing your images and reducing your APK size. But before you start replacing all your PNGs keep in mind that the first time the image is drawn will be longer. The rest of the possible issues with Vector Drawables are minor and easy to overcome, comparing to the gain of using them.

If you want to learn more about Vector Drawables here are some interesting resources:

<a href="https://developer.android.com/studio/write/vector-asset-studio.html">Adding multi-density vector graphics in Android Studio<a/>
<br/>
<a href="https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.ultiul691">Vector drawables and AppCompat</a>
<br/>
<a href="https://www.youtube.com/watch?v=r_LpCi6DQME">Colt McAnlis's talk on image compression at Google I/O 2016</a>
