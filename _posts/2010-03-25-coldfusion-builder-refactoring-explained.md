---
layout: post
title: ColdFusion Builder - Refactoring Explained
slug: coldfusion-builder-refactoring-explained
date: 2010-03-25
categories:
- ColdFusion
- ColdFusion Builder
tags:
- Adobe
- Builder
- ColdFusion
status: publish
type: post
published: true
---
<h2><span style="font-weight: normal; font-size: 13px;">ColdFusion Builder has a built-in operation to perform refactoring tasks, another tool to help alleviate mass problems with renaming and any conflicts that may arise - no one steps into the world of refactoring without a mild sense of fear and possibly perspiration.</span></h2>
<h2>What is refactoring?</h2>
<p>The official (or 'an' official) definition of refactoring:</p>
<blockquote><p>"Improving a computer program by reorganising its internal structure without altering its external behaviour"</p></blockquote>
<p>More specifically, the ability to successfully rename files, functions and methods throughout an entire project or application without damaging or breaking the underlying code and functions.</p>
<p>ColdFusion Builder has a built-in operation to perform refactoring tasks, again helping to alleviate mass problems with renaming and any conflicts that may arise - no one steps into the world of refactoring without a mild sense of fear and possibly perspiration.</p>
<h2>Renaming CFC or CFM files</h2>
<p>From within ColdFusion Builder, you can easily rename a .cfc or .cfm file, which will alter all references pointing to or using that particular file.</p>
<p>Within the root of my project, I have a file called monkey.cfm - this has clearly been misspelt, and MUST be changed to monkeh.cfm immediately. Luckily, it's VERY easy to do using the refactoring option available.</p>
<ol>
<li>Select the file you wish to rename from the Navigation pane</li>
<li>Right-click and within the context menu select <strong>Refactor &gt; Rename</strong></li>
</ol>
<p>This will open up a dialog window to enter in the revised name of the file:</p>
<p><img title="renameFile1" src="/assets/uploads/2010/03/renameFile1.gif" alt="renameFile1" /></p>
<p>Once the correct or revised file name has been added, you have the option to make changes to only the current file.</p>
<p>By default this is unchecked, as refactoring normally indicates changes are required across the entire application - besides, prudence and caution should advise you that it's always better to scan across the entire application anyway to avoid any possible issues later on.</p>
<p>Click the '<strong>Preview</strong>' button, which will load up the next screen to show you a list of files and the code lines where changes will be made, also providing a superb code-comparison window:</p>
<p><img title="renameFile2" src="/assets/uploads/2010/03/renameFile2.gif" alt="renameFile2" /></p>
<p>In this example, only one reference to the file was found, which was the cfinclude path in index.cfm. If you're happy to commit the changes, click '<strong>OK</strong>' to confirm. ColdFusion Builder will make all of the necessary changes and your work here is done.</p>
<h2>Renaming UDFs</h2>
<p>UDFs are likely to be used throughout an application on numerous pages. Revising the name of the functions is incredibly easy.</p>
<ol>
<li>Open up the file in ColdFusion Builder, and select the function name</li>
<li>Right-click to pull up the context menu and again select <strong>Refactor &gt; Rename</strong></li>
</ol>
<p>In this example, I have a ColdFusion function written in the index.cfm page. The included monkeh.cfm page also makes a call to the function getDateTime().</p>
<p>I want to change this to getNow(), so highlighting or selecting the existing function name, select the '<strong>Refactor</strong>' menu option. You will again be greeted with the internal refactoring dialog window. Enter the revised name for the function.</p>
<p><img title="UDFRename1" src="/assets/uploads/2010/03/UDFRename1.gif" alt="UDFRename1" /></p>
<p>To see all changes across the project, click the preview button, which will list and display the location and specific entry of code to be changed.</p>
<p><img title="UDFRename2" src="/assets/uploads/2010/03/UDFRename2.gif" alt="UDFRename2" /></p>
<p>In this screen shot, you can see that ColdFusion Builder has found that the function is being called in both the index and monkeh.cfm files, and that the function itself is written in index.cfm, which will also be renamed.</p>
<p>Clever ColdFusion Builder.</p>
<h2>Reference Searches</h2>
<p>Renaming and revising file, function and method names aside, another essential tool of project and application management is the ability to search throughout the code base.</p>
<p>Guess what? ColdFusion Builder has got that down for you as well.</p>
<p>You are able to search for a reference of a file within either the project or the workspace.</p>
<ol>
<li>Within the Navigation pane, right-click on a .cfm or .cfc file within the project</li>
<li>Select the '<strong>References</strong>' option, and choose either '<strong>Project</strong>' or '<strong>Workspace</strong>'</li>
</ol>
<p><img title="reference1" src="/assets/uploads/2010/03/reference1.gif" alt="reference1" /></p>
<p>If it's not already open within your ColdFusion Builder workspace, the Search window will open and display all locations of the referenced text within either the entire workspace or the current project, as selected in the previous step.</p>
<p>You are also able to run a reference search within a particular file. With that .cfm or .cfc file open within the code editor window, select or highlight the text you wish to search for, and under the '<strong>References</strong>' context-menu, you will now see a third option to search within the file, as well as the project or workspace.</p>
<h2>Simplified Refactoring</h2>
<p>For me personally, I have found the addition of the refactoring functions in ColdFusion Builder another great tool and a benefit to development.</p>
<p>As code bases grow and expand over time, amending applications and object references can turn into a major chore. Refactoring can now be achieved through the IDE, helping to alleviate the risk of damaged references and file paths, which otherwise could have potentially disastrous effects on your application.</p>
