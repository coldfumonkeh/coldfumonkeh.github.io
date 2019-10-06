<cfimport prefix="MGTags" taglib="../../tags">
<MGTags:layout section="header" metaDesc="(i want my) MTV is a free CFC wrapper written for use with the MTVN API. View and search for artists/bands and videos.">
<MGTags:layout section="body">

<h1>(I want my) MTV CFC</h1>
<div class="descr"></div>

<p>Given a classy name to evoke memories of Dire Straits and 'the good ol' days', this is a ColdFusion CFC wrapper to allow 
ColdFusion developers to interact with the MTV Network API service.</p>

<p>The CFC is available for download now, and includes a breakdown of methods and functions included within.</p>

<p>It's going to be a work in progress, so please feel free to add comments, bugs, issues, and general good tidings on the <a href="http://www.mattgifford.co.uk/blog/?p=40">blog post</a>.</p>

<cfset application.MTV = CreateObject("component", "MTVVids")>

<cfparam name="form.searchTerm" default="" />
<cfparam name="url.searchTerm" default="" />

<cfif form.searchTerm NEQ ''>
	<cfset searchTerm = #form.searchTerm#>
<cfelseif url.searchTerm NEQ ''>
	<cfset searchTerm = #url.searchTerm#>
<cfelse>
	<cfset searchTerm = 'Paramore'>
</cfif>

<cfoutput>

<form name="searchMTV" action="index.cfm" method="post">
<label for"searchTerm">Artist/Band Name: </label><input type="text" id="searchTerm" name="searchTerm" />
<input type="submit" name="submit_btn" id="submit_btn" value="looks for vids" />&nbsp;&nbsp;<img src="http://www.mtv.com/shared/promoimages/powered_by_mtv/powered_by_mtv_icon_black_pink.jpg" alt="powered by MTV" />
</form>

<cfif searchTerm NEQ ''>

<cftry>
<cfset searchVideos = "#application.MTV.searchVideo('#URLDecode(searchTerm)#', 1, 'no')#" />
<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
</cftry>

<cfif searchVideos.success EQ 0>
	<p>Sorry, there were no matches for '#URLDecode(searchTerm)#'.</p>
<cfelse>

<cfif isdefined("searchVideos.artistaliasimages") AND #arrayLen(searchVideos.artistaliasimages)# GT 0>
	<img src="#searchVideos.artistaliasimages[1].url#" width="#searchVideos.artistaliasimages[1].width#" height="#searchVideos.artistaliasimages[1].height#" />
</cfif>

<h2 style="font-size: 12px;">#URLDecode(searchTerm)#</h2>

<table>
<tr>
<cfloop from="1" to="#arrayLen(searchVideos.items)#" index="i">
<cfset thisItem = searchVideos.items[i]>
	<td>
	<h3>#thisItem.title#</h3>
	<embed src="#thisItem.mediaContent.url#"
     width="448" height="366"
     type="#thisItem.mediaContent.type#"
     allowFullScreen="true"
     allowScriptAccess="always" />
	 </td>
</cfloop>
</tr>
</table>

<cfset relatedArtists = application.MTV.getRelatedArtists(searchVideos.artistRelatedLink)>
<p>Related to:<br />
<cfloop from="1" to="#arrayLen(relatedArtists.items)#" index="i">
	<a href="index.cfm?searchTerm=#URLEncodedFormat(relatedArtists.items[i].title)#">#relatedArtists.items[i].title#</a>&nbsp;&nbsp;||&nbsp;&nbsp;
</cfloop>
</p>

</cfif>

</cfif>
</cfoutput>

<h1>Methods Included:</h1>

<ul>
	<li><b>searchVideo</b>: search for a band/artist. Compiles a detailed structure and arrays with artist, video, and related information</li>
	<li><b>getVideoByID</b>: returns detailed data for a specific video</li>
	<li><b>getRelatedArtists</b>: returns detailed struct with information on all artists related to current selection</li>
	<li><b>getArtistAlias</b>: returns detailed struct of alias information for the selected artist</li>
	<li><b>allVideosByArtist</b>: returns detailed struct of all videos for the selected artist/band</li>
	<li><b>artistBrowse</b>: used to draw complete list of all artists/bands within the API. '-' for artists starting with a number, 'a-z' for all other artists</li> 
	<li><b>searchArtist</b>: similar to searchVideo function, only for specific artist information</li>
</ul>

<h2>Download the complete CFC</h2>

<p>The CFC has been released, and is available to download from the RIA Forge project page: <a href="http://iwantmymtv.riaforge.org/" target="_blank">http://iwantmymtv.riaforge.org/</a></p>
<p><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/" target="_blank"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br />This work is licenced under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/" target="_blank">Creative Commons Licence</a>.</p>
	
<MGTags:layout section="footer">