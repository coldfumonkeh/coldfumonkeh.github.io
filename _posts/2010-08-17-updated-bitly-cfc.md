---
layout: post
title: Updated Bit.ly ColdFusion Wrapper
slug: updated-bitly-cfc
date: 2010-08-17
categories:
- ColdFusion
tags:
- Adobe
- API
- CFC
- ColdFusion
status: publish
type: post
published: true
---
<p>On 2nd August I released a revised version of my <a title="View the original post" href="http://www.mattgifford.co.uk/bitly-coldfusion-api/" target="_self">bit.ly ColdFusion CFC Wrapper</a>.</p>
<p>I had received an email from a user of the component who was having trouble with certain errors being returned from various calls to the API.</p>
<p>After a little investigation, I discovered that the API itself had changed; the code within the CFC was now failing due to an upgrade within the actual API.</p>
<h2>What's changed?</h2>
<p>Quite a lot seems to have changed in the API version upgrade.</p>
<p>The error and stats methods from the version 2 API have now been deprecated and are no longer in use.</p>
<p>The current methods now available within the version 3 API are:</p>
<ul>
<li>shorten</li>
<li>expand</li>
<li>validate</li>
<li>clicks</li>
<li>bitly_pro_domain</li>
<li>lookup</li>
<li>authenticate</li>
<li>info</li>
</ul>
<p>As well as the available methods, the base URL for the API call was also changed. As such, this change has also been amended in the latest release of the bit.ly CFC wrapper.</p>
<h2>How do I get it?</h2>
<p>If you are using the CFC wrapper, I'd kindly suggest you upgrade to the latest version to avoid any unwanted errors due to the API change.</p>
<p>You can download the revised version of the API wrapper from <a title="Download bit.ly ColdFusion CFC API Wrapper from riaforge.org" href="http://bitly.riaforge.org/" target="_blank">bitly.riaforge.org</a></p>
