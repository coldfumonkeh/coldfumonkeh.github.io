---
layout: post
title: Extending the ColdFusion Service Layer
slug: extending-the-coldfusion-service-layer
date: 2010-05-16
categories:
- ColdFusion
tags:
- Adobe
- CFC
- ColdFusion
status: publish
type: post
published: true
---
<p>I received an excellent question in the comments of another post from Rajeev, who asked:</p>
<blockquote><p>"I am trying to extract text from a pdf document using ColdFusion. But I need to invoke this as a web service from my PHP code.</p>
<p>I am able to use 'cfpdf' tag with 'extracttext' but as I said I need to run this from PHP. But the 'http://localhost/CFIDE/services/pdf.cfc?wsdl' WSDL has 'extractpages' and it does not have 'extracttext'.</p>
<p>So is it possible to somehow invoke CF as a webservice from PHP and use it to extract text from a pdf document?"</p></blockquote>
<p>The clear answer is YES, absolutely.</p>
<h2>What are the services?</h2>
<p>Now, I love the ColdFusion services.. I've blogged about them before, and have presented on the 'awesomeness' of using them within a Flex/AIR application to utilise some ColdFusion functionality in a desktop app.</p>
<p>This is a perfect example of their intended use; using some of the powerful ColdFusion features and tags inside of a PHP project. Accessing the power, versatility and rapid development/implementation of ColdFusion in an external project is what the CFaaS features were made for... after all, we need to share the love with other developers and languages, and help to make their lifes easier and more productive. :)</p>
<p>Relating to the question in hand, the first and most important thing to note here is that the exposed services in ColdFusion 9 are nothing more than ColdFusion components, accessed as a wsdl.</p>
<p>These 'default' service CFCs are stored within the /CFIDE/services directory of your CF installation.</p>
<p>The PDF Service, although fairly well packed with useful methods, does indeed miss out the extractText function that we have available in tag form. For a full list of available methods in all of the exposed services, feel free to reference the <a title="View the ColdFusion as a Service Cheat Sheet post" href="http://www.mattgifford.co.uk/cfaas-method-cheat-sheet/" target="_self">ColdFusion as a Service Cheat Sheet</a>, available as a PDF to download and cherish forever.</p>
<h2>Create a web service</h2>
<p>ColdFusion has always been awesome at creating web services. On a rudimentary level, if you can write a CFC, you can write a web service. It's as simple as that.</p>
<p>So, let's jump straight in and build a CFC that will satisfy the task at hand and allow us to use the extractText PDF action.</p>
<p>Create a new CFC called 'pdfText.cfc' and save it in the /CFIDE/services directory within your webroot. This will put it alongside the other exposed service layer components.</p>
<p><strong>/CFIDE/services/pdfText.cfc</strong></p>
<pre name="code" class="xml">
&lt;cfcomponent displayname="pdfText"
				output="false"
				extends="CFIDE.services.base"
				hint="I am the pdfText component, and I'm going to
						let you extract text from a PDF."&gt;

&lt;---
	We are extending the CFIDE.services.base component.
	This will allow us to access some security methods.
---&gt;

	&lt;cffunction name="extractText" access="remote"
				returntype="Any"
				output="false"
				hint="I extract text from the PDF.
						Output in either XML or String format."&gt;

		&lt;cfargument name="serviceusername"
					required="false"
					type="String"
					default=""
					hint="I am the service username used to
							access the web services." /&gt;

		&lt;cfargument name="servicepassword"
					required="false"
					type="String"
					default=""
					hint="I am the service password used to
							access the web services." /&gt;

		&lt;cfargument name="source"
					required="true"
					type="String"
					hint="I am the absolute or relative path
							of the PDF file|PDF document variable|
							cfdocument variable" /&gt;

		&lt;cfargument name="password"
					required="false"
					type="String"
					default=""
					hint="I am the password of the PDF document." /&gt;

		&lt;cfargument name="pages"
					required="true"
					type="String"
					default="*"
					hint="The page numbers from where the text needs
							to be extracted from the PDF document.
							Wildcard '*' is ALL pages." /&gt;

		&lt;cfargument name="returnData"
					required="false"
					type="String"
					default="xml"
					hint="I am the return format for the extracted text.
							String or XML." /&gt;

			&lt;!--- var scope the return variable ---&gt;
			&lt;cfset var pdfData = '' /&gt;

				&lt;!--- We have extended the /CFIDE/services/base Class
					and so we now have access to it's methods.
					Let's use these for security to ensure that there
					is no 'illegal' access to this service.
				---&gt;
				&lt;!---
					Run the isAllowed method to check the
					username and password
				---&gt;
				&lt;cfif super.isAllowed(
							username=arguments.serviceusername,
							password=arguments.servicepassword,
							service='PDF')
					&lt;!---
						AND check the IP address matches that
						set within the administrator security roles
					---&gt;
					AND super.isAllowedIP(
								username=arguments.serviceusername,
								service='PDF')&gt;
					&lt;!--- The PDF tag, action set to 'extractText' ---&gt;
					&lt;cfpdf
					    action="extracttext"
					    source="#arguments.source#"
					    pages="#arguments.pages#"
						type="#arguments.returnData#"
						useStructure="true"
						honourspaces="true"
						password="#arguments.password#"
						name="pdfData" /&gt;

				&lt;/cfif&gt;

		&lt;cfreturn pdfData /&gt;

	&lt;/cffunction&gt;

&lt;/cfcomponent&gt;
</pre>
<h3>Why the security?</h3>
<p>The CFC would work perfectly well without extending the CFIDE.services.base component and without the added security checks. If you want to use it without those, you can. I have added these in as an extra level of security and to protect unwarranted access to the service layer.</p>
<p>As we are emulating and 'hooking into' the existing exposed services, it would be prudent to err on the side of caution and follow the same security measures. By default, all access to the exposed services is restricted within the ColdFusion administrator. </p>
<p>To access these, a user permission must be created, complete with allowed IP address/range. My previous post on using <a href="http://www.mattgifford.co.uk/coldfusion-as-a-service-part-1/" title="View the ColdFusion as a Service post">ColdFusion as a Service</a> has the step-by-step instructions on setting up this access.</p>
<p>Calling the new web service is incredibly easy, and can be made directly within the browser to view the data:</p>
<p>http://localhost:8500/CFIDE/services/pdfText.cfc?wsdl&method=extractText&serviceusername=user&servicepassword=pass&source=/path/to/pdf</p>
<h2>All done</h2>
<p>There you have it. A new ColdFusion 'exposed service' component, developed to use the tags and functionality you are currently missing, extending the security restriction model of the default services.</p>
