---
layout: post
title: MultiMap API ColdFusion Wrapper
slug: multimap-api-coldfusion-wrapper
date: 2010-06-29
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
<p>At the end of last week, I released a new ColdFusion CFC wrapper to interact with the Multimap API.</p>
<p>I updated the version to 1.1 this morning to include a new method to obtain static map images.</p>
<p>Multimap... seemingly considered obsolete by some since Google steam-rollered into the geocoding mapping arean, making it even easier for people to integrate and work with geographical information.<br />
I must admit, it had been years since I looked at a Multimap generated object, always defaulting to browse the Goog-monster and it's directions for me.</p>
<p>Google makes it incredibly easy to plot a route between multiple points and pull that route direction information.</p>
<p>However, one thing that found incredibly difficult to do using the Google maps API (perhaps due to lack of/hidden documentation or lack of coffee) was to easily obtain the latitude and longitude of every single point of the returned route. A small fun project I was working on at that time would have benefited from this information.</p>
<h2>Multimap to the rescue!</h2>
<p>I found, when browsing through the API and playing with some test responses, that the returned information for route searches contains a wealth of data, including the start and end point in lat/lon format for every point of the journey. Exactly what I was looking for.</p>
<p>I was impressed with the results, and what better way to share the benefit than to write something open source so others can at least try it out themselves too.</p>
<h2>Instantiation</h2>
<p>Instantiating the object requires one parameter, which is the MultiMap API key. To obtain your free key to access the open api, visit the official site here: <a title="Visit MultiMap Open API" href="http://www.multimap.com/openapi/" target="_blank">http://www.multimap.com/openapi/</a></p>
<p>In the below example, I'm also sending through the optional second parameter, parseOutput, to true. This returns any XML or JSON information in structural form. The alternative 'false' option will return the literal string information.</p>
<pre name="code" class="xml">
&lt;!--- set your api key as a variable --->
&lt;cfset strApiKey 		= '&lt; your API key goes here >' /&gt;

&lt;!--- instantiate the object --->
&lt;!---
setting the parseOutput to true to return
structural information (XML and deserialized JSON)
---&gt;
&lt;cfset objMMapSVC		= createObject('component',
							'com.coldfumonkeh.map.multimap').
							init(
								apikey=strApiKey,
								parseOutput=true
							) /&gt;
</pre>
<p>There are four functions within the multimap object, each of which interact with a particular service offered through the API:</p>
<ul>
<li><strong>geoSearch()</strong>: runs a search on the geocoding web service</li>
<li><strong>getRoute()</strong>: runs a search for a route</li>
<li><strong>getConversion()</strong>: converts lat/lon values into Ordnance Survey / Mercator references</li>
<li><strong>getMap()</strong>: generates an image for the map, or returns detailed information for visual representation</li>
</ul>
<h2>Geocoding</h2>
<p>The basic geocode search method contains a variety of optional parameters to send through to help refine your search and the returned data.</p>
<p>In this example, we're running a quick search on the UK postal code WC2N:</p>
<pre name="code" class="xml">
&lt;cfset xmlObj = objMMapSVC.geoSearch(
						postalCode='WC2N',
						countrycode='GB'
					) /&gt;

&lt;cfdump var="#xmlObj#"
		label="Geocoding Results" /&gt;
</pre>
<p>The returned data in this case is fairly succinct and to the point, providing the user with the lat/lon coordinates of the 'approved' location:</p>
<p><img src="/assets/uploads/2010/06/geocodeResults.gif" alt="geocode results" title="geocode results" /></p>
<h2>Routing</h2>
<p>The route search returns a great deal of information, covering the overall journey (including distance, duration and bounding box) to stage and step-specific information, such as written directions, duration, lat/lon coordinates etc.</p>
<pre name="code" class="xml">
&lt;cfset postalCodeList 	= 'WC2N, E3' /&gt;
&lt;cfset countryCodeList 	= 'GB, GB' /&gt;

&lt;!--- map the route between the two postal codes ---&gt;
&lt;cfset xmlObj = objMMapSVC.getRoute(
					postalCode=postalCodeList,
					countryCode=countryCodeList,
					mode='walking') /&gt;

&lt;cfdump var="#xmlObj#"
		label="Route Results" /&gt;
</pre>
<p>A VERY helpful method to use, and the one which fired up my interest in the MultiMap services again.</p>
<p><img src="/assets/uploads/2010/06/routeResults.gif" alt="route results" title="route results" /></p>
<h2>Conversion</h2>
<p>The conversion method does pretty much what it implies. Taking supplied lat/lon coordinates, this will return the x y coordinate equivalents for the same location for use with the Ordnance Survey Grid System. This will also work in reverse, by sending through the x y to obtain their relative lat/lon values.</p>
<pre name="code" class="xml">
&lt;cfset latList = '51.50964,51.52854' /&gt;
&lt;cfset lonList = '-0.12483,-0.02619' /&gt;

&lt;!--- convert the lat/lon into x/y ---&gt;
&lt;cfset xmlObj = objMMapSVC.getConversion(
					lat=latList,lon=lonList
					) /&gt;

&lt;cfdump var="#xmlObj#"
		label="Conversion Results" /&gt;
</pre>
<p>The results of which can be seen here:</p>
<p><img src="/assets/uploads/2010/06/latlonConversion.gif" alt="lat lon conversion results" title="lat lon conversion results" /></p>
<h2>Static Map Generation</h2>
<p>Most, if not all developers have toyed with the Google map integration into some site or other, I'm sure.</p>
<p>JavaScript driven, and dynamically generated within a given DIV element, it is a beautiful, highly extensible system to use, granted.</p>
<p>The Multimap API likes to kick it 'old skool' and generate images for each request using the parameters passed through in the request. This is very reminiscent to me of using the Arc GIS system a few years ago, when I was developing mapping tools for an environmental agency. Not as slick as being able to pan / relocate the map center using a drag and click interface, sure.. but still useful.</p>
<p>In this example, we're creating a static map image of the WC2 area of London using pre-determined lat/lon coordinates. </p>
<p>One thing I did like about these images is the datasource overlay attribute. This queries a MultiMap datasource and overlays pointers/markers directly onto the map image of certain locations / amenities. For instance, below I am asking for the web service to include markers for all ATM machines within the boundary box area of my location.</p>
<p>Again, this may not be as sexy as interactive placeholders as seen on the Google map implementation, but I like the fact that users/ developers have access to their stored information.</p>
<pre name="code" class="xml">
&lt;cfset imgObj = objMMapSVC.getMap(
					lat='51.50964',
					lon='-0.12483',
					overlayDataSource='mm.poi.global.general.atm',
					overlayCount=100,
					overlayLabel='ATM',
					maptype='map',
					zoomFactor=16) /&gt;

&lt;cfdump var="#imgObj#"
		label="Map image response" /&gt;

&lt;cfif structKeyExists(imgObj, 'imgPath')&gt;
	&lt;cfimage action="writeToBrowser" source="#imgObj.imgPath#" /&gt;
&lt;/cfif&gt;
</pre>
<p>The map method result (if using the browser to view the API directly) will display the image instantly.</p>
<p>In the CFC wrapper, I developed the return information for this particular method to return a struct of information, which includes the mime type of the file, the location of the image file on the server (which is written from the byteArray information returned from the original service request and saved into the getTempDirectory() location) and the terms and conditions HTML link, which must be displayed near any generated map, according to the API terms and conditions.</p>
<p><img src="/assets/uploads/2010/06/staticMapResponse.gif" alt="static map response" title="static map response" /></p>
<p>So, in the above code example, you can see we are checking for the existence of the 'imgPath' value within the returned struct and displaying that image directly to the browser, which will display the image like so:</p>
<p><img src="/assets/uploads/2010/06/staticMapImage.gif" alt="static map image" title="static map image" /></p>
<p>Mmmm.. detailed and sexy, I think you'll agree. :)</p>
<h4>Getting image information</h4>
<p>The getMap() method not only returns static images, but is also incredibly useful for returning information about a static image based upon the parameters you send through.</p>
<p>In this example, I am querying the API using a routeKey paramater, which is essentially the start and end coordinates for a route i wish to display on the map image.</p>
<p>I could easily use the same parameters as in the previous image generation example, only the output parameter is no longer requiring an image; instead, we are requesting either JSON or XML.</p>
<pre name="code" class="xml">
&lt;!---
	map image call requesting JSON data;
	no image generated
---&gt;
&lt;cfset routeKeylist	= 'GB,-0.12483:51.50964;0.29551:51.76776,0' /&gt;

&lt;cfset imgObj = objMMapSVC.getMap(
					routekey=routeKeylist,
					maptype='map',
					output='json'
				) /&gt;

&lt;cfdump var="#imgObj#"
		label="Map image response" /&gt;
</pre>
<p>I had to streamline and crop the returned structural information, as it was too long to include on a single blog post... (I dont want you scrolling any longer than you need to, dear reader).</p>
<p>This returned information is incredibly detailed and useful. Consider this at first glances as a mapping equivalent of using the getMetaData() method to read a ColdFusion component. You get a lot of core information about the image and the locations used to generate.</p>
<p><img src="/assets/uploads/2010/06/staticMapData.gif" alt="static map data" title="static map data" /></p>
<p>Other useful structs returned in this response include the automatically generated URL's to the API webservice to instantly obtain the maps surrounding the central location, i.e to pan east,north-east, south-west etc.</p>
<p>I will be displaying these in action in a future blog post, complete with code to implement the image loading, so stay tuned.</p>
<p>All in all, I have found the MultiMap API incredibly simple to use, and surprisingly detailed.</p>
<p>The moral of the story? If there was one, I'd say that you should never turn your back on something otherwise you may miss out on what it can do for you.</p>
<h2>Where can I get it?</h2>
<p>The MultiMap API CFC Wrapper is available to download for free right now from <a href="http://multimap.riaforge.org/" target="_blank" title="Download MultiMap API CFC Wrapper from riaforge.org">http://multimap.riaforge.org/</a></p>
