---
layout: post
title: Atom Editor Plugins
slug: atom-editor-plugins
categories:
- Development
tags:
- developers
status: publish
type: post
published: true
date: 2015-04-08
excerpt: "Atom editor has been the IDE of choice for the last few months. Here are some of the plugins I use on a daily basis to enhance productivity."
---

A few weeks ago I posted the following on Twitter:

<blockquote class="twitter-tweet" lang="en"><p>Have been using <a href="https://twitter.com/AtomEditor">@AtomEditor</a> full time for the last 5 months. Amazing editor with great packages and workflow integration.</p>&mdash; Matt Gifford (@coldfumonkeh) <a href="https://twitter.com/coldfumonkeh/status/581006109491638272">March 26, 2015</a></blockquote>

Whilst the tweet didn't garner a multitude of responses from across the globe (why would it have?) it received a few responses from interested parties and all were related to packages or as Dan Kraus put it:

<blockquote class="twitter-tweet" data-conversation="none" lang="en"><p><a href="https://twitter.com/coldfumonkeh">@coldfumonkeh</a> <a href="https://twitter.com/AtomEditor">@AtomEditor</a> what are your must-have&#39;s?</p>&mdash; Dan Kraus (@DanKrausDev) <a href="https://twitter.com/DanKrausDev/status/581074969544790016">March 26, 2015</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>


So, I thought I'd quickly list the plugins / packages I use on a daily basis and those I recommend you install.

They are listed in the order of most downloads in total.

## [file-icons](https://atom.io/packages/file-icons)

This awesome little plugin renders file extension plugins in the project navigation / file sidebar making it easier to instantly visualise what files are which types (sometimes it's not always easy to see the actual file extension if the structure is heavily nested or you like your screen space).

## [merge-conflicts](https://atom.io/packages/merge-conflicts)

An easy way to manage merge conflicts directly within Atom. Why jump out of the context or break your stride if you don't have to?

## [editorconfig](https://atom.io/packages/editorconfig)

Configuration plugin to help maintain consistent coding styles between editors. If you're not using this method of configuration yet you should. Whilst it's not yet fully supported across the board it's a good habit to get into and really helps with consistency. Check out http://editorconfig.org for more details on the project.

## [travis-ci-status](https://atom.io/packages/travis-ci-status)

I'm a big fan of Travis C.I. (and continuous integration in general) so this package is a must for me. It's rather subtle and unobtrusive. If Atom detects a travis.yml file in your project. A small clock icon appears in the status bar at the bottom of the editor and display build success (or failure) by changing colour. Clicking the icon will open a panel in the editor with some build information. Anything that can help provide an instant visual over build success is useful.

## [markdown-pdf](https://atom.io/packages/markdown-pdf)

I write a lot of magazine articles and features. For years these were written in Word documents until last year when I started writing most things in Markdown. I had an app on the Mac (iA Writer) that could convert Markdown into Word and PDF files but it sometimes messed up the formatting.

I found this plugin about 4 weeks ago and it perfectly converts my Markdown files (which contain a lot of formatted code blocks) into PDF files. This has made my life that little bit easier.

## [grunt-runner](https://atom.io/packages/grunt-runner)

I love Grunt. It is used in most of my projects and save so much time. I tend to run it directly via the Terminal whenever I open a project into the editor like so:

```
cd my-awesome-project
atom . && grunt
```

but there are a few Grunt packages available for Atom. This one displays a panel at the bottom of the editor which can be toggled to hide if necessary. It will detect a Gruntfile in your project root and clicking the 'Start Grunt' button will display the available tasks you can run. Select one (typically the 'default' task for me) and it will run for you. Toggle the log output and the panel will open to show you Terminal output from the task runner. This plugin can be a little intrusive sometimes (the panel seems to open by default every time) and it's not one I use all of the time but it works well and is employed occasionally.

## [pdf-view](https://atom.io/packages/pdf-view)

After I discovered the awesome Markdown PDF plugin (above) I wanted to open the generated PDF files in Atom to proof-read them before sending off to publishers. This package provides the support to open and render PDF files in the editor. Much needed (and a surprise PDF reading isn't available as standard).

## [wordcount](https://atom.io/packages/wordcount)

Another writing-related package. I need to keep a close eye on word counts when writing magazine content. This plugin allows me to do that nicely.

## [npm-install](https://atom.io/packages/npm-install)

A really helpful package. With a .js file open that includes require calls to modules, running a command from this module can install and save the modules into the project's package.json file. A BIG time saver.


## [bower-install](https://atom.io/packages/bower-install)

Similar to the above NPM package but manages Bower dependencies instead and saves them to the bower.json file.

## [atom-jasmine](https://atom.io/packages/atom-jasmine)

I like [Jasmine](http://jasmine.github.io) as a testing tool nd this package provides snippets for the lazy / time-conscious / efficient developer to write Jasmine specs. Type in the shorthand keyword, press tab and it auto-completes and creates the spec outline for you. Thank you time saving awesomeness.

## [language-cfml](https://atom.io/packages/language-cfml)

Any ColdFusion work can benefit from Adam Tuttle's CFML language package. Pull the repo, add to it, give back to the community.


## [jasmine-runner](https://atom.io/packages/jasmine-runner)

Having written the Jasmine tests this package can help me run them within the editor. Again, why break out of my context/ focus if I don't have to?

## [jenkins](https://atom.io/packages/jenkins)

Similar to the Travis CI package above, this Jenkins package reads from the Jenkins server feed and reports build status in the bottom status bar of the editor. Clicking the colour coded icon will show a panel of job details which also includes links to the jobs on the Jenkins server. Another helpful quick visual guide for build stats.


# Having it all

Atom ships with a number of useful packages already included; these are simply packages I have used consistently or found incredibly useful since moving to Atom.

Should you wish to install all of these packages now (why would you not?) then simply run the following command and they will be installed and ready for your Atom-powered workflow.

```
apm stars --user coldfumonkeh --install
```

# Recommendations?

Are there any packages you use that you'd like to recommend? Please let me know if so.
