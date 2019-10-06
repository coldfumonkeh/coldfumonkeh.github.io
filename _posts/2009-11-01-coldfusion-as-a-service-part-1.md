---
layout: post
title: ColdFusion as a Service (part 1)
slug: coldfusion-as-a-service-part-1
date: 2009-11-01
categories:
- AIR
- ColdFusion
- Development
- Events
- Flex Apps
- Tutorials
tags:
- Actionscript
- Adobe
- ColdFusion
- Namespace
- Service
- SOTR
- Tutorial
status: publish
type: post
published: true
---
<p>In the first of a series of small tutorials, we will discover the new features available in ColdFusion 9 that expose the service layer for use with external languages and applications.</p>
<p>Andy Allan from <a title="Fuzzy Orange" href="http://www.fuzzyorange.co.uk" target="_blank">Fuzzy Orange</a> and I co-authored a tutorial in November's issue of .net magazine highlighting the use of ColdFusion as a Service. We followed up the article with presentations over the two week <a title="Scotch on the Rocks" href="http://www.scotch-on-the-rocks.co.uk/" target="_blank">Scotch on the Rocks</a> European Tour in October. The feaure went down very well and sparked some interest in an other-wise as-of-yet unknown addition to ColdFusion 9.</p>
<p>Common but still powerful tags such as CFImage and CFChart were once only available for use directly in a ColdFusion .cfm template page. Thanks to ColdFusion 9 the services are available for RIA developers to call as remote web services, either in the form of WSDL CFCs or as Actionscript Proxy Classes when writing FLEX/AIR applications.</p>
<h3>Exposed Services</h3>
<p>The services that are exposed are:</p>
<ul>
<li>Chart</li>
<li>Document</li>
<li>Image</li>
<li>PDF</li>
<li>Mail</li>
<li>Pop</li>
</ul>
<p>The above tags are available for use in Flex/Flash/AIR applications using the cfservices.swc file included in every ColdFusion 9 installation. However, the SWC file itself acts as a 'placeholder', or an easy method of accessing the classes on the web server, which are ultimately exposed as web services. As such, they are also available through SOAP and AMF, meaning developers in other languages (.net, php, ruby etc) can also access and utilise the awesome power that ColdFusion has to offer.</p>
<p>The WSDL web services are typically located in the following location on your server:<br />
<code>http://[server]:[port]/CFIDE/services/</code></p>
<p>As an example, if you wished to access the Mail service from your built-in local development server, the URL would be the following:<br />
<code>http://localhost:8500/CFIDE/services/mail.cfc?wsdl</code></p>
<h3>The application we will build</h3>
<p>In this tutorial, we will explore and investigate the ease of using the ColdFusion services in a FLEX/AIR application, and will do so by creating a fairly simple yet powerful desktop application that will accept an image via drag/drop.</p>
<p>The user will be able to resize and rotate the image (using the Image class) and finally the user can send an email from the desktop application with the image as an attachment (using the Mail class). We will end up with an application looking like this:</p>
<p><a href="/assets/uploads/2009/10/applicationWindow.png"><img title="Application Window in action" src="/assets/uploads/2009/10/applicationWindow.png" alt="Application Window in action" /></a></p>
<h3>Minor language differences</h3>
<pre name="code" class="java">&lt;cfmail
	to="info@guitarhero.com"
	from="matt.gifford@fuzzyorange.co.uk"
	subject="Artist request - Kenny Loggins"&gt;

&lt;/cfmail&gt;</pre>
<p>The above is a traditional cfmail tag that all ColdFusion developers know and love with the bare essential attributes. Consider this against the cf:Mail tag below (which is an example of the proxy classes available to us when using the CF services in FLEX):</p>
<pre name="code" class="java">&lt;cf:mail
	to="info@guitarhero.com"
	from="matt.gifford@fuzzyorange.co.uk"
	subject="Artist request - Kenny Loggins"&gt;

&lt;/cf:mail&gt;</pre>
<p>The only difference in this example is the tag naming convention, where we instantiate the tags using the '<strong>cf:</strong>' namespace, which we declare in the MXML code when writing our application.</p>
<p>FLEX and ColdFusion have always worked so beautifully with each other, and thanks to ColdFusion 9 the transition or crossover for CF developers to play with FLEX apps has been made even easier.</p>
<h3><strong>Setting User Access</strong></h3>
<p style="text-align: left;">Due to the fact that the service layer exposes the WSDL CFCs, access is restricted by default. We need to set a specific user account with the correct permissions to access the services, and we do this under the SECURITY menu in the ColdFusion Administrator (http://localhost:8500/CFIDE/administrator/), and proceed to the 'User Manager' option.</p>
<p><a href="/assets/uploads/2009/10/addUser.png"><img style="display: block; margin-left: auto; margin-right: auto; border: 0px initial initial;" title="adding a user to the security manager" src="/assets/uploads/2009/10/addUser.png" alt="adding a user to the security manager" /></a></p>
<p style="text-align: left;">Add a new user, and set the user name and password for the account:</p>
<p><a href="/assets/uploads/2009/10/newuser.png"><img style="display: block; margin-left: auto; margin-right: auto; border: 0px initial initial;" title="new user details" src="/assets/uploads/2009/10/newuser.png" alt="new user details" /></a></p>
<p style="text-align: left;">At the bottom of this settings page, you can select which of the exposed services you wish to allocate to that user account. I've been very greedy and allowed access to all of them for my account, but following this tutorial you will certainly need the Image and Mail service.</p>
<p><a href="/assets/uploads/2009/10/allowedServices.png"><img style="display: block; margin-left: auto; margin-right: auto; border: 0px initial initial;" title="Selecting services allowed for the user" src="/assets/uploads/2009/10/allowedServices.png" alt="Selecting services allowed for the user" /></a></p>
<p style="text-align: left;">To enable access for the services, you'll also need to supply an IP address or range of IP addresses that can use the exposed layer, under the 'Allowed IP Addresses' menu option. As we are developing on the localhost, you can add 127.0.0.1 to the list.</p>
<p><a href="/assets/uploads/2009/10/allowedIP.png"><img style="display: block; margin-left: auto; margin-right: auto; border: 0px initial initial;" title="Allowed IP Addresses" src="/assets/uploads/2009/10/allowedIP.png" alt="Allowed IP Addresses" /></a></p>
<h3>Getting started with Services in Flex/AIR</h3>
<p>There are three simple steps to follow to build a dynamic FLEX/AIR application that will use the ColdFusion services:</p>
<ol>
<li>Import the cfservices.swc library</li>
<li>Add the ColdFusion namespace</li>
<li>Write some code</li>
</ol>
<h3>Import the cfservices.swc library</h3>
<p>Let's create a new FLEX / AIR project in Eclipse/Flash builder.<br />
Enter the name for the project (it can be anything your heart desires, although something slightly relevant to the working application is a good move ;) )</p>
<p><a href="/assets/uploads/2009/10/Untitled-1.png"><img title="Create New Flex Project" src="/assets/uploads/2009/10/Untitled-1.png" alt="Create New Flex Project" /></a></p>
<p>Although we are going to be accessing services on a ColdFusion server, we do not need to specify any  server type in the drop down box on the project configuration page. This will be handled by the SWC file and adding the namespace.</p>
<p>Hitting 'next', accept the default debug output options for the project, and proceed to the third screen in the wizard, the source and library build paths. Selecting the 'Library Path', we need to browse to and import the cfservices.swc file into the application. Hit the 'Add SWC' button to open the browse dialog.</p>
<p><a href="/assets/uploads/2009/10/Untitled-2.png"><img title="Add SWC Library" src="/assets/uploads/2009/10/Untitled-2.png" alt="Add SWC Library" /></a></p>
<p>Browse to the location of the cfservices.swc file on your ColdFusion installation.<br />
This is typically in: <strong>/CFIDE/scripts/AIR/</strong></p>
<p><a href="/assets/uploads/2009/10/Untitled-3.png"><img title="SWC File Location" src="/assets/uploads/2009/10/Untitled-3.png" alt="SWC File Location" /></a></p>
<p><a href="/assets/uploads/2009/10/Untitled-4.png"><img title="SWC File Location" src="/assets/uploads/2009/10/Untitled-4.png" alt="SWC File Location" /></a></p>
<p>Click 'OK', and the cfservices.swc file will be added to the library build path for your application.</p>
<p><a href="/assets/uploads/2009/10/Untitled-5.png"><img title="SWC Import" src="/assets/uploads/2009/10/Untitled-5.png" alt="SWC Import" /></a></p>
<h3>Add the ColdFusion namespace</h3>
<p>Now that the project has been created and the cfservices.swc file has been added to the library build path, we can start accessing the ColdFusion services.<br />
We need to add a new namespace to the FLEX application that points to the ColdFusion services, so add this line of code as an attribute inside the opening  tag:</p>
<pre name="code" class="java">
xmlns:cf="coldfusion.service.mxml.*"
</pre>
<p>I have also added the width and height for the application, and the <strong>init()</strong> method to be run on creationComplete. The <strong>init()</strong> method will be written a little further along in the tutorial.  Now that the cf namespace has been added to the application, by typing '<strong>cf:</strong>' at any point in the mxml page, you will see the code hinting window will pop up with the new ColdFusion exposed services.</p>
<p><a href="/assets/uploads/2009/10/cfNamespace.png"><img title="ColdFusion Exposed Services" src="/assets/uploads/2009/10/cfNamespace.png" alt="ColdFusion Exposed Services" /></a></p>
<p style="text-align: left;">Adding the ColdFusion server  The library has been added, the namespace has been declared and the cf:tags are now available for use. At this point, we have no interaction with any ColdFusion 9 server, so we need to declare the settings for the application to interact with the server and use it's exposed services.</p>
<p style="text-align: left;">This is easily achieved by using the <strong>cf:Config</strong> tag. The Config class sets the configuration parameters and connection details for the ColdFusion services, and should be used before setting up any other service class. The params set here are global, and can be overridden by any of the individual service proxy classes should you need to.</p>
<pre name="code" class="java">&lt;!-- ColdFusion Service settings and calls --&gt;
&lt;cf:config
	id="conf"
	cfserver="localhost"
	cfport="8500"
	serviceusername="mgifford"
	servicepassword="mgifford" /&gt;</pre>
<p>In the above code block, I am defining the connection details for my local ColdFusion 9 development server, which uses the built-in web server. Set the server name (the server name or iP address), the port on which the ColdFusion server is running and the service username and password, which is set in the ColdFusion Administrator.</p>
<h3>File uploads using the Util class</h3>
<p>The first step of user-interaction with this application is to drag and drop an image onto the image panel.</p>
<p>The <strong>init()</strong> method is run on creationComplete of the AIR application, and sets up the initial variables and handlers. We are accepting gif, jpg or png image formats, as defined in the imgArray variable below. The event listeners for the drag and drop have been added to the imagePanel component in the mxml code.</p>
<p>The important code to note here is the creation of the variables handling the file upload. We are using the details set in the cf:Conf tag to call the variables into the Actionscript (conf.serviceUsername etc)</p>
<pre name="code" class="java">// constructor method
// add event listeners to the panel for interaction, define the array of 'permitted' images,
// and set up the ColdFusion web access for uploads
private function init():void {
	imagePanel.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragEnter);
	imagePanel.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDragDrop);
	imgArray = new Array('gif','jpg','png');

	var variables:URLVariables = new URLVariables();
	variables.serviceusername  = conf.serviceUserName;
	variables.servicepassword  = conf.servicePassword;

	uploadUrl.url		   = "http://" + conf.cfServer + ":" + conf.cfPort + "" + Util.UPLOAD_URL;
	uploadUrl.method 	   = "POST";
	uploadUrl.contentType   = "multipart/form-data";
	uploadUrl.data		   = variables;

	controlPanel.enabled	   = false;
	mailPanel.enabled	   = false;
}</pre>
<p>The uploadUrl.url variable also uses the settings written in the cf:Config tag, and the <strong>UPLOAD_URL</strong> variable is a constant from the Util class that contains the url on the ColdFusion server of the Upload service, relative to the CF webroot, which generates the following location:<br />
<code>http://localhost:8500/CFIDE/services/upload.cfc?METHOD=uploadForm</code></p>
<p>We are also sending through the conf.serviceUserName and conf.servicePassword variables in the uploadUrl.data. As the WSDL services are behind the CFIDE on the ColdFusion server, we need to send these through to authenticate and access the CFCs.</p>
<p>Below is the <strong>onDragDrop()</strong> method which runs after the file extension has been accepted by the application:</p>
<pre name="code" class="java">// on drop, set the image source, apply the image title to the panel, and upload the file for use
// with the ColdFusion services
private function onDragDrop(e:NativeDragEvent):void {
	var fa:Object 		= e.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT);
	// set the title of the panel with the file name of the image
	imagePanel.title 	= fa[0].name;

	// start the file upload to the ColdFusion server
	file = FileReference(fa[0]);
	file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadComplete);
	file.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
	file.upload(uploadUrl);
}</pre>
<p>To note in the above code block, the accepted drag image is stored in the <strong>fa</strong> Object variable, which is then cast to a File reference. The file then uploads the accepted drag image to the ColdFusion Upload class, and runs the <strong>onUploadComplete()</strong> method after a successful transaction:</p>
<pre name="code" class="java">// run after initial drag/drop to obtain the file and run the ColdFusion image info service
private function onUploadComplete(event:DataEvent):void {
	uploadedFileUrl = Util.extractURLFromUploadResponse(event.data.toString());
	dragImage.source = uploadedFileUrl;
	getImageInfo.execute();
}</pre>
<p>The <strong>onUploadComplete()</strong> method handles the return from the ColdFusion server. Here, we use the Util class again with the <strong> extractURLFromUploadResponse()</strong> method.</p>
<p>This takes the response returned from the Upload service and extracts the path of the uploaded file on the ColdFusion server. The url returned from the server and obtained from the method will be similar to the following:<br />
<code>http://localhost:8500/CFFileServlet/_cfservicelayer/_cf6722484872514459847.png</code></p>
<p>Transmitting files to your CF server and getting the exact string back to you has never been easier, all thanks to the power of the exposed services in ColdFusion 9.</p>
<p>The final line of the above code block runs the first of the &lt;cf:Image /&gt; tags with the id getImageInfo. The CF proxy classes are run using the <strong>execute()</strong> method, and the image tag in question is shown below:</p>
<pre name="code" class="java">&lt;cf:image
	id="getImageInfo"
	action="info"
	source="{dragImage.source}"
	result="imageInfoResult(event)"
	fault="onFault(event)"&gt;

&lt;/cf:image&gt;</pre>
<p>Again, you can see that with the exception of the required result and fault handler methods, the service tags available for use in the FLEX application are identical to the matching tags available when coding directly into a ColdFusion .cfm page.</p>
<h3>Streamlining the image tags</h3>
<p>This application has four &lt;cf:Image /&gt; tags in use, each of which run a separate function and have individual result and fault handlers.</p>
<p>The Image service allows for batch processing, which gives the developer the ability to send through an associative array of information to the class to run and manipulate the image, like so:</p>
<p>Actionscript:</p>
<pre name="code" class="java">[Bindable] public var arrAttributes:Array =
    [{Resize:{width:"75%",height:"75%"}},
    {Flip:{transpose:"270"}}]</pre>
<p>MXML:</p>
<pre name="code" class="java">&lt;cf:image
	id="batchImage"
	action="batchoperation"
	source="{path to image source}"
	attributes="{arrAttributes}"&gt;

&lt;/cf:image&gt;</pre>
<p>The ability to batch process image amendments, sending multiple parameters through to the service in one action is a fantastic way to help streamline the code and get the most out of the awesome CF9 image functions on the server.</p>
<p>We will cover the batch processing in more detail in a later tutorial.</p>
<h3>Sending Mail</h3>
<p>An incredibly exciting function now available to us for use in the FLEX application is the ability to send email using the ColdFusion server.</p>
<p><a href="/assets/uploads/2009/11/rotatedImage1.png"><img title="Image edited in AIR application" src="/assets/uploads/2009/11/rotatedImage1.png" alt="Image edited in AIR application" /></a></p>
<p>In our demo application, we allow the user the ability to send an email with the amended image as an attachment. The cf:Mail tag is fairly self-explanatory, containing the standard attributes required for the mail tag to run, with the addition of the result and fault handlers to control the success or failure events.</p>
<p>MXML Mail Tag:</p>
<pre name="code" class="java">&lt;cf:mail
	id="sendMail"
	to="{mailTo.text}"
	from="{mailFrom.text}"
	subject="Test message"
	result="mailSuccess(event)"
	fault="mailFailure(event)"&gt;

&lt;/cf:mail&gt;</pre>
<p>The image attachment is handled in the Actionscript file within the <strong>sendEmail()</strong> method which is run after clicking the 'Send Email' button.<br />
The image is added to an array called 'attachCollection', which in turn is added to the email attachments attribute. The above <strong>sendMail</strong> mail tag is run using the <strong>execute()</strong> method.</p>
<p>Actionscript:</p>
<pre name="code" class="java">private function sendEmail():void {
        attachCollection[0] = {"file": dragImage.source};
        sendMail.attachments = attachCollection;
        sendMail.execute();
}</pre>
<p><a href="/assets/uploads/2009/11/emailattachment.png"><img title="Image received as attachment" src="/assets/uploads/2009/11/emailattachment.png" alt="Image received as attachment" /></a></p>
<h3>Final Notes</h3>
<p>I hope that this tutorial/explanation of using ColdFusion as a Service in your FLEX/AIR applications has been an eye-opener if nothing else. I was truly excited by this feature when I had read about it in the documentation during the CF9 BETA testing.</p>
<p>I personally believe it has opened the doors for increased RIA development, and the ability to utilise the CF features on other development languages goes to highlight the strength and power that ColdFusion possesses as a server language.<br />
Hopefully other developers will realise the benefits of using ColdFusion too.</p>
<h3>Complete code</h3>
<p>The complete code has been supplied in the attached ZIP file below as an exported Flex Builder project (the main MXML file and the script.as file) to replicate the demo application.</p>
<p><a title="Download the CFaaS demo application" href="http://www.monkehworks.com/downloads/CFaaSDemoApplication.zip" target="_blank">Download the sample CFaaS Flex Builder application</a></p>
