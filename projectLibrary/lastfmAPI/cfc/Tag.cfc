<!---

	Name: Tag.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="tag" hint="Component containing functions to access TAG methods within the last.fm API">

	<cffunction name="init" access="public" returntype="tag" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="getSimilar" output="true" returntype="any" access="public" hint="Search for tags similar to this one. Returns tags ranked by similarity, based on listening data. ">
		<cfargument name="tag" required="true" type="string" hint="the tag name you wish to search albums for">
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('original,url,name,streamable') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.getsimilar',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.tag = returnedXML.lfm.similartags.XmlAttributes.tag />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/similartags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuTagMatches = StructNew()>
							<cfset stuTagMatches.tag = StructNew() />
							<cfset stuTagMatches.tag.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuTagMatches.tag.streamable = resultNodes[librarymatches].streamable.XmlText>
							<cfset stuTagMatches.tag.url = resultNodes[librarymatches].url.XmlText>
							<cfset arrayAppend(arrTagMatches,stuTagMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.similarTags = arrTagMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/similartags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'original', returnedXML.lfm.similartags.XmlAttributes.tag) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[librarymatches].streamable.XmlText) />
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
	
	<cffunction name="getTopAlbums" output="true" returntype="any" access="public" hint="Get the top albums tagged by this tag, ordered by tag count. ">
		<cfargument name="tag" required="true" type="string" hint="the tag name you wish to search albums for" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artistName,artistMBID,artistURL,url,tagcount,name,mbid,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.gettopalbums',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.tag = returnedXML.lfm.topalbums.XmlAttributes.tag />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topalbums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
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
					<cfset stuResults.topalbums = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topalbums/album')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[librarymatches].artist.name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[librarymatches].artist.mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[librarymatches].artist.url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tagcount', resultNodes[librarymatches].tagcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="artistimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[artistimage].XmlAttributes.size, resultNodes[librarymatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getTopArtists" output="true" returntype="any" access="public" hint="Get the top artists tagged by this tag, ordered by tag count. ">
		<cfargument name="tag" required="yes" type="string" default="" hint="the tag name you wish to search albums for" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,tagcount,name,streamable,mbid,rank,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.gettopartists',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.tag = returnedXML.lfm.topartists.XmlAttributes.tag />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuArtistMatches.rank = resultNodes[librarymatches].XmlAttributes.rank>
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
					<cfset stuResults.topartists = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/topartists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tagcount', resultNodes[librarymatches].tagcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[librarymatches].streamable.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[librarymatches].XmlAttributes.rank) />
							<cfif structKeyExists(resultNodes[librarymatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="artistimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[artistimage].XmlAttributes.size, resultNodes[librarymatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getTopTags" output="true" returntype="any" access="public" hint="Fetches the top global tags on Last.fm, sorted by popularity (number of times used)">
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = '' />
			<cfset var returnedXML = '' />
			<cfset var resultNodes = '' />
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,name,count') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.gettoptags',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults) />			
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code />
				<cfset stuResults.message = returnedXML.lfm.error.XmlText />
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptags/tag') />
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew() />
							<cfset stuArtistMatches.tag = StructNew() />
							<cfset stuArtistMatches.tag.name = resultNodes[librarymatches].name.XmlText />
							<cfset stuArtistMatches.tag.count = resultNodes[librarymatches].count.XmlText />
							<cfset stuArtistMatches.tag.url = resultNodes[librarymatches].url.XmlText />
							<cfset arrayAppend(arrArtistMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.topTags = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptags/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'count', resultNodes[librarymatches].count.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />					
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
	
	<cffunction name="getTopTracks" output="true" returntype="any" access="public" hint="Get the top tracks tagged by this tag, ordered by tag count. ">
		<cfargument name="tag" required="yes" type="string" default="" hint="the tag name you wish to search tracks for" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('artistURL,artistName,artistMBID,url,tagcount,name,streamable,fulltrack,mbid,rank,small,medium,large') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.gettoptracks',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.tag = returnedXML.lfm.toptracks.XmlAttributes.tag />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[librarymatches].name.XmlText>
							<cfset stuArtistMatches.rank = resultNodes[librarymatches].XmlAttributes.rank>
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
					<cfset stuResults.topTracks = arrArtistMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/toptracks/track')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="librarymatches">
							<cfset temp = QueryAddRow(rstResults) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[librarymatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'tagcount', resultNodes[librarymatches].tagcount.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[librarymatches].name.XmlText) />	
							<cfset temp = QuerySetCell(rstResults, 'artistURL', resultNodes[librarymatches].artist.url.XmlText) />	
							<cfset temp = QuerySetCell(rstResults, 'artistName', resultNodes[librarymatches].artist.name.XmlText) />	
							<cfset temp = QuerySetCell(rstResults, 'artistMBID', resultNodes[librarymatches].artist.mbid.XmlText) />	
							<cfset temp = QuerySetCell(rstResults, 'streamable', resultNodes[librarymatches].streamable.XmlText) />	
							<cfset temp = QuerySetCell(rstResults, 'fulltrack', resultNodes[librarymatches].streamable.XmlAttributes.fulltrack) />	
							<cfset temp = QuerySetCell(rstResults, 'mbid', resultNodes[librarymatches].mbid.XmlText) />	
							<cfset temp = QuerySetCell(rstResults, 'rank', resultNodes[librarymatches].XmlAttributes.rank) />	
							<cfif structKeyExists(resultNodes[librarymatches], "image")>						
							<cfloop from="1" to="#arrayLen(resultNodes[librarymatches].image)#" index="artistimage">
									<cfset temp = QuerySetCell(rstResults, resultNodes[librarymatches].image[artistimage].XmlAttributes.size, resultNodes[librarymatches].image[artistimage].XmlText) />
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
	
	<cffunction name="getWeeklyArtistChart" output="true" returntype="any" access="public" hint="Get an artist chart for a tag, for a given date range. If no date range is supplied, it will return the most recent artist chart for this tag.">
		<cfargument name="tag" required="yes" type="string" default="" hint="The tag name in question" />
		<cfargument name="from" required="no" type="string" default="" hint="The date at which the chart should start from" />
		<cfargument name="to" required="no" type="string" default="" hint="The date at which the chart should end on" />
		<cfargument name="limit" required="no" type="string" default="50" hint="The number of chart items to return." />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('tag,weight,url,name,mbid') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.getweeklyartistchart',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">
					<cfset stuResults.tag = returnedXML.lfm.weeklyartistchart.XmlAttributes.tag />
					<cfset stuResults.from = returnedXML.lfm.weeklyartistchart.XmlAttributes.from />
					<cfset stuResults.to = returnedXML.lfm.weeklyartistchart.XmlAttributes.to />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklyartistchart/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[groupmatches].name.XmlText />
							<cfset stuArtistMatches.mbid = resultNodes[groupmatches].mbid.XmlText />
							<cfset stuArtistMatches.weight = resultNodes[groupmatches].weight.XmlText>
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
							<cfset temp = QuerySetCell(rstResults, 'tag', returnedXML.lfm.weeklyartistchart.XmlAttributes.tag) />
							<cfset temp = QuerySetCell(rstResults, 'weight', resultNodes[chartmatches].weight.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[chartmatches].url.XmlText) />
							<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[chartmatches].name.XmlText) />
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
	
	<cffunction name="getWeeklyChartList" output="true" returntype="any" access="public" hint="Get a list of available charts for this tag, expressed as date ranges which can be sent to the chart services. ">
		<cfargument name="tag" required="yes" type="string" default="" hint="The tag name in question" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('tag,to,from') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.getweeklychartlist',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfswitch expression="#arguments.return#">
				<cfcase value="struct">	
					<cfset stuResults.tag = returnedXML.lfm.weeklychartlist.XmlAttributes.tag />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklychartlist/chart')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.from = resultNodes[tagmatches].XmlAttributes.from />
							<cfset stuArtistMatches.to = resultNodes[tagmatches].XmlAttributes.to />								
							<cfset arrayAppend(arrGroupMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
						<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/weeklychartlist/chart')>
						<cfif arraylen(resultNodes) GT 0>
							<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">				
								<cfset temp = QueryAddRow(rstResults) />
								<cfset temp = QuerySetCell(rstResults, 'tag', returnedXML.lfm.weeklychartlist.XmlAttributes.tag) />
								<cfset temp = QuerySetCell(rstResults, 'to', resultNodes[tagmatches].XmlAttributes.to) />
								<cfset temp = QuerySetCell(rstResults, 'from', resultNodes[tagmatches].XmlAttributes.from) />	
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
	
	<cffunction name="search" output="true" returntype="any" access="public" hint="Search for a tag by name. Returns matches sorted by relevance. ">
		<cfargument name="tag" required="yes" type="string" hint="The tag name in question" />
		<cfargument name="page" required="no" type="numeric" default="1" hint="Scan into the results by specifying a page number. Defaults to first page." />
		<cfargument name="limit" required="no" type="numeric" default="30" hint="Limit the number of tags returned at one time. Default (maximum) is 30" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct', 'query' or 'xml'." />
			<cfset var arrTagMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset var rstResults = QueryNew('url,name,count') />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tag.search',arguments) />
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
					<cfset stuResults.startPage = returnedXML.lfm.results.query.XmlAttributes.startPage />
					<cfset stuResults.role = returnedXML.lfm.results.query.XmlAttributes.role />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/tagmatches/tag')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">
							<cfset stuTagMatches = StructNew()>
							<cfset stuTagMatches.tag = StructNew() />
							<cfset stuTagMatches.tag.name = resultNodes[tagmatches].name.XmlText>
							<cfset stuTagMatches.tag.count = resultNodes[tagmatches].count.XmlText>
							<cfset stuTagMatches.tag.url = resultNodes[tagmatches].url.XmlText>					
							<cfset arrayAppend(arrTagMatches,stuTagMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrTagMatches />
					<cfset returnVar = stuResults>
				</cfcase>
				<cfcase value="query">
						<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/results/tagmatches/tag')>
						<cfif arraylen(resultNodes) GT 0>
							<cfloop from="1" to="#arraylen(resultNodes)#" index="tagmatches">				
								<cfset temp = QueryAddRow(rstResults) />
								<cfset temp = QuerySetCell(rstResults, 'url', resultNodes[tagmatches].url.XmlText) />
								<cfset temp = QuerySetCell(rstResults, 'count', resultNodes[tagmatches].count.XmlText) />
								<cfset temp = QuerySetCell(rstResults, 'name', resultNodes[tagmatches].name.XmlText) />	
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