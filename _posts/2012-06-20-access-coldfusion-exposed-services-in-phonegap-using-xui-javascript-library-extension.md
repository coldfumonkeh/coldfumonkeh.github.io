---
layout: post
title: Access ColdFusion Exposed Services In PhoneGap Using XUI JavaScript Library
  Extension
slug: access-coldfusion-exposed-services-in-phonegap-using-xui-javascript-library-extension
categories:
- ColdFusion
- Mobile
tags:
- ColdFusion
- Mobile
- PhoneGap
status: publish
type: post
published: true
date: 2012-06-20
---
<p>I'm a big fan of the ColdFusion as a Service exposed service layer. I've <a title="ColdFusion as a Service" href="http://www.mattgifford.co.uk/coldfusion-as-a-service-part-1" target="_blank">written about it before</a>, spoken about it at conferences and written about it for magazine articles and tutorials.</p>
<p>It's super-easy for AIR / Flex developers to invoke the services using a .swc file provided in the ColdFusion installation. With minimal code, you can access a number of functions on the server-side, including sending mail, image manipulation and file uploads</p>
<p>Non CF-developers can also access these features by calling the exposed services via a web service request. Awesome!</p>
<h2>The Problem</h2>
<p>Wouldn't it be nice to be able to access these CFaaS methods from another path? As the popularity for mobile application development increases, largely thanks to open-source frameworks and libraries including the awesome PhoneGap project, mobile developers cannot access these exposed services unless they write AJAX commands and build every request URL, append the parameters and get bogged down in code that could potentially use up valuable network resources and increase the size of the overall application.</p>
<h2>The Solution</h2>
<p>I've been working on an extension of the <a title="xuijs.com" href="http://xuijs.com/" target="_blank">XUI</a> JavaScript library that will fully manage access to the ColdFusion exposed services within your PhoneGap applications. Built with ease of use and simplicity in mind, the syntax to declare methods and perform these tasks has been ported over from the current way that the cfservices.swc file allows Flex / AIR developers to access them.</p>
<p>I also chose to use XUI as the base JS library as it is incredibly small (10.4Kb or 4.2Kb gzipped), and at the moment the extension is only 5.96Kb (3.08Kb compressed), meaning that the overall application file size still remains quite small.</p>
<h2>How Do I Use It?</h2>
<p>To create a connection to your remote ColdFusion server you simply define the parameters within the config() method, which takes an object of name / value pairs.</p>
<p>To send an email you would create a mail function, which again contains an object of parameters. You would then call the send() method, passing in the ID of the mail request you have defined. This means you can have more than one set up to send emails to different people with different contents.</p>
<p>Image manipulation is the same. With your image function created, call the execute() method to run that task. The XUI plugin generates the remote URL using the details set in the config() function and processes the XmlHttpRequest for you.</p>
<p>To manage the data, you can pass in your result and fault callback handlers to execute any further processing of the results.</p>
<pre name="code" class="html">&lt;!DOCTYPE HTML&gt;
&lt;html&gt;
  &lt;head&gt;
    &lt;meta http-equiv="Content-type" content="text/html; charset=utf-8"&gt;
    &lt;title&gt;XUI&lt;/title&gt;
    &lt;script type="text/javascript" charset="utf-8" src="xui.js"&gt;&lt;/script&gt;
    &lt;script type="text/javascript" charset="utf-8" src="cfmobile.js"&gt;&lt;/script&gt;
	&lt;script type="text/javascript" charset="utf-8"&gt;

    	x$.ready(function() {

			var myImage = x$('#myImage').attr('src');

			// Set up your access details here
			/*
				Remember to create the user in the CFAdmin
				with access to the Mail and image services
			*/
			x$.config(
				{
					id : 'testCFAAS',
					cfPort : 8500,
					cfServer : '127.0.0.1',
					serviceUserName : 'cfaas',
					servicePassword : 'cfaas'
				}
			);

			// Wanna send mail from HTML / Mobile?
			/*
				Enter your mail server settings here
				along with the message details
			*/
			x$.mail({
				server 		: "", // smtp server settings
				port 		: 25,
				username 	: '', // mail username
				password 	: '', // mail password
		        to 			: "",
				from 		: "",
		        subject 	: "Sent from cfmobile",
				content 	: "Hello World!",
		        type 		: "text",
		        useTLS 		: "true",
				/*
					Your callbacks can be predefined like so,
					or you can write them inline
				*/
		        result 		: handleResult,
		        fault 		: handleError,
				id 			: 'sendMailTest'
			});

			x$.image({
				method 	: "crop",
		        source 	: myImage,
				x 		: 50,
				y 		: 25,
				width 	: 300,
				height 	: 450,
				id 		: 'cropimage',
				result 	: function() {
					console.log(this.responseText);
				}
			});

			x$.image({
				method 	: "grayscale",
		        source 	: myImage,
				id 		: 'grayimage',
				result 	: function() {
					console.log(this.responseText);
				}
			});

			// Register event handlers
			x$('#emailButton').on('click', function() {
				// Send the email by referencing the id
				x$.send('sendMailTest');
			});

			x$('#cropButton').on('click', function() {
				// Execute any other service request (not mail) by using the execute() method
				x$.execute('cropimage');
			});

			x$('#grayscaleButton').on('click', function() {
				x$.execute('grayimage');
			});

		});

		function handleResult() {
			console.log('--- email success ---');
			console.log(this.response);
		};

		function handleError() {
			console.log('--- email error ---');
			console.log(this.response);
		};

	&lt;/script&gt;
&lt;/head&gt;
&lt;body&gt;

	&lt;h2&gt;cfmobile XUI extension&lt;/h2&gt;
	&lt;p&gt;Lightweight addition to XUI library.&lt;/p&gt;

	&lt;button id="emailButton"&gt;Send Email&lt;/button&gt;
	&lt;button id="cropButton"&gt;Crop Image&lt;/button&gt;
	&lt;button id="grayscaleButton"&gt;Grayscale Image&lt;/button&gt;

	&lt;img src="http://www.insidethewebb.com/content/2011/01/cfhour.png" id="myImage" /&gt;

&lt;/body&gt;
&lt;/html&gt;</pre>
<h2>Coming Soon</h2>
<p>The code is in final stages of an alpha release, which will contain at least the functionality to access the image manipulation methods and the ability to send email directly from your mobile application via the ColdFusion server.</p>
<p>Work is currently underway to complete the upload functions and document / pdf generation and manipulation.</p>
<p>Thanks to <a href="http://blog.dkferguson.com/" title="http://blog.dkferguson.com/" target="_blank">Dave Ferguson</a> (<a href="http://twitter.com/dfgrumpy" title="http://twitter.com/dfgrumpy" target="_blank">@dfgrumpy</a>) for providing some time and resources to help test the plugin using local AND remote servers, we both have some demo PhoneGap applications that successfully use the plugin for access to the exposed services.</p>
<p>I will notify the world when the alpha release has been pushed out to the various online repositories.</p>
<p>So, what do you think? Will it be of use to you?</p>
