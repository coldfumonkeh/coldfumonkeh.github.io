<!---

	Name: Album.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="album" hint="Component containing functions to access ALBUM methods within the last.fm API">

	<cffunction name="init" access="public" returntype="album" output="false" hint="I am the constructor method.">
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
		
	<cffunction name="search" output="true" returntype="any" access="public" hint="search for an album">
		<cfargument name="album" required="yes" type="string" hint="the text you wish to search with (name of album)" />
		<cfargument name="page" required="no" type="numeric" default="1" hint="the page you wish to display (when used in pagination)" />
		<cfargument name="limit" required="no" type="numeric" default="30" hint="the total number of results to return" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('Artist,Name,URL,Streamable,ID,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('album.search',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>			
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset stuResults.searchTerm = returnedXML.lfm.results.query.XmlAttributes.searchTerms />
					<cfset stuResults.totalResults = returnedXML.lfm.results.totalResults.XmlText />
					<cfset stuResults.itemsPerPage = returnedXML.lfm.results.itemsPerPage.XmlText />
					<cfset stuResults.startIndex = returnedXML.lfm.results.startIndex.XmlText />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/albummatches/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[albummatches].name.XmlText>
							<cfset stuArtistMatches.artist = resultNodes[albummatches].artist.XmlText>
							<cfset stuArtistMatches.id = resultNodes[albummatches].id.XmlText>
							<cfset stuArtistMatches.url = resultNodes[albummatches].url.XmlText>
							<cfset stuArtistMatches.streamable = resultNodes[albummatches].streamable.XmlText>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[albummatches].image.XmlText>
								<cfset stuArtistImage.size = resultNodes[albummatches].image.XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/albummatches/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'Artist', resultNodes[albummatches].artist.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'Name', resultNodes[albummatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'URL', resultNodes[albummatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'Streamable', resultNodes[albummatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'ID', resultNodes[albummatches].id.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="albumImage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[albummatches].image[albumImage].XmlAttributes.size, resultNodes[albummatches].image[albumImage].XmlText) />
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
	
	<cffunction name="getInfo" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="no" type="string" default="" hint="the name of the artist" />
		<cfargument name="album" required="no" type="string" default="" hint="the name of the album" />
		<cfargument name="mbid" required="no" type="string" default="" hint="The musicbrainz id for the album" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrAlbumMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('album.getInfo',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/album/')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
							<cfset stuAlbumMatches = StructNew()>
							<cfset stuAlbumMatches.name = resultNodes[albummatches].name.XmlText>
							<cfset stuAlbumMatches.artist = resultNodes[albummatches].artist.XmlText>
							<cfset stuAlbumMatches.mbid = resultNodes[albummatches].mbid.XmlText>
							<cfset stuAlbumMatches.url = resultNodes[albummatches].url.XmlText>
							<cfset stuAlbumMatches.releasedate = resultNodes[albummatches].releasedate.XmlText>
							<cfset stuAlbumMatches.stats = StructNew()>
							<cfset stuAlbumMatches.stats.listeners = resultNodes[albummatches].listeners.XmlText />
							<cfset stuAlbumMatches.stats.playcount = resultNodes[albummatches].playcount.XmlText />
							<cfset arrAlbumImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="albumimage">
								<cfset stuAlbumImage = StructNew()>
								<cfset stuAlbumImage.url = resultNodes[albummatches].image.XmlText>
								<cfset stuAlbumImage.size = resultNodes[albummatches].image.XmlAttributes.size>
								<cfset arrayAppend(arrAlbumImage,stuAlbumImage) />
							</cfloop>
							<cfset stuAlbumMatches.image = arrAlbumImage />
							<cfset arrayAppend(arrAlbumMatches,stuAlbumMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrAlbumMatches />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getTags" output="true" returntype="any" access="public">
		<cfargument name="artist" required="no" type="string" default="" hint="the name of the artist" />
		<cfargument name="album" required="no" type="string" default="" hint="the name of the album" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var args = '' />
			<cfset var rstResults = QueryNew('name,url,album,artist') />
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['album'] = arguments.album />
			<cfset args['sessionKey'] = arguments.sessionKey />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('album.gettags', args, arguments.sessionKey, 'xml')) />
			<!--- <cfset searchResults = variables.stuInstance.utility.xmlStrip(authCall) /> --->
			<cfset searchResults = authCall />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tags/tag')>
					<cfset stuResults.artist = returnedXML.lfm.tags.XmlAttributes.artist />
					<cfset stuResults.album = returnedXML.lfm.tags.XmlAttributes.album />
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset stuTagMatches = StructNew()>
							<cfset stuTagMatches.name = resultNodes[tagmatches].name.XmlText>
							<cfset stuTagMatches.url = resultNodes[tagmatches].url.XmlText>
							<cfset temp = arrayAppend(arrTagMatches,stuTagMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrTagMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'artist', returnedXML.lfm.tags.XmlAttributes.artist) />
							<cfset temp = QuerySetCell(rstResults, 'album', returnedXML.lfm.tags.XmlAttributes.album) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[tagmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[tagmatches].url.XmlText) />
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
	
	<cffunction name="addTags" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="album" required="yes" type="string" default="" hint="the name of the album" />
		<cfargument name="tags" required="yes" type="string" default="" hint="A comma delimited list of user supplied tags to apply to this album. Accepts a maximum of 10 tags." />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['album'] = arguments.album />
			<cfset args['tags'] = arguments.tags />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('album.addTags', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="removeTag" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="album" required="yes" type="string" default="" hint="the name of the album" />
		<cfargument name="tag" required="yes" type="string" default="" hint="A single user tag to remove from this album" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['album'] = arguments.album />
			<cfset args['tag'] = arguments.tag />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('album.removeTag', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
</cfcomponent>