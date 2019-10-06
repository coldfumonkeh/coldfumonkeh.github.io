<!---

	Name: Venue.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="venue" hint="Component containing functions to access VENUE methods within the last.fm API">

	<cffunction name="init" access="public" returntype="venue" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="getEvents" output="true" returntype="any" access="public" hint="Get a list of upcoming events at this venue.">
		<cfargument name="venue" required="yes" type="string" default="" hint="the venue id to fetch the events for" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,id,venueID,venueName,venueURL,venueLat,venueLong,venuePostalCode,venueCountry,venueCity,venueStreet,attendance,reviews,headliner,artists,title,startDate,description,tag,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('venue.getevents',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.venue = returnedXML.lfm.events.XmlAttributes.venue />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/events/event')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="eventmatches">
							<cfset stuEventMatches = StructNew()>
							<cfset stuEventMatches.title = resultNodes[eventmatches].title.XmlText>
							<cfset stuEventMatches.id = resultNodes[eventmatches].id.XmlText>
							<cfset stuLineUp = StructNew() />
							<cfset stuLineUp.headliner = resultNodes[eventmatches].artists.headliner.XmlText />
							<cfset arrLineUp = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].artists.artist)#" index="artistmatch">
								<cfset arrayAppend(arrLineUp,resultNodes[eventmatches].artists.artist[artistmatch].XmlText) />
							</cfloop>
							<cfset stuLineUp.artists = arrLineUp />
							<cfset stuEventMatches.artists = stuLineUp />
							<cfset stuEventMatches.venue = StructNew() />
							<cfset stuEventMatches.venue.name = resultNodes[eventmatches].venue.name.XmlText />
							<cfset stuEventMatches.venue.location = StructNew() />
							<cfset stuEventMatches.venue.location.city = resultNodes[eventmatches].venue.location.city.XmlText />
							<cfset stuEventMatches.venue.location.country = resultNodes[eventmatches].venue.location.country.XmlText />
							<cfset stuEventMatches.venue.location.street = resultNodes[eventmatches].venue.location.street.XmlText />
							<cfset stuEventMatches.venue.location.postalcode = resultNodes[eventmatches].venue.location.postalcode.XmlText />
							<cfset stuEventMatches.venue.location.point = StructNew() />
							<cfset stuEventMatches.venue.location.point.lat = resultNodes[eventmatches].venue.location.point.lat.XmlText />
							<cfset stuEventMatches.venue.location.point.long = resultNodes[eventmatches].venue.location.point.long.XmlText />
							<cfset stuEventMatches.venue.url = resultNodes[eventmatches].venue.url.XmlText />
							<cfset stuEventMatches.startDate = resultNodes[eventmatches].startDate.XmlText />
							<cfset stuEventMatches.description = resultNodes[eventmatches].description.XmlText />
							<cfset stuEventMatches.attendance = resultNodes[eventmatches].attendance.XmlText />
							<cfset stuEventMatches.reviews = resultNodes[eventmatches].reviews.XmlText />
							<cfset stuEventMatches.tag = resultNodes[eventmatches].tag.XmlText />
							<cfset stuEventMatches.url = resultNodes[eventmatches].url.XmlText />
							<cfset arrEventImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].image)#" index="eventImage">
								<cfset stuEventImage = StructNew()>
								<cfset stuEventImage.url = resultNodes[eventmatches].image.XmlText>
								<cfset stuEventImage.size = resultNodes[eventmatches].image.XmlAttributes.size>
								<cfset arrayAppend(arrEventImage,stuEventImage) />
							</cfloop>
							<cfset stuEventMatches.image = arrEventImage />
							<cfset arrayAppend(arrEventMatches,stuEventMatches) />
						</cfloop>
						<cfset stuResults.recommendations = arrEventMatches />
					</cfif>
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
							<cfset temp = QuerySetCell(rstResults, 'venueID', resultNodes[eventmatches].venue.id.XmlText) />
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
					<cfset returnVar = returnedXML>
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getPastEvents" output="true" returntype="any" access="public">
		<cfargument name="venue" required="yes" type="string" default="" hint="the venue id to fetch the events for" />
		<cfargument name="page" required="false" type="numeric" default="1" hint="the page number to scan to" />
		<cfargument name="limit" required="false" type="numeric" default="10" hint="the number of events to return per page" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,ID,venue,attendance,reviews,artists,headliner,title,startdate,description,tag,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('venue.getpastevents',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.venue = returnedXML.lfm.events.XmlAttributes.venue />
					<cfset stuResults.page = returnedXML.lfm.events.XmlAttributes.page />
					<cfset stuResults.perpage = returnedXML.lfm.events.XmlAttributes.perpage />
					<cfset stuResults.total = returnedXML.lfm.events.XmlAttributes.total />
					<cfset stuResults.totalpages = returnedXML.lfm.events.XmlAttributes.totalpages />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/events/event')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="eventmatches">
							<cfset stuEventMatches = StructNew()>
							<cfset stuEventMatches.title = resultNodes[eventmatches].title.XmlText>
							<cfset stuEventMatches.id = resultNodes[eventmatches].id.XmlText>
							<cfset stuLineUp = StructNew() />
							<cfset stuLineUp.headliner = resultNodes[eventmatches].artists.headliner.XmlText />
							<cfset arrLineUp = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].artists.artist)#" index="artistmatch">
								<cfset arrayAppend(arrLineUp,resultNodes[eventmatches].artists.artist[artistmatch].XmlText) />
							</cfloop>
							<cfset stuLineUp.artists = arrLineUp />
							<cfset stuEventMatches.artists = stuLineUp />
							<cfset stuEventMatches.venue = StructNew() />
							<cfset stuEventMatches.venue.name = resultNodes[eventmatches].venue.name.XmlText />
							<cfset stuEventMatches.venue.location = StructNew() />
							<cfset stuEventMatches.venue.location.city = resultNodes[eventmatches].venue.location.city.XmlText />
							<cfset stuEventMatches.venue.location.country = resultNodes[eventmatches].venue.location.country.XmlText />
							<cfset stuEventMatches.venue.location.street = resultNodes[eventmatches].venue.location.street.XmlText />
							<cfset stuEventMatches.venue.location.postalcode = resultNodes[eventmatches].venue.location.postalcode.XmlText />
							<cfset stuEventMatches.venue.location.point = StructNew() />
							<cfset stuEventMatches.venue.location.point.lat = resultNodes[eventmatches].venue.location.point.lat.XmlText />
							<cfset stuEventMatches.venue.location.point.long = resultNodes[eventmatches].venue.location.point.long.XmlText />
							<cfset stuEventMatches.venue.url = resultNodes[eventmatches].venue.url.XmlText />
							<cfset stuEventMatches.startDate = resultNodes[eventmatches].startDate.XmlText />
							<cfset stuEventMatches.description = resultNodes[eventmatches].description.XmlText />
							<cfset stuEventMatches.attendance = resultNodes[eventmatches].attendance.XmlText />
							<cfset stuEventMatches.reviews = resultNodes[eventmatches].reviews.XmlText />
							<cfset stuEventMatches.tag = resultNodes[eventmatches].tag.XmlText />
							<cfset stuEventMatches.url = resultNodes[eventmatches].url.XmlText />
							<cfset arrEventImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].image)#" index="eventImage">
								<cfset stuEventImage = StructNew()>
								<cfset stuEventImage.url = resultNodes[eventmatches].image.XmlText>
								<cfset stuEventImage.size = resultNodes[eventmatches].image.XmlAttributes.size>
								<cfset arrayAppend(arrEventImage,stuEventImage) />
							</cfloop>
							<cfset stuEventMatches.image = arrEventImage />
							<cfset arrayAppend(arrEventMatches,stuEventMatches) />
						</cfloop>
						<cfset stuResults.pastevents = arrEventMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/events/event')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="eventmatches">
							<cfset arrLineUp = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].artists.artist)#" index="artistmatch">
								<cfset arrayAppend(arrLineUp,resultNodes[eventmatches].artists.artist[artistmatch].XmlText) />
							</cfloop>
							<cfset stuEventMatches.venue = StructNew() />
							<cfset stuEventMatches.venue.name = resultNodes[eventmatches].venue.name.XmlText />
							<cfset stuEventMatches.venue.location = StructNew() />
							<cfset stuEventMatches.venue.location.city = resultNodes[eventmatches].venue.location.city.XmlText />
							<cfset stuEventMatches.venue.location.country = resultNodes[eventmatches].venue.location.country.XmlText />
							<cfset stuEventMatches.venue.location.street = resultNodes[eventmatches].venue.location.street.XmlText />
							<cfset stuEventMatches.venue.location.postalcode = resultNodes[eventmatches].venue.location.postalcode.XmlText />
							<cfset stuEventMatches.venue.location.point = StructNew() />
							<cfset stuEventMatches.venue.location.point.lat = resultNodes[eventmatches].venue.location.point.lat.XmlText />
							<cfset stuEventMatches.venue.location.point.long = resultNodes[eventmatches].venue.location.point.long.XmlText />
							<cfset stuEventMatches.venue.url = resultNodes[eventmatches].venue.url.XmlText />
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[eventmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'id', resultNodes[eventmatches].id.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'attendance', resultNodes[eventmatches].attendance.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'reviews', resultNodes[eventmatches].reviews.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artists', arrLineUp) />
							<cfset temp = QuerySetCell(rstResults, 'headliner', resultNodes[eventmatches].artists.headliner.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'title', resultNodes[eventmatches].title.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'startdate', resultNodes[eventmatches].startDate.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'description', resultNodes[eventmatches].description.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tag', resultNodes[eventmatches].tag.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venue', stuEventMatches.venue) />
							<cfif structKeyExists(resultNodes[eventmatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].image)#" index="eventImage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[eventmatches].image[eventImage].XmlAttributes.size, resultNodes[eventmatches].image[eventImage].XmlText) />
							</cfloop>
							</cfif>
						</cfloop>
						<cfset stuResults.pastevents = arrEventMatches />
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
	
	<cffunction name="search" output="true" returntype="Any" access="public" hint="Search for a venue by venue name ">
		<cfargument name="venue" required="yes" type="string" hint="the venue name you would like to search for." />
		<cfargument name="page" required="no" type="numeric" default="1" hint="the results page you would like to fetch." />
		<cfargument name="limit" required="no" type="numeric" default="30" hint="the number of results to fetch per page." />
		<cfargument name="country" required="no" type="string" default="" hint="Filter your results by country. Expressed as an ISO 3166-2 code" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrVenueMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,venueID,venueName,venueURL,venueLat,venueLong,venuePostalCode,venueCountry,venueCity,venueStreet') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('venue.search',arguments) />
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
					<cfset stuResults.startPage = returnedXML.lfm.results.query.XmlAttributes.startPage />
					<cfset stuResults.totalResults = returnedXML.lfm.results.totalResults.XmlText />
					<cfset stuResults.itemsPerPage = returnedXML.lfm.results.itemsPerPage.XmlText />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/venuematches/venue')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="venuematches">
							<cfset stuVenueMatches = StructNew()>
							<cfset stuVenueMatches.name = resultNodes[venuematches].name.XmlText>
							<cfset stuVenueMatches.id = resultNodes[venuematches].id.XmlText>
							<cfset stuVenueMatches.url = resultNodes[venuematches].url.XmlText>
							<cfset stuVenueMatches.venue.location = StructNew() />
							<cfset stuVenueMatches.venue.location.city = resultNodes[venuematches].location.city.XmlText />
							<cfset stuVenueMatches.venue.location.country = resultNodes[venuematches].location.country.XmlText />
							<cfset stuVenueMatches.venue.location.street = resultNodes[venuematches].location.street.XmlText />
							<cfset stuVenueMatches.venue.location.postalcode = resultNodes[venuematches].location.postalcode.XmlText />
							<cfset stuVenueMatches.venue.location.point = StructNew() />
							<cfset stuVenueMatches.venue.location.point.lat = resultNodes[venuematches].location.point.lat.XmlText />
							<cfset stuVenueMatches.venue.location.point.long = resultNodes[venuematches].location.point.long.XmlText />
							<cfset arrayAppend(arrVenueMatches,stuVenueMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrVenueMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/venuematches/venue')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="venuematches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[venuematches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueID', resultNodes[venuematches].id.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueName', resultNodes[venuematches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueURL', resultNodes[venuematches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueLat', resultNodes[venuematches].location.point.lat.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueLong', resultNodes[venuematches].location.point.long.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venuePostalCode', resultNodes[venuematches].location.postalcode.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueCountry', resultNodes[venuematches].location.country.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueCity', resultNodes[venuematches].location.city.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venueStreet', resultNodes[venuematches].location.street.XmlText) />
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