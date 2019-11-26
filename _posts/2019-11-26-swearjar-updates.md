---
layout: post
title: CFML swearjar updates
slug: swearjar-updates
date: 2019-11-26
categories:
- ColdFusion
- Lucee
- CFML
tags:
- ColdFusion
- Lucee
- CFML
excerpt: "Swearjar has received a few updates. Here's what's new"
---

A few weeks ago [I blogged about the latest open-source project](/2019/11/13/cfml-swearjar-profanity-detection-and-filtering-component-library.html), [Swearjar](https://github.com/coldfumonkeh/swearjar).

It has received a few updates which I wanted to highlight here.

### Two New Methods

The first update is that the library now contains two new methods: `sugarcoat` and `unicorn`.

These came to fruition after getting a tweet response from Pete Williamson [@WillshawMedia](https://twitter.com/WillshawMedia):

<blockquote class="twitter-tweet" data-partner="tweetdeck"><p lang="en" dir="ltr">reading the en_US.json file made me laugh out loud... also a feature to replace swears with nice friendly safe words would be amazing</p>&mdash; Pete Williamson (@WillshawMedia) <a href="https://twitter.com/WillshawMedia/status/1196765280992669697?ref_src=twsrc%5Etfw">November 19, 2019</a></blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>


Although I was only creating a CFML version of an existing package port, I thought this would actually be a good addition to the library.

The `sugarcoat` method will attempt to replace any profanity detected with a replacement value, defined within the `JSON` library file.

There is a new `replacements` struct at the bottom of the default `en_US.json` file which currently only holds one replacement as an example.

```
"replacements":{
    "pornography":[
        "erotic literature"
    ]
}
```

When using the `sugarcoat` method it will look for any replacements defined for the detected word within this struct. If one exists, it will replace the profanity with this word (or one of the possible replacements if you have added more than one into the array). If no replacement word is found it will continue to censor the response text and replace the profanity with asterisk characters.

```
strCensored = swearjar.sugarcoat( 'What in tarnation are you doing reading pornography, you rantallion?!?' );
// What in ********* are you doing reading erotic literature, you **********?!?
```


Finally we have `unicorn`, which as you may guess, will simply replace every detected instance of profanity with the word "unicorn".

```
strCensored = swearjar.unicorn( 'What in tarnation are you doing, you rantallion?!?' );
// What in unicorn are you doing, you unicorn?!?
```

Yes, this has the potential to completely ruin the context of the content, but it could also make it a little funnier in the process.

**"Unicorn you, you unicorn unicorn"**

### Now a ColdBox Module

I was honoured that Gavin Pickin chose to choose Swearjar as the Forgebox module of the week in the [November 19th Modernize or Die podcast](https://cfmlnews.modernizeordie.io/episodes/modernize-or-die-cfml-news-for-november-19th-2019) episode.

Brad Wood asked if it was a ColdBox module or just a standalone component. I had submitted it to Forgebox as purely a standalone CFC, but after hearing that episode I added a `ModuleConfig.cfc` and resubmitted after some initial testing. 

Now Swearjar is configured to be installed as a ColdBox module if you wish, which means it is available to use with Wirebox dependency injection by adding the property `swearjar@swearjar' to your services and components.

Thank you to Brad for also helping me out via Twitter DM when I hit an issue with legacy artifacts when testing this out.

So, for all of you ColdBox users out there, you no longer need to manually map or bind the component. That's to Wirebox goodness and the ModuleConfig, it's all taken care of for you.


