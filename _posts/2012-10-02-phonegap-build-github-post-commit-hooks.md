---
layout: post
title: PhoneGap Build Github Post Commit Hooks
slug: phonegap-build-github-post-commit-hooks
categories:
- Development
tags:
- PhoneGap
status: publish
type: post
published: true
date: 2012-10-02
---
<p>I gave a presentation at <a title="PhoneGap Day EU 2012" href="http://pgday.phonegap.com/eu2012/" target="_blank">PhoneGap Day EU 2012</a> in Amsterdam in September titled "<a title="Automating PhoneGap Build on Slideshare" href="http://www.slideshare.net/coldfumonkeh/automating-phonegap-build" target="_blank">Automating PhoneGap Build</a>". Essentially, the talk was about the cloud-based build service (now out of Beta, if you haven't yet heard) and how developers can integrate it into their workflow.</p>
<p>As part of the talk, I was integrating an ANT build from within Eclipse / ColdFusion Builder to access, upload to and deploy from my PhoneGap Build account. I'm a BIG believer in reducing the need to exit your IDE wherever possible. If I can keep my workflow in one place as much as possible, I'm happy.</p>
<p>Now, these ANT tasks were using the awesome PhoneGap Build API (<a title="PhoneGap Build API Docs" href="https://build.phonegap.com/docs/api" target="_blank">https://build.phonegap.com/docs/api</a>) which I love. I also use Git repositories for all of my code and projects, and the ability to create or define a PG Build project directly from a Git repos is awesome.</p>
<p>Although the API contains a method to run a pull request from the repository (which will then rebuild the project for you), it's still an extra step in the chain that need not necessarily be there.</p>
<p>Consider this:</p>
<ul>
<li>commit your code to your Git repos</li>
<li>perform the pull request in PhoneGap Build (via API or logging into the UI)</li>
</ul>
<p>Whilst these two tasks can be combined fairly easily using an ANT task or bash script / bat file, there is another way to automatically pull the latest code and rebuild directly after committing your code to Github.</p>
<h2>Web Hooks</h2>
<p>GitHub provides a lot of service hooks for use after a commit. I've <a title="Github Post-Receive Custom ColdFusion Hook" href="http://www.mattgifford.co.uk/github-post-receive-custom-coldfusion-hook">written about them before</a> and <a title="Github Post Receive Hook on Github" href="https://github.com/coldfumonkeh/Github-Post-Receive-Hook" target="_blank">created a ColdFusion CFC wrapper</a> to handle the data payload delivered in the POST request.</p>
<p>There are service hooks to tap into ticketing applications, sending commit notifications via Twitter and a range of other services.. one of the options (the first in the list, in fact) is a WebHook URL. This can be any remote URL of your choosing (ideally one you have access to).</p>
<p>You can access these from the <strong>Admin</strong> button in the main menu of your Github project:</p>
<p><img  title="Github Admin Panel" src="/assets/uploads/2012/10/github_admin_panel-610x175.png" alt="Github Admin Panel" />Select <strong>Service Hooks</strong> from the left navigation and click <strong>WebHook URLs</strong>. You can add as many custom URLs as you want to for each project, but in this case we'll just use the one.</p>
<p><img  title="Github Web Hooks" src="/assets/uploads/2012/10/github_web_hooks-610x200.png" alt="Github Web Hooks" /></p>
<h2>So, how can we use this with PhoneGap Build?</h2>
<p>Simple.</p>
<p>In the settings panel for your Git repository-powered PhoneGap application, you will see a button marked <strong>Pull latest</strong>.</p>
<p><img title="PhoneGap Build Pull Request Button" src="/assets/uploads/2012/10/pgbuild_pull_request_button.png" alt="PhoneGap Build Pull Request Button" /></p>
<p>The link associated with this button is something like the following: <strong>https://build.phonegap.com/apps/217582/push</strong> (where the application ID 217582 is specific to your PG Build app).</p>
<p>We can force a request to this page directly without making a request to the PG Build API. All we need to do is use basic authentication to validate ourselves and gain access.</p>
<p>We can't set this URL directly into the Github service hook field, but we can perform the request to this function from the page we do set as the service hook.</p>
<h2> What do we need to make this work?</h2>
<p>To perform the basic authentication against the PG Build service and access the correct project, you will need to send through the following three parameters:</p>
<ul>
<li>your PhoneGap Build username</li>
<li>your PhoneGap Build password</li>
<li>the ID of the project / application</li>
</ul>
<p>I created a very simple Ruby application using the Sinatra framework to handle this.</p>
<p><strong>http://autobuild.monkeh.me/myemail@something.fake/password/12345</strong></p>
<p>Below is the code for the autobuild.monkeh.me Sinatra application.</p>
<p>The default route ('/') displays nothing but some text output. The main focus here is the second route, available by GET or POST requests. This route will accept the URL made up of the username, password and application ID. This will then perform a GET request to the PhoneGap Build repository push request to grab the latest code from the repository and rebuild the application.</p>

```
require 'sinatra'
require 'rest_client'

def get_or_post(path, opts={}, &block)
  get(path, opts, &block)
  post(path, opts, &block)
end

get '/' do
        'Hello world'
end

get_or_post '/:user/:pass/:appid' do

        pgURL = 'https://build.phonegap.com/apps/' + params[:appid] + '/push'
        private_resource =
            RestClient::Resource.new pgURL, params[:user], params[:pass]
        private_resource.get{ |response, request, result, &block|
        if [301, 302, 307].include? response.code
        response.follow_redirection(request, result, &block)
        end
}

end

# Handle all other routing
["/", "/:user", "/:user/", "/:user/:pass", "/:user/:pass/"].each do |path|
get_or_post path do
        'Ru-roh, you cant do that.'
end
end
```

<p>So, if you add the following URL (using your own PhoneGap Build username, password and application ID) to the Github Web Hook URL, every commit made to Github will send a request to this URL, which in turn will make the authenticated request to the PhoneGap Build service to pull the latest code from your repository and rebuild all applications.</p>
<p>I love the PhoneGap Build service - it already makes life so much easier and is awesome sexy voodoo magic. Add the API into the mix, and you already have the ability to define your own workflow for building mobile PhoneGap applications.</p>
<p>Using the Github service hooks is just taking one extra step out of the workflow and helping to automate the deployment / build processes. Feel free to try it yourself using the <strong>autobuild.monkeh.me</strong> URL.</p>
