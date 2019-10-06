<!---

	Name: Group.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="group" hint="Component containing functions to access GROUP methods within the last.fm API">

	<cffunction name="init" access="public" returntype="group" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="getMembers" output="true" returntype="any" access="public" hint="Get a list of members for this group. ">
		<cfargument name="group" required="yes" type="string" default="" hint="The group name to fetch the members of." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,name,realname,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('group.getmembers',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfset stuResults.group = returnedXML.lfm.members.XmlAttributes.for />
			<cfset stuResults.page = returnedXML.lfm.members.XmlAttributes.page />
			<cfset stuResults.perpage = returnedXML.lfm.members.XmlAttributes.perpage />
			<cfset stuResults.totalpages = returnedXML.lfm.members.XmlAttributes.totalpages />
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/members/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuMemberMatches = StructNew()>
							<cfset stuMemberMatches.name = resultNodes[groupmatches].name.XmlText>
							<cfset stuMemberMatches.realname = resultNodes[groupmatches].realname.XmlText>
							<cfset stuMemberMatches.url = resultNodes[groupmatches].url.XmlText />					
							<cfset arrUserImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[groupmatches].image)#" index="memberimage">
								<cfset stuUserImage = StructNew()>
								<cfset stuUserImage.url = resultNodes[groupmatches].image[memberimage].XmlText>
								<cfset stuUserImage.size = resultNodes[groupmatches].image[memberimage].XmlAttributes.size>
								<cfset arrayAppend(arrUserImage,stuUserImage) />
							</cfloop>
							<cfset stuMemberMatches.image = arrUserImage />					
							<cfset arrayAppend(arrGroupMatches,stuMemberMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/members/user')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'realname', resultNodes[groupmatches].realname.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[groupmatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[groupmatches].url.XmlText) />
							<cfloop from="1" to="#arrayLen(resultNodes[groupmatches].image)#" index="memberimage">
								<cfset temp = QuerySetCell(rstResults, resultNodes[groupmatches].image[memberimage].XmlAttributes.size, resultNodes[groupmatches].image[memberimage].XmlText) />
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
	
	<cffunction name="getWeeklyAlbumChart" output="true" returntype="any" access="public" hint="Get an album chart for a group, for a given date range. If no date range is supplied, it will return the most recent album chart for this group. ">
		<cfargument name="group" required="yes" type="string" default="" hint="The last.fm group name to fetch the charts of." />
		<cfargument name="from" required="no" type="string" default="" hint="The date at which the chart should start from. See Group.getWeeklyChartList for more" />
		<cfargument name="to" required="no" type="string" default="" hint="The date at which the chart should end on. See Group.getWeeklyChartList for more." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('group,artistName,artistMBID,playcount,url,name,mbid,rank') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('group.getweeklyalbumchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">		
					<cfset stuResults.group = returnedXML.lfm.weeklyalbumchart.XmlAttributes.group />
					<cfset stuResults.from = returnedXML.lfm.weeklyalbumchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklyalbumchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyalbumchart/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuAlbumMatches = StructNew()>
							<cfset stuAlbumMatches.artist = StructNew() />
							<cfset stuAlbumMatches.artist.name = resultNodes[groupmatches].artist.XmlText />
							<cfset stuAlbumMatches.artist.mbid = resultNodes[groupmatches].artist.XmlAttributes.mbid />
							<cfset stuAlbumMatches.name = resultNodes[groupmatches].name.XmlText>
							<cfset stuAlbumMatches.mbid = resultNodes[groupmatches].mbid.XmlText>
							<cfset stuAlbumMatches.playcount = resultNodes[groupmatches].playcount.XmlText>
							<cfset stuAlbumMatches.rank = resultNodes[groupmatches].XmlAttributes.rank>
							<cfset stuAlbumMatches.url = resultNodes[groupmatches].url.XmlText />									
							<cfset arrayAppend(arrGroupMatches,stuAlbumMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyalbumchart/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'group', returnedXML.lfm.weeklyalbumchart.XmlAttributes.group) />
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
					<cfset returnVar = returnedXML>
				</cfcase>
				</cfswitch>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getWeeklyArtistChart" output="true" returntype="any" access="public" hint="Get an artist chart for a group, for a given date range. If no date range is supplied, it will return the most recent album chart for this group. ">
		<cfargument name="group" required="yes" type="string" default="" hint="The last.fm group name to fetch the charts of." />
		<cfargument name="from" required="no" type="string" default="" hint="The date at which the chart should start from. See Group.getWeeklyChartList for more." />
		<cfargument name="to" required="no" type="string" default="" hint="The date at which the chart should end on. See Group.getWeeklyChartList for more." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('group,playcount,url,name,mbid,rank') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('group.getweeklyartistchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.group = returnedXML.lfm.weeklyartistchart.XmlAttributes.group />
					<cfset stuResults.from = returnedXML.lfm.weeklyartistchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklyartistchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyartistchart/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[groupmatches].name.XmlText />
							<cfset stuArtistMatches.mbid = resultNodes[groupmatches].mbid.XmlText />
							<cfset stuArtistMatches.playcount = resultNodes[groupmatches].playcount.XmlText>
							<cfset stuArtistMatches.rank = resultNodes[groupmatches].XmlAttributes.rank>
							<cfset stuArtistMatches.url = resultNodes[groupmatches].url.XmlText />									
							<cfset arrayAppend(arrGroupMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyartistchart/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'group', returnedXML.lfm.weeklyartistchart.XmlAttributes.group) />
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
	
	<cffunction name="getWeeklyChartList" output="true" returntype="any" access="public" hint="Get a list of available charts for this group, expressed as date ranges which can be sent to the chart services. ">
		<cfargument name="group" required="yes" type="string" default="" hint="The last.fm group name to fetch the charts list for." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('group,dateFrom,dateTo') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('group.getweeklychartlist',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.group = returnedXML.lfm.weeklychartlist.XmlAttributes.group />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklychartlist/chart')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.from = resultNodes[groupmatches].XmlAttributes.from />
							<cfset stuArtistMatches.to = resultNodes[groupmatches].XmlAttributes.to />								
							<cfset arrayAppend(arrGroupMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklychartlist/chart')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'group', returnedXML.lfm.weeklychartlist.XmlAttributes.group) />
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
	
	<cffunction name="getWeeklyTrackChart" output="true" returntype="any" access="public" hint="Get a track chart for a group, for a given date range. If no date range is supplied, it will return the most recent album chart for this group. ">
		<cfargument name="group" required="yes" type="string" default="" hint="The last.fm group name to fetch the charts of." />
		<cfargument name="from" required="no" type="string" default="" hint="The date at which the chart should start from. See Group.getWeeklyChartList for more" />
		<cfargument name="to" required="no" type="string" default="" hint="The date at which the chart should end on. See Group.getWeeklyChartList for more." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('group,artistName,artistMBID,playcount,url,name,mbid,rank') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('group.getweeklytrackchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset stuResults.group = returnedXML.lfm.weeklytrackchart.XmlAttributes.group />
					<cfset stuResults.from = returnedXML.lfm.weeklytrackchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklytrackchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklytrackchart/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.rank = resultNodes[groupmatches].XmlAttributes.rank />
							<cfset stuArtistMatches.artist = StructNew() />
							<cfset stuArtistMatches.artist.name = resultNodes[groupmatches].artist.XmlText />
							<cfset stuArtistMatches.artist.mbid = resultNodes[groupmatches].artist.XmlAttributes.mbid />
							<cfset stuArtistMatches.name = resultNodes[groupmatches].name.XmlText />
							<cfset stuArtistMatches.mbid = resultNodes[groupmatches].mbid.XmlText />
							<cfset stuArtistMatches.playcount = resultNodes[groupmatches].playcount.XmlText />
							<cfset stuArtistMatches.url = resultNodes[groupmatches].url.XmlText />						
							<cfset arrUserImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[groupmatches].image)#" index="memberimage">
								<cfset stuUserImage = StructNew()>
								<cfset stuUserImage.url = resultNodes[groupmatches].image[memberimage].XmlText>
								<cfset stuUserImage.size = resultNodes[groupmatches].image[memberimage].XmlAttributes.size>
								<cfset arrayAppend(arrUserImage,stuUserImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrUserImage />						
							<cfset arrayAppend(arrGroupMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">				
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklytrackchart/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="chartmatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'group', returnedXML.lfm.weeklytrackchart.XmlAttributes.group) />
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