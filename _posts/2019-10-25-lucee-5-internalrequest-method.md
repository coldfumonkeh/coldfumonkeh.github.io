---
layout: post
title: Lucee 5 _InternalRequest method
slug: lucee-5-internalrequest-method
date: 2019-10-25
categories:
- ColdFusion
tags:
- ColdFusion
excerpt: "Today I learnt about the _InternalRequest method in Lucee 5. It's cool."
---

Today I found out about a non-publicised hidden function in the Lucee CFML engine: `_InternalRequest`.

Let's take a look at what it is and how you might use it.

## What it is

This function essentially acts as an internal http request, allowing you to make a request to the CFML engine internally.

It's not actually an http request as we currently know it, but it acts the same way and produces similar results.

Here's a quick example.

Let's say my application has an all-powerful template that returns some crucial JSON (impressive, right?):

<script src="https://gist.github.com/coldfumonkeh/aa2dfb3a8b31564126b61b6f6ea0f87c.js"></script>

If we hit that page directly in the browser we would receive the expected JSON response:

![The raw JSON response](/assets/uploads/2019/10/internalRequest_raw_json.png)

We can make the same request to the template from elsewhere within our application using the `_InternalRequest()` function:

<script src="https://gist.github.com/coldfumonkeh/952084060e13875388cd441f21cae0ac.js"></script>

This request would result in the following struct response:

![The _InternalRequest struct response](/assets/uploads/2019/10/internalRequest_struct_response_one.png)

Let's update the example and send some information through in the `GET` request:

<script src="https://gist.github.com/coldfumonkeh/47d26ed2f4be846eb92c7a1d6f45d476.js"></script>

By sending through the `url` property in the function, we are effectively calling the given `template` as if we were requesting it directly in the browser like so: `http://127.0.0.1:62558/monkeh.cfm?id=123456&debug=false`

The updated response would look like this:

![The second _InternalRequest struct response](/assets/uploads/2019/10/internalRequest_struct_response_two.png)


## How you might use it

It's a great function that can be used for making internal http requests, so you might have a use case for it somewhere within your application (perhaps in a controller where you're calling an API module prior to rendering the template).

For me, this function opens a lot of doors when it comes to creating integration tests.

Let's assume that I have an API template within my application and I want to run integration tests on it using [TestBox](https://forgebox.io/view/testbox) to make sure that the actual code performs as expected, and not testing against a mocked version.

<script src="https://gist.github.com/coldfumonkeh/6d4d590c5565d69a9069d75f0c3276c5.js"></script>

By using `_InternalRequest`, we can easily make these requests to internal templates and actually test the responses that your app would give to users.

## The arguments

Here's a breakdown of the arguments accepted by the function:

**template** - template path (script name) for the request (example:`/test/index.cfm`)

**method** - method of the request (`GET`,`POST`,`PUT`,`DELETE`...)

**urls/url (alias)** - `URL` scope passed to the request (query string)

**forms/form (alias)** - `FORM` scope passed to the request

**cookies/cookie (alias)** - `COOKIE` scope passed to the request

**headers/header (alias)** - Request header entries passed to the request

**body** - body to send with the request

**charset** - charset used for the request, if not set the web charset is used

**addtoken** - if yes/true, add `urltoken` as cookie

A detailed breakdown of the complete function data can be found in the following gist on [trycf.com](https://trycf.com/gist/023e860634f6beeb3f7af30e6444c6b5/lucee5).