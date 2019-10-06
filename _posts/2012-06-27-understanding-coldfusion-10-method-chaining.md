---
layout: post
title: Understanding ColdFusion 10 Method Chaining
slug: understanding-coldfusion-10-method-chaining
categories:
- ColdFusion
- Components
tags:
- CFC
- ColdFusion
- ColdFusion 10
status: publish
type: post
published: true
date: 2012-06-27
---
<p>One of the many new enhancements to the ColdFusion 10 language has been the ability to chain methods in your ColdFusion components.</p>
<h2>What's chaining?</h2>
<p>If you're a jQuery user, chances are you've seen (and probably used) method chaining before. It's a simple (but powerful) way to group your method calls together to perform actions on the same object / element:</p>
<pre name="code" class="javascript">
$('#myElement')
    .css('backgroundColor','yellow')
    .attr('title', 'Chaining methods... heck yeah!');
</pre>
<h2>In Action</h2>
<p>Let's take a look at how you can use method chaining in ColdFusion 10.</p>
<p>We'll start off with a simple Person bean / entity object. In this object we want to store the first name, last name and email address for our individual.</p>
<pre name="code" class="html">
&lt;cfcomponent output="false" accessors="true"&gt;

	&lt;cfproperty name="firstname" type="string" default="" /&gt;
	&lt;cfproperty name="lastname" 	type="string" default="" /&gt;
	&lt;cfproperty name="email" 	type="string" default="" /&gt;

	&lt;cffunction name="init"&gt;
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<p>There are a number of ways that you can instantiate a component, and depending on whether you have developed the object to be 'read-only' (you can only set the properties from the init / constructor method within the object, not from any calling pages or templates) or not, you would have to set each property one at a time, like so:</p>
<pre name="code" class="html">
&lt;cfset objPerson = new person() /&gt;
&lt;cfset objPerson.setFirstname('Matt') /&gt;
&lt;cfset objPerson.setLastname('Gifford') /&gt;
&lt;cfset objPerson.setEmail('me@monkeh.me') /&gt;
</pre>
<p>ColdFusion 10 method chaining now means you can set any of your object's properties in one go, like so:</p>
<pre name="code" class="html">
&lt;cfset objPerson =
			new person()
			.setFirstname('Matt')
			.setLastname('Gifford')
			.setEmail('me@monkeh.me')
		/&gt;
</pre>
<h2>The Rules</h2>
<p>There are some rules in place which define how far you can go when chaining your methods:</p>
<ul>
<li>The accessors attribute is set to true</li>
<li>If the setter functions for the property are defined</li>
<li>Until a method is found</li>
</ul>
<p>Let's have a look at these to try and better understand them.</p>
<h3>Accessors attribute set to true</h3>
<p>You can see from the previous code sample showing the person entity that the opening cfcomponent tag has the accessors attribute set to true. Without this, ColdFusion will not generate the implicit accessors and mutators (or getters and setters) for each property.</p>
<p>Let's see what happens when you have it set to false or not defined and have chosen to write your own getter and setter methods. Here is an amended version of our person object:</p>
<pre name="code" class="html">
&lt;cfcomponent output="false"&gt;

	&lt;cfproperty name="firstname" type="string" default="" /&gt;
	&lt;cfproperty name="lastname" 	type="string" default="" /&gt;
	&lt;cfproperty name="email" 	type="string" default="" /&gt;

	&lt;cffunction name="init"&gt;
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;

	&lt;cffunction name="setFirstname"&gt;
		&lt;cfargument name="firstname" /&gt;
		&lt;cfset variables.firstname = arguments.firstname /&gt;
	&lt;/cffunction&gt;

	&lt;cffunction name="setLastname"&gt;
		&lt;cfargument name="lastname" /&gt;
		&lt;cfset variables.lastname = arguments.lastname /&gt;
	&lt;/cffunction&gt;

	&lt;cffunction name="setEmail"&gt;
		&lt;cfargument name="email" /&gt;
		&lt;cfset variables.email = arguments.email /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<p>Running this using the chaining code above will not end well:</p>
<p><img src="/assets/uploads/2012/06/cfc_chaining_no_accessors_error.png" alt="ColdFusion 10 method chaining without implicit accessors" title="ColdFusion 10 method chaining without implicit accessors" /></p>
<p>ColdFusion will assume that the second method, <strong>setLastName()</strong>, is contained within the <strong>setFirstName()</strong> method call, in the same way a public function would be available within an instantiated component. Without the magic of implicit accessors, chaining will not work.</p>
<h3>Setter functions are not defined</h3>
<p>In this example, the setter attribute for the email property has been set to false. Instead of using the implicit mutator we're going to create our own <strong>setEmail()</strong> method in the CFC just to see what happens if we try to call it as part of the chaining.</p>
<p>Here's our revised CFC:</p>
<pre name="code" class="html">
&lt;cfcomponent output="false" accessors="true"&gt;

	&lt;cfproperty name="firstname" type="string" default="" /&gt;
	&lt;cfproperty name="lastname" 	type="string" default="" /&gt;
	&lt;cfproperty name="email" 	type="string" default="" setter="false" /&gt;

	&lt;cffunction name="init"&gt;
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;

	&lt;cffunction name="setEmail"&gt;
		&lt;cfargument name="email" /&gt;
		&lt;cfset variables.email = arguments.email /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<p>And here we are setting the property values once more:</p>
<pre name="code" class="html">
&lt;cfset objPerson =
			new person()
			.setFirstname('Matt')
			.setLastname('Gifford')
			.setEmail('me@monkeh.me')
		/&gt;
</pre>
<p>If we run the above code against the revised person object, the mutators will successfully set the values for the firstname and lastname properties but will error when trying to set the email, even though we defined our own <strong>setEmail</strong> method:</p>
<p><img src="/assets/uploads/2012/06/setter_false_error.png" alt="ColdFusion 10 method chaining needs setter functions defined" title="ColdFusion 10 method chaining needs setter functions defined" /></p>
<p>We <em>could</em> get around this by calling our defined <strong>setEmail</strong> method after the initial chaining, like so:</p>
<pre name="code" class="html">
&lt;cfset objPerson =
			new person()
			.setFirstname('Matt')
			.setLastname('Gifford')
		/&gt;

&lt;cfset objPerson.setEmail('something@wrong.net') /&gt;
</pre>
<p>but this then bypasses the awesomeness provided by chaining your methods and the implicit getters and setters. Why create more work for yourself if you don't have to? Of course, there may be instances when you want or need to run setter functions this way... it's always good to know you have options.</p>
<h3>Until a method is found</h3>
<p>Method chaining will work for any valid (for valid, see points one and two above) properties within your component and will happily set the values for as many as you wish UNTIL it reaches a method call, at which point it will stop setting values.</p>
<p>Here is another revised version of the person object, which now contains a <strong>getFullName()</strong> method to return a concatenated string containing the firstname and lastname property values:</p>
<pre name="code" class="html">
&lt;cfcomponent output="false" accessors="true"&gt;

	&lt;cfproperty name="firstname" type="string" default="" /&gt;
	&lt;cfproperty name="lastname" 	type="string" default="" /&gt;
	&lt;cfproperty name="email" 	type="string" default="" /&gt;

	&lt;cffunction name="init"&gt;
		&lt;cfreturn this /&gt;
	&lt;/cffunction&gt;

	&lt;cffunction name="getFullName"&gt;
		&lt;cfreturn getfirstname() & ' ' & getLastname() /&gt;
	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<p>Running the following code will work as all property values will be set before returning the value from the <strong>getFullName()</strong> method:</p>
<pre name="code" class="html">
&lt;cfset objPerson =
			new person()
			.setFirstname('Matt')
			.setLastname('Gifford')
			.setEmail('me@monkeh.me')
			.getFullName() /&gt;

&lt;cfdump var="#objPerson#"&gt;
</pre>
<p>Running the following will NOT work as ColdFusion will not be able to find the <strong>setEmail()</strong> method within the object:</p>
<pre name="code" class="html">
&lt;cfset objPerson =
			new person()
			.setFirstname('Matt')
			.setLastname('Gifford')
			.getFullName()
			.setEmail('me@monkeh.me') /&gt;

&lt;cfdump var="#objPerson#"&gt;
</pre>
<p><img src="/assets/uploads/2012/06/method_discovered.png" alt="ColdFusion 10 method chaining will continue until it finds a method" title="ColdFusion 10 method chaining will continue until it finds a method" /></p>
<h3>Don't Go Nuts</h3>
<p>Method chaining is awesome and can really help streamline your code, but if you have a multitude / butt-load of properties within the object, try not to go crazy and set all of the values in one long chain. It IS possible to do that, but it will start to make the code unreadable and potentially unmanageable.</p>
<p>Remember that code is a language and languages need to be read.</p>
<h2>The End</h2>
<p>So there you go... method chaining in ColdFusion 10 is an amazing addition to the language and one that can really help you minimise code, increase productivity and generally make your day that little bit happier.</p>
<p>&nbsp;</p>
