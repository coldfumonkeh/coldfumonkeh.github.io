---
layout: post
title: Github Actions with CommandBox and TestBox
slug: github-actions-with-commandbox-and-testbox
date: 2020-07-16
categories:
- ColdFusion
- Lucee
- CFML
tags:
- ColdFusion
- Lucee
- CFML
excerpt: "Add some custom workflows to your Github repositories with this very helpful action to perform TestBox unit tests on your CFML code"
---

Following on from my blog post last week after my investigation into using [Azure Pipelines with your Github repositories](/2020/07/09/azure-pipelines-with-commandbox-and-testbox.html) to run your CFML TestBox test suites in ComandBox, this afternoon I started playing around with [Github Actions](https://github.com/features/actions) to see what was available.

I'm a big believer in automating what you can, and have certainly been a big fan of pipelines and continuous integration features for a long time. As a result Github Actions were something that piqued my interest as soon as I 'discovered' them last week.

After successfully getting the pipelines running in Azure, I wanted to see how feasible it would be to create a new Github Action that anyone could use to run their unit tests against their CFML code in a CommandBox Docker instance.

It turns out it was very easy, and it's now available for everyone to use from the Github Marketplace (for free): [https://github.com/marketplace/actions/cfml-testbox-test-runner](https://github.com/marketplace/actions/cfml-testbox-test-runner)

![The CFML testBox Test Runner action](/assets/uploads/2020/07/cfml-testbox-test-runner-on-Github-Marketplace.png)

Very similar to tagging versions of modules in your Git repositories and publishing those versions / releases to [ForgeBox](http://forgebox.io/), you can publish and release multiple versions of whatever actions you create. When a user visits the action on the marketplace, as shown above, the available versions are listed in the drop down on the top right of the page.

Clicking "Use latest version" will display an overlay window with the absolute bare minimum code you need to add this action to your workflows.

![The latest version action example](/assets/uploads/2020/07/cfml-github-action-useage-example.png)


The following is an example `.github/workflows/main.yml` file that you can use in your repositories to create matrix testing strategies for various versions of CFML engines:

<script src="https://gist.github.com/coldfumonkeh/7f3e220447f1ab47f541ab0817c7f601.js"></script>

Essentially this workflow will run whenever anyone pushes to the `master` branch or any pull requests are created for the `master` branch. The events, much like anything else available through the actions, can be customised to really target specific workflows for specific branches, should you wish.

The matrix strategy is quite simple, and saves us having to duplicate code blocks to define multiple engines to test against.

Here we can simply set the CFML engine versions (in a CommandBox friendly way using the slug and @version reference) and we pass the `cfml_engine` version from the matrix into the CFML TestBox Action code block. This will then create and run separate steps for each engine version listed.

![The CFML Testing Workflow in action](/assets/uploads/2020/07/cfml-github-testing-workflow-matrix.png)

As you would expect, you can click into each workflow job and see each step of the process. You can see in this screenshot that the action even outputs to the console to confirm that `Your CFML engine of choice is lucee@4` (or whatever the version passed to the action was) before it begins to install dependencies and start running the TestBox tests.

![The CFML Testing Workflow running the requested CFML engine version](/assets/uploads/2020/07/cfml-github-matrix-action-in-progress.png)

I still really love the fact that Github shows you the status of any pipelines or actions that are or have been running on your repository from the "home page" of the repo, with the option to click through to view the specific details.

![Action results visible from the repository home page](/assets/uploads/2020/07/cfml-testbox-action-results-visible.png)

The [CFML testBox action itself is open source and available on Github](https://github.com/coldfumonkeh/cfml-testbox-action).

I hope you find this action useful, and if you use it in your workflows let me know!