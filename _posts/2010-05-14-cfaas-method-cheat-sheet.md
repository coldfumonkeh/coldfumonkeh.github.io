---
layout: post
title: ColdFusion as a Service - method cheat sheet
slug: cfaas-method-cheat-sheet
date: 2010-05-14
categories:
- ColdFusion
tags:
- Adobe
- ColdFusion
status: publish
type: post
published: true
---
<p>I'm a massive fan of the ColdFusion as a Service feature added in to ColdFusion 9.</p>
<p>As my natural development path progressed from pure CF into adopting Flex technologies and practices, the integration between the two core languages and development platforms (CFML &amp; Flex) became more important.</p>
<p>I've blogged about <a title="ColdFusion as a Service (Part 1)" href="http://www.mattgifford.co.uk/coldfusion-as-a-service-part-1/" target="_blank">creating an AIR application in Flex using the CFaaS feature</a>, have presented on it at last year's European Scotch on the Rocks tour, and at the online CFMeetup presentations (<a title="CF Online Meetup" href="http://www.meetup.com/coldfusionmeetup/calendar/13162484/?from=list&amp;offset=0" target="_blank">which you can view here and enjoy my crude jokes about MC Hammer</a>)</p>
<h2>Web Service Use</h2>
<p>Of course the ability to utilise the exposed service layers is not explicitly granted to Flash/Flex users. A few of the core ColdFusion components have been opened up to allow non-CF developers to access and use these methods in their native languages, using the CFCs as a WSDL.</p>
<h2>Documentation, where are you?</h2>
<p>Following on from a thread in a Google group earlier this morning, it was pointed out, quite rightly, that unfortunately the documentation on this new addition is a little sparse to say the least.</p>
<p>Most, if not all, CF Developers will know how to implement and parse a web service, and as such the need to write an example on how to do this, especially to read a web service that runs ColdFusion methods IN ColdFusion, is kind of pointless.</p>
<p>There are basic examples of implementing the services in other languages, but nothing too detailed.</p>
<p>I WILL be covering this in more detail in part 2 of the ColdFusion as a Service tutorial posts.</p>
<p>The fundamental issue raised this morning was the fact that there seems to be no documentation on the methods available within the exposed components (with the exception of opening up the WSDL in either your browser or within ColdFusion Builder's remote services browser).</p>
<p>In an attempt to resolve this issue, I have compiled a rough (but hopefully detailed enough) PDF file that lists all of the methods available within the exposed service components, and all parameters accepted by each method.</p>
<p>I hope this will be of some help to those wanting to investigate or develop applications using the CFaaS features.</p>
<h2>Download It</h2>
<p>You can <a title="Download the CFaaS Service Method PDF " href="http://www.monkehworks.com/downloads/CFaaS_ServiceMethods.pdf" target="_blank">download the PDF file here</a></p>
