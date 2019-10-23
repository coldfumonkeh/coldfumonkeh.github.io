---
layout: post
title: grep with CFML and Java Streams
slug: grep-with-cfml-and-java-streams
date: 2019-10-23
categories:
- ColdFusion
- Java
tags:
- ColdFusion
- Java
- Streams
excerpt: "A little experiment to try and grep a file using CFML and Java 8 Streams"
---

I was listening to "[Modernize or Die](https://cfmlnews.modernizeordie.io/)® - CFML News for October 15th, 2019" this morning, and heard Andrew Davis ask "Is there anything in ColdFusion somewhere to grep, aside from just doing a `cfexecute` on the grep?". [The link to the exact point in the awesome podcast video stream is here](https://youtu.be/ShEoWC-D784?list=PLNE-ZbNnndB98oRT8THamdCUiyDQL1uEj&t=2722).

This got me thinking.. yeah, not normally a good sign.

I know that you can read files in Java 8 using the streams, so in theory you could perform at least a regex filter on file contents as a pseudo-grep.

So, I got writing during my lunch break and came up with `grep.cfc`.

**Before anyone judges me on anything, this was literally a 20 minute hack to play around and see what I could come up with.**

As an aside, I only started listening to the podcast yesterday, so I have a lot to catch up on, but I already love it and I think the Ortus team are doing an amazing job with it! Needless to say, I'm now a subscriber.

Anyway...

## Grepping

At the moment it only handles a grep filter on a single file, although I plan to add directory support to it as iterating over directories using streams will be relatively straight-forward and fast.

I've broken the component down into simple chained method calls.

So, example one and I'm searching for every instance of `public` within the given file. In these examples, I'm actually grepping against the `grep.cfc` file itself; I'm not sure if that is "**grep-ception**".

<script src="https://gist.github.com/coldfumonkeh/1a48d81a440ca68fde508ad5d1b3d636.js"></script>

Firstly we provide a pattern to match (`pattern()`), the we set a relative path to the file to search (`file()`).

Finally, to complete the process we call the `grep()` method which creates the initial Java stream on the file, pulling out all of the lines contained within. The component then creates a Java Predicate using the pattern string value sent via the `pattern()` method call. This predicate is then used to filter any lines that match the given pattern, before terminating the stream by returning an array of results.

The resulting dump from the above example is here:

![The response from grep 1](/assets/uploads/2019/10/grep1_response.png)

Running a second example, I'm trying to grep on my domain name:

<script src="https://gist.github.com/coldfumonkeh/5a219857a100f2e2dc6beeb2a0cb66ac.js"></script>

This results in just the one item coming back in the array:

![The response from grep 2](/assets/uploads/2019/10/grep2_response.png)

It doesn't return line numbers when perhaps it should. Agsin, before anyone judges me on anything, **this was literally a 20 minute hack to play around and see what I could come up with**.

You all know I love `cbStreams`. It could do most if not all of this as well, but I wanted to try and come up with something quickly without dependencies for an extra challenge.

It will be going into Github this afternoon, but the bare bones is below in the gist.

<script src="https://gist.github.com/coldfumonkeh/5cf17b6a6918cc55f5e4e3d91ee34913.js"></script>

That's about it. Just another quick experiment to see if something was possible.