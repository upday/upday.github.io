---
layout: post
title: "Android N’s App Shortcuts"
description:
modified:
categories: blog
author: kavya_hebbani
excerpt: App Shortcuts introduced in Android N provides quick access points to your app. Let's take a look at how to implement this in detail.
tags: [Android N, Android UI]
image: /images/blog/app_shortcuts/image_main.jpg
date: 2016-11-16T00:39:55-04:00
---
Android N introduced many new powerful features out of which I would like to talk about a simple, yet very useful one: <a href="https://developer.android.com/preview/shortcuts.html">App Shortcuts</a>. Available from Android API version 25, App shortcuts help users to perform a specific action within the app, from outside the app.

<center>
<picture>
	<img src="/images/blog/app_shortcuts/longtap.gif">
	<figcaption>App Shortcuts opened via long-tap</figcaption>
</picture>
</center>

Performing a long-tap on the app’s launcher icon will display the list of App shortcuts and each of them can be added to home-screen as an individual launcher icon.

Android provides two types of App shortcuts:

#### 1. Static Shortcuts:
Static shortcuts are published when the app is installed, hence they remain constant throughout the app. Static shortcuts are immutable which means that their icons, description and the Intent it launches cannot be changed without updating to a new version of the app.

Static shortcuts are used for generic actions of the app that remain persistent over the lifetime of your app’s current version.

Examples: scan a QR code, view shopping cart, start a new game.

#### 2. Dynamic Shortcuts:
Dynamic shortcuts are created, updated and removed during run-time of your app.

Dynamic shortcuts are used to provide specific, context-sensitive actions within your app, that could change with the user or based on user’s interactions within the app.

Examples: translate from a specific language, call a specific person, go to a specific channel on YouTube.

#### Implementing App Shortcuts

#### Static Shortcuts
To define Static shortcuts, create a resource file under ‘res/xml’ with an arbitrary name, say ‘shortcuts.xml’ and define all the app’s shortcuts with their icons, description and the Intent that it should launch within the app.

{% highlight java %}
<shortcuts xmlns:android="http://schemas.android.com/apk/res/android">

  <shortcut
    android:shortcutId="open_cart"
    android:enabled="true"
    android:icon="@drawable/cart_icon"
    android:shortcutShortLabel="@string/short_label"
    android:shortcutLongLabel="@string/long_label"
    android:shortcutDisabledMessage="@string/disabled_message">
    <intent
      android:action="android.intent.action.VIEW"
      android:targetPackage="com.example.shortcuts"
      android:targetClass="com.example.shortcuts.MainActivity" />
  </shortcut>
<!-- Specify more shortcuts here. -->
</shortcuts>
{% endhighlight %}

Add a `meta-data` tag to your launcher Activity in the manifest and provide the shortcuts resource file.

{% highlight java %}
<extra android:name="fragmentToOpen" android:value="cart"/>
{% endhighlight %}

If you have multiple shortcuts launching the same Activity, then to differentiate between the actions that needs to be performed, define an `extra` for the Intent in ‘shortcuts.xml’ and check for this value in your Activity.

<center>
<picture>
	<img src="/images/blog/app_shortcuts/open_static.gif">
	<figcaption>Opening ‘My Cart’ and going back to Main page.</figcaption>
</picture>
</center>

#### Dynamic Shortcuts
The <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#setDynamicShortcuts%28java.util.List%3Candroid.content.pm.ShortcutInfo%3E%29">ShortcutManager</a> API provides methods to publish, update and remove shortcuts dynamically. Each shortcut can be defined using <a href="https://developer.android.com/reference/android/content/pm/ShortcutInfo.html">ShortcutInfo</a> which provides the UI information of the shortcut.

{% highlight java %}
ShortcutManager manager = getSystemService(ShortcutManager.class);
ShortcutInfo shortcut = new ShortcutInfo.Builder(this, "cartId")
    .setShortLabel("My Cart")
    .setLongLabel("Open shopping cart")
    .setIcon(Icon.createWithResource(context, R.drawable.cart))
    .setIntent(new Intent(context, CartActivity.class))
    .build();
shortcutManager.setDynamicShortcuts(Arrays.asList(shortcut));
{% endhighlight %}

Using <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#setDynamicShortcuts%28java.util.List%3Candroid.content.pm.ShortcutInfo%3E%29">setDynamicShortcuts()</a> updates the entire list of Dynamic shortcuts. If you want to just add another element to the existing list, use <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#addDynamicShortcuts%28java.util.List%3Candroid.content.pm.ShortcutInfo%3E%29">addDynamicShortcuts()</a>. To update the existing Dynamic shortcut, use the method <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#updateShortcuts%28java.util.List%3Candroid.content.pm.ShortcutInfo%3E%29">updateShortcuts()</a>.

<center>
<picture>
	<img src="/images/blog/app_shortcuts/add_remove_dynamic.gif">
	<figcaption>Adding and removing ‘Sports’ as shortcut.</figcaption>
</picture>
</center>


Please note that the call to set, add and update Dynamic shortcuts using ShortcutManager is rate-limited, when the app is not in foreground. This means that if the rate-limit is exceeded, calling these API will return false. Hence, before performing an action, check if the rate-limiting is active using <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#isRateLimitingActive%28%29">isRateLimitingActive()</a> method.

{% highlight java %}
if (shortcutManager.isRateLimitingActive()) {
    // Bring app to foreground to reset the limit.
}
{% endhighlight %}

When the app is upgraded, the Dynamic shortcuts that are not pinned to home screen are not retained. Hence, the app must restore them if necessary.

{% highlight java %}
if (shortcutManager.getDynamicShortcuts().size() == 0) {
    // App restored, re-publish dynamic shortcuts.
}
{% endhighlight %}

#### Handling User Navigation
When the user launches the app via a shortcut and then decides to press back button, then the app might be closed abruptly. To avoid this and create a user friendly navigation and retain the users in the app, you can launch multiple Intents (in the order with the last one on top) for both Static and Dynamic shortcuts.

* For Static shortcuts multiple Intents can be defined in ‘shortcuts.xml’.


{% highlight java %}
<shortcut
    android:shortcutId="open_cart"
    android:enabled="true"
    android:icon="@drawable/cart_icon"
    android:shortcutShortLabel="@string/short_label"
    android:shortcutLongLabel="@string/long_label"
    android:shortcutDisabledMessage="@string/disabled_message">
    <intent
      android:action="android.intent.action.VIEW"
      android:targetPackage="com.example.shortcuts"
      android:targetClass="com.example.shortcuts.MainActivity" />
    <intent
      android:action="android.intent.action.VIEW"
      android:targetPackage="com.example.shortcuts"
      android:targetClass="com.example.shortcuts.CartActivity" />  </shortcut>
{% endhighlight %}

The first Intent will always have <a href="https://developer.android.com/reference/android/content/Intent.html#FLAG_ACTIVITY_NEW_TASK">`FLAG_ACTIVITY_NEW_TASK`</a> and <a href="https://developer.android.com/reference/android/content/Intent.html#FLAG_ACTIVITY_CLEAR_TASK">`FLAG_ACTIVITY_CLEAR_TASK`</a> set. This means that the existing activities will be destroyed when a Static shortcut is launched.

* The same can be achieved with Dynamic shortcuts using <a href="https://developer.android.com/reference/android/content/pm/ShortcutInfo.Builder.html#setIntents%28android.content.Intent[]%29">setIntents(Intent[])</a> method.

{% highlight java %}
ShortcutInfo shortcut = new ShortcutInfo.Builder(this, "cartId")
    .setShortLabel("My Cart")
    .setLongLabel("Open shopping cart")
    .setIcon(Icon.createWithResource(context, R.drawable.cart))
    .setIntents(new Intent[] {
                   new Intent(context, MainActivity.class)
                       .setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK),
                   new Intent(context, CartActivity.class)
                   })
    .build();
{% endhighlight %}

Typically, `FLAG_ACTIVITY_CLEAR_TASK` is defined so that the new target Activity is brought to front.

#### Best practices:

* Use at most 4 App shortcuts, including static and dynamic ones, for a better user experience.

* Disable the Dynamic shortcuts that are no longer valid using <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#disableShortcuts%28java.util.List%3Cjava.lang.String%3E,%20java.lang.CharSequence%29">disableShortcuts(shortcut, errorMessage).</a> If the user has already pinned the shortcuts on the home screen, then the error message will be displayed.

* Invoke <a href="https://developer.android.com/reference/android/content/pm/ShortcutManager.html#reportShortcutUsed%28java.lang.String%29">reportShortcutUsed(String)</a> every time the shortcut action is performed in the app. This is used by the Launcher applications to predict which shortcuts will most likely be used at a given time by examining the shortcut usage history data.

* Use <a href="https://medium.com/upday-devs/optimizing-the-performance-of-vector-drawables-680a4c456286#.pi61nqwkc">vector drawables</a> for icons, so that they are scaled for different dimensions automatically. Except if you are using avatars, use PNG and provide image for all dimensions.

* Keep the descriptions short, specific and meaningful. Do not exceed 10 characters for short description and 25 characters for long description.

* Dynamic shortcuts by default appear on top of the Static ones. The order of Dynamic shortcuts can be changed by changing the ‘Rank’ of the shortcut using <a href="https://developer.android.com/reference/android/content/pm/ShortcutInfo.Builder.html#setRank%28int%29">ShortcutInfo.Builder().setRank().</a>

* When the system locale changes, update the icon’s description. Keep in mind that Android 7.0 supports <a href="https://developer.android.com/about/versions/nougat/android-7.0.html#multi-locale_languages">multi-locale.</a>

#### Testing:
To test App shortcuts you would need Android version 7.1, with supported launcher(like the Nexus or Pixel launcher). A preview image can be easily setup on a rooted device or you can use an emulator, as described in detail <a href="https://developer.android.com/preview/download.html">here.</a>

#### TL;DR
To conclude, App shortcuts are a great way to provide quick and easy access to the app’s common and recommended points within the app. Reducing the number of taps is always something the user will love about your app. Users are excited about Android N and its time to make the most of it and let the heavy users of your app enjoy the cool new features. The complete source code can be found in my <a href="https://github.com/kavyaShreeHS/App-Shortcuts">GitHub repository.</a>