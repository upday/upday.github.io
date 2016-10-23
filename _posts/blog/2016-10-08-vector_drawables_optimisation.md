---
layout: post
title: "Optimizing the Performance of Vector Drawables"
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
	<a href="/images/blog/vector_drawables/vector_drawables_vs_png.png"><img src="/images/blog/vector_drawables/vector_drawables_vs_png.png" alt="VectorDrawable vs PNG" width="350"></a>
	<figcaption>Using a VectorDrawable vs using a small PNG image</figcaption>
</picture>
</center>

Using vector data instead of raster image data, the number of resources added to the project decreases, since now only one resource per resolution is needed, and therefore also the APK size.

Although the XML file containing the vector drawable is usually smaller than the PNG version, the vector drawables come with a computational overhead at runtime, which may be an issue for more complex graphical elements. When vector drawables are drawn for the first time, a cached bitmap is created in order to optimize the re-drawing performance. This cache is re-used as long as the width and the height of the image that needs to be drawn is the same. If a VectorDrawable is used for multiple sizes, a new Bitmap will be created every time and drawn.

Compared to raster images, drawing VectorDrawables will take more time for the first drawing. But then, as long as the size of the image doesn't change, the next drawings of VectorDrawables will take similar amount of time like drawing raster images.


## Multiple Sizes, Multiple Renderings

Let's say that you need to display an image that needs to fill the height of the screen but keep the aspect ration when rotating the device from portrait to landscape.

<center>
<picture>
	<a href="/images/blog/vector_drawables/phone_portrait.png"><img src="/images/blog/vector_drawables/phone_portrait.png" alt="VectorDrawable vs PNG" height="350"></a>
	<a href="/images/blog/vector_drawables/phone_landscape.png"><img src="/images/blog/vector_drawables/phone_landscape.png" alt="VectorDrawable vs PNG" width="350"></a>
	<figcaption>Changing the size of the image on orientation</figcaption>
</picture>
</center>

**VectorDrawables use a Bitmap cache that gets recreated when the size changes**, so for example when you rotate your device from portrait to landscape. After the first rendering, the cached bitmap will be used. This means that you end up spending a lot of time on the first rendering of the VectorDrawable, at every rotation of the screen.
The best approach in this case is to **create one VectorDrawable for portrait and one for landscape**. Like this, time will be spent only for the first rendering of the two images and the corresponding bitmap caches will be used from there on for every rotation.

Let's test this! The size of the view changes when changing the orientation. When rotating the device, drawing the vector drawable takes, in average, 15.50ms in portrait and 7.80ms in landscape, where the view is smaller.
In the same time, when the image is just re-used by different views, we can see that drawing the vector drawable takes 15.50ms the first time - afterwards, drawing time is reduced to 0.15ms.  

## Maximum VectorDrawable Size Recommended

Since the vector graphics are rendered at runtime, on the CPU, the initial loading and drawing of a vector drawable will be slower. This is why <a href="https://developer.android.com/studio/write/vector-asset-studio.html">Google recommends<a/> using them for images of max 200x200dp.

<center>
<picture>
	<a href="/images/blog/vector_drawables/android_doc.png"><img src="/images/blog/vector_drawables/android_doc.png" alt="Android documentation"></a>
	<figcaption>Android documentation says max 200 x 200 dp</figcaption>
</picture>
</center>

We are curious developers here at <a href="https://play.google.com/store/apps/details?id=de.axelspringer.yana">upday<a/> so we wanted to see some numbers. What exactly does "slower" mean and what's the difference between drawing a vector drawable and a PNG? Given how much <a href="https://plus.google.com/explore/PERFMATTERS">#PERFMATTERS<a/> we need to make sure that we won't end up with a smaller APK but with a slower app.

**Test 1:** We set the image to match the size of the screen: **1440x1960px**. The vector drawable took, in average, **16.60ms** to draw, the PNG 0.180ms.
<br/>
**Test 2:** We set the image to the maximum recommended: 200x200dp so, **800x800px**. The vector drawable took **3.40ms** to draw, the PNG 0.060ms.

The difference in rendering time is considerable.

## Do You Really Need a VectorDrawable?


## How We Tested

To check how long the rendering of an image takes, meant that we needed to measure how long it takes to draw it. So we created a `MeasurableImageView` class that extends `ImageView`. We are overriding the ``onDraw()`` method allowing us to compute how long the ``super.onDraw()`` takes.
We used a Samsung Galaxy S7 as a test device. We ran the app several times, computing an average of the values for different scenarios.

### 1. Using System.nanoTime()

Before and after the `ImageView.onDraw` method call, we got the system time. Then, we just deducted the start time from the end time, to get the duration.

{% highlight java %}
@Override
protected void onDraw(final Canvas canvas) {
    long startTime = System.nanoTime();

    super.onDraw(canvas);

    long endTime = System.nanoTime();
    long duration = endTime - startTime;
}
{% endhighlight %}


### 2. Using TraceView

Hoping to get clearer results, we decided to use TraceView. We called ``Debug.startMethodTracing`` before the ``super.onDraw`` and stopped the tracing with ``Debug.stopMethodTracing`` immediately after.

{% highlight java %}
@Override
protected void onDraw(final Canvas canvas) {
    Debug.startMethodTracing("test");
    super.onDraw(canvas);
    Debug.stopMethodTracing();
}
{% endhighlight %}

Then we analyzed the generated traces, looking for the time took to run ``VectorDrawable.draw`` and ``BitmapDrawable.draw``methods.

<center>
<picture>
	<a href="/images/blog/vector_drawables/trace_png.png"><img src="/images/blog/vector_drawables/trace_png.png" alt="TraceView of a PNG"></a>
		<a href="/images/blog/vector_drawables/trace_vector_drawable.png"><img src="/images/blog/vector_drawables/trace_vector_drawable.png" alt="TraceView of a vector drawable"></a>
	<figcaption>Screenshot from TraceView results when using a PNG image and a VectorDrawable</figcaption>
</picture>
</center>

*Note:* keep in mind that you won't get exactly the same values, every time when your image is rendered. The values that you get should just be used as general reference points. The rendering duration depends also on the power of your CPU so make sure you use the mostly used device by your users.

## Conclusion

<a href="https://developer.android.com/reference/android/graphics/drawable/VectorDrawable.html">VectorDrawables<a/> are the best way of minimizing the number of images resources and reducing your APK size. But before you start replacing all your PNGs, keep in mind that the first time the image is drawn, it will take longer. Considerably longer! The rest of the issues to take into account with vector drawables are minor and easy to overcome, compared to the advantages that you get when using them.

Check out the project used for testing VectorDrawables in this <a href="https://github.com/florina-muntenescu/vectordrawable-vs-png">GitHub repo</a>.

If you want to learn more about vector drawables, here are some interesting resources:

<a href="https://developer.android.com/studio/write/vector-asset-studio.html">Adding multi-density vector graphics in Android Studio<a/>
<br/>
<a href="https://medium.com/@duhroach/how-vectordrawable-works-fed96e110e35#.r8dp2p9lc">How VectorDrawable works</a>
<br/>
<a href="https://medium.com/@chrisbanes/appcompat-v23-2-age-of-the-vectors-91cbafa87c88#.ultiul691">Vector drawables and AppCompat</a>
<br/>
<a href="https://www.youtube.com/watch?v=r_LpCi6DQME">Colt McAnlis's talk on image compression at Google I/O 2016</a>