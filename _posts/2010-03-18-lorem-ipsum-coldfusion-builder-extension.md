---
layout: post
title: Lorem Ipsum ColdFusion Builder Extension
slug: lorem-ipsum-coldfusion-builder-extension
date: 2010-03-18
categories:
- ColdFusion
- ColdFusion Builder
- Projects
tags:
- Adobe
- Builder
- ColdFusion
status: publish
type: post
published: true
---
<p>ColdFusion Builder is an incredibly powerful tool, and the ability to extend the IDE with custom-written extensions enhances the power of the application.</p>
<h2>The Requirement</h2>
<p>Whilst working on some site content earlier, a few pages were still waiting for new copy to be written. As a typical fallback plan, I added in some dummy text to fill the void - I normally visit the official <a title="Visit the lipsum.com" href="http://www.lipsum.com/" target="_blank">www.lipsum.com</a> site to generate the required dummy text for me, then copy and paste it into my editor.</p>
<p>As a ColdFusion Builder user, I wondered if there was an extension available to work with Lipsum data, to help alleviate the repetitive task of cut/copy and paste (or simply hammering the keyboard to generate random nonsense).</p>
<p>After having a quick search on riaforge.org (the first place every developer should check before starting development on a plugin or component package from scratch), I noticed there wasn't a ColdFusion Builder extension available to automatically generate the dummy text.</p>
<h2>The Solution</h2>
<p>There was, however, a CFC called <a title="Download CFLipsum from riaforge.org" href="http://cflipsum.riaforge.org/" target="_blank">CFLipsum</a> developed by <a title="Visit Tim's site" href="http://tim.bla.ir/" target="_blank">Tim Blair</a> that interacted with the lipsum.com XML feed to generate the dummy text. Tim's CFC did a fantastic job as a self-contained component package.</p>
<p>Using Tim's CFC as a starting point (you have to love the CF community and sharing code), I developed a quick but fully functioning CF Builder extension that will insert the generated dummy text directly into the code editor window at the current position of the cursor.</p>
<p>Once installed, the extension is accessible by right-clicking anywhere within the editor window and selecting the 'Lipsum Generator' menu option:</p>
<p><img title="lipsumGen_contextMenu" src="/assets/uploads/2010/03/lipsumGen_contextMenu.gif" alt="lipsumGen_contextMenu" /></p>
<p>At this point, the user will be shown an option screen to choose how they want the dummy text returned:</p>
<p><img title="lipsumGen_optionMenu" src="/assets/uploads/2010/03/lipsumGen_optionMenu.gif" alt="lipsumGen_optionMenu" /></p>
<p>The first option, a simple boolean 'yes'/'no' selection, lets the user decide if they would like the returned text to start with the traditional 'Lorem Ipsum...'. Purely cosmetic, but for those who cannot bear to be without those two words, this option is for you. :)</p>
<p>The second option lets you choose in which format you would like the returned text;</p>
<ul>
<li>words</li>
<li>paragraphs</li>
<li>bytes</li>
</ul>
<p>Option three then lets you choose either how many words or paragraphs to return, or if 'bytes' was selected in the previous option, how many bytes of text to be returned.</p>
<p>Finishing the selection and clicking 'ok', the extension will then insert the text directly into the editor window, complete with &lt;p&gt; tags:</p>
<p><img title="lipsumGen_addedText" src="/assets/uploads/2010/03/lipsumGen_addedText.gif" alt="lipsumGen_addedText" /></p>
<p>A simple extension, but one that I hope will help others along the way. It's effective, saves time, and built in ColdFusion, so it must be good. Right? Right!</p>
<h2>Where can I get it from?</h2>
<p>The Lipsum Generator extension is available to download now from RIA Forge:</p>
<p><a href="http://lipsum.riaforge.org/">http://lipsum.riaforge.org/</a></p>
