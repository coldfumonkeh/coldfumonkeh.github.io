---
layout: post
title: (I want my) Last.fm CFC wrapper
slug: lastfmcfc
date: 2009-02-26
categories:
- ColdFusion
- Components
- Projects
tags:
- CFC
- ColdFusion
status: publish
type: post
published: true
---
<p><!--UPDATE: An online demo of some of the functionality can be found here: <a title="Last FM API CFC Demo" href="http://mattgifford.co.uk/projects/lastfmapi/" target="_blank">http://mattgifford.co.uk/projects/lastfmapi/</a>--></p>
<p>I wrote this tag-based CFC wrapper to access the last.fm api (details and spec can be found here: <a title="http://www.last.fm/api" href="http://www.last.fm/api" target="_blank">http://www.last.fm/api</a>)<br />
There are 15 components in total, 13 of which contain methods and functions relating to the last.fm api.</p>
<p>I wanted to try and develop something that was easy to implement, and easy to use.</p>
<p>The system I came up with requires the user to access ONE method within ONE component only,<br />
and all classes, methods and arguments are passed through this one function.</p>
<p>The user only needs to createObject for the API.cfc file.<br />
This takes two params (the api key and secret key provided to you by last.fm).</p>
<p>Example:</p>
<pre name="code" class="xml" escaped="true">
&lt;cfset api = createObject("component", "cfc.api").init('__api__key__','__secret__key__') /&gt;
</pre>
<p>That's it. The api wrapper is effectively ready to go.</p>
<p>To access individual methods, the process is a simple one.<br />
Last.fm organised and arranged their method calls into a class name.method name format eg user.getInfo.</p>
<p>There is one single function within the API.cfc that the user needs to call: methodCall().<br />
This takes three params (the class name, the method name, the params to send to the method)</p>
<p>The param argument takes a struct format argument collection, so a call to user.getInfo (with username) would be like this:</p>
<p>Example:</p>
<pre name="code" class="xml" escaped="true">
&lt;cfset args = StructNew() /&gt;
&lt;cfset args["user"] = "mattgifford" /&gt;
&lt;cfset thisUserInfo = api.methodCall('user', 'getinfo', args) /&gt;
</pre>
<p>Easy!</p>
<p>Each of the functions within the main methods contain an extra argument (return).<br />
This is used to allow you to choose what format you would like to receive the data.<br />
As default, this is 'struct'.<br />
All functions have the option for 'xml' output.</p>
<p>Most of them (with only a few exceptions where there is no repeating data to require it) have the option for 'query',<br />
allowing you to easily loop through and output data.</p>
<p>The wrapper is available for download from <a title="(I want my) lastfm wrapper" href="http://iwantmylastfm.riaforge.org/" target="_blank">http://iwantmylastfm.riaforge.org/</a></p>
