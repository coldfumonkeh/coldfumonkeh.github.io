---
layout: post
title: CFML content moderation detection component library
slug: cfml-content-moderation-detection-component-library
date: 2019-12-23
categories:
- ColdFusion
- Lucee
- CFML
tags:
- ColdFusion
- Lucee
- CFML
excerpt: "Introducing the CFML PicPurify content moderation, detection and filtering component"
---

Another day, another API.

Yesterday I was working on a client project that needed some form of automated content moderation when uploading image and video files. Ideally, I needed to check for pornographic content and content that included nudity, hateful images, gore and general nastiness. To save having to write complex AI detection features from scratch I searched the web for existing APIs that could handle this. There were a few that handle nudity (through facial recognition and detection of the skin tone) but nothing seemed to cover all categories I wanted to check. And then I found [PicPurify](https://www.picpurify.com/).

Their API was able to check for the following categories in both images and video:

* porn_moderation
* suggestive_nudity_moderation
* gore_moderation
* money_moderation
* weapon_moderation
* drug_moderation
* hate_sign_moderation
* obscene_gesture_moderation
* qr_code_moderation
* face_detection
* face_age_detection
* face_gender_detection
* face_gender_age_detection

The free tier gives you 2000 free units for detection (one category per request is one unit, so if we wanted to check an image for nudity and gore that would mean two units have been used).

As a result, I created the [PicPurify CFML wrapper](https://github.com/coldfumonkeh/PicPurify) for the API.

### Introducing PicPurify

Instantiation of the component is simple. You will need an API key from their site. 

Simply pass the API key into the `init` method:

```
picpurify = new picpurify( apiKey = '<YOUR API KEY GOES HERE>' );
```

This package is also a ColdBox module. The module can be configured by creating a `picpurify` configuration structure in your application configuration file (`config/Coldbox.cfc`) with the following settings:

```
picpurify = {
     apiKey = '<YOUR_API_KEY_GOES_HERE>' // Your PicPurify API Key
};
```

Then you can inject the CFC via Wirebox:

```
property name="picpurify" inject="picpurify@picpurify";
```

Let's take a sample API request and pass through the URL for a remote image of "indecent nature". We'll ask the API to check it for nudity and pornographic content:

```
stuResponse = picpurify.analysePicture(
    task      = 'porn_moderation,suggestive_nudity_moderation',
    url_image = '<REMOTE URL FOR IMAGE FILE>'
);
```

The resulting output from the API contains the categories submitted in the search, which (if any) failed, and the overall score for the moderation.

![PicPurify Result Dump](/assets/uploads/2019/12/PicPurify_result_dump.png)

The `final_decision` value will also inform you if something contains naughty things as it will return `KO` as opposed to a clean image or video that would return `OK`.


So, that's the `PicPurify` component. It's [available on Github](https://github.com/coldfumonkeh/PicPurify) and [Forgebox](https://forgebox.io/view/picpurify) and is compatible with Lucee 4.5, Lucee 5, ColdFusion 2016 and ColdFusion 2018.

Onwards with your content moderation!