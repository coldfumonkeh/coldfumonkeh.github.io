---
layout: post
title: Formatting Twitter Dates in ColdFusion
slug: formatting-twitter-dates-in-coldfusion
categories:
- ColdFusion
tags:
- ColdFusion
- monkehTweets
- twitter
status: publish
type: post
published: true
date: 2012-12-21
---
<p>A few days ago Adam Tuttle posted a question regarding the formatting of dates returned from the Twitter API. Putting it bluntly, Twitter has screwed around with the date / time string, making it rather difficult to parse using conventional methods. During some research, other languages are also suffering from issues trying to parse the string into something useable.</p>
<p>Consider this example from a response:</p>

```
Wed Aug 29 17:12:58 +0000 2012
```

<p>Whilst ColdFusion's parseDateTime function used to work with the response strings returned from the API, it no longer does. If we pass in the string to the function, we get a date that is missing eleven years and ten hours:</p>

```
{ts '2001-08-29 07:12:58'}
```

<p>This prompted a few ideas bounced between Adam and I, and some rather interested method names in the process (of which I won't repeat here..)</p>
<p>In the end, I came up with the following function to parse and format the date into something useable:</p>

```
<cffunction name="parseTwitterDateFormat" output="false" returntype="String" hint="I return the date in a useable date format.">
  <cfargument name="twitterDate" required="true" type="string" hint="The Twitter date." />
    <cfset var formatter = CreateObject("java", "java.text.SimpleDateFormat").init("EEE MMM d kk:mm:ss Z yyyy") />
      <cfset formatter.setLenient(true) />
	<cfreturn formatter.parse(arguments.twitterDate) />
</cffunction>
```

<p>This uses the SimpleDateFormat Java class, passing through the date pattern, and returning a parsed java.util.Date object.</p>
<p>This returns the following:</p>

```
{ts '2012-08-29 18:12:58'}
```

<p>The only caveat with this approach is that the SimpleDateFormat class has converted the time to my local timezone. However, it is now manageable with ColdFusion.</p>
<p>For any <a title="monkehTweets on GitHub" href="https://github.com/coldfumonkeh/monkehTweets" target="_blank">monkehTweets</a> users out there, I have added the <strong>parseTwitterDateFormat()</strong> method to the base.cfc in the latest push to the repository. If you need to use this function but dont want to download a new build, simply add the function above to your base.cfc file.</p>
