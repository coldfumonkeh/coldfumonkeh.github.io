---
layout: post
title: Cannot load 32-bit SWT libraries on 64-bit JVM
slug: cannot-load-32-bit-swt-libraries-on-64-bit-jvm
categories:
- Development
tags: []
status: publish
type: post
published: true
date: 2011-06-10
---
<p>I've been doing a little application maintenance today and restoring my standalone version of ColdFusion Builder 2, making sure it has all of the Eclipse plugins and extras that I use on a daily basis.</p>
<p>I fell foul of a common issue that although I've dealt with before, still took a few minutes to recall the solution and resolve the problem. As such I've posted here for my own sanity and to help any others who may stumble into the same situation.</p>
<p>After running an ANT task on one my ColdFusion projects, I received the following error:</p>
<p>"<strong>Cannot load 32-bit SWT libraries on 64-bit JVM</strong>"</p>
<p>Essentially, this indicates a clash between the java library used by the plugin and the JVM used by the machine.</p>
<p>The fix is a simple one. Open the installed JRE window via the Properties menu: <strong>Eclipse -&gt; Preferences -&gt; Java -&gt; Installed JRE</strong></p>
<p>(the menu options may differ slightly between various versions of Eclipse or Eclipse-based applications)</p>
<p><img title="Installed JRE within Eclipse / ColdFusion Builder 2" src="/assets/uploads/2011/06/eclipse_JVM_preferences.png" alt="Installed JRE within Eclipse / ColdFusion Builder 2" /></p>
<p>With the default JRE selected, hit the Edit button to proceed to the next window.</p>
<p><img title="Edit the JRE in Eclipse / ColdFusion Builder 2" src="/assets/uploads/2011/06/edit_JVM_preferences.png" alt="Edit the JRE in Eclipse / ColdFusion Builder 2" /></p>
<p>Alter the Default VM Arguments field by adding <strong>-d32</strong>, which ensures that the 32-bit JVM is used instead of the 64. This should remove the error and you can continue as normal.</p>
<p>My ANT build is now back to working as expected with a little tweak to the JVM definition. Good times.</p>
