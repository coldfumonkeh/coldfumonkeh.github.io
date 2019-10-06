<!---

	Name: Utility.cfc
	Purpose: for use with the last.fm API, called through API.cfc
	Author: Matt Gifford (http://www.mattgifford.co.uk/)
	Date: February 2009
	Version: 1.0
		
--->

<cfcomponent name="utility" hint="A CFC to handle generic functions within the last.fm API">

	<cffunction name="init" access="public" returntype="utility" output="false" hint="I am the constructor method.">
		<cfargument name="apikey" required="true" type="string" />
		<cfargument name="SecretKey" required="true" type="string" />
		<cfargument name="rootURL" required="true" type="string" />
			<!--- holds all private instance data --->
			<cfset variables.stuInstance = StructNew() />
			<cfset variables.stuInstance.APIKey = arguments.apikey />
			<cfset variables.stuInstance.SecretKey = arguments.secretkey />
			<cfset variables.stuInstance.rootURL = arguments.rootURL />
		<cfreturn this /> 
	</cffunction>
		
	<cffunction name="xmlStrip" access="public" returntype="xml" output="true" hint="I help with stripping out tags and tidying up the returned XML">
		<cfargument name="xmlIn" required="true" type="xml" hint="the XML retrieved from the CFHTTP request" />
			<cfset var originalXML = arguments.xmlIn />
			<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both opening and closing tags. --->
			<cfset xmlOut = originalXML.ReplaceAll("(</?)(\w+:)","$1") />
			<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
			<cfset xmlOut = xmlOut.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />
		<cfreturn xmlOut />
	</cffunction>
	
	<cffunction name="callAPIMethod" access="public" returntype="Xml" output="true" hint="I make the call to the API to retrieve the data, and reorder the arguments fr the URL string">
		<cfargument name="methodName" type="string" required="true" hint="I am the name of the method you wish to seach within the API" />
		<cfargument name="methodParams" type="struct" required="true" hint="the arguments to send to the cfhttp API call" />				
			<cfset stuArgCopy = StructCopy(methodParams) />
			<!---<cfset temp = StructDelete(stuArgCopy, "return") />--->
			<cfset stuArgCopy.api_key = variables.stuInstance.APIKey />			
			<cfset arrArgs = StructKeyArray(stuArgCopy) />
			<cfset temp = ArraySort(arrArgs, 'TextNoCase') />		
			<cfset strRemoteCall = '#variables.stuInstance.rootURL#?method=#arguments.methodName#' />
			<cfloop from="1" to="#arrayLen(arrArgs)#" index="i">
				<cfset strRemoteCall = strRemoteCall & '&#lcase(arrArgs[i])#=#lcase(stuArgCopy[arrArgs[i]])#' />	
			</cfloop>
			<cfhttp url="#strRemoteCall#" result="callResult" />			
		<cfreturn callResult.filecontent />
	</cffunction>

	<cffunction name="callAuthenticatedMethod" access="public" returntype="any" output="false" hint="I make the call to the API to retrieve data that needs authentication">
		<cfargument name="methodName" type="string" required="true" hint="I am the name of the method you wish to seach within the API" />
		<cfargument name="args" type="struct" required="false" default="#StructNew()#" hint="I am a structure of arguments required for the method call" />
		<cfargument name="sessionKey" type="string" required="false" hint="We need to use this method to GET our session key. All other uses of the method require a session key">
		<cfargument name="format" type="string" required="false" default="json">
			<cfset arguments.args['api_sig'] = authenticationHashString(argumentCollection=arguments) />
		<cfreturn callMethod(arguments.methodName, arguments.args, 'post', arguments.format) />
	</cffunction>
	
	<cffunction name="authenticationHashString" access="public" returntype="string" output="false" hint="I create the MD5 / Hash string for authentication">
		<cfargument name="methodName" type="string" required="true" />
		<cfargument name="args" type="struct" required="false" default="#StructNew()#" />
		<cfargument name="sessionKey" type="string" required="false" hint="We need to use this method to GET our session key. All other uses of the method require a session key">
			<cfscript>
				var argArray = "";
				var str = "";
				var i = 0;
				arguments.args['api_key'] = variables.stuInstance.APIKey;
				arguments.args['method'] = arguments.methodName;
				if(StructKeyExists(arguments, 'sessionKey')){
					arguments.args['sk'] = arguments.sessionKey;
				}
				argArray = StructKeyArray(args);
				ArraySort(argArray,'TextNoCase');
				for(i=1; i LTE ArrayLen(argArray); i=i+1){
					str = str & argArray[i] & args[argArray[i]];
				}
				return LCase(Hash( str & variables.stuInstance.SecretKey ));
			</cfscript>
	</cffunction>
	
	<cffunction name="callMethod" access="private" returntype="any" output="false" hint="I call a method within the API. I run the get and write/post requests">
		<cfargument name="methodName" type="string" required="true" hint="I am the name of the method you wish to seach within the API" />
		<cfargument name="args" type="struct" required="false" default="#StructNew()#" hint="I am a structure of arguments required for the method call" />
		<cfargument name="method" type="string" required="false" default="get" hint="I am the method of return to be used. 'GET' or 'POST'" />
			<cfset var result = "" />
			<cfset var arg = "" />
			<cfhttp url="#variables.stuInstance.rootURL#" method="#arguments.method#" charset="utf-8" result="result">
				<cfhttpparam type="url" name="method" value="#arguments.methodName#" />
				<cfhttpparam type="url" name="api_key" value="#variables.stuInstance.APIKey#" />
				<cfloop collection="#arguments.args#" item="arg">
					<cfhttpparam  type="url" name="#arg#" value="#arguments.args[arg]#" />
				</cfloop>
			</cfhttp>
		<cfreturn result.filecontent />
	</cffunction>
				
</cfcomponent>