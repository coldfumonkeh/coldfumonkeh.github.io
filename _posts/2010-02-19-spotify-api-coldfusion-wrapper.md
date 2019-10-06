---
layout: post
title: Spotify API ColdFusion Wrapper
slug: spotify-api-coldfusion-wrapper
date: 2010-02-19
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
<p>Having a little more fun this evening, I decided to knock up a quick little CFC wrapper to interact with the Spotify MetaData API. The full open source code can be downloaded from <a title="Download spotifyAPI from riaforge.org" href="http://spotifyapi.riaforge.org/" target="_blank">http://spotifyapi.riaforge.org/</a>.</p>
<h2>Spotify MetaData API</h2>
<p>The MetaData API allows users to explore <a title="Spotify.com" href="http://www.spotify.com/" target="_blank">Spotify</a>’s music catalogue. Sadly, the API as of yet doesn't allow for interaction with playlists. For me, that would be ideal - creating and editing playlists and their content from the API. It's on my Christmas list, I guess my card didnt make it to the Spotify HQ though. :)</p>
<p>Until more of the content is accessible through the service, the MetaData API will hopefully provide some level of comfort to the developers aching to get started building Spotify-based applications.</p>
<h3>The spotify object</h3>
<p>The spotify.cfc component is incredibly simple. It has two public methods (outlined below) that allow the user to run the API calls.</p>
<p>At the moment, Spotify only allow XML responses from the API. The component is set by default to return the XML data as a string.</p>
<p>However, this can be toggled when instantiating the component by passing in a '<strong>true</strong>' boolean value, which will return the data using the XmlParse() function, as shown below:</p>
<pre name="code" class="java">
&lt;cfscript&gt;
// instantiate the object and enable struct output
objSpotify = createObject('component',
		'com.coldfumonkeh.spotify').init(structOutput=true);
&lt;/cfscript&gt;
</pre>
<h3>Search</h3>
<p>The first of the two methods available is the search function.</p>
<p>The API allows you to search for albums, artists or tracks. To keep things simple, one method was created in the spotify.cfc component to cater for all searches.</p>
<p>The method accepts three params;</p>
<ol>
<li>searchMethod - required string. Allows you to specify either Album, Artist or Track.</li>
<li>query - required string. The string to search for, which will be sent as a URL parameter in the remote call.</li>
<li>page - non-required string (default 1). The page of the result set to return.</li>
</ol>
<h3>Search example</h3>
<p>Running a simple search for an artist is fairly simple, as seen in the code below:</p>
<pre name="code" class="java">
&lt;cfscript&gt;
// instantiate the object
objSpotify = createObject('component',
		'com.coldfumonkeh.spotify').init(structOutput=true);

// artist search for Butch Walker
result = objSpotify.search(searchMethod='artist',
				query='Butch Walker');
&lt;/cfscript&gt;
</pre>
<p>The search method then generates the correct URL to pass through in the cfhttp GET request:</p>
<p><strong>http://ws.spotify.com/search/1/artist?q=Butch%20Walker&page=1</strong></p>
<p>The response for this (and any call within the wrapper) is sent through another function that validates the returned status code. Anything other than a '200 OK' response will not be allowed; the process will abort, and the user will be informed of the issue.</p>
<p>The response returned from the search above will output as shown here:</p>
<p><img title="butchWalker_artistSearchxml" src="/assets/uploads/2010/02/butchWalker_artistSearchxml.gif" alt="butchWalker_artistSearchxml" /></p>
<p>Running a similar search, I'm now searching for one of my favourite albums, 'Sycamore Meadows'</p>
<pre name="code" class="java">
&lt;cfscript&gt;
// instantiate the object
objSpotify = createObject('component',
		'com.coldfumonkeh.spotify').init(structOutput=true);

// album search for Sycamore Meadows
result = objSpotify.search(searchMethod='album',
				query='Sycamore Meadows');
&lt;/cfscript&gt;
</pre>
<p>Using the same search function, by changing the searchMethod parameter, the URL generated is amended accordingly, as so:</p>
<p><strong>http://ws.spotify.com/search/1/album?q=Sycamore%20Meadows&page=1</strong> </p>
<p>A portion of the response is shown here:</p>
<p><img src="/assets/uploads/2010/02/searchSycamoreMeadows.gif" alt="searchSycamoreMeadows" title="searchSycamoreMeadows" /></p>
<h3>Lookup</h3>
<p>The second of the two methods available is the lookup function, which allows you to look up information contained for a specific Spotify URI.</p>
<p>The method accepts two params;</p>
<ol>
<li>URI - required string. The Spotify URI.</li>
<li>detailLevel - required string (default 'Off'). The level of data returned within the response.</li>
</ol>
<h3>Lookup example</h3>
<p>Using the URI returned from the last search example above, let's run a lookup on the Sycamore Meadows album:</p>
<pre name="code" class="java">
&lt;cfscript&gt;
// instantiate the object
objSpotify = createObject('component',
		'com.coldfumonkeh.spotify').init(structOutput=true);

// run a lookup on the given URI
result = objSpotify.lookup(URI='spotify:album:5vL0AkqmcSoYxwyaiOq0i8',
		detailLevel='off');
&lt;/cfscript&gt;
</pre>
<p>The detailLevel parameter was set to 'Off', so we'll receive the bare minimum response from the API.</p>
<p><img title="sycamoreMeadows_noDetailXML" src="/assets/uploads/2010/02/sycamoreMeadows_noDetailXML.gif" alt="sycamoreMeadows_noDetailXML" /></p>
<p>The detailLevel has three settings:</p>
<ol>
<li>Off</li>
<li>Low</li>
<li>High</li>
</ol>
<p>Changing the detailLevel on the same lookup to 'Low' will yield more information in the response:</p>
<p><img title="sycamoreMeadows_lowDetailXML" src="/assets/uploads/2010/02/sycamoreMeadows_lowDetailXML.gif" alt="sycamoreMeadows_lowDetailXML" /></p>
<p>You can now see the addition of the child node 'tracks', containing all tracks and their URI's. These URI's can then be taken and used in a further lookup to obtain more information.</p>
<h2>Where can I get it?</h2>
<p>The code is available to download from RIAforge.org, here: <a title="Download spotifyAPI from riaforge.org" href="http://spotifyapi.riaforge.org/" target="_blank">http://spotifyapi.riaforge.org/</a></p>
