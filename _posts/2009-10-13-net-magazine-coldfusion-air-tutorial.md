---
layout: post
title: .net magazine ColdFusion / AIR tutorial
slug: net-magazine-coldfusion-air-tutorial
date: 2009-10-13
categories:
- AIR
- ColdFusion
- Flex Apps
- Tutorials
tags:
- .net
- Adobe
- AIR
- ColdFusion
- FLEX
- Tutorial
status: publish
type: post
published: true
---
<p>In line with the release of <a title="Adobe ColdFusion 9" href="http://www.adobe.com/coldfusion" target="_blank">ColdFusion 9</a>, I am pleased to announce that <a title="Fuzzy Orange" href="http://www.fuzzyorange.co.uk" target="_blank">Fuzzy Orange</a>'s very own Andy Allan and I have written a tutorial on ColdFusion as a Service for the  UK's largest Web Design/Development magazine, <a title=".net Magazine" href="http://www.netmag.co.uk/" target="_blank">.net mag</a>.</p>
<p><img class="size-full wp-image-567 alignleft" style="margin-right: 8px;" title=".net magazine November 195" src="/assets/uploads/2009/10/net195cover130.jpg" alt=".net magazine November 195" align="alignleft" /></p>
<p>In the tutorial, featured in the November (195) issue of the magazine, we take you through the process of developing feature rich internet applications that can harness server-side ColdFusion functions without writing a single line of ColdFusion code.</p>
<p>The demo application was immense fun to write - something I could really get my teeth stuck into.</p>
<p>It's an interesting and fun application to showcase a few of the features available to use through the new ActionScript proxy classes shipped with ColdFusion 9.</p>
<p>The application itself allows the user to drag and drop an image onto the main application screen. Using the ColdFusion services now available, the user can then rotate and resize the image from within the AIR application, each time updating and calling back a new image from the ColdFusion server, using the built-in Image() functions.</p>
<p>To further highlight the possibilities now available, the application then allows the user to email the revised/amended image as an attachment to a user-defined email address, which uses the cfmail functionality in ColdFusion.</p>
<p>This is only the tip of the iceberg of some of the exposed functions now available through the new packages. Other proxy tags available for use within MXML applications are:</p>
<ul>
<li>Chart (cfchart)</li>
<li>Document (cfdocument)</li>
<li>Pdf (cfpdf)</li>
<li>Pop (cfpop)</li>
<li>Util (including file upload support)</li>
<li>Config (configuring the application to use ColdFusion services)</li>
<li>Image (cfimage)</li>
<li>Mail (cfmail)</li>
</ul>
<p>PDF creation directly within an AIR application, converting an Office document to PDF, interaction with Ldap, Mail and Pop services and further image manipulation enhance the interoperability between ColdFusion and the MXML scripting languages, and all of this achieved by using the cfservices.swc file, available with all ColdFusion 9 installations, and including it into your Flex/AIR application library path.</p>
<p>The November issue of .net magazine is out today (October 13th), so grab a copy and let us know what you think of the tutorial.</p>
<p><strong>For more information:</strong></p>
<p><a title="ColdFusion ActionScript Proxy Classes" href="http://help.adobe.com/en_US/ColdFusion/9.0/Developing/WS45F7E41F-825B-4fcd-B96D-D5B7E2107E7E.html" target="_blank">Proxy ActionScript classes for ColdFusion Services</a></p>
