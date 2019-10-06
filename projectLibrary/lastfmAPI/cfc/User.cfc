<!---

	Name: User.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="user" hint="Component containing functions to access USER methods within the last.fm API">

	<cffunction name="init" access="public" returntype="user" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="getEvents" output="true" returntype="any" access="public" hint="Get a list of upcoming events that this user is attending. Easily integratable into calendars, using the ical standard">
		<cfargument name="user" required="yes" type="string" default="" hint="The user name" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,id,venueID,venueName,venueURL,venueLat,venueLong,venuePostalCode,venueCountry,venueCity,venueStreet,attendance,reviews,headliner,artists,title,startDate,description,tag,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getevents',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.events.XmlAttributes.user />
					<cfset stuResults.total = returnedXML.lfm.events.XmlAttributes.total />
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
						<cfset stuResults.events = arrEventMatches />
					</cfif>
					<cfset returnVar = stuResults />
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
					<cfset returnVar = returnedXML />
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getFriends" output="true" returntype="any" access="public" hint="Get a list of the user's friends on Last.fm. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The last.fm username to fetch the friends of." />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="An integer used to limit the number of friends returned." />
		<cfargument name="recenttracks" required="no" type="boolean" default="False" hint="Whether or not to include information about friends' recent listening in the response." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrFriendMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,url,name,realname,small,medium,large,extralarge,recentTrack') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getfriends',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.friends.XmlAttributes.for />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/friends/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="friendmatches">
							<cfset stuFriendMatches = StructNew()>
							<cfset stuFriendMatches.name = resultNodes[friendmatches].name.XmlText>
							<cfset stuFriendMatches.realname = resultNodes[friendmatches].realname.XmlText>
							<cfset stuFriendMatches.url = resultNodes[friendmatches].url.XmlText>
							<cfif arguments.recenttracks NEQ 'false'>
								<cfset stuFriendMatches.recenttrack = StructNew() />
								<cfset stuFriendMatches.recenttrack.artist = StructNew() />
								<cfset stuFriendMatches.recenttrack.artist.name = resultNodes[friendmatches].recenttrack.artist.name.XmlText />
								<cfset stuFriendMatches.recenttrack.artist.mbid = resultNodes[friendmatches].recenttrack.artist.mbid.XmlText />
								<cfset stuFriendMatches.recenttrack.artist.url = resultNodes[friendmatches].recenttrack.artist.url.XmlText />
								<cfset stuFriendMatches.recenttrack.name = resultNodes[friendmatches].recenttrack.name.XmlText />
								<cfset stuFriendMatches.recenttrack.mbid = resultNodes[friendmatches].recenttrack.mbid.XmlText />
								<cfset stuFriendMatches.recenttrack.url = resultNodes[friendmatches].recenttrack.url.XmlText />
							</cfif>
							<cfif structKeyExists(resultNodes[friendmatches], "image")>
							<cfset arrFriendImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[friendmatches].image)#" index="userimage">
								<cfset stuFriendImage = StructNew()>
								<cfset stuFriendImage.url = resultNodes[friendmatches].image[userimage].XmlText>
								<cfset stuFriendImage.size = resultNodes[friendmatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrFriendImage,stuFriendImage) />
							</cfloop>
							<cfset stuFriendMatches.image = arrFriendImage />
							</cfif>
							<cfset arrayAppend(arrFriendMatches,stuFriendMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.friends = arrFriendMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/friends/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="friendmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.friends.XmlAttributes.for) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[friendmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[friendmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'realName', resultNodes[friendmatches].realname.XmlText) />
							<cfif structKeyExists(resultNodes[friendmatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[friendmatches].image)#" index="userimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[friendmatches].image[userimage].XmlAttributes.size, resultNodes[friendmatches].image[userimage].XmlText) />
							</cfloop>
							</cfif>
							<cfif arguments.recenttracks NEQ 'false'>
								<cfset stuFriendMatches.recenttrack = StructNew() />
								<cfset stuFriendMatches.recenttrack.artist = StructNew() />
								<cfset stuFriendMatches.recenttrack.artist.name = resultNodes[friendmatches].recenttrack.artist.name.XmlText />
								<cfset stuFriendMatches.recenttrack.artist.mbid = resultNodes[friendmatches].recenttrack.artist.mbid.XmlText />
								<cfset stuFriendMatches.recenttrack.artist.url = resultNodes[friendmatches].recenttrack.artist.url.XmlText />
								<cfset stuFriendMatches.recenttrack.name = resultNodes[friendmatches].recenttrack.name.XmlText />
								<cfset stuFriendMatches.recenttrack.mbid = resultNodes[friendmatches].recenttrack.mbid.XmlText />
								<cfset stuFriendMatches.recenttrack.url = resultNodes[friendmatches].recenttrack.url.XmlText />
								<cfset temp = QuerySetCell(rstResults, 'recentTrack', stuFriendMatches.recenttrack) />
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
	
	<cffunction name="getPlaylists" output="true" returntype="any" access="public" hint="Get a list of a user's playlists on Last.fm. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The last.fm username to fetch the playlists of." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,streamable,url,id,creator,date,duration,title,description,size,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getplaylists',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.playlists.XmlAttributes.user />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/playlists/playlist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.id = resultNodes[librarymatches].id.XmlText>
							<cfset stuArtistMatches.title = resultNodes[librarymatches].title.XmlText>
							<cfset stuArtistMatches.description = resultNodes[librarymatches].description.XmlText>
							<cfset stuArtistMatches.date = resultNodes[librarymatches].date.XmlText>
							<cfset stuArtistMatches.size = resultNodes[librarymatches].size.XmlText>
							<cfset stuArtistMatches.url = resultNodes[librarymatches].url.XmlText>
							<cfset stuArtistMatches.duration = resultNodes[librarymatches].duration.XmlText>
							<cfset stuArtistMatches.streamable = resultNodes[librarymatches].streamable.XmlText>
							<cfset stuArtistMatches.creator = resultNodes[librarymatches].creator.XmlText />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="userimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[librarymatches].image[userimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[librarymatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.userplaylist = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/playlists/playlist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'id', resultNodes[librarymatches].id.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'title', resultNodes[librarymatches].title.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'description', resultNodes[librarymatches].description.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'date', resultNodes[librarymatches].date.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'size', resultNodes[librarymatches].size.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'duration', resultNodes[librarymatches].duration.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[librarymatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'creator', resultNodes[librarymatches].creator.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.playlists.XmlAttributes.user) />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="userimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[userimage].XmlAttributes.size, resultNodes[librarymatches].image[userimage].XmlText) />
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
	
	<cffunction name="getLovedTracks" output="true" returntype="any" access="public" hint="Get the last 50 tracks loved by a user. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user name to fetch the loved tracks for." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistURL,artistMBID,dateUTS,date,url,name,mbid,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getlovedtracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.lovedtracks.XmlAttributes.user />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/lovedtracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuArtistMatches.mbid = resultNodes[librarymatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[librarymatches].url.XmlText>
							<cfset stuArtistMatches.date = StructNew() />
							<cfset stuArtistMatches.date.date = resultNodes[librarymatches].date.XmlText />
							<cfset stuArtistMatches.date.uts = resultNodes[librarymatches].date.XmlAttributes.uts />
							<cfset stuArtistMatches.artist = StructNew() />
							<cfset stuArtistMatches.artist.artist = resultNodes[librarymatches].artist.name.XmlText />
							<cfset stuArtistMatches.artist.mbid = resultNodes[librarymatches].artist.mbid.XmlText />
							<cfset stuArtistMatches.artist.url = resultNodes[librarymatches].artist.url.XmlText />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="userimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[librarymatches].image[userimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[librarymatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							</cfif>
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.lovedtracks = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/lovedtracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'dateUTS', resultNodes[librarymatches].date.XmlAttributes.uts) />
							<cfset temp = QuerySetCell(rstResults, 'date', resultNodes[librarymatches].date.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[librarymatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[librarymatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[librarymatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.lovedtracks.XmlAttributes.user) />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="userimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[userimage].XmlAttributes.size, resultNodes[librarymatches].image[userimage].XmlText) />
							</cfloop>
							</cfif>
						</cfloop>
					</cfif>
					<cfset returnVar = rstResults />
				</cfcase>
				<cfcase value="xml">
					<cfset returnVar = searchResults />
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>

	<cffunction name="getNeightbours" output="true" returntype="any" access="public" hint="Get a list of a user's neighbours on Last.fm. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The last.fm username to fetch the neighbours of." />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="An integer used to limit the number of neighbours returned." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrFriendMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,url,match,name,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getneighbours',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.neighbours.XmlAttributes.user />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/neighbours/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="friendmatches">
							<cfset stuFriendMatches = StructNew()>
							<cfset stuFriendMatches.name = resultNodes[friendmatches].name.XmlText>
							<cfset stuFriendMatches.match = resultNodes[friendmatches].match.XmlText>
							<cfset stuFriendMatches.url = resultNodes[friendmatches].url.XmlText>
							<cfif structKeyExists(resultNodes[friendmatches], "image")>
							<cfset arrFriendImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[friendmatches].image)#" index="userimage">
								<cfset stuFriendImage = StructNew()>
								<cfset stuFriendImage.url = resultNodes[friendmatches].image[userimage].XmlText>
								<cfset stuFriendImage.size = resultNodes[friendmatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrFriendImage,stuFriendImage) />
							</cfloop>
							<cfset stuFriendMatches.image = arrFriendImage />
							</cfif>
							<cfset arrayAppend(arrFriendMatches,stuFriendMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.neighbours = arrFriendMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/neighbours/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="friendmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.neighbours.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[friendmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'match', resultNodes[friendmatches].match.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[friendmatches].name.XmlText) />
							<cfif structKeyExists(resultNodes[friendmatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[friendmatches].image)#" index="userimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[friendmatches].image[userimage].XmlAttributes.size, resultNodes[friendmatches].image[userimage].XmlText) />
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
	
	<cffunction name="getRecentTracks" output="true" returntype="any" access="public" hint="Get a list of the recent tracks listened to by this user. Indicates now playing track if the user is currently listening.">
		<cfargument name="user" required="yes" type="string" default="" hint="The last.fm username to fetch the recent tracks of." />
		<cfargument name="limit" required="no" type="numeric" default="0" hint="An integer used to limit the number of tracks returned." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrFriendMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistMBID,albumName,albumMBID,name,url,dateUTS,date,streamable,mbid,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getrecenttracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.recenttracks.XmlAttributes.user />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/recenttracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset stuFriendMatches = StructNew()>
							<cfset stuFriendMatches.artist = StructNew() />
							<cfset stuFriendMatches.artist.name = resultNodes[trackmatches].artist.XmlText>
							<cfset stuFriendMatches.artist.mbid = resultNodes[trackmatches].artist.XmlAttributes.mbid>
							<cfset stuFriendMatches.album = StructNew() />
							<cfset stuFriendMatches.album.name = resultNodes[trackmatches].album.XmlText>
							<cfset stuFriendMatches.album.mbid = resultNodes[trackmatches].album.XmlAttributes.mbid>
							<cfset stuFriendMatches.streamable = resultNodes[trackmatches].streamable.XmlText>
							<cfset stuFriendMatches.date = StructNew() />
							<cfset stuFriendMatches.date.date = resultNodes[trackmatches].date.XmlText>
							<cfset stuFriendMatches.date.uts = resultNodes[trackmatches].date.XmlAttributes.uts>
							<cfset stuFriendMatches.streamable = resultNodes[trackmatches].streamable.XmlText>
							<cfset stuFriendMatches.mbid = resultNodes[trackmatches].mbid.XmlText>
							<cfset stuFriendMatches.url = resultNodes[trackmatches].url.XmlText>
							<cfset stuFriendMatches.name = resultNodes[trackmatches].name.XmlText>
							<cfif structKeyExists(resultNodes[trackmatches], "image")>
							<cfset arrFriendImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="userimage">
								<cfset stuFriendImage = StructNew()>
								<cfset stuFriendImage.url = resultNodes[trackmatches].image[userimage].XmlText>
								<cfset stuFriendImage.size = resultNodes[trackmatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrFriendImage,stuFriendImage) />
							</cfloop>
							<cfset stuFriendMatches.image = arrFriendImage />
							</cfif>
							<cfset arrayAppend(arrFriendMatches,stuFriendMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.recenttracks = arrFriendMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/recenttracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.recenttracks.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[trackmatches].artist.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[trackmatches].artist.XmlAttributes.mbid) />
							<cfset temp = QuerySetCell(rstResults, 'albumName', resultNodes[trackmatches].album.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'albumMBID', resultNodes[trackmatches].album.XmlAttributes.mbid) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[trackmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[trackmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'dateUTS', resultNodes[trackmatches].date.XmlAttributes.uts) />
							<cfset temp = QuerySetCell(rstResults, 'date', resultNodes[trackmatches].date.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[trackmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[trackmatches].mbid.XmlText) />			
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
					<cfset returnVar = returnedXML />
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getShouts" output="true" returntype="any" access="public" hint="Get shouts for this user. Also available as an rss feed. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The username to fetch shouts for" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrShoutMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,body,date,author') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getshouts',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.shouts.XmlAttributes.user />
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
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.shouts.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'body', resultNodes[shoutmatches].body.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'date', resultNodes[shoutmatches].date.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'author', resultNodes[shoutmatches].author.XmlText) />
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
	
	<cffunction name="getInfo" output="true" returntype="any" access="public" hint="Get information about a user profile. ">
		<cfargument name="sessionKey" required="yes" type="string" default="A session key generated by authenticating a user via the authentication protocol. " />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrShoutMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset args = StructNew() />
			<cfset searchResults = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('user.getinfo', args, arguments.sessionKey, 'xml')) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>
					<cfset stuResults.id = returnedXML.lfm.user.id.XmlText />
					<cfset stuResults.name = returnedXML.lfm.user.name.XmlText />
					<cfset stuResults.url = returnedXML.lfm.user.url.XmlText />
					<cfset stuResults.image = returnedXML.lfm.user.image.XmlText />
					<cfset stuResults.lang = returnedXML.lfm.user.lang.XmlText />
					<cfset stuResults.country = returnedXML.lfm.user.country.XmlText />
					<cfset stuResults.age = returnedXML.lfm.user.age.XmlText />
					<cfset stuResults.gender = returnedXML.lfm.user.gender.XmlText />
					<cfset stuResults.subscriber = returnedXML.lfm.user.subscriber.XmlText />
					<cfset stuResults.playcount = returnedXML.lfm.user.playcount.XmlText />
					<cfset stuResults.playlists = returnedXML.lfm.user.playlists.XmlText />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getRecommendedArtists" output="true" returntype="any" access="public" hint="Get Last.fm artist recommendations for a user ">
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,name,mbid,streamable,small,medium,large,extralarge') />
			<cfset args = StructNew() />
			<cfset searchResults = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('user.getRecommendedArtists', args, arguments.sessionKey, 'xml')) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.recommendations.XmlAttributes.user />
					<cfset stuResults.page = returnedXML.lfm.recommendations.XmlAttributes.page />
					<cfset stuResults.perpage = returnedXML.lfm.recommendations.XmlAttributes.perpage />
					<cfset stuResults.total = returnedXML.lfm.recommendations.XmlAttributes.total />
					<cfset stuResults.totalpages = returnedXML.lfm.recommendations.XmlAttributes.totalpages />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/recommendations/artist')>
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
								<cfset stuArtistImage.url = resultNodes[artistmatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[artistmatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
						<cfset stuResults.recommendations = arrArtistMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/recommendations/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[artistmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[artistmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[artistmatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[artistmatches].streamable.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="image">
								<cfset temp = QuerySetCell(rstResults, resultNodes[artistmatches].image[image].XmlAttributes.size, resultNodes[artistmatches].image[image].XmlText) />
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
	
	<cffunction name="getRecommendedEvents" output="true" returntype="any" access="public" hint="Get a paginated list of all events recommended to a user by Last.fm, based on their listening profile. ">
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />
		<cfargument name="page" required="false" type="numeric" default="1" hint="the page number to scan to" />
		<cfargument name="limit" required="false" type="numeric" default="10" hint="the number of events to return per page" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,id,venueID,venueName,venueURL,venueLat,venueLong,venuePostalCode,venueCountry,venueCity,venueStreet,attendance,reviews,headliner,artists,title,startDate,description,tag,small,medium,large,extralarge') />
			<cfset args = StructNew() />
			<cfset args["page"] = arguments.page />
			<cfset args["limit"] = arguments.limit />
			<cfset searchResults = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('user.getRecommendedEvents', args, arguments.sessionKey, 'xml')) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch  expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.events.XmlAttributes.user />
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
							<cfset stuEventMatches.venue.id = resultNodes[eventmatches].venue.id.XmlText />
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
								<cfset stuEventImage.url = resultNodes[eventmatches].image[eventImage].XmlText>
								<cfset stuEventImage.size = resultNodes[eventmatches].image[eventImage].XmlAttributes.size>
								<cfset arrayAppend(arrEventImage,stuEventImage) />
							</cfloop>
							<cfset stuEventMatches.image = arrEventImage />
							<cfset arrayAppend(arrEventMatches,stuEventMatches) />
						</cfloop>
						<cfset stuResults.recommendedEvents = arrEventMatches />
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
					<cfset returnVar = returnedXML />
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getPastEvents" output="true" returntype="any" access="public" hint="Get a paginated list of all events a user has attended in the past. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The username to fetch the events for" />
		<cfargument name="page" required="false" type="numeric" default="1" hint="the page number to scan to" />
		<cfargument name="limit" required="false" type="numeric" default="10" hint="the number of events to return per page" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,url,ID,venue,attendance,reviews,artists,headliner,title,startdate,description,tag,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getpastevents',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.events.XmlAttributes.user />
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
								<cfset stuEventImage.url = resultNodes[eventmatches].image[eventImage].XmlText>
								<cfset stuEventImage.size = resultNodes[eventmatches].image[eventImage].XmlAttributes.size>
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
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.events.XmlAttributes.user) />
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
	
	<cffunction name="getTopTags" output="true" returntype="any" access="public" hint="Get the top tags used by this user. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user name" />
		<cfargument name="limit" required="false" type="numeric" default="10" hint="the number of events to return per page" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset rstResults = QueryNew('user,url,name,count') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.gettoptags',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.toptags.XmlAttributes.user />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
						<cfset stuTagMatches = StructNew()>
							<cfset stuTagMatches.name = resultNodes[tagmatches].name.XmlText>
							<cfset stuTagMatches.count = resultNodes[tagmatches].count.XmlText>
							<cfset stuTagMatches.url = resultNodes[tagmatches].url.XmlText>
							<cfset arrayAppend(arrTagMatches, stuTagMatches) />
						</cfloop>
						<cfset stuResults.toptags = arrTagMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.toptags.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[tagmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[tagmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'count', resultNodes[tagmatches].count.XmlText) />
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
	
	<cffunction name="getTopArtists" output="true" returntype="any" access="public" hint="Get the top artists listened to by a user. You can stipulate a time period. Sends the overall chart by default. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user name" />
		<cfargument name="period" required="no" type="string" default="overall" hint="the time period over which to retrieve top artists for (overall||3month||6month||12month)" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,playcount,url,name,streamable,mbid,rank,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.gettopartists',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.topartists.XmlAttributes.user />
					<cfset stuResults.type = returnedXML.lfm.topartists.XmlAttributes.type />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
						<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[artistmatches].name.XmlText>
							<cfset stuArtistMatches.playcount = resultNodes[artistmatches].playcount.XmlText>
							<cfset stuArtistMatches.rank = resultNodes[artistmatches].XmlAttributes.rank>
							<cfset stuArtistMatches.mbid = resultNodes[artistmatches].mbid.XmlText>
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
						<cfset stuResults.topartists = arrArtistMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="artistmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.topartists.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[artistmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[artistmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[artistmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[artistmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[artistmatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[artistmatches].XmlAttributes.rank) />
							<cfif structKeyExists(resultNodes[artistmatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[artistmatches].image)#" index="artistimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[artistmatches].image[artistimage].XmlAttributes.size, resultNodes[artistmatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getTopAlbums" output="true" returntype="any" access="public" hint="Get the top albums listened to by a user. You can stipulate a time period. Sends the overall chart by default.">
		<cfargument name="user" required="yes" type="string" default="" hint="The user name" />
		<cfargument name="period" required="no" type="string" default="overall" hint="the time period over which to retrieve top artists for (overall||3month||6month||12month)" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistURL,artistMBID,playcount,url,name,mbid,rank,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.gettopalbums',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.topalbums.XmlAttributes.user />
					<cfset stuResults.type = returnedXML.lfm.topalbums.XmlAttributes.type />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topalbums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
						<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[albummatches].name.XmlText>
							<cfset stuArtistMatches.playcount = resultNodes[albummatches].playcount.XmlText>
							<cfset stuArtistMatches.rank = resultNodes[albummatches].XmlAttributes.rank>
							<cfset stuArtistMatches.mbid = resultNodes[albummatches].mbid.XmlText>
							<cfset stuArtistMatches.url = resultNodes[albummatches].url.XmlText>
							<cfset stuArtistMatches.artist = StructNew() />
							<cfset stuArtistMatches.artist.name = resultNodes[albummatches].artist.name.XmlText />
							<cfset stuArtistMatches.artist.mbid = resultNodes[albummatches].artist.mbid.XmlText />
							<cfset stuArtistMatches.artist.url = resultNodes[albummatches].artist.url.XmlText />
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="albumimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[albummatches].image[albumimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[albummatches].image[albumimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
						<cfset stuResults.topalbums = arrArtistMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topalbums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="albummatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.topalbums.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[albummatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[albummatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[albummatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[albummatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[albummatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[albummatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[albummatches].XmlAttributes.rank) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[albummatches].name.XmlText) />
							<cfif structKeyExists(resultNodes[albummatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[albummatches].image)#" index="albumimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[albummatches].image[albumimage].XmlAttributes.size, resultNodes[albummatches].image[albumimage].XmlText) />
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
	
	<cffunction name="getTopTracks" output="true" returntype="any" access="public" hint="Get the top tracks listened to by a user. You can stipulate a time period. Sends the overall chart by default. ">
		<cfargument name="user" required="yes" type="string" default="" hint="The user name" />
		<cfargument name="period" required="no" type="string" default="overall" hint="the time period over which to retrieve top artists for (overall||3month||6month||12month)" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTrackMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistURL,artistName,artistMBID,playcount,url,mbid,streamable,fulltrack,small,medium,large,extralarge') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.gettoptracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.toptracks.XmlAttributes.user />
					<cfset stuResults.type = returnedXML.lfm.toptracks.XmlAttributes.type />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset stuTrackMatches = StructNew()>
							<cfset stuTrackMatches.name = resultNodes[trackmatches].name.XmlText>
							<cfset stuTrackMatches.playcount = resultNodes[trackmatches].playcount.XmlText>
							<cfset stuTrackMatches.mbid = resultNodes[trackmatches].mbid.XmlText>
							<cfset stuTrackMatches.url = resultNodes[trackmatches].url.XmlText>
							<cfset stuTrackMatches.streamable = StructNew() />
							<cfset stuTrackMatches.streamable.streamable = resultNodes[trackmatches].streamable.XmlText>
							<cfset stuTrackMatches.streamable.fulltrack = resultNodes[trackmatches].streamable.XmlAttributes.fulltrack>
							<cfset stuTrackMatches.artist = StructNew() />
							<cfset stuTrackMatches.artist.name = resultNodes[trackmatches].artist.name.XmlText>
							<cfset stuTrackMatches.artist.mbid = resultNodes[trackmatches].artist.mbid.XmlText>
							<cfset stuTrackMatches.artist.url = resultNodes[trackmatches].artist.url.XmlText>
							<cfif structKeyExists(resultNodes[trackmatches], "image")>	
							<cfset arrTrackImage = ArrayNew(1) />
								<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="trackimage">
									<cfset stuTrackImage = StructNew()>
									<cfset stuTrackImage.url = resultNodes[trackmatches].image[trackimage].XmlText>
									<cfset stuTrackImage.size = resultNodes[trackmatches].image[trackimage].XmlAttributes.size>
									<cfset arrayAppend(arrTrackImage,stuTrackImage) />
								</cfloop>
								<cfset stuTrackMatches.image = arrTrackImage />
							</cfif>
							<cfset arrayAppend(arrTrackMatches,stuTrackMatches) />
						</cfloop>
						<cfset stuResults.toptracks = arrTrackMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'lfm/toptracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="trackmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.toptracks.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[trackmatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[trackmatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[trackmatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[trackmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[trackmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[trackmatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[trackmatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'fulltrack', resultNodes[trackmatches].streamable.XmlAttributes.fulltrack) />						
							<cfif structKeyExists(resultNodes[trackmatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[trackmatches].image)#" index="trackImage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[trackmatches].image[trackImage].XmlAttributes.size, resultNodes[trackmatches].image[trackImage].XmlText) />
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
	
	<cffunction name="getWeeklyChartList" output="true" returntype="any" access="public" hint="Get a list of available charts for this user, expressed as date ranges which can be sent to the chart services. ">
		<cfargument name="user" required="yes" type="string" default="" hint="the last.fm username to fetch the chart lists for." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrChartMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,dateFrom,dateTo') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getweeklychartlist',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.weeklychartlist.XmlAttributes.user />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklychartlist/chart')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset stuChartMatches = StructNew()>
							<cfset stuChartMatches.dateFrom = resultNodes[chartmatches].XmlAttributes.from>
							<cfset stuChartMatches.dateTo = resultNodes[chartmatches].XmlAttributes.to>
							<cfset arrayAppend(arrChartMatches,stuChartMatches) />
						</cfloop>
						<cfset stuResults.chartDates = arrChartMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklychartlist/chart')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.weeklychartlist.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'dateFrom', resultNodes[chartmatches].XmlAttributes.from) />
							<cfset temp = QuerySetCell(rstResults, 'dateTo', resultNodes[chartmatches].XmlAttributes.to) />				
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
	
	<cffunction name="getWeeklyAlbumChart" output="true" returntype="any" access="public" hint="Get an album chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent album chart for this user. ">
		<cfargument name="user" required="yes" type="string" default="" hint="the last.fm username to fetch the chart lists for." />
		<cfargument name="dateFrom" required="false" type="string" default="" hint="the date at which the chart should start from." />
		<cfargument name="dateTo" required="false" type="string" default="" hint="the date at which the chart should end on." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrChartMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistMBID,playcount,url,name,mbid,rank') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getweeklyalbumchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.weeklyalbumchart.XmlAttributes.user />
					<cfset stuResults.from = returnedXML.lfm.weeklyalbumchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklyalbumchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyalbumchart/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset stuChartMatches = StructNew()>
							<cfset stuChartMatches.rank = resultNodes[chartmatches].XmlAttributes.rank>
							<cfset stuChartMatches.artist = StructNew() />
							<cfset stuChartMatches.artist.name = resultNodes[chartmatches].artist.XmlText />
							<cfset stuChartMatches.artist.mbid = resultNodes[chartmatches].artist.XmlAttributes.mbid />
							<cfset stuChartMatches.name = resultNodes[chartmatches].name.XmlText />
							<cfset stuChartMatches.mbid = resultNodes[chartmatches].mbid.XmlText />
							<cfset stuChartMatches.playcount = resultNodes[chartmatches].playcount.XmlText />
							<cfset stuChartMatches.url = resultNodes[chartmatches].url.XmlText />
							<cfset arrayAppend(arrChartMatches,stuChartMatches) />
						</cfloop>
						<cfset stuResults.trackchart = arrChartMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyalbumchart/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.weeklyalbumchart.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[chartmatches].artist.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[chartmatches].artist.XmlAttributes.mbid) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[chartmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[chartmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[chartmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[chartmatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[chartmatches].XmlAttributes.rank) />					
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
	
	<cffunction name="getWeeklyArtistChart" output="true" returntype="any" access="public" hint="Get an artist chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent artist chart for this user. ">
		<cfargument name="user" required="yes" type="string" default="" hint="the last.fm username to fetch the chart lists for." />
		<cfargument name="dateFrom" required="false" type="string" default="" hint="the date at which the chart should start from." />
		<cfargument name="dateTo" required="false" type="string" default="" hint="the date at which the chart should end on." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrChartMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,playcount,url,name,mbid,rank') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getweeklyartistchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.weeklyartistchart.XmlAttributes.user />
					<cfset stuResults.from = returnedXML.lfm.weeklyartistchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklyartistchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyartistchart/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset stuChartMatches = StructNew()>
							<cfset stuChartMatches.rank = resultNodes[chartmatches].XmlAttributes.rank>
							<cfset stuChartMatches.name = resultNodes[chartmatches].name.XmlText />
							<cfset stuChartMatches.mbid = resultNodes[chartmatches].mbid.XmlText />
							<cfset stuChartMatches.playcount = resultNodes[chartmatches].playcount.XmlText />
							<cfset stuChartMatches.url = resultNodes[chartmatches].url.XmlText />
							<cfset arrayAppend(arrChartMatches,stuChartMatches) />
						</cfloop>
						<cfset stuResults.trackchart = arrChartMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyartistchart/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.weeklyartistchart.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[chartmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[chartmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[chartmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[chartmatches].XmlAttributes.rank) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[chartmatches].mbid.XmlText) />				
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
	
	<cffunction name="getWeeklyTrackChart" output="true" returntype="any" access="public" hint="Get a track chart for a user profile, for a given date range. If no date range is supplied, it will return the most recent track chart for this user. ">
		<cfargument name="user" required="yes" type="string" default="" hint="the last.fm username to fetch the chart lists for." />
		<cfargument name="dateFrom" required="false" type="string" default="" hint="the date at which the chart should start from." />
		<cfargument name="dateTo" required="false" type="string" default="" hint="the date at which the chart should end on." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrChartMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('user,artistName,artistMBID,playcount,url,name,mbid,rank') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('user.getweeklytrackchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.user = returnedXML.lfm.weeklytrackchart.XmlAttributes.user />
					<cfset stuResults.from = returnedXML.lfm.weeklytrackchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklytrackchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklytrackchart/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset stuChartMatches = StructNew()>
							<cfset stuChartMatches.rank = resultNodes[chartmatches].XmlAttributes.rank>
							<cfset stuChartMatches.artist = StructNew() />
							<cfset stuChartMatches.artist.name = resultNodes[chartmatches].artist.XmlText />
							<cfset stuChartMatches.artist.mbid = resultNodes[chartmatches].artist.XmlAttributes.mbid />
							<cfset stuChartMatches.name = resultNodes[chartmatches].name.XmlText />
							<cfset stuChartMatches.mbid = resultNodes[chartmatches].mbid.XmlText />
							<cfset stuChartMatches.playcount = resultNodes[chartmatches].playcount.XmlText />
							<cfset stuChartMatches.url = resultNodes[chartmatches].url.XmlText />
							<cfset arrayAppend(arrChartMatches,stuChartMatches) />
						</cfloop>
						<cfset stuResults.trackchart = arrChartMatches />
					</cfif>
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklytrackchart/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'user', returnedXML.lfm.weeklytrackchart.XmlAttributes.user) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[chartmatches].artist.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[chartmatches].artist.XmlAttributes.mbid) />
							<cfset temp = QuerySetCell(rstResults, 'playcount', resultNodes[chartmatches].playcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[chartmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[chartmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[chartmatches].XmlAttributes.rank) />					
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