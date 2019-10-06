---
layout: post
title: ColdFusion Builder SQL Editor
slug: coldfusion-builder-sql-editor
date: 2010-03-24
categories:
- ColdFusion
- ColdFusion Builder
tags:
- Builder
- ColdFusion
status: publish
type: post
published: true
---
<p>Working with SQL and database connectivity has now been simplified, thanks to the built-in SQL Editor window within ColdFusion Builder.</p>
<p>Not everyone is a SQL guru, capable of writing intense JOIN statements across 5 tables (including multiple AND clauses), all in one go.</p>
<p>Chances are, a SQL statement will be written, added to the cfquery tags and the results displayed using a cfdump - classic step debugging.</p>
<p>ColdFusion Builder has helped to alleviate some of the stresses and strains from us non-SQL masters, and we are now able to access the SQL Editor window directly from within the code editor to write AND test returned data from pre-defined datasources.</p>
<h2>Show me how</h2>
<p>OK.</p>
<h3>It's all about context</h3>
<p>Access to the SQL Editor can be made by right-clicking anywhere within an active code editor window. From the context-menu, select the '<strong>SQL Editor</strong>' option:</p>
<p><img title="SQL Editor Context Menu" src="/assets/uploads/2010/03/sqlEditor1.gif" alt="SQL Editor Context Menu" /></p>
<p>This will load up the SQL Editor window, as shown below.</p>
<p>From here, you can select the datasource you wish to work through from the drop-down list, and also change the ColdFusion server instance to access any datasources under the selected server.</p>
<h3>Code Completion</h3>
<p>The SQL editor offers user-friendly, clear code-formatting and colouring, which visually makes it a little easier to write and debug statements.</p>
<p>Code-completion is also available within the window. In this instance, after typing the opening '<strong>SELECT</strong>' statement, pressing the space button will load up a sub menu listing the available database names, all thanks to the connection to the RDS.</p>
<p><img title="SQL Editor Code Completion" src="/assets/uploads/2010/03/sqlEditor2.gif" alt="SQL Editor Code Completion" /></p>
<p>After selecting the table name, typing a full stop/period will enable a second sub menu listing all columns within the selected table.</p>
<p>This is a fantastic time saver, and reduces the possibility of any typos or spelling issues that could cause conflicts or errors when running the query.</p>
<h3>Write it all out</h3>
<p>In my working example, I am creating a query against the '<strong>monkehDatabase</strong>' and the '<strong>kickAss</strong>' table to pull out the complete list of current items that officially 'kick ass'.</p>
<p>I have simple pleasures.</p>
<p>With the SELECT statement finished (albeit in this case a very simple one), simply click the '<strong>Execute Query</strong>' button at the bottom of the window. The Editor will connect to the datasource through RDS and will open up the 'Query Result' tab to display the returned information.</p>
<p><img title="SQL Editor Execute Query" src="/assets/uploads/2010/03/sqlEditor3.gif" alt="SQL Editor Execute Query" /></p>
<h3>Returned data</h3>
<p>So, according to the monkehDatabase, what kicks ass?</p>
<p>Thanks to ColdFusion Builder's built-in SQL Editor, we have now easily got a visual return of all records within the table, in this case listing (using boolean values) what does and does not KICK A.</p>
<p>You can see here that, unlike Chuck Norris, ColdFusion and Guinness, the Teletubbies don't.</p>
<p><img title="SQL Editor Query Results" src="/assets/uploads/2010/03/sqlEditor4.gif" alt="SQL Editor Query Results" /></p>
<h3>Beware: you want everything?</h3>
<p>The SQL Editor will return ALL records within a table if you run a SELECT statement. There is no capping limit for development purposes; all records would be returned, which could possibly take some time depending on the size of the database and use up CPU that could be better used elsewhere.</p>
<p>To avoid this unless you want all records returned, you can of course add a '<strong>TOP</strong>' clause to the SQL statement to limit the number of records brought back to you.</p>
<p><img title="SQL Editor Code Insertion" src="/assets/uploads/2010/03/sqlEditor5.gif" alt="SQL Editor Code Insertion" /></p>
<h3>Insert the code</h3>
<p>Once you are happy with the query you have written, fully-tested and suitable for your needs, ColdFusion Builder adds an extra level of help to ease development for you.</p>
<p>Clicking the '<strong>OK</strong>' button in the SQL Editor window will insert the SQL statement you have just worked meticulously on directly into the code editor window, at the current position of the cursor.</p>
<p>It saves a mass of time either copying and pasting the statement, or writing it out again. More time to drink Guinness and watch Chuck Norris movies.</p>
<h2>Easy as tubby custard</h2>
<p>ColdFusion Builder offers a streamlined, simpler way to manage your data, develop your applications and optimise your work flow. Whether you are a hardcore SQL developer or not, the built-in SQL Editor will certainly assist you and help to make your life easier.</p>
<p>You can now add yourself to the list of things that kick ass. Good job!</p>
<p><img title="teletubbiesKickA" src="/assets/uploads/2010/03/teletubbiesKickA.jpg" alt="teletubbiesKickA" /></p>
<p>Oh, and I'd better update the table... watch out Chuck.</p>
