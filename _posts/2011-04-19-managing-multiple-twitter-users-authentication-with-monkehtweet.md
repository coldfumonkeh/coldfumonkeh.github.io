---
layout: post
title: Managing multiple Twitter users authentication with monkehTweet
slug: managing-multiple-twitter-users-authentication-with-monkehtweet
categories:
- ColdFusion
- Screencasts
tags:
- ColdFusion
- Tutorial
- twitter
status: publish
type: post
published: true
date: 2011-04-19
---
<p>One of the questions I get asked frequently in regards to the monkehTweet ColdFusion Twitter wrapper is the ability to manage multiple users and their access to Twitter.</p>
<p>In this post, I've written a sample application to emulate a user-based system. Once a user has logged in, the application can access this user's Twitter details and send a post to their stream, updating their status.</p>
<p>Check out the video using the above link (or directly on <a title="View this video on YouTube" href="http://www.youtube.com/watch?v=DdOlbnx1PkE" target="_blank">YouTube</a>) to see it in action. Full code with clear comments is included below, and you can download the entire sample application to enjoy and adapt as you wish to suit your needs.</p>
<h3>Multiple User Demo</h3>
<p>When dealing with Twitter OAuth calls (especially accessing the restricted data requiring authentication), the user's token and token secret are required to form the base request and the signature required to cryptographically sign the request.</p>
<p>monkehTweet requires the consumer application's token and secret values to be sent through in the <strong>init()</strong> constructor method as the consumer application MUST have these in place to connect to the service provider (in this case Twitter) to be recognised.</p>
<p>However, to communicate on behalf of a specific user, monkehTweet needs to have the user's token and secret value, which are obtained after successful authentication from the user. These values are required to successfully form the authenticated header, base string and signature needed to send to Twitter in the request.</p>
<p>The main function to note in the example and code is the use of <strong>setFinalAccessDetails()</strong> method within the monkehTweet component. This function will set the OAuth token, OAuth secret and user account name, assuming you have already obtained them from a method of prior authentication.</p>
<p><strong>login.cfm</strong></p>
<pre lang="cfm" line="1" escaped="true">&lt;!---
Name: login.cfm
Author: Matt Gifford AKA coldfumonkeh
		(http://www.mattgifford.co.uk)
Date: 28.01.2011
Copyright 2011 Matt Gifford AKA coldfumonkeh.
		All rights reserved.
---&gt;

&lt;cfif structKeyExists (form,'loginBtn')&gt;
	&lt;cfquery name="rstUserLogin"
			 datasource="#application.datasource#"&gt;
		SELECT
			ID,
			username,
			password
		FROM
			tblUsers
		WHERE
			username = &lt;cfqueryparam
				    cfsqltype="cf_sql_varchar"
				    value="#form.username#" /&gt;

		AND password = &lt;cfqueryparam
				    cfsqltype="cf_sql_varchar"
				    value="#form.password#" /&gt;
	&lt;/cfquery&gt;

	&lt;cfif rstUserLogin.recordcount&gt;
		&lt;!---
			Query found a user, so let's set the
			session values and store the user's previously
			saved twitter authentication details.
		---&gt;
		&lt;cfset session['isLoggedIn'] 	= true /&gt;
		&lt;cfset session['userID']	= rstUserLogin.ID /&gt;

		&lt;!---
			Relocate the user back to the index main page.
		---&gt;
		&lt;cflocation url="index.cfm" addtoken="false" /&gt;
	&lt;/cfif&gt;

&lt;/cfif&gt;

&lt;form name="loginForm" method="post"&gt;

	&lt;label 	for="username"&gt;Username: &lt;/label&gt;
	&lt;input 	type="text"
		name="username"
		id="username" /&gt;&lt;br /&gt;

	&lt;label 	for="password"&gt;Password: &lt;/label&gt;
	&lt;input 	type="password"
		name="password"
		id="password" /&gt;&lt;br /&gt;

	&lt;input 	type="submit"
		name="loginBtn"
		value="Log in" /&gt;

&lt;/form&gt;</pre>
<p>&nbsp;</p>
<p>The login form is purely to access our internal application and to authenticate the user against our own database using non-Twitter account details. If the user exists, their <strong>userID</strong> value is set in the <strong>SESSION</strong> scope (required for a database query in the next screen) and they are transferred to the index.cfm page to proceed.</p>
<p><strong>index.cfm</strong></p>
<pre lang="cfm" line="1" escaped="true">&lt;!---
Name: index.cfm
Author: Matt Gifford AKA coldfumonkeh
		(http://www.mattgifford.co.uk)
Date: 28.01.2011
Copyright 2011 Matt Gifford AKA coldfumonkeh.
			All rights reserved.
---&gt;

&lt;cfoutput&gt;
&lt;!---
	Only proceed if the user has successfully
	logged in to our site.
---&gt;
&lt;cfif session.isLoggedIn&gt;
	&lt;!---
		Use the stored userID after login to
		check if this user has previously authenticated
		with us and we have their twitter details.
	---&gt;
	&lt;cfif structKeyExists (session,'userID')&gt;

		&lt;cfquery name="rstTweetDetails"
				 datasource="#application.datasource#"&gt;
			SELECT
				ID,
				userID,
				accessToken,
				accessSecret,
				screen_name,
				twitter_userID
			FROM
				tblTweetAccess
			WHERE
				userID = &lt;cfqueryparam
                                	cfsqltype="cf_sql_numeric"
					value="#session.userID#" /&gt;
		&lt;/cfquery&gt;

		&lt;cfif rstTweetDetails.recordcount&gt;
			&lt;!---
				Sweet! It looks as though we have this user's
				authentication access details from a previous visit.
				They don't need to authenticate through Twitter anymore.

				Store their access details into the session scope.
			---&gt;
			&lt;cfscript&gt;
				session['accessToken']	=
					rstTweetDetails.accessToken;
				session['accessSecret']	=
					rstTweetDetails.accessSecret;
				session['screen_name']	=
					rstTweetDetails.screen_name;
				WriteOutput('&lt;p&gt;You have already
				authenticated with Twitter.&lt;/p&gt;');
            &lt;/cfscript&gt;

			&lt;!---
				Output something to the user
				so that they can proceed.
			---&gt;
			&lt;a href="post.cfm"&gt;Send a post using monkehTweets
				and see the CFC in action&lt;/a&gt;

		&lt;cfelse&gt;
			&lt;!---
				They have logged in, but have not authenticated
				through Twitter. We need to send them through
				the OAuth validation process.

				Firstly we need to have the user grant access
				to our application. We do this (using OAuth)
				through the getAuthorisation() method.

				The callbackURL is optional. If not sent through,
				Twitter will use the callback URL it has
				stored for your application.
			---&gt;
			&lt;cfset authStruct =
			application.objMonkehTweet.getAuthorisation(
				callbackURL='http://[yourdomain]/authorize.cfm'
			) /&gt;

			&lt;cfif authStruct.success&gt;
				&lt;!---
					Here, the returned information is being
					set into the session scope.
					You could also store these into a DB
					(if running an application for multiple users).
				---&gt;
				&lt;cfset session['oAuthToken']
					= authStruct.token /&gt;
				&lt;cfset session['oAuthTokenSecret']
					= authStruct.token_secret /&gt;
			&lt;/cfif&gt;

			&lt;!---
				Now, we need to relocate the user to
				Twitter to perform the authorisation for us.
			---&gt;
			&lt;p&gt;To continue, please authenticate with Twitter.&lt;/p&gt;
			&lt;a href="#authStruct.authURL#"&gt;
                                Authenticate to proceed&lt;/a&gt;

		&lt;/cfif&gt;

	&lt;/cfif&gt;

&lt;/cfif&gt;

&lt;/cfoutput&gt;</pre>
<p>Once the user has logged in, we can then use the stored <strong>userID</strong> from the <strong>SESSION</strong> scope to query against the tblTweetAccess table to see if they have already authenticated with Twitter and we have their token details.</p>
<p>If we do have these details, we set the access token, access secret and their Twitter screen name into the session scope, as they will be used in the post.cfm page to set the authentication details using the <strong>setFinalAccessDetails()</strong> method.</p>
<p>If we do not have these details, the user needs to be sent to Twitter to start the authentication process. They will be transferred to authorize.cfm after they have actioned the authentication (hopefully approving our application and allowing us access to their Twitter stream).</p>
<p>A successful authentication will send an oauth_verifier parameter in the <strong>URL</strong> query string.</p>
<p><strong>authorize.cfm</strong></p>
<pre lang="cfm" line="1" escaped="true">&lt;!---
Name: authorize.cfm
Author: Matt Gifford AKA coldfumonkeh
		(http://www.mattgifford.co.uk)
Date: 28.01.2011
Copyright 2011 Matt Gifford AKA coldfumonkeh.
		All rights reserved.
---&gt;

&lt;!--- Proceed if the user has approved the application. ---&gt;
&lt;cfif structKeyExists(URL, 'oauth_verifier')&gt;

&lt;cfscript&gt;
	returnData	= application.objMonkehTweet.getAccessToken(  
			requestToken	= 	session.oAuthToken,
			requestSecret	= 	session.oAuthTokenSecret,
			verifier	=	url.oauth_verifier
				);

if (returnData.success) {
	/*
		Save these off to your database against
		your user so you can access their
		account in the future.
	*/
	session['accessToken']	= returnData.token;
	session['accessSecret']	= returnData.token_secret;
	session['screen_name']	= returnData.screen_name;
	session['user_id']	= returnData.user_id;

	/*
		Insert the details for this user into
		the database so that we can store the
		token details for next time.
	*/
	queryService = new query();
	queryService.setDatasource(application.datasource);
	queryService.setName("insertAuthentication");
	queryService.addParam(	name="userID",
					value="#session['userID']#",
					cfsqltype="NUMERIC");

	queryService.addParam(	name="accessToken",
					value="#returnData.token#",
					cfsqltype="VARCHAR");

	queryService.addParam(	name="accessSecret",
					value="#returnData.token_secret#",
					cfsqltype="VARCHAR");

	queryService.addParam(	name="screen_name",
					value="#returnData.screen_name#",
					cfsqltype="VARCHAR");

	queryService.addParam(	name="twitter_userID",
					value="#returnData.user_id#",
					cfsqltype="NUMERIC");

	queryService.setSQL(
	"INSERT INTO
	tblTweetAccess
		(
			userID,
			accessToken,
			accessSecret,
			screen_name,
			twitter_userID
		) VALUES (
			:userID,
			:accessToken,
			:accessSecret,
			:screen_name,
			:twitter_userID
		)"
	);

	result = queryService.execute();

	writeDump(returnData);

}
&lt;/cfscript&gt;

&lt;a href="post.cfm"&gt;Send a post using monkehTweets
	and see the CFC in action&lt;/a&gt;

&lt;cfelse&gt;

	&lt;p&gt;You denied access for the application.&lt;/p&gt;

&lt;/cfif&gt;</pre>
<p>Following a successful authentication, the user is sent back to authorize.cfm, and we are able to use monkehTweet to obtain the user's access token, secret and screen name values, which are again stored into the <strong>SESSION</strong> scope for use in the action page (post.cfm).</p>
<p>As we now have the user's access tokens, we dont need to send them to Twitter to authenticate every time we wish to access their account on their behalf. This means we can store their details in the database for future use, using the <strong>userID</strong> stored in the session scope to create the reference to our specific user record.</p>
<p><strong>post.cfm</strong></p>
<pre lang="cfm" line="1" escaped="true">&lt;!---
Name: post.cfm
Author: Matt Gifford AKA coldfumonkeh
		(http://www.mattgifford.co.uk)
Date: 28.01.2011
Copyright 2011 Matt Gifford AKA coldfumonkeh.
		All rights reserved.
---&gt;
&lt;cfscript&gt;
	/*
		We also need to set the values into the
		authentication class inside monkehTweets
	*/
	application.objMonkehTweet.setFinalAccessDetails(
			oauthToken		= 	session['accessToken'],
			oauthTokenSecret	=	session['accessSecret'],
			userAccountName		=	session['screen_name']
	);

	/*
		Let's make a test call to update the
		status of the authenticated user.
		If you are using this for a number of users,
		you will need to set the details prior to each call
		using the setFinalAccessDetails() method above.
	*/

	/*
		If you are using this purely for a single user,
		you can set all of the authentication details in
		the init() constructor method when instantiating the application
	*/
	returnData = application.objMonkehTweet.postUpdate(
		"I'm using the awesome ##monkehTweets
		ColdFusion library from @coldfumonkeh!"
	);
&lt;/cfscript&gt;
&lt;cfdump var="#returnData#"
	label="Returned data from the twitter request" /&gt;</pre>
<p>&nbsp;</p>
<p>In the final action page, we obtain the OAuth access token details from the <strong>SESSION</strong> scope. Of course, you could revise this code to run a query to look up the details within the database for the logged in user instead of storing them in a scope. The choice is yours.</p>
<p>Here, we send the details into the <strong>setFinalAccessDetails()</strong> method to set them into monkehTweet and to create the correct authentication headers to manage this user's account on their behalf.</p>
<h4>Code Caveat</h4>
<p>The code in this example contains a bizarre mix of script and tag-based coding, all forming a fully-functioning but bizarre cocktail of ColdFusion awesomeness. Don't question it, just go with the flow. It was more of a case that I was playing around with different techniques and options. For example, I dont often use the new Query() method for data transactions, so I took the chance to implement it here just to try something 'different'.</p>
<p>Variety, much like black pepper, is the spice of life.</p>
<h2>Download the code</h2>
<p>There you go; a very simple example using monkehTweet to handle multiple user accounts within an application, and storing access details for your users.</p>
<p>The full code, including .sql file to build a dummy database is included in the <a title="Download the monkehTweet Multiple User Demo code" href="http://www.monkehworks.com/downloads/demo_code/monkehTweet_MultipleUser_demo.zip">attached .zip archive</a> for your enjoyment.</p>
<p>&nbsp;</p>
