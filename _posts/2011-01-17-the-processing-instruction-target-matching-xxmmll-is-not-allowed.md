---
layout: post
title: The processing instruction target matching "[xX][mM][lL]" is not allowed
slug: the-processing-instruction-target-matching-xxmmll-is-not-allowed
categories:
- ColdFusion
tags:
- ColdFusion
- XML
date: 2011-01-17
---
<p>Whilst working on the Scotch on the Rocks 2011 site, I also created a mini-api to power the application and to allow remote access for external applications.</p>
<p>During testing of the XML output, I received a strange error message that I had not previously encountered:</p>
<blockquote><p>The processing instruction target matching "[xX][mM][lL]" is not allowed</p></blockquote>
<p>The work in question was converting a ColdFusion query recordset into an XML document with one node per row of data returned. It turns out the issue was arising due to whitespace at the top of the document, and was resolved by removing the whitespace from the CF code generating the XML content.</p>
<pre name="code" class="java">
&lt;cfsavecontent
variable="strReturnData"&gt;&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;rootNode&gt;
	&lt;totalrecords&gt;&lt;/totalrecords&gt;
	&lt;cfoutput query="myQuery"&gt;
	&lt;itemNode&gt;

	&lt;/itemNode&gt;
    &lt;/cfoutput&gt;
&lt;/rootNode&gt;
&lt;/cfsavecontent&gt;
</pre>
<p>Notice how the XML tag starts immediately after the cfsavecontent tag closes at the top? Yes, I had to sacrifice beautifully laid out, tabbed code, but it removed the whitespace from the top of the document, and this error was dealt with.</p>
