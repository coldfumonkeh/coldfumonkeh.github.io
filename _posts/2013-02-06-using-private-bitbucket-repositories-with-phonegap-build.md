---
layout: post
title: Using Private Bitbucket Repositories With PhoneGap Build
slug: using-private-bitbucket-repositories-with-phonegap-build
categories:
- Development
- Mobile
tags:
- Workflow
- Git
- PhoneGap
status: publish
type: post
published: true
date: 2013-02-06
---
<p>The PhoneGap Build service has been able to associate an application account with a private Github repository for <a title="PhoneGap Blog: Building from your Private Github Repositories" href="https://build.phonegap.com/blog/building-from-your-private-github-repositories" target="_blank">some time now</a>.</p>
<p>As Github charges for private repositories, moving from a free account to a micro account, it's not always easy (or financially viable) to keep your source code private through their system. This is where <a title="Bitbucket.org" href="https://bitbucket.org/" target="_blank">Bitbucket</a> excels, with unlimited private repositories for any of your projects you wish to remain secret - after all, you don't want everyone to see the code for your next killer app, right?</p>
<p>However, the PhoneGap Build service currently only caters for easily linking your Github private repositories, so how can you still use your private Bitbucket repo and pass it through to the PhoneGap Build service to generate your mobile applications?</p>
<p>It turns out this is incredibly easy. Firstly you will need (obviously) a private Bitbucket repository with code ready to deploy to the build service:</p>
<p><img alt="Private Bitbucket repository" src="/assets/uploads/2013/02/bitbucket_private_repo.png" /></p>
<p>Next, when creating your new application in PhoneGap Build, choose the <strong>private</strong> tab - the open-source tab will only accept Github URLs:</p>
<p><img alt="PhoneGap Build Private Repository" src="/assets/uploads/2013/02/pgbuild_private_app.png" /></p>
<p>Entering in the Bitbucket repo URL 'as it is' won't work. The build service won't be able to access it. So, to use private Bitbucket repositories, simply alter the URL to pass through your repository account password, as you would when sending a basic http authentication request, like so:</p>

```
https://coldfumonkeh:<strong>my_killer_password</strong>@bitbucket.org/coldfumonkeh/test-private-repo.git
```

<p>The build service will then be able to authenticate against your private Git repository and pull your code in. Nice and easy.</p>
<p><img alt="Private PhoneGap Build App" src="/assets/uploads/2013/02/private_app_created.png" /></p>
<p>By doing this, you can host your PhoneGap applications in a private repository outside of Github and still access them through the PGBuild services, keeping your source code secure and hidden.</p>
<p>You can also streamline the workflow and deployment process to PhoneGap Build by using the <a title="Autobuild your PhoneGap applications from a Git commit" href="http://autobuild.monkeh.me/" target="_blank">autobuild</a> service I created. Setting up a POST service in Bitbucket will send a request to PhoneGap Build after every successful commit to the repository, which will then trigger an automatic pull request to update the code and compile the application for you, incrementing the build. One commit, numerous processes handled for you. Find out how easy it is to set up an autobuild request on the official site: <a title="Autobuild your PhoneGap applications from a Git commit" href="http://autobuild.monkeh.me/" target="_blank">http://autobuild.monkeh.me/</a></p>
