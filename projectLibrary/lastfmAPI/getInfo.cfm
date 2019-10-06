<cfoutput>

	<cfset stuArgs = StructNew() />
			
	<cfloop list="#form.name#" index="mainData" delimiters="|">
		<cfset stuArgs["#ListGetAt(mainData,1,':')#"] = "#ListGetAt(mainData,2,':')#" />
	</cfloop>

	<cfset stuArgs["return"] = "#form.format#" />
		
	<cfset info = #api.methodCall(form.class, form.method, stuArgs)# />
				
	<cfswitch expression="#form.method#">
	<cfcase value="getInfo">
		<cfswitch expression="#form.class#">
		<cfcase value="artist">
			<h1>Artist Information</h1>
			<p>&nbsp;</p>
			<p><img src="#info.results[1].image[2].url#" 
					align="left" alt="#info.results[1].name#" title="#info.results[1].name#" style="margin-right: 10px; margin-bottom: 10px;" /> 
					<strong>#info.results[1].name#</strong></p>
			
			<p>#info.results[1].bio.content#</p>
		</cfcase>
		<cfcase value="track">
			<p><strong>Track Information</strong></p>
			<p>&nbsp;</p>
			<p><strong>#info.results[1].name#</strong> by <strong>#info.results[1].artist.name#</strong></p>
			<h2>Stats</h2>
			<p>#info.results[1].stats.listeners# listeners<br />
			#info.results[1].stats.playcount# playcount
			</p>
		</cfcase>
		<cfcase value="album">
			<p><strong>Album Information</strong></p>
			<p>&nbsp;</p>
			<p>
			<table>
			<tr>
				<td><img src="#info.results[1].image[2].url#" 
					align="left" alt="#info.results[1].name#" title="#info.results[1].name#" /></td>
			</tr>
			<tr>
				<td><strong>#info.results[1].name#</strong> by <strong>#info.results[1].artist#</strong></td>
			</tr>
			</table>
			<h2>Stats</h2>
			<p>#info.results[1].stats.listeners# listeners<br />
			#info.results[1].stats.playcount# playcount
			</p>
		</cfcase>
		<cfcase value="event">
			<h1>Event Details</h1>
			<p>&nbsp;</p>
			<p><img src="#info.results[1].image[2].url#" 
				align="left" alt="#info.results[1].title#" title="#info.results[1].title#" style="margin-right: 10px; margin-bottom: 10px;" /> 
				<strong>#info.results[1].title#</strong></p>
			
			<p><strong>Headliner:</strong> #info.results[1].headliner#</p>
			<p>All artists:
			<ul>
				<cfloop from="1" to="#arrayLen(info.results[1].artists)#" index="artists">
				<li><a style="cursor: pointer;" onclick="getInfo('artist:#info.results[1].artists[artists].artist#','artist','getInfo','struct','leftContent');getInfo('artist:#info.results[1].artists[artists].artist#','artist','getEvents','query','rightBox1');">#info.results[1].artists[artists].artist#</a></li>
				</cfloop>
			</ul>
			</p>
			<p>&nbsp;</p>
			<p><strong>Location:</strong><br />
			#info.results[1].venue.name#<br />
			#info.results[1].venue.location.street#<br />
			#info.results[1].venue.location.city#<br />
			#info.results[1].venue.location.country#<br />
			#info.results[1].venue.location.postalcode#
			</p>
		</cfcase>
		</cfswitch>
	</cfcase>
	</cfswitch>
	
	<cfswitch expression="#form.method#">
		<cfcase value="getEvents">
		<cfif info.recordcount GT 0>
			<p><strong>Events</strong></p>
			<cfif info.recordcount GT 3>
				<cfset totalEvents = 3>
			<cfelse>
				<cfset totalEvents = info.recordcount>
			</cfif>
			<cfloop from="1" to="#totalEvents#" index="events">
				<p><img src="#info.image[events].url#" alt="Image" title="Image" class="image" /><b>#info.title[events]#</b><br />
				#info.venue[events].name#, #info.venue[events].location.city#, #info.venue[events].location.country#.</p>
				<p><a style="cursor: pointer;" onclick="getInfo('event:#info.ID[events]#','event','getInfo','struct','leftContent');">View details</a></p>
			</cfloop>
		<cfelse>
			<p>There are no events listed for this artist</p>
		</cfif>
		</cfcase>
		<cfcase value="getTopTags">
			<cfif info.recordcount GT 0>
				<p><strong>Top Tags</strong></p>
				<cfloop query="info">
				#name#&nbsp;
				</cfloop>
			</cfif>
		</cfcase>
		<cfcase value="getTopTracks">
			<cfif info.recordcount GT 0>
				<p><strong>Top Tracks</strong></p>
				<cfloop query="info">
				#name# (#playcount# plays)<br />
				</cfloop>
			</cfif>
		</cfcase>
	</cfswitch>
	
</cfoutput>