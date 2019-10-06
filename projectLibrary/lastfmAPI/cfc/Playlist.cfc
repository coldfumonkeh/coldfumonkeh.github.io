<!---

	Name: Playlist.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="playlist" hint="Component containing functions to access PLAYLIST methods within the last.fm API">

	<cffunction name="init" access="public" returntype="playlist" output="false" hint="I am the constructor method.">
		<cfargument name="apikey" required="true" type="string" />
		<cfargument name="SecretKey" required="true" type="string" />
		<cfargument name="rootURL" required="true" type="string" />
			<!--- holds all private instance data --->
			<cfset variables.stuInstance = StructNew() />
			<cfset variables.stuInstance.APIKey = arguments.apikey />
			<cfset variables.stuInstance.SecretKey = arguments.secretkey />
			<cfset variables.stuInstance.rootURL = arguments.rootURL />
			<cfset variables.stuInstance.utility = createObject("component", "utility").init(arguments.apikey,arguments.secretkey,arguments.rootURL) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="create" output="true" returntype="any" access="public" hint="Create a Last.fm playlist on behalf of a user ">
		<cfargument name="title" required="yes" type="string" default="" hint="Title for the playlist" />
		<cfargument name="description" required="yes" type="string" default="" hint="Description for the playlist" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />	
			<cfset var arrPlaylist = ArrayNew(1) />
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset args = StructNew() />
			<cfset args['title'] = arguments.title />
			<cfset args['description'] = arguments.description />
			<cfset searchResults = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('playlist.create', args, arguments.sessionKey, 'xml')) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/playlists/playlist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="playlistmatches">
							<cfset stuPlaylist = StructNew()>
							<cfset stuPlaylist.id = resultNodes[playlistmatches].id.XmlText>
							<cfset stuPlaylist.title = resultNodes[playlistmatches].title.XmlText />
							<cfset stuPlaylist.description = resultNodes[playlistmatches].description.XmlText />
							<cfset stuPlaylist.date = resultNodes[playlistmatches].date.XmlText />
							<cfset stuPlaylist.size = resultNodes[playlistmatches].size.XmlText />
							<cfset stuPlaylist.duration = resultNodes[playlistmatches].duration.XmlText />
							<cfset stuPlaylist.streamable = resultNodes[playlistmatches].streamable.XmlText />
							<cfset stuPlaylist.creator = resultNodes[playlistmatches].creator.XmlText />
							<cfset stuPlaylist.url = resultNodes[playlistmatches].creator.XmlText />
							<cfset arrPlaylistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[playlistmatches].image)#" index="image">
								<cfset stuPlaylistImage = StructNew()>
								<cfset stuPlaylistImage.url = resultNodes[playlistmatches].image[image].XmlText>
								<cfset stuPlaylistImage.size = resultNodes[playlistmatches].image[image].XmlAttributes.size>
								<cfset arrayAppend(arrPlaylistImage,stuPlaylistImage) />
							</cfloop>
							<cfset stuPlaylist.image = arrPlaylistImage />				
							<cfset arrayAppend(arrPlaylist,stuPlaylist) />
						</cfloop>
					</cfif>
					<cfset stuResults.playlist = arrPlaylist />
					<cfset returnVar = stuResults />
				</cfcase>
				<cfcase value="xml">
					<cfset returnVar = returnedXML />
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="fetch" output="true" returntype="any" access="public" hint="Fetch XSPF playlists using a lastfm playlist url. ">
		<cfargument name="playlistURL" required="yes" type="string" default="" hint="A lastfm protocol playlist url ('lastfm://playlist/...')" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var arrUserMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('playlist.fetch',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>
					<cfset stuResults.version = returnedXML.lfm.playlist.XmlAttributes.version />
					<cfset stuResults.title = returnedXML.lfm.playlist.title.XmlText />
					<cfset stuResults.annotation = returnedXML.lfm.playlist.annotation.XmlText />
					<cfset stuResults.creator = returnedXML.lfm.playlist.creator.XmlText />
					<cfset stuResults.date = returnedXML.lfm.playlist.date.XmlText />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/playlist/tracklist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[groupmatches].name.XmlText>
							<cfset stuArtistMatches.url = resultNodes[groupmatches].url.XmlText />			
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[groupmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[groupmatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[groupmatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />				
							<cfset arrayAppend(arrGroupMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.tracklist = arrGroupMatches />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="addTrack" output="true" returntype="any" access="public" hint="Add a track to a Last.fm user's playlist">
		<cfargument name="playlistID" required="yes" type="string" default="" hint="The ID of the playlist - this is available in user.getPlaylists" />
		<cfargument name="artist" required="yes" type="string" default="" hint="The artist name that corresponds to the track to be added" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['playlistID'] = arguments.playlistID />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('playlist.addTrack', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
</cfcomponent>