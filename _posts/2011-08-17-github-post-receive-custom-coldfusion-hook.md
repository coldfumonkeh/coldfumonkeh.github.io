---
layout: post
title: Github Post-Receive Custom ColdFusion Hook
slug: github-post-receive-custom-coldfusion-hook
categories:
- ColdFusion
tags:
- ColdFusion
- Components
- Git
status: publish
type: post
published: true
date: 2011-08-17
---
<p>I love writing open source ColdFusion apps.. it helps to grow the community, possibly fill some gaps or requirements, and allows me to keep learning and experimenting with code and processes.</p>
<p>All of my open-source releases are pushed to <a href="http://githubhook.riaforge.org/index.cfm?event=page.myprojects&id=8276" title="View my projects on riaforge.org" target="_blank">riaforge.org</a> (which should be EVERY ColdFusion developer's first place to look when searching for code. I've also been pushing the releases to <a href="https://github.com/coldfumonkeh" title="View my projects on Github" target="_blank">Github</a> for a number of reasons, but primarily to help raise the general public's awareness of ColdFusion (if they see projects actively being developed and pushed out, they know it's still very much <a href="http://iscoldfusiondead.com/" title="Is ColdFusion dead?" target="_blank">alive and kicking</a>) and for any developers who prefer to pull from the Git repository (should they wish to amend/edit/revise code and push back to me, that's always a bonus too!).</p>
<p>One thing I discovered when working on <a title="Download monkehTweet ColdFusion Twitter API Wrapper" href="http://monkehtweet.riaforge.org" target="_blank">monkehTweet</a> was that Github.com had a number of built in post-commit hooks - the list of available services looks quite extensive and seems to cover most common ticketing and project management tools.</p>
<p>You can access these hooks by clicking the admin button on the top header of your Github repos and selecting Service Hooks from the next menu.</p>
<p><img title="Github Admin button" src="/assets/uploads/2011/08/adminButton.png" alt="Github Admin button" /></p>
<p>One of the options was to hook the account into Twitter, and following any updates or pushes to the repository, Github would post a status update through via the authenticated Twitter account.</p>
<p>Pretty impressive stuff, really easy to integrate and great for rapid updates and notifications. However, the status updates were quite generic:</p>
<p><img title="Github Service Hook Twitter updates" src="/assets/uploads/2011/08/githubPRHook_Twitter.png" alt="Github Service Hook Twitter updates" /></p>
<p>You can see here that the name of the committer (pusher/updater) takes up a lot of space. Sure, my online handle is longer than others, but what if you could customise the messages posted out via the hook?</p>
<p>Well, it turns out you can do that too!</p>
<h2>Payload</h2>
<p>From the Service Hook menu, you can select the first option 'Post-Receive URLs' which allows you to specify your own endpoint to receive the commit information. Github deploys the data through an HTTP POST submission with the form name of 'payload', which submits a JSON value containing a whole load of details relating to not only the last commit but the repository in general.</p>
<p><a href="/assets/uploads/2011/08/GithubServiceHooks.png"><img  title="Github Service Hooks" src="/assets/uploads/2011/08/GithubServiceHooks-610x439.png" alt="Github Service Hooks" /></a></p>
<p>The returned JSON response looks like this:</p>
<pre>{
  "after": "d1ba8626485e26bf87275de1aa3ff2a62a2e096d",
  "base_ref": null,
  "before": "3af75e4d216593e5b456e959559daaa5c138f315",
  "commits": [
    {
      "added": [
        "com\/coldfumonkeh\/githubPostReceive\/commit.cfc",
        "com\/coldfumonkeh\/githubPostReceive\/githubPayload.cfc",
        "com\/coldfumonkeh\/githubPostReceive\/payload.cfc",
        "com\/coldfumonkeh\/githubPostReceive\/repository.cfc"
      ],
      "author": {
        "email": "me@mattgifford.co.uk",
        "name": "Matt Gifford aka coldfumonkeh",
        "username": "coldfumonkeh"
      },
      "distinct": true,
      "id": "d1ba8626485e26bf87275de1aa3ff2a62a2e096d",
      "message": "Components added to repos",
      "modified": [],
      "removed": [],
      "timestamp": "2011-08-17T05:11:30-07:00",
      "url": "https:\/\/github.com\/coldfumonkeh\/Github-Post-Receive-Hook\/commit\/d1ba8626485e26bf87275de1aa3ff2a62a2e096d"
    }
  ],
  "compare": "https:\/\/github.com\/coldfumonkeh\/Github-Post-Receive-Hook\/compare\/3af75e4...d1ba862",
  "created": false,
  "deleted": false,
  "forced": false,
  "pusher": {
    "name": "none"
  },
  "ref": "refs\/heads\/master",
  "repository": {
    "created_at": "2011\/08\/17 05:01:37 -0700",
    "description": "This ColdFusion component will read in your Github commit payload information and provide you with a detailed CFC or JSON string to work with to create custom hook information",
    "fork": false,
    "forks": 1,
    "has_downloads": true,
    "has_issues": true,
    "has_wiki": true,
    "homepage": "http:\/\/www.mattgifford.co.uk\/",
    "name": "Github-Post-Receive-Hook",
    "open_issues": 0,
    "owner": {
      "email": "me@mattgifford.co.uk",
      "name": "coldfumonkeh"
    },
    "private": false,
    "pushed_at": "2011\/08\/17 05:11:53 -0700",
    "size": 96,
    "url": "https:\/\/github.com\/coldfumonkeh\/Github-Post-Receive-Hook",
    "watchers": 1
  }
}</pre>
<p>This is superb, but I wanted a simple way of using this data to customise and use any way I wanted, so I created a ColdFusion component package to do just that!</p>
<h2>Useage</h2>
<p>In the page you saved as your custom service hook url, instantiate the component like so:</p>
<pre lang="cfm">
<!--- Instantiate the component --->
<cfset objPayload = createObject(
			'component',
			'com.coldfumonkeh.githubPostReceive.githubPayload'
		) />
<!---
	Call the receive() method to process
	the deployed payload information.
--->
<cfset payloadinfo = objPayload.receive(
			payloadSubmission	=	FORM,
			asObject		=	false,
			parseResults		=	true
		) />
</pre>
<p>The <strong>payloadSubmission</strong> argument is required and accepts the entire FORM structure from the submission. Setting <strong>asObject</strong> to true will generate the full payload information as a fully populated CFC for you:</p>
<p><img  title="Github Service Hook CFC Response" src="/assets/uploads/2011/08/githubCFC-610x487.png" alt="Github Service Hook CFC Response" /></p>
<p>If <strong>asObject</strong> is set to false (default), you will simply receive the original JSON response as a string:</p>
<p><img  title="Github Service Hook JSON Response" src="/assets/uploads/2011/08/githubJSON-610x98.png" alt="Github Service Hook JSON Response" /></p>
<p>You can set the third parameter (<strong>parseResults</strong>) to true, which will deserialize the JSON and return a structural representation of the output:</p>
<p><img  title="Github Service Hook Structural Response" src="/assets/uploads/2011/08/githubStruct-610x435.png" alt="Github Service Hook Structural Response" /></p>
<p>So, with this custom hook feature in place, you can create bespoke emails to notify you of updates. You can store your commit details into a database. You can also use my <a title="Download monkehTweet ColdFusion Twitter API Wrapper" href="http://monkehtweet.riaforge.org" target="_blank">monkehTweet</a> Twitter wrapper to post your custom message to Twitter. The possibilities are endless.</p>
<h2>Download It</h2>
<p>You can download the Github Post-Receive Hook ColdFusion package from <a title="Download the ColdFusion package from riaforge.org" href="http://githubhook.riaforge.org/" target="_blank">githubhook.riaforge.org</a> or from the <a title="Download the ColdFusion package from Github" href="https://github.com/coldfumonkeh/Github-Post-Receive-Hook" target="_blank">Github repository</a>.</p>
<p>Happy customising!</p>
