---
layout: post
title: Work With Remote API JSON Data in ColdFusion 10 Queries
slug: work-with-remote-api-json-data-in-coldfusion-10-queries
categories:
- ColdFusion
tags:
- API
- ColdFusion
- ColdFusion 10
status: publish
type: post
published: true
date: 2012-06-29
---
<p>Yesterday I <a title="Initializing A New Query With Data in ColdFusion 10" href="http://www.mattgifford.co.uk/initializing-a-new-query-with-data-in-coldfusion-10">blogged</a> about the language enhancements in ColdFusion 10 and the <a title="http://helpx.adobe.com/coldfusion/release-note/coldfusion-9-0-update-2.html" href="http://helpx.adobe.com/coldfusion/release-note/coldfusion-9-0-update-2.html" target="_blank">ColdFusion 9.0.2 update</a> that allow you <a title="Initializing A New Query With Data in ColdFusion 10" href="http://www.mattgifford.co.uk/initializing-a-new-query-with-data-in-coldfusion-10">populate a new query during initialization</a>.</p>
<p>This got me to thinking about how much easier this can make querying and filtering data from a remote API request.</p>
<h2>In Action</h2>
<p>In this simple example we'll make a request to the Twitter search API to return the last ten results for our search criteria, 'ColdFusion'.</p>
<p>As we're receiving JSON from the response, we can easily deserialize it into a format that we can then pass directly into the <code>queryNew()</code> method.</p>
<p><img title="The JSON response is perfectly suited to pass directly in to the queryNew method" alt="The JSON response is perfectly suited to pass directly in to the queryNew method" src="/assets/uploads/2012/06/json_response.png" /></p>
<p>We instantly have an array of structures to send in to our query.</p>
<h3>Saving The Data As A Query</h3>
<p>Let's jump straight to the code:</p>

```
<!--- Make the request to the API --->
<cfhttp
  url="http://search.twitter.com/search.json?q=coldfusion&rpp=10"
	method="get"
	result="jsonTweets" />

<!--- Convert JSON to array of structs --->
<cfset jsonData = deserializeJSON(jsonTweets.fileContent) />

<!--- Check we have records returned to us --->
<cfif arrayLen(jsonData.results)>
	<!--- We want to provide the query with column names --->
	<cfset strColType		=	'' />
	<!--- To do this, we'll take the first result item... --->
	<cfset stuFirstTweet 	= 	jsonData.results[1] />
	<!--- and get the list of keys from the structure. --->
	<cfset thisKeyList 		= 	structKeyList(stuFirstTweet) />
	<!---
		We now need to provide the column data type.
		This example assumes everything is a VarChar.
		Looping over the list of keys, we'll append a
		datatype to the column type list defined earlier.
	--->
	<cfloop list="thisKeyList" index="listItem">
		<cfset listAppend(strColType,'varChar') />
	</cfloop>

	<!---
		Generate the new query, passing in the  
		column list, column type list and the data.
	--->
	<cfset qryTweets = queryNew(
							thisKeyList,
							strColType,
							jsonData.results
						) />

</cfif>
```

<p>Assuming that we have records returned in the API request, we should now have a query object populated with the results directly from the remote call:</p>
<p><img title="ColdFusion 10 populating a new query with data directly from a remote API request" alt="ColdFusion 10 populating a new query with data directly from a remote API request" src="/assets/uploads/2012/06/initial_query_populated.png" /></p>
<h3>A Small But Important Caveat</h3>
<p>We need to provide the column names for the <code>queryNew()</code> method. As you can see in the code sample above, we took the first result in the response and set the structure key names in to a list to serve this purpose.</p>
<p>For the majority of instances, depending on what API you call, this would probably suffice as the structure of the results wouldn't change.</p>
<p>The Twitter API, however, will amend the result structure if a particular tweet is a reply by adding in some additional parameters. If these are encountered, the values of the query will not match up with the column names. Something to consider.</p>
<h3>Filtering</h3>
<p>Now that we have this data, we can easily run a query of queries to further filter the results, or to manipulate them however we wish to:</p>

```
<cfquery dbtype="query" name="qryFilter">
  SELECT *
	FROM qryTweets
	WHERE from_user_id =
        <cfqueryparam cfsqltype="cf_sql_numeric" value="6499262" />
</cfquery>
```

<p><img title="Filtering the populated query to refine results" alt="Filtering the populated query to refine results" src="/assets/uploads/2012/06/filtered_query.png" /></p>
<p>ColdFusion already makes working with a JSON response easy. Having the ability to now convert data like this into a query is incredibly cool and helps to make it even easier!</p>
