---
layout: post
title: ColdFusion Builder Snippets
slug: coldfusion-builder-snippets
date: 2010-04-01
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
<p>ColdFusion is a Rapid Application Development language, meaning that it allows developers to write powerful applications of any scale or magnitude with relative ease, and provides us the ability to code quickly and easily using relatively simple tag and script syntax to produce and perform some incredibly powerful tasks.</p>
<p>The speed and rapid elements of Coldfusion development also means that (theoretically) we are able to deliver end products to our customers with more ease and less issues - I choose the word 'theoretically' as there is always nine times out of ten an issue or two that arise to slow things down, whether it's a code issue or client-related enquiries.</p>
<p>Regardless, typically we are able to work faster, smarter and harder with ColdFusion, which means we may be able to finish projects on time if not earlier.</p>
<p>Does this mean more time at the pub after work as all projects have been completed? Perhaps more time with the family? However you choose to spend your 'earnt' hours, you HAVE earnt them.</p>
<h2>Gaining more time</h2>
<p>Building on top of what is already an astonishingly quickly language within which to develop, there are more ways a ColdFusion developer can enhance their development performance and optimise their time.</p>
<p>Through the use of code snippets, you can easily reduce the repetition of some of the common tasks when developing your applications or writing code.</p>
<h3>What are snippets?</h3>
<p>I'll tell you.</p>
<h3>Go on then...</h3>
<p>Snippets are code segments that can be written, customised and added into your application code.</p>
<p>ColdFusion Builder has a built-in snippet panel which lets you add your code snippets, edit them and insert them into the editor with ease. To access the panel in your workspace, you can do either one of the following:</p>
<ul>
<li><strong>Window -&gt; Show View -&gt; Snippets</strong></li>
<li><strong>Window -&gt; Show View -&gt; Other... -&gt; ColdFusion -&gt; Snippets</strong></li>
</ul>
<p><img title="Snippet Panel" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.49.27.png" alt="Snippet Panel" /></p>
<p>IDE's typically have some sort of toolbar with shortcuts to commonly used tags and functions, perhaps a wizard to help you fill out some of the attribute options to help you populate the tags before inserting them into the code editor.</p>
<p>Snippets are the same thing, although they are custom-written; YOU have the ability to write your own snippets of code, customise them for your own needs and requirements and format them to suit your preferences.</p>
<h3>Example</h3>
<p>You may want to debug your application and view the information sent in a FORM submission.</p>
<p>You'd probably type in the cfdump tag with the var attribute, then follow with a cfabort tag to halt further page processing.</p>
<p>With snippets, you can create a custom block of code containing those tags and information - you'd only have to write it once, and you could call it and insert it into your code using a simple keystroke shortcut.</p>
<p>Already, you have removed the necessity to duplicate code every time you need to run a dump and abort process, instantly saving you time.</p>
<h4>Let's create this snippet now</h4>
<ol>
<li>Open up the snippet panel in ColdFusion Builder</li>
<li>Click the 'Create A New Snippet' icon (the yellow 'plus' sign)</li>
<li>You will be provided with a snippet wizard dialog box to assist you and make your life easier than it already is
<p>These options are:</p>
<ul>
<li><strong>Name:</strong> The name of the snippet</li>
<li><strong>Trigger Text:</strong> The text used with the keyboard shortcut to invoke the snippet</li>
<li><strong>Start Block:</strong> The code segment you wish to invoke</li>
<li><strong>End Block:</strong> Optional code to insert after the Start Block</li>
</ul>
</li>
</ol>
<p>To create the cfdump / cfabort tag combination snippet, let's enter in the following details:</p>
<ul>
<li>Name: <strong>dumpAbort</strong></li>
<li>Trigger: <strong>dumpAbort</strong></li>
<li>Description: <strong>I create a cfdump followed by a cfabort tag</strong></li>
</ul>
<p>The code was added in to the Start Block input option, and the result can be seen below:</p>
<p><img title="Snippet Wizard" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.17.07.png" alt="Snippet Wizard" /></p>
<p>Awesome. Right? As we have provided a trigger text for the snippet, once saved we could invoke and insert it into the currently open document by typing in 'dumpAbort' and pressing the '<strong>cmd + J</strong>' key combination ('<strong>Ctrl + J</strong>' on a PC) or by double-clicking on the snippet in the Snippet Panel.</p>
<p>This block would work, but we'd still have to manually edit the code after insertion to add in the value of the var attribute to dump out our SCOPE/object.</p>
<h3>Adding Values</h3>
<p>Thankfully, we have the ability to force the snippet to prompt us to enter in information before the code is inserted in to the editor.</p>
<p>This is achieved by using the $${ ... } notation to mark a placeholder for variables to be included into the snippet.</p>
<p>We could add the <strong>$${Scope}</strong> inside the snippet block for the var attribute, which would prompt the wizard to create a dialog asking with a text field asking for the value of the Scope variable to be added:</p>
<p><img title="Scope Variable Prompt 1" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.04.47.png" alt="Scope Variable Prompt 1" /></p>
<p>Another alternative is to provide a list of values for the snippet placeholder variable, like so:</p>
<pre class="html">&lt;cfdump var="#$${Scope:FORM|URL|SESSION|Application}#" /&gt;</pre>
<p>The options you wish to provide are separated with a pipe (<strong>|</strong>) and written inside the $${} placeholder parenthesis.</p>
<p>This will create a drop down box with the values, and the selected value will be inserted in place of the $$( ... ) snippet variable:</p>
<p><img title="Snippet Value List" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.11.13.png" alt="Snippet Value List" /></p>
<p>After selecting a value, the code is then inserted directly into the editor at the current position of the cursor:</p>
<p><img title="Snippet Inserted" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.18.49.png" alt="Snippet Inserted" /></p>
<p>Instantly, we have created, adapted and customised a snippet, which when populated with either free-text or a value from a list of pre-defined values, will insert directly into the editor.</p>
<p>Goodbye repetitive typing, hello completed projects, happy clients and good times.</p>
<h4>System Variables</h4>
<p>Another benefit of using snippets is their ability to automatically populate 'system variables'.</p>
<p>The following is a list of reserved variables that the Snippets system will pre-populate for you upon insertion:</p>
<ul>
<li>$${DATE}</li>
<li>$${MONTH}</li>
<li>$${TIME}</li>
<li>$${DATETIME}</li>
<li>$${CURRENTFILE} – Current file name (just the file)</li>
<li>$${CURRENTFOLDER} – Current folder (The path to the containing folder)</li>
<li>$${CURRENTPATH} – Current path (full file name)</li>
<li>$${CURRENTPRJPATH} – Just the folder</li>
<li>$${USERNAME} – Current user</li>
<li>$${MONTHNUMBER} – Month as a number</li>
<li>$${DAYOFMONTH} – Day of month as a number</li>
<li>$${DAYOFWEEKNUMBER} – Day of week (the week starts on Sunday)</li>
<li>$${DATETIME24} – DateTime24 – a 24 hour clock version of datetime.</li>
<li>$${YEAR} – Current year.</li>
<li>$${YEAR2DIGIT} – Current two digit year.</li>
</ul>
<p>These are ideal timesavers and a superb way to populate dynamic data without having to type within the wizard.</p>
<p>Consider this example where we can create an inline CFML comment block:</p>
<pre class="html">&lt;!--- $${ Comment Title:FIX|TODO|ENHANCEMENT}
      $${DAYOFMONTH}.$${MONTHNUMBER}.$${YEAR2DIGIT}
      $${TIME} $${USERNAME}: $${Description} ---&gt;</pre>
<p>Only two variables here require any user-input from the wizard;</p>
<ol>
<li>Comment Title - a drop down selection list</li>
<li>Description - a free text entry for the comment</li>
</ol>
<p><img title="Comment Snippet" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.37.16.png" alt="Comment Snippet" /></p>
<p>The remaining values will be automatically added to the snippet when the code is inserted into the editor. Confirming the above screen will produce output similar to as shown below:</p>
<p><img title="Comment Snippet Inserted" src="/assets/uploads/2010/04/Screen-shot-2010-04-01-at-11.38.06.png" alt="Comment Snippet Inserted" /></p>
<h2>More samples for you</h2>
<p>I've been using snippets as much as I can over the last few months, and I have certainly noticed a reduction in time-spent on repetitive tasks and duplicate coding.</p>
<p>The benefit of using snippets is certainly one that can be noticed.</p>
<p>Below are a few of the snippets that I have created and use/have used. I'm adding them here so that others may use them, and save even more time by not having to write the snippets out themselves - hey, i'm nice like that.</p>
<p>You may notice that some of the snippets could be better optimised by including more select options here and there.. if you wish to change these to suit your needs, please feel free; that is why they have been added here.</p>
<p>Use them, love them, and if they save you some minutes coding, remember that minutes lead to hours... and if you end up hours ahead on your project, remember the monkeh and buy me a beer.</p>
<h4>cfcomponent snippet (with init method)</h4>
<p>In the component snippet, I ad written this to create not only the component tags but also the pseudo-constructor and the init method function tag blocks.</p>
<p>Notice the snippet placeholder $${Displayname} is used twice here; firstly in the displayname attribute of the cfcomponent tag, then in the hint attribute of the init function. The wizard only prompts for this variable once, and will use the value in every instance of the placeholder within the snippet.</p>
<pre class="html">&lt;cfcomponent
        displayname="$${Displayname}"
        output="$${Output:false|true}"&gt;

	&lt;cfset variables.instance = structNew() /&gt;

	&lt;cffunction name="init"
                access="$${Access:public|private|package|remote}"
                output="false"
                returntype="any"
                hint="I am the constructor method
                        for the $${Displayname} Class."&gt;

		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;</pre>
<h4>cffunction snippet</h4>
<pre class="html">&lt;cffunction name="$${Name}"
        access="$${Access:public|private|package|remote}"
        output="$${Output:false|true}" hint="$${Hint}"&gt;

&lt;/cffunction&gt;</pre>
<h4>cfargument snippet</h4>
<pre class="html">&lt;cfargument name="$${ParamName}"
        required="$${Required:true|false}"
        type="$${Type:String|Numeric|Boolean|XML|Any}" hint="$${Hint}" /&gt;</pre>
