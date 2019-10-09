---
layout: post
title: IP API CFML Open Source Component
slug: ip-api-component-open-source
date: 2019-10-09
categories:
- development
tags:
- coldfusion
- open source
- component
excerpt: "If you want to use an API for detailed, accurate IP and geolocation data, I have an open-source component for you."
---

A few months ago I needed to write some code to interact with the [IP API service](https://ipapi.com) to fetch geolocation data for certain conditions within the application.

The code I needed to implement was only a single call to a single endpoint on the API, but that evening I decided to write an API wrapper for it in CFML anyway, which was [released as open source](https://github.com/coldfumonkeh/IPAPI) that very night.

Instantiation of the component is simple.

Grab an API key from the [IP API service](https://ipapi.com) and include it within the `init()` constructor call.

Not all plans on the service support `HTTPS`, so if you don't have it, you will need to pass the `HTTP` endpoint into the constructor method too, using the `apiEndpoint` argument.

To grab a data structure for a given IP address, simply call the `ipLookup()` method, passing in the IP address to query:

<script src="https://gist.github.com/coldfumonkeh/bce633dd170a1444f561e4a122fa8bc8.js"></script>

If your subscription plan includes bulk IP lookups, you can optionally send in a comma-separated list of IP addresses.

You can also perform an IP lookup on any IP address that makes the call to the API, so if you want to test it out easily and verify information for your IP,
simply call the `originIPLookup()` method without sending through any parameters.

As you can see, the response contains a lot of really useful information:

<script src="https://gist.github.com/coldfumonkeh/5d1614d88ae6cc5f0466b9b191f71c06.js"></script>

Responses for all requests can be either `xml` or `json` (default), which is configurable as an argument for each method.

You can find the project on my [Github repository](https://github.com/coldfumonkeh) [here](https://github.com/coldfumonkeh/IPAPI)