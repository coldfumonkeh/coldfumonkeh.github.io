---
layout: post
title: Azure pipelines with CommandBox and TestBox
slug: azure-pipelines-with-commandbox-and-testbox
date: 2020-07-09
categories:
- ColdFusion
- Lucee
- CFML
tags:
- ColdFusion
- Lucee
- CFML
excerpt: "Here's how to set up Microsoft Azure to run a development pipeline and perform TestBox unit tests on your CFML code"
---

I've been trying to implement pipelines for my own personal and open source repositories so that I can easily perform automated unit tests against the CFML code.

I have a working Bitbucket pipeline script that works perfectly for any code I have in my Bitbucket repositories, but all of my open source projects are hosted on GitHub.

As a result, I wanted to get the testing pipelines set up using the [Microsoft Azure developer tools](https://dev.azure.com/) associated with Github.

![Build Status in GitHub](/assets/uploads/2020/07/azure-01.png)

Although both are written and defined using the YAML syntax, the two are very different.

I was able to initially set up a multi-stage pipeline that was able to download and install CommandBox, but the actual tests were never run as they were outside of the environment; basically it was all wrong and I was stuck.

So, I reached out to the amazing CFML community, as one should in times such as these:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Yes, I have a guide for that: <a href="https://t.co/0dLN7EiN9H">https://t.co/0dLN7EiN9H</a></p>&mdash; Pete Freitag (@pfreitag) <a href="https://twitter.com/pfreitag/status/1281042219944882176?ref_src=twsrc%5Etfw">July 9, 2020</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

Enter Pete Freitag, who had some documentation for his incredible [Fixinator](https://github.com/foundeo/fixinator) project on [how to run CommandBox and internal `box` commands in Azure](https://github.com/foundeo/fixinator/wiki/Running-Fixinator-on-Azure-DevOps-Pipelines-or-TFS).

I got Pete's reply this morning, and so after a coffee and a bit of a play with the Azure syntax I was able to get my pipelines working for my [OAuth2](https://github.com/coldfumonkeh/oauth2) project, testing the code against Lucee 4, Lucee 5, and versions 10, 11, 2016 and 2018 of Adobe ColdFusion.

Here's a snippet of the initial pipeline script ([the full raw script can be found here](https://github.com/coldfumonkeh/oauth2/blob/2838894bcf002b9f40cddf89dfc85a3886d612a1/azure-pipelines.yml)):


```
pool:
  vmImage: 'ubuntu-16.04'

stages:
  - stage: Testing
    jobs:
    - job: Lucee4
      steps:
      - script: |
          echo Starting the build
          curl --location -o /tmp/box.zip https://www.ortussolutions.com/parent/download/commandbox/type/bin
          unzip /tmp/box.zip -d /tmp/
          chmod a+x /tmp/box
          /tmp/box install production=false
          /tmp/box server start cfengine=lucee@4
          mkdir /tmp/results/
          /tmp/box testbox run outputFile=testbox-lucee4.xml reporter=junit
      - task: PublishTestResults@2
        inputs:
          testResultsFormat: 'JUnit'
          testResultsFiles: '**/testbox-*.xml' 
          testRunTitle: TestBox Tests
          failTaskOnFailedTests: true
        displayName: 'TestBox Results'
    - job: Lucee5
      steps:
      - script: |
          echo Starting the build
          curl --location -o /tmp/box.zip https://www.ortussolutions.com/parent/download/commandbox/type/bin
          unzip /tmp/box.zip -d /tmp/
          chmod a+x /tmp/box
          /tmp/box install production=false
          /tmp/box server start cfengine=lucee@5
          mkdir /tmp/results/
          /tmp/box testbox run outputFile=testbox-lucee5.xml reporter=junit
      - task: PublishTestResults@2
        inputs:
          testResultsFormat: 'JUnit'
          testResultsFiles: '**/testbox-*.xml' 
          testRunTitle: TestBox Tests
          failTaskOnFailedTests: true
        displayName: 'TestBox Results'
```

You can see that using `stages` I am able to split up the pipeline and each stage has a number of `jobs`. Each `job` relates to a specific CFML engine testing environment. The script block above shows the `Lucee4` and `Lucee5` jobs in the `Testing` stage.

![CFML engine steps in the Testing stage](/assets/uploads/2020/07/azure-cfml-engine-steps.png)

The screenshot above shows the complete engine job list run by the pipeline in parallel.

The script block for each engine does the same thing:

* download CommandBox
* run `box` commands to install TestBox
* start the specific CFML engine
* run the tests and output the results into a specific `testbox-XXXX.xml` file

I am not a fan of duplication, but for the initial ease of use and getting it up and running I was happy to make this minor sacrifice just to see the tests passing.

After each script step for each CFML engine, the pipeline then runs an Azure internal task, `PublishTestResults@2`, to publish the test results. By doing so the pipeline interface will have visual access to the overall tests run and the success / failure for each test included within the pipeline.

![See those tests pass!](/assets/uploads/2020/07/azure-pipeline-statistics.png)

I am sure this pipeline can be fine-tuned and improved by someone with more knowledge or experience than I on Azure's pipelines, but I am really happy that the pipelines are working and the test results and status are clearly visible for all contributors and visitors to the repository.

I do like that any vistor to the repository can dig into the status of the build and see what has passed / failed. and view the pipeline in more detail:

![Viewing the repository pipeline in more detail](/assets/uploads/2020/07/azure-github-pipeline-details.png)

It's time to get this initial pipeline script added to all of my repositories.

I want to finish by saying a huge THANK YOU to Pete Freitag for sharing the documentation and for helping me get this working as a result!