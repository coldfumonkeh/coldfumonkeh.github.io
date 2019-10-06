---
layout: post
title: Shortened CFML URLs via AlfredApp
slug: shortened-cfml-urls-via-alfredapp
categories:
- ColdFusion
- Projects
tags:
- Extensions'
- Workflow'
- ColdFusion
status: publish
type: post
published: true
date: 2012-01-30
---
<p>Since moving to using a Mac as my primary development machine I've been using the awesome <a title="Alfred App" href="http://www.alfredapp.com/" target="_blank">Alfred</a> App to help streamline my tasks, productivity and workflow thanks to the keyboard shortcuts. I find myself using these shortcuts constantly to open files, applications, find files, perform system operations and even run console sessions and commands.</p>
<p>One of the greatest things about <a title="Alfred App" href="http://www.alfredapp.com/" target="_blank">Alfred</a> is the ability to extend it's already packed functionality by creating your own extensions. This requires a <a title="Alfred Powerpack" href="http://www.alfredapp.com/powerpack/" target="_blank">Powerpack</a> licence (for a tiny cost of £15), which allows you to do so much more.</p>
<p>One of the services I've been using recently is the <a title="Visit cfml.us" href="http://cfml.us" target="_blank">cfml.us</a> URL shortening service, written by Tim Cunningham (<a title="TimCunningham71 on Twitter" href="https://twitter.com/TimCunningham71" target="_blank">@TimCunningham71</a>) - a superb URL service that really helps us to differentiate and create ColdFusion specific links for Twitter etc.</p>
<p>Using Alfred, I created a very simple extension that allows users to create a <a title="Visit cfml.us" href="http://cfml.us" target="_blank">cfml.us</a> shortened URL from their desktop. The generated short URL will then display in a Growl notification on the desktop, and will automatically be copied to the clipboard so you can paste it wherever you want to use it.</p>
<p>The extension works from a keyword / shortcut that Alfred uses to display the option: cfml.us</p>
<p><img title="cfml_us_01" src="/assets/uploads/2012/01/cfml_us_01.png" alt="" /></p>
<p>The syntax is really easy: cfml.us [URL to shorten]</p>
<p><img title="cfml_us_02" src="/assets/uploads/2012/01/cfml_us_02.png" alt="" /></p>
<p>This accepts one parameter which is the full URL you want to shrink</p>
<p>After a successful response you will get the Growl notification displaying the shortened URL and the URL added to your clipboard.</p>
<p><img title="cfml_us_03" src="/assets/uploads/2012/01/cfml_us_03.png" alt="" /></p>
<p>The extension is available to download from Github here:</p>
<p><a title="Alfred CFML.US Extension" href="https://github.com/coldfumonkeh/alfred-cfml.us-extension" target="_blank">https://github.com/coldfumonkeh/alfred-cfml.us-extension</a></p>
<p><a title="Download the extension" href="http://www.mattgifford.co.uk/shortened-cfml-urls-via-alfredapp/downloadextension" rel="attachment wp-att-3211" target="_blank"><img title="downloadextension" src="/assets/uploads/2012/01/downloadextension.png" alt="" /></a></p>
