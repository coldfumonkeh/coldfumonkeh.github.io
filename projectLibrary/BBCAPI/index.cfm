<cfparam name="url.channelID" default="" />
<cfparam name="url.programmeID" default="" />
<cfparam name="url.genreID" default="" />
<cfparam name="url.groupID" default="" />

<h1>(What is on) BBC CFC</h1>
<div class="descr"></div>

<p>For those who want to keep up to date with what shows are going to be on across the BBC tv and radio networks, this is a ColdFusion CFC wrapper to allow developers to interact with the BBC Web API service.</p>

<h2>Download the complete CFC</h2>

<p>The CFC has been released, and is available to download from the RIA Forge project page: <a href="http://whatisonbbc.riaforge.org/" target="_blank">http://whatisonbbc.riaforge.org/</a></p>
<p><a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/" target="_blank"><img alt="Creative Commons License" style="border-width:0" src="http://i.creativecommons.org/l/by-nc-sa/3.0/88x31.png" /></a><br />This work is licenced under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/3.0/" target="_blank">Creative Commons Licence</a>.</p>

<p>Please feel free to add comments, bugs, issues, and general good tidings on the <a href="http://www.mattgifford.co.uk/what-is-on-bbc-cfc/">blog post</a>.</p>

<h2>Have a play around with it</h2>

<cfset channObj = createObject("component", "BBCAPI").init() />
<cfoutput>
	
<cfif url.groupID NEQ ''>
	<cfset grpMembers = channObj.groupMembersList('#url.groupID#') />
	<p>Programmes within the group:</p>
	<cfloop from="1" to="#arrayLen(grpMembers)#" index="grp">
		<a href="?programmeID=#grpMembers[grp].programmeID#">#grpMembers[grp].name#</a><br />
	</cfloop>
</cfif>

<cfif url.genreID NEQ ''>
	<cfset genMembers = channObj.getGenreMembers('#url.genreID#') />
	<p>Programmes within the genre:</p>
	<cfloop from="1" to="#arrayLen(genMembers)#" index="gen">
		<a href="?programmeID=#genMembers[gen].programmeID#">#genMembers[gen].title#</a><br />
	</cfloop>
</cfif>

<cfif url.programmeID NEQ ''>
	<cfset progInfo = channObj.getProgrammeInfo('#url.programmeID#') />	
	<cfif structKeyExists(progInfo, "events")>
	Available to view at the following times:<br /><br />
	<cfloop from="1" to="#arrayLen(progInfo.events)#" index="events">
		<cfif events EQ 1>
		<a href="?channelID=#progInfo.events[events].channelID#">
		<img src="#progInfo.events[events].channelInfo.logos[1].url#" border="0" width="63" height="26" /></a><br /><br />
		</cfif>
		#TimeFormat(Mid(progInfo.events[events].Start, 12, 5), "HH:MM")# #DateFormat(Left(progInfo.events[events].Start, 10), "dd/mm/yyyy")#<br />		
		<br />
	</cfloop>
	
	<strong>#progInfo.name#</strong><br />
	#progInfo.synopsis#<br /><br />
	
	<cfif arrayLen(progInfo.group) GT 0>
	Group:<br />
	<cfloop from="1" to="#arrayLen(progInfo.group)#" index="grp">
		<a href="?groupID=#progInfo.group[grp].groupID#">#progInfo.group[grp].name#</a>
	</cfloop>
	
	<br /><br />
	</cfif>
	
	<cfif arrayLen(progInfo.genre) GT 0>
	Genre:<br />
	<cfloop from="1" to="#arrayLen(progInfo.genre)#" index="gen">
		<a href="?genreID=#progInfo.genre[gen].genreID#">#UCase(progInfo.genre[gen].name)#</a>&nbsp;
	</cfloop>
	<br /><br />
	</cfif>
	</cfif>
</cfif>

<cfif url.channelID NEQ ''>
	<cfset progSched = channObj.getProgrammeSchedule('#url.channelID#') />
	<cfif arrayLen(progSched.schedule) GT 0>
	<img src="#progSched.channelInfo.logos[1].url#" /><br /><br />
	<cfloop from="1" to="#arrayLen(progSched.schedule)#" index="sched">
		<a href="?programmeID=#progSched.schedule[sched].progID#">#progSched.schedule[sched].Name#</a><br />
		<strong>Date:</strong> #TimeFormat(Mid(progSched.schedule[sched].Start, 12, 5), "HH:MM")# #DateFormat(Left(progSched.schedule[sched].Start, 10), "dd/mm/yyyy")#<br />
		<strong>Duration:</strong> #progSched.schedule[sched].duration#<br /><br />
	</cfloop>
	</cfif>
</cfif>


<cfset channelList = channObj.channelList() />
<cfset tdCount = 0 />
<table>
<tr>
<cfloop from="1" to="#arrayLen(channelList)#" index="chanID">
	<td>
	<a href="?channelID=#channelList[chanID].channelID#">
	<img src="#channelList[chanID].information.logos[1].url#" border="0" style="margin: 2px; border: 1px solid ##000000;" /></a>
	</td>
	<cfset tdCount = tdCount+1 />
	<cfif tdCount EQ 5>
	</tr>
	<tr>
		<cfset tdCount = 0 />
	</cfif>
</cfloop>
</tr>
</table>
</cfoutput>



<h1>Methods Included:</h1>

<ul>
	<li><b>channelList</b>: returns the list of TV and RADIO channels available through the API</li>
	<li><b>getChannelInfo</b>: returns information on a specific channel</li>
	<li><b>getGenreList</b>: returns a list of all available genres</li>
	<li><b>getGenreMembers</b>: returns all members of a specific genre</li>
	<li><b>getGroupInfo</b>: returns information for a specific group</li>
	<li><b>getGroupList</b>: returns a list of all groups available within the API</li>
	<li><b>getProgrammeInfo</b>: returns information for a specific programme</li>
	<li><b>getProgrammeSchedule</b>: returns the schedule for a specific channel</li>
	<li><b>groupMembersList</b>: returns members of a specific group</li>
</ul>