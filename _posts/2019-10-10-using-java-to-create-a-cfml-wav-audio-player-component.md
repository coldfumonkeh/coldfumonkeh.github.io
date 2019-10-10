---
layout: post
title: Using Java to create a CFML .wav file audio player component
slug: using-java-to-create-a-cfml-wav-audio-player-component
date: 2019-10-10
categories:
- development
tags:
- coldfusion
- open source
- component
excerpt: "Hey, you! You want to play .wav files in your CFML application using a component? Check this out!"
---

Yesterday I had a thought (it does happen sometimes), and I wondered if it's possible to make an audio player in CFML that manages audio playback through the browser.

I had a little investigation, and during my lunchbreak today I came up with [CFWavPlayer](https://github.com/coldfumonkeh/CFWavPlayer).

I don't know why you'd want to use this, but you might do.. because, you know, wav files are cool.

This was built just for fun as an experiment, and I love how CFML lets me create and try these things out with relative ease.

### Create a new player

Instantiating a new instance of the `CFWavPlayer` object can be done through the `WavBuilder` factory.

All methods that interact directly with the audio playback and management can be chained.

<script src="https://gist.github.com/coldfumonkeh/f38edd414a61331d24513881a18bf494.js"></script>

This above code will create a new instance of the `CFWavPlayer` object, load in a file and play it to the end.

You can choose to run an action on the `CFWavPlayer` instance at a given duration using the `wait()` method. This is essentially a helper shortcut method to the CFML `sleep()` function.

<script src="https://gist.github.com/coldfumonkeh/b3c266fe5db9e8bccf590a162050ce93.js"></script>

So, in the above example, we load a file, start playing it, and five seconds into it we stop the audio.

We could use the `wait()` method to do other things:

<script src="https://gist.github.com/coldfumonkeh/aed9bd7cb6c5e6c0c0b22fb56a7cd267.js"></script>

Here we play the loaded wav file, wait five seconds, pause it, wait another 1.5 seconds, then resume playing from where we left off. I know.. the power to control the wav is immensely invigorating.

### Jumping the playhead

You can use the `jumpTo()` method to move the virtual playhead to a given point in the track and then start playing from there:

<script src="https://gist.github.com/coldfumonkeh/b4a8712c916cb5e8924ba4727d05433c.js"></script>

This can be useful to cut out any annoying introductions to songs. I mean, who wants to listen to a million bars of intro when you can just jump straight to the awesome guitar riff somewhere in the middle? (assuming you know the exact microsecond position of that guitar riff).

### Looping

You can loop an audio file endlessly, should you wish too:

<script src="https://gist.github.com/coldfumonkeh/e6fc8555b62e28854625080d93534ea4.js"></script>

**Note that with the `loop()` method added to the chain you do not need to call the `play()` method.**

To stop the loop, you would then just need to call the `stop()` method on the `CFWavPlayer` instance:

<script src="https://gist.github.com/coldfumonkeh/f4d23fcd258c79b3e34c1c938fd42dfb.js"></script>

**NOTE that if you add a `loop()` and forget to add a `stop()`, the only way to kill the sound is to restart your server.**

In this looping example we can loop over the audio file which is roughly ten seconds long.
After 2.5 loops we can stop it:

<script src="https://gist.github.com/coldfumonkeh/690eaea22e25624a2e58bdd1ada39639.js"></script>

### Restarting audio

You can also restart the audio from the beginning:

<script src="https://gist.github.com/coldfumonkeh/d95d7cda3038d2f87f9c157ab5f08c8f.js"></script>

In the above example we play the audio for ten seconds then restart it from the very beginning, playing it through to the end. Just because we can.

### Multiple sounds at once!

You can use `CFWavPlayer` to play multiple sounds at once through the browser. Because who doesn't like wav-induced headaches?

Before we play the audio in `player1` we can get the duration (in microseconds) from the underlying Java `Clip` instance. We can then convert that duration into milliseconds and pass it into the `wait()` method on `player2`, after which we'll tell it to stop playing.

Running this, both sounds will start and end at the same time, the second looping until the first one finishes.

The parallel play doesn't seem work in Lucee but I have tested it and it is working on Adobe ColdFusion 2018.

<script src="https://gist.github.com/coldfumonkeh/a1c756990e72bc55197a3e1f40843fe1.js"></script>

### Debugging (kinda)

You can debug (in a way) by also dumping out the current status of the `CFWavPlayer` instance, as well as the current frame of the audio playhead:

<script src="https://gist.github.com/coldfumonkeh/806dfa0b29f73ee422295cdf612b94c2.js"></script>

So, that's `CFWavPlayer`. It was built for fun in about 60 minutes as an experiment and testing myself to explore a little more about the underlying Java classes. Plus, it's audio related, so for me that's a LOT of fun.

You can find the project on my [Github repository](https://github.com/coldfumonkeh) [here](https://github.com/coldfumonkeh/CFWavPlayer)