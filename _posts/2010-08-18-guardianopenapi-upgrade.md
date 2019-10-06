---
layout: post
title: Guardian Open API CFC Wrapper
slug: guardianopenapi-upgrade
date: 2010-08-18
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
<p>Way back in March 2009, <a title="View the original post on mattgifford.co.uk" href="http://www.mattgifford.co.uk/guardianopenplatform/">I released a ColdFusion component wrapper</a> to interact with the (then in Alpha/Beta stages) Guardian OpenAPI to access content from the Guardian.</p>
<p>Sadly, I negated to follow up the initial release of the code and to update the wrapper once the API had been pushed into a formed release. I have punished myself with wooden spoons and bamboo sticks as penance.</p>
<p>I am pleased to say that I have now (finally) updated the CFC wrapper to include the current up-to-date implementation of the API and available methods for use within your ColdFusion applications.</p>
<h2>What Does It Do?</h2>
<p>There is a lot of information available to read on the official <a title="Visit the official Guardian Open Platform site" href="http://www.guardian.co.uk/open-platform" target="_blank">Guardian site for the open platform</a>. The underlying use of the API is to access over 1 Million articles across the last 10 years, including current content. Essentially, the Guardian are opening up a shed load (yep, it's an official form of measurement) of their content for free.</p>
<p>There are tiered access levels (three, I believe) from which you can obtain more information and resources from the API requests, but the free version is incredibly detailed from what I've seen so far.</p>
<h2>What's In It?</h2>
<p>There are four main methods within the API, which are:</p>
<ul>
<li>Content Search</li>
<li>Item Search</li>
<li>Tag Search</li>
<li>Section Search</li>
</ul>
<h2>What has changed in the update?</h2>
<p>The methods available for use have been amended. The parameters for each method have completely changed from the initial release I made in march last year. The API developers revised most of the arguments for each method, and more or less started again from scratch.</p>
<p>I have also revised the folder structure for the wrapper, which now sits happily in a separate package structure as you would expect.</p>
<p>In addition to these changes, the API now officially handles JSON response requests. In the initial release, only XML was allowed as a response format, and I had written in a function to convert the XML to JSON within the wrapper to return JSON if requested by the user. An API isn't truly an API in my opinion if it doesn't offer a choice of response formats though, and I'm certainly glad this was finally amended.</p>
<h3>Let's see it in action then</h3>
<p>OK</p>
<h2>Instantiation</h2>
<p>Creating and instantiating the object is incredibly simple, and requires one parameter, the API key. There is an optional second parameter, set to true by default which handles the output of the data. If true, the XML will be parsed or the JSON will be returned in structural format, depending on your chosen return format.</p>
<pre name="code" class="xml">&lt;cfset strKey = '&lt; your api key &gt;' /&gt;

&lt;cfset openAPI = createObject(
					'component',
					'com.coldfumonkeh.guardian.openAPI'
				)
				.init(
					apikey=strKey,
					parseOutput=true
				) /&gt;

&lt;---
	Let's search on a specific tag, and return
	the results in JSON format, limited to 3 results
---&gt;
&lt;cfset openResults = openAPI.tags(
					q='Literature',
					format='json',
					pagesize=3
				) /&gt;

&lt;cfdump var="#openResults#"
		label="Results from the openAPI call." /&gt;</pre>
<p>In the above example, we are running a quick tag search on the keyword 'literature', limiting the response to 3 items and requesting the data in JSON format.</p>
<p>The response from the above code call would be similar to below:</p>
<p><img title="guardianTagSearch" src="/assets/uploads/2010/08/guardianTagSearch.gif" alt="guardianTagSearch" /></p>
<p>Let's take another look at a quick easy example. This time, we'll run a content search for anything containing 'iPhone', and we'll filter the results for content published on or after a particular date:</p>
<pre name="code" class="xml">&lt;cfset openResults = openAPI.search(
						q='iPhone',
						page=1,
						format='json',
						fromdate='2010-08-17'
					) /&gt;</pre>
<p><img title="guardianContentSearch" src="/assets/uploads/2010/08/guardianContentSearch.gif" alt="guardianContentSearch" /></p>
<p>Incredibly easy to implement, and a lot of detailed content available for your use, should you so wish.</p>
<p>I won't bore you too much with extra code samples; the full code available to download has some code examples to get you started.</p>
<h2>Where do I get it?</h2>
<p>The revised, updated Guardian Open Platform API CFC Wrapper is available to download now from <a title="Download the Guardian Open Platform API CFC Wrapper from riaforge.org" href="http://guardianopenplatform.riaforge.org/" target="_blank">guardianopenplatform.riaforge.org</a>.</p>
