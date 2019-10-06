---
layout: post
title: monkehTweets ColdFusion Twitter CFC Update
slug: monkehtweets-coldfusion-twitter-cfc-update
date: 2010-09-13
categories:
- ColdFusion
- Projects
tags:
- API
- CFC
- ColdFusion
- twitter
status: publish
type: post
published: true
---
<p>Following on from a change in authentication protocol at Twitter HQ, monkehTweets stopped working at the end of August.</p>
<p>The previous release of monkehTweets used only the Basic Authentication method, which sent the username and password through as a header in the HTTP request for all API calls. Twitter decided to completely shut down this authentication method and go purely for an OAuth-based format.</p>
<h2>OAuth is fun... honest</h2>
<p>OAuth is an incredibly powerful form of authentication, and theoretically one that is quite easy. Theoretically.</p>
<p>This is the third open-source project of mine that uses OAuth authentication (the other two haven't actually been released yet). Although the essential basics are the same, the implementation differs from site to site, what is needed to make the call, which parameters to send, what is returned etc etc</p>
<p>I have had more headaches with OAuth over the last week than I care to recall, but each and every one has been a learning experience; exposure to something else, which can only be a good thing. (remain positive :) )</p>
<h2>Simplicity is key</h2>
<p>The addition of the OAuth amendments to the existing monkehTweets library threw up many questions and thoughts about the structure and implementation of the library.</p>
<p>I knew from download stats, comments and messages that people were using the original release package, which is fantastic. As such, I didn't want to change the actual monkehTweets.cfc service layer / facade object more than i needed to; after all, this was the file holding the methods being called by applications written by others.</p>
<p>I also wanted to keep the instantiation requirements to a minimum if possible; I always prefer to have an object that is quick and easy to get up and running, and I wanted to try and keep that with the revised version of monkehTweets.</p>
<h2>Set up your application</h2>
<p>To begin with the OAuth authentication and integration with the monkehTweets CFC, you need to create an application on <a href="http://dev.twitter.com/apps" target="_blank" title="Visit dev.twitter.com to generate your consumer details">http://dev.twitter.com/apps</a>, which will generate the consumer key and consumer secret values that you need.</p>
<p><img src="/assets/uploads/2010/09/twitOAuth_01-e1284368726536.png" alt="" title="Create your application on dev.twitter.com" /></p>
<p>Three points are highlighted in the above screen shot:</p>
<ul>
<li>The applicaiton type is set to browser</li>
<li>The callback URL is defined here. This can be over-written when making authorisation calls</li>
<li>The access type is set to read & write</li>
</ul>
<p>After completing your application registration form, you will have your consumer key and consumer secret values, which you will need as the basic required attributes for the instantiation of the monkehTweets object.</p>
<p><img src="/assets/uploads/2010/09/twitOAuth_02-e1284368675841.png" alt="" title="Obtaining the consumer key information" /></p>
<p>You can also obtain the access token and secret values, which you can add into the init() method. </p>
<p>This is primarily if you are using the Twitter API for a single user account only (in this case, the account with which you signed in and created the application registration).</p>
<p><img src="/assets/uploads/2010/09/twitOAuth_03-e1284368747846.png" alt="" title="Obtaining the access token information" /></p>
<p>Instantiation of the object has changed slightly from the original release, which asked for only the username and password of the twitter account.</p>
<p>In the revised release, you are required to use the consumer key and secret values. You can optionally add in the access token, access secret and account username values within the init() method if you wish to bypass the OAuth authentication and access the Twitter API using the single user account.</p>
<pre name="code" class="xml">
<cfscript>
	/*
		If you are using this for a number of different accounts
		(allowing numerous users to acces Twitter)
		you will need to specify only the consumerKey and consumerSecret

		If you are using this for a single account only,
		set the oauthToken, oauthTokenSecret and your account name
		in the init() method also.
	*/
	application.objMonkehTweet = createObject('component',
        'com.coldfumonkeh.monkehTweet')
		.init(
			consumerKey			=	'< enter your consumer key >',
			consumerSecret		=	'< enter your consumer secret >',
			/*
			oauthToken			=	'< enter your oauth token  >',
			oauthTokenSecret	=	'< enter your oauth secret >',
			userAccountName		=	'< enter your twitter account name >',
			*/
			parseResults		=	true
		);
	return true;
</cfscript>
</pre>
<p>The project download contains example code on using the OAuth implementation to request access and authorization tokens etc, and how to make a call to the API using an authorized header.</p>
<p>There is also a word and pdf installation document which explains which details you need to get up and running, and how to set up your application.</p>
<p>There is also a link to <a href="http://www.amazon.co.uk/wishlist/B9PFNDZNH4PY" title="View Matt Gifford's Amazon wish list." target="_blank">my Amazon wish list</a>, should you feel warm, tingly and generous :)</p>
<h2>I want it. Where can I get it?</h2>
<p>The revised API wrapper has been updated and is available to download from the official <a href="http://monkehTweet.riaforge.org/" title="Download monkehTweets v1.2 from riaforge.org" target="_blank">monkehTweet.riaforge.org</a> page.</p>
