<cfparam name="url.login" default="0" />
<cfparam name="url.token" default="0" />


<cfif url.login NEQ 0>
	<!--- <cflocation url="http://www.last.fm/api/auth/?api_key=b5277b69d7258758426fb15362498823" addtoken="no" /> --->
</cfif>
<cfif url.token NEQ 0>
	<cfset session.AuthToken = url.token />
	<cflocation url="index.cfm" addtoken="no" />
<cfelse>
	<cfif not isdefined("session.AuthToken")>
		<a href="?login=1">log in</a>		
	<cfelse>
		<cfif session.AuthToken NEQ ''>
			<cfset arg = StructNew() />
			<cfset arg["token"] = "#session.AuthToken#" />
			
			<cfset authenticatedSession = api.methodCall('auth', 'getSession', arg).session />
			<cfset session.key = authenticatedSession.key />
			
			<cfset arg = StructNew() />
			<cfset arg["sessionKey"] = "#session.key#" />
			<cfset userInfo = #api.methodCall('user','userGetInfo',arg)# />
									
			
			<cfset arg = StructNew() />
			<cfset arg["user"] = "mattgifford" />
			<cfset arg["sessionKey"] = "#session.key#" />
			
			<cfset arg["return"] = "struct" />
			
			<cfset arg["venue"] = "8782973" />
			<cfset arg["event"] = "854740" />
			<cfset arg["status"] = "0" />
			


			<cfdump var="#api.methodCall('event','getAttendees',arg)#" />
					

			
	

			
		</cfif>
	</cfif>
</cfif>