<!---

	Name: Taste.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="taste" hint="Component containing functions to access TASTE methods within the last.fm API">

	<cffunction name="init" access="public" returntype="taste" output="false" hint="I am the constructor method.">
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
	
	<cffunction name="compareTaste" output="true" returntype="any" access="public" hint="Get a Tasteometer score from two inputs, along with a list of shared artists. If the input is a User or a Myspace URL, some additional information is returned. ">
		<cfargument name="type1" required="yes" type="string" default="" hint="user' | 'artists' | 'myspace" />
		<cfargument name="type2" required="yes" type="string" default="" hint="user' | 'artists' | 'myspace" />
		<cfargument name="value1" required="yes" type="string" default="" hint="[Last.fm username] | [Comma-separated artist names] | [MySpace profile URL]" />
		<cfargument name="value2" required="yes" type="string" default="" hint="[Last.fm username] | [Comma-separated artist names] | [MySpace profile URL]" />
		<cfargument name="limit" required="no" type="string" default="" hint="How many shared artists to display" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />
			<cfset var arrGroupMatches = ArrayNew(1) />
			<cfset var arrUserMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset remoteResult = variables.stuInstance.utility.callAPIMethod('tasteometer.compare',arguments) />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(remoteResult) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>	
					<cfset stuResults.score = returnedXML.lfm.comparison.result.score.XmlText />
					<cfset resultNodes = xmlSearch(#searchResults#,'/lfm/comparison/result/artists/artist')>
					<cfif arraylen(resultNodes) GT 0>
						<cfloop from="1" to="#arraylen(resultNodes)#" index="groupmatches">
							<cfset stuArtistMatches = StructNew()>
							<cfset stuArtistMatches.name = resultNodes[groupmatches].name.XmlText>
							<cfset stuArtistMatches.url = resultNodes[groupmatches].url.XmlText />				
							<cfset arrArtistImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(resultNodes[groupmatches].image)#" index="artistimage">
								<cfset stuArtistImage = StructNew()>
								<cfset stuArtistImage.url = resultNodes[groupmatches].image[artistimage].XmlText>
								<cfset stuArtistImage.size = resultNodes[groupmatches].image[artistimage].XmlAttributes.size>
								<cfset arrayAppend(arrArtistImage,stuArtistImage) />
							</cfloop>
							<cfset stuArtistMatches.image = arrArtistImage />				
							<cfset arrayAppend(arrGroupMatches,stuArtistMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.results = arrGroupMatches />
					<cfset userResultNodes = xmlSearch(#searchResults#,'/lfm/comparison/input/user')>
					<cfif arraylen(userResultNodes) GT 0>
						<cfloop from="1" to="#arraylen(userResultNodes)#" index="usermatches">
							<cfset stuUserMatches = StructNew()>
							<cfset stuUserMatches.name = userResultNodes[usermatches].name.XmlText>
							<cfset stuUserMatches.url = userResultNodes[usermatches].url.XmlText />	
							
							<cfset arrUserImage = ArrayNew(1) />
							<cfloop from="1" to="#arrayLen(userResultNodes[usermatches].image)#" index="userimage">
								<cfset stuUserImage = StructNew()>
								<cfset stuUserImage.url = userResultNodes[usermatches].image[userimage].XmlText>
								<cfset stuUserImage.size = userResultNodes[usermatches].image[userimage].XmlAttributes.size>
								<cfset arrayAppend(arrUserImage,stuUserImage) />
							</cfloop>
							<cfset stuUserMatches.image = arrUserImage />												
							<cfset arrayAppend(arrUserMatches,stuUserMatches) />
						</cfloop>
					</cfif>
					<cfset stuResults.users = arrUserMatches />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
</cfcomponent>