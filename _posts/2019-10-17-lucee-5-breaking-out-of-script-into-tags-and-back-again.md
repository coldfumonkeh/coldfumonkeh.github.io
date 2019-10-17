---
layout: post
title: Lucee 5 - Breaking out of script into tags and back again
slug: lucee-5-breaking-out-of-script-into-tags-and-back-again
date: 2019-10-17
categories:
- development
tags:
- coldfusion
excerpt: "Break out of cfscript to write tag-based code in Lucee 5.3."
---

There's a **SECRET** bit of functionality in Lucee 5.3 that you may not know about yet, and this is the ability to write tag-based CFML within the context of `cfscript` code.

Imagine the following example. I have a table into which I want to output the rows of data from a collection. It could be an array, query, nested structures or any other format of data. In this case, I have an array of structural (dummy) data to display:

![An array of structs](/assets/uploads/2019/10/lucee_backticks.png)

In my simple example, I want to call a function named `getSalesDataRows()` to build these iterative table rows and populated cells as a string.

<script src="https://gist.github.com/coldfumonkeh/ad8f6b3360fa58923a680259f3e23927.js"></script>

You can do this in script in a number of ways, one of which is to `writeOutput()` or `echo()` the rows and table cells.

<script src="https://gist.github.com/coldfumonkeh/4e48553fcd66e37e9fd44092db8d7ed1.js"></script>

Whilst this works, for me it's not easy to read. 

In Lucee 5.3, you can actually break out of the `cfscript` context to write tag-based code using triple backticks.
These will be familiar to anyone who's ever written a block of code in Markdown, but in this instance they switch contexts within Lucee and allow you to write your tag code before closing the backticks and continuing with your `cfscript`.

<script src="https://gist.github.com/coldfumonkeh/e88be2cdf6239a95ca919dfa45d2e81b.js"></script>

That's it. Nice and easy.