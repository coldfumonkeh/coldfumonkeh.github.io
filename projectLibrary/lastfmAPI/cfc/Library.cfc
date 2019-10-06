<!---

	Name: Library.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="library" hint="Component containing functions to access LIBRARY methods within the last.fm API">

	<cffunction name="init" access="public" returntype="library" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="addAlbum" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="album" required="yes" type="string" default="" hint="the name of the album" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['album'] = arguments.album />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('library.addAlbum', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="addArtist" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('library.addArtist', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="addTrack" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name you wish to add" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('library.addTrack', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="getAlbums" output="true" returntype="any" access="public" hint="A paginated list of all the albums in a user's library, with play counts and tag counts. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user whose library you want to fetch" />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="Limit the amount of albums returned (maximum/default is 50)." />
		<cfargument name="page" required="no" type="numeric" default="0" hint="The page number you wish to scan to." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistURL,artistMBID,playcount,url,tagcount,name,mbid,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('library.getalbums',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.albums.XmlAttributes.user />
					<cfset stuResults.page = returnedXML.lfm.albums.XmlAttributes.page />
					<cfset stuResults.perpage = returnedXML.lfm.albums.XmlAttributes.perpage />
					<cfset stuResults.totalpages = returnedXML.lfm.albums.XmlAttributes.totalpages />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/albums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuArtistMatches.playcount = resultNodes[librarymatches].playcount.XmlText>
							<cfset stuArtistMatches.tagcount = resultNodes[librarymatches].tagcount.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[librarymatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[librarymatches].url.XmlText>
							<cfset stuArtistMatches.artist = StructNew() />
							<cfset stuArtistMatches.artist.name = resultNodes[librarymatches].artist.name.XmlText>
							<cfset stuArtistMatches.artist.mbid = resultNodes[librarymatches].artist.mbid.XmlText>
							<cfset stuArtistMatches.artist.url = resultNodes[librarymatches].artist.url.XmlText>
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[librarymatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[librarymatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.albums = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/albums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.albums.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[librarymatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[librarymatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[librarymatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[librarymatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tagcount', resultNodes[librarymatches].tagcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="albumImage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[albumImage].XmlAttributes.size, resultNodes[librarymatches].image[albumImage].XmlText) />
							</cfloop>
						</cfloop>
					</cfif>
					<cfset returnVar = rstResults />
				</cfcase>
				<cfcase value="xml">
					<cfset returnVar = returnedXML>
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getArtists" output="true" returntype="any" access="public" hint="A paginated list of all the artists in a user's library, with play counts and tag counts. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user whose library you want to fetch." />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="Limit the amount of artists returned (maximum/default is 50)." />
		<cfargument name="page" required="no" type="numeric" default="0" hint="The page number you wish to scan to." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('playcount,url,tagcount,name,streamable,mbid,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('library.getartists',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.artists.XmlAttributes.user />
					<cfset stuResults.page = returnedXML.lfm.artists.XmlAttributes.page />
					<cfset stuResults.perpage = returnedXML.lfm.artists.XmlAttributes.perpage />
					<cfset stuResults.totalpages = returnedXML.lfm.artists.XmlAttributes.totalpages />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/artists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuArtistMatches.playcount = resultNodes[librarymatches].playcount.XmlText>
							<cfset stuArtistMatches.tagcount = resultNodes[librarymatches].tagcount.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[librarymatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[librarymatches].url.XmlText>
							<cfset stuArtistMatches.streamable = resultNodes[librarymatches].streamable.XmlText>
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[librarymatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[librarymatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.artists = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/artists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults)>
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[librarymatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tagcount', resultNodes[librarymatches].tagcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[librarymatches].streamable.XmlText) />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="image">
								<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[image].XmlAttributes.size, resultNodes[librarymatches].image[image].XmlText) />
							</cfloop>
							</cfif>
						</cfloop>
					</cfif>
					<cfset returnVar = rstResults />
				</cfcase>
				<cfcase value="xml">
					<cfset returnVar = returnedXML />
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getTracks" output="true" returntype="any" access="public" hint="A paginated list of all the tracks in a user's library, with play counts and tag counts. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user whose library you want to fetch." />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="Limit the amount of tracks returned (maximum/default is 50)." />
		<cfargument name="page" required="no" type="numeric" default="0" hint="The page number you wish to scan to." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistURL,artistMBID,playcount,url,tagcount,name,streamable,fulltrack,mbid,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('library.gettracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.tracks.XmlAttributes.user />
					<cfset stuResults.page = returnedXML.lfm.tracks.XmlAttributes.page />
					<cfset stuResults.perpage = returnedXML.lfm.tracks.XmlAttributes.perpage />
					<cfset stuResults.totalpages = returnedXML.lfm.tracks.XmlAttributes.totalpages />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuArtistMatches.playcount = resultNodes[librarymatches].playcount.XmlText>
							<cfset stuArtistMatches.tagcount = resultNodes[librarymatches].tagcount.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[librarymatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[librarymatches].url.XmlText>
							<cfset stuArtistMatches.streamable = StructNew() />
							<cfset stuArtistMatches.streamable.streamable = resultNodes[librarymatches].streamable.XmlText>
							<cfset stuArtistMatches.streamable.fulltrack = resultNodes[librarymatches].streamable.XmlAttributes.fulltrack>
							<cfset stuArtistMatches.artist = StructNew() />
							<cfset stuArtistMatches.artist.name = resultNodes[librarymatches].artist.name.XmlText>
							<cfset stuArtistMatches.artist.mbid = resultNodes[librarymatches].artist.mbid.XmlText>
							<cfset stuArtistMatches.artist.url = resultNodes[librarymatches].artist.url.XmlText>
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[librarymatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[librarymatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.tracks = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.tracks.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[librarymatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[librarymatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[librarymatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[librarymatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tagcount', resultNodes[librarymatches].tagcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[librarymatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'fulltrack', resultNodes[librarymatches].streamable.XmlAttributes.fulltrack) />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="albumImage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[albumImage].XmlAttributes.size, resultNodes[librarymatches].image[albumImage].XmlText) />
							</cfloop>
							</cfif>
						</cfloop>
					</cfif>
					<cfset returnVar = rstResults />
				</cfcase>
				<cfcase value="xml">
					<cfset returnVar = returnedXML>
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
			
</cfcomponent>