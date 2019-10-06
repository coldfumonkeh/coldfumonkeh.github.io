---
layout: post
title: Displaying Real Android Devices On Screen
slug: displaying-real-android-devices-on-screen
categories:
  - Development
tags:
  - Mobile
  - Presentations
  - Testing
status: publish
type: post
published: true
date: 2012-10-05
---

I've had a few presentations recently where I have been demoing the awesomeness that is the PhoneGap Build service. I needed to demo and show the process of deploying and running a compiled application directly onto a device.

Typically, I would use the the Android Device (AVD) emulator for this, although I would rather show the processes running on a real device and somehow show that on screen.

After a very quick Google search, I found the answer in the form of <a title="Droid@Screen" href="http://droid-at-screen.ribomation.com/" target="_blank">Droid@Screen</a>.

This is a .jar file that hooks into the Android ADB (Android Debug Bridge) executable, and will display the active device screen on your machine when the device is connected via USB.

<img title="Droid@Screen running a live device" src="/assets/uploads/2012/10/droid2_running.png" alt="Droid@Screen running a live device" />

It has worked fairly well for me so far. I've had a few instances of it freezing on me mid-demo, but I admit I haven't fully read the documentation or tested each and every available setting (yet).

As it is a .jar file, you simply need a machine that runs Java (minimum version 6) and the Android SDK installed locally so that you can access the ADB tool. If you haven't tried it or heard of it before, check it out and see if it helps you for any presentation / debugging / goofing around requirements.
