---
layout: post
title: devObjective 2015 Day One Notes
slug: devobjective-2015-day-one-notes
date: 2015-05-13
categories:
- Events
- ColdFusion
tags:
- Events
- Developers
- ColdFusion
excerpt: "Notes taken during the devObjective 2015 conference in Minneapolis, Wednesday 13th May 2015."
---

## devObjective 2015

Notes taken from sessions attended at the devObjective 2015, day one (13th May 2015)

---

### Web Penetration and Hacking Tools

Presented by David Epler

https://www.owasp.org/index.php/Category:OWASP_Top_Ten_Project

sqlmap.org  SQL injection vulnerability checking tool (demo #1)

BeEF (Browser Exploitation Framework) running with Metasploit (demo #2)

Published Exploit Script (demo #3)

* Sub-Zero.py can access the CF 9-10 administration password and suck source code from your server (anything that CF can access it can access too)


Web Application Firewalls can help protect web apps without the need to modify them.

They:

* can be a appliance, server plugin or filter
* can provide an additional layer of security
* can react faster than changing application code
* more common in front of legacy applications

#### ModeSecurity WAF

* open source, free web app firewall
  * Apache, IIS 7, Nginx, reverse proxy
* Security Models
  * negative security model
  * positive security model
  * virtual patching
  * extrusion detection model
* OWASP ModSecurity Core Rule Set Project

#### Web Vulnerability Scanners

* Provide automated way to test web applications for vulnerabilities
  * static vs dynamic analysis
  * can be challenging to setup authentication and session management
  * can't improvise, every web application is unique
* Usually integrated as part of Secure Software Development LifeCycle (SSLDC)


#### Recommended Reading

[The Web Application hacker's Handbook: Finding and Exploiting Security flaws (Second Edition)](http://www.amazon.com/Web-Application-Hackers-Handbook-Exploiting/dp/1118026470/ref=sr_1_1?s=books&ie=UTF8&qid=1431533700&sr=1-1&keywords=The+Web+Application+hacker%27s+Handbook%3A+Finding+and+Exploiting+Security+flaws+%28Second+Edition%29) - by Dafydd Tuttard and Marcus Pinto

---

### Building Desktop Apps with HTML & JavaScript. Node-webkit

Presented by Andy Matthews

[nw.js](http://nwjs.io/) (formerly node-Webkit)

[nw.js on Github](https://github.com/nwjs/nw.js/)

Chromium Shell and node.js

Cross-platfrom solution for desktop applications.

Installation:

<pre>npm install -g nw</pre>

Configuration of desktop app via <code>window</code> node in package.json file.

Test application locally without having to compile. <code>nw</code> command will open the app using default index page.

Init method (of sorts):

<pre>require("nw.gui").Window.get().show();</pre>

or

<pre>
var gui = require("nw.gui");
gui.Window.get().show();
</pre>

Accessing the menu object from the gui:

<pre>
var player = new gui.Menu();
player.append(new gui.menuItem({ icon: 'imgs/something.png', label: 'Play' }));
</pre>

* Context menu management
* Full file system access and management
* Drag and display portability and management

Use Grunt / Gulp to automate your build process for the application.


#### Node-Webkit vs Atom Shell (Electron)

* Electron is all JS (no HTML files)
* Electron _may_ have slightly better performance over NW
* NW installs A LOT of stuff you may not need and could weight down your distributed product
* NW leaves JS files ready to view on the user's machine
  * Use Grunt / Gulp to minify, uglify and obfuscate your code before distribution

Use a [generator](https://www.npmjs.com/package/generator-node-webkit) to help with it all:

<pre>npm install -g generator-node-webkit</pre>


---

### Our application got popular, and now it breaks

Presented by Dan Wilson

Customer behaviour affected by site latency. Customer abandonment rate increased by 8%.

<blockquote>"Life is about shared resources."</blockquote>

You make choices every time you program and develop. They will either give you opportunities for success of avenues to dead ends.

A bottleneck simply leads to another bottleneck. That's just the way it works.

#### Evil #1: Making bad tradeoffs

* Do not use the session scope

[ missed some content here due to phone call ]



#### Evil #2: Database Abuse

* Looping queries, not using JOINS (also using JOINS badly)


---

### Front-End Modernization For Mortals

Presented by Cory Gackenheimer

How do you choose which languages / frameworks to use?

* Blog posts
* Conference Talks
* Video tutorials
* Try stuff yourself
* Recommendation form friend / colleague
* more...

but...

codebase is not primed to accept

* bower
* browserify
* AMD modules
* Grunt / Gulp tasks, Brocolli etc

#### Current Workflow

Has been tested and proven

* team has been doing it for years
* company is making money doing X for so long
* developers understand it and have bought in
* changing things wholesale will take some adjustment



#### Next Workflow

You can either

A) adopt wholesale the processes of someone you
  * have seen talk
  * read a blog about
  * uses framework X

B) Accept that you cannot change _everything_

#### What is a monlith?

Anything that hinders the maintainability and stability of your front-end code


#### Modularize

  * Take inventory of your code

  Do you need these to co-exist?

    * API wrapper
    * validation calls
    * date parsing
    * animation/UI hacks


  * Split it out into manageable chunks for development (breaking down the large JS files)  

  * Concatenate and minimize them

This is enough to make a measurable difference. Your code is immediately more manageable and maintainable. It is also minimized for the client.

Improve upon this. Concat and minimization may not be enough.

Leverage jQuery using the <code>$.extend()</code> method which can allow you to merge objects seamlessly.

Use AMD modules (require.js for example) to improve modularity.

Using ES6 and [babel.io](https://babeljs.io)
