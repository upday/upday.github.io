---
layout: post
title: "From Code to Dex — A Compilation Story"
description:
modified:
categories: blog
author: florina_muntenescu
excerpt: All Android code lines dream about one thing — to one day be part of a dex file, packaged in an APK and run (error) free on a device. In this blog post I want to tell you about the journey that your app’s code goes through, on its way to becoming part of dex files.
tags: [Android, Dex, Compilation, Jack, Jill]
image:
date: 2017-01-04T00:00:00-04:00
---
All Android code lines dream about one thing — to one day be part of a dex file, packaged in an APK and run (error) free on a device. In this blog post I want to tell you about the journey that your app’s code goes through, on its way to becoming part of dex files.

## The App Module And His Friends
The main character in our story is our __application module__ (the one in _\<project_dir>/app_). But usually the application module hangs out with some friends — the library __.jar dependencies__, his bigger brothers — the __.aar dependencies__, and possibly even some __library modules__.

The application module and the library module each contain their own .java source code, resource file and <a href="https://www.guardsquare.com/en/proguard">_proguard-rules.pro_</a>. The .aar dependency incorporates the .class bytecode files, together with the resource files and the _proguard.txt_ file. The .jar dependency contains the .class files. All of these files need to be compiled to one (or more) dex file(s), and then afterwards packaged in an APK and run on an Android device.

<center>
<picture>
	<a href="/images/blog/jack_jill_dex"><img src="/images/blog/jack_jill_dex/characters.png" alt="App module, library module, .aar and .jar dependencies"></a>
	<figcaption>App Module and his friends: the library module, the .aar and .jar dependencies</figcaption>
</picture>
</center>

## Target: The Dex File
Dex files are <a href="https://source.android.com/devices/tech/dalvik/dex-format.html">Dalvik executable files</a> for both <a href="https://source.android.com/devices/tech/dalvik/">ART and Dalvik</a> runtimes. They combine the power of our four protagonists creating the bytecode that runs on Android devices.

The dex file is most known for the infamous <a href="https://medium.com/@rotxed/dex-skys-the-limit-no-65k-methods-is-28e6cb40cf71#.67a5fhsu1">65k method count limit</a> but it contains more than just a method table. More precisely, it aggregates content from the app module and all of its dependencies. The <a href="https://source.android.com/devices/tech/dalvik/dex-format.html">dex file format contains</a> the following elements:

1. File Header
2. String Table
3. Class List
4. Field Table
5. Method Table
6. Class Definition Table
7. Field List
8. Method List
9. Code Header
10. Local Variable List

But the road to the dex file is long and winding. First, the Java source code is compiled using `javac` (part of the JDK) to create the .class files. Afterwards, using the `dx` tool (part of the Android SDK build tools), the Java bytecode .class files are translated to the .dex files.

## Jack And Jill To The Rescue!
Two heroes appear in the lives of our characters starting with Android M, to make the road to dex less long and winding: __Java Android Compiler Kit__ (aka Jack) and his friend the __Jack Intermediate Library Linker__ (aka Jill). Jack and Jill tools are at the core of a new Android toolchain. They improve build times and simplify development by reducing dependencies on other tools.

### Enabling Jack And Jill
To use the power of these toolchain heroes, all you need to do is enable them in your _build.gradle_ file.
{% highlight groovy %}
android {
    ...
    buildToolsRevision '21.1.1'
    defaultConfig {
      // Enable the Jack build tools.
      useJack = true
    }
    ...
}
{% endhighlight %}

### Jack And Jill Super Compiler Powers
Enabling Jack brings forward the first of his powers: allowing you to start using <a href="https://developer.android.com/guide/platform/j8-jack.html">__Java 8 features__</a> in your app after adding the `sourceCompatibility` and `targetCompatibility` compile options in your __build.gradle__ file.

__Jack__ works directly only with one of our characters: the __application module__. It will compile the .java files from _\<project_dir>/app_ directly to .dex files. Jack uses __.jack library files__, that contain the pre-compiled dex code, a .jayce file, the resources needed and meta information.

The __pre-dex__ from each library are used when compiling, speeding up the process.

<center>
<picture>
	<a href="/images/blog/jack_jill_dex"><img src="/images/blog/jack_jill_dex/jack-library-file.png" alt=".jack library file content"></a>
	<figcaption><a href="https://source.android.com/source/jack.html#the_jack_library_format">.jack library file content</a></figcaption>
</picture>
</center>


__Jill__ works with the other characters: __library modules, .aar and .jar dependencies__. From those, Jill will use just the .class files to create a __.jayce__ file — an intermediate bytecode file. The .jayce file is then bundled together with the resources from the library dependencies to create a .jack file. From there on this library file is handled by Jack.

<center>
<picture>
	<a href="/images/blog/jack_jill_dex"><img src="/images/blog/jack_jill_dex/jill.png" alt="Workflow to import an existing .jar library"></a>
	<figcaption><a href="https://source.android.com/source/jack.html#the_jack_library_format">Workflow to import an existing .jar library</a></figcaption>
</picture>
</center>


If you set `minifyEnabled` true in your _build.gradle_ file, Jack will use the _proguard-rules.po_ and _proguard.txt_ files to handle __shrinking and obfuscation__ of your code.

Jack’s powers don’t stop here. __Incremental compilation__ is supported. With Jack, only components modified since the last compilation, together with their dependencies, are recompiled. So, when only some components were modified, the compilation time can decrease considerably compared to a full compilation.

Pre-dexing and incremental compilation <a href="https://source.android.com/source/jack.html#incremental_compilation">do not work</a> when shrinking/obfuscation/repackaging is enabled.

Jack brings our story to an end by putting together all the files, classes, methods and so on, from your app and other dependencies, to create the dex file. If the number of all the methods is bigger than 65K and support for <a href="https://developer.android.com/studio/build/multidex.html">multidex</a> is enabled, then Jack handles the splitting into multiple dex files.

<center>
<picture>
	<a href="/images/blog/jack_jill_dex"><img src="/images/blog/jack_jill_dex/jackjillbuild.png" alt="Typical Jack and Jill Application Build"></a>
	<figcaption><a href="https://android-developers.googleblog.com/2014/12/hello-world-meet-our-new-experimental.html">Typical Jack and Jill Application Build</a></figcaption>
</picture>
</center>

## TL;DR
Here’s how each of the toolchains <a href="https://developer.android.com/guide/platform/j8-jack.html#configuration">work</a>:

Legacy javac toolchain:

__javac__ (`.java` → `.class`) → __dx__ (`.class` → `.dex`)

New Jack toolchain:

__Jack__ (`.java` → `.jack` → `.dex`)

Jack speeds up the compilation time and handles shrinking, obfuscation, repackaging and multidex. Before you start using it, keep in mind that it’s still considered <a href="http://tools.android.com/tech-docs/jackandjill">experimental</a>.


If you want to find out more details about our heroes’ <a href="https://developer.android.com/studio/build/index.html">compiling</a> journey, check out the following resources: <a href="https://source.android.com/source/jack.html">compiling with Jack</a>, Eric Lafortune’s talk on <a href="https://www.youtube.com/watch?v=QOmVx61-bfc&t=0s">The Jack and Jill build system</a>, and Jesse Wilson’s talk on <a href="https://www.youtube.com/watch?v=v4Ewjq6r9XI">Dex</a>.
