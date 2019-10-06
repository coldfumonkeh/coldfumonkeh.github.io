<cfimport prefix="MGTags" taglib="../../tags">
<MGTags:layout section="header">
<MGTags:layout section="body">

<h1>FLEX You Tube application</h1>
<div class="descr">Wed, 09 Jul 2008 12:00:00 GMT</div>

<p>This is the first fun FLEX project that I've been working on, and I'm very proud of it, and what I've learnt in the process. 
The original idea was to create a more dynamic interactive method of sharing some of my favourite videos from YouTube.</p>
<p>The base source code was taken from <a href="http://dougmccune.com" target="_blank">Doug McCune's</a> fantastic coverflow carousel. The carousel was superb, but within the source code all of the elements were hard-coded onto the stage.</p>
<p>I wanted to make the whole thing as dynamic as possible, and generate the elements within the ActionScript calls, cutting out any hard coding.</p>
<p>This application draws the data from an XML playlist, which contains the artist, song title, and reference ID. 
The required thumbnail images are saved onto the server for each video to be displayed.</p>
<p>The FLEX app then loops through the XML, generating the panels, images and buttons within the loop, populating the stage.</p>
<p>Viewing the video, a state transition is performed to switch to the video player, which reads in the XML for the chosen video to display the video information, 
and starts to stream the video directly from YouTube.</p>
<p>There are a lot of amendments and addtional functions to place into the application, but for now, I'm happy with the results!</p> 

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
	attributes.id = "CoverFlow_FlexControls";
	attributes.name = "CoverFlow_FlexControls";
	attributes.align = "middle";
	swfobject.embedSWF("CoverFlow_FlexControls.swf", "flexContainer", "600", "300", "9.0.28", "swfobject/expressInstall.swf", flashvars, params, attributes);
</script>

<div id="flexContainer" style="border: 1px solid ##ff0000; width: 600px; height: 300px;">
	<p>Ooops. This feature requires the Adobe Flash Player to run.<br />
	<a href=http://www.adobe.com/go/getflash/>Get Flash now so you don't miss out on this, or anything else!</a></p>
</div>
</cfoutput>

<MGTags:layout section="footer">