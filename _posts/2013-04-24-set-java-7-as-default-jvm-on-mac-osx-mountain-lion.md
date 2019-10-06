---
layout: post
title: Set Java 7 as default JVM on Mac OSX Mountain Lion
slug: set-java-7-as-default-jvm-on-mac-osx-mountain-lion
categories:
- General
tags:
- Java
status: publish
type: post
published: true
date: 2013-04-24
---
<p>I recently had an issue where an application I wanted to run on Mountain Lion needed Java 7 as the default JVM on the machine. The install for the app in question worked without errors, but the issue was highlighted when trying to run the app.</p>
<p>Here's how I fixed the problem.</p>
<p>Firstly, open Terminal and find out the current default Java version on your machine:</p>
<pre>java -version</pre>
<p>Download the Java 7 JDK from the Java SE site (<a title="Download Java SE" href="http://www.oracle.com/technetwork/java/javase/downloads/index.html" target="_blank">http://www.oracle.com/technetwork/java/javase/downloads/index.html</a>)</p>
<p>Run the installer. Now, for me this still didnt ensure that the updated Java version was the current one used by the system.</p>
<p>In Terminal, navigate to the following location:</p>
<pre>cd /System/Library/Frameworks/JavaVM.framework/Versions/</pre>
<p>The CurrentJDK symlink in this directory was still pointing to an older Java version. To resolve this, remove the symlink and create a new one pointing to the new Java 7 JDK (you may need to use sudo to run these commands):</p>
<pre>rm CurrentJDK</pre>
<pre>ln -s /Library/Java/JavaVirtualMachines/jdk1.7.0_21.jdk/Contents/ CurrentJDK</pre>
<p>This fixed it for me. To confirm, check the Java version once again in Terminal:</p>
<pre>java -version</pre>
<p>You should now see java version "1.7.0_21" (or similar).</p>
