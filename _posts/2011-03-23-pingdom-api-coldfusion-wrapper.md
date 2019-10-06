---
layout: post
title: Pingdom API ColdFusion Wrapper
slug: pingdom-api-coldFusion-wrapper
categories:
- ColdFusion
- Projects
tags:
- API
- CFC
- ColdFusion
- slider
status: publish
type: post
published: true
date: 2011-03-23
---
<p>For any who don't know, <a title="Visit www.pingdom.com" href="http://www.pingdom.com" target="_blank">Pingdom</a> is a service that offers web site monitoring and notification.. a pretty sweet little application, and fairly powerful from what I've seen of it so far.</p>
<p>It turns out that yesterday they announced the release of their API in public beta. I love writing ColdFusion components to interact with external APIs, and as this was a new one (and one which I will certainly have a use for in various projects, and i'm fairly sure others may find it useful too) I wrote a CFC to interact with the services and API.</p>
<h2>Pingdom API</h2>
<p>The API itself is pretty cool, and lets you manipulate the entire system and set up monitor checks, find details on specific checks, set up users and manage notification settings. Although the API itself is split into a few sections (users, checks, settings etc) I decided to write one CFC to contain all methods and functions, instead of branching out and trying to separate various methods.</p>
<h3>The pingdom object</h3>
<p>The actual pingdom.cfc component is incredibly easy to instantiate and work with. At present, the API only allows for JSON responses, which although not quite opening up the full benefit of REST interfaces, is certainly enough to keep going for the moment.</p>
<p>You need to have an account with Pingdom to work with the API. They have paid services, but also offer a free account with limited resources; this may be enough for most people to play around with. Once you have an account, you also need to register your application to obtain an application key, which is required to proceed.</p>
<pre class="xml">&lt;!--- Instantiate the component ---&gt;
&lt;cfset objPingdom = createObject(
						'component',
						'com.coldfumonkeh.pingdom.pingdom'
					).init(
						emailAddress	=	'&lt; email address &gt;',
						password		=	'&lt; account password &gt;',
						applicationKey	=	'&lt; application key &gt;',
						parse			=	true
					) /&gt;</pre>
<p>In the above example, I've also set an optional fourth argument (parse) to true. This will return any response from the API as a structural representation instead of the literal string to help make debugging a little easier.</p>
<p>I have one 'check' with my free account, and i want to set it up to monitor my site www.mattgifford.co.uk using an HTTP request. I want it to email me AND send me a twitter message if anything goes down.</p>
<p>Here's how I do that:</p>
<pre class="xml">&lt;!--- Create a new check for my site ---&gt;
&lt;cfset checkStatus = objPingdom.createCheck(
						name			=	'Check My Site',
						host			=	'mattgifford.co.uk',
						type			=	'http',
						sendtoemail		=	true,
						sendtotwitter	=	true
					) /&gt;

&lt;cfdump var="#checkStatus#" /&gt;</pre>
<p>There are more arguments and parameters to use so set up a whole host of different monitors and checks. You can have SMTP, Ping checks, IMAP, POP3 and more..</p>
<p>The response from my create request brings back the name and the id the new check:</p>
<p><img title="Check Created" src="/assets/uploads/2011/03/checkCreated.gif" alt="Check Created" /></p>
<p>And running a further command getCheckDetail() and passing in the returned ID of the new check, we can confirm the details have been set:</p>
<p><img title="check detail" src="/assets/uploads/2011/03/checkDetail.gif" alt="check detail" /></p>
<h2>A Single Test</h2>
<p>I want to run a quick test on a domain to make sure it's up and running. Again, there are a multitude of parameters I could send through for this, but we'll stick with another simple example.. we only want to check a standard domain is present and working.</p>
<pre class="xml">&lt;!---
	Run a quick check on a single domain.
	A 'quick fix' to ensure it's up and running.
---&gt;
&lt;cfset checkStatus = objPingdom.makeSingleTest(
						host	=	'coldfumonkeh.com',
						type	=	'http'
					) /&gt;

&lt;cfdump var="#checkStatus#" /&gt;</pre>
<p>The single test is a great way to run a quick check.. the results confirm status and response time, and also which probe was used to run the test. This was selected by the system at random, although you can specify a particular probe to use, if you so desire.</p>
<p><img title="Single Test Results" src="/assets/uploads/2011/03/singleTestResults.gif" alt="Single Test Results" /></p>
<p>There is much more to be managed and manipulated with the API, and it's a pretty cool service they're offering. I know for certain that I'll be using the CFC in many projects to come, and I hope you guys find it of use too.</p>
<h2>Where can I get it?</h2>
<p>The code is available to download from RIAforge.org here: <a title="Download the Pingdom API ColdFusion wrapper from riaforge.org" href="http://pingdom.riaforge.org" target="_blank">http://pingdom.riaforge.org</a></p>
<p>It is also available to download and for collaboration from my github repository here: <a title="Visit the pingdom API repository on github.com" href="https://github.com/coldfumonkeh/pingdom-API" target="_blank">https://github.com/coldfumonkeh/pingdom-API</a></p>
