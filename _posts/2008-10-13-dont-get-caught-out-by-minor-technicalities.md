---
layout: post
title: Don't Get Caught Out By Minor Technicalities
slug: dont-get-caught-out-by-minor-technicalities
date: 2008-10-13
categories:
- Development
- Flex Apps
tags:
- FLEX
- Issues
- Namespace
status: publish
type: post
published: true
---
<p>I need more coffee.. or a beer.. or both</p>
<p>Today I fell for a really stupid problem, which just goes to show how easy it is to not spot the simple issues.</p>
<p>I'm currently working on a FLEX AIR application alongside two other developers. After importing the project files from CVS and into Flex Builder, the AIR application would not run, and I could not run the debugger either.</p>
<p>The solution, it turns out, was really simple. I was still running Flex Builder 3, and my colleagues were running 3.0.1. The difference between the two was the namespace used in the application descriptor xml file. Version 3.0.1 uses <a href="http://ns.adobe.com/air/application/1.1">http://ns.adobe.com/air/application/1.1</a>, whereas version 3 uses <a href="http://ns.adobe.com/air/application/1.0">http://ns.adobe.com/air/application/1.0</a>. A small technicality, but it had us stumped for the morning.</p>
<p>Simply changing the namespace meant that the AIR app would run from within Flex builder. Rest assured, I am now updating to version 3.0.1. Now, where's that coffee jar...</p>
