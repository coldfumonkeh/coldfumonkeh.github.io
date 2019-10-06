---
layout: post
title: Initializing A New Query With Data in ColdFusion 10
slug: initializing-a-new-query-with-data-in-coldfusion-10
categories:
- ColdFusion
tags:
- ColdFusion
- ColdFusion 10
status: publish
type: post
published: true
date: 2012-06-28
---
<p>It's time to take a look at another of the awesome language enhancements in ColdFusion 10.</p>
<p>In CF10, you can populate new user-defined query with data at the point of instantiation. This means that you don't have to perform a series of loops to add a row and set data into each cell within that row. Thanks to this language enhancement you can send your data into the new query from the start and have it populated for you.</p>
<p><strong>** edit **</strong></p>
<p>Thanks to Sam Farmer for reminding me that the enhanced queryNew() method is also available in the <a title="http://helpx.adobe.com/coldfusion/release-note/coldfusion-9-0-update-2.html" href="http://helpx.adobe.com/coldfusion/release-note/coldfusion-9-0-update-2.html" target="_blank">ColdFusion 9.0.2 update</a>. I'm silly...</p>
<p><strong>** end **</strong></p>
<p>This is one of my personal favourites as it is such a timesaver and can really streamline your code and workflow if put to use.</p>
<h2>In Action</h2>
<p>Let's create a new query and populate it with data from the start. In the code below, we are defining the names of the columns and the data type for those columns. Finally, we'll send in an array of structures as the data for the query:</p>

{% highlight javascript %}
<cfscript>
	qryPeople = queryNew(
					'firstname, lastname, email',
					'varChar, varChar, varChar',
					[
						{
							firstname 	: 	'Matt',
							lastname	:	'Gifford',
							email		:	'me@monkeh.me'
						},
						{
							firstname 	: 	'Dave',
							lastname	:	'Ferguson',
							email		:	'never@doingitwrong.com'
						},
						{
							firstname 	: 	'Scott',
							lastname	:	'Stroz',
							email		:	'angry@stackover.flow'
						}
					]
				);
</cfscript>
{% endhighlight %}

<pre name="code" class="html">&lt;cfscript&gt;
	qryPeople = queryNew(
					'firstname, lastname, email',
					'varChar, varChar, varChar',
					[
						{
							firstname 	: 	'Matt',
							lastname	:	'Gifford',
							email		:	'me@monkeh.me'
						},
						{
							firstname 	: 	'Dave',
							lastname	:	'Ferguson',
							email		:	'never@doingitwrong.com'
						},
						{
							firstname 	: 	'Scott',
							lastname	:	'Stroz',
							email		:	'angry@stackover.flow'
						}
					]
				);
&lt;/cfscript&gt;</pre>
<p>Running the above code in our browser, we would receive the following query object, populated with our data:</p>
<p><img  title="ColdFusion 10 Query New populated with data" src="/assets/uploads/2012/06/query_new_populated-272x112.png" alt="ColdFusion 10 Query New populated with data" /></p>
<p>What's great about this addition to the language is how much time it saves compared to creating the query, setting the columns, setting the number of rows, adding rows and setting values of cells within each of those rows... by sending the data through to the function from the start, your recordset is ready instantly. Of course, there will be times when you may need to use the 'old skool' method of creating custom queries on the fly, and there is nothing wrong with that either! You have options, which is always a good thing.</p>
<h2>Acceptable Data Formats</h2>
<p>When passing the data in to the new query, you have three formats of data organisation to choose from. In the first example (above) we passed in an array of structured information:</p>
<p><img title="ColdFusion 10 queryNew function accepts an array of structures to populate data" src="/assets/uploads/2012/06/array_of_structs.png" alt="ColdFusion 10 queryNew function accepts an array of structures to populate data" /></p>
<p>We can also pass in a single structure to set the values of one row within the database:</p>
<p><img src="/assets/uploads/2012/06/single_struct.png" alt="ColdFusion 10 new Query function will accept a structure to populate a single row of data" title="ColdFusion 10 new Query function will accept a structure to populate a single row of data" /></p>
<pre name="code" class="html">&lt;cfscript&gt;
	qryPeople = queryNew(
					'firstname, lastname, email',
					'varChar, varChar, varChar',
					{
							firstname 	: 	'Dave',
							lastname	:	'Ferguson',
							email		:	'never@doingitwrong.com'
					}
				);
&lt;/cfscript&gt;</pre>
<p>Or we can pass in an array of arrays:</p>
<p><img src="/assets/uploads/2012/06/array_of_arrays.png" alt="ColdFusion 10 new Query function will accept an array of arrays to populate data" title="ColdFusion 10 new Query function will accept an array of arrays to populate data" /></p>
<pre name="code" class="html">&lt;cfscript&gt;
	qryPeople = queryNew(
					'firstname, lastname, email',
					'varChar, varChar, varChar',
					[
						[ 'Matt','Gifford','me@monkeh.me' ],
						[ 'Dave', 'Ferguson', 'never@doingitwrong.com' ],
						[ 'Scott', 'Stroz', 'angry@stackover.flow' ]
					]
				);
&lt;/cfscript&gt;</pre>
<p>The array you send in could be single or multi-dimensional.</p>
<h2>Order Is Everything</h2>
<p>It's important to remember that if sending data by an array, the values in the array will be mapped to the query columns in the order they are sent.</p>
<p>The structures being sent in the first two examples had a name / value pair for their contents (it's what structures do) and so ColdFusion can easily map the value to the specific column by matching the name. I could send the data through in any order as below, but the values will still map to the correct columns by reference:</p>
<pre name="code" class="html">&lt;cfscript&gt;
	qryPeople = queryNew(
					'firstname, lastname, email',
					'varChar, varChar, varChar',
					[
						{
							firstname 	: 	'Matt',
							email		:	'me@monkeh.me',
							lastname	:	'Gifford'
						},
						{
							lastname	:	'Ferguson',
							firstname 	: 	'Dave',
							email		:	'never@doingitwrong.com'
						},
						{
							firstname 	: 	'Scott',
							lastname	:	'Stroz',
							email		:	'angry@stackover.flow'
						}
					]
				);
&lt;/cfscript&gt;</pre>
<p>When sending the data as an array, the values will be inserted into the query in the order they are defined in the array. In this example, I've intentionally mixed up the order of the values within each array:</p>
<pre name="code" class="html">
&lt;cfscript&gt;
	qryPeople = queryNew(
					'firstname, lastname, email',
					'varChar, varChar, varChar',
					[
						[ 'Gifford','Matt','me@monkeh.me' ],
						[ 'never@doingitwrong.com', 'Ferguson', 'Dave' ],
						[ 'Scott', 'Stroz', 'angry@stackover.flow' ]
					]
				);
&lt;/cfscript&gt;
</pre>
<p>The resulting query is stil populated, but as we expected it's not in the right order:</p>
<p><img src="/assets/uploads/2012/06/array_values_muddled.png" alt="ColdFusion 10 queryNew function will convert array values in the order they are provided" title="ColdFusion 10 queryNew function will convert array values in the order they are provided" /></p>
<p>Although I'm sure that people will not have this issue, it's something to remember in case you start seeing strange values in incorrect columns.</p>
<p>ColdFusion 10, continually making developer's lives easier with simple language enhancements that have a lot of power!</p>
