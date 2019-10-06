---
layout: post
title: Lyric Search ColdFusion Wrapper
slug: lyric-search-coldfusion-wrapper
date: 2010-07-07
categories:
- ColdFusion
- Components
tags:
- Adobe
- API
- CFC
- ColdFusion
- music
status: publish
type: post
published: true
---
<p>Music makes the world go around. Funny.. I thought it was the conservation of angular momentum. What do I know?</p>
<p>Those that know me will certainly see that I love my music. It's a big part of my life, and something that is always on hand to help your day.</p>
<p>Since writing the <a href="http://www.mattgifford.co.uk/spotify-api-coldfusion-wrapper/">Spotify MetaData API</a> and <a href="http://www.mattgifford.co.uk/lastfmcfc/">Last.FM API</a> wrappers, I wanted to extend these by enhancing the results returned from a music search, and display the lyrics of the selected / queried song.</p>
<p>The open-source code for the Lyric Search API wrapper is available now to download from RIA Forge: <a title="Download lyric search from riaforge.org" href="http://lyricsearch.riaforge.org/" target="_blank">http://lyricsearch.riaforge.org/</a></p>
<h2>What is it?</h2>
<p>The lyricSearch ColdFusion wrapper interacts with a lyrcis database API provided by <a title="Visit lyricsfly.com" href="http://lyricsfly.com/" target="_blank">lyricsfly</a>. Registration is free, and the service requires a permanent API key to access the full, un-restricted results, which can be obtained from a request form on their site.</p>
<p>However, they do offer a temporary API key (that is generated on a weekly basis) to access the API and test the implementation of your code against it.</p>
<p>The CFC wrapper contains only two methods, which are:</p>
<ol>
<li>search for lyrics by the artist AND song title</li>
<li>search for lyrics by a text string</li>
</ol>
<h3>Instantiate the lyricSearch object</h3>
<p>Invoking the object is a simple matter of passing through the one required parameter, which is the API key.</p>
<pre name="code" class="xml">
<cfscript>
	// current temporary key at time of writing
	strAPIKey = '42cbcce797c8ec06f-temporary.API.access';
	// invoke the component
	/* parseOutput is set to true,
		to get a structural representation of the response */
	objLyrics = createObject('component',
				'com.coldfumonkeh.lyricsfly.lyrics').init(
					apiKey=strAPIKey,
					parseOutput=true
				);
</cfscript>
</pre>
<p>Here, I am also sending through the parseOutput parameter, which is actually true by default. This boolean value controls the output generated from the API wrapper, and if set to true, will return the response in a structural format (parsed XML or structural JSON). If false, the response will be in a literal string format.</p>
<h2>Search using artist and track name</h2>
<pre name="code" class="xml">
&lt;!---
	Run a search for an artist and track title.
	Bring back the response in JSON format,
	and convert the placeholder [br] tags into
	the actual HTML tags.
--->
&lt;cfset artistResults =
		objLyrics.searchArtistTitle(
			artist="Butch Walker",
			title="If",
			format="json",
			convertHTML=true
		) />

&lt;cfdump var="#artistResults#"
		label="artist / song query results" /&gt;
</pre>
<p>The code above is fairly self-explanatory. One of the parameters (convertHTML) is an optional boolean value set to false by default. In any response from the API, the lyrics text contains forced line-break tags, but in a placeholder format, like so:</p>
<blockquote><p>And if I could be the chains, I'd fall from you and let you fly to the angels[br]<br />
If I could be your pain I'd run from you, so far away.[br]</p></blockquote>
<p>Now, this wouldn't be a problem for any user to take this response and replace the placeholders with the correct HTML tags to output onto the screen. </p>
<p>However, it seems like an extra effort that the end user really shouldn't have to worry about and manage themselves; the API should handle that for them, or at least give them the option to choose to do so, which is why the CFC wrapper contains convertHTML boolean parameter.</p>
<h4>Replacing XML object values</h4>
<p>Converting and replacing the sub-strings within the API response was very easy.</p>
<p>All response directly from the API are returned as XML, and so it's very easy to run a search within the XML object for all track responses, which will generate an array, thanks to xmlSearch().</p>
<p>We can then loop over the array, and run a replaceNoCase() function on every lyric text xml node in the response and update the HTML tags, as seen in the code snippet below:</p>
<pre name="code" class="xml">
&lt;cfset var xmlObj 	= xmlParse(arguments.response) />
&lt;cfset var arrText 	= '' />

&lt;!--- Run this if we want to convert the HTML --->
&lt;cfif arguments.convertHTML>
	&lt;!--- Create an array of tracks --->
	&lt;cfset arrText 	= xmlSearch(xmlObj, '/start/sg/tx') />
	&lt;cfif arraylen(arrText)>
		&lt;cfset intLoop = 1 />
		&lt;!---
			Loop over the array, and replace all instances
			of the placeholder tags with the correct HTML
		--->
		&lt;cfloop array="#arrText#" index="i">
			&lt;cfset xmlObj.start.sg[intLoop].tx.xmlText =
				replaceNoCase(i.xmlText, '[br]', '&lt;br />', 'all') />
			&lt;!--- Increment the loop ---&gt;
			&lt;cfset intLoop ++ />
		&lt;/cfloop>
	&lt;/cfif>
&lt;/cfif&gt;
</pre>
<p>After any conversions have (or haven't, depending on the selection) been done, the CFC then returns the response to the user, and the example above would generate the following structural response:</p>
<p><img src="/assets/uploads/2010/07/lyricsearchJSON.gif" alt="lyricSearch JSON response" title="lyricSearch JSON response" /></p>
<h2>Search using a text string</h2>
<p>The second method within the API lets you query the database using a text string, like so:</p>
<pre name="code" class="xml">
&lt;!--- Run a search for a lyric string ---&gt;
&lt;cfset lyricsResults =
			objLyrics.searchLyric(
				lyric="just a shot away",
				format="xml",
				convertHTML=true
			) /&gt;
&lt;cfdump var="#lyricsResults#"
		label="lyrics query results" /&gt;
</pre>
<p>The resulting output for this call returns an XML object finding any matches to the supplied string:</p>
<p><img src="/assets/uploads/2010/07/lyricSearchXML.gif" alt="lyricSearch XML response" title="lyricSearch XML response" /></p>
<p>The first result was the correct song I was looking for, which was "Gimme Shelter" by the Rolling Stones (one of the greatest songs of all time, in my opinion).</p>
<h2>Where can I get it?</h2>
<p>The code is available to download from RIAforge.org, here: <a href="http://lyricsearch.riaforge.org/" title="Download the Lyric Search CFC Wrapper from riaforge.org" target="_blank">http://lyricsearch.riaforge.org/</a></p>
