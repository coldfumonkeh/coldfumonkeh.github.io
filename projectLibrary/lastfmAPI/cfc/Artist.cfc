<!---

	Name: Artist.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="artist" hint="Component containing functions to access ARTIST methods within the last.fm API">

	<cffunction name="init" access="public" returntype="artist" output="false" hint="I am the constructor method.">
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
				
	<cffunction name="search" output="true" returntype="Any" access="public" hint="Search for an artist by name. Returns artist matches sorted by relevance. ">
		<cfargument name="artist" required="yes" type="string" hint="the name of the artist" />
		<cfargument name="page" required="no" type="numeric" default="1" hint="Scan into the results by specifying a page number. Defaults to first page." />
		<cfargument name="limit" required="no" type="numeric" default="30" hint="Limit the number of artists returned at one time. Default (maximum) is 30." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('Name,URL,Streamable,MBID,small,medium,large,extralarge,mega') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.search',arguments) />
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
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/artistmatches/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[artistmatches].name.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[artistmatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[artistmatches].url.XmlText>
							<cfset stuArtistMatches.streamable = resultNodes[artistmatches].streamable.XmlText>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[artistmatches].image.XmlText>
								<cfset stuArtistImage.size = resultNodes[artistmatches].image.XmlAttributes.size>
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
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/artistmatches/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'Name', resultNodes[artistmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'URL', resultNodes[artistmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'Streamable', resultNodes[artistmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'MBID', resultNodes[artistmatches].mbid.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="artistimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[artistmatches].image[artistimage].XmlAttributes.size, resultNodes[artistmatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getEvents" output="true" returntype="any" access="public" hint="Get a list of upcoming events for this artist. Easily integratable into calendars, using the ical standard">
		<cfargument name="artist" required="no" type="string" default="" hint="the name of the artist" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('Artists,attendance,description,headliner,ID,image,reviews,tag,title,url,venue') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.getEvents',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>	
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset stuResults.artist = returnedXML.lfm.events.XmlAttributes.artist />
					<cfset stuResults.total = returnedXML.lfm.events.XmlAttributes.total />
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
							<cfset stuEventMatches.venue.location.timezone = resultNodes[eventmatches].venue.location.timezone.XmlText />
							<cfset stuEventMatches.venue.location.point = StructNew() />
							<cfset stuEventMatches.venue.location.point.lat = resultNodes[eventmatches].venue.location.point.lat.XmlText />
							<cfset stuEventMatches.venue.location.point.long = resultNodes[eventmatches].venue.location.point.long.XmlText />
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
								<cfset stuEventImage.url = resultNodes[eventimage].image.XmlText>
								<cfset stuEventImage.size = resultNodes[eventimage].image.XmlAttributes.size>
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
							<cfset stuEventMatches.venue = StructNew() />
							<cfset stuEventMatches.venue.name = resultNodes[eventmatches].venue.name.XmlText>
							<cfset stuEventMatches.venue.url = resultNodes[eventmatches].venue.url.XmlText>
							<cfset stuEventMatches.venue.location = StructNew() />
							<cfset stuEventMatches.venue.location.city = resultNodes[eventmatches].venue.location.city.XmlText />
							<cfset stuEventMatches.venue.location.country = resultNodes[eventmatches].venue.location.country.XmlText />
							<cfset stuEventMatches.venue.location.street = resultNodes[eventmatches].venue.location.street.XmlText />
							<cfset stuEventMatches.venue.location.postalcode = resultNodes[eventmatches].venue.location.postalcode.XmlText />
							<cfset stuEventMatches.venue.location.timezone = resultNodes[eventmatches].venue.location.timezone.XmlText />
							<cfset stuEventMatches.venue.location.point = StructNew() />
							<cfset stuEventMatches.venue.location.point.lat = resultNodes[eventmatches].venue.location.point.lat.XmlText />
							<cfset stuEventMatches.venue.location.point.long = resultNodes[eventmatches].venue.location.point.long.XmlText />
							<cfset temp = QuerySetCell(rstResults, 'title', resultNodes[eventmatches].title.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'id', resultNodes[eventmatches].id.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'venue', stuEventMatches.venue) />
							<cfset temp = QuerySetCell(rstResults, 'headliner', resultNodes[eventmatches].artists.headliner.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'attendance', resultNodes[eventmatches].attendance.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'description', resultNodes[eventmatches].description.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'reviews', resultNodes[eventmatches].reviews.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tag', resultNodes[eventmatches].tag.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[eventmatches].url.XmlText) />
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
							<cfset temp = QuerySetCell(rstResults, 'Artists', arrEventArtists) />
	
							<cfset arrEventImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[eventmatches].image)#" index="eventimage">
								<cfset stuEventImage = StructNew()>
								<cfset stuEventImage.url = resultNodes[eventimage].image.XmlText>
								<cfset stuEventImage.size = resultNodes[eventimage].image.XmlAttributes.size>
								<cfset arrayAppend(arrEventImage,stuEventImage) />
							</cfloop>
							<cfset temp = QuerySetCell(rstResults, 'image', stuEventImage) />				
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
	
	<cffunction name="getInfo" output="true" returntype="any" access="public" hint="Get the metadata for an artist on Last.fm. Includes biography. ">
		<cfargument name="artist" required="no" type="string" default="" hint="the name of the artist" />
		<cfargument name="mbid" required="no" type="string" default="" hint="The musicbrainz id for the artist" />
		<cfargument name="lang" required="no" type="string" default="" hint="The language to return the biography in, expressed as an ISO 639 alpha-2 code." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.getInfo',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>	
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/artist/')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[artistmatches].name.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[artistmatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[artistmatches].url.XmlText>
							<cfset stuArtistMatches.stats = StructNew()>
							<cfset stuArtistMatches.stats.listeners = resultNodes[artistmatches].stats.listeners.XmlText />
							<cfset stuArtistMatches.stats.playcount = resultNodes[artistmatches].stats.playcount.XmlText />
							<cfset stuArtistMatches.streamable = resultNodes[artistmatches].streamable.XmlText>
							<cfset stuArtistMatches.bio = StructNew()>
							<cfset stuArtistMatches.bio.summary = resultNodes[artistmatches].bio.summary.XmlText />
							<cfset stuArtistMatches.bio.content = resultNodes[artistmatches].bio.content.XmlText />
							<cfset stuArtistMatches.bio.published = resultNodes[artistmatches].bio.published.XmlText />
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[artistmatches].image.XmlText>
								<cfset stuArtistImage.size = resultNodes[artistmatches].image.XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							<!--- add in the similar artists --->
							<cfset resultSimilarNodes = xmlSearch(#searchResults#,'/lfm/artist/similar/artist')>
							<cfset arrSimArtist = ArrayNew(1) />
							<cfif arrayLen(resultSimilarNodes) GT 0>
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].similar.artist)#" index="similarArtist">
								<cfset stuSimArtist = StructNew()>
								<cfset stuSimArtist.name = resultNodes[artistmatches].similar.artist[similarArtist].name.XmlText>
								<cfset stuSimArtist.url = resultNodes[artistmatches].similar.artist[similarArtist].url.XmlText>
								<!--- get similar artist images --->
								<cfset arrSimArtistImage = ArrayNew(1) />
								<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].similar.artist.image)#" index="simArtistimage">
									<cfset stuSimArtistImage = StructNew()>
									<cfset stuSimArtistImage.url = resultNodes[artistmatches].similar.artist[similarArtist].image[simArtistimage].XmlText>
									<cfset stuSimArtistImage.size = resultNodes[artistmatches].similar.artist[similarArtist].image[simArtistimage].XmlAttributes.size>
									<cfset arrayAppend(arrSimArtistImage,stuSimArtistImage) />
								</cfloop>
								<cfset stuSimArtist.image = arrSimArtistImage />
								<cfset arrayAppend(arrSimArtist,stuSimArtist) />
							</cfloop>
							</cfif>
							<cfset stuArtistMatches.similar = arrSimArtist />
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrArtistMatches />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getShouts" output="true" returntype="any" access="public" hint="Get shouts for this artist. Also available as an rss feed. ">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrShoutMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artist,body,date,author')>
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.getshouts',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.artist = returnedXML.lfm.shouts.XmlAttributes.artist />
					<cfset stuResults.total = returnedXML.lfm.shouts.XmlAttributes.total />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/shouts/shout')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="shoutmatches">
							<cfset stuShoutMatches = StructNew()>
							<cfset stuShoutMatches.body = resultNodes[shoutmatches].body.XmlText>
							<cfset stuShoutMatches.author = resultNodes[shoutmatches].author.XmlText>
							<cfset stuShoutMatches.date = resultNodes[shoutmatches].date.XmlText>
							<cfset arrayAppend(arrShoutMatches,stuShoutMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.shouts = arrShoutMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/shouts/shout')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="shoutmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'artist', returnedXML.lfm.shouts.XmlAttributes.artist)>
							<cfset temp = QuerySetCell(rstResults, 'body', resultNodes[shoutmatches].body.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'date', resultNodes[shoutmatches].date.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'author', resultNodes[shoutmatches].author.XmlText)>
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
	
	<cffunction name="getSimilar" output="true" returntype="any" access="public" hint="Get all the artists similar to this artist ">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="Limit the number of similar artists returned" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,match,name,streamable,mbid,small,medium,large,extralarge,mega') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.getsimilar',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset stuResults.artist = returnedXML.lfm.similarartists.XmlAttributes.artist />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/similarartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[artistmatches].name.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[artistmatches].mbid.XmlText>
							<cfset stuArtistMatches.match = resultNodes[artistmatches].match.XmlText>
							<cfset stuArtistMatches.url = resultNodes[artistmatches].url.XmlText>
							<cfset stuArtistMatches.streamable = resultNodes[artistmatches].streamable.XmlText>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[artistmatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[artistmatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.similarArtists = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/similarartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[artistmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'match', resultNodes[artistmatches].match.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[artistmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[artistmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[artistmatches].mbid.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="artistimage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[artistmatches].image[artistimage].XmlAttributes.size, resultNodes[artistmatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getTopAlbums" output="true" returntype="any" access="public" hint="Get the top albums for an artist on Last.fm, ordered by popularity. ">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrAlbumMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('rank, artistName, artistURL, playcount, url, name, mbid, small, medium, large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.gettopalbums',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.artist = returnedXML.lfm.topalbums.XmlAttributes.artist />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topalbums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
							<cfset stuTopAlbum = StructNew()>
							<cfset stuTopAlbum.rank = resultNodes[albummatches].XmlAttributes.rank>
							<cfset stuTopAlbum.name = resultNodes[albummatches].name.XmlText>
							<cfset stuTopAlbum.playcount = resultNodes[albummatches].playcount.XmlText>
							<cfset stuTopAlbum.mbid = resultNodes[albummatches].mbid.XmlText>
							<cfset stuTopAlbum.url = resultNodes[albummatches].url.XmlText>
							<cfset stuTopAlbum.artist = StructNew() />
							<cfset stuTopAlbum.artist.name = resultNodes[albummatches].artist.name.XmlText />
							<cfset stuTopAlbum.artist.url = resultNodes[albummatches].artist.url.XmlText />
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[albummatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[albummatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuTopAlbum.image = arrArtistImage />
							<cfset arrayAppend(arrAlbumMatches,stuTopAlbum) />
						</cfloop>
					</cfif>
					<cfset stuResults.topAlbums = arrAlbumMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topalbums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[albummatches].XmlAttributes.rank) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[albummatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[albummatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[albummatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[albummatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[albummatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[albummatches].artist.url.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="artistimage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[albummatches].image[artistimage].XmlAttributes.size, resultNodes[albummatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getTopFans" output="true" returntype="any" access="public" hint="Get the top fans for an artist on Last.fm, based on listening data. ">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrFanMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artist,url,name,weight,small,medium,large,extralarge,mega') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.gettopfans',arguments) />
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
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topfans/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="fanmatches">
							<cfset stuTopFans = StructNew()>
							<cfset stuTopFans.weight = resultNodes[fanmatches].weight.XmlText>
							<cfset stuTopFans.name = resultNodes[fanmatches].name.XmlText>
							<cfset stuTopFans.url = resultNodes[fanmatches].url.XmlText>			
							<cfif structKeyExists(resultNodes[fanmatches], "image")>					
							<cfset arrUserImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[fanmatches].image)#" index="userimage">
								<cfset stuUserImage = StructNew()>
								<cfset stuUserImage.url = resultNodes[fanmatches].image[userimage].XmlText>
								<cfset stuUserImage.size = resultNodes[fanmatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrUserImage,stuUserImage) />
							</cfloop>
							<cfset stuTopFans.image = arrUserImage />
							</cfif>
							<cfset arrayAppend(arrFanMatches,stuTopFans) />
						</cfloop>
					</cfif>
					<cfset stuResults.topFans = arrFanMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topfans/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="fanmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'artist', returnedXML.lfm.topfans.XmlAttributes.artist) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[fanmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[fanmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'weight', resultNodes[fanmatches].weight.XmlText) />			
							<cfif structKeyExists(resultNodes[fanmatches], "image")>					
							<cfloop from="1" to="#arrayLen(resultNodes[fanmatches].image)#" index="userimage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[fanmatches].image[userimage].XmlAttributes.size, resultNodes[fanmatches].image[userimage].XmlText) />
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
	
	<cffunction name="getTopTracks" output="true" returntype="any" access="public" hint="Get the top tracks by an artist on Last.fm, ordered by popularity">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('rank,name,playcount,mbid,url,streamable,fulltrack,artistname,artisturl,small,medium,large,extralarge,mega')>
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.gettoptracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.artist = returnedXML.lfm.toptracks.XmlAttributes.artist />
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
							<cfset stuTopTracks.artist.url = resultNodes[trackmatches].artist.url.XmlText />			
							<cfif structKeyExists(resultNodes[trackmatches], "image")>					
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[trackmatches].image.XmlText>
								<cfset stuArtistImage.size = resultNodes[trackmatches].image.XmlAttributes.size>
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
							<cfset temp = QueryAddRow(rstResults)>
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[trackmatches].XmlAttributes.rank)>
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[trackmatches].name.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[trackmatches].playcount.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[trackmatches].mbid.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[trackmatches].streamable.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'fulltrack', resultNodes[trackmatches].streamable.XmlAttributes.fulltrack)>
							<cfset temp = QuerySetCell(rstResults, 'artistname', resultNodes[trackmatches].artist.name.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'artisturl', resultNodes[trackmatches].artist.url.XmlText)>
							<cfif structKeyExists(resultNodes[trackmatches], "image")>
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="artistimage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[trackmatches].image[artistimage].XmlAttributes.size, resultNodes[trackmatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getTopTags" output="true" returntype="any" access="public" hint="Get the top tags for an artist on Last.fm, ordered by popularity.">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artist,name,url,count')>
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('artist.gettoptags',arguments) />
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
							<cfset temp = QueryAddRow(rstResults)>
							<cfset temp = QuerySetCell(rstResults, 'artist', returnedXML.lfm.toptags.XmlAttributes.artist)>
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[tagmatches].name.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[tagmatches].url.XmlText)>
							<cfset temp = QuerySetCell(rstResults, 'count', resultNodes[tagmatches].count.XmlText)>
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
	
	
	<cffunction name="getTags" output="true" returntype="any" access="public" hint="Get the tags applied by an individual user to an artist on Last.fm. ">
		<cfargument name="artist" required="yes" type="string" default="" hint="The artist name in question" />
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
			<cfset args['sessionKey'] = arguments.sessionKey />
			<cfset searchResults = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('artist.gettags', args, arguments.sessionKey, 'xml')) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/tags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset stuTopTags = StructNew()>
							<cfset stuTopTags.name = resultNodes[tagmatches].name.XmlText>
							<cfset stuTopTags.url = resultNodes[tagmatches].url.XmlText>
							<cfset arrayAppend(arrTagMatches,stuTopTags) />
						</cfloop>
					</cfif>
					<cfset stuResults.topTags = arrTagMatches />
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
		<cfargument name="tags" required="yes" type="string" default="" hint="A comma delimited list of user supplied tags to apply to this album. Accepts a maximum of 10 tags." />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['tags'] = arguments.tags />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('artist.addTags', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="removeTag" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist" />
		<cfargument name="tag" required="yes" type="string" default="" hint="A single user tag to remove from this artist" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['tag'] = arguments.tag />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('artist.removeTag', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="share" output="true" returntype="any" access="public" hint="get information for a specific album">
		<cfargument name="artist" required="yes" type="string" default="" hint="the name of the artist to share" />
		<cfargument name="recipient" required="yes" type="string" default="" hint="Email Address | Last.fm Username - A comma delimited list of email addresses or Last.fm usernames. Maximum is 10" />
		<cfargument name="message" required="false" type="string" default="" hint="An optional message to send with the recommendation. If not supplied a default message will be used." />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['recipient'] = arguments.recipient />
			<cfset args['message'] = arguments.message />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('artist.share', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
</cfcomponent>