<!---

	Name: Geo.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="geo" hint="Component containing functions to access GEO methods within the last.fm API">

	<cffunction name="init" access="public" returntype="geo" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="getEvents" output="true" returntype="any" access="public" hint="Get all events in a specific location by country or city name. ">
		<cfargument name="location" required="no" type="string" default="" hint="Specifies a location to retrieve events for (service returns nearby events by default)" />
		<cfargument name="lat" required="no" type="string" default="" hint="Specifies a latitude value to retrieve events for (service returns nearby events by default)" />
		<cfargument name="long" required="no" type="string" default="" hint="Specifies a longitude value to retrieve events for (service returns nearby events by default)" />
		<cfargument name="page" required="no" type="numeric" default="1" hint="Display more results by pagination" />
		<cfargument name="distance" required="no" type="string" default="" hint="Find events within a specified distance" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,id,venueName,venueURL,venueLat,venueLong,venuePostalCode,venueCountry,venueCity,venueStreet,attendance,reviews,headliner,artists,title,startDate,description,tag,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('geo.getevents',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.location = returnedXML.lfm.events.XmlAttributes.location />
					<cfset stuResults.page = returnedXML.lfm.events.XmlAttributes.page />
					<cfset stuResults.total = returnedXML.lfm.events.XmlAttributes.total />
					<cfset stuResults.totalpages = returnedXML.lfm.events.XmlAttributes.totalpages />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/events/event')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="eventmatches">
							<cfset stuEventMatches = StructNew()>
							<cfset stuEventMatches.id = resultNodes[eventmatches].id.XmlText>
							<cfset stuEventMatches.title = resultNodes[eventmatches].title.XmlText>
							<cfset stuEventMatches.venue = StructNew() />
							<cfset stuEventMatches.venue.name = resultNodes[eventmatches].venue.name.XmlText>
							<cfset stuEventMatches.venue.url = resultNodes[eventmatches].venue.url.XmlText>
							<cfset stuEventMatches.venue.location = StructNew() />
							<cfset stuEventMatches.venue.location.city = resultNodes[eventmatches].venue.location.city.XmlText />
							<cfset stuEventMatches.venue.location.country = resultNodes[eventmatches].venue.location.country.XmlText />
							<cfset stuEventMatches.venue.location.street = resultNodes[eventmatches].venue.location.street.XmlText />
							<cfset stuEventMatches.venue.location.postalcode = resultNodes[eventmatches].venue.location.postalcode.XmlText />
							<cfset stuEventMatches.venue.location.point = StructNew() />
							<cfset stuEventMatches.venue.location.point.lat = resultNodes[eventmatches].venue.location.point.lat.XmlText />
							<cfset stuEventMatches.venue.location.point.long = resultNodes[eventmatches].venue.location.point.long.XmlText />
							<cfset stuEventMatches.startDate = resultNodes[eventmatches].startDate.XmlText />
							<cfset stuEventMatches.description = resultNodes[eventmatches].description.XmlText />
							<cfset stuEventMatches.attendance = resultNodes[eventmatches].attendance.XmlText />
							<cfset stuEventMatches.reviews = resultNodes[eventmatches].reviews.XmlText />
							<cfset stuEventMatches.tag = resultNodes[eventmatches].tag.XmlText />
							<cfset stuEventMatches.url = resultNodes[eventmatches].url.XmlText />
							<cfset arrEventArtists = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].artists.artist)#" index="eventartist">
								<cfset stuEventArtists = StructNew()>
								<cfset stuEventArtists.artist = resultNodes[eventmatches].artists.artist[eventartist].XmlText>
								<cfset arrayAppend(arrEventArtists,stuEventArtists) />
							</cfloop>
							<cfset stuEventMatches.artists = arrEventArtists />
							<cfset stuEventMatches.headliner = resultNodes[eventmatches].artists.headliner.XmlText />
							<cfset arrEventImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].image)#" index="eventimage">
								<cfset stuEventImage = StructNew()>
								<cfset stuEventImage.url = resultNodes[eventmatches].image[eventimage].XmlText>
								<cfset stuEventImage.size = resultNodes[eventmatches].image[eventimage].XmlAttributes.size>
								<cfset arrayAppend(arrEventImage,stuEventImage) />
							</cfloop>
							<cfset stuEventMatches.image = arrEventImage />					
							<cfset arrayAppend(arrEventMatches,stuEventMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrEventMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/events/event')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="eventmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset arrLineUp = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].artists.artist)#" index="artistmatch">
								<cfset arrayAppend(arrLineUp,resultNodes[eventmatches].artists.artist[artistmatch].XmlText) />
							</cfloop>
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[eventmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'id', resultNodes[eventmatches].id.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueName', resultNodes[eventmatches].venue.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueURL', resultNodes[eventmatches].venue.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueLat', resultNodes[eventmatches].venue.location.point.lat.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueLong', resultNodes[eventmatches].venue.location.point.long.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venuePostalCode', resultNodes[eventmatches].venue.location.postalcode.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueCountry', resultNodes[eventmatches].venue.location.country.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueCity', resultNodes[eventmatches].venue.location.city.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueStreet', resultNodes[eventmatches].venue.location.street.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'attendance', resultNodes[eventmatches].attendance.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'reviews', resultNodes[eventmatches].reviews.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'headliner', resultNodes[eventmatches].artists.headliner.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artists', arrLineUp) />
							<cfset temp = QuerySetCell(rstResults, 'title', resultNodes[eventmatches].title.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'startDate', resultNodes[eventmatches].startDate.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'description', resultNodes[eventmatches].description.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tag', resultNodes[eventmatches].tag.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].image)#" index="eventImage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[eventmatches].image[eventImage].XmlAttributes.size, resultNodes[eventmatches].image[eventImage].XmlText) />
							</cfloop>
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
	
	<cffunction name="getTopArtists" output="true" returntype="any" access="public" hint="Get the most popular artists on Last.fm by country ">
		<cfargument name="country" required="yes" type="string" default="" hint="the name of the country you wish to search within. Eg. United Kingdom or Spain" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('playcount,url,name,streamable,mbid,rank,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('geo.gettopartists',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.country = returnedXML.lfm.topartists.XmlAttributes.country />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset stuTopTracks = StructNew()>
							<cfset stuTopTracks.rank = resultNodes[trackmatches].XmlAttributes.rank>
							<cfset stuTopTracks.name = resultNodes[trackmatches].name.XmlText>
							<cfset stuTopTracks.playcount = resultNodes[trackmatches].playcount.XmlText>
							<cfset stuTopTracks.mbid = resultNodes[trackmatches].mbid.XmlText>
							<cfset stuTopTracks.url = resultNodes[trackmatches].url.XmlText>
							<cfset stuTopTracks.streamable = resultNodes[trackmatches].streamable.XmlText />		
							<cfif structKeyExists(resultNodes[trackmatches], "image")>					
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[trackmatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[trackmatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuTopTracks.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrTrackMatches,stuTopTracks) />
						</cfloop>
					</cfif>
					<cfset stuResults.topArtists = arrTrackMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[trackmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[trackmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[trackmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[trackmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[trackmatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[trackmatches].XmlAttributes.rank) />
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="image">
								<cfset temp = QuerySetCell(rstResults, resultNodes[trackmatches].image[image].XmlAttributes.size, resultNodes[trackmatches].image[image].XmlText) />
							</cfloop>
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
	
	<cffunction name="getTopTracks" output="true" returntype="any" access="public" hint="Get the most popular tracks on Last.fm last week by country ">
		<cfargument name="country" required="yes" type="string" default="" hint="the name of the country you wish to search within. Eg. United Kingdom or Spain" />
		<cfargument name="location" required="no" type="string" default="" hint="A metro name, to fetch the charts for (must be within the country specified)" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artistURL,artistName,artistMBID,playcount,url,name,streamable,fulltrack,mbid,rank,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('geo.gettoptracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.country = returnedXML.lfm.toptracks.XmlAttributes.country />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset stuTopTracks = StructNew()>
							<cfset stuTopTracks.rank = resultNodes[trackmatches].XmlAttributes.rank>
							<cfset stuTopTracks.name = resultNodes[trackmatches].name.XmlText>
							<cfset stuTopTracks.playcount = resultNodes[trackmatches].playcount.XmlText>
							<cfset stuTopTracks.mbid = resultNodes[trackmatches].mbid.XmlText>
							<cfset stuTopTracks.url = resultNodes[trackmatches].url.XmlText>
							<cfset stuTopTracks.streamable = StructNew() />
							<cfset stuTopTracks.streamable.streamable = resultNodes[trackmatches].streamable.XmlText />
							<cfset stuTopTracks.streamable.fulltrack = resultNodes[trackmatches].streamable.XmlAttributes.fulltrack />
							<cfset stuTopTracks.artist = StructNew() />
							<cfset stuTopTracks.artist.name = resultNodes[trackmatches].artist.name.XmlText />
							<cfset stuTopTracks.artist.mbid = resultNodes[trackmatches].artist.mbid.XmlText />
							<cfset stuTopTracks.artist.url = resultNodes[trackmatches].artist.url.XmlText />		
							<cfif structKeyExists(resultNodes[trackmatches], "image")>					
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[trackmatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[trackmatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuTopTracks.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrTrackMatches,stuTopTracks) />
						</cfloop>
					</cfif>
					<cfset stuResults.topTracks = arrTrackMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[trackmatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[trackmatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[trackmatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[trackmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[trackmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[trackmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[trackmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'fulltrack', resultNodes[trackmatches].streamable.XmlAttributes.fulltrack) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[trackmatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[trackmatches].XmlAttributes.rank) />
							<cfif structKeyExists(resultNodes[trackmatches], "image")>
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="image">
								<cfset temp = QuerySetCell(rstResults, resultNodes[trackmatches].image[image].XmlAttributes.size, resultNodes[trackmatches].image[image].XmlText) />
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
	
</cfcomponent>