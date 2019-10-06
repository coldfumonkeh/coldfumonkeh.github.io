---
layout: post
title: Detecting Network Connectivity in Flex AIR applications
slug: network-connectivity-in-air
date: 2010-07-20
categories:
- AIR
- Development
- Screencasts
- Tutorials
tags:
- Adobe
- AIR
- FLEX
status: publish
type: post
published: true
---
<p>Detecting network connectivity is a crucial part of AIR application development.</p>
<p>If you're releasing or developing AIR applications that require an internet connection, you want to ensure that you have the connectivity before you start running your 'online code' to trap any possible errors that may occur from lack of connection or downtime.</p>
<p>In this brief video tutorial, I outline the basics required to set up network connectivity monitoring functionality inside of your AIR application.</p>
<p>To view the video, click on the video link above, or watch it directly on <a title="View this video on YouTube" href="http://youtu.be/Joih2VXK2Bo" target="_blank">YouTube</a>.</p>
<p><strong>MXML Code</strong></p>
<pre name="code" class="xml">&lt;?xml version="1.0" encoding="utf-8"?&gt;
&lt;s:WindowedApplication xmlns:fx="http://ns.adobe.com/mxml/2009"
					   xmlns:s="library://ns.adobe.com/flex/spark"
					   xmlns:mx="library://ns.adobe.com/flex/mx"
					   creationComplete="init()"&gt;

	&lt;fx:Script&gt;
		&lt;![CDATA[
			// network monitoring functions
			/* **************************** */

			// import the URLMonitor class
			import air.net.URLMonitor;

			/*
			Set up the URL string variable for the URLRequest to check.
			In this example, let's use google.com as we can be sure 99.99%
			of the time that it will be up and running.
			*/
			private var strURLMonitor	: String = 'http://www.google.com';
			private var	monitor			: URLMonitor;
			[Bindable]
			private var isOnline		: Boolean = false;

			/*
			This function checks the online status by attempting
			to resolve a connection to a remote address
			*/
			private function monitorConnection():void {
				monitor = new URLMonitor(
								new URLRequest(strURLMonitor)
							);
				monitor.addEventListener(
								StatusEvent.STATUS,
								announceStatus);
				monitor.start();
			}

			/*
			Declare the status from the monitorConnection function
			and set the value to the variable isOnline
			*/
			private function announceStatus(e:StatusEvent):void {
				trace("Status change. Current status: " + monitor.available);
				if(monitor.available) {
					isOnline = true;
					/*
					Inside here, you can run any functions or script
					that require network connection, as it exists.
					*/
				} else {
					isOnline = false;
				}
			}

			/*
			The network connection has changed.
			Run the monitorConnection function to check status
			*/
			private function onNetworkChange(event:Event):void {
				trace('network change');
				monitorConnection();
			}
			//

			private function init():void {
				/*
					Keep an eye on network connectivity...
					Any losses, and run the onNetworkChange method
				*/
				NativeApplication.nativeApplication.addEventListener(
						Event.NETWORK_CHANGE, onNetworkChange);

				// run monitorConnection
				monitorConnection();
			}

		]]&gt;
	&lt;/fx:Script&gt;

	&lt;s:Label x="10"
			 y="10"
			 text="Online? {isOnline}"
			 width="493"
			 height="167"
			 fontSize="72" /&gt;

&lt;/s:WindowedApplication&gt;</pre>
