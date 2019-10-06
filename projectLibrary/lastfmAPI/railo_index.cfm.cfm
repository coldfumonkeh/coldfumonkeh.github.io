<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<title>Demo</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<style>
	.error {font-weight : bold;color:red;}
	</style>
</head>

<body>
<h1>Railo Administrator</h1>
<a href="railo-context/admin.cfm">admin</a><br>

<cfoutput>
<cfloop from="1" to="5" index="in">
	#in#<br />
</cfloop>
</cfoutput>


<h1>Railo Dumps</h1>

	<!--- Default Werte --->
	<cfparam name="url.test" default="Hallo URL">
	<cfparam name="form.test" default="Hallo FORM">
	<cfset test="Hallo Variables">
	
	<cfdump var="#test#" label="test">
	<cfdump var="#url#" label="url">
	<cfdump var="#form#" label="form">
	<cfdump var="#request#" label="request">
	<cfdump var="#variables#" label="variables">
	<cfdump var="#server#" label="server">
	
<!--- new railo build in type constructors---> 
	<cfdump var="#array(1,2,3,"aaa")#" label="array">
	<cfdump var="#struct(a:1,b:2,c:3,d:"aaa")#" label="struct">
	<cfdump var="#query(col1:array(1.1,1.2,1,3),col2:array(2.1,2.2,2,3))#" label="query">

	
</body>
</html>
