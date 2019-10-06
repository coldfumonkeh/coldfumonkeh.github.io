---
layout: post
title: monkehTweets update - now supports Twitter API v1.1
slug: monkehtweets-update-now-supports-twitter-api-v1-1
categories:
- ColdFusion
tags:
- API
- CFC
- ColdFusion
- twitter
status: publish
type: post
published: true
date: 2012-10-30
---
<p>Last week I committed quite a substantial update to the monkehTweets library on <a title="monkehTweets project on Github" href="https://github.com/coldfumonkeh/monkehTweets" target="_blank">Github</a> (also available via <a title="monkehtweet.riaforge.org" href="http://monkehtweet.riaforge.org" target="_blank">riaforge.org</a>).</p>
<p>For those who don't know, Twitter have been working to update their API in the first big update since it's launch, and v1.1 is the result of their work.</p>
<h2>How Long Do I Have Left?</h2>
<p>For all developers and applications currently using the previous versions of monkehTweets (and Twitter API v1 as a result) you have a rather generous amount of time to update your code and make the transition to the new API. Version 1 will be closed off and no longer available from the start of March 5th, 2013. (source: <a title="Deprecation of the Twitter API v1" href="https://dev.twitter.com/docs/api/1.1/overview#Deprecation_of_v1.0_of_the_API" target="_blank">https://dev.twitter.com/docs/api/1.1/overview#Deprecation_of_v1.0_of_the_API</a>)</p>
<p>The pre-v1.1 implementation of monkehTweets is still available via Github in it's own branch, which is available here should you need it: <a title="monkehTweets 1.3.2_v1.1 branch on Github" href="https://github.com/coldfumonkeh/monkehTweets/tree/1.3.2_v1.1/" target="_blank">https://github.com/coldfumonkeh/monkehTweets/tree/1.3.2_v1.1/</a></p>
<h2>Changes</h2>
<p>There have been a number of changes to the API, including revised endpoints to reflect the new API version number (1.1), but most of these should fall under the radar of users and implementors of the monkehTweets library as it will manage these for you.</p>
<p>The biggest changes to the API update are as follows:</p>
<ul>
<li>All calls to the API require authentication (oauth)</li>
<li>All requests and responses will be in JSON format</li>
</ul>
<p>It is important to note at this stage that the instantiation and use of monkehTweets itself has not changed. It was developed to be easy to use and to open up the detailed API for all CFML developers without having to instantiate Java classes. This has not changed and you can still get up and running in seconds. The example code in the project download will help you get your application set up and posting tweets very quickly.</p>
<h2>How has monkehTweets dealt with these changes?</h2>
<p>The authentication process was easy to manage. For the small number of methods that were making un-authenticated method calls, these were amended to run through the function dealing with the OAuth authentication. From a user point of view, this will have little to no impact on your existing code. As the application / user needs to be authenticated and those details are stored in the monkehTweets object, this will be handled invisibly for you.</p>
<p>The formatting was a little more detailed to change. All of the methods in monkehTweets used to have an argument called 'format' which used to default to XML. This allowed users to select the response format of the data to process in their preferred manner. The format arguments have now been stripped from all method calls, and the remote URL endpoints for each method have been forced to use JSON. If you are using XML responses you WILL need to amend your code to handle the new return format.</p>
<h2>Method Changes</h2>
<p>The following functions have been removed from monkehTweets as they were no longer supported in the v1.1 API:</p>
<ul>
<li>addNotification</li>
<li>blockExists</li>
<li>endSession</li>
<li>friendshipExists</li>
<li>getAccountTotals</li>
<li>getDailyTrends</li>
<li>getLists</li>
<li>getNoRetweetIDs</li>
<li>getPublicTimeline</li>
<li>getRetweetedToUser</li>
<li>getRetweetsByMe</li>
<li>getRetweetsByUser</li>
<li>getRetweetsOfMe</li>
<li>getRetweetsToMe</li>
<li>getUserProfileImage</li>
<li>getWeeklyTrends</li>
<li>oauthRateLimitStatus</li>
<li>rateLimitStatus</li>
<li>removeNotification</li>
<li>retweetedBy</li>
<li>retweetedByIDs</li>
<li>test</li>
</ul>
<p>If your application uses any of the above methods, you will need to revise the code to remove them and amend any functionality that depends on them.</p>
<p>The following functions have been added to monkehTweets as new additions in the v1.1 API:</p>
<ul>
<li>closestTrends</li>
<li>getApplicationRateLimitStatus</li>
</ul>
<p>All other methods remain active and current. Any changes made to existing methods in the monkehTweets library have been done as quietly as possible so as not to impact the code and therefore the implementation of the code. Method names have not been changed where possible to make the transition easier for you to manage.</p>
<h2>Error Handling</h2>
<p>One of the biggest issues I had with the ever-evolving Twitter API and method parameters was managing the error handling, certainly when trying to accomodate for a number of response formats.</p>
<p>In the previous version of the package, the requested format was passed through to the sub-methods along with the response to correctly format the data and attempt to check for any error codes before returning to the user. The Twitter API error processing changed and the code was unstable, certainly when dealing with XML responses.</p>
<p>Whilst my original intention was to trap any errors and return a user-friendly error message back to the user / developer, in the latest release I have completely dropped this functionality. This was done primarily for two reasons:</p>
<ol>
<li>It was unstable due to numerous changes from Twitter and I feared that if they changed their error handling again it would cause more errors.</li>
<li>Having just one response format now made this easier. JSON will be returned regardless of whether the request was a success or failure.</li>
</ol>
<p>This now means that users and developers will need to catch any errors from the API themselves. To help with this, Twitter have a fairly detailed list of error response codes to watch out for: <a title="View the Twitter API documentation covering the error response codes" href="https://dev.twitter.com/docs/error-codes-responses" target="_blank">https://dev.twitter.com/docs/error-codes-responses</a></p>
<p>The example used on the site shows the error response in JSON format, and is a clear indication of what to watch out for:</p>

```
{"errors":[{"message":"Sorry, that page does not exist","code":34}]}
```

<h2>More Information</h2>
<p>For more information and clarification on the official changes to the Twitter API introduced in v1.1, please check out the API overview on the official documentation page: <a title="View the Twitter API v1.1 documentation page" href="https://dev.twitter.com/docs/api/1.1/overview" target="_blank">https://dev.twitter.com/docs/api/1.1/overview</a></p>
<h2>Use monkehTweets?</h2>
<p>Do you use monkehTweets? Has it saved you time, money, pain and stress? Let me know. I always look forward to seeing how people are using it in their applications.</p>
<p>If it really helped you, feel free to <a title="Matt Gifford's Amazon wishlist" href="http://www.amazon.co.uk/registry/wishlist/B9PFNDZNH4PY" target="_blank">visit my Amazon wishlist</a> and say thanks :)</p>
<p>&nbsp;</p>
