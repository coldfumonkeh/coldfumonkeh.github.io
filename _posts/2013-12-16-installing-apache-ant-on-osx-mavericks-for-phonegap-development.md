---
title: Installing Apache Ant on OSX Mavericks for PhoneGap development
slug: installing-apache-ant-on-osx-mavericks-for-phonegap-development
categories:
- Development
tags:
- PhoneGap
status: publish
type: post
published: true
date: 2013-12-16
---
<p>I haven't developed any PhoneGap applications on one of my laptops since upgrading it to OSX Mavericks. Earlier this evening I stumbled across a problem when running the following command to run the app against the Android SDK:</p>
<p>phonegap run android</p>
<p>The error is received was:</p>
<p>[phonegap] detecting Android SDK environment...</p>
<p>[phonegap] using the local environment</p>
<p>[phonegap] adding the Android platform...</p>
<p>[error] An error occured during creation of android sub-project.</p>
<p>Error: ERROR : executing command 'ant', make sure you have ant installed and added to your path.</p>
<p>It turns out that Ant isn't installed by default on Mavericks. If you hit this issue too there are two quick ways to remedy the situation and get up and running again.</p>
<h2>HomeBrew</h2>
<p>This is the solution I used as I have HomeBrew installed on this machine.</p>
<p>I updated the Brew and simply requested an install of Ant:</p>
<p>brew update</p>
<p>brew install ant</p>
<p>This took seconds to work, which is always a pleasant surprise. If you dont have HomeBrew installed, simply run the following command first:</p>
<p>ruby -e "$(curl -fsSL <a href="https://raw.github.com/mxcl/homebrew/go/install">https://raw.github.com/mxcl/homebrew/go/install</a>)"</p>
<h2>MacPorts</h2>
<p>If you're a MacPorts user instead, simply run the following:</p>
<p>sudo port install apache-ant</p>
<p>Whichever method you choose, you should now once again have access to Ant via the command line.</p>
