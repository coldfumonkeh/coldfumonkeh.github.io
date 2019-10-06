---
layout: post
title: Twitter Application Permission Model Changes
slug: twitter-application-permission-model-changes
categories:
- Development
tags:
- API
- twitter
status: publish
type: post
published: true
date: 2011-06-23
---
<p>A note for all Twitter application developers, including everyone using <a title="monkehTweet Twitter API ColdFusion Wrapper" href="http://www.mattgifford.co.uk/monkehtweets-coldfusion-twitter-cfc-update">monkehTweet</a>...</p>
<p>Twitter have made changes to the application permission model which has an impact on what services your application can manage on behalf of the user, with a particular focus of accessing their Direct Messages.</p>
<p>When setting up a consumer application through Twitter, you were provided with two permission settings -</p>
<ol>
<li>Read &amp; Write</li>
<li>Read-only</li>
</ol>
<p>Twitter have now added in a third level of permissions: Read, Write, &amp; Direct Messages.</p>
<p>If your application needs to access the direct messages for authenticated users, you will need to log in to <a title="Visit dev.twitter.com" href="http://dev.twitter.com" target="_blank">dev.twitter.com</a> and change the permission settings for your application. This will not change your current consumer key or consumer secret values; the strings themselves will remain the same, but the associated permissions will alter.</p>
<p>Any user logging in to authenticate and approve your application is currently presented with the following permission message:</p>
<p><img title="Twitter application authentication permissions" src="/assets/uploads/2011/06/twitter_application_permission_1.gif" alt="Twitter application authentication permissions" /></p>
<p>As mentioned, you will need to log in to <a title="Visit dev.twitter.com" href="http://dev.twitter.com" target="_blank">dev.twitter.com</a> to alter your application's permission settings (if you wish/need to access the direct messages)</p>
<p>Once logged in, change the permission settings for your application:</p>
<p><img title="Twitter application - change application permissions" src="/assets/uploads/2011/06/twitter_application_permission_2.gif" alt="Twitter application - change application permissions" /></p>
<p>Any user authorising your application will now see the following revised permission message:</p>
<p><img title="Twitter application permissions" src="/assets/uploads/2011/06/twitter_application_permission_3.gif" alt="Twitter application permissions" /></p>
<p><strong>Your application has changed it's permission level and any new users will have these settings, but the permission changes have not been applied to existing users.</strong></p>
<p>The permissions are stored / assigned to each user token (to ensure that users have the correct level of access they have approved). If you need to access your user's Direct Messages, <strong>all existing users will need to re-authorize</strong> to pick up the new permissions and have them applied to their access keys for your application.</p>
<p>If this applies to you, you may need to send out a friendly email to your application's users to ask them to log in and authenticate once more.</p>
<p>For more information, visit the official <a title="Twitter Application Permission Model FAQ" href="http://dev.twitter.com/pages/application-permission-model-faq" target="_blank">Twitter FAQ</a> for this issue.</p>
