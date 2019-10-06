---
layout: post
title: ColdFusion Component Hint Checker Extension
slug: coldfusion-hint-checker
date: 2010-06-11
categories:
- ColdFusion
- ColdFusion Builder
tags:
- Builder
- ColdFusion
status: publish
type: post
published: true
---
<p>Hints... they are an important part of life.</p>
<p>Consider dropping a hint for a long-sought after birthday gift. Hinting to someone that you like them, or hints for the latest console game to help you achieve maximum death rampage on "Killer Chocolate Bunnies from Mars".</p>
<p>Bottom line, <strong>hints are helpful</strong>.</p>
<h2>Enter 'THE PROBLEM'</h2>
<p>Never more so has the need for hints been as important as in the world and lives of developers. We write awesome frameworks, intense code and sweet apps.</p>
<p>I was in a situation the other day working on a legacy app for someone to resolve some issues and add new functionality. The ColdFusion developer/s who had originally built the particular features for the application had written as much as they could in components to increase modularity and promote reusable code. Kudos. </p>
<p>The one thing that was constantly drummed in to me from day one as a ColdFusion developer was to always think about reusability. Why develop two or three functions with marginally different functionality if you can take a step back and restructure one method to work for all eventualities? It cleans up your code base, simplifies development and debugging, and makes for happy monkehs.</p>
<p>I digress.. ploughing through lines of someone else's code to debug or amend code can be taxing at the best of times (depending of current levels of caffeine intake). This particular task was made much harder to manage as absolutely no methods in the component(s) had been hinted. In a lot of cases, only the name of the method had been provided; no other attributes</p>
<p><strong>IMAGINE THE WHITESPACE!!</strong><br />
<img src="/assets/uploads/2010/06/shocking.gif" alt="Shocking" title="Shocking" /></p>
<p>There was the occasional comment here and there for good measure and to log minor edits, but nothing of any consequence that would aid understanding of the code and requirements.</p>
<h3>Bring in the hunter</h3>
<p>This got me thinking of a solution, or at least an idea to help avoid the solution in the future. With the awesome ability to create extensions for ColdFusion Builder, I quickly knocked up (by which I mean developed, not impregnated) an extension that would read the meta data of a selected component, and search within it for any instances of a method with a blank, incomplete or missing HINT attribute.</p>
<p>The <a href="http://hintchecker.riaforge.org/" title="Download the ColdFusion Hint Checker extension from riaforge.org" target="_blank">ColdFusion Hint Checker</a> extension was born.</p>
<h2>Here's how it works</h2>
<p>[kml_flashembed publishmethod="static" fversion="8.0.0" movie="/assets/uploads/2010/06/HintCheckerExtensionDemo.swf" targetclass="flashmovie"]</p>
<p>If you had Flash player, you'd be watching an awesome demo video right about now.</p>
<p>[/kml_flashembed]</p>
<h3>Why use it?</h3>
<p>Now, this didn't help me in my particular predicament; after all, none of the original developers were available to quiz and maim over the missing information. I could have added in my best guesses for the functionality, but that wouldn't have helped future devs looking at the code. So who could benefit from the application?</p>
<p>Perhaps you are developing and releasing open-source applications or CFC wrappers to the community. You ideally want to ensure that hints are provided so people can quickly understand what each method does.</p>
<p>Maybe you are a development manager or in charge of a team of developers. Perhaps you want to run a quick check on the ColdFusion components developed by your team to check for correct documentation. After all, if your team are going to be sharing code and reusing code written by others, make sure they hint it, and use this to track down any slackers. :)</p>
<p>Perhaps you are just anal about code and like to ensure everything is correctly hinted. You're not alone.</p>
<h3>Here's what it does</h3>
<p>ColdFusion provides developers with an easy 'straight-out-of-the-box' way to obtain information about a component, through the use of the <strong>getComponentMetaData()</strong> and <strong>getMetaData()</strong> functions.</p>
<p>Here's an output screenshot of the <strong>getComponentMetaData()</strong> function reading in my test.cfc file.</p>
<p><img src="/assets/uploads/2010/06/metaData_capture.gif" alt="getComponentMetaData() output" title="getComponentMetaData() output" /></p>
<p>You instantly have a visual representation of the component, it's attributes, extensions, path and (most importantly in this scenario) an array of all functions, each function declared as a struct of information.</p>
<p>It is this array, and the structs within that we are able to easily read and double-check the existence of the HINT attribute (by searching for the existence of a key named 'hint' within the structs).</p>
<p>In the following example, we're reading the meta data from a CFC file, looping over the array and performing our checks on the HINT attributes. Nice and easy.</p>
<pre name="code" class="xml">
&lt;!--- Get the metaData information from the CFC file ---&gt;
&lt;cfset arrayMeta = getComponentMetaData('test') /&gt;

&lt;!--- Set up the array to contain results from the check ---&gt;
&lt;cfset arrResults = [] /&gt;

&lt;!---
	Perform the loop if the CFC contains methods.
	Here, we are checking for the existence and the length
	of the array containing the functions.
 ---&gt;
&lt;cfif IsDefined("arrayMeta.functions") AND ArrayLen(arrayMeta.functions)&gt;

	&lt;!--- Loop over the array ---&gt;
	&lt;cfloop from="1" to="#ArrayLen(arrayMeta.functions)#" index="intCount"&gt;
		&lt;!---
			Check each struct within the array item for
			an empty or missing HINT attribute
		---&gt;
		&lt;cfif NOT structKeyExists(arrayMeta.functions[intCount], "hint")
					OR arrayMeta.functions[intCount].hint EQ ''&gt;

			&lt;cfset strMessage = '&lt;strong&gt; '
				& arrayMeta.functions[intCount].name
				& '&lt;/strong&gt; method has either an empty or
					missing HINT attribute! Sort it out!' /&gt;

			&lt;!--- Append the message ot the results array ---&gt;
			&lt;cfset arrayPrepend(arrResults, strMessage) /&gt;

		&lt;/cfif&gt;

	&lt;/cfloop&gt;

&lt;/cfif&gt;

&lt;!--- Dump the result array to see what we have uncovered ---&gt;
&lt;cfdump var="#arrResults#" label="Results from the hint checker." /&gt;
</pre>
<p>The resulting output from the code will produce an array like this:</p>
<p><img src="/assets/uploads/2010/06/hintCheck_results.gif" alt="hint check results" title="hint check results" /></p>
<p>This is an over-simplified version of the code contained within the extension, but you can see how easy it is to read information from the component and perform the hint check task.</p>
<p>The extension itself provides a little more information to the user and has a slightly prettier interface. Slightly.</p>
<h3>What's your line?</h3>
<p>It would be fine and dandy to just output the problem messages to the user, but it's not overly helpful. If there was a problem, you would want to know on which line the problem exists so you can quickly navigate to the correct location in your IDE and fix it.</p>
<p>In an effort to help the user experience and provide slightly more useful information, the plugin also returns the line number of the argument of method with the 'offensive' hint attribute.</p>
<p>This has been made incredibly easy thanks to the ability to loop over a file line by line, introduced in <a title="View the Adobe ColdFusion 8 Livedocs entry for looping over a file" href="http://livedocs.adobe.com/coldfusion/8/htmldocs/help.html?content=Tags_j-l_15.html#3205709" target="_blank">ColdFusion 8</a>.</p>
<p>In this basic example, the cfloop  accepts the full path to the file in the file attribute, and will output each line:</p>
<pre name="code" class="xml">
&lt;cfloop file="c:\full\path\to\file.txt" index="currentLine"&gt;
    #currentLine#&lt;br /&gt;
&lt;/cfloop&gt;
</pre>
<p>Simple.</p>
<p>As we want to obtain the current line of a specific method or argument name, we need to run a <strong>findNoCase()</strong> function on every line to see if we get a match. Once found, the method will return the populated string variable containing the line number of the requested method or argument.</p>
<p>In the getLineNumber method used in the extension, two arguments are required; the full path to the component (for the cfloop) and the name of the method or argument to search for.</p>
<p><strong>getLineNumber method</strong></p>
<pre name="code" class="xml">
&lt;cffunction name="getLineNumber"
			access="private"
			output="false"
			returntype="String"
			hint="I find the current line number of the
				function/method in question."&gt;

	&lt;cfargument name="componentPath"
				required="true" type="String"
				hint="I am the path to the component that
					you want to check." /&gt;

	&lt;cfargument name="functionName"
				required="true" type="String"
				hint="I am the name of the function that you wish
					to retrieve the line number of." /&gt;

		&lt;cfset var strLineNum 		= '' /&gt;
		&lt;cfset var strFunctionName 	= arguments.functionName /&gt;
		&lt;cfset var i 				= 1 /&gt;

			&lt;!--- loop over the file, sent through as a full path
					via the arguments scope ---&gt;
			&lt;cfloop file="#arguments.componentPath#" index="line"&gt;
				&lt;!--- loop line-by-line until the
					method/argument name has been matched ---&gt;
				&lt;cfif findNoCase(strFunctionName, line, 1)&gt;
					&lt;cfset strLineNum = i /&gt;
				&lt;/cfif&gt;
				&lt;cfset i++ /&gt;
	        &lt;/cfloop&gt;

	&lt;cfreturn strLineNum /&gt;
&lt;/cffunction&gt;
</pre>
<h2>Where can I get it?</h2>
<p>The ColdFusion Builder extensions is available to download from RIAforge.org, here: <a href="http://hintchecker.riaforge.org/" title="Download the ColdFusion Hint Checker extension from riaforge.org" target="_blank">http://hintchecker.riaforge.org/</a></p>
