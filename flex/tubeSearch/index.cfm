<cfimport prefix="MGTags" taglib="../../tags">
<MGTags:layout section="header">
<MGTags:layout section="body">

<h1>FLEX You Tube Search application</h1>
<div class="descr">Fri, 25 Jul 2008 15:27:00 GMT</div>

<p>Built around the source code for my previous FLEX/Tube app (<A HREF="http://www.mattgifford.co.uk/flex/myTube/" alt="FLEX myTube" title="FLEX myTube">myTube</a>), I wanted to play around with the search functionality offered by the youtube API.</p>
<p>Although only a simple application, a search is made for keywords entered, and the XML is returned from the API. Flex loops through the namespaces and groups to collect the relevant information, and the video is requested and then played.</p>
<p>As this is only the alpha release of this version, it doesn't take into account any restrictions for playing videos (such as restriction by country) and so at the moment the app only displays a connection error message.</p>
<p>I will be adding this handling very soon, and would love to build on this to also include multiple results displayed as thumbnails, allowing the user to select from the search results instead of the 'random generated' video they get returned.</p>
<p>Still, not bad for a few hours of playing.</p>


<cfoutput>
<script type="text/javascript" src="#application.rootURL#scripts/swfobject/swfobject.js"></script>
<script type="text/javascript">
	var flashvars = {};
	var params = {};
	params.play = "true";
	params.loop = "false";
	params.quality = "high";
	params.bgcolor = "##000000";
	params.allowscriptaccess = "sameDomain";
	flashvars.endPoint = "";
	var attributes = {};
	attributes.id = "youtubeSearch";
	attributes.name = "youtubeSearch";
	attributes.align = "middle";
	swfobject.embedSWF("tubeSearch.swf", "flexContainer", "600", "300", "9.0.28", "swfobject/expressInstall.swf", flashvars, params, attributes);
</script>

<div id="flexContainer" style="border: 1px solid ##ff0000; width: 600px; height: 300px;">
	<p>Ooops. This feature requires the Adobe Flash Player to run.<br />
	<a href=http://www.adobe.com/go/getflash/>Get Flash now so you don't miss out on this, or anything else!</a></p>
</div>
</cfoutput>

<MGTags:layout section="footer">