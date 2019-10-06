---
layout: post
title: monkehTweets ColdFusion Twitter CFC
slug: monkehtweets-coldfusion-twitter-cfc
date: 2010-02-08
categories:
- ColdFusion
- Projects
tags:
- API
- CFC
- ColdFusion
- twitter
status: publish
type: post
published: true
---
<p>Ive been having a lot of fun over the weekend developing my own ColdFusion CFC wrappers to interact with the Twitter API (Application Programming Interface) - yes, I'm a geek.</p>
<h2>Introducing monkehTweets</h2>
<p>monkehTweets is the (rather catchy, I think you'll agree) name of the CFC wrapper I have developed.</p>
<p>I must admit, I was surprised at how easy (and fun) the Twitter API itself is. It's very easy to follow and simple to use. Having developed wrappers for various external APIs in the past, so far the Twitter API has been the most enjoyable to write for.</p>
<h2>So, what's included?</h2>
<p>The wrapper itself contains 13 ColdFusion components. Eleven of these components deal specifically with a particular section/group of methods available through the Twitter API. These 11 components are:</p>
<ul>
<li>account</li>
<li>blocks</li>
<li>direct_messages</li>
<li>favorites</li>
<li>friendships</li>
<li>lists</li>
<li>notifications</li>
<li>saved_searches</li>
<li>stauses</li>
<li>trends</li>
<li>users</li>
</ul>
<p>An abstract 'base' class is included that holds common utility functions used throughout the above 11 components.</p>
<p>Finally, there is the monkehTweet component itself, which is the user-facing façade, providing access to the 'sub' components. There are 70 methods open to the user/developer to access the API through the monkehTweet façade object, each one directly relating to an existing method within the Twitter API.</p>
<h2>Instantiating the façade</h2>
<p>The monkehTweet component is the only object required to be instantiated by the user, as follows:</p>
<pre name="code" class="java">objMonkehTweet = createObject('component',
        'com.coldfumonkeh.monkehTweet').init('username','password');</pre>
<p>The constructor method only requires two parameters; the Twitter username and account password respectively. These are persisted throughout the CFC package and included in every other component where required to make authenticated calls to the API service.</p>
<p>Running a simple call to obtain user details can be achieved like so:</p>
<pre  name="code" class="java">objMonkehTweet = createObject('component',
        'com.coldfumonkeh.monkehTweet').init('username','password');
// make a call to get user details and return data
result = objMonkehTweet.getUserDetails(id='coldfumonkeh');</pre>
<h2>Making the most of the REST</h2>
<p>The Twitter API does it's best to conform to the principles of Representational State Transfer (REST). The API itself allows for the data to be returned in a total of four MIME types, namely XML, JSON and the RSS and Atom specifications.</p>
<p>Each calling function within monkehTwitter cfc is very well documented in terms of hint attributes, and will let you know which formats are available for that particular method. Most methods generally support only XML or JSON, while a handful accept a combination of all four, and a few accept all four options.</p>
<p>In an effort to simplify the ability to switch file extensions, each calling method has an extra non-required argument ('format') which defaults to 'XML'. Changing this value to another allowed extension when making a request to the API will ensure you retrieve the response back in the required format.</p>
<p>For example, making a call to the getLists() method accepting all default arguments:</p>
<pre  name="code" class="java">// get all lists assigned to me, using default XML format
result = objMonkehTweet.getLists();</pre>
<p>This results in the output of XML formatted data, as shown in the example snippet below.</p>
<pre  name="code" class="xml:nocontrols">&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;lists_list&gt;
&lt;lists type="array"&gt;
&lt;list&gt;
&lt;id&gt;6651154&lt;/id&gt;
&lt;name&gt;Coldfusion&lt;/name&gt;
&lt;full_name&gt;@coldfumonkeh/coldfusion&lt;/full_name&gt;
&lt;slug&gt;coldfusion&lt;/slug&gt;
&lt;description&gt;ColdFusion developers&lt;/description&gt;
&lt;subscriber_count&gt;0&lt;/subscriber_count&gt;
&lt;member_count&gt;1&lt;/member_count&gt;
&lt;uri&gt;/coldfumonkeh/coldfusion&lt;/uri&gt;
&lt;/list&gt;
....
&lt;/lists&gt;
&lt;/lists_list&gt;
</pre>
<p>Running the same method call, we can switch the 'format' parameter to 'JSON' like so:</p>
<pre  name="code" class="java">// get all lists assigned to me, using JSON format
result = objMonkehTweet.getLists(format='JSON');</pre>
<p>The change in format request has been passed through to the API and the returned data is in JSON format, as per the example snippet below:</p>
<pre  name="code" class="js:nocontrols">{"name":"Coldfusion","full_name":"@coldfumonkeh\/coldfusion",
"subscriber_count":0.0,"description":"ColdFusion developers",
"id":6651154.0,"slug":"coldfusion","mode":"public",
"member_count":1.0","uri":"\/coldfumonkeh\/coldfusion"}</pre>
<h2>Working with the output</h2>
<p>So, you can see it really is very easy to pull the data back from the API in a workable 'string' format.</p>
<p>What if you wanted to work with or view the structural information of the returned data? For example, you might prefer to work with XML once it has been parsed, or JSON may be easier to work with if you can see it in a structural format. monkehTweets has been tweaked to allow for ease of use, and has taken this into consideration.</p>
<p>The intial instantiation method for the monkehTweet cfc accepts a third, non-required boolean parameter called 'parseResults'. Set to false by default, if set to true, the returned data from any called method will be converted using XmlParse() for XML, RSS and Atom, and DeserializeJSON() for any JSON responses, converting the data into a struct or an array of structs.</p>
<p>For example, let's run the getUserDetails() method once more, but let's set the parseResults parameter to true for both the XML and JSON requests:</p>
<pre  name="code" class="java">// instantiating the facade, but this time
// requesting structural data response
objMonkehTweet = createObject('component',
        'com.coldfumonkeh.monkehTweet').init('username','password',true);
// make a call to get user details and return data in XML format
result = objMonkehTweet.getUserDetails(id='coldfumonkeh');</pre>
<p><img  title="monkehTweet XML Structural Output" src="/assets/uploads/2010/02/monkehTweet_XMLStruct-724x1024.png" alt="monkehTweet XML Structural Output" /></p>
<pre  name="code" class="java">// instantiating the facade, but this time
// requesting structural data response
objMonkehTweet = createObject('component',
        'com.coldfumonkeh.monkehTweet').init('username','password',true);
// make a call to get user details and return data in JSON format
result = objMonkehTweet.getUserDetails(id='coldfumonkeh',format='json');</pre>
<p><img title="monkehTweet JSON Structural Output" src="/assets/uploads/2010/02/monkehTweet_JSONStruct.png" alt="monkehTweet JSON Structural Output" /></p>
<h2>I want it. Where can I get it?</h2>
<p>Right here: <a title="Download monkehTweets from riaforge.org" href="http://monkehtweet.riaforge.org/" target="_blank">monkehTweets.riaforge.org</a></p>
<p>The API wrapper has been released as an open-source package available to download from the riagforge.org library.</p>
<p>I hope that you download it, try it out and (fingers crossed) use it in a project. Let me know how you get on.</p>
