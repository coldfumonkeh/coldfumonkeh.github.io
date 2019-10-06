---
layout: post
title: 'Rhea: ColdFusion Rackspace Cloud API CFC'
slug: rhea-rackspace-cloud-api
date: 2010-03-10
categories:
- ColdFusion
- Projects
tags:
- API
- CFC
- ColdFusion
status: publish
type: post
published: true
---
<p>Another day, another open-source ColdFusion API released to the community :)</p>
<p><a href="http://www.fuzzyorange.co.uk" target="_blank" title="Visit the Fuzzy Orange site">Fuzzy Orange</a> are pleased to announce the release of our first open-source project.</p>
<p>Codenamed Rhea, after the Greek mythologicial figure and mother of Gods and Godesses, the project has been a labour of love for the last few weeks, and one that I've certainly enjoyed developing.</p>
<h2>What is it?</h2>
<p>Naming conventions and codenames aside, Rhea is a ColdFusion CFC package developed specifically to interact with the <a href="http://www.rackspacecloud.com/" target="_blank" title="Visit the Rackspace Cloud site">Rackspace Cloud Server and Cloud Files</a> APIs.</p>
<p>Over at FO Towers, not only are we Rackspace partners, but we've been using the Rackspace Cloud services for some time. Having the ability to create a new server in literally seconds is amazing, and the option to store files remotely in custom directories (or 'Containers') using the Cloud Files system is fantastic.</p>
<p>Having spoken to other developers and reading through the documentation available, we noticed that although Rackspace provided bindings to support their API in many languages, there was no official ColdFusion binding.</p>
<p>Spotting the gap in the field and wanting to fill the void, Rhea was born.</p>
<h2>Bringing Rhea to life</h2>
<p>To try to make life easier and simpler for fellow developers and users of the project, Rhea has been developed to be as simple to use as possible. The only file that needs to be instantiated to start working with the object is rackspaceCloud.cfc.</p>
<p>This file acts as a facade (or Service Layer object) to the sub-components and underlying public-facing methods.</p>
<p>Instantiating the rackspaceCloud.cfc is incredibly easy, and only requires two parameters; the Rackspace account username and the API key.</p>
<pre name="code" class="html">
&lt;cffunction name="onApplicationStart" output="false"&gt;
	&lt;cfscript&gt;
		strcloudUser = '&lt;enter your cloud api username&gt;';
		strcloudKey  = '&lt;enter your cloud api key&gt;';

		Application.objRackspace = createObject('component',
		        'com.fuzzyorange.rackspaceCloud').
		        init(username=strcloudUser,apiKey=strcloudKey);

	&lt;/cfscript&gt;
&lt;/cffunction&gt;
</pre>
<p>Immediately after instantiation, the component runs an authentication method to verify and validate the user details against the API.</p>
<p>If unsuccessful, the API will throw a user-friendly error message and any further processing will abort. If your details are correct and authentication has been successful, you're ready to go and explore Rhea.</p>
<h2>One facade to rule them all...</h2>
<p><img title="cloudSofa" src="/assets/uploads/2010/03/cloudSofa.gif" alt="cloudSofa" /></p>
<p>As we are dealing with two separate API systems (Cloud Server and Cloud Files), access to the relevant methods for each is obtained through the main rackspaceCloud object.</p>
<p>This file invokes two new objects on run time to act as an interface to the relevant functions.</p>
<p>Although not strictly an Interface pattern in terms of true Object-Oriented Design, the two API interfaces are accessed using the code below:</p>
<pre name="code" class="java">
// store and persist the file interface
Application.objFiles = Application.objRackspace.fileInterface();
// store and persist the server interface
Application.objServer = Application.objRackspace.serverInterface();
</pre>
<p>Using the fileInterface() and serverInterface() methods from the main object, we are now storing and persisting the relevant objects in the Application scope for use throughout our site.</p>
<p>To access a Server-specific method for example, we would then call code similar to the following:</p>
<p>Application.objServer.<em>methodname(param1, param2...)</em>;</p>
<h3>What can we do with it?</h3>
<p>Quite a lot. Fact.</p>
<p>The official project download contains documentation outlining the installation and implementation of the CFC package, and also contains a comprehensive list of all methods available to interact with the Rackspace Cloud services, for both the server and file APIs.</p>
<p>Here's a brief summary of some of the functions available:</p>
<ul>
<li>Create a new server using custom images and flavors</li>
<li>Back up, restore, reboot and resize a server</li>
<li>Upload files to custom Containers</li>
<li>View and edit object meta data and contents</li>
</ul>
<p>Over the next few weeks, I'll be publishing some posts with code examples covering some of the methods available using Rhea, so make sure you bookmark the site and stay tuned for forthcoming posts.</p>
<p>We hope that you download, have a look through and use the project code. It's certainly changed the way we operate and deploy our files.<br />
Because of this, we developed the API to pass on the benefits to others in the community.</p>
<p>If you choose to implement or use the code, please feel free to let us know. We'd love to hear from you.</p>
<p>As always, time never stands still. We'll keep working on Rhea with updates and additions to constantly improve the code where possible and to ensure that you continue to get the best application available.</p>
<h2>Where can I get it?</h2>
<p>The Rhea project is available for download now from RIA Forge: <a title="Download Rhea from riaforge.org" href="http://rhea.riaforge.org/" target="_blank">http://rhea.riaforge.org/</a></p>
