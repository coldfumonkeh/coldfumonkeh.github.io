---
layout: post
title: devObjective 2015 Day Two Notes
slug: devobjective-2015-day-two-notes
date: 2015-05-14
categories:
- Events
- ColdFusion
tags:
- Events
- Developers
- ColdFusion
excerpt: "Notes taken during the devObjective 2015 conference in Minneapolis, Thursday 14th May 2015."
---

## devObjective 2015

Notes taken from sessions attended at the devObjective 2015, day two (14th May 2015)

---

### Rethink Async with RXJS

Presented by Ryan Anklam

#### Reactive Programming

Iterator: a pattern for accessing the elements of a collection without exposing its underlying representation

Observer: an object, the Subject, has one or many observers, that are notified of any state changes

#### Observable

Benefits over another Async approach:

* replayable
* composable
* cancelable
* cache-able
* sharable


Map - Transforms each element in a collection. The original collection is unchanged.

Filter - Narrows collections.

Reduce - turns an entire collection into a single value.

Zip - combines two collections.


#### Thinking Functionally

* replace loops with map
* replace if statements with filters
* don't put too much into a single stream. Break up large streams into a number of smaller ones


#### Flattening patterns - managing concurrency

* merge - combines items in a collection as each item arrives
* concat - combines the collections in the order they arrived
* switchLatest - switches to latest collection as it arrives


#### Learn More

http://github.com/jhusain/learnrx

https://github.com/Reactive-Extensions/RxJS

https://rxjs.codeplex.com/

---


### Multiply like Rabbits with RabbitMQ

Presented by Luis Majano

https://www.rabbitmq.com/

#### Problems with RPC

* Blocks requests
* Asynchronous, partial solution, still 1 - 1 relationship
* Sender always knows about receiver
* Receiver knows about sender

How can we decouple knowledge and apply messaging patterns to our apps?

#### Messaging (EMB)

Producer

* doesn't care about consumers
* asynchronous
* can be any system or language
* does not get a response

Messaging Bus - Broker

Consumer(s)

* Can be any system or language



#### Benefits of Messaging

* Producers lack knowledge - decoupled
* cross-platform technologies - flexibility
* event-driven programming - scalability
* queueing for later delivery
* asynchronous
* load balancing


#### Patterns

* Direct Messaging
* Work Queues
* Publish / Subscribe
* Topics / Routing

#### Protocols

**AMQP**

Advanced Messaging Queuing Protocol

www.amqp.org

Uses standard binary protocol

* Exchanges
* Queuing
* Routing
* Reliable
* Secure

Has a number of implementations, but lets look into [RabbitMQ](http://www.rabbitmq.com)

#### RabbitMQ

AMQP Messaging Broker with wrappers available in a number of different languages

Accepts and forwards messages

Think of it like the post box, post office AND postman rolled into one.


#### Learn More

[RabbitMQ](http://www.rabbitmq.com)

Rabbit Simulator - http://tryrabbitmq.com/



---


### Who Owns Software Security? You Do.

Presented by Tim Buntel


Do you scan your apps for cybersecurity vulnerabilities before making them available? **40%** of people said **NO**.

How much do you budget towards securing mobile apps built for customers? **50%** of people said **$0**.


Time to market is an issue - under pressure to release new apps faster due to:
* customer demand
* competitive actions
* revenue shortfalls

#### New Tools

* Endpoint profiling
* Endpoint forensics
* Network forensics
* "Secure" platforms

(RSA Conference 2015)

#### Quality Today

* Patterns, frameworks, and good design
* Do it early, do it often (and automate it)
* High quality people make high quality software
* It is everyone's responsibility

Doing it right is actually quicker in the end!

Good software is secure. Secure software is good software.

#### Four Step Plan

1. Study successes

  * https://www.bsimm.com - describes software security initiatives at 67 well-known companies
  * study failures (not just successes)
  * OWASP

2. Inventory yourself

  * Know your tech stack
  * Know your app and how it works
    * store a password
    * login a user
    * upload a photo
    * display user contributed content
    * concatenate strings
  * What is secret? What data is moving where?

3. Make it agile

  * Agile Quality = Agile Security
  * Add security to your **"definition of done"**
  * Tools help scale the process
    * IDEs with "checkers"
    * Near-real-time tools
      * [Klocwork](http://www.klocwork.com/)
      * [Codiscope](https://codiscope.com/)
      * [Coverity](http://www.coverity.com/)
    * Build tools (Brakeman)

4. Drive the culture

  * even a _little_ security is better than none. Don't wait for a big initiative.
  * security should not be a "special event"
  * get trained!
  * have a plan for when something does go wrong



---

### W3C Content Security Policy & HTTP headers for Security

Presented by David Epler

#### X-Content-Type-Options

* protect against MIME type confusion attacks (IE9+, Chrome and Safari)

<pre>X-Content-Type-Options: nosniff</pre>

#### X-XSS-Protection

* configures user-agent's built-in reflective XSS protection (IE8+ and Chrome)


<pre>X-­‐XSS-­‐Protection: 1; mode=block</pre>

<code>0</code> = disable XSS protection

<code>1</code> = enable XSS protection

<code>1; mode=block</code> = enable XSS protection & block content

<code>1; report=URL</code> = report potential XSS to URL (Chrome/Webkit only)


#### X-Frame-Options

* Indicates if browser should be allowed to render content in <code>&lt;frame&gt;</code> or <code>&lt;iframe&gt;</code>

<code>DENY</code> Prevents any domain from framing the content

<code>SAMEORIGIN</code> Only allows sites on same domain to frame the content

<code>ALLOW-FROM URL</code> Whitelist of URLs that are allowed to frame the content


<pre>X-­‐Frame-­‐Options: SAMEORIGIN</pre>

Browser support varies on value.



#### HTTP Strict Transport Security (HSTS)

Instructs the browser to always use HTTPS protocol

Helps prevent:

  * network attacks
  * mixed content vulnerabilities

Does not allow a user to override the invalid certificate message.


<pre>
// Require HTTPS for 60 seconds on domain
Strict-­‐Transport-­‐Security: max-­‐age=60

// Require HTTPS for 365 days on domain and all subdomains
Strict-­‐Transport-­‐Security: max-­‐age=31536000; includeSubDomains

// Remove HSTS Policy (including subdomains)
Strict-­‐Transport-­‐Security: max-­‐age=0
</pre>



#### Learn More


**HTTP Headers**

* [MIME-Handling Changes in Internet Explorer](http://blogs.msdn.com/b/ie/archive/2010/10/26/mime-handling-changes-ininternet-explorer.aspx)
* [Controlling the XSS Filter](http://blogs.msdn.com/b/ieinternals/archive/2011/01/31/controlling-the-internetexplorer-xss-filter-with-the-x-xss-protection-http-header.aspx)
* [OWASP: Clickjacking Defense Cheat Sheet](https://www.owasp.org/index.php/Clickjacking_Defense_Cheat_Sheet)
* [OWASP: Cookie HTTPOnly](https://www.owasp.org/index.php/HttpOnly)
* [OWASP: Cookie Secure](https://www.owasp.org/index.php/SecureFlag)
* [Veracode: Guidelines for Security Headers](https://www.veracode.com/blog/2014/03/guidelines-for-setting-security-headers)


**HTTP Strict Transport Security**

* [Specification](https://tools.ietf.org/html/rfc6797)
* [OWASP HTTP Strict Transport Security](https://www.owasp.org/index.php/HTTP_Strict_Transport_Security)
* [Mozilla Developer Network](https://developer.mozilla.org/en-US/docs/Web/Security/HTTP_strict_transport_security)
* [HSTS Preload](https://hstspreload.appspot.com/)
* [IIS Module](http://hstsiis.codeplex.com/)


**Content Security Policy**

* [CSP 1.0 Candidate Recommendation](http://www.w3.org/TR/2012/CR-CSP-20121115/)
* [CSP 1.1 Candidate Recommendation](http://www.w3.org/TR/2015/CR-CSP2-20150219/)
* [OWASP Content Security Policy](https://www.owasp.org/index.php/Content_Security_Policy)
* [An Introduction to Content Security Policy](http://www.html5rocks.com/en/tutorials/security/content-security-policy/)
* [Content Security Policy Reference](http://content-security-policy.com/)
* [CSP Playground](http://www.cspplayground.com/)
