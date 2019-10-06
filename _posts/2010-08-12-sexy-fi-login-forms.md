---
layout: post
title: Sexy-fi your login forms
slug: sexy-fi-login-forms
date: 2010-08-12
categories:
- Development
- jQuery
tags:
- ColdFusion
- jQuery
- Wordpress
status: publish
type: post
published: true
---
<p>I've been looking into some UX issues this week, and various other front end components to make a client's site more aesthetically pleasing, which is always fun.</p>
<p>Now, I won't lie.. I also use Wordpress as a blogging platform.. yeah yeah, a ColdFusion developer using a PHP application. The truth is, I've used it from day one as a blogger (I've been doing this in various forms for the last 6 years, believe it or not), and it's constantly being updated. It's a great system with some fantastic developers behind it, as well as a very clean design principle.</p>
<p>Now, logging into a Wordpress blog the other day I mixed up my password with one of the million or so that I use (couple that with the fact I'm getting old and forgetful...) and I received a really pleasant surprise from Wordpress (version 3).</p>
<p>After the failed login, the entire login form shook a few times, and displayed above it is the error information box. That was a really nice addition; they could have just stuck with the traditional big red "YOU MESSED UP, YOU IDIOT" message you see on so many sites.</p>
<p>This reminded me of something else; One of the presentations I was able to escape long enough to attend at Scotch on the Rocks 2011 was one from <a title="Vist Aral's site" href="http://aralbalkan.com/" target="_blank">Aral Balkan</a>, title "The Art of Emotional Design: a story of pleasure, joy, and delight". A fantastic presentation, and one which really makes you think about developing or adding details in to your applications to make your users go "oooh" instead of "oh.."</p>
<p>...which is what happened here (which is a good thing).</p>
<h2>Shake what you got</h2>
<p>Instantly I wanted to emulate it and create something similar. Wordpress is packed with classes and action hooks to load in specific actions when required.</p>
<p>To create a very simple equivalent, I'm using the very powerful jQuery UI library, which has a shake effect baked in - awesome.</p>
<p>You can view the video using the link at the top of this post, or watch it directly on <a title="View this video on YouTube" href="http://youtu.be/jRiSmWKkNOQ" target="_blank">YouTube</a>.</p>
<p>Here's the core of the login form created for the demo:</p>
<p><strong>index.cfm</strong></p>
<pre name="code" class="xml">&lt;!---
Name: index.cfm
Author: Matt Gifford aka coldfumonkeh
Date: 11/08/2010
Purpose:
	Login form to demonstrate the use
	of the jQuery UI's shake effect.
---&gt;
&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
		"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"&gt;
&lt;html xmlns="http://www.w3.org/1999/xhtml"
		dir="ltr" lang="en-US"&gt;
&lt;head&gt;
	&lt;title&gt;Login&lt;/title&gt;
	&lt;meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /&gt;
	&lt;link rel='stylesheet'
			href='assets/css/login.css'
			type='text/css' media='all' /&gt;
	&lt;link rel='stylesheet'
			href='assets/css/ui-lightness/jquery-ui-1.8.4.custom.css'
			type='text/css' media='all' /&gt;
	&lt;script src="assets/js/jquery-1.4.2.min.js"
			type="text/javascript"&gt;&lt;/script&gt;
	&lt;script src="assets/js/jquery-ui-1.8.4.custom.min.js"
			type="text/javascript"&gt;&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;

&lt;div id="login"&gt;
	&lt;!---
		Here, we set an empty div which we'll populate
		and add styles using the jQuery UI classes.
	---&gt;
	&lt;div id="login_message"&gt;&lt;/div&gt;
	&lt;!---
		Uber-simple login form. Username and password fields.
		No more, no less.
	---&gt;
	&lt;form name="loginform" id="loginform" onsubmit="return false;"&gt;
		&lt;p&gt;
			&lt;label for="username"&gt;Username&lt;br /&gt;
			&lt;input type="text"
					name="username"
					id="username"
					class="inputFields"
					value=""
					size="20"
					tabindex="1" /&gt;
			&lt;/label&gt;
		&lt;/p&gt;
		&lt;p&gt;
			&lt;label for="password"&gt;Password&lt;br /&gt;
			&lt;input type="password"
					name="password"
					id="password"
					class="inputFields"
					value=""
					size="20"
					tabindex="2" /&gt;
			&lt;/label&gt;
		&lt;/p&gt;
		&lt;p class="submit"&gt;
			&lt;input type="button"
					name="btnLogin"
					id="btnLogin"
					value="Log In"
					tabindex="3" /&gt;
		&lt;/p&gt;
	&lt;/form&gt;

&lt;/div&gt;
&lt;!---
	Bring on the jQuery.
---&gt;
&lt;/body&gt;
&lt;/html&gt;</pre>
<p>Nothing out of the ordinary going on here.. in fact the WHOLE process is incredibly simple. In this example, we're just sending through username and password parameters, and are validating against a fixed authentication; I'm not querying a database in this instance.</p>
<p>The authentication process returns a boolean value, which we'll use in the jQuery handling to determine succes (or not).</p>
<p><strong>checkLogin.cfm</strong></p>
<pre name="code" class="xml">&lt;!---
Name: checkLogin.cfm
Author: Matt Gifford aka coldfumonkeh
Date: 11/08/2010
Purpose:
	Dummy login authentication page
	checking against static information.
---&gt;
&lt;cfsetting enablecfoutputonly="true" showdebugoutput="false" /&gt;
&lt;cfparam name="boolSuccess" type="boolean" default="false" /&gt;

&lt;cfif structKeyExists(form, 'username')
		AND structKeyExists(form, 'password')&gt;
	&lt;cfif form.username EQ 'random1000' AND form.password EQ 'password'&gt;
		&lt;cfset boolSuccess = true /&gt;
	&lt;/cfif&gt;
&lt;/cfif&gt;

&lt;cfoutput&gt;#boolSuccess#&lt;/cfoutput&gt;</pre>
<p>The actual core of the work is within the jQuery script, which in itself is still pretty straightforward.</p>
<p>In the example below, we're using jQuery's AJAX method to send the form and it's data to the checkLogin.cfm page.</p>
<p>Using the boolean response as a status to monitor the authentication success, we can then handle the form and any processes that we need to take care of:</p>
<p><strong>index.cfm (jQuery code)</strong></p>
<pre name="code" class="xml">&lt;script type="text/javascript"&gt;
$(document).ready(function(){
	$("#username").focus();

	$("#btnLogin").click(function(){
		/*
		 * The login button has been clicked.
		 * Send an AJAX POST request to the checkLogin.cfm
		 * page, which will work out the authentication for us.
		 * We will receive a boolean value in the response.
		 */
		$.ajax({
		  url: "checkLogin.cfm",
		  type: "POST",
		  cache: false,
		  data: "username=" + $("#username").val()
				+ "&amp;password=" + $("#password").val(),
		  success: function(status){
			if(status == 'false') {
				/*
				 * The authentication was a failure. As such, we'll let
				 * the user down gently with a smile and shake the login
				 * form. This will act as notification and a little
				 * 'crowd pleasing' effect to brighten their day.
				*/
				$("#loginform").effect("shake", {times:2}, 100);
				/*
				 * Set the Class attribute for the message element
				 * and set the html value with the ERROR message.
				*/
				$("#login_message")
					.attr('class', 'ui-state-error')
					.html('&lt;strong&gt;ERROR&lt;/strong&gt;:
							Your details were incorrect.&lt;br /&gt;');
			} else {
				/*
				 * The authentication was a resounding success! Good times.
				 * Set the Class attribute for the message element
				 * and set the html value with the SUCCESS message.
				*/
				$("#login_message")
					.attr('class', 'ui-state-highlight')
					.html('&lt;strong&gt;PERFECT&lt;/strong&gt;:
							You may proceed. Good times.&lt;br /&gt;');
			}
		  }
		});
	})
});
&lt;/script&gt;</pre>
<p>Using jQuery's UI, we are able to not only set the shake effect and apply it to the entire loginForm div element, we are also able to set the class attributes for the login_message element and apply the styles from the CSS themes available with the UI framework.</p>
<h2>Shake it yourself</h2>
<p>The only true way to enjoy is to experience yourself. :)</p>
<p>The full code for this example is available to download.</p>
<p><a title="Download the loginShake example" href="http://www.monkehworks.com/downloads/demo_code/loginShake_coldfumonkeh.zip" target="_blank"><br />
<img class="size-full wp-image-260" title="Download the loginShake example" alt="Download the loginShake example" src="/assets/uploads/2009/03/ico-download.png" /></a></p>
