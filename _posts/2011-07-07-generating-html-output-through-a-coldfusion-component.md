---
layout: post
title: Generating HTML output through a ColdFusion Component
slug: generating-html-output-through-a-coldfusion-component
categories:
- ColdFusion
tags:
- CFC
- ColdFusion
status: publish
type: post
published: true
date: 2011-07-07
---
<p>I've been wrestling with a legacy application that I've inherited over the last month or so, and the more I look into it the more things I find that make me cringe.</p>
<p>The most frustrating of all is the fact that numerous CFCs are being used across the site to generate HTML output and content for the site. I'm not just talking a small link here or there, rather complete HTML tables, divs and everything else in between. One method I'm currently having to work with is almost 300 lines long and creates a full page worth of content to be output directly into the calling .cfm template. I'm not even going to mention the fact that these CFCs also call and reference the Application, Request and Session scopes (although I just did). Encapsulation, anyone?</p>
<p>I know my thoughts on generating such things using CFCs, but I wanted to open it up and see what you think. Should CFCs be used to create and output HTML? If so, how much? Should you be ok with creating links and small snippets, or do you think it's ok to create large chunks of HTML?</p>
<p>The floor is yours.. hit me with your nuggets of wisdom and opinion.</p>
