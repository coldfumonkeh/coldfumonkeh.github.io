---
layout: post
title: monkehTweet Authorization Issue Without Callback URL Defined
slug: monkehtweet-authorization-issue-without-callback-url-defined
categories:
- ColdFusion
- Development
tags:
- CFC
- ColdFusion
- twitter
date: 2014-01-28
excerpt: Have you experienced the dreaded ‘Element AUTHURL is undefined in AUTHSTRUCT’ error when using monkehTweets to authorize an application against a user? You have? Step right in and see how to solve the issue.
---

Some users have experienced the following error when authenticating and authorizing their ColdFusion Twitter application using monkehTweet:

<img alt="AUTHURL is undefined in AUTHSTRUCT - monkehTweets" src="/assets/uploads/2014/01/authurl_error.jpg" />

I experienced this issue again last night when testing and updating the code, but only when I ran through the authorization process to grant permissions for a new user.

After a little digging around the answer (as they most often are) was quite simple.

Although I was sending through a callback URL in the code as below:

```
authStruct = application.objMonkehTweet.getAuthorisation(
  callbackURL='http://127.0.0.1:8500/monkehTweet/authorize.cfm'
);
```

The issue was that I had not defined a callback URL for this application in the app settings on dev.twitter.com. It had been left blank, and if that is the case the OAuth process assumes you are running an OOB request (Out Of Bounds) for mobile authentication. This fails the authorisation as the callback url set in the local code does not match the literal string 'oob'.

To change this, log into the application on <a title="dev.twitter.com" href="http://dev.twitter.com" target="_blank">dev.twitter.com</a> and go to the Settings tab:

<img title="Twitter Application Settings" alt="Twitter Application Settings" src="/assets/uploads/2014/01/twitter_settings_tab.png" />

Enter a URL in the callback URL field. This does not have to be the exact callback you will use, but as long as one is entered and it is not blank Twitter will know this is not an OOB request. Until a value is entered into this field, the API key will be "protected" from callback usage.

<img title="Twitter Application Callback URL" alt="Twitter Application Callback URL" src="/assets/uploads/2014/01/twitter_callback_url.png" />

This should solve the above error for anyone experiencing it.
