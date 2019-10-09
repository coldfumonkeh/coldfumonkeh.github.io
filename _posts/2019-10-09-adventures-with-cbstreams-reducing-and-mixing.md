---
layout: post
title: Adventures with CBStreams - Reducing and Mixing
slug: adventures-with-cbstreams-reducing-and-mixing
date: 2019-10-09
categories:
- development
tags:
- coldfusion
excerpt: "Let's take a look at using Java 8 streams to reduce a multidimensional array."
---

Following on from the two previous posts in the **Adventures with CBStreams** series, [API Transformations](/2019/10/07/adventures-with-cbstreams-api-transformations.html) and [Struct Grouping](/2019/10/08/adventures-with-cbstreams-struct-grouping.html), today I wanted show you a useful example to use Java streams to reduce a multidimensional array.

Let's start off with creating a multidimensional array.

<script src="https://gist.github.com/coldfumonkeh/92cd0ba42a14cf14a159349e03ea89de.js"></script>

In this particular example, we'll use our musicians again. Let's consider the first array as **modern** artists, whilst the second array contains the **classics**/**legends**.

If we dump out the `arrGroupedData` value. we can see the array we need to work with.

![The raw multidimnesional array](/assets/uploads/2019/10/streams_multidimensional_array_raw.png)

OK. Let's start with the native `arrayReduce()` function. In our code, we simply want to combine the multidimensional array into one array containing all of the values.

<script src="https://gist.github.com/coldfumonkeh/c5b21e078d778b43bf9a7910f247fa1d.js"></script>

The output of the above code shows our single array, fully populated with all of the musicians.

![Native CFML arrayReduce](/assets/uploads/2019/10/native_arrayreduce.png)

If it does the same thing, why bother using the streams?

Well, we've seen in the other posts that streams allow us to manipulate data asynchronously, if we choose. It's a great choice if you're dealing with large data sets that you want to process quickly and efficiently.

With that in mind, let's update our code to replace the native `arrayReduce()` function with a `cbstreams`-powered process instead.

<script src="https://gist.github.com/coldfumonkeh/281b2e29debee2ebb0e214d42d83994e.js"></script>

The output of the above code is exactly the same as the native `arrayReduce()` method.

A great reason to use streams to reduce your arrays is the ability to run additional processes on the values prior to returning the complete reduction.

The value from the first `map()` function is each sub-array included within the parent - our **modern** and **classic** artists respectively.

We can take that sub-array and send it through the pipeline, adding a second `map()` function. We'll pass that array through to an external function, `artistDetailStream()`, which will send off a request to the [Spotify Web API](https://github.com/coldfumonkeh/Spotify-Web-API) to receive information for that artist, searching by the given name.

`objSpotify` relates to a variable assignment for the Spotify Web API component, not included here as it contains oauth-related information as part of the constuctor. We also pass through the instantiated `streamBuilder` component into the `artistDetailStream()` function.

<script src="https://gist.github.com/coldfumonkeh/735a12f802a07f36d73e46880aea4c47.js"></script>

As the initial parameter we send through is an array of structs containing artist names, we still have to loop over the array to send each name to the API.

We can run this process asynchronously by using, you guessed it, Java streams.

<script src="https://gist.github.com/coldfumonkeh/fc449c59d3db01a546f68e50488a8883.js"></script>

Once again, we set up a new Java stream within the function, looping over the number of records within the given array and pulling each item out using the first `map()` function.

The second `map()` now receives the struct containing the actual `name` of the artist, and it is that value we can use to send to the Spotify API to run a search.

We then obtain the first relevant match from the available items in the API response and create a struct of data to set into our array to pass back to the original calling process.

You can also see that we ran this procedure asynchronously using the `parallel()` method to help speed up the overall response.

This transformed response is returned in the original requesting stream process, and the results are combined into a single array as before, only this time with more data pulled from an external API.

![The reduced and transformed array](/assets/uploads/2019/10/streams_reduced_and_transformed.png)

Just in case it passed you by, we are running a Java stream **WITHIN** another Java stream.

How cool is that?