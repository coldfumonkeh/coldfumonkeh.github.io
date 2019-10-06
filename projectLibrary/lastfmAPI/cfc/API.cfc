<!---

	Name: API.cfc
	Purpose: for use with the last.fm API, the main component used to access other methods and classes
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="api" hint="the main CFC for interaction with the last.fm API">

	<cffunction name="init" access="public" returntype="api" output="false" hint="I am the constructor method.">
		<cfargument name="apikey" required="true" type="string" />
		<cfargument name="SecretKey" required="true" type="string" />
			<!--- holds all private instance data --->
			<cfset variables.stuInstance = StructNew() />
			<cfset variables.stuInstance.APIKey = arguments.apikey />
			<cfset variables.stuInstance.SecretKey = arguments.secretkey />
			<cfset variables.stuInstance.rootURL = 'http://ws.audioscrobbler.com/2.0/' />
			<cfset variables.stuInstance.authURL = 'http://www.last.fm/api/auth/' />
			<cfset variables.stuInstance.album = createObject("component", "album").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.artist = createObject("component", "artist").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.auth = createObject("component", "auth").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL,variables.stuInstance.authURL) />
			<cfset variables.stuInstance.event = createObject("component", "event").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.geo = createObject("component", "geo").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.group = createObject("component", "group").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.library = createObject("component", "library").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.playlist = createObject("component", "playlist").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.tag = createObject("component", "tag").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.taste = createObject("component", "taste").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.track = createObject("component", "track").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.user = createObject("component", "user").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
			<cfset variables.stuInstance.venue = createObject("component", "venue").init(arguments.apikey,arguments.secretkey,variables.stuInstance.rootURL) />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="methodCall" access="public" returntype="any" output="true" hint="I am the main calling method to access the API.">
		<cfargument name="className" required="true" type="string" hint="the name of the method class to call" />
		<cfargument name="methodName" required="true" type="string" hint="the name of the method function to call" />
		<cfargument name="params" required="false" type="struct" default="#structNew()#" hint="the arguments to be used within the method. send within the argumentcollection as a structure." />						
			<cfif structKeyExists(variables.stuInstance, arguments.className)>
				<cfif structKeyExists(variables.stuInstance[arguments.className], arguments.methodName)>
					<cfinvoke component="#variables.stuInstance[arguments.className]#" method="#arguments.methodName#" argumentCollection="#arguments.params#" returnVariable="methodReturn" />
				<cfelse>
					<cfset methodReturn = StructNew() />
					<cfset methodReturn.message = 'That method name does not exist within the component. Please check the documentation for available method names.' />
				</cfif>
			<cfelse>
				<cfset methodReturn = StructNew() />
				<cfset methodReturn.message = 'That class name does not exist. Please check the documentation for available component names.' />
			</cfif>
		<cfreturn methodReturn />
	</cffunction>
					
</cfcomponent>