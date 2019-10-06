---
layout: post
title: ColdFusion CFCs and Flash Builder 4
slug: coldfusion-cfcs-and-flash-builder-4
date: 2010-07-15
categories:
- ColdFusion
- Screencasts
- Tutorials
tags:
- Adobe
- Builder
- ColdFusion
- FLEX
status: publish
type: post
published: true
---
<p>Following on from the cfmeetup presentation last week on "Getting Started with Adobe AIR", I received some requests to share the code used in the example applications.</p>
<p>In this post, you will find not only the source code to connect a Flash Builder 4 application to a remote ColdFusion component, but also a rather useful (hopefully) video tutorial to guide you on your way.</p>
<p>You can view the video by pressing the above link or watch it directly on <a title="View the video directly on YouTube." href="http://youtu.be/VF0WWgwhp3o" target="_blank">YouTube</a>.</p>
<h3>Source Code</h3>
<p><strong>HelloWorld.cfc</strong></p>
<pre name="code" class="xml">&lt;cfcomponent 	displayname="helloWorld"
				output="false"
				hint="I am a simple component that you can use to call
						from your Flex applications."&gt;

	&lt;cffunction name="helloWorld"
				access="remote"
				output="false"
				hint="I return a string greeting."&gt;

		&lt;cfreturn 'Monkeh love IS good love!' /&gt;

	&lt;/cffunction&gt;

	&lt;cffunction name="helloPerson"
				access="remote"
				output="false"
				hint="I return a personalised string greeting."&gt;

		&lt;cfargument name="name" required="true"
					type="String"
					hint="The name of the person to greet" /&gt;

		&lt;cfreturn 'Hey, #arguments.name#! Did you know that
						Monkeh love is good love?' /&gt;

	&lt;/cffunction&gt;

	&lt;cffunction name="getQuery"
				access="remote"
				output="false"
				hint="I return a query object."&gt;

		&lt;cfset var qContacts = queryNew('firstName, lastName') /&gt;

			&lt;cfset queryAddRow(qContacts, 4) /&gt;
			&lt;cfset querySetCell(qContacts, 'firstName', 	'Paul', 		1) /&gt;
			&lt;cfset querySetCell(qContacts, 'lastName', 		'McCartney', 	1) /&gt;
			&lt;cfset querySetCell(qContacts, 'firstName', 	'John', 		2) /&gt;
			&lt;cfset querySetCell(qContacts, 'lastName', 		'Lennon', 		2) /&gt;
			&lt;cfset querySetCell(qContacts, 'firstName', 	'George', 		3) /&gt;
			&lt;cfset querySetCell(qContacts, 'lastName', 		'Harrison', 	3) /&gt;
			&lt;cfset querySetCell(qContacts, 'firstName', 	'Ringo', 		4) /&gt;
			&lt;cfset querySetCell(qContacts, 'lastName', 		'Starr', 		4) /&gt;

		&lt;cfreturn qContacts /&gt;

	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;</pre>
<p><strong>The main mxml file</strong></p>
<pre name="code" class="xml">&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;s:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
			   xmlns:s="library://ns.adobe.com/flex/spark"
			   xmlns:mx="library://ns.adobe.com/flex/mx"
			   minWidth="955"
			   minHeight="600"
			   creationComplete="remotesvc.getQuery()"&gt;

	&lt;fx:Declarations&gt;
		&lt;!-- Place non-visual elements (e.g., services, value objects) here --&gt;

		&lt;s:RemoteObject id="remotesvc"
						destination="ColdFusion"
						endpoint="http://localhost:8500/flex2gateway/"
						source="helloWorld"&gt;

			&lt;s:method name="helloPerson"
					  result="helloResult(event)" /&gt;

			&lt;s:method name="helloWorld"
					  result="helloResult(event)" /&gt;

			&lt;s:method name="getQuery"
					  result="queryResult(event)" /&gt;

		&lt;/s:RemoteObject&gt;

	&lt;/fx:Declarations&gt;

	&lt;fx:Script&gt;
		&lt;![CDATA[
			import mx.collections.ArrayCollection;

			[Bindable] private var acBeatles:ArrayCollection;

			import mx.controls.Alert;
			import mx.rpc.events.ResultEvent;

			private function helloResult(event:ResultEvent):void {
				Alert.show(event.result.toString());
			}

			private function queryResult(event:ResultEvent):void {
				acBeatles = event.result as ArrayCollection;
			}

		]]&gt;
	&lt;/fx:Script&gt;

	&lt;s:TextInput id="nameInput"  x="10" y="24"/&gt;

	&lt;s:Button label="Question"
			  click="remotesvc.helloPerson(nameInput.text)"
			  x="146"
			  y="25"/&gt;

	&lt;s:Button label="Statement"
			  click="remotesvc.helloWorld()"
			  x="245"
			  y="25"/&gt;

	&lt;mx:DataGrid x="10" y="88"
				 dataProvider="{acBeatles}"&gt;&lt;/mx:DataGrid&gt;

&lt;/s:Application&gt;</pre>
