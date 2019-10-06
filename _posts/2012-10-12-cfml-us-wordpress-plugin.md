---
layout: post
title: cfml.us Wordpress Plugin
slug: cfml-us-wordpress-plugin
categories:
- ColdFusion
tags:
- API
- ColdFusion
- plugin
- Wordpress
status: publish
type: post
published: true
date: 2012-10-12
---
<p>I'm a Wordpress user, and have been for as many years as I've been developing (which is a lot, now that I think about it..man, I feel old sometimes). However, I'm primarily a ColdFusion developer, and always want to share the CF love whenever possible.</p>
<p>I developed a simple Wordpress plugin that uses the <a title="Visit cfml.us" href="http://cfml.us" target="_blank">cfml.us</a> URL shortening service written by <a title="Visit cfmumbojumbo.com" href="http://cfmumbojumbo.com/" target="_blank">Tim Cunningham</a> which will automatically create and store a shortened URL for your pages and posts.</p>
<h2>How to..</h2>
<p>Installation of the plugin is simple. Download the .zip file and upload it into your Wordpress plugin repository (either FTP or via the admin interface) and activate it.</p>
<p>There are two methods of use.</p>
<p>The first is as a shortcode, which can be used within the content editor for any page or post.</p>
<p>The default shortcode is as follows:</p>

```
[cfmlus_link]
```

<p>This will use the default title / lead text and output the link like so:</p>

```
Short URL: <a href="http://cfml.us/Mf" class="">http://cfml.us/Mf</a>
```

<p>We can override this a little and specify a different lead text (or nothing at all) and provide a class name for the link using the inline attributes:</p>

```
[cfmlus_link title="Any other title here" class="my_link_class"]
```

<p>The second option is to set a function directly within your template code to output the link wherever you want to:</p>

```
<?php show_cfmlus_link(); ?>
```

<h2>Saved and Stored</h2>
<p>When a new URL is generated for the parent page using the plugin, the shortened URL is saved as a custom post meta value. This removes any possible issues with duplicate URLs being generated for the same long URL, and it only needs to be created once.</p>
<h2>Grab it</h2>
<p>The code is available to download from Github now: <a title="Download the cfml.us Wordpress plugin" href="https://github.com/coldfumonkeh/cfml.us-Wordpress-plugin" target="_blank">https://github.com/coldfumonkeh/cfml.us-Wordpress-plugin</a></p>
<p>If you're a Mac user and have <a title="Visit Alfred App" href="http://www.alfredapp.com/" target="_blank">Alfred App</a> installed (with powerpack) you can also use my <a title="Shortened CFML URLs via AlfredApp" href="http://www.mattgifford.co.uk/shortened-cfml-urls-via-alfredapp" target="_blank">cfml.us extension</a> there to create shortened URLs, copied directly to your clipboard.</p>
