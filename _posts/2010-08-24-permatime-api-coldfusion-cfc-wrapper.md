---
layout: post
title: Permatime API ColdFusion CFC Wrapper
slug: permatime-api-coldfusion-cfc-wrapper
date: 2010-08-24
categories:
- ColdFusion
tags:
- Adobe
- API
- CFC
- ColdFusion
status: publish
type: post
published: true
---
<p>A few days ago I was made aware of the great little site <a title="Visit permatime.com" href="http://permatime.com" target="_blank">permatime.com</a></p>
<h2>What Time Is It?</h2>
<p>A fantastic mini-app, this site is ideal for online meetings or perhaps events that require attendees from across the globe.</p>
<p>By setting the timezone for the event as part of the link, any users following that URL will see the details of the event/party/conference etc in their own local time zone.</p>
<h2>Oooh, an API</h2>
<p>To my delight, the permatime team had documented every parameter needed to generate a permatime URL, thereby letting users generate the links off site.</p>
<p>Of course, not wanting to miss an opportunity, I wanted to have some fun and create a ColdFusion wrapper for this service, which is available to download now from riaforge and is incredibly easy to use indeed.</p>
<pre name="code" class="xml">
&lt;cfscript&gt;
	// instantiate the permatime component
	objPermatime = createObject('component',
				'com.coldfumonkeh.permatime.permatime')
				.init();

	/* For a list of available location/timezones,
		please visit http://permatime.com/timezones
	*/

	strPermLink = objPermatime.buildLink(
			location 	= 'Europe/England',
			date		= '2010-08-27',
			time		= '14:00',
			label		= '80sFriday',
			link		= 'http://www.monkehradio.com/'
		);
&lt;/cfscript&gt;
</pre>
<p>It really is that easy to use the wrapper, and the resulting value of the strPermLink variable will be the generated link to the permatime site, which in this case would be:</p>
<p><a href="http://permatime.com/Europe/England/2010-08-27/14:00/80sFriday?link=http://www.monkehradio.com/" title="The generated link from the permatime API Wrapper" target="_blank">http://permatime.com/Europe/England/2010-08-27/14:00/80sFriday?link=http://www.monkehradio.com/</a></p>
<p>Following that permatime link, you would be greeted with the following information, which you could then email on or alter the time zones.</p>
<p><img src="/assets/uploads/2010/08/permatimeExample.gif" alt="permatimeExample" title="permatimeExample" /></p>
<p>The wrapper also contains a second function which enables you to generate a permatime link using a unix time stamp, like so:</p>
<pre name="code" class="xml">
&lt;cfscript&gt;
	strPermLink2 = objPermatime.buildTimestampLink(
			timestamp 	= '1226183760'
			/*
			* This function can also accept a label and link attribute
			*/
		);
&lt;/cfscript&gt;
</pre>
<p>I can see this service with so many uses; implementations into CMS or diary / event applications to name a few.</p>
<p>And of course, if you needed to shrink the links after generation, you could always pass them through <a href="http://www.mattgifford.co.uk/updated-bitly-cfc/" title="View the post 'Updated Bit.ly ColdFusion Wrapper' on mattgifford.co.uk">my bit.ly API CFC Wrapper</a> :) *<strong>cross promotion is always a good thing</strong>*</p>
<h2>Where can I get it?</h2>
<p>The code is available to download from RIAforge.org, here: <a href="http://permatime.riaforge.org/" title="Download the permatime CFC Wrapper from riaforge.org" target="_blank">http://permatime.riaforge.org/</a></p>
