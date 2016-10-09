---
layout: post
title: "Understanding Vector Drawables"
description: This is how vector drawables work and what their limitations are
modified:
categories: blog
author: florina_muntenescu
excerpt: Before you replace all your images with vector drawables, here's how they work and what issues you might have with them.
tags: [Android, UI, Vector Drawables]
image:
date: 2016-10-08T00:39:55-04:00
---

## Android Supports Vector Graphics, Finally!

While some mobile platforms have been supporting vector graphics for a while, Android only began doing this natively starting with API Level 21 and with the help of the Support Library 23.2.0 for pre-Lollipop devices. Vector drawables allow the representation of images (e.g. icons, UI elements) based on XML vector graphics. Using vector data instead of raster image data, the number of resources added to the project decreases, since now only one resource per resolution is needed, and therefore also the APK size. But, before you decide to replace absolutely every PNG in your app with a vector drawable, understand how they work, what limitations they have and how can you overcome some of them.

## How Vector Drawables Work

Vector graphics use geometrical shapes to describe graphical elements. The vector graphics are rendered at runtime. The automatic rendering at pixel density gives smoothness to the graphics, regardless of the device capabilities. So your images won’t be downscaled or upscaled, looking stretched or pixelated but they will be always perfectly drawn for your screen size. Although the XML file containing the vector drawable is usually smaller than the PNG version, the vector drawables come with a computational overhead at runtime, which may be an issue for more complex graphical elements.


## Limitations Of Vector Drawables


### Maximum VectorDrawable Size Recommended

Since the vector graphics are rendered at runtime, on the CPU, the initial loading and drawing of a vector drawable will be slower. This is why <a href="https://developer.android.com/studio/write/vector-asset-studio.html">Google recommends<a/> using them for images of max 200x200dp.

We are curious developers here at <a href="https://play.google.com/store/apps/details?id=de.axelspringer.yana">upday<a/> so we wanted to find out what exactly does "slower" mean and what's the difference between drawing a vector drawable and a PNG? Given how much <a href="https://plus.google.com/explore/PERFMATTERS">#PERFMATTERS<a/> we wanted to make sure that we won't end up with a smaller APK but with a slower app.
In order to actually check how long the rendering takes, we have measured it using several different test methods:

###### 1. Using System.currentTimeMillis()

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

**Test 1:** We set the image to match the size of the screen: **1440x1960px**. The vector drawable took **16ms** to draw, the PNG 0ms.
<br/>
**Test 2:** We set the image to the maximum recommended: 200x200dp so, **800x800px**. The vector drawable took **3ms** to draw, the PNG 0ms.

The difference in rendering time is considerable.

###### 2. Using TraceView

Hoping to get clearer results, we decided to use TraceView. We modified the overridden ``onDraw`` method, calling ``Debug.startMethodTracing`` before the ``super.onDraw`` and stopped the tracing with ``Debug.stopMethodTracing`` immediately after.

{% highlight java %}
@Override
protected void onDraw(final Canvas canvas) {
    Debug.startMethodTracing("vd");
    super.onDraw(canvas);
    Debug.stopMethodTracing();
}
{% endhighlight %}

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

###### 3. Using HierachyViewer

At the beginning, we considered this a valid way of measuring the render time. But, after seeing <a href="https://twitter.com/queencodemonkey">Huyen Tue Dao<a/>'s talk at Droidcon Berlin 2016 about <a href="https://www.youtube.com/watch?v=gwqQT5NrhUg">loving lean layout<a/>, where she mentions several times not to rely on the numbers from the HierarchyViewer, we decided skip this.




### Multiple Sizes, Multiple Renderings

When vector drawables are drawn for the first time, a cached bitmap is created in order to optimize the re-drawing performance. This cache is re-used as long as the width and the height of the image that needs to be drawn is the same. If a VectorDrawable is used for multiple sizes, a new Bitmap will be created every time and drawn. Therefore, the best approach in this case is to create VectorDrawables for every size needed.

In order to test this, we just allow our app to support both portrait and landscape orientation. Since the size of the view changes when changing the orientation, we can see that when rotating the device, drawing the vector drawable takes 15ms in portrait and 5ms in landscape, where the view is smaller.
At the same time, when the image is just re-used by different views, we can see that drawing the vector drawable takes 15ms the first time - afterwards, drawing time is reduced to 0ms.  


### Supported Tags

Another limitation of vector drawables are the tags. Not all VectorDrawable XML tags are supported for Android 5.0 and higher, just a limited set:

<center>
<picture>
	<img src="/images/blog/vector_drawables/tags_support.png" alt="VectorDrawables tags supported">
	<figcaption>Supported tags. Image from Android developer pages. </figcaption>
</picture>
</center>

But, the Support Library 23.2.0 and higher offers full support for VectorDrawable XML elements.


### Resource References In VectorDrawable XML

In case you want to reference other resources in the VectorDrawable XML, you can do it like this:

{% highlight XML %}
android:fillColor="@color/colorPrimary"
{% endhighlight %}

Be aware that only Android 5.0 and higher supports dynamic attributes.
Setting this will result in black areas instead of your desired color on pre-API level 21 devices.

<center>
<picture>
<img src="/images/blog/vector_drawables/dynamic_res_21.png" alt="Dynamic attributes on API level 21" width="250">
<img src="/images/blog/vector_drawables/dynamic_res_19.png" alt="Dynamic attributes on API level 19" width="250">
<figcaption>Dynamic attributes used on API level 21(left) vs 19(right)</figcaption>
</picture>
</center>

To change the color of your vector drawable dynamically, the solution is simple: tint your images.  

{% highlight XML %}
android:tint="@color/colorAccent"
{% endhighlight %}

Just make sure that your VectorDrawable is black for the path that needs to be drawn and transparent for the rest. Otherwise, you might end up with unexpected colors.

### Vector Drawable Preview in Android Studio Looks Skewed

The vector drawable preview in both the import preview and in the file preview can look skewed. But don't be scared, chances are it might look good when the app is run on the device. So, make sure your check them on the device first and only change them if needed.

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
