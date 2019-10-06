---
layout: post
title: RIAForge project link Wordpress shortcode plugin
slug: riaforge-project-link-wordpress-shortcode-plugin
categories:
- Development
tags:
- plugin
- Wordpress
status: publish
type: post
published: true
date: 2011-07-08
---
<p>I've created a very simple Wordpress plugin that makes use of the awesome shortcode API to generate content within the editor.</p>
<p>In this case, I wanted something to automatically generate a link to a specific project page on RIAForge. When I release open source projects on the site, I always link to the product page on RIAForge, manually typing the link every time. Although that's no massive loss of time, but any savings are certainly welcome.</p>
<p>The plugin simply accepts the id of the specific project you want to link to as an attribute within the shortcode, so placing something like so in the editor:</p>
<p><img title="riaforge_shortcode_1" src="/assets/uploads/2011/07/riaforge_shortcode_1.png" alt="" /></p>
<p>will generate and render the following URL when someone views the page:</p>
<p><img title="riaforge_shortcode_2" src="/assets/uploads/2011/07/riaforge_shortcode_2.png" alt="" /></p>
<p>Simple in nature and function, it may be something I expand over time and add in an admin interface, but for now this will certainly be a massive timesaver for me (and hopefully others too).</p>
<pre name="code" class="php">
&lt;?php
/*
Plugin Name: riaforge Shortcode Generator
Description: This plugin obtains information and generates a
			link to a specific project on riaforge using the
            ID as an attribute in the shortcode.
            For example: [riaforge projectid="100"]
Version: 0.1
License: GPL
Author: Matt Gifford aka coldfumonkeh
Author URI: http://www.mattgifford.co.uk
*/

/* 	add the filter to allow the
	shortcode to run in our widgets
*/
add_filter('widget_text', 	'do_shortcode');

function getProjectInfo($atts, $content=null) {
		// Our shortcode attributes and default values
		extract(shortcode_atts(array(
			"projectid"		=&gt; ''
		), $atts));
		// Build the URL for the get request
		$strURL 	= 	'http://www.riaforge.org/boltapi/api.cfc?
        				method=getProject&id='.
						$projectid .'&returnFormat=json';
		// Run the get request
		$json 		= wp_remote_get($strURL);
		// get the array of data from the response
		$array 		= json_decode($json['body']);
		$jsonData	= $array-&gt;DATA;

		// Build the HTML tag to return
		return '&lt;a href="http://'. $jsonData[0][4] .'.riaforge.org"
				target="_blank"
				title="Download '. $jsonData[0][1] .' from RIAForge.org"&gt;
				Download '. $jsonData[0][1] .' from RIAForge.org&lt;/a&gt;';
}

add_shortcode('riaforge', 'getProjectInfo');

?&gt;
</pre>
<p>Shortcodes are a superb addition to Wordpress (since version 2.5) and can transform the simplest thing into an automatic process. Superb!</p>
