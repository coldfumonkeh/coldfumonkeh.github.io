<cfoutput>	
	<cfset stuArgs = StructNew() />
	<cfset stuArgs["return"] = "query" />
	
	<cfswitch expression="#form.searchType#">
		<cfcase value="album">
			<cfset methodName = 'search' />
			<cfset stuArgs["album"] = "#form.searchValue#" />
		</cfcase>
		<cfcase value="artist">
			<cfset methodName = 'search' />
			<cfset stuArgs["artist"] = "#form.searchValue#" />
		</cfcase>
		<cfcase value="track">
			<cfset methodName = 'search' />
			<cfset stuArgs["track"] = "#form.searchValue#" />
		</cfcase>
	</cfswitch>
			
	<cfset searchResults = api.methodCall(form.searchType, methodName, stuArgs)>
	
	<cfswitch expression="#form.searchType#">
		<cfcase value="album">			
		<h1>Album Search Results</h1>
		<p>&nbsp;</p>
			<cfloop query="searchResults">
				<p>
				<a style="cursor: pointer;" title="View album information" onclick="getInfo('artist:#artist#|album:#name#','album','getInfo', 'struct' ,'rightBox1');">#name#</a> - <a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#artist#','artist','getInfo','struct','leftContent');getInfo('artist:#artist#','artist','getEvents','query','rightBox1');">#artist#</a><br /><br />
				</p>
			</cfloop>
		</cfcase>
		<cfcase value="artist">
		<h1>Artist Search Results</h1>
		<p>&nbsp;</p>
			<cfloop query="searchResults">
				<p>
				<a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#name#','artist','getInfo','struct','leftContent');getInfo('artist:#name#','artist','getEvents','query','rightBox1');getInfo('artist:#name#','artist','getTopTags','query','rightBox3');getInfo('artist:#name#','artist','getTopTracks','query','rightBox2');">#name#</a><br /><br />
				</p>
			</cfloop>
		</cfcase>
		<cfcase value="track">
		<h1>Track Search Results</h1>
		<p>&nbsp;</p>
			<cfloop query="searchResults">
				<p>
				<!---<a style="cursor: pointer;" title="View track information">#name#</a>---> #name# - <a style="cursor: pointer;" title="View artist information" onclick="getInfo('artist:#artist#','artist','getInfo','struct','leftContent');getInfo('artist:#artist#','artist','getEvents','query','rightBox1');">#artist#</a><br /><br />
				</p>
			</cfloop>
		</cfcase>
	</cfswitch>
	
	
</cfoutput>