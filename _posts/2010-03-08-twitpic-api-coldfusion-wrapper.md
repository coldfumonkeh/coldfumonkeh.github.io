---
layout: post
title: TwitPic API ColdFusion Wrapper
slug: twitpic-api-coldfusion-wrapper
date: 2010-03-08
categories:
- ColdFusion
tags:
- CFC
- ColdFusion
- Components
status: publish
type: post
published: true
---
<p>Having developed the <a href="http://www.mattgifford.co.uk/monkehtweets-coldfusion-twitter-cfc/" title="View the blog post for the monkehTweets ColdFusion Twitter Wrapper">monkehTweets</a> Twitter ColdFusion Wrapper, I wanted to carry on working with the Twitter 'market' and decided to build a quick little CFC wrapper to interact with the <a href="http://twitpic.com" target="_blank" title="Go to the TwitPic site">TwitPic</a> API. </p>
<p>This CFC wrapper will easily allow developers to integrate the upload functionality into any projects, and will enable users to upload an image to the TwitPic site with an optional message.</p>
<p>The full open source code can be downloaded from <a href="http://twitpic.riaforge.org/" target="_blank" title="Download the TwitPic API ColdFusion Wrapper from RIA Forge">http://twitpic.riaforge.org/</a>.</p>
<h2>Instantiating the CFC</h2>
<p>Invoking the twitpic object is incredibly simple.<br />
The component has two required parameters; the account name and password for the Twitter user account.</p>
<p>The object also accepts an optional third parameter, 'parseResults'. This is set to false by default, and as such the XML response returned from the API will be in literal String format.<br />
Setting this param to 'true', the XML will be returned through ColdFusion's built-in XmlParse() function, returning a structural representation of the XML.</p>
<pre name="code" class="html">
&lt;cfscript&gt;
	strUsername = 'Twitter account username';
	strPassword = 'Twitter account password';

        // instantiate the twitpic component and pass the params
	objTwitPic = createObject('component',
					'com.coldfumonkeh.twitpic').init(
						userName=strUsername,
						password=strPassword,
						parseResults='true');
&lt;/cfscript&gt;
</pre>
<p>In my (some may say crude) HTML form, we are creating a very simple user-interface. We are allowing the user to browse for a file, and supply an optional message to send through to the TwitPic API. If the message was present, it would be posted using the Twitter user's details onto the feed with a link to the uploaded image prepended.</p>
<h2>Handling the form upload</h2>
<pre name="code" class="html">
&lt;cfif structKeyExists(form, 'submit_btn')&gt;
	&lt;cffile action="upload"
		destination="#getTempDirectory()#"
		file="#form.file#"
		nameconflict="overwrite" /&gt;

	&lt;cfscript&gt;
		upload = objTwitPic.uploadPic(
			media='#cffile.serverdirectory#\#cffile.serverfile#',
			message=form.message);
    	writeDump(upload);
	&lt;/cfscript&gt;
&lt;/cfif&gt;

&lt;cfoutput&gt;
	&lt;form name="upload" action="#cgi.script_name#"
			method="post" enctype="multipart/form-data"&gt;
	    &lt;label for="file"&gt;Photo:&lt;/label&gt;
	    &lt;input type="file" name="file" id="file" /&gt;&lt;br /&gt;
	    &lt;label for="message"&gt;Tweet:&lt;/label&gt;
	    &lt;input type="text" name="message"
			id="message" maxlength="140" size="70" /&gt;&lt;br /&gt;
	    &lt;input type="submit" name="submit_btn" value="upload" /&gt;
	&lt;/form&gt;
&lt;/cfoutput&gt;
</pre>
<p>In the above example. the form handler event itself is relatively easy. Detecting the submission of the form, the file is uploaded to the temporary directory on the ColdFusion server using the cffile tag.</p>
<p>To send the details to TwitPic, we next run the uploadPic() method within the twitpic.cfc, which accepts the location of the file and the message field from the form.</p>
<h2>The uploadPic() Method</h2>
<p>The uploadPic() method itself submits an HTTP POST request to the TwitPic API, sending through the file and the message field (if filled in).</p>
<pre name="code" class="html">
&lt;cffunction name="uploadPic" access="public" output="false"
	hint="I am the function that handles the file upload,
	and can also publish a status message to your Twitter account"&gt;
		&lt;cfargument name="media" 	required="true"
			type="string" hint="The binary image data to submit" /&gt;
		&lt;cfargument name="username" required="false"
			default="#getTweetUserName()#"
			type="string" hint="The Twitter username" /&gt;
		&lt;cfargument name="password"	required="false"
			default="#getTweetPassword()#"
			type="string" hint="The Twitter password" /&gt;
		&lt;cfargument name="message"	required="false"
			default=""
			type="string" hint="Message to post to Twitter.
				The URL of the image is automatically added" /&gt;
			&lt;cfset var cfhttp 		= '' /&gt;
			&lt;cfset var strResponse 	= '' /&gt;
			&lt;cfset var strMethodURL	= '' /&gt;
			&lt;cfset var stuError		= structNew() /&gt;
			&lt;cfset var arrXMLError	= arrayNew(1) /&gt;
				&lt;!--- build the required URL for submission ---&gt;
				&lt;cfset strMethodURL = getTwitPicURL()
					& 'api/upload' /&gt;
				&lt;cfif len(arguments.message)&gt;
					&lt;cfset strMethodURL = strMethodURL
						& 'AndPost' /&gt;
				&lt;/cfif&gt;
				&lt;!--- send the POST request to the URL ---&gt;
				&lt;cfhttp url="#strMethodURL#" method="post"&gt;
					&lt;cfhttpparam name="media"
						type="file"
						file="#arguments.media#" /&gt;
					&lt;cfhttpparam name="username"
						type="formfield"
						value="#arguments.username#" /&gt;
					&lt;cfhttpparam name="password"
						type="formfield"
						value="#arguments.password#" /&gt;
					&lt;cfif len(arguments.message)&gt;
						&lt;cfhttpparam name="message"
							type="formfield"
							value="#arguments.message#" /&gt;
					&lt;/cfif&gt;
				&lt;/cfhttp&gt;
				&lt;!--- handle the return ---&gt;
				&lt;cfif len(cfhttp.fileContent)&gt;
					&lt;cfset arrXMLError =
						xmlSearch(cfhttp.fileContent, 'rsp/err') /&gt;
					&lt;cfif arrayLen(arrXMLError)&gt;
						&lt;cfset stuError = arrXMLError[1].XmlAttributes /&gt;
						&lt;cfreturn stuError /&gt;
						&lt;cfabort&gt;
					&lt;/cfif&gt;
					&lt;cfreturn handleReturnFormat(cfhttp.fileContent) /&gt;
				&lt;/cfif&gt;
&lt;/cffunction&gt;
</pre>
<p>The API offered two options when sending data; with a message or without the message.</p>
<p>The actual underlying code and functionality between the two was the same, the only difference being the URL to submit to if the message was supplied.</p>
<p>As such, it made it much simpler to create a single method to handle both eventualites, and generate the required URL accordingly, as seen in the code example below:</p>
<pre name="code" class="html">
&lt;!--- build the required URL for submission ---&gt;
&lt;cfset strMethodURL = getTwitPicURL() & 'api/upload' /&gt;
&lt;cfif len(arguments.message)&gt;
    &lt;cfset strMethodURL = strMethodURL & 'AndPost' /&gt;
&lt;/cfif&gt;
</pre>
<p>If only the photo was supplied, the generated string would read:</p>
<p><strong>http://twitpic.com/api/upload</strong>.</p>
<p>With the inclusion of the message, the <strong>strMethodURL</strong> variable would be amended to create the revised URL: </p>
<p><strong>http://twitpic.com/api/uploadAndPost</strong></p>
<h2>API Response</h2>
<p>Following a successful post, the API will return an XML response. For any posts that included only photo uploads (no comments or messages), the standard XML output is similar to below, returning the specific ID of the media and the direct link to the file on the twitpic site.</p>
<p><img src="/assets/uploads/2010/03/twitPic_upload_complete.gif" alt="twitPic_upload_complete" title="twitPic_upload_complete" /></p>
<p>Supplying a message to accompany the uploaded file, the returned output would be similar to the screen grab below:</p>
<p><img src="/assets/uploads/2010/03/twitPic_upload_message_complete.gif" alt="twitPic_upload_message_complete" title="twitPic_upload_message_complete" /></p>
<p>Here, you can see the response has included the Twitter ID of the user making the post, and the ID of the status created and published in the Twitter feed.</p>
<p>The freshly uploaded image and accompanying message / status update can now be viewed on TwitPic using the URL returned from the response.</p>
<p><img src="/assets/uploads/2010/03/twitPic_uploaded.gif" alt="twitPic_uploaded" title="twitPic_uploaded" /></p>
<h2>Error Handling</h2>
<p>The TwitPic API is incredibly simple, especially in comparison to other APIs, including the Twitter API. No complex REST-ful coding here. The output is available in XML only. </p>
<p>To some extent, that may be limiting. As a developer, ideally you would like an API to return method responses in as many varying formats as possible to help with code integration and development.</p>
<p>In this instance, however, it makes it incredbily easy to manage any errors from the API call.</p>
<p>The API itself only specifies four error messages, or instances for error based upon API process, namely</p>
<ul>
<li>1001 - Invalid twitter username or password</li>
<li>1002 - Image not found</li>
<li>1003 - Invalid image type</li>
<li>1004 - Image larger than 4MB</li>
</ul>
<p>The detection of error messages was made incredibly easy due to the fact that the XML response would contain a specific node called '<strong>err</strong>', as shown in the below sample:</p>
<pre name="code" class="xml">
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="fail">
    <err code="1001" msg="Invalid twitter username or password">
    </err>
</rsp>
</pre>
<p>To check for the existence of this node, and therefore any error messages returned from the API, an XmlSearch is performed on the returned XML structure, performing a search on the 'err' node name:</p>
<pre name="code" class="html">
&lt;cfset arrXMLError = xmlSearch(cfhttp.fileContent, 'rsp/err') /&gt;
</pre>
<p>Any detection of the 'err' node will populate a pre-defined var-scoped array variable. From this, we can then run the checks on the length of the array, and return the structure within the attributes of the XML to the user, should an error exist.</p>
<pre name="code" class="html">
&lt;cfif arrayLen(arrXMLError)&gt;
    &lt;cfset stuError = arrXMLError[1].XmlAttributes /&gt;
    &lt;cfreturn stuError /&gt;
    &lt;cfabort&gt;
&lt;/cfif&gt;
</pre>
<p><img src="/assets/uploads/2010/03/arrayXMLError.gif" alt="arrayXMLError" title="arrayXMLError" /></p>
<h2>Where can I get it?</h2>
<p>The code is available to download from RIAforge.org, here: <a href="http://twitpic.riaforge.org/" target="_blank" title="Download the TwitPic API ColdFusion Wrapper from RIA Forge">http://twitpic.riaforge.org/</a></p>
