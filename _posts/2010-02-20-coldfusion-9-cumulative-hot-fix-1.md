---
layout: post
title: ColdFusion 9 Cumulative Hot Fix 1
slug: coldfusion-9-cumulative-hot-fix-1
date: 2010-02-20
categories:
- ColdFusion
tags:
- ColdFusion
status: publish
type: post
published: true
---
<p>Adobe have released a Cumulative Hot Fix for ColdFusion 9, and it is recommended to all users that the hot fix is applied if they have experienced any of the following issues:</p>
<ul>
<li>Fix for the NullPointerException error thrown when deploying a car file from Coldfusion 7 containing datasources to Coldfusion 9</li>
<li>Fix for the issue where Coldfusion was ignoring local variable assignment when the variable is assigned to a struct at runtime</li>
<li>Fix for the “java.util.regex.PatternSyntaxException: Illegal repetition{}” error thrown when using {} as delimiter with the listtoarray function</li>
<li>Fix for the issue where in any cfscript style function declarations, function parameter types were not accepting the dotted CFC typeFix for the issue where coldfusion deployed on Jboss was unable to render maps using cfmap</li>
<li>Fix for the “Error casting an object of type java.lang.Double cannot be cast to  java.lang.String to an incompatible type” error thrown when calling a CFC remotely with returnFormat=json</li>
<li>Fix for the issue where an implicit struct/array passed to a function call as a value is not working</li>
<li>Fix for the issue where cfscript style function declaration was not accepting implicit struct/array as a default value for the second argument onward</li>
<li>Fix for the “ashx image format is not supported on this operating system” error thrown when assigning an image returned from a .NET webservice to a CFImage tag</li>
<li>Fix for the “Cannot drop the table '&lt;tableName&gt;'” error thrown when requesting the CFC for the first time with the ORM setting dbcreate set to dropcreate</li>
</ul>
<p>For more information on the CHF1, please visit the <a title="Adobe Technote - Cumulative Hot Fix 1 for ColdFusion 9" href="http://kb2.adobe.com/cps/825/cpsid_82536.html" target="_blank">Adobe Technote page</a> with details for downloading and installing the fix.</p>
<h3>MXUnit issues?</h3>
<p>Ray Camden has posted a <a title="CHF Warning - Impacts MXUnit" href="http://www.coldfusionjedi.com/index.cfm/2010/2/20/CHF-Warning--Impacts-MXUnit" target="_blank">brief blog entry</a> following his installation of the hot fix, and how it affected MXUnit. If you experience issues of a similar nature, check out his post.</p>
