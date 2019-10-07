---
layout: post
title: Adventures with CBStreams - API Transformations
slug: adventures-with-cbstreams-api-transformations
date: 2019-10-07
categories:
- development
tags:
- coldfusion
excerpt: "Use Java 8 streams with CFML. I'll show you some real-world examples."
---

I've been using [cbstreams](https://github.com/coldbox-modules/cbstreams) a lot recently over the last few years.

It's a CFML wrapper that interacts with the Java Streams, allowing you to use those streams directly within your CFML code without having to deal with the Java code underneath. In true Ortus Solutions fashion, it's very well documented.

Most of the examples that you see for Java Streams are for array manipulation and collection, and not really something that can be easily compared to current problems that you may face in your working day that it can solve.

So, this is the first of a few `cbstreams` posts I wanted to make to help clarify what it can do to help give you some clearer examples of how you could use it within your code.


### Use streams as API data transformers

I LOVE APIs. I mean, I LOOOOOOOVE APIs.

I have spent a lot of time writing APIs for various projects, using various tools.

I often change between API tooling when developing. It depends a lot upon the code base (is it in a framework and do modules exist for that framework), the requirements (is a large feature-rich API tool worthwhile for this small app) and cost (how long will it take me to get it up and running).

I have two default go-to API tools for CFML applications:

* [Taffy](https://taffy.io) - it works out of the box. Tweet-sized code
* [ColdBox](https://www.coldbox.org/) - creating a custom API module for each project

In this example we'll use [Taffy](https://taffy.io) as the API resource provider as it's lightweight and ideal to use for demonstration purposes.

Let's build up the initial endpoint to fetch some data for musicians.

Using the `Taffy` documentation as a guide, the following file is placed within the `/resources` directory, and will effectively become our `GET` request handler for all artists within our database when users call `http://*.*.*.*/artists`

<script src="https://gist.github.com/coldfumonkeh/6f7f534edf3ac06b44dac982abcd5da6.js"></script>

Setting up the `/artists` resource to fetch information on all musicians within our datastore, 
we can pass in optional parameters as part of the `GET` request to limit the number of records and provide an offset for pagination purposes:

`http://*.*.*.*/artists?limit=2&offset=1` as an example

As of yet we have no data, and so we pass an empty array value to the internal Taffy `rep` function, as well as an accompanying structure of parameters used to make the request - helpful for the API caller to confirm the values they sent were used to make up the request.

![The empty API response](/assets/uploads/2019/10/taffy_empty_response.png)

Let's add a little bit of code to fetch our data. This could be from an in-line query call, or from an instantiated service component, as used here in the example.

<script src="https://gist.github.com/coldfumonkeh/8f6695a01447b467c565b04b8f88830e.js"></script>

By default, our returned query recordset looks like this:

![The base query resultset](/assets/uploads/2019/10/streams_query_base_output.png)

So, we have the query response, but we still need to transform the data and output it as an array.

There are [CFML functions out there](https://www.bennadel.com/blog/124-ask-ben-converting-a-query-to-an-array.htm) to help you convert a query into an array, but we want to try and create a data transformer of sorts so that we can define an explicit structure with associated data to return within the API response.

When it comes to data transformation, I'll typically use the incredible [cffractal](https://github.com/coldbox-modules/cffractal) library. I've given presentations on it before and find it an invaluable tool to use. I've used it inside ColdBox applications, inside other framework-based CFML applications, and alongside Taffy to transform the data before returning the API response.

It can, however, come with a bit of a learning curve (although not much, that's doing it a huge disservice).

As I've been using [cbstreams](https://github.com/coldbox-modules/cbstreams) a lot recently over the last few years, I wanted to show an optional way to transform your query data into a readable structural format that you can use when returning JSON data.

### Enter CBStreams!

This is where `cbstreams` can really help you.

Firstly, you would need to install `cbstreams` into your application. It is available from the [Github repository](https://github.com/coldbox-modules/cbstreams) or you can install it from [Forgebox](https://forgebox.io/view/cbstreams) using [CommandBox](https://www.ortussolutions.com/products/commandbox):

`box install cbstreams`

You can see that it's very easy to chain method calls when building up your `streambuilder` object.

<script src="https://gist.github.com/coldfumonkeh/37b6602bf0c759e5c5d10ae6298cf073.js"></script>

The `parallel()` method call is optional. By adding that in, the stream wil leverage parallel programming to help run the process asynchronously. This only really shows a benefit when dealing with a high number of records; working on smaller data sets I haven't really seen much change, but I wanted you to know that it's there and should be used if you want to perform asynch processes on your data.

As part of the stream `map()` function, once we have the row from the query, the value sent to the `transformArtistData()` method is a structural representation of that row:

![Each query row is passed to the function as a struct](/assets/uploads/2019/10/mapped_struct_item_in_stream.png)

We simply pass our struct of data (for each row of the query) into the transform method. It can manipulate it however you see fit and return whatever you want it to return.

The following example is relatively basic in terms of the data coming back (no super-heavy processing or nested resources), but was created as a way to show you how simply you can control data responses for your API, transforming the records into something readable and useable for the end users.

Our `transformArtistData` method could be in a service component, a dedicated model or inline within the Taffy resource itself.

<script src="https://gist.github.com/coldfumonkeh/e672fa908497cb55024671ef517fbebf.js"></script>

If we run a `writeDump( arrData );` before we return the API response, we can see the array generated by the stream processessing:

![cbstreams for CFML](/assets/uploads/2019/10/stream_array_result.png)

Making a fresh request to the API endpoint, now populated with `cbstreams` data, we would see our transformed data:

![The transformed API response](/assets/uploads/2019/10/taffy_transformed_response.png)

The completed `get()` method in the `artists.cfc` resource would look something like this:

<script src="https://gist.github.com/coldfumonkeh/bde45c118307023a765e79a828aa9a5f.js"></script>

So, there you go. I've used Java Streams thanks to the `cbstreams` module for a number of things. This is the first of a few I wanted to bring to your attention.

You never know when you may need to unleash the power of Java Streams inside your CFML application!