<cfapplication name="lastCFC" sessionmanagement="true" sessiontimeout="#CreateTimeSpan(0,0,30,0)#" />

<cfset api = createObject("component", "cfc.api").init('b5277b69d7258758426fb15362498823','ac60410c27d71c323d58c980d56c36f9') />

<cfparam name="url.login" default="0" />
<cfparam name="url.token" default="0" />

<cfif url.token NEQ 0>
	<cfset session.AuthToken = url.token />
</cfif>


<cfif url.login NEQ 0>
	<!--- <cflocation url="http://www.last.fm/api/auth/?api_key=b5277b69d7258758426fb15362498823" addtoken="no" /> --->
	<cfscript>
		api.methodCall('auth','getAuthToken');
	</cfscript>
</cfif>

<cfif structKeyExists(url, "clear")>
	<cfset structClear(session) />
</cfif>

<cfif structKeyExists(session, "token") AND session.token NEQ ''>
	<a href="?clear=1">log out</a>
</cfif>

<cfif structKeyExists(session, "AuthToken") AND session.AuthToken NEQ ''>
	<cfset arg = StructNew() />
	<cfset arg["token"] = "#session.AuthToken#" />
	
	<cfset authenticatedSession = api.methodCall('auth', 'getSession', arg).session />
	<cfset session.key = authenticatedSession.key />
	
	<cfset arg = StructNew() />
	<cfset arg["sessionKey"] = "#session.key#" />
	<cfset userInfo = #api.methodCall('user','getInfo',arg)# />
	<cfset session.userInfo = #userInfo# />
</cfif>