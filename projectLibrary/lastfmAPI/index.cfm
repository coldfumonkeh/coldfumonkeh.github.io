<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
	<meta name="author" content="Luka Cvrk (www.solucija.com)" />
	<meta http-equiv="content-type" content="text/html;charset=iso-8859-2" />
	<script src="jquery-latest.js" type="text/javascript"></script>
	<script src="custom.js" type="text/javascript"></script>
	<link rel="stylesheet" href="style.css" type="text/css" />
	<title>(I want my) lasftm demo</title>
</head>
<body>	
	<div class="content">
		<div class="header_right">
			<div class="top_info">
				<div class="top_info_right">
					<p>
						<cfif not isdefined("session.AuthToken")>
							Have a last.fm account? <a href="?login=1">Log in</a>		
						<cfelse>
						Hi <strong><cfoutput>#session.userInfo.name#</cfoutput></strong>.&nbsp; 
						<a href="?clear=1">Log out</a>
						</cfif>
					</p>					
				</div>		
			</div>
					
			<div class="bar">

			</div>
		</div>
			
		<div class="logo">
			<h1><a href="index.cfm" title="(I want my) LastFM demo home">I want my <span class="red">LastFm</span></a></h1>
			<p>CFC wrapper for API-coolness</p>
		</div>
		
		<div class="search_field">
			<form method="post" action="?">
				<p><span class="grey">Search:</span>
				<select name="searchType" id="searchType">
					<option value="album">Album</option>
					<option value="artist">Artist</option>
					<option value="track">Track</option>
				</select>
				&nbsp;&nbsp; <input type="text" name="searchValue" id="searchValue" class="search" /> <input type="button" value="Search" class="button" name="searchBtn" id="searchBtn" /></p>
			</form>
		</div>
		
		<div class="newsletter">
			<p></p>
		</div>
		
		<div class="subheader">
			<p>This demo site was built to highlight some of the features and methods available within the lastfm API wrapper.<br />
			As an example site, not all methods are used here.</p>
		</div>
		
		<div id="leftContent" class="left">
			<div class="left_articles">
				<h2>The brief introduction</h2>
				<p>This demo uses the (<strong>I want my) lastfm API CFC</strong> wrapper and jQuery to create and process the AJAX requests.</p>
				<p>This is in no way a complete demonstration, simply a visual way to display how the CFC and it's methods interact with the API.</p>
				<p>The complete project is available to download from <a href="http://iwantmylastfm.riaforge.org" title="iwantmylastfm.riaforge.org" target="_blank">iwantmylastfm.riaforge.org</a></p>
			</div>
						
			<div class="lt"></div>
			<div class="lbox">				
				<cfif isdefined("session.AuthToken")>
					<cfset arg = StructNew() />
					<cfset arg["user"]="#session.userInfo.name#" />
					<cfset arg["return"]="query" />
					<cfset recentTracks = api.methodCall('user','getRecentTracks',arg)>
				<h2>Your Recently Played Tracks</h2>
				<cfif recentTracks.recordcount LT 8>
					<cfset recentLoopTo = recentTracks.recordcount />
				<cfelse>
					<cfset recentLoopTo = 8 />
				</cfif>
				<cfoutput>
				<p>
				<cfloop from="1" to="#recentLoopTo#" index="recent">
				<a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#recentTracks.artistName[recent]#','artist','getInfo','struct','leftContent');getInfo('artist:#recentTracks.artistName[recent]#','artist','getEvents','query','rightBox1');getInfo('artist:#recentTracks.artistName[recent]#','artist','getTopTags','query','rightBox2');getInfo('artist:#recentTracks.artistName[recent]#','artist','getTopTracks','query','rightBox3');">#recentTracks.artistName[recent]#</a> - 
				<a style="cursor: pointer;" title="View track information" onclick="getInfo('artist:#recentTracks.artistName[recent]#|track:#URLEncodedFormat(recentTracks.name[recent])#','track','getInfo','struct','rightBox1');">#recentTracks.name[recent]#</a><br />
				</cfloop>
				</p>
				</cfoutput>
				
				<cfelse>
				
					<h2>Top Ten Tags</h2>
					
						<cfset arg = StructNew() />
						<cfset arg["return"]="query" />
						<cfset topTags = api.methodCall('tag','getTopTags',arg) />
						
						<cfoutput>
						<p>
						<cfloop from="1" to="8" index="recent">
						#topTags.name[recent]# (#topTags.count[recent]# instances)<br />
						</cfloop>
						</p>
						</cfoutput>
				</cfif>
			</div>
								
			<div class="lt"></div>
			<div class="lbox">
			
				<cfif isdefined("session.AuthToken")>
					<cfset arg = StructNew() />
					<cfset arg["user"]="#session.userInfo.name#" />
					<cfset arg["sessionKey"]="#session.key#" />
					<cfset arg["return"]="query" />
					<cfset recommededArtists = api.methodCall('user','getRecommendedArtists',arg)>
				<h2>Your Recommended Artists</h2>
				<cfif recommededArtists.recordcount LT 8>
					<cfset recentLoopTo = recommededArtists.recordcount />
				<cfelse>
					<cfset recentLoopTo = 8 />
				</cfif>
				<cfoutput>
				<p>
				<cfloop from="1" to="#recentLoopTo#" index="recent">
				<a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#recommededArtists.name[recent]#','artist','getInfo','struct','leftContent');getInfo('artist:#recommededArtists.name[recent]#','artist','getEvents','query','rightBox1');getInfo('artist:#recommededArtists.name[recent]#','artist','getTopTags','query','rightBox2');getInfo('artist:#recommededArtists.name[recent]#','artist','getTopTracks','query','rightBox3');">#recommededArtists.name[recent]#</a><br />
				</cfloop>
				</p>
				</cfoutput>
				
				<cfelse>
				
					<cfset arg = StructNew() />
					<cfset arg["user"]="mattgifford" />
					<cfset arg["return"]="query" />
					<cfset recentTracks = api.methodCall('user','getRecentTracks',arg)>
					<h2>MY Recently Played Tracks</h2>
					<cfif recentTracks.recordcount LT 8>
						<cfset recentLoopTo = recentTracks.recordcount />
					<cfelse>
						<cfset recentLoopTo = 8 />
					</cfif>
					<cfoutput>
					<p>
					<cfloop from="1" to="#recentLoopTo#" index="recent">
					<a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#recentTracks.artistName[recent]#','artist','getInfo','struct','leftContent');getInfo('artist:#recentTracks.artistName[recent]#','artist','getEvents','query','rightBox1');getInfo('artist:#recentTracks.artistName[recent]#','artist','getTopTags','query','rightBox2');getInfo('artist:#recentTracks.artistName[recent]#','artist','getTopTracks','query','rightBox3');">#recentTracks.artistName[recent]#</a> - 
					<a style="cursor: pointer;" title="View track information" onclick="getInfo('artist:#recentTracks.artistName[recent]#|track:#URLEncodedFormat(recentTracks.name[recent])#','track','getInfo','struct','rightBox1');">#recentTracks.name[recent]#</a><br />
					</cfloop>
					</p>
					</cfoutput>
					
				</cfif>
			
			</div>
		</div>	
		<div class="right">
						
			<div class="rt"></div>
			<div id="rightBox1" class="right_articles">
				<cfoutput>
				<cfif isdefined("session.AuthToken")>
				<p><img src="#session.userInfo.image#" alt="Image" title="Image" class="image" width="50" height="75" /><strong>#session.userInfo.name#</strong><br />
					<strong>Playcount:</strong> #session.userInfo.playcount#<br />
					<strong>Playlists:</strong> #session.userInfo.playlists#<br />
					<strong>Subscriber:</strong> #session.userInfo.subscriber#
				</p>
				<cfelse>
				<p>Search for an album, track or artist using the form above.</p>
				</cfif>
				</cfoutput>
			</div>
			<div class="rt"></div>
			<div id="rightBox2" class="right_articles">
				<p>Desktop application, AIR application, web site, mashup - what could you do with this API?</p>
			</div>
			<div class="rt"></div>
			<div id="rightBox3" class="right_articles">
				
				<cfset arg = StructNew() />
				<cfset arg["user"]="mattgifford" />
				<cfset arg["return"]="query" />
				<cfset myLoved = api.methodCall('user','getLovedTracks',arg) />
				
				<p><strong>MY Recently Loved Tracks</strong></p>
				<cfif myLoved.recordcount LT 8>
					<cfset recentLoopTo = myLoved.recordcount />
				<cfelse>
					<cfset recentLoopTo = 8 />
				</cfif>
				<cfoutput>
				<p>
				<cfloop from="1" to="#recentLoopTo#" index="recent">
				<a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#myLoved.artistName[recent]#','artist','getInfo','struct','leftContent');getInfo('artist:#myLoved.artistName[recent]#','artist','getEvents','query','rightBox1');getInfo('artist:#myLoved.artistName[recent]#','artist','getTopTags','query','rightBox2');getInfo('artist:#myLoved.artistName[recent]#','artist','getTopTracks','query','rightBox3');">#myLoved.artistName[recent]#</a> - 
				<a style="cursor: pointer;" title="View track information" onclick="getInfo('artist:#myLoved.artistName[recent]#|track:#URLEncodedFormat(myLoved.name[recent])#','track','getInfo','struct','rightBox1');">#myLoved.name[recent]#</a><br />
				</cfloop>
				</p>
				</cfoutput>
			</div>
		</div>	
		<div class="footer">
			<p>&copy; Copyright 2006 Design By: Luka Cvrk - <a href="http://www.solucija.com/" target="_blank">Solucija</a></p>
		</div>
	</div>
	
<script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
var pageTracker = _gat._getTracker("UA-499065-1");
pageTracker._trackPageview();
</script>
	
</body>
</html>