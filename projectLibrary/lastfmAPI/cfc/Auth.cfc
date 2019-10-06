<!---

	Name: Auth.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="auth" hint="Component containing functions to access AUTHENTICATION methods within the last.fm API">

	<cffunction name="init" access="public" returntype="auth" output="false" hint="I am the constructor method.">
		<cfargument name="apikey" required="true" type="string" />
		<cfargument name="SecretKey" required="true" type="string" />
		<cfargument name="rootURL" required="true" type="string" />
		<cfargument name="authURL" required="true" type="string" />
			<!--- holds all private instance data --->
			<cfset variables.stuInstance = StructNew() />
			<cfset variables.stuInstance.APIKey = arguments.apikey />
			<cfset variables.stuInstance.SecretKey = arguments.secretkey />
			<cfset variables.stuInstance.rootURL = arguments.rootURL />
			<cfset variables.stuInstance.authURL = arguments.authURL />
			<cfset variables.stuInstance.utility = createObject("component", "utility").init(arguments.apikey,arguments.secretkey,arguments.rootURL) />
		<cfreturn this /> 
	</cffunction>
	
	<cffunction name="getAuthToken" output="false" access="public" hint="used to transfer the user to the last.fm site to log in and approve this API for access">
		<cflocation url="#variables.stuInstance.authURL#?api_key=#variables.stuInstance.APIKey#" addtoken="false" />
	</cffunction>
	
	<cffunction name="getSession" output="true" returntype="any" access="public" hint="Fetch a session key for a user. The third step in the authentication process. See the authentication how-to for more information. ">
		<cfargument name="token" required="true" type="string" hint="A 32-character ASCII hexadecimal MD5 hash returned by step 1 of the authentication process (following the granting of permissions to the application by the user)" />
		<cfargument name="return" required="no" type="string" default="struct" hint="can accept either 'struct' or 'xml'." />	
			<cfscript>
				var stuResults = StructNew();
				charEncoding = "utf-8";
				apikeydecode=CharsetDecode(variables.stuInstance.APIKey, charEncoding);
				apikeyencode=CharsetEncode(apikeydecode, charEncoding);
				tokendecode=CharsetDecode(arguments.token, charEncoding);
				tokenencode=CharsetEncode(tokendecode, charEncoding);
				secrkeydecode=CharsetDecode(variables.stuInstance.SecretKey, charEncoding);
				secrkeyencode=CharsetEncode(secrkeydecode, charEncoding);
				hashParam = LCase(Hash("api_key#apikeyencode#methodauth.getsessiontoken#tokenencode##secrkeyencode#"));
		    </cfscript>					    			
			<cfset methodURL = "#variables.stuInstance.rootURL#?method=auth.getsession" />
			<cfset methodURL = methodURL & '&api_key=#variables.stuInstance.APIKey#&token=#tokenencode#&api_sig=#hashParam#' />
			<cfhttp url="#methodURL#" />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(cfhttp.filecontent) />
			<cfset returnedXML = XmlParse(searchResults)>
			<cfif arrayLen(xmlSearch(returnedXML, 'lfm/error')) GT 0>
				<cfset stuResults.errorCode = returnedXML.lfm.error.XmlAttributes.code>
				<cfset stuResults.message = returnedXML.lfm.error.XmlText>
				<cfset returnVar = stuResults />
			<cfelse>
				<cfif arguments.return EQ 'struct'>
					<cfset stuResults.session = StructNew() />
					<cfset stuResults.session.name = returnedXML.lfm.session.name.XmlText />
					<cfset stuResults.session.key = returnedXML.lfm.session.key.XmlText />
					<cfset stuResults.session.subscriber = returnedXML.lfm.session.subscriber.XmlText />
					<cfset stuResults.session.api_sig = hashParam />
					<cfset returnVar = stuResults>
				<cfelse>
					<cfset returnVar = returnedXML>
				</cfif>
			</cfif>
		<cfreturn returnVar />
	</cffunction>
	
	<cffunction name="getWebSession" output="true" returntype="any" access="public" hint="Used by our flash embeds (on trusted domains) to use a site session cookie to seed a ws session without requiring a password. Uses the site cookie so must be accessed over a .last.fm domain. ">
			<cfset var arrArtistMatches = ArrayNew(1) />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultNodes = ''>
			<cfset var stuResults = StructNew() />
			<cfset methodURL = "#variables.stuInstance.rootURL#?method=auth.getwebsession" />
			<cfset methodURL = methodURL & '&api_key=#variables.stuInstance.APIKey#' />
			<cfset methodURL = methodURL & '&api_sig=#variables.stuInstance.secretkey#' />
			<cfhttp url="#methodURL#" />
			<cfset searchResults = variables.stuInstance.utility.xmlStrip(cfhttp.filecontent) />
			<cfset returnedXML = XmlParse(searchResults)>
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
		<cfreturn stuResults />
	</cffunction>
		
</cfcomponent>