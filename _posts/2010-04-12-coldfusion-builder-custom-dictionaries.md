---
layout: post
title: ColdFusion Builder Custom Dictionaries
slug: coldfusion-builder-custom-dictionaries
date: 2010-04-12
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
<p>Dictionaries.. wonderful things. Languages evolve over time, and the extensive range of words and vocabulary inevitably adapts to 'roll with the changes'. Without dictionaries assisting us, we run the risk of becoming reticent with our choice of vocabulary and to an extent our progress with our chosen language.</p>
<p>This can be true for any language, written or spoken.</p>
<h2>The CFML Language</h2>
<p>Take CFML, for example. As the years have passed and new versions of the programming language have been released, there have been enhancements and additions to each release to improve the language to cater for the requirements in the modern world.</p>
<p>And with every release, an updated reference or dictionary has been released to assist developers and to help us understand at a glance what changes have been made and what we can now do.</p>
<h3>Code Assist</h3>
<p>ColdFusion Builder ships with code / content assist functionality to assist with code completion and to help with remembering the attributes available for any tag or function - let's face it, there are a lot of them, and we all need prompting from time to time to refresh our memories.</p>
<p>CF Builder comes loaded with a dictionary for MX 7, 8 and of course ColdFusion 9.</p>
<p>You can access the editor to change the current dictionary in use by following these steps:</p>
<ul>
<li>Open up <strong>Window</strong> -&gt; <strong>Preferences</strong></li>
<li>In the tree list, navigate to <strong>ColdFusion</strong> -&gt; <strong>Editor Profiles</strong> -&gt; <strong>Editor</strong> -&gt; <strong>Code Assist</strong></li>
</ul>
<p>You will be presented with the following window and information:</p>
<p><img src="/assets/uploads/2010/04/codeAssist_Window.gif" alt="codeAssist_Window" title="codeAssist_Window" /></p>
<p>From the drop-down list you can change your selected dictionary to use within the editor for code assistance.</p>
<h3>But wait a minute..</h3>
<p>What's up?</p>
<h3>I'm using an engine which has different tags</h3>
<p>Ah, I see. So, you want to use the awesome-ness that is ColdFusion Builder AND adapt the dictionary so that you can use the code assist to help you with the extra tags and functions that you have access to?</p>
<p>Not a problem.</p>
<p>Each dictionary included with ColdFusion Builder is an XML file containing information about each tag and function in the library. As such, you can easily amend an existing dictionary or create your own to suit your requirements.</p>
<h2>Create a custom dictionary</h2>
<p>Firstly, you'll need to navigate to the location of the dictionaries within your ColdFusion Builder installation, within the plugins directory: <strong>\plugins\com.adobe.ide.coldfusion.dictionary_</strong><em><strong>XXX</strong></em><strong>\dictionary</strong></p>
<p>In my case, the directory was called '<strong>plugins\com.adobe.ide.coldfusion.dictionary_1.0.0.271911\dictionary</strong>'.</p>
<ol>
<li>Create a directory called 'Custom' within the Dictionary directory</li>
<li>Create an XML file to describe the custom tags and functions</li>
</ol>
<p>In this example, let's create an XML file to contain some dictionary references for the Railo tags and functions.</p>
<p>The basic structure of the XML file is as follows:</p>
<pre name="code" class="xml">
&lt;dictionary&gt;
    &lt;tags&gt;
        &lt;tag&gt;
			&lt;parameter&gt;
			&lt;/parameter&gt;
        &lt;/tag&gt;
    &lt;/tags&gt;
&lt;/dictionary&gt;
</pre>
<p>The root node is the <strong>dictionary</strong> element, and each <strong>tag</strong> node holds the description and attributes for the entry, wrapped by the <strong>tags</strong> node.</p>
<p>Let's add a sample entry for the cfvideoplayer tag.</p>
<p><strong>Custom/railo.xml</strong></p>
<pre name="code" class="xml">
&lt;?xml version="1.0" encoding="UTF-8"?&gt;
&lt;dictionary&gt;
    &lt;tags&gt;
		&lt;!--
		cfvideoplayer
			preview = "string"
			video = "string"
			thumbnails = "boolean"
		--&gt;

        <!--
        Set the details for the tag here; add the name attribute
        and the help content to be displayed in the prompt
        -->

		&lt;tag endtagrequired="false" name="cfvideoplayer"
			single="true" xmlstyle="false"&gt;
			&lt;help&gt;&lt;![CDATA[
				Play a video
				]]&gt;
			&lt;/help&gt;

            <!--
            The tag attributes are added here with the parameter nodes.
            Set the name, if required and type of attribute.
            Each parameter also allows for the help content
            which will again be displayed to the user.
            -->

			&lt;parameter name="preview" required="false" type="String"&gt;
				&lt;help&gt;&lt;![CDATA[
				The path of the preview image.
				]]&gt;&lt;/help&gt;
				&lt;values/&gt;
			&lt;/parameter&gt;
			&lt;parameter name="video" required="false" type="String"&gt;
				&lt;help&gt;&lt;![CDATA[
				The path to Movie File (flv/mp4).
				]]&gt;&lt;/help&gt;
				&lt;values/&gt;
			&lt;/parameter&gt;
			&lt;parameter name="thumbnails" required="false" type="boolean"&gt;
				&lt;help&gt;&lt;![CDATA[
				Use thumbnails in playlist or not.
				]]&gt;&lt;/help&gt;

                <!--
                In this boolean parameter, we can set the values
                for the user to select from, with a default option.
                -->

				&lt;values default="false"&gt;
                    &lt;value option="true" /&gt;
                    &lt;value option="false" /&gt;
                &lt;/values&gt;
			&lt;/parameter&gt;
		&lt;/tag&gt;
	&lt;/tags&gt;
&lt;/dictionary&gt;
</pre>
<p>Although not a complete entry for the cfvideoplayer tag, here we have defined the tag in the dictionary and added in three of the attributes available for it.</p>
<p>Ideally, the help nodes should be as complete as possible for every step to assist the user with information on every tag and attribute available.</p>
<p>The concept of adding functions to the dictionary is exactly the same, with the small but hopefully obvious amendment of using a <strong>functions</strong> node instead of the tags node.</p>
<pre name="code" class="xml">
&lt;functions&gt;
        &lt;function name="abs" returns="Numeric" &gt;
            &lt;help&gt;&lt;![CDATA[
        Absolute-value function. The absolute value of a number is
        the number without its sign.
    ]]&gt;&lt;/help&gt;
            &lt;parameter name="number" required="true" type="Numeric"&gt;
                &lt;help&gt;&lt;![CDATA[
        ]]&gt;&lt;/help&gt;
            &lt;/parameter&gt;
        &lt;/function&gt;
&lt;/functions&gt;
</pre>
<h4>Setting attribute combinations</h4>
<p>The dictionaries also contain extra nodes and elements to assist with code writing.</p>
<p>For any tags that contain attributes dependant on another, you can use the <strong>possiblecombinations</strong> node, including combinations within.</p>
<p>The following example here is taken from the cfmessagebox entry in the CF9 dictionary. The possiblecombinations node is placed immediately after the final parameter node before the closing tag node.</p>
<pre name="code" class="xml">
&lt;possiblecombinations&gt;
    &lt;combination attributename="name"&gt;
        &lt;required&gt;name,type&lt;/required&gt;
        &lt;optional&gt;callback,labelcancel,labelno,labelok,
						labelyes,message,multiline,title&lt;/optional&gt;
    &lt;/combination&gt;
    &lt;combination attributename="type"&gt;
        &lt;required&gt;name,type&lt;/required&gt;
        &lt;optional&gt;callback,labelcancel,labelno,labelok,
						labelyes,message,multiline,title&lt;/optional&gt;
    &lt;/combination&gt;
&lt;/possiblecombinations&gt;
</pre>
<h2>Loading the dictionary</h2>
<p>So, you've written your custom dictionary to include tags and functions for your CFML engine of choice. You now need to load the dictionary into ColdFusion Builder for use in the editor.</p>
<p>Firstly, the dictionary needs to be included into the dictionaryconfig.xml file. This lives in the same dictionary directory and contains the names and paths to the dictionaries loaded into ColdFusion Builder.</p>
<p>Open this file in your text editor of choice and add the following:</p>
<pre name="code" class="xml">
&lt;dictionary_config&gt;

	&lt;dictionary id="CF_DICTIONARY"&gt;
		&lt;version key="ColdFusion9" label="ColdFusion 9"&gt;
            &lt;grammar location="cf9.xml" /&gt;

        &lt;/version&gt;

		&lt;version key="ColdFusion8" label="ColdFusion 8"&gt;
			&lt;grammar location="cf8.xml" /&gt;

		&lt;/version&gt;

		&lt;version key="ColdFusionMX7" label="ColdFusion MX 7"&gt;
			&lt;grammar location="cfml7.xml" /&gt;

		&lt;/version&gt;

		&lt;!--
		add the RailoSample dictionary. Set a name
		and include the location to the file
		--&gt;

		&lt;version key="RailoSample" label="Railo Sample"&gt;
			&lt;grammar location="Custom/railo.xml" /&gt;

		&lt;/version&gt;

	&lt;/dictionary&gt;


	&lt;dictionary id="SQL_DICTIONARY"&gt;
		&lt;version key="mssql" label="Microsoft(R) SQL Server"&gt;
			&lt;grammar location="sqlkeywords.txt" /&gt;
		&lt;/version&gt;
	&lt;/dictionary&gt;


&lt;/dictionary_config&gt;
</pre>
<p>You can see from the config file that ColdFusion Builder also loads in a SQL dictionary for MS SQL. This is worth noting if you wanted to include your own DB dictionary or amend the included file.</p>
<p>Ok, the dictionaryconfig.xml file is now aware of our new custom dictionary. Navigate your way to the Code Assist menu in Preferences once more:</p>
<ul>
<li>Open up <strong>Window</strong> -&gt; <strong>Preferences</strong></li>
<li>In the tree list, navigate to <strong>ColdFusion</strong> -&gt; <strong>Editor Profiles</strong> -&gt; <strong>Editor</strong> -&gt; <strong>Code Assist</strong></li>
</ul>
<p>Directly beneath the drop-down dictionary list, click the 'Reload Dictionaries' button. You may need to restart ColdFusion Builder for it to pick up on the new XML file created in the directory.</p>
<p><img src="/assets/uploads/2010/04/codeAssist_Window_Railo.gif" alt="codeAssist_Window_Railo" title="codeAssist_Window_Railo" /></p>
<p>Once the dictionary is visible in the list, select your new file and you're ready to start coding in the editor.</p>
<p><img src="/assets/uploads/2010/04/cfvideoplayer_hint.gif" alt="cfvideoplayer_hint" title="cfvideoplayer_hint" /></p>
<p>You can see that the new dictionary is in use and hinting the tags we have entered in, complete with hint pop ups.</p>
<p><img src="/assets/uploads/2010/04/cfvideoplayer_attribute_hint.gif" alt="cfvideoplayer_attribute_hint" title="cfvideoplayer_attribute_hint" /></p>
<p>The attributes are also working nicely and providing reminders for us as well.</p>
<h2>What does this all mean?</h2>
<p>In essence, this means that any CFML developer, regardless of their chosen / preferred engine is able to use ColdFusion Builder to optimise their workflow and enhance their applications.</p>
<p>The ability to create custom dictionaries is incredibly clever and ensures that ALL CFML developers have the same abilities with the development tools on offer.</p>
