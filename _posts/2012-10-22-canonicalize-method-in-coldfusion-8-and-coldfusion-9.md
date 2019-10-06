---
layout: post
title: Canonicalize Method in ColdFusion 8 and ColdFusion 9
slug: canonicalize-method-in-coldfusion-8-and-coldfusion-9
categories:
- ColdFusion
tags:
- ColdFusion
- ESAPI
- Security
status: publish
type: post
published: true
date: 2012-10-22
---
<p>Earlier this morning, <a title="Visit mjhagen on Twitter" href="http://twitter.com/mjhagen" target="_blank">Mingo Hagen</a> <a title="http://twitter.com/mjhagen/statuses/260320092989030400" href="http://twitter.com/mjhagen/statuses/260320092989030400" target="_blank">asked a question</a> on Twitter about using the <a title="ColdFusion 10 docs - canonicalize" href="http://help.adobe.com/en_US/ColdFusion/10.0/CFMLRef/WS932f2e4c7c04df8f-1a0d37871353e31b968-8000.html" target="_blank">canonicalize function</a> available natively in ColdFusion 10 on a ColdFusion 9 server.</p>
<p>ColdFusion 10 contains a few new security methods (encodeForHTML, encodeForURL etc) as well as the canonicalize method, which are drawn from the <a title="OWSAP ESAPI documentation" href="https://www.owasp.org/index.php/Category:OWASP_Enterprise_Security_API" target="_blank">ESAPI (Enterprise Security API)</a> .jar file included in the installation. Whilst CF8 and cF9 do not have these methods exposed as native functions, they DO contain the ESAPI.jar file. ESAPI was included in ColdFusion as a hotfix for 8 and 8.0.1 (ESAPI 1.4), and ColdFusion 9 and 9.0.1 (ESAPI 2 RC). This means we can instantiate the java library and still use these security features:</p>

```
<cfset strText = 'Hello, world. This is the &lt;strong&gt;greatest&lt;/strong&gt; example in the world.' />

<!--- Instantiate the ESAPI object. --->
<cfset objESAPI 	= createObject("java","org.owasp.esapi.ESAPI") />
<!--- Assign the Encoder class to a new variable. --->
<cfset objEncoder 	= objESAPI.encoder() />

<!--- Canonicalize the provided string. --->
<cfset strClean = objEncoder.canonicalize(strText, false, false) />


<!---
	In this example we created a separate object for the Encoder class.
	You could simply call the canonicalize function this way, too:

	<cfset strClean = objESAPI.encoder().canonicalize('whatever your input string is') />

--->
```

<p>The ESAPI components and libraries are incredibly detailed and feature-rich and much more can be achieved with them, but the above code will help you instantiate the objects and use the encoding methods in earlier versions of ColdFusion (8 and 9).</p>
<p>I have also added the canonicalize method to my forked repository of the CFML Security project created by Pete Freitag / Foundeo last week.</p>
<p>You can download the fork from <a title="Download CFML Security from Github" href="https://github.com/coldfumonkeh/cfml-security" target="_blank">https://github.com/coldfumonkeh/cfml-security</a></p>
