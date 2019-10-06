---
layout: post
title: ColdFusion Builder Beta 3 Upgrade Issues
slug: coldfusion-builder-beta-3-upgrade-issues
date: 2009-12-21
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
<p><span>This morning I upgraded my installation of <span>ColdFusion</span> Builder to use the new Beta 3 release.</span></p>
<p><span>Eclipse is my main development IDE. It's streamlined the way I work, and having the ability to switch between SVN management, Flex/AIR development, <span>ColdFusion</span> development and much more within the same IDE window is superb. As such, I run <span>ColdFusion</span> Builder as a <span>plugin</span> into Eclipse.</span></p>
<p><span>Upgrading to Beta 3 hit a small issue, and viewing ANY .<span>cfc</span> or .<span>cfm</span> file in <span>ColdFusion</span> Builder was throwing the following error alert:</span></p>
<p><a href="/assets/uploads/2009/12/eclipse_Coldfusion_Builder_Beta3_Install_Errors.jpg"><img title="eclipse_Coldfusion_Builder_Beta3_Install_Errors" src="/assets/uploads/2009/12/eclipse_Coldfusion_Builder_Beta3_Install_Errors.jpg" alt="Coldfusion Builder Beta3 Install Errors" /></a></p>
<p>The error was related to com/adobe/rds/client/eclipse/debugger/ui/model/CFMLLineBreakAdapter, and would throw as soon as any ColdFusion file was active in the IDE. A major pain, especially if you are flicking between multiple tabs of CF pages.</p>
<p>The <a title="Upgarding to ColdFusion Builder Beta 3 on Windows" href="http://help.adobe.com/en_US/ColdFusionBuilder/Installing/WS0ef8c004658c108926f4c3db1249e52277c-7fe9.html" target="_blank">installation instructions</a> were followed to the letter, two or three times, so I was a little puzzled.</p>
<p><span>After <span>uninstalling</span> the Beta version again, I looked in the 'eclipse-&gt;plugins' directory, and noticed that most if not all of the <span>ColdFusion</span>-related <span>plugins</span> (com.adobe.<span>ide</span>.<span>coldfusion</span>.***) were still there - this included the new Beta 3 and the old Beta 2 <span>plugis</span>.</span></p>
<p><span>I deleted and removed these from the directory, and ran the installer again. This time around, the installation was a perfect success, no alert messages. I can only assume that the residual CF-related <span>plugins</span> were causing conflicts with the new <span>plugins</span> from the Beta 3 upgrade. Removing them all and starting again worked.</span></p>
<p>Thanks to <a title="Paul Kukiel's Blog" href="http://blog.kukiel.net/" target="_blank"><span>Paul <span>Kukiel</span></span></a><span> for letting me use his screen shot (above). I was lacking <span>caffiene</span> too much to obtain my own at that time. Thanks Paul.</span></p>
<p>Related links:</p>
<p><span>Adobe <span>ColdFusion</span> Builder  - </span><a title="Adobe - installing.upgrading to ColdFusion Builder Beta 3" href="http://help.adobe.com/en_US/ColdFusionBuilder/Installing/WS0ef8c004658c108926f4c3db1249e52277c-8000.html" target="_blank">installing/upggrading to Beta 3</a></p>
