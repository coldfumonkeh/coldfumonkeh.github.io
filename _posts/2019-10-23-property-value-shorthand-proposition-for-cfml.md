---
layout: post
title: Property Value Shorthand proposition for CFML
slug: property-value-shorthand-proposition-for-cfml
date: 2019-10-21
categories:
- ColdFusion
tags:
- ColdFusion
excerpt: "Part of my wishlist for future CFML engines is the property value shorthand. "
---

The object property value shorthand has been available in JavaScript using ES6/ES2015 for some time. I personally think it's a fantastic language feature that streamlines code and I would love to see it as part of future CFML engine updates.

Let's take a look at a JavaScript example:

<script src="https://gist.github.com/coldfumonkeh/9948d5b0e6e88e3c5b7e4fc4e613ea01.js"></script>

Here you can see that the object properties have been added without directly referencing the property names when applying the variables. This is because the variable names actually directly match the names of the properties being added.

Compare this to the older ES5 syntax, when you had to define the property names with the variables:

<script src="https://gist.github.com/coldfumonkeh/0c7486e02e3db8b04e6d61e327ade972.js"></script>

If, in ES6, the variable name differed for any of the properties, you would of course still need to define the property reference:

<script src="https://gist.github.com/coldfumonkeh/010e9d5f96d228c4ff1f9870dc77d284.js"></script>

In the above example, the `dog` and `bird` variables still match the property names. However, we have a `pussycat` variable for the `cat` property, and so we need to explicitly define the property name.

Let's consider this in a CFML context.

Of course it would be amazing to have the same functionality when adding values into a CFML struct:

<script src="https://gist.github.com/coldfumonkeh/ba1c263659a0ea6c34d69cf572d35ecc.js"></script>

How about adding shorthand references in when sending argument values into a function?

<script src="https://gist.github.com/coldfumonkeh/98d51aac98a5ca21857105a486f11f45.js"></script>

CFML functions already let you send in arguments without directly naming the property, but those depend on the values matching the order of the expected arguments within the function.

In the above example we are sending `to`, `from` and then `message`, but the function would automatically attribute the `from` value to the `message` argument and the `message` value to the `from` argument.

Ideally I'd love all future CFML engines to be able to determine which variable is assigned to which argument based upon the variable name matching the argument name.

This situation would most likely help to ensure that any non-attributed arguments have the correct default values set and validation within the methods to handle data payloads and consistency of incoming parameters, which would rely on the developer to implement.

The function implementation might be a little bit of a stretch, but struct property shorthand should be relatively easy to implement (I would assume).