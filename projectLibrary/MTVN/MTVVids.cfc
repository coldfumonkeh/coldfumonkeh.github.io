<!---
Name: MTVVids.cfc
Author: Matt Gifford (http://www.mattgifford.co.uk/)
Date: Friday 31st October, 2008 (Happy Halloween)
Purpose: a CFC created for ColdFusion users to interact with the MTV Networks API (http://developer.mtvnservices.com/)
Copyright (c) 2008 Matt Gifford
Licensed under the Creative Commons Attribution-Noncommercial-ShareAlike License
http://creativecommons.org/licenses/by-nc-sa/3.0/

If you use this CFC, like it, or just want to be friendly, please drop by my site/blog/project page to say hello.
It would be great to hear from people using this CFC. Many thanks.

--->


<cfcomponent displayname="MTVVids" hint="contains functions to access the MTVN video API">
	
	<cffunction name="searchVideo" output="yes" access="public" returntype="any">
		<cfargument name="searchTerm" required="yes" type="string" hint="the name of the artist/band to search for. The function will escape any characters and URLEncode the term for you" />
		<cfargument name="maxResults" required="no" type="numeric" default="1" hint="the maximum number of results you want returned" />
		<cfargument name="includeRelated" required="no" type="string" default="yes" hint="if yes, an extra struct is included, which holds the details of artists/bands related to the selected artist" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, the results will be returned as a query recordset. Default is 'no'" />
			<cftry>
			<cfset feedURL = "http://api.mtvnservices.com/1/video/search/?term=#URLEncodedFormat(arguments.searchTerm)#&max-results=#arguments.maxResults#&start-index=1" />
			<cfhttp url="#feedURL#" />
			
				<!--- create the return struct and array --->
				<cfset searchResults = "#cfhttp.filecontent#" />

				<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
				<cfset searchResults = searchResults.ReplaceAll("(</?)(\w+:)","$1") />
				<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
				<cfset searchResults = searchResults.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

				<cfset returnedXML = XmlParse(searchResults)>				
				<!--- create the base foundation for the struct --->
				<cfset resultStr = StructNew()>
				
				<cfset ItemNodes = xmlSearch(#searchResults#,'/feed/entry')>
				<cfset itemsArr = ArrayNew(1)>
				<cfif arraylen(ItemNodes) GT 0>
					<cfloop from="1" to="#arraylen(ItemNodes)#" index="i">

					<cfset ItemStr = StructNew()>

					<cfset ItemXML = xmlparse(ItemNodes[i])>
					<cfset ItemStr.title = #ItemXML.entry.title.XmlText#>
					<cfset ItemStr.id = #ItemXML.entry.id.XmlText#>
					<cfset ItemStr.description = #ItemXML.entry.description.XmlText#>

					<cfset contentNodes = xmlSearch(#ItemXML#,'/entry/content/')>
					<cfif arraylen(contentNodes) GT 0>
						<cfloop from="1" to="#ArrayLen(contentNodes)#" index="k">
							<cfset ContentXML = xmlparse(contentNodes[k])>
							<cfset ItemStr.mediaContent = #ContentXML.content.XmlAttributes#>
						</cfloop>
					</cfif>
					
					<cfset ItemStr.mediaPlayer = #ItemXML.entry.player.XmlAttributes#>

					<!--- get links (used for the extra API references --->
					<cfset linkNodes = xmlSearch(#ItemXML#,'/entry/link/')>
					<cfif arraylen(linkNodes) GT 0>
						<cfset linkArr = ArrayNew(1)>
						<cfloop from="1" to="#ArrayLen(linkNodes)#" index="k">
							<cfset LinkXML = xmlparse(linkNodes[k])>
							<cfset linkArr[k] = #LinkXML.link.XmlAttributes#>
							<!--- get the artist uri from the rel attribute --->
							<!--- this is required to use other services, such as related artists --->					
							<cfif structKeyExists(#LinkXML.link.XmlAttributes#, "rel") AND #LinkXML.link.XmlAttributes.rel# EQ 'http://api.mtvnservices.com/1/schemas/artist'>
								<cfset resultStr.artist_uri = #LinkXML.link.XmlAttributes.href#>
								<cfset resultStr.artistRelatedLink = "#LinkXML.link.XmlAttributes.href#related/">
							</cfif>
						</cfloop>
						<cfset ItemStr.links = #linkArr#>
					</cfif>

					<cfset thumbnailNodes = xmlSearch(#ItemXML#,'/entry/thumbnail/')>
					<cfif arraylen(thumbnailNodes) GT 0>
						<!--- get the thumbnails --->
						<cfset thumbArr = ArrayNew(1)>
						<cfloop from="1" to="#ArrayLen(thumbnailNodes)#" index="k">
							<cfset ThumbXML = xmlparse(thumbnailNodes[k])>
							<cfset thumbArr[k] = #ThumbXML.thumbnail.XmlAttributes#>
						</cfloop>
						<cfset ItemStr.mediaThumbnails = #thumbArr#>
					<cfelse>
						<cfset ItemStr.mediaThumbnails = ArrayNew(1)>
					</cfif>

					<cfset ItemStr.keywords = #ItemXML.entry.keywords.XmlText#>

					<cfset creditNodes = xmlSearch(#ItemXML#,'/entry/credit/')>
					<cfif arraylen(creditNodes) GT 0>
						<!--- get the credits --->
						<cfset creditArr = ArrayNew(1)>
						<cfloop from="1" to="#ArrayLen(creditNodes)#" index="l">
							<cfset CreditXML = xmlparse(creditNodes[l])>
							<cfset creditStr = #CreditXML.credit.XmlAttributes#>
							<cfset temp = StructInsert(creditStr, "individual", #CreditXML.credit.XmlText#)>
							<cfset creditArr[l] = #CreditXML.credit.XmlAttributes#>
						</cfloop>
						<cfset ItemStr.mediaCredits = #creditArr#>
					</cfif>

					<cfset categoryNodes = xmlSearch(#ItemXML#,'/entry/category/')>
					<cfif arraylen(categoryNodes) GT 0>
						<!--- get the categories --->
						<cfset categoryArr = ArrayNew(1)>
						<cfloop from="1" to="#ArrayLen(categoryNodes)#" index="l">
							<cfset CategoryXML = xmlparse(categoryNodes[l])>
							<cfset categoryStr = #CategoryXML.category.XmlAttributes#>
							<cfset temp = StructInsert(categoryStr, "individual", #CategoryXML.category.XmlText#)>
							<cfset categoryArr[l] = #CategoryXML.category.XmlAttributes#>
						</cfloop>
						<cfset ItemStr.mediaCategory = #categoryArr#>
					</cfif>

					<cfset itemsArr[i] = ItemStr>

					</cfloop>
				
					<cfset resultStr.id = #returnedXML.feed.id.XmlText#>
					<cfset resultStr.updated = #returnedXML.feed.updated.XmlText#>
					<cfset resultStr.title = #returnedXML.feed.title.XmlText#>
					<cfset resultStr.link = #returnedXML.feed.link.XmlAttributes#>
					<cfset resultStr.items = #itemsArr#>
					<cfset resultStr.success = 1>

					<cfif #arguments.includeRelated# EQ 'yes'>
						<cfset resultStr.relatedArtists = getRelatedArtists(#resultStr.artistRelatedLink#).items>
					</cfif>
				
					<cfif arguments.returnQuery EQ 'yes'>
						<cfset resultStr = QueryNew("artist_uri,name,videoID,description,keywords,mediaplayer,category,videoDuration,videoExpression,videoIsDefault,videoMedium,videoType,videoURL,credits,thumbnails")>
						<cfset newRow = QueryAddRow(resultStr, #arrayLen(itemsArr)#)>
						<cfloop from="1" to="#arrayLen(itemsArr)#" index="rq">
							<!--- Set the values of the cells in the query --->
							<cfset temp = QuerySetCell(resultStr, "name", "#itemsArr[rq].title#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoID", "#itemsArr[rq].id#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "description", "#itemsArr[rq].description#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "keywords", "#itemsArr[rq].keywords#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "mediaplayer", "#itemsArr[rq].mediaplayer.url#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "artist_uri", "#itemsArr[rq].links[2].href#", #rq#)>
							
							<!--- get media details --->
							<cfset temp = QuerySetCell(resultStr, "videoDuration", "#itemsArr[rq].mediacontent.duration#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoExpression", "#itemsArr[rq].mediacontent.expression#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoIsDefault", "#itemsArr[rq].mediacontent.isdefault#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoMedium", "#itemsArr[rq].mediacontent.medium#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoType", "#itemsArr[rq].mediacontent.type#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoURL", "#itemsArr[rq].mediacontent.url#", #rq#)>
							
							<cfset temp = QuerySetCell(resultStr, "category", "#itemsArr[rq].mediacategory#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "credits", "#itemsArr[rq].mediacredits#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "mediaPlayer", "#itemsArr[rq].mediaPlayer.url#", #rq#)>
							
							<cfset temp = QuerySetCell(resultStr, "thumbnails", "#itemsArr[rq].mediathumbnails#", #rq#)>
						</cfloop>
					</cfif>
				<cfelse>
					<cfset resultStr.success = 0>
				</cfif>
	
				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>	
		<cfreturn resultStr />
	</cffunction>
	
	<cffunction name="getVideoByID" output="true" access="public" returnType="any">
		<cfargument name="videoID" required="true" type="string" hint="a link string, containing the unique video reference (eg: http://api.mtvnservices.com/1/video/hznHivqrbHHZDPDWS/)" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, the results will be returned as a query recordset. Default is 'no'" />
			<cfset var feedURL = ''>
			<cfset var videoDetails = ''>
			<cfset var returnedXML = ''>
			<cfset var ItemNodes = ''>
			<cfset var itemsArr = ''>
			<cfset var ItemStr = ''>
			<cfset var ItemXML = ''>
			<cfset var contentNodes = ''>
			<cfset var ContentXML = ''>
			<cfset var linkNodes = ''>
			<cfset var linkArr = ''>
			<cfset var LinkXML = ''>
			<cfset var thumbnailNodes = ''>
			<cfset var thumbArr = ''>
			<cfset var ThumbXML = ''>
			<cfset var creditNodes = ''>
			<cfset var creditArr = ''>
			<cfset var CreditXML = ''>
			<cfset var creditStr = ''>
			<cfset var categoryNodes = ''>
			<cfset var categoryArr = ''>
			<cfset var CategoryXML = ''>
			<cfset var categoryStr = ''>
		
			<cftry>
		
			<cfset feedURL = "#arguments.videoID#" />
			<cfhttp url="#feedURL#" />
				
				<!--- create the return struct and array --->
				<cfset videoDetails = "#cfhttp.filecontent#" />

				<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
				<cfset videoDetails = videoDetails.ReplaceAll("(</?)(\w+:)","$1") />
				<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
				<cfset videoDetails = videoDetails.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

				<cfset returnedXML = XmlParse(videoDetails)>
				
				<cfset ItemNodes = xmlSearch(#videoDetails#,'/entry')>
				<cfset itemsArr = ArrayNew(1)>
				<cfif arraylen(ItemNodes) GT 0>
					<cfloop from="1" to="#arraylen(ItemNodes)#" index="i">
						<cfset ItemStr = StructNew()>
						<cfset ItemXML = xmlparse(ItemNodes[i])>
						<cfset ItemStr.title = #ItemXML.entry.title.XmlText#>
						<cfset ItemStr.id = #ItemXML.entry.id.XmlText#>
						<cfset ItemStr.description = #ItemXML.entry.description.XmlText#>

						<cfset contentNodes = xmlSearch(#ItemXML#,'/entry/content/')>
						<cfif arraylen(contentNodes) GT 0>
							<cfloop from="1" to="#ArrayLen(contentNodes)#" index="k">
								<cfset ContentXML = xmlparse(contentNodes[k])>
								<cfset ItemStr.mediaContent = #ContentXML.content.XmlAttributes#>
							</cfloop>
						</cfif>

						<cfset ItemStr.mediaPlayer = #ItemXML.entry.player.XmlAttributes#>

						<!--- get links (used for the extra API references --->
						<cfset linkNodes = xmlSearch(#ItemXML#,'/entry/link/')>
						<cfif arraylen(linkNodes) GT 0>
							<cfset linkArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(linkNodes)#" index="k">
								<cfset LinkXML = xmlparse(linkNodes[k])>
								<cfset linkArr[k] = #LinkXML.link.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.links = #linkArr#>
						</cfif>

						<cfset thumbnailNodes = xmlSearch(#ItemXML#,'/entry/thumbnail/')>
						<cfif arraylen(thumbnailNodes) GT 0>
							<!--- get the thumbnails --->
							<cfset thumbArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(thumbnailNodes)#" index="k">
								<cfset ThumbXML = xmlparse(thumbnailNodes[k])>
								<cfset thumbArr[k] = #ThumbXML.thumbnail.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.mediaThumbnails = #thumbArr#>
						<cfelse>
							<cfset ItemStr.mediaThumbnails = ArrayNew(1)>
						</cfif>

						<cfset ItemStr.keywords = #ItemXML.entry.keywords.XmlText#>

						<cfset creditNodes = xmlSearch(#ItemXML#,'/entry/credit/')>
						<cfif arraylen(creditNodes) GT 0>
							<!--- get the credits --->
							<cfset creditArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(creditNodes)#" index="l">
								<cfset CreditXML = xmlparse(creditNodes[l])>
								<cfset creditStr = #CreditXML.credit.XmlAttributes#>
								<cfset temp = StructInsert(creditStr, "individual", #CreditXML.credit.XmlText#)>
								<cfset creditArr[l] = #CreditXML.credit.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.mediaCredits = #creditArr#>
						</cfif>

						<cfset categoryNodes = xmlSearch(#ItemXML#,'/entry/category/')>
						<cfif arraylen(categoryNodes) GT 0>
							<!--- get the categories --->
							<cfset categoryArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(categoryNodes)#" index="l">
								<cfset CategoryXML = xmlparse(categoryNodes[l])>
								<cfset categoryStr = #CategoryXML.category.XmlAttributes#>
								<cfset temp = StructInsert(categoryStr, "individual", #CategoryXML.category.XmlText#)>
								<cfset categoryArr[l] = #CategoryXML.category.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.mediaCategory = #categoryArr#>
						</cfif>
						<cfset itemsArr[i] = ItemStr>
					</cfloop>
					
					<!--- add the items to the base foundations --->
					<cfset resultStr.id = #returnedXML.entry.id.XmlText#>
					<cfset resultStr.updated = #returnedXML.entry.updated.XmlText#>
					<cfset resultStr.title = #returnedXML.entry.title.XmlText#>
					<cfset resultStr.link = #returnedXML.entry.link.XmlAttributes#>
					<cfset resultStr.items = #itemsArr#>
					
					
					<cfif arguments.returnQuery EQ 'yes'>
						<cfset resultStr = QueryNew("name, videoID, description,keywords,videoDuration,videoExpression,videoIsDefault,videoMedium,videoType,videoURL,category,credits,mediaPlayer,thumbnails")>
						<cfset newRow = QueryAddRow(resultStr, #arrayLen(itemsArr)#)>
						<cfloop from="1" to="#arrayLen(itemsArr)#" index="rq">
							<!--- Set the values of the cells in the query --->
							<cfset temp = QuerySetCell(resultStr, "name", "#returnedXML.entry.title.XmlText#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoID", "#returnedXML.entry.id.XmlText#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "description", "#itemsArr[rq].description#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "keywords", "#itemsArr[rq].keywords#", #rq#)>
							
							<!--- get media details --->
							<cfset temp = QuerySetCell(resultStr, "videoDuration", "#itemsArr[rq].mediacontent.duration#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoExpression", "#itemsArr[rq].mediacontent.expression#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoIsDefault", "#itemsArr[rq].mediacontent.isdefault#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoMedium", "#itemsArr[rq].mediacontent.medium#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoType", "#itemsArr[rq].mediacontent.type#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoURL", "#itemsArr[rq].mediacontent.url#", #rq#)>
							
							<cfset temp = QuerySetCell(resultStr, "category", "#itemsArr[rq].mediacategory#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "credits", "#itemsArr[rq].mediacredits#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "mediaPlayer", "#itemsArr[rq].mediaPlayer.url#", #rq#)>
							
							<cfset temp = QuerySetCell(resultStr, "thumbnails", "#itemsArr[rq].mediathumbnails#", #rq#)>
							
						</cfloop>
					</cfif>
					
				</cfif>

				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>

		<cfreturn resultStr />
	</cffunction>
	
	
	<cffunction name="getRelatedArtists" access="public" output="true" returnType="any">
		<cfargument name="artistRelatedLink" required="yes" type="string" hint="a link containing the artist uri (eg: http://api.mtvnservices.com/1/artist/[artist_uri]/related/)" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, the results will be returned as a query recordset. Default is 'no'." />
			
			<cftry>
			
			<cfset feedURL = "#arguments.artistRelatedLink#" />
			<cfhttp url="#feedURL#" />
			
				<!--- create the return struct and array --->
				<cfset relatedArtistsResults = "#cfhttp.filecontent#" />

				<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
				<cfset relatedArtistsResults = relatedArtistsResults.ReplaceAll("(</?)(\w+:)","$1") />
				<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
				<cfset relatedArtistsResults = relatedArtistsResults.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

				<cfset returnedXML = XmlParse(relatedArtistsResults)>
				
				<!--- create the base foundation for the struct --->
				<cfset relatedResultStr = StructNew()>
				
				<cfset ItemNodes = xmlSearch(#relatedArtistsResults#,'/feed/entry')>

				<cfset relatedItemsArr = ArrayNew(1)>
				
				<cfif arraylen(ItemNodes) GT 0>
					<cfloop from="1" to="#arraylen(ItemNodes)#" index="i">
						<cfset ItemStr = StructNew()>
						<cfset ItemXML = xmlparse(ItemNodes[i])>
						<cfset ItemStr.title = #ItemXML.entry.title.XmlText#>
						<cfset ItemStr.id = #ItemXML.entry.id.XmlText#>

						<!--- get links (used for the extra API references --->
						<cfset linkNodes = xmlSearch(#ItemXML#,'/entry/link/')>
						<cfif arraylen(linkNodes) GT 0>
							<cfset linkArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(linkNodes)#" index="k">
								<cfset LinkXML = xmlparse(linkNodes[k])>
								<cfset linkArr[k] = #LinkXML.link.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.links = #linkArr#>
						</cfif>
						<cfset relatedItemsArr[i] = ItemStr>
					</cfloop>
					
					<!--- add the items to the base foundations --->
					<cfset relatedResultStr.id = #returnedXML.feed.id.XmlText#>
					<cfset relatedResultStr.updated = #returnedXML.feed.updated.XmlText#>
					<cfset relatedResultStr.title = #returnedXML.feed.title.XmlText#>
					<cfset relatedResultStr.link = #returnedXML.feed.link.XmlAttributes#>
					<cfset relatedResultStr.items = #relatedItemsArr#>
					
					<cfif arguments.returnQuery EQ 'yes'>
						<cfset relatedResultStr = QueryNew("name, artist_uri, relatedLink", "VarChar, VarChar, VarChar")>
						<cfset newRow = QueryAddRow(relatedResultStr, #arrayLen(relatedItemsArr)#)>
						<cfloop from="1" to="#arrayLen(relatedItemsArr)#" index="rq">
							<!--- Set the values of the cells in the query --->
							<cfset temp = QuerySetCell(relatedResultStr, "name", "#relatedItemsArr[rq].title#", #rq#)>
							<cfset temp = QuerySetCell(relatedResultStr, "artist_uri", "#relatedItemsArr[rq].id#", #rq#)>
							<cfset temp = QuerySetCell(relatedResultStr, "relatedLink", "#relatedItemsArr[rq].links[2].href#", #rq#)>
						</cfloop>
					</cfif>
					
				</cfif>
			
				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>
			
		<cfreturn relatedResultStr />
	</cffunction>
	
	<cffunction name="getArtistAlias" output="true" access="public" returntype="any">
		<cfargument name="artistURI" required="yes" type="string" hint="the unique uri link for the artist (eg: http://api.mtvnservices.com/1/artist/[artist_uri]/)" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, the results will be returned as a query recordset. Default is 'no'." />
			
			<cftry>
			
			<cfset feedURL = "#arguments.artistURI#" />
			<cfhttp url="#feedURL#" />
			
				<!--- create the return struct and array --->
				<cfset aliasResults = "#cfhttp.filecontent#" />

				<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
				<cfset aliasResults = aliasResults.ReplaceAll("(</?)(\w+:)","$1") />
				<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
				<cfset aliasResults = aliasResults.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

				<cfset returnedXML = XmlParse(aliasResults)>
								
				<!--- create the base foundation for the struct --->
				<cfset aliasResultStr = StructNew()>
				
				<!--- only run if there are items within the xml --->
				<cfset rootNodes = xmlSearch(#returnedXML#,'/entry/')>
				<cfif arrayLen(rootNodes) GT 0>
									
					<cfset thumbnailNodes = xmlSearch(#returnedXML#,'/entry/thumbnail/')>
					<!--- get the thumbnails --->
					<cfset thumbArr = ArrayNew(1)>
					
					<cfif arraylen(thumbnailNodes) GT 0>
						<cfloop from="1" to="#ArrayLen(thumbnailNodes)#" index="k">
							<cfset ThumbXML = xmlparse(thumbnailNodes[k])>
							<cfset thumbArr[k] = #ThumbXML.thumbnail.XmlAttributes#>
						</cfloop>
						<cfset aliasResultStr.artistThumbnails = #thumbArr#>
					</cfif>
					
					<cfset aliasLinkNodes = xmlSearch(#returnedXML#,'/feed/entry/')>
					<!--- get the thumbnails --->
					<cfset aliasLinkArr = ArrayNew(1)>
					
					<cfif arraylen(aliasLinkNodes) GT 0>
						<cfloop from="1" to="#ArrayLen(aliasLinkNodes)#" index="k">
							<cfset AliasLinkXML = xmlparse(aliasLinkNodes[k])>
							<cfset aliasLinkArr[k] = #AliasLinkXML.link.XmlAttributes#>
						</cfloop>
						<cfset aliasResultStr.artistAliasLinks = #aliasLinkArr#>
					</cfif>
					
					<cfif arguments.returnQuery EQ 'yes'>
					
					</cfif>
					
				</cfif>
			
				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>

		<cfreturn aliasResultStr />
	</cffunction>
	
	
	
	<cffunction name="allVideosByArtist" output="yes" access="public" returntype="any">
		<cfargument name="artist_uri" required="yes" type="string" hint="the unique uri link for the artist (eg: http://api.mtvnservices.com/1/artist/[artist_uri]/videos/)" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, the results will be returned as a query recordset. Default is 'no'." />
			<cfset var feedURL = ''>
			<cfset var searchResults = ''>
			<cfset var allVideoXML = ''>
			<cfset var resultStr = ''>
			<cfset var ItemNodes = ''>
			<cfset var videoItemsArr = ''>
			<cfset var ItemStr = ''>
			<cfset var ItemXML = ''>
			<cfset var contentNodes = ''>
			<cfset var ContentXML = ''>
			<cfset var linkNodes = ''>
			<cfset var linkArr = ''>
			<cfset var LinkXML = ''>
			<cfset var thumbnailNodes = ''>
			<cfset var thumbArr = ''>
			<cfset var ThumbXML = ''>
			<cfset var creditNodes = ''>
			<cfset var creditArr = ''>
			<cfset var CreditXML = ''>
			<cfset var creditStr = ''>
			<cfset var categoryNodes = ''>
			<cfset var categoryArr = ''>
			<cfset var CategoryXML = ''>
			<cfset var categoryStr = ''>
		
			<cftry>
		
			<cfset feedURL = "#arguments.artist_uri#" />
			<cfhttp url="#feedURL#" />

				<!--- create the return struct and array --->
				<cfset searchResults = "#cfhttp.filecontent#" />

				<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
				<cfset searchResults = searchResults.ReplaceAll("(</?)(\w+:)","$1") />
				<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
				<cfset searchResults = searchResults.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

				<cfset allVideoXML = XmlParse(searchResults)>
																
				<!--- create the base foundation for the struct --->
				<cfset resultStr = StructNew()>
				
				<cfset ItemNodes = xmlSearch(#searchResults#,'/feed/entry/')>
				<cfset NoNodes = xmlSearch(#searchResults#,'/h1/')>
																
				<cfset videoItemsArr = ArrayNew(1)>

				<cfif arraylen(ItemNodes) GT 0>
					<cfloop from="1" to="#arraylen(ItemNodes)#" index="allVidLoop">
						<cfset ItemStr = StructNew()>
						<cfset ItemXML = xmlparse(ItemNodes[allVidLoop])>

						<cfset ItemStr.title = #ItemXML.entry.title.XmlText#>
						<cfset ItemStr.id = #ItemXML.entry.id.XmlText#>

						<cfset contentNodes = xmlSearch(#ItemXML#,'/entry/content/')>
						<cfif arraylen(contentNodes) GT 0>
							<cfloop from="1" to="#ArrayLen(contentNodes)#" index="k">
								<cfset ContentXML = xmlparse(contentNodes[k])>
								<cfset ItemStr.mediaContent = #ContentXML.content.XmlAttributes#>
							</cfloop>
						</cfif>

						<!--- get links (used for the extra API references --->
						<cfset linkNodes = xmlSearch(#ItemXML#,'/entry/link/')>
						<cfif arraylen(linkNodes) GT 0>
							<cfset linkArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(linkNodes)#" index="k">
								<cfset LinkXML = xmlparse(linkNodes[k])>
								<cfset linkArr[k] = #LinkXML.link.XmlAttributes#>
								<!--- get the artist uri from the rel attribute --->
								<!--- this is required to use other services, such as related artists --->
								<cfset artist_uri = StructFindValue( #LinkXML.link.XmlAttributes#, "235" )>
								<cfif structKeyExists(#LinkXML.link.XmlAttributes#, "rel") AND #LinkXML.link.XmlAttributes.rel# EQ 'http://api.mtvnservices.com/1/schemas/artist'>
									<cfset resultStr.artist_uri = #LinkXML.link.XmlAttributes.href#>
									<cfset resultStr.artistRelatedLink = "#LinkXML.link.XmlAttributes.href#related/">
								</cfif>
							</cfloop>
							<cfset ItemStr.links = #linkArr#>
						</cfif>

						<cfset thumbnailNodes = xmlSearch(#ItemXML#,'/entry/thumbnail/')>
						<cfif arraylen(thumbnailNodes) GT 0>
							<!--- get the thumbnails --->
							<cfset thumbArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(thumbnailNodes)#" index="k">
								<cfset ThumbXML = xmlparse(thumbnailNodes[k])>
								<cfset thumbArr[k] = #ThumbXML.thumbnail.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.mediaThumbnails = #thumbArr#>
						<cfelse>
							<cfset ItemStr.mediaThumbnails = ArrayNew(1)>
						</cfif>
					
						<cfset creditNodes = xmlSearch(#ItemXML#,'/entry/credit/')>
						<cfif arraylen(creditNodes) GT 0>
							<!--- get the credits --->
							<cfset creditArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(creditNodes)#" index="l">
								<cfset CreditXML = xmlparse(creditNodes[l])>
								<cfset creditStr = #CreditXML.credit.XmlAttributes#>
								<cfset temp = StructInsert(creditStr, "individual", #CreditXML.credit.XmlText#)>
								<cfset creditArr[l] = #CreditXML.credit.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.mediaCredits = #creditArr#>
						</cfif>

						<cfset categoryNodes = xmlSearch(#ItemXML#,'/entry/category/')>
						<cfif arraylen(categoryNodes) GT 0>
							<!--- get the categories --->
							<cfset categoryArr = ArrayNew(1)>
							<cfloop from="1" to="#ArrayLen(categoryNodes)#" index="l">
								<cfset CategoryXML = xmlparse(categoryNodes[l])>
								<cfset categoryStr = #CategoryXML.category.XmlAttributes#>
								<cfset temp = StructInsert(categoryStr, "individual", #CategoryXML.category.XmlText#)>
								<cfset categoryArr[l] = #CategoryXML.category.XmlAttributes#>
							</cfloop>
							<cfset ItemStr.mediaCategory = #categoryArr#>
						</cfif>

						<cfset videoItemsArr[allVidLoop] = ItemStr>

					</cfloop>
					
					<cfset resultStr.id = #allVideoXML.feed.id.XmlText#>
					<cfset resultStr.updated = #allVideoXML.feed.updated.XmlText#>
					<cfset resultStr.title = #allVideoXML.feed.title.XmlText#>
					<cfset resultStr.link = #allVideoXML.feed.link.XmlAttributes#>
					<cfset resultStr.items = #videoItemsArr#>
				
					<cfif arguments.returnQuery NEQ 'no'>
						<cfset resultStr = QueryNew("videoID, title, thumbnails, credits, category, artist_uri, artistrelatedLink, artistvideoLink, videoDuration, videoExpression, videoIsDefault, videoMedium, videoType, videoURL")>
						<cfset newRow = QueryAddRow(resultStr, #arrayLen(videoItemsArr)#)>
						<cfloop from="1" to="#arrayLen(videoItemsArr)#" index="rq">
							<!--- Set the values of the cells in the query --->
							<cfset temp = QuerySetCell(resultStr, "videoID", "#videoItemsArr[rq].id#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "title", "#videoItemsArr[rq].title#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "artist_uri", "#LinkXML.link.XmlAttributes.href#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "artistrelatedLink", "#LinkXML.link.XmlAttributes.href#related/", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "artistvideoLink", "#allVideoXML.feed.id.XmlText#", #rq#)>
							
							<!--- get media details --->
							<cfset temp = QuerySetCell(resultStr, "videoDuration", "#videoItemsArr[rq].mediacontent.duration#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoExpression", "#videoItemsArr[rq].mediacontent.expression#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoIsDefault", "#videoItemsArr[rq].mediacontent.isdefault#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoMedium", "#videoItemsArr[rq].mediacontent.medium#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoType", "#videoItemsArr[rq].mediacontent.type#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "videoURL", "#videoItemsArr[rq].mediacontent.url#", #rq#)>
							
							<cfset temp = QuerySetCell(resultStr, "category", "#videoItemsArr[rq].mediacategory#", #rq#)>
							<cfset temp = QuerySetCell(resultStr, "credits", "#videoItemsArr[rq].mediacredits#", #rq#)>
							
							<cfset temp = QuerySetCell(resultStr, "thumbnails", "#videoItemsArr[rq].mediathumbnails#", #rq#)>
						</cfloop>
					</cfif>
					
				<cfelseif arrayLen(NoNodes) GT 0>
					<cfset resultStr.items = ''>
				</cfif>

				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>
				
		<cfreturn resultStr />
	</cffunction>
	
	
	<cffunction name="artistBrowse" access="public" output="true" returnType="any">
		<cfargument name="browseAlpha" required="yes" type="string" hint="a single character, required for searching. ('a-z', or '-' for other characters)" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, will convert the output to a query format. Default is 'no'." />
			
			<cftry>
			
			<cfhttp url="http://api.mtvnservices.com/1/artist/browse/#arguments.browseAlpha#" />
			
			<!--- create the return struct and array --->
			<cfset searchResults = "#cfhttp.filecontent#" />

			<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
			<cfset searchResults = searchResults.ReplaceAll("(</?)(\w+:)","$1") />
			<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
			<cfset searchResults = searchResults.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

			<cfset returnedXML = XmlParse(searchResults)>

			<cfset ItemNodes = xmlSearch(#searchResults#,'/feed/entry')>
				
			<cfif arraylen(ItemNodes) GT 0>
				<cfset itemsArr = ArrayNew(1)>
				<cfloop from="1" to="#arraylen(ItemNodes)#" index="i">
					<cfset ItemXML = xmlparse(ItemNodes[i])>
					<cfset ItemStr = StructNew()>
					<cfset ItemXML = xmlparse(ItemNodes[i])>
					<cfset ItemStr.title = #ItemXML.entry.title.XmlText#>
					<cfset ItemStr.id = #ItemXML.entry.id.XmlText#>
					
					<!--- get links (used for the extra API references --->
					<cfset linkNodes = xmlSearch(#ItemXML#,'/entry/link/')>
					<cfset linkArr = ArrayNew(1)>
					<cfif ArrayLen(linkNodes) GT 0>
					<cfloop from="1" to="#ArrayLen(linkNodes)#" index="k">
						<cfset LinkXML = xmlparse(linkNodes[k])>
						<cfset linkArr[k] = #LinkXML.link.XmlAttributes#>
						
						<!--- get the artist uri from the rel attribute --->
						<!--- this is required to use other services, such as related artists --->					
						<cfif structKeyExists(#LinkXML.link.XmlAttributes#, "rel") AND #LinkXML.link.XmlAttributes.rel# EQ 'http://api.mtvnservices.com/1/schemas/artist'>
							<cfset resultStr.artist_uri = #LinkXML.link.XmlAttributes.href#>
							<cfset resultStr.artistRelatedLink = "#LinkXML.link.XmlAttributes.href#related/">
						</cfif>	
					</cfloop>
					<cfset ItemStr.links = #linkArr#>
					</cfif>
					<cfset itemsArr[i] = #ItemStr#>
				</cfloop>
			</cfif>
			
			<cfset resultStr = StructNew()>
			<cfset resultStr.id = #returnedXML.feed.id.XmlText#>
			<cfset resultStr.updated = #returnedXML.feed.updated.XmlText#>
			<cfset resultStr.title = #returnedXML.feed.title.XmlText#>
			<cfset resultStr.link = #returnedXML.feed.link.XmlAttributes#>
			<cfset resultStr.items = #itemsArr#>
			
			<cfif arguments.returnQuery EQ 'yes'>
				<cfset resultStr = QueryNew("name, artist_uri, relatedLink", "VarChar, VarChar, VarChar")>
				<cfset newRow = QueryAddRow(resultStr, #arrayLen(itemsArr)#)>
				<cfloop from="1" to="#arrayLen(itemsArr)#" index="rq">
					<!--- Set the values of the cells in the query --->
					<cfset temp = QuerySetCell(resultStr, "name", "#itemsArr[rq].title#", #rq#)>
					<cfset temp = QuerySetCell(resultStr, "artist_uri", "#itemsArr[rq].id#", #rq#)>
					<cfset temp = QuerySetCell(resultStr, "relatedLink", "#itemsArr[rq].links[2].href#", #rq#)>
				</cfloop>
			</cfif>
			
				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>
			
		<cfreturn resultStr />
	</cffunction>
	
	
	<cffunction name="searchArtist" access="public" output="true" returnType="any">			
		<cfargument name="searchTerm" required="yes" type="string" hint="the name of the artist/band to search for. The function will escape any characters and URLEncode the term for you" />
		<cfargument name="maxResults" required="no" type="numeric" default="1" hint="the maximum number of results you want returned" />
		<cfargument name="includeRelated" required="no" type="string" default="no" hint="if yes, an extra struct is included, which holds the details of artists/bands related to the selected artist" />
		<cfargument name="returnQuery" required="no" type="string" default="no" hint="if yes, the results will be returned as a query recordset. Default is 'no'." />
			<cfset var searchResults = ''>
			<cfset var returnedXML = ''>
			<cfset var resultStr = ''>
			<cfset var rootNodes = ''>
			<cfset var ItemNodes = ''>
			<cfset var itemsArr = ''>
			<cfset var ItemXML = ''>
			<cfset var ItemStr = ''>
			<cfset var linkNodes = ''>
			<cfset var linkArr = ''>
			<cfset var LinkXML = ''>
			
			<cftry>
			
			<cfhttp url="http://api.mtvnservices.com/1/artist/search/?term=#URLEncodedFormat(arguments.searchTerm)#&max-results=#arguments.maxResults#" />
			
			<!--- create the return struct and array --->
			<cfset searchResults = "#cfhttp.filecontent#" />

			<!--- Strip out the tag prefixes. This will convert tags from the form of soap:nodeName to JUST nodeName. This works for both openning and closing tags. --->
			<cfset searchResults = searchResults.ReplaceAll("(</?)(\w+:)","$1") />
			<!--- Remove all references to XML name spaces. These are node attributes that begin with "xmlns:". --->
			<cfset searchResults = searchResults.ReplaceAll("xmlns(:\w+)?=""[^""]*""","") />

			<cfset returnedXML = XmlParse(searchResults)>
			
			<cfset resultStr = StructNew()>

			<!--- only run if there are items within the xml --->
			<cfset rootNodes = xmlSearch(#returnedXML#,'/feed/')>
			<cfif arrayLen(rootNodes) GT 0>
			
				<cfset ItemNodes = xmlSearch(#searchResults#,'/feed/entry')>
					
				<cfset itemsArr = ArrayNew(1)>
										
				<cfif arraylen(ItemNodes) GT 0>
					<cfloop from="1" to="#arraylen(ItemNodes)#" index="i">
						<cfset ItemXML = xmlparse(ItemNodes[i])>
						<cfset ItemStr = StructNew()>
						<cfset ItemXML = xmlparse(ItemNodes[i])>
						<cfset ItemStr.title = #ItemXML.entry.title.XmlText#>
						<cfset ItemStr.id = #ItemXML.entry.id.XmlText#>
						
						<!--- get the artists videos --->
						<cfset videoFeedLink = #ItemXML.entry.id.XmlText#&'videos/'>
						<cfset ItemStr.videos = allVideosByArtist(videoFeedLink).items>
						
						<!--- get links (used for the extra API references --->
						<cfset linkNodes = xmlSearch(#ItemXML#,'/entry/link/')>
						<cfset linkArr = ArrayNew(1)>
						<cfif ArrayLen(linkNodes) GT 0>
						<cfloop from="1" to="#ArrayLen(linkNodes)#" index="k">
							<cfset LinkXML = xmlparse(linkNodes[k])>
							<cfset linkArr[k] = #LinkXML.link.XmlAttributes#>
							
							<!--- get the artist uri from the rel attribute --->
							<!--- this is required to use other services, such as related artists --->					
							<cfif structKeyExists(#LinkXML.link.XmlAttributes#, "rel") AND #LinkXML.link.XmlAttributes.rel# EQ 'http://api.mtvnservices.com/1/schemas/artist/related'>
								<cfset resultStr.artistRelatedLink = "#LinkXML.link.XmlAttributes.href#related/">
							</cfif>
							
						</cfloop>
						<cfset ItemStr.links = #linkArr#>
						</cfif>
						<cfset itemsArr[i] = #ItemStr#>
					</cfloop>
					
					<cfset resultStr.id = #returnedXML.feed.id.XmlText#>
					<cfset resultStr.updated = #returnedXML.feed.updated.XmlText#>
					<cfset resultStr.title = #returnedXML.feed.title.XmlText#>
					<cfset resultStr.link = #returnedXML.feed.link.XmlAttributes#>
					<cfset resultStr.items = #itemsArr#>
				
					<cfif arguments.returnQuery EQ 'yes'>
						<cfset resultStr = QueryNew("artist_uri,name,videoID,category,videoDuration,videoExpression,videoIsDefault,videoMedium,videoType,videoURL,credits,thumbnails")>
						<cfloop from="1" to="#arrayLen(itemsArr)#" index="rq">
							<cfif structKeyExists(itemsArr[rq], "videos")>
							<cfloop from="1" to="#arrayLen(itemsArr[rq].videos)#" index="qv">
							<cfset newRow = QueryAddRow(resultStr)>
							<cfset temp = QuerySetCell(resultStr, "videoID", "#itemsArr[rq].videos[qv].id#")>
							<cfset temp = QuerySetCell(resultStr, "artist_uri", "#itemsArr[rq].videos[qv].links[2].href#")>
							<cfset temp = QuerySetCell(resultStr, "name", "#itemsArr[rq].videos[qv].title#")>
							
							<!--- get media details --->
							<cfset temp = QuerySetCell(resultStr, "videoDuration", "#itemsArr[rq].videos[qv].mediacontent.duration#")>
							<cfset temp = QuerySetCell(resultStr, "videoExpression", "#itemsArr[rq].videos[qv].mediacontent.expression#")>
							<cfset temp = QuerySetCell(resultStr, "videoIsDefault", "#itemsArr[rq].videos[qv].mediacontent.isdefault#")>
							<cfset temp = QuerySetCell(resultStr, "videoMedium", "#itemsArr[rq].videos[qv].mediacontent.medium#")>
							<cfset temp = QuerySetCell(resultStr, "videoType", "#itemsArr[rq].videos[qv].mediacontent.type#")>
							<cfset temp = QuerySetCell(resultStr, "videoURL", "#itemsArr[rq].videos[qv].mediacontent.url#")>
							
							<cfset temp = QuerySetCell(resultStr, "category", "#itemsArr[rq].videos[qv].mediacategory#")>
							<cfset temp = QuerySetCell(resultStr, "credits", "#itemsArr[rq].videos[qv].mediacredits#")>
							<cfset temp = QuerySetCell(resultStr, "thumbnails", "#itemsArr[rq].videos[qv].mediathumbnails#")>
							</cfloop>
							</cfif>
						</cfloop>
					</cfif>

				</cfif>			

			</cfif>
			
				<cfcatch><cfdump var="#cfcatch#" /></cfcatch>
			</cftry>
			
		<cfreturn resultStr />
	</cffunction>

</cfcomponent>