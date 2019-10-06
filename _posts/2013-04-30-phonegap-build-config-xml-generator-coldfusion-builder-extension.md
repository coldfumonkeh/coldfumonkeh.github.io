---
layout: post
title: PhoneGap Build Config.xml Generator ColdFusion Builder Extension
slug: phonegap-build-config-xml-generator-coldfusion-builder-extension
categories:
- ColdFusion
- ColdFusion Builder
- Projects
tags:
- Builder
- ColdFusion
- PhoneGap
status: publish
type: post
published: true
date: 2013-04-30
---
<p>This is a post that I started writing in October 2012 (around the time when this project was officially released into the great wide open), but alas it's taken me this long to complete it. Yes, I've been busy.</p>
<p>I build PhoneGap applications - I love it, and have even written a <a title="PhoneGap Mobile Application Development Cookbook" href="http://www.packtpub.com/phonegap-mobile-application-development-cookbook/book" target="_blank">book on it</a> (blatant plug). My main IDE is ColdFusion Builder. It does everything I need, and as it's based on Eclipse I can easily update and extend it with plugins for any extra functionality.</p>
<p>One of the beautiful features of ColdFusion Builder is the ability to create your own plugins written in ColdFusion, running locally on the server. Magic stuff.</p>
<p>As a PhoneGap developer and a heavy user of the <a title="http://build.phonegap.com" href="http://build.phonegap.com" target="_blank">PhoneGap Build</a> service, I wanted to streamline my workflow a little. The PG Build service needs a config.xml file included in the code to provide application details (version number, name etc) as well as icon and splash screen image references (and much more). XML is great, but writing and managing a number of config.xml files had the potential to become cumbersome and prone to errors.</p>
<p>To remedy this, I built a ColdFusion Builder extension that allows me (and YOU!) to easily generate a config.xml file to use in your PhoneGap Build project.</p>
<p>You can download the extension from <a title="http://phonegapbuild.riaforge.org/" href="http://phonegapbuild.riaforge.org/" target="_blank">phonegapbuild.riaforge.org</a>, and install it into ColdFusion Builder as you would with any extension.</p>
<p>Once installed, you will have a new option in the context-menu when you right-click on a project / directory in the navigator view panel. This will ultimately generate the config.xml file into the directory you have selected, so make sure you click on the root folder for your PhoneGap application:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_menu.png"><img alt="pg_ext_menu" src="/assets/uploads/2013/04/pg_ext_menu.png" /></a></p>
<p> Select the option to "Generate Config.xml", which will load up the generation wizard in an overlay window:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_ui.png"><img alt="pg_ext_ui" src="/assets/uploads/2013/04/pg_ext_ui.png" /></a></p>
<p>As you can see, there are a lot of options in the left-hand menu, all of which relate specifically to configuration values that you can set into the .xml file.</p>
<p>There are a few values that are required for the build service to accept and read the file properly. Any required fields will quickly display user-friendly messages if they have left blank after focus. If you attempt to save the file without any of these required fields, it will also prompt you to complete them. Each option also has a help hint to the right, which will display a (hopefully) helpful message to the user to explain what it is:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_required_fields.png"><img alt="pg_ext_required_fields" src="/assets/uploads/2013/04/pg_ext_required_fields.png" /></a></p>
<p>Working with icons and splash images is also incredibly easy. The extension has a separate tab for each platform, which each available image size for reference. Simply select to upload an image into that particular image "slot", and it will upload it to the project directory. When it does so, it will also rename each image file with a specific file name for that operating system / mobile platform, and it will separate the images into platform directories for ease of use:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_images.png"><img alt="pg_ext_images" src="/assets/uploads/2013/04/pg_ext_images.png" /></a></p>
<p>One of the features available is the ability to specify access to specific domains and subdomains, or allow global access to external resources. The extension really helps to simplify this. By default all external access is restricted:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_domains.png"><img alt="pg_ext_domains" src="/assets/uploads/2013/04/pg_ext_domains.png" /></a></p>
<p> Change the option to "false" and a pop-up window will display to let you specify your access rules:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_add_domain.png"><img alt="pg_ext_add_domain" src="/assets/uploads/2013/04/pg_ext_add_domain.png" /></a></p>
<p>Once added, they will be visible to delete if required. You can now add as many access permissions as you need to:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_domain_added.png"><img alt="pg_ext_domain_added" src="/assets/uploads/2013/04/pg_ext_domain_added.png" /></a></p>
<p>Once you have finished defining the values in the wizard, click the rather large but friendly "Save File" button, which will generate the populated config.xml file for you in the location of the directory originally selected to open the wizard:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_generated_01.png"><img alt="pg_ext_generated_01" src="/assets/uploads/2013/04/pg_ext_generated_01.png" /></a></p>
<p> ColdFusion Builder will also automatically open the freshly-created file for you in the editor:</p>
<p><a href="/assets/uploads/2013/04/pg_ext_generated.png"><img alt="pg_ext_generated" src="/assets/uploads/2013/04/pg_ext_generated.png" /></a></p>
<p> You may want to edit an existing configuration file that you have generated. That's easy to do using this extension. Simply select the "Generate Config.xml" menu option once more. The extension will first determine if an .xml file already exists in that location. If it does, it will give you the option to load that file, which will populate all of the wizard values and options from the file. Make your changes and save the file to update the values. Simple.</p>
<p>At the moment the extension is missing the ability to select which (if any) of the available plugins offered through PhoneGap Build you can use in your project. That will be available in a future update.</p>
<p>I use this extension a lot. It saves a lot of time generating required config.xml files for my PhoneGap Build projects, and I hope that it can help you too.</p>
<p>&nbsp;</p>
