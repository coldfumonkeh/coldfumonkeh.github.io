---
layout: post
title: jQuery GallerificPlus V0.4 Release
slug: gallerificplus-v04-release
date: 2009-09-21
categories:
- Components
- jQuery
tags:
- gallerificPlus
- jQuery
status: publish
type: post
published: true
---
<p>I am pleased to announce the launch of the latest version of the jQuery plugin, <a title="jQuery gallerificPlus" href="http://www.mattgifford.co.uk/projects/gallerificplus/">gallerificPlus</a>.</p>
<p>Following on from some fantastic comments and feedback from some users, I have added in the ability to set the image slideshow transitions to play as soon as the gallery is loaded.</p>
<p>By default, this is set to 'true' in the plugin. To disable the autoPlay, simply add one line to the gallery instantiation code within the HTML file, as below:</p>
<pre lang="java">var gallery = $('#gallery').galleriffic('#navigation', {
delay:                          2000,
numThumbs:                12,
imageContainerSel:       '#slideshow',
controlsContainerSel:    '#controls',
titleContainerSel:          '#image-title',
descContainerSel:        '#image-desc',
downloadLinkSel:         '#download-link',
fixedNavigation:            true,
galleryKeyboardNav:     true,
autoPlay:                     false
});</pre>
<p>There was also an issue with two of the selector classes within the plugin code that caused an incompatability issue with jQuery 1.3.2. This has also been addressed and now works with the previous jQuery versions as well as the latest.</p>
<p>The updated source code can be found on the <a title="jQuery gallerificPlus" href="http://www.mattgifford.co.uk/projects/gallerificplus/">gallerificPlus</a> projects page.</p>
