---
layout: post
title: ColdFusion Builder Server Management
slug: coldfusion-builder-server-management
date: 2010-01-27
categories:
- ColdFusion
- ColdFusion Builder
tags:
- Adobe
- Bolt
- ColdFusion
status: publish
type: post
published: true
---
<p>This is a post I've had stored in my blog drafts since <a title="ColdFusion Builder on Adobe Labs" href="http://labs.adobe.com/technologies/coldfusionbuilder/" target="_blank">ColdFusion Builder</a> was first released in Beta. I apologise, I should have had it posted by now.</p>
<p>ColdFusion developers the world over have been asking Adobe for a ColdFusion specific IDE for some time now, and Adobe responded accordingly with ColdFusion Builder (originally codenamed 'Bolt' for those who didn't know).</p>
<p>A dedicated IDE catering for CF needs, ColdFusion Builder (although still in Beta) has proven to be a fantastic resource for development. Built to use the already superb Eclipse IDE (which most developers are either aware of or use) CF Builder has opened up the possibilities and options available when developing ColdFusion applications.</p>
<p>There are two ways you can install ColdFusion Builder:</p>
<ol>
<li>As a standalone development product</li>
<li>As a plugin to be used in an existing Eclipse installation</li>
</ol>
<p>You can download ColdFusion Builder (currently Beta 3) from the <a title="ColdFusion Builder on Adobe Labs" href="http://labs.adobe.com/technologies/coldfusionbuilder/" target="_blank">Adobe Labs</a> site.</p>
<p>I typically use the plugin option - I have Eclipse already installed with my SVN respositories, Subclipse, Flex Builder plugin and more, and so for me the addition of one more plugin not only simplifies my workspace, layout and time-management, but also ensures I only have one place to go for any of my development requirements.</p>
<p>In this tutorial, I'll guide you through setting up a ColdFusion server instance within CF Builder, allowing the developer to access and manage the server and the ColdFusion administrator from within the IDE, and also creating a new ColdFusion project, mapping to the server to allow for real-time CF output within the workspace. Let's get started!</p>
<h2>Open up the Server view</h2>
<p>In the Eclipse/ColdFusion Builder menu, go to <strong>Window &gt; Show View &gt; Servers</strong>.</p>
<p><a href="/assets/uploads/2009/11/Access-Server-View.png"><img title="Access Server View" src="/assets/uploads/2009/11/Access-Server-View.png" alt="Access Server View" /></a></p>
<p style="text-align: left;">This will open up the Servers tab (as shown in the next screenshot). A major benefit of using an Eclipse-based IDE is that the panels and windows can be moved around the workspace, allowing you to to customise your screen space and optimise how you like to work.</p>
<p style="text-align: left;">Feel free to drag the panel around the workspace to a position that best suits you. Alternatively, you can always minimise and maximise them as and when you choose.</p>
<p>
<p><a href="/assets/uploads/2009/11/Add-New-CF-Server.png"><img title="Add New CF Server" src="/assets/uploads/2009/11/Add-New-CF-Server.png" alt="Add New CF Server" /></a></p>
<h2 style="text-align: left;">Adding a Server</h2>
<p style="text-align: left;">Let's add a ColdFusion server to the Server panel. Click on the first icon in the toolbar menu (at the top of the panel), and select 'Connect to ColdFusion Server', which will open up the 'New ColdFusion Server Setup' dialog window.</p>
<p><a href="/assets/uploads/2009/11/New-CF-Server-Setup-1.png"><img title="New CF Server Setup Step 1" src="/assets/uploads/2009/11/New-CF-Server-Setup-1.png" alt="New CF Server Setup Step 1" /></a></p>
<p style="text-align: left;">From this window, we start the near effortless task of adding a server to the workspace. Let's run through the steps and details for each entry.</p>
<h3>General Settings</h3>
<div>
<ul>
<li>Server Name: The ColdFusion server name.<span style="color: #000000;"> (eg mattgifford)</span></li>
<li>Description: Enter a description of the server. I typically write the server name, local or remote, and version of ColdFusion (eg mattgifford local CF9)</li>
<li>
<div>
<p>Application Server:  If you are using a JRun installation, select JRun. If you are using the built-in development server or any other server, select 'Other' from the dropdown.  ColdFusion Builder allows you to start, stop or restart your server if it is a JRun instance (once the server has been added). This option will not be available if you do not use a JRun instance.</p>
</div>
</li>
<li>Host Name: The name of the ColdFusion server host. For example, localhost, 127.0.0.1 or perhaps dev.mattgifford.co.uk (if using virtual hosts in an apache setup, for example).</li>
<li>Ensure the 'Is Local' option is selected, as at this point we are only adding local servers.</li>
</ul>
</div>
<h3>Other Settings</h3>
<div>
<ul>
<li>Webserver Port: Specify the port number of the ColdFusion server instance you  are configuring. By default, the port number is 8500.</li>
<li>Context root:<span style="color: #ff0000;"> (applicable only for JRun servers with J2EE configuration)</span> Enter the context root. The J2EE environment supports multiple, isolated web  applications running in a server instance. Hence, J2EE web applications running  in a server are each rooted at a unique base URL, called a context root (or  context path). For example, '/cfusion' or '/' if the context root was cleared during JRun installation.</li>
<li>Application Server Name:<span style="color: #ff0000;"> (applicable only for JRun servers with J2EE  configuration)</span> Name of the JRun Server on which ColdFusion is deployed. This will relate the server name in the JRun Management Console.</li>
<li>RDS User Name: If you are using RDS, specify the RDS user name.</li>
<li>RDS Password: Specify the RDS password.
<div>
<div>Note: You set the RDS password in  the ColdFusion Administrator. The RDS password is not the same as the ColdFusion aministrator password.</div>
</div>
</li>
<li>Select the Enable SSL option to enable SSL support in ColdFusion Builder.  Servers registered in the Server Manager can communicate using SSL.</li>
<li>Select Auto Start and Auto Stop options to automatically start and stop the  ColdFusion server every time you launch and exit ColdFusion Builder.</li>
</ul>
<p>Click Next to proceed.</p>
</div>
<p><a href="/assets/uploads/2009/11/New-CF-Server-Setup.png"><img title="New CF Server Setup Step 2" src="/assets/uploads/2009/11/New-CF-Server-Setup.png" alt="New CF Server Setup Step 2" /></a></p>
<h3>Local Server Settings</h3>
<div>
<p>Select the Local Server Settings tab, and specify the following local server  settings, as applicable.</p>
<ul>
<li>Server Home: <span style="color: #ff0000;">(applicable only for JRun servers)</span> Browse and select the ColdFusion Server home directory. For example, C:/ColdFusion9/ for a standalone ColdFusion server instance. For a multiserver instance, the server home is the Application Server Home directory, for example, C:\JRun4 for a JRun-J2EE or multiserver configuration.</li>
<li>Document Root: Browse and select the webroot location. If ColdFusion is configured with a web server, say IIS, then select the document root of the web server; for example, c:\inetpub\wwwroot.This setting is required for previewing, debugging, and CFC name resolution in ColdFusion Builder.</li>
<li>Version: <span style="color: #ff0000;">(applicable only for JRun servers)</span> Select the ColdFusion server  version from the Version drop-down list.</li>
<li>Windows Service: <span style="color: #ff0000;">(applicable only for JRun servers)</span> The Windows Service option is available only for standalone and multi-server configurations, and not J2EE configuration. If you want to start and stop the ColdFusion server using the Windows Service, select Use Windows Service To Start/Stop Server.</li>
</ul>
</div>
<p><a href="/assets/uploads/2009/11/Server-Local-Settings.png"><img title="Server Local Settings" src="/assets/uploads/2009/11/Server-Local-Settings.png" alt="Server Local Settings" /></a></p>
<h4>URL Prefix</h4>
<div>
<p>This task is optional. You don’t necessarily have to specify a URL when creating a server. You can specify a URL prefix even after creating the server by editing the server settings in the Servers view.</p>
<p>Select the URL Prefix tab and enter the following details:</p>
<ol>
<li>Local Path: Browse to or enter the path to the local file system  resource.</li>
<li>URL prefix: Enter the URL prefix.</li>
<li>Click Add.<a href="/assets/uploads/2009/11/Server-URL-Prefix.png"><img title="Server URL Prefix" src="/assets/uploads/2009/11/Server-URL-Prefix.png" alt="Server URL Prefix" /></a></li>
</ol>
</div>
<h4>Virtual Host Settings</h4>
<div>
<p>This is an option. You do not need to specify any virtual host details in ColdFusion Builder when setting up your server.</p>
<p>If you do supply virtual host information, please be aware that ColdFusion Builder does not validate these settings. Therefore, if you enter details here that do not match those set up on your web server, ColdFusion Builder will not inform you of any errors.</p>
<p>To configure a virtual host, select the Virtual Host Settings tab, and do the  following:</p>
<ol>
<li>Click New and enter the following details in Virtual Host Settings  section.
<ol type="a">
<li>
<div>
<p>Name: Specify a name for the virtual host. For example, vhost1. You can provide any name and  not necessarily the name that you provide in the web server.</p>
</div>
</li>
<li>Host Name: The virtual host name as specified in your IIS or Apache web server settings. For example, dev.mattgifford.co.uk. When you create a virtual host in ColdFusion Builder, the virtual host uses a naming convention <em>server name</em>-<em>virtual host name</em>. The Server drop-down list in Project properties displays the virtual host name using this naming convention. For example, if you created a virtual host named "vhost1" in your ColdFusion server (localhost), the naming convention that ColdFusion Builder uses to identify the virtual host is "localhost-vhost1".</li>
<li>Port: The port assigned to the virtual host in the web server.</li>
<li>Type: Select HTTP or HTTPS from the drop-down list.</li>
<li>Document Root: Browse to or enter the home directory of the virtual host.For example, if my website dev.mattgifford.co.uk is mapped to the directory C:\websites\mattgifford on the Apache web server, enter C:\websites\mattgifford as the home directory.</li>
<li>Click Add.</li>
</ol>
</li>
<li>To create a virtual directory, click Virtual Directory and enter the  following details.
<ol type="a">
<li>Alias: Specify an alias for the folder path.</li>
<li>Location: Browse to or enter the folder path to which you want to specify an alias.For example, if the document root of your website (dev.mattgifford.co.uk) is C:\websites\mattgifford, and you want to include images from a folder available on d:\monkehImages\images. Then, you can define an alias called "images" for the folder path "d:\monkehImages\images".</li>
<li>Click Add.</li>
<li>Click OK to add the virtual directory to the Virtual Directory Settings  table.</li>
</ol>
</li>
<li>Click Apply. The virtual host is added to the List Virtual Hosts  table.</li>
</ol>
<p>To modify the virtual host settings, select the virtual host from the List Virtual Hosts table, modify the settings, and click Update.</p>
</div>
<p><a href="/assets/uploads/2009/11/Server-Virtual-Host-Settings.png"><img title="Server Virtual Host Settings" src="/assets/uploads/2009/11/Server-Virtual-Host-Settings.png" alt="Server Virtual Host Settings" /></a></p>
<h3>Install Extensions</h3>
<div>
<p>Select the Install Extensions option to install the extensions that are  packaged with ColdFusion Builder.</p>
<ol>
<li>Select the ColdFusion server on which you want to install the extension.</li>
<li>Browse and select the ColdFusion webroot location.</li>
<li>Browser to a location within the webroot to install the extensions. The  extensions are installed in the Extensions directory within the selected  location.</li>
</ol>
<p>Click Finish to create the ColdFusion local server instance.</p>
<h2>All done!</h2>
</div>
<p>You can see from the screenshot below, the server is now added to the Server panel.</p>
<p><a href="/assets/uploads/2009/11/CF9-Server-added.png"><img title="CF9 Server added" src="/assets/uploads/2009/11/CF9-Server-added.png" alt="CF9 Server added" /></a></p>
<p>The following information is directly available to view from this datagrid:</p>
<ul>
<li>ServerName</li>
<li>Status (Running or Stopped)</li>
<li>Description</li>
<li>Type (Local or Remote)</li>
<li>Host</li>
<li>Port</li>
</ul>
<p><a href="/assets/uploads/2009/11/Launch-Admin-Page.png"><img title="Launch CF Admin" src="/assets/uploads/2009/11/Launch-Admin-Page.png" alt="Launch CF Admin" /></a></p>
<p>Each entry into the Server panel has a context menu, accessible by right-clicking on a server entry. Options available include Start, Stop and Restart the server (JRun and J2EE only), Edit and Delete, Server Monitor and Admin Page. I personally think that having the ability to directly control and manage your servers from within your development workspace is a massive time saver.</p>
<p>No need to open up Terminal, Windows Services or the JRun Management Console to start/stop a server instance. You don't have to leave your screen to do this (except to make a coffee, which you can do now if you'd like?)</p>
<p>Let's open up the ColdFusion Administrator by selecting 'Launch Admin Page' from the context menu. The Admin page will load up in a new tab inside the Eclipse IDE workspace. Awesome!</p>
<p><a href="/assets/uploads/2009/11/CFAdmin-inside-CF-Builder.png"><img title="CFAdmin inside CF Builder" src="/assets/uploads/2009/11/CFAdmin-inside-CF-Builder.png" alt="CFAdmin inside CF Builder" /></a></p>
<p>You will be asked to log in as normal. You can now manage and configure your admin settings. No need to open up a new browser tab or window, or move to a different application to do this. You don't have to leave the workspace.</p>
<p><a href="/assets/uploads/2009/11/CFBuilder-Server-Monitor.png"><img title="CFBuilder Server Monitor" src="/assets/uploads/2009/11/CFBuilder-Server-Monitor.png" alt="CFBuilder Server Monitor" /></a></p>
<p>The same can be achieved with the Server Monitor ('Launch Server Monitor' from the context menu). This will also load up in a new tab in the workspace. This might be just me, but I hope I'm not the only one that thinks this is immense! Once again, you can monitor and control your server without (all together now) "leaving your workspace".</p>
<p>
<h2>Create a new ColdFusion project</h2>
<p>Ok, we now have our local ColdFusion server set up within ColdFusion Builder. Let's add a project to the IDE which uses that server.</p>
<p><a href="/assets/uploads/2009/11/Create-New-CF-Project.png"><img title="Create New CF Project" src="/assets/uploads/2009/11/Create-New-CF-Project.png" alt="Create New CF Project" /></a></p>
<h3>Enter project information</h3>
<div>
<div>
<ol>
<li>Right-click in the Navigator area and click <strong>New &gt; ColdFusion Project</strong>.</li>
<li>In the Project Builder wizard, specify the project name.</li>
<li>To change the default project location, deselect the Use Default Location  option. As we are going to use the webroot of the ColdFusion server/instance we have just added, change the project location to point to that webroot.</li>
<li>Click Next to specify the ColdFusion server details.</li>
</ol>
</div>
</div>
<p><a href="/assets/uploads/2009/11/New-CF-Project-Project-Name.png"><img title="New CF Project - Project Name" src="/assets/uploads/2009/11/New-CF-Project-Project-Name.png" alt="New CF Project - Project Name" /></a></p>
<h3>Enter server details</h3>
<div>
<ol>
<li>Select the server from the Server pop-up menu. Here, we can see the <strong>CF 9 Local server</strong> that was added in the earlier steps.
<div>Note: If the project is in the  server web root, then the Sample URL box is automatically populated with the  server URL. For example, http://127.0.0.1:8500/eval, where 127.0.0.1 is the  server host, 8500 is the port number, and eval is the project name.</div>
</li>
<li>Specify your preview settings to use an external web browser by browsing and  selecting the select the web browser executable. The internal browsers are  selected, by default.</li>
<li>Click Next.</li>
</ol>
</div>
<p>
<p><a href="/assets/uploads/2009/11/New-CF-Project-Server-Details.png"><img title="New CF Project - Server Details" src="/assets/uploads/2009/11/New-CF-Project-Server-Details.png" alt="New CF Project - Server Details" /></a></p>
<h3>Add existing sources</h3>
<div>
<ol>
<li>In this step, you can:
<ul>
<li>Link existing resources folder to the project.</li>
<li>Select previously configured applications, such as Model Glue, with the  current project.</li>
</ul>
</li>
<li>Click Add to select the folder to link to the project.</li>
<li>Click Finish to build a new ColdFusion project.</li>
</ol>
</div>
<h2>Complete!</h2>
<div>You have now created a new project in ColdFusion Builder that is 'attached' to a server instance.</div>
<div>We can see it in action. Let's create a new file, 'index.cfm' in the root of the project we have just created, and add some CF code, for example '&lt;cfdump var="#cgi#" /&gt;' and save the file.</div>
<div><a href="/assets/uploads/2010/01/index_sourceView.png"><img  title="View CF code in ColdFusion Builder" src="/assets/uploads/2010/01/index_sourceView-1024x477.png" alt="View CF code in ColdFusion Builder" /></a></div>
<div>At the bottom-left of the code screen, you can see two tabs. We are currently in the 'Source' view. Switching to select the default browser tab 'IE' will resolve the code we have just writtem using the ColdFusion server applied to the project, which will display the CF output directly within the workspace window.</div>
<div><a href="/assets/uploads/2010/01/index_browserView.png"><img  title="View CF output in ColdFusion Builder" src="/assets/uploads/2010/01/index_browserView-1024x510.png" alt="View CF output in ColdFusion Builder" /></a></div>
<div>For me personally, ColdFusion Builder has been an immensely pleasurable experience. It's part of my daily development routine, and something that I am very excited about. I look forward to the final release, and I'll be writing about some more of the features included in coming posts.</div>
<h3>Further information</h3>
<ul>
<li><a title="ColdFusion Builder on Adobe Labs" href="http://labs.adobe.com/technologies/coldfusionbuilder/" target="_blank">ColdFusion Builder on Adobe Labs</a></li>
<li><a href="WS0ef8c004658c1089e9a3f41239ccac94d-7ffe.html" target="_blank">Understanding virtual hosts, and relevance in the ColdFusion  Builder context</a></li>
<li><a href="WS0ef8c004658c10895e247a961239daf7783-7ffe.html">Virtual  directories</a></li>
<li><a href="WS0ef8c004658c1089-1e935ddd12234e74f58-8000.html">Using  Extensions</a></li>
</ul>
<div id="_mcePaste" style="overflow: hidden; position: absolute; left: -10000px; top: 1197px; width: 1px; height: 1px;"><span style="color: #ff0000;">(J2EE only)</span></div>
