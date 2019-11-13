---
layout: post
title: CFML swearjar profanity detection and filtering component library
slug: cfml-swearjar-profanity-detection-and-filtering-component-library
date: 2019-11-13
categories:
- ColdFusion
- Lucee
- CFML
tags:
- ColdFusion
- Lucee
- CFML
excerpt: "Introducing the CFML swearjar profanity detection and filtering component"
---

Yesterday I was working on a client project that needed some form of curse / explicit word detection within content. This was easy enough (and fun to build), but during my investigations into how others have done similar things, I found a JavaScript package called [swearjar-node](https://github.com/ahmedengu/swearjar-node). The more I looked at it, the more I realised this would be great to convert into a CFML component that could be used server-side for profanity detection.

So last night, whilst listening to and half-watching the fabulous [Modernize or Die&reg; Podcast](https://cfmlnews.modernizeordie.io/), I created a CFML version of the library.

### Introducing the swearjar

Instantiation of the component is simple:

```
swearjar = new swearjar();
```

By default the component loads in the `en_US.json` 'libary' file that is included in the `config` directory which includes a number of horrendous words and their associated categories. This, too, was a direct port of the same config file from the original JavaScript package, and as a result anything you read in there was not included by me. Just to get that caveat out there in case people start thinking "Wow, monkeh has a potty mouth!".

There are benefits of having a library loaded in such a way, including:

**you can add to it when you discover more filth that you want to detect and censor in your application**

**you can create locale-based versions for your users**

Now, in all examples from this point on I will not be using the default library to save blushes and to refrain from having certain words on this blog post. Instead I will be loading in an alternate curse word library created especially for testing purposes: `vintage.json`.

Yes! Bring on the 17th century filth!

You have two options to load in a different library file:

**as part of the `init` constructor:**

```
swearjar = new swearjar( './config/vintage.json' );
```

**or after instantiating the component using the `loadBadWords` method:**

```
swearjar.loadBadWords( './config/vintage.json' );
```

The file is read by the component and the contents are stored in the `badWords` property, which is publicly-accessible so that you can access it:

```
stuBadWords = swearjar.getBadWords();
```

![The badWords variable dump](/assets/uploads/2019/11/swearjar_badwords_dump_one.png)

I'll give you a minute to soak those beauties into your vocabulary.

All done?

Let's move on then.

You can see that the structure of the library files dictates that you have keys for 'regex' values, `simple` word lookups and also `emoji` detection.

### Detection

To detect profanity in any content, simply pass the text into the `profane` method, which will return a boolean value depending on whether or not it contains anything declared within the library file:

```
swearjar.profane( 'What are you doing?!?' ); // returns false

swearjar.profane( 'What in tarnation are you doing, you rantallion?!?' ); // returns true
```

You can get a detailed structure of profanity using the `detailedProfane` method:

```
stuDetailed = swearjar.detailedProfane( 'What in tarnation are you doing, you rantallion?!?' );
```

![The detailedProfane response](/assets/uploads/2019/11/swearjar_detailedProfane.png)

Here you can see the response includes the `profane` boolean value, the words (and the number of times they were included) that it has detected from the library, the categories (and number of items within those categories), and the censored version of the content.

You can directly return the censored string for output using the `censored` method:

```
strCensored = swearjar.censor( 'What in tarnation are you doing, you rantallion?!?' );
```

The result is the original string including the filthy words censored with an asterisk for every character.

![The censored response](/assets/uploads/2019/11/swearjar_censored_response.png)

Should you wish, you can obtain a struct of all words (and their categories) contained within the passed text using the `words` method:

```
stuWords = swearjar.words( 'What in tarnation are you doing, you rantallion?!?' );
```

![The words response](/assets/uploads/2019/11/swearjar_words_response.png)

The `scorecard` method analyzes the given text and generates a report of the type of profanity found:

```
stuScorecard = swearjar.scorecard( 'What in tarnation are you doing, you rantallion?!?' );
```

This returns a struct containing all categories as keys, with a total count relating to the number of words included in the given text associated with that category:

![The scorecard response](/assets/uploads/2019/11/swearjar_scorecard_response.png)


You may need to programmatically update the curse words you wish to detect and inject them into the component.

You can do this for the `simple`, `regex` and `emoji` values using the `addSimple`, `addRegex` and `addEmoji` methods respectively.

Any new additions you make this way are not written to the file and as such will only be persisted for as long as the component is alive.

Let's take a quick look at how to add a new `simple` value to detect.

All you need to do is add the string value to detect, followed by an array of categories that it may be associated with:

```
wearjar.addSimple( 'fustilarian', [ 'insult' ] );
```

The `addSimple`, `addRegex` and `addEmoji` methods return void / null, but the value you have provided will have been added to the `badWords` struct within the component for use:

![The badWords variable dump](/assets/uploads/2019/11/swearjar_badwords_dump_two.png)

In the above image you can see we now have **fustilarian** as a value to check for.


So, that's the `swearjar` component. It was a fun quick package to work on, and one that I can see being rather useful. It's [available on Github](https://github.com/coldfumonkeh/swearjar) and [Forgebox](https://forgebox.io/view/swearjar) and is compatible with Lucee 4.5, Lucee 5, ColdFusion 2016 and ColdFusion 2018.

Have at it!