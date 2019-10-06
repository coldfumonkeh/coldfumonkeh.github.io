---
layout: post
title: Shareaholic API ColdFusion Wrapper
slug: shareaholic-api-coldfusion-wrapper
categories:
- ColdFusion
- Projects
tags:
- API
- ColdFusion
status: publish
type: post
published: true
date: 2011-06-13
---
<p>Crawling through my code library and various directories in ColdFusion Builder earlier today, I stumbled across a project that I had started in January 2011 but had never released (although it was complete).</p>
<p>A few minor tweaks and changes to tidy up some code and prep it for release, please find the long-overdue Shareaholic API ColdFusion wrapper.</p>
<h2>The What?</h2>
<p>OK, so I've built it up a little and may need to explain what it is.. far enough.</p>
<p>Shareaholic allows you to share links to an ever-growing number of online services and popular social media sites without having to worry about writing complex links or dealing each individual site's API or preferred method of URL formatting.</p>
<p>Through the API, you can simply and easily build a single URL for each service or site you wish to offer the ability to post to, and Shareaholic handles the rest of the formatting for each specific service.</p>
<p>It is ideal way to allow readers to share blog posts, articles and online magazines, and is now available to use in your ColdFusion applications!</p>
<h3>What's Included</h3>
<p>The ColdFusion implementation consists of one component containing of four public methods:</p>
<ul>
<li>buildLink</li>
<li>shareCount</li>
<li>topUsers</li>
<li>getServiceListAsArray</li>
</ul>
<h2>The How</h2>
<p>To start using the service, you need to obtain an API key from Shareaholic. Head over to <a title="Register a new application with Shareaholic" href="http://www.shareaholic.com/developers/apps/new" target="_blank">http://www.shareaholic.com/developers/apps/new</a> to register your application.</p>
<p><img title="Shareaholic - registering an application to access the API" src="/assets/uploads/2011/06/shareaholic_app_registration.png" alt="Shareaholic - registering an application to access the API" /></p>
<p>Registering your application will provide you with the API key required to access.</p>
<h2>Instantiating the component</h2>
<p>Instantiation of the Shareaholic component is simple, and the API key is the only required parameter.</p>
<pre name="code" class="java">objShareaholic = createObject(
					"component",
					'com.coldfumonkeh.shareaholic.shareaholic'
				).init(
					apiKey='&lt; your api key goes here &gt;'
				);</pre>
<p>The second optional parameter is the version number for the API - the default value is "1" and is set in the component.</p>
<h2>Building a link</h2>
<p>Building a link is a simple case of calling the buildLink method from the component and sending through the three required parameters: apitype, service and the link you wish to share.</p>
<pre name="code" class="java">strURL = objShareaholic.buildLink(
			apitype		=	'1',
			service		=	'7',
			link		=	'http://www.adobe.com/products/coldfusion/',
			notes		=	'This is a kickass server language.',
			title		=	'ColdFusion Rocks',
			tags		=	'ColdFusion,Adobe,awesome',
			shortener	=	'jmp',
			source		=	'Matt Gifford aka coldfumonkeh'
		);</pre>
<p>There are a number of services currently available to use, and the official API doesn't appear to have a method of easily searching / listing these dynamically. The component provides the <strong>getServiceListAsArray</strong> function to return an array of these:</p>
<pre name="code" class="java">&lt;cfdump var="#objShareaholic.getServiceListAsArray()#" /&gt;</pre>
<p>Which returns an array of structs, each struct containing the name of the service and the numeric ID of the service which you'll need to send through to the API.</p>
<h3>Customising the link</h3>
<p>The other parameters in the example above are some of the extra arguments available to help customise the link and whatever message is sent / posted by the user.</p>
<p>The above example will generate a link like so:</p>
<p>http://www.shareaholic.com/api/share/?source=Matt%20Gifford%20aka%20coldfumonkeh&amp;v=1&amp;tags=ColdFusion%2CAdobe%2Cawesome<br />&amp;link=http%3A%2F%2Fwww%2Eadobe%2Ecom%2Fproducts%2Fcoldfusion%2F&amp;service=7&amp;<br />
apikey=3c911829d7a4c9dad42961984fe68efa3&amp;shortener=jmp&amp;apitype=1&amp;notes=This%20is%20a<br />
%20kickass%20server%20language%2E&amp;title=ColdFusion%20Rocks</p>
<p>In this example the service ID of 7 relates to Twitter (the official docs don't have these in alphabetical order, or any order it would appear), the title is displayed as part of the message and the shortener asks for the link to be automatically shortened by one of the predefined services, in this case j.mp.</p>
<p>Clicking on the link will take the user to Twitter with the custom message and an automatically-shortened URL, like so:</p>
<p><img title="Generating a link" src="/assets/uploads/2011/06/shareaholic_first_link.png" alt="Generating a link" /></p>
<p>If sending to Twitter, you can create a more specific custom message using templates using the variables in the request call. For example, sending this revised method call with the template tags:</p>
<pre name="code" class="java">strURL = objShareaholic.buildLink(
		apitype		=	'1',
		service		=	'7',
		link		=	'http://www.adobe.com/products/coldfusion/',
		notes		=	'This is a kickass server language.',
		title		=	'ColdFusion Rocks',
		tags		=	'ColdFusion,Adobe,awesome',
		shortener	=	'jmp',
		source		=	'Matt Gifford aka coldfumonkeh',
		// add in the template parameter to customise
		template	=	'Check this out from ${source}:
							(${short_link}) %23ColdFusion %23API'
);</pre>
<p>results in the following output (using the generated variables to create a customised message:</p>
<p><img title="Generating a link with a template" src="/assets/uploads/2011/06/shareaholic_template_link.png" alt="Generating a link with a template" /></p>
<p>The api also allows you to send through a specific short url (if you already have one) and if you have an account with bit.ly or su.pr you can also send across your username / api key with that service to make sure your shortened urls are logged and stored in your account.</p>
<h2>The Rest</h2>
<p>The other two methods are part of the data api and allow you to see how many times a certain domain has been shared through the service, and who has shared it the most. Pretty useful stuff!</p>
<p>I've found this to be a really useful API, and (although releasing later than planned) hope you guys find it of help too.</p>
<h2>Where can I get it?</h2>
<p>Right here: <a title="Download the wrapper from riaforge.org" href="http://shareaholic.riaforge.org/" target="_blank">shareaholic.riaforge.org</a> or here <a title="Download the wrapper from github" href="https://github.com/coldfumonkeh/Shareaholic" target="_blank">https://github.com/coldfumonkeh/Shareaholic</a></p>
