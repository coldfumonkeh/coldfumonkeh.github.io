<!---

	Name: Track.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="track" hint="Component containing functions to access TRACK methods within the last.fm API">

	<cffunction name="init" access="public" returntype="track" output="false" hint="I am the constructor method.">
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
		
	<cffunction name="search" output="true" returntype="any" access="public" hint="Search for a track by track name. Returns track matches sorted by relevance. ">
		<cfargument name="track" required="yes" type="string" hint="The track name in question" />
		<cfargument name="artist" required="no" type="string" default="" hint="Narrow your search by specifying an artist" />
		<cfargument name="page" required="no" type="numeric" default="1" hint="Scan into the results by specifying a page number. Defaults to first page." />
		<cfargument name="limit" required="no" type="numeric" default="30" hint="Limit the number of tracks returned at one time. Default (maximum) is 30." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('Artist,Name,URL,Streamable,listeners,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('track.search',arguments) />
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
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/trackmatches/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackMatches">
							<cfset stuTrackMatches = StructNew()>
							<cfset stuTrackMatches.name = resultNodes[trackMatches].name.XmlText>
							<cfset stuTrackMatches.artist = resultNodes[trackMatches].artist.XmlText>
							<cfset stuTrackMatches.streamable = StructNew()>
							<cfset stuTrackMatches.streamable.streamable = resultNodes[trackMatches].streamable.XmlText />
							<cfset stuTrackMatches.streamable.fulltrack = resultNodes[trackMatches].streamable.XmlAttributes.fulltrack />
							<cfset stuTrackMatches.url = resultNodes[trackMatches].url.XmlText>
							<cfset stuTrackMatches.listeners = resultNodes[trackMatches].listeners.XmlText>
							<cfset arrayAppend(arrTrackMatches,stuTrackMatches) />
							<cfif structKeyExists(resultNodes[trackMatches], "image")>
							<cfset arrTrackImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[trackMatches].image)#" index="trackimage">
								<cfset stuTrackImage = StructNew()>
								<cfset stuTrackImage.url = resultNodes[trackMatches].image[trackimage].XmlText>
								<cfset stuTrackImage.size = resultNodes[trackMatches].image[trackimage].XmlAttributes.size>
								<cfset arrayAppend(arrTrackImage,stuTrackImage) />
							</cfloop>
							<cfset stuTrackMatches.image = arrTrackImage />
							</cfif>
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrTrackMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/trackmatches/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackMatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'Artist', resultNodes[trackMatches].artist.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'Name', resultNodes[trackMatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'URL', resultNodes[trackMatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'Streamable', resultNodes[trackMatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'listeners', resultNodes[trackMatches].listeners.XmlText) />
							<cfif structKeyExists(resultNodes[trackmatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="trackimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[trackmatches].image[trackimage].XmlAttributes.size, resultNodes[trackmatches].image[trackimage].XmlText) />
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
	
	<cffunction name="getInfo" output="true" returntype="any" access="public" hint="Get the metadata for a track on Last.fm using the artist/track name or a musicbrainz id. ">
		<cfargument name="artist" required="yes" type="string" default="" hint="The artist name in question" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="mbid" required="no" type="string" default="" hint="The musicbrainz id for the track" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('track.getinfo',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>		
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/track/')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset stuTrackMatches = StructNew()>
							<cfset stuTrackMatches.name = resultNodes[trackmatches].name.XmlText>
							<cfset stuTrackMatches.artist = StructNew() />
							<cfset stuTrackMatches.artist.name = resultNodes[trackmatches].artist.name.XmlText />
							<cfset stuTrackMatches.artist.mbid = resultNodes[trackmatches].artist.mbid.XmlText />
							<cfset stuTrackMatches.artist.url = resultNodes[trackmatches].artist.url.XmlText />
							<cfset stuTrackMatches.mbid = resultNodes[trackmatches].mbid.XmlText>
							<cfset stuTrackMatches.url = resultNodes[trackmatches].url.XmlText>
							<cfset stuTrackMatches.duration = resultNodes[trackmatches].duration.XmlText>
							<cfset stuTrackMatches.stats = StructNew()>
							<cfset stuTrackMatches.stats.listeners = resultNodes[trackmatches].listeners.XmlText />
							<cfset stuTrackMatches.stats.playcount = resultNodes[trackmatches].playcount.XmlText />	
							<cfset stuTrackMatches.streamable = StructNew()>
							<cfset stuTrackMatches.streamable.streamable = resultNodes[trackmatches].streamable.XmlText />
							<cfset stuTrackMatches.streamable.fulltrack = resultNodes[trackmatches].streamable.XmlAttributes.fulltrack />					
							<cfset arrayAppend(arrTrackMatches,stuTrackMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrTrackMatches />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getSimilar" output="true" returntype="any" access="public" hint="Get the similar tracks for this track on Last.fm, based on listening data. ">
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="artist" required="no" type="string" default="" hint="The artist name in question" />
		<cfargument name="mbid" required="no" type="string" default="" hint="The musicbrainz id for the track" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('track.getsimilar',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>
					<cfset stuResults.artist = returnedXML.lfm.similartracks.XmlAttributes.artist />
					<cfset stuResults.track = returnedXML.lfm.similartracks.XmlAttributes.track />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/similartracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset stuTrackMatches = StructNew()>
							<cfset stuTrackMatches.name = resultNodes[trackmatches].name.XmlText>
							<cfset stuTrackMatches.playcount = resultNodes[trackmatches].playcount.XmlText>
							<cfset stuTrackMatches.match = resultNodes[trackmatches].match.XmlText>
							<cfset stuTrackMatches.mbid = resultNodes[trackmatches].mbid.XmlText>
							<cfset stuTrackMatches.match = resultNodes[trackmatches].match.XmlText>
							<cfset stuTrackMatches.url = resultNodes[trackmatches].url.XmlText>
							<cfset stuTrackMatches.streamable = StructNew() />
							<cfset stuTrackMatches.streamable.streamable = resultNodes[trackmatches].streamable.XmlText>
							<cfset stuTrackMatches.streamable.fulltrack = resultNodes[trackmatches].streamable.XmlAttributes.fulltrack>
							<cfset stuTrackMatches.duration = resultNodes[trackmatches].duration.XmlText>
							<cfset stuTrackMatches.artist = StructNew() />
							<cfset stuTrackMatches.artist.name = resultNodes[trackmatches].artist.name.XmlText>
							<cfset stuTrackMatches.artist.mbid = resultNodes[trackmatches].artist.mbid.XmlText>
							<cfset stuTrackMatches.artist.url = resultNodes[trackmatches].artist.url.XmlText>
							<cfif structKeyExists(resultNodes[trackmatches], "image")>	
							<cfset arrTrackImage = ArrayNew(1) />
								<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="trackimage">
									<cfset stuTrackImage = StructNew()>
									<cfset stuTrackImage.url = resultNodes[trackmatches].image.XmlText>
									<cfset stuTrackImage.size = resultNodes[trackmatches].image.XmlAttributes.size>
									<cfset arrayAppend(arrTrackImage,stuTrackImage) />
								</cfloop>
								<cfset stuTrackMatches.image = arrTrackImage />
							</cfif>
							<cfset arrayAppend(arrTrackMatches,stuTrackMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.similarArtists = arrTrackMatches />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getTopTags" output="true" returntype="any" access="public" hint="Get the top tags for this track on Last.fm, ordered by tag count. Supply either track & artist name or mbid">
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="artist" required="no" type="string" default="" hint="The artist name in question" />
		<cfargument name="mbid" required="no" type="string" default="" hint="The musicbrainz id for the track" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artist,track,url,name,count') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('track.gettoptags',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.artist = returnedXML.lfm.toptags.XmlAttributes.artist />
					<cfset stuResults.track = returnedXML.lfm.toptags.XmlAttributes.track />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset stuTopTags = StructNew()>
							<cfset stuTopTags.count = resultNodes[tagmatches].count.XmlText>
							<cfset stuTopTags.name = resultNodes[tagmatches].name.XmlText>
							<cfset stuTopTags.url = resultNodes[tagmatches].url.XmlText>
		
							<cfset arrayAppend(arrTagMatches,stuTopTags) />
						</cfloop>
					</cfif>
					<cfset stuResults.topTags = arrTagMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[tagmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'count', resultNodes[tagmatches].count.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[tagmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'track', returnedXML.lfm.toptags.XmlAttributes.track) />
							<cfset temp = QuerySetCell(rstResults, 'artist', returnedXML.lfm.toptags.XmlAttributes.artist) />
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
	
	<cffunction name="getTags" output="true" returntype="any" access="public" hint="Get the tags applied by an individual user to a track on Last.fm. ">
		<cfargument name="artist" required="yes" type="string" default="" hint="The artist name in question" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="sessionKey" required="yes" type="string" default="" hint="A session key generated by authenticating a user via the authentication protocol." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('name,url')>
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset args['sessionKey'] = arguments.sessionKey />
			<cfset searchResults = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('track.gettags', args, arguments.sessionKey, 'xml')) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfif arrayLen(xmlSearch(searchResults, '/lfm/tags')) GT 0>
						<cfset stuResults.artist = returnedXML.lfm.tags.XmlAttributes.artist />
						<cfset stuResults.track = returnedXML.lfm.tags.XmlAttributes.track />
						<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tags/tag')>
						<cfif arraylen(resultNodes) GT 0>
							<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
								<cfset stuTopTags = StructNew()>
								<cfset stuTopTags.name = resultNodes[tagmatches].name.XmlText>
								<cfset stuTopTags.url = resultNodes[tagmatches].url.XmlText>
								<cfset arrayAppend(arrTagMatches,stuTopTags) />
							</cfloop>
						</cfif>
						<cfset stuResults.tags = arrTagMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset temp = QueryAddRow(rstResults)>
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[tagmatches].name.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[tagmatches].url.XmlText)>
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
	
	<cffunction name="addTags" output="true" returntype="any" access="public" hint="add tags to a specific artist">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="tags" required="yes" type="string" default="" hint="A comma delimited list of user supplied tags to apply to this album. Accepts a maximum of 10 tags." />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset args['tags'] = arguments.tags />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('track.addTags', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="love" output="true" returntype="any" access="public" hint="add tags to a specific artist">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('track.love', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="removeTag" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="track" required="yes" type="string" default="" hint="The track name in question" />
		<cfargument name="tag" required="yes" type="string" default="" hint="A single user tag to remove from this artist" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset args['tag'] = arguments.tag />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('track.removeTag', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="getTopFans" output="true" returntype="any" access="public" hint="Get the top fans for this track on Last.fm, based on listening data. Supply either track & artist name or musicbrainz id. ">
		<cfargument name="track" required="no" type="string" default="" hint="The track name in question" />
		<cfargument name="artist" required="no" type="string" default="" hint="the name of the artist" />
		<cfargument name="mbid" required="no" type="string" default="" hint="The musicbrainz id for the track" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrFanMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artist,track,url,name,weight,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('track.gettopfans',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.artist = returnedXML.lfm.topfans.XmlAttributes.artist />
					<cfset stuResults.track = returnedXML.lfm.topfans.XmlAttributes.track />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topfans/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="usermatches">
							<cfset stuTopFans = StructNew()>
							<cfset stuTopFans.name = resultNodes[usermatches].name.XmlText>
							<cfset stuTopFans.url = resultNodes[usermatches].url.XmlText>
							<cfset stuTopFans.weight = resultNodes[usermatches].weight.XmlText>
							<cfset arrUserImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[usermatches].image)#" index="userimage">
								<cfset stuUserImage = StructNew()>
								<cfset stuUserImage.url = resultNodes[usermatches].image[userimage].XmlText>
								<cfset stuUserImage.size = resultNodes[usermatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrUserImage,stuUserImage) />
							</cfloop>
							<cfset stuTopFans.image = arrUserImage />
							<cfset arrayAppend(arrFanMatches,stuTopFans) />
						</cfloop>
					</cfif>
					<cfset stuResults.topFans = arrFanMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topfans/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="usermatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[usermatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'weight', resultNodes[usermatches].weight.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[usermatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'track', returnedXML.lfm.topfans.XmlAttributes.track) />
							<cfset temp = QuerySetCell(rstResults, 'artist', returnedXML.lfm.topfans.XmlAttributes.artist) />
							<cfif structKeyExists(resultNodes[usermatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[usermatches].image)#" index="userimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[usermatches].image[userimage].XmlAttributes.size, resultNodes[usermatches].image[userimage].XmlText) />
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
	
	<cffunction name="share" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist to share" />
		<cfargument name="track" required="yes" type="string" default="" hint="the name of the track to share" />
		<cfargument name="recipient" required="yes" type="string" default="" hint="Email Address | Last.fm Username - A comma delimited list of email addresses or Last.fm usernames. Maximum is 10" />
		<cfargument name="message" required="false" type="string" default="" hint="An optional message to send with the recommendation. If not supplied a default message will be used." />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset args['recipient'] = arguments.recipient />
			<cfset args['message'] = arguments.message />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('track.share', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="ban" output="true" returntype="any" access="public" hint="Ban a track for a given user profile. This needs to be supplemented with a scrobbling submission containing the 'ban' rating (see the audioscrobbler API).">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist to share" />
		<cfargument name="track" required="yes" type="string" default="" hint="the name of the track to share" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('track.ban', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
</cfcomponent>