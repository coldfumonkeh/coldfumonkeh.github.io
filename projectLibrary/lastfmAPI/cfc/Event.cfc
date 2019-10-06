<!---

	Name: Event.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="event" hint="Component containing functions to access EVENT methods within the last.fm API">

	<cffunction name="init" access="public" returntype="event" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="attend" output="true" returntype="any" access="public" hint="Set a user's attendance status for an event. ">
		<cfargument name="event" required="yes" type="string" default="" hint="The numeric last.fm event id" />
		<cfargument name="status" required="yes" type="string" default="" hint="The attendance status (0=Attending, 1=Maybe attending, 2=Not attending)" />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />
			<cfset args = StructNew() />
			<cfset args['event'] = arguments.event />
			<cfset args['status'] = arguments.status />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('event.attend', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
	<cffunction name="getAttendees" output="true" returntype="any" access="public" hint="Get a list of attendees for an event. ">
		<cfargument name="event" required="yes" type="string" default="" hint="The numeric last.fm event id" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrFriendMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('event,url,name,realname,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('event.getAttendees',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/attendees/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="friendmatches">
							<cfset stuFriendMatches = StructNew()>
							<cfset stuFriendMatches.name = resultNodes[friendmatches].name.XmlText>
							<cfset stuFriendMatches.realname = resultNodes[friendmatches].realname.XmlText>
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
					<cfset stuResults.friends = arrFriendMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/attendees/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="friendmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[friendmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[friendmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'realName', resultNodes[friendmatches].realname.XmlText) />
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
	
	<cffunction name="getInfo" output="true" returntype="any" access="public" hint="Get the metadata for an event on Last.fm. Includes attendance and lineup information. ">
		<cfargument name="event" required="no" type="string" default="" hint="The numeric last.fm event id" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrEventMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('event.getInfo',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>	
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/event')>
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
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getShouts" output="true" returntype="any" access="public" hint="Get shouts for this event. Also available as an rss feed. ">
		<cfargument name="event" required="yes" type="string" default="" hint="The numeric last.fm event id" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrShoutMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('event,body,date,author') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('event.getshouts',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.event = returnedXML.lfm.shouts.XmlAttributes.event />
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
							<cfset temp = QuerySetCell(rstResults, 'event', returnedXML.lfm.shouts.XmlAttributes.event) />
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
	
	<cffunction name="share" output="true" returntype="any" access="public" hint="Share an event with one or more Last.fm users or other friends.">
		<cfargument name="event" required="yes" type="string" default="" hint="The numeric last.fm event id" />
		<cfargument name="recipient" required="yes" type="string" default="" hint="Email Address | Last.fm Username - A comma delimited list of email addresses or Last.fm usernames. Maximum is 10" />
		<cfargument name="message" required="false" type="string" default="" hint="An optional message to send with the recommendation. If not supplied a default message will be used." />
		<cfargument name="sessionKey" required="yes" type="string" default="the session key obtained from the authentication" />		
			<cfset args = StructNew() />
			<cfset args['artist'] = arguments.artist />
			<cfset args['track'] = arguments.track />
			<cfset args['recipient'] = arguments.recipient />
			<cfset args['message'] = arguments.message />
			<cfset authCall = xmlParse(variables.stuInstance.utility.callAuthenticatedMethod('event.share', args, arguments.sessionKey, 'xml')) />
		<cfreturn authCall />
	</cffunction>
	
</cfcomponent>