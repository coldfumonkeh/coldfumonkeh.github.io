<cfimport prefix="MGTags" taglib="../../../tags">
<MGTags:layout section="header">
<MGTags:layout section="body">

<h1>Papervision 3D</h1>
<div class="descr">Thurs, 11 Sept. 2008 17:36:00 GMT</div>

<p>I'm a bit late in the game for this, but I've been having a look at Papervison 3D, and integrating it into Flex.<br />
It's a bit of a 'standard' application, but here's my first attempt at using the library, creating a 3d sphere with bitmap texture.</p>
<p>A proper 'Hello World' example. :)</p>

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
	attributes.id = "PapervisionTest";
	attributes.name = "PapervisionTest";
	attributes.align = "middle";
	swfobject.embedSWF("PapervisionTest.swf", "flexContainer", "200", "200", "9.0.28", "swfobject/expressInstall.swf", flashvars, params, attributes);
</script>

<div id="flexContainer" style="border: 1px solid ##ff0000; width: 600px; height: 200px; text-align: center;">
	<p>Ooops. This feature requires the Adobe Flash Player to run.<br />
	<a href=http://www.adobe.com/go/getflash/>Get Flash now so you don't miss out on this, or anything else!</a></p>
</div>
</cfoutput>

<MGTags:layout section="footer">