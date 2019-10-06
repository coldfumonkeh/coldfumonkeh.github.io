---
layout: post
title: ColdFusion Security Hotfix
slug: coldfusion-security-hotfix
categories:
- ColdFusion
tags:
- Adobe
- ColdFusion
status: publish
type: post
published: true
date: 2013-11-13
---
<p>Yesterday (12th November 2013) a new hotfix was released with security updates applicable to ColdFusion versions 10, 9.0.2, 9.0.1 and 9 for Windows, Mac and Linux.</p>
<p>To quote the <a title="ColdFusion security update bulletin" href="http://www.adobe.com/support/security/bulletins/apsb13-27.html" target="_blank">official bulletin</a>, "this hotfix addresses a reflected cross site scripting vulnerability that could be exploited by a remote, authenticated user on ColdFusion 10 and earlier when the CFIDE directory is exposed. "</p>
<p>If your ColdFusion 10 server is behind a firewall or you are unable to access / use the automatic update feature there are instructions on how to implement the update manually here: <a title="ColdFusion 10 Hotfix Installation Guide" href="http://blogs.coldfusion.com/post.cfm/coldfusion-hotfix-installation-guide" target="_blank">http://blogs.coldfusion.com/post.cfm/coldfusion-hotfix-installation-guide</a> . Look for the section titled "What can be done if the ColdFusion server is behind the firewall and can't access the Adobe's Update site URL?"</p>
<p>I would also strongly recommend reading the ColdFusion server lockdown guides:</p>
<ul>
<li><a title="ColdFusion 9 server lockdown guide" href="http://www.adobe.com/content/dam/Adobe/en/products/coldfusion/pdfs/91025512-cf9-lockdownguide-wp-ue.pdf" target="_blank">ColdFusion 9</a></li>
<li><a title="ColdFusion 10 server lockdown guide" href="http://www.adobe.com/content/dam/Adobe/en/products/coldfusion/pdfs/cf10/cf10-lockdown-guide.pdf" target="_blank">ColdFusion 10</a></li>
</ul>
