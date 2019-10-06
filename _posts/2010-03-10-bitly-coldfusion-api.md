---
layout: post
title: Bit.ly URL Shortening Service ColdFusion API
slug: bitly-coldfusion-api
date: 2010-03-10
categories:
- ColdFusion
- Projects
tags:
- API
- CFC
- ColdFusion
status: publish
type: post
published: true
---
<p>Shrink it, expand it, explore it, understand it... there are a few things you can do with a URL if you use the <a title="Visit the bit.ly site" href="http://bit.ly/" target="_blank">bit.ly</a> URL service.</p>
<p>To make things a little easier for ColdFusion developers and URL-shrinking fans alike, I've built a ColdFusion CFC wrapper to interact with the bit.ly service API. Your URL shortening concerns may now be a thing of the past. :)</p>
<p>The open-source code is available now to download from RIA Forge: <a title="Download bitly from riaforge.org" href="http://bitly.riaforge.org/" target="_blank">http://bitly.riaforge.org/</a></p>
<h2>What is it?</h2>
<p>The bit.ly API service requires an active account. <a title="Register for your bit.ly account" href="http://bit.ly/account/register" target="_blank">Registration is free</a>, and once created you will be provided with the API key required to use the API.</p>
<p>The API only offers five functions, so it's not an overly complex model to work with. These functions are:</p>
<ol>
<li>Shorten a URL</li>
<li>Expand a URL back to the original</li>
<li>Obtain information on a shortened URL</li>
<li>Get stats on the URL such as traffic and referrer data</li>
<li>Get a list of error codes from the API</li>
</ol>
<h3>Instantiate the bit.ly object</h3>
<p>Invoking the object is a simple matter of passing through the two required parameters; the bit.ly username and API key.</p>
<pre name="code" class="html">
&lt;cfscript&gt;
	strUser = 'your bit.ly account name'
	strKey	= 'your bit.ly api key'

	// instantiate the object
	objBitly = createObject('component',
		'com.coldfumonkeh.bitly.bitly').
		init(username=strUser,apikey=strKey,parse=true);
&lt;/cfscript&gt;
</pre>
<p>In the above code example, I am also sending through an optional parameter called 'parse'. Set to false by default, the returned data will be in literal string format. Set to true as it is now, XML responses will be returned using the XmlParse() function, and JSON response using the DeserializeJSON() function, hopefully providing the developer an easier option to view when debugging or working with the data.</p>
<p>You can also set the response format 'globally' (ie for all methods within the CFC). By default, this is set to 'XML', and all methods will return XML-formatted data.<br />
You can choose to set this across the board for all functions, or specify an individual return format per-method using the format argument, which will override the global setting.</p>
<h4>Strip it down</h4>
<p>In the following example, we are sending a request through to shorten a specific URL, and are overriding the global return format for this method by asking for the response in JSON format.</p>
<pre name="code" class="html">
// let's shorten a URL
shorten = objBitly.shorten(
		longURL='http://www.scotch-on-the-rocks.co.uk/',
		format='json');
</pre>
<p>As we have set the global 'parse' parameter to true, the output will be returned to us as ColdFusion structural information, as seen here:</p>
<p><img src="/assets/uploads/2010/03/bitly_shorten_response.gif" alt="bitly_shorten_response" title="bitly_shorten_response" /></p>
<h4>Blow it back up</h4>
<p>Let's now run a reverse on the URL we have just shortened to obtain the original URL, using the expand() method. This function will allow you to provide either the shortURL or the hash key generated and provided with the shorten response.</p>
<pre name="code" class="html">
// let's expand a URL using a bit.ly short URL
expand = objBitly.expand(shortURL='http://bit.ly/bQ8Nbv');
// or by using the bit.ly hash
expand = objBitly.expand(hash='OWJV4');
</pre>
<p>In the above example, I have not provided a specific return format, so the global default option is used and will return XML, as below:</p>
<p><img src="/assets/uploads/2010/03/bitly_expand_response.gif" alt="bitly_expand_response" title="bitly_expand_response" /></p>
<h4>Grabbing some information</h4>
<p>Let's now run the info() method to see what data we can retrieve from the same shortened URL. As with the previous method, you could choose to run this method using either the shortURL or the hash parameter:</p>
<pre name="code" class="html">
// get info on a shortURL or hash
info = objBitly.info(shortURL='http://bit.ly/bQ8Nbv',format='JSON');
</pre>
<p>The response from the info() request pulls back a lot of detailed information read from the target page, including meta-data stripped from the head tags. It will also provide you with the username of the original 'shrinkee'.</p>
<p><img src="/assets/uploads/2010/03/bitly_info_response.gif" alt="bitly_info_response" title="bitly_info_response" /></p>
<h4>Get your facts</h4>
<p>The stats() method allows you to view information on the traffic and referrers on a particular shortURL or hash. Total clicks, referrer address details and clicks per site are included in the response.</p>
<p>Getting this information is incredibly easy:</p>
<pre name="code" class="html">
// get info on a shortURL
info = objBitly.info(shortURL='http://bit.ly/bQ8Nbv',format='JSON');
</pre>
<p>The response from the above example can be seen below, again in Deserialized JSON format as we have provided the global parse and per-method format parameters.</p>
<p><img src="/assets/uploads/2010/03/bitly_stats_response.gif" alt="bitly_stats_response" title="bitly_stats_response" /></p>
<h3>Sounds good. Where can I get it?</h3>
<p>The bit.ly API ColdFusion wrapper is available to download now from RIA Forge: <a title="Download bitly from riaforge.org" href="http://bitly.riaforge.org/" target="_blank">http://bitly.riaforge.org/</a></p>
