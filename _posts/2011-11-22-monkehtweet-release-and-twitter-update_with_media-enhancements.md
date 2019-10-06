---
layout: post
title: monkehTweet release and Twitter update_with_media enhancements
slug: monkehtweet-release-and-twitter-update-with-media-enhancements
categories:
- ColdFusion
- Projects
tags:
- API
- ColdFusion
- Components
status: publish
type: post
published: true
date: 2011-11-22
---
<p>This morning I pushed out the latest release of monkehTweet, the open-source ColdFusion wrapper to interact with the Twitter API.</p>
<p>There are a number of revisions, enhancements and changes to the code and the service layer.</p>
<p>Firstly, and very important for anyone using the older versions of the package - I went through the Twitter documentation to check and update all available methods and add additional / new parameters to the code. Whilst doing so, I changed some of the argument names to fall in line with the official Twitter names to make it easier for me to maintain and update future releases.</p>
<p>As a result, PLEASE make sure you check your use of parameter names in any methods you are calling with the actual names of the arguments available to avoid any possibility of disruption or errors. Only a few methods have had some arguments changed this way, but I'd still recommend just checking your code to make sure. As said, this will greatly improve future update times and revisions.</p>
<h2>Update with Media</h2>
<p>The biggest addition to the project is probably the inclusion of the new update\_with\_media function from Twitter, which allows you to post one image (either a gif, jpeg or png) with the status update. This took some considerable thinking, plenty of coffee and a little refactoring of code to put in to place, but it's finally there.</p>
<p>In terms of use, it's incredibly simple. The two required parameters are the status and the media file to upload and include alongside the status. The media file itself is the full path of the file on the server.</p>
<p>Let's have a look at the example below:</p>
<pre name="code" class="xml">objMonkehTweet	=	new com.coldfumonkeh.monkehTweet(
	consumerKey			=	'&lt; your consumer key &gt;',
	consumerSecret		=	'&lt; your consumer secret &gt;',
	oauthToken			=	'&lt; your oauth token &gt;',
	oauthTokenSecret	=	'&lt; your oauth token secret &gt;',
	userAccountName		=	'&lt; your account name &gt;'
);

objMonkehTweet.postUpdate(
	status="@iotashan - the new release has something you've been waiting for..
			yes, the longest 24 hours in the world, ever, is finally over!",
	in\_reply\_to\_status\_id='134657766970228736'
);</pre>
<p>Here we have a simple status update, in reply to a particular status from a follower. </p>
<p>The actual status generated from this call be seen here: <a href="http://twitter.com/#!/coldfumonkeh/statuses/138930784303194112" title="View this status update" target="_blank">http://twitter.com/#!/coldfumonkeh/statuses/138930784303194112</a></p>
<p>The update\_with\_media function (or __postUpdateWithMedia__ as it's called in monkehTweet) is incredibly similar.</p>
<pre name="code" class="xml">objMonkehTweet	=	new com.coldfumonkeh.monkehTweet(
	consumerKey			=	'&lt; your consumer key &gt;',
	consumerSecret		=	'&lt; your consumer secret &gt;',
	oauthToken			=	'&lt; your oauth token &gt;',
	oauthTokenSecret	=	'&lt; your oauth token secret &gt;',
	userAccountName		=	'&lt; your account name &gt;'
);

// Include the media parameter (full path to file)

objMonkehTweet.postUpdateWithMedia(
	status='@refyner FYI the new ##monkehTweet release has some
		minor changes to some argument names. ##ColdFusion',
	media="/Applications/ColdFusion9/wwwroot/monkehTweet/test/code.png",
	in\_reply\_to\_status\_id='135070647205380096'
);</pre>
<p>The status generated from this call with the attached media file can be seen here: <a href="http://twitter.com/coldfumonkeh/statuses/138945147168763904" title="View this status update" target="_blank">http://twitter.com/coldfumonkeh/statuses/138945147168763904</a></p>
<p>The single media argument points to the full path of the image file on the server. monkehTweet handles the full upload and authentication procedure in much the same way as it does with every other request through the API.</p>
<p>Under the hood quite a lot more is happening that the user is not aware of. The postUpdateWithMedia method needs to handle the OAuth authentication and header generation slightly differently to all of the other requests within the API. The call to this method is handled through a POST request that needs to go through a multipart/form-data submission, sending the image file in binary, as well as any of the other arguments (status is a required field, so will always be sent in the request).</p>
<p>As the request was being sent in this manner, the OAuth signature needed to be redefined for this method only to just include the oauth_* specific parameters. This was the biggest headache to refactor, but once it was working was incredibly easy.</p>
<p>At present, Twitter only accepts JPG, GIF and PNG files for upload. To assist in ensuring the correct file type has been submitted, the monkehTweet package will check the mimetype of the supplied file, and will only proceed if it matches one of the approved file types. This has been included thanks to the open source project <a title="MagicMime on RIAForge.org" href="http://magicmime.riaforge.org/" target="_blank">http://magicmime.riaforge.org/</a> from Paul Connell.</p>
<p>One think to note is that the link generated by Twitter to the upload media file forms part of the 140 character limitation on the overall status. To quote the <a title="Read the statuses/update_with_media documentation" href="https://dev.twitter.com/docs/api/1/post/statuses/update_with_media" target="_blank">official documentation</a> for this method:</p>
<blockquote><p>The Tweet text will be rewritten to include the media URL(s), which will reduce the number of characters allowed in the Tweet text. If the URL(s) cannot be appended without text truncation, the tweet will be rejected and this method will return an HTTP 403 error.</p></blockquote>
<p>So, if uploading an image, keep an eye on the length of the text within the status to ensure you don't go over the limit.</p>
<h2>Help is at hand</h2>
<p>Some more inclusions into this release are the three help methods from Twitter:</p>
<ul>
<li>test</li>
<li>configuration</li>
<li>languages</li>
</ul>
<p>Test simply runs a basic call to the API to return a response - very useful for determining the current system status. Languages will provide you with details of the ISO language references that you can then use in certain calls.</p>
<p>The configuration function is incredibly useful for the media uploads. The returned data contains information on the maximum number of media allowed per upload (currently set to one), the size limit of the uploaded image file (very useful to determine if an image SHOULD be uploaded by checking the size), as well as photo size dimensions, URL length as well as some other information.</p>
<h2>Grab a copy!</h2>
<p>The updated version (v1.3.0) of monkehTweet is available now to download from <a title="Download monkehTweet from RIAForge.org" href="http://monkehtweet.riaforge.org" target="_blank">monkehtweet.riaforge.org</a> or from the github repository here: <a title="Download monkehTweet from the github repository" href="https://github.com/coldfumonkeh/monkehTweets" target="_blank">https://github.com/coldfumonkeh/monkehTweets</a>.</p>
