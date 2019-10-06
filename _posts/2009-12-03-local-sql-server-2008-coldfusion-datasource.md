---
layout: post
title: Local SQL Server 2008 ColdFusion Datasource
slug: local-sql-server-2008-coldfusion-datasource
date: 2009-12-03
categories:
- ColdFusion
tags:
- ColdFusion
- datasource
- SQL Server
status: publish
type: post
published: true
---
<p>This morning I finished installing SQL Server 2008 on my local machine for development.</p>
<p>Having set up the database, I hit a small issue when trying to add the database as a datasource within the ColdFusion administrator, receiving the following error:</p>
<p>Connection verification failed for data source: romixrDB<br />
java.sql.SQLNonTransientConnectionException: [Macromedia][SQLServer JDBC Driver]Error establishing socket to host and port: 127.0.0.1:1433. Reason: Connection refused: connect<br />
The root cause was that: java.sql.SQLNonTransientConnectionException: [Macromedia][SQLServer JDBC Driver]Error establishing socket to host and port: 127.0.0.1:1433. Reason: Connection refused: connect</p>
<p>You can see a connection issue with the datasource, with a failure to connect on the socket using the localhost (127.0.0.1) and port number (1433). By default, SQL Server 2008 doesn't have the port number enabled.</p>
<p>To resolve the issue, open up your SQL Server Configuration Manager application (Programs -&gt; Microsoft SQL Server 2008 -&gt; Configuration Tools -&gt; SQL Server Configuration Manager).</p>
<p>Expand the SQL Server Network Configuration menu item, and click on the Protocols option for the server, which will display the list of protocols in the main window:</p>
<p><a href="/assets/uploads/2009/12/sqlConfigManager_01.gif"><img title="SQL Server Configuration Manager" alt="SQL Server Configuration Manager" src="/assets/uploads/2009/12/sqlConfigManager_01.gif" /></a></p>
<p>Right-click on the TCP/IP option, and select 'properties' from the context menu, which will open up the properties window.</p>
<p>Change the 'Enabled' option to YES under the 'Protocol' tab.</p>
<p><a href="/assets/uploads/2009/12/tcpipProperties_01.gif"><img title="TCP IP Properties" alt="TCP IP Properties" src="/assets/uploads/2009/12/tcpipProperties_01.gif" /></a></p>
<p>Selecting the 'IP Addresses' tab, you can see the TCP Port for all IP references is set to 1433, the default port. You can also set the 'Enabled' option for the IP1 and IP2 options to 'YES' here as well. Click 'Apply' to save your changes.</p>
<p><a href="/assets/uploads/2009/12/tcpipProperties_02.gif"><img title="TCP IP Properties" alt="TCP IP Properties" src="/assets/uploads/2009/12/tcpipProperties_02.gif" /></a></p>
<p>The changes are now saved, but you will need to restart the SQL Server service before they take effect. To do so, select the 'SQL Server Services' option in the config manager, and select the SQL Server item from the list.</p>
<p>Click the 'Restart service' icon on the toolbar (circled).</p>
<p><a href="/assets/uploads/2009/12/sqlConfigManager_02.gif"><img title="SQL Server Configuration Manager" alt="SQL Server Configuration Manager" src="/assets/uploads/2009/12/sqlConfigManager_02.gif" /></a></p>
<p>Back into the ColdFusion Administrator, verify the connections again, and the new SQL Server datasource should be OK now that the ports have been opened on the database server.</p>
