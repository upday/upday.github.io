---
layout: post
title: "Optimizing Vector Drawables"
description: This is how vector drawables work and how to optimize them
modified:
categories: blog
author: florina_muntenescu
excerpt: You have replaced all image resources in your app with VectorDrawables - your APK is smaller and your images look better. But are you really using them correctly? Here are three mistakes that you might be doing and how to fix them, right now. Because &#35;PERFMATTERS.
tags: [Android, UI, Vector Drawables]
image:
date: 2016-10-08T00:39:55-04:00
---

While some mobile platforms have been supporting vector graphics for a while, Android only began doing this natively starting with API Level 21 and with the help of the Support Library 23.2.0 for pre-Lollipop devices. By replacing you PNG image resources with VectorDrawables, your APK size decreases considerably and most of all, your images look good, independent of the resolution of the device used.

The system will try to redraw your activity at every 16ms so it can reach the <a href="https://www.youtube.com/watch?v=CaMTIgxCSqU">60fps</a> target. So this means that the duration of every `onDraw` method is extremely important.

When used incorrectly, VectorDrawables can affect the performance of your app, because the drawing can take a long time. Here are three mistakes that you might be doing together with easy to implement solutions, to ensure that you are really improving the performance of your app, with the help of VectorDrawables.

## Understanding The Internals Of VectorDrawables

Vector graphics use geometrical shapes to describe graphical elements. The vector graphics are rendered at runtime. The automatic rendering at pixel density gives smoothness to the graphics, regardless of the device capabilities. So your images won’t be downscaled or upscaled, looking stretched or pixelated but they will be always perfectly drawn for your screen size.
Vector drawables allow the representation of images (e.g. icons, UI elements) based on XML vector graphics.

<center>
<picture>
	<a href="/images/blog/vector_drawables/vector_drawables_vs_png.png"><img src="/images/blog/vector_drawables/vector_drawables_vs_png.png" alt="VectorDrawable vs PNG"></a>
	<figcaption>Using a VectorDrawable vs using a small PNG image</figcaption>
</picture>
</center>

Using vector data instead of raster image data, the number of resources added to the project decreases, since now only one resource per resolution is needed, and therefore also the APK size.

Although the XML file containing the vector drawable is usually smaller than the PNG version, the vector drawables come with a computational overhead at runtime, which may be an issue for more complex graphical elements. When vector drawables are drawn for the first time, a cached bitmap is created in order to optimize the re-drawing performance. This cache is re-used as long as the width and the height of the image that needs to be drawn is the same. If a VectorDrawable is used for multiple sizes, a new Bitmap will be created every time and drawn.

Compared to raster images, drawing VectorDrawables will take more time for the first drawing but then, as long as the size of the image doesn't change, the next drawings of VectorDrawables will take less than drawing raster images.


## Multiple Sizes, Multiple Renderings

Let's say that you need to display an image as 100x50dp when in portrait and 50x100dp when in landscape.

// image

**VectorDrawables use a Bitmap cache that gets recreated when the size changes**, so for example when you rotate your device from portrait to landscape. This means that you end up spending time on rendering at every rotation. The best approach in this case is to **create VectorDrawables for portrait and landscape**. You will end up with two XML files instead of one, but the gain is the rendering time is more valuable.

Let's test this! The size of the view changes when changing the orientation, we can see that when rotating the device, drawing the vector drawable takes 15ms in portrait and 5ms in landscape, where the view is smaller.
At the same time, when the image is just re-used by different views, we can see that drawing the vector drawable takes 15ms the first time - afterwards, drawing time is reduced to 0ms.  

## Maximum VectorDrawable Size Recommended

Since the vector graphics are rendered at runtime, on the CPU, the initial loading and drawing of a vector drawable will be slower. This is why <a href="https://developer.android.com/studio/write/vector-asset-studio.html">Google recommends<a/> using them for images of max 200x200dp.

We are curious developers here at <a href="https://play.google.com/store/apps/details?id=de.axelspringer.yana">upday<a/> so we wanted to find out what exactly does "slower" mean and what's the difference between drawing a vector drawable and a PNG? Given how much <a href="https://plus.google.com/explore/PERFMATTERS">#PERFMATTERS<a/> we wanted to make sure that we won't end up with a smaller APK but with a slower app.


**Test 1:** We set the image to match the size of the screen: **1440x1960px**. The vector drawable took **16ms** to draw, the PNG 0ms.
<br/>
**Test 2:** We set the image to the maximum recommended: 200x200dp so, **800x800px**. The vector drawable took **3ms** to draw, the PNG 0ms.

The difference in rendering time is considerable.


We generated two traces: one after setting the vector drawable as image source and the other one after using a PNG. The interesting results come from analyzing the drawing time: ``VectorDrawable.draw`` took **22.669ms** real time, whereas ``BitmapDrawable.draw`` took only **0.180ms**.

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

## How We Tested

In order to actually check how long the rendering takes, we have measured it using several different test methods:

### 1. Using System.currentTimeMillis()

We created a MeasurableImageView, that overrides the ``onDraw()`` method allowing to compute how long the ``super.onDraw()`` took.

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


### 2. Using TraceView

Hoping to get clearer results, we decided to use TraceView. We modified the overridden ``onDraw`` method, calling ``Debug.startMethodTracing`` before the ``super.onDraw`` and stopped the tracing with ``Debug.stopMethodTracing`` immediately after.

{% highlight java %}
@Override
protected void onDraw(final Canvas canvas) {
    Debug.startMethodTracing("vd");
    super.onDraw(canvas);
    Debug.stopMethodTracing();
}
{% endhighlight %}





## Resource References In VectorDrawable XML

In case you want to reference other resources in the VectorDrawable XML, you can do it like this:

{% highlight XML %}
android:fillColor="@color/colorPrimary"
{% endhighlight %}

Be aware that only **Android 5.0 and higher supports dynamic attributes**.
Setting this will result in black areas instead of your desired color on pre-API level 21 devices.

<center>
<picture>
<img src="/images/blog/vector_drawables/dynamic_res_21.png" alt="Dynamic attributes on API level 21" width="250">
<img src="/images/blog/vector_drawables/dynamic_res_19.png" alt="Dynamic attributes on API level 19" width="250">
<figcaption>Dynamic attributes used on API level 21(left) vs 19(right)</figcaption>
</picture>
</center>

To change the color of your vector drawable dynamically, the solution is simple: tint your images.  

{% highlight java %}
drawable.setColorFilter(color, PorterDuff.Mode.SRC_IN);
{% endhighlight %}

Just make sure that your VectorDrawable is black for the path that needs to be drawn and transparent for the rest. Otherwise, you might end up with unexpected colors.


## Conclusion

<a href="https://developer.android.com/reference/android/graphics/drawable/VectorDrawable.html">VectorDrawables<a/> are the best way of minimizing the number of images resources and reducing your APK size. But before you start replacing all your PNGs, keep in mind that the first time the image is drawn, it will take longer. Considerably longer! The rest of the issues to take into account with vector drawables are minor and easy to overcome, compared to the advantages that you get when using them.

Check out the project used for testing VectorDrawables in this <a href="https://github.com/florina-muntenescu/Playground">GitHub repo</a>.

If you want to learn more about vector drawables, here are some interesting resources:

<a href="https://developer.android.com/studio/write/vector-asset-studio.html">Adding multi-density vector graphics in Android Studio<a/>
<br/>
<a href="https://medium.com/@duhroach/how-vectordrawable-works-fed96e110e35#.r8dp2p9lc">How VectorDrawable works</a>
<br/>
<a href="https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.ultiul691">Vector drawables and AppCompat</a>
<br/>
<a href="https://www.youtube.com/watch?v=r_LpCi6DQME">Colt McAnlis's talk on image compression at Google I/O 2016</a>
