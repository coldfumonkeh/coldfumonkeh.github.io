---
layout: post
title: Into The Box 2015 Notes
slug: into-the-box-2015-notes
date: 2015-05-12
categories:
- Events
- ColdFusion
tags:
- Events
- Developers
- ColdFusion
excerpt: "Notes taken during the Into The Box 2015 conference in Minneapolis, Tuesday 12th May 2015."
---

## Into the Box 2015

Monkeh Works are speaking at (and attending the rest of) <a href="http://intothebox.org" target="_blank">Into The Box</a> in Minneapolis and will be posting notes of sessions attended throughout the day.

Thanks to <a href="http://www.ortussolutions.com/" target="_blank">Ortus Solutions</a> for organising this great event and for all of the sponsors for, well, sponsoring it.

This is the brain dump of notes taken throughout the sessions attended.

Make of them what you will.

---

### NoSQL for you and me

Presented by Brad Wood and Curt Gratz

* NoSQL is just a buzz word. No standards involved.
* Characteristics:
  * non-relational
  * open-source (some of them are, anyway)
  * cluster-friendly (some of them are, anyway)
  * schema less - (How can you have data without a schema?)
* Types:
  * key/value pairs
  * document databases
  * column databases
  * graph databases
    * great for storing social media-type data (think Facebook Graph data)
* CAP Theorem (pick two from these)
  * Consistency
  * Availability
  * Partition Tolerance
* No More ACID
  * **A**tomicity - all or nothing (transactions)
  * **C**onsistency - data is never violated (constraints, validation etc)
  * **I**solation - operations must not see data from other non-finished operations (locks)
  * **D**urability - state of data is persisted when operation finishes (server crash protection)
* Normalisation
  * Less data duplication
  * Less storage space
  * Higher data consistency / integrity
  * Easy to query
  * Updates are EASY
* Denormalisation
  * Minimize the need for joins
  * Reduce the number of indexes
  * Reduce the number of relationships
  * Updates are harder (slower)
* Making a mental shift from relational to NoSQL
  * In SQL we tend to want to avoid hitting the database as much as possible. We know it is costly when tying up connection pools and overloading DB servers.
  * Denormalisation takes getting used to.
  * Data integrity
  * Schema changes are easy

Code demo from Brad using CommandBox and [CFCouchbase SDK](http://www.ortussolutions.com/products/cfcouchbase) ([CFCouchbase SDK on Github](https://github.com/Ortus-Solutions/cfcouchbase-sdk))

* Lucee extension to provide Couchbase Server (and additional caching). Free trial version or paid / commercial fully-open version.

---

### Crash Course in Ionic + AngularJS

Presented by Nolan Erck

* Single Page Applications with Angular.js
  * mydomain.com/#/contact
  * mydomain.com/#/products
  * instead of contant.html, products.html etc
  * routed through index.html via internal routing
  * whole site downloaded at once, then accessed via the browser cache
  * only new data is fetched from the server
* Angular.js is:
  * MVC framework for building JS SPAs
  * include one .js file, add directive to your HTML and you're done
  * includes:
    * D.I.
    * routing
    * 2-way data binding
    * and much more...
* Getting Started
  * [angularjs.org](angularjs.org) (and click download)
  * can get from [NPM](https://www.npmjs.com/) and [bower](http://bower.io/search/?q=angular) too
  * <code>&lt;script src-"angular.js"&gt;&lt;/script&gt;</code>
  * <code>html ng-app</code> attribute
* What is [MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)?
  * Model View Controller
  * Design Pattern
  * Splits your app into three logical sections
    * Model - data and related logic
    * View - the visible / viewable aspects
    * Controller - determines what happens next in the app. May include business logic too.

* Getting data via AJAX
  * Could get data from anywhere (Angular doesnt care)
  * <code>$http.get('todo.json').success(function (data) { // do something })</code>
* <code>$scope</code>
  * used to persist data for the view (the data bus between the model and the view)
  * think of it as the <code>RC</code> scope in ContentBox or FW/1
* Custom Directives
  * custom tags written in Angular JS
    * <code>&lt;my-custom-widget&gt;</code>
  * works like regular HTML tags
  * Similar to Polymer
* Very brief overview on basic Angular.js features (above)
* [Ionic](ionicframework.com) overview
  * mobile specific
  * Cordova / Phonegap bridge using Angular.js
  * Built on Angular's directives and services
  provides powerful U.I. for mobile layouts as well as Angular data management and Cordova CLI integration.
  * Performance 'obsessed'
    * minimal DOM manipulation
    * removed 300ms tap delay
  * Need node.js, Ionic packages and Cordova packages
  * If building locally you need SDKs installed and in place (or use [PhoneGap Build](https://build.phonegap.com/))
  * Getting started
    * [Ionic documentation](http://ionicframework.com/docs/)
    * <code>ionic start application-name</code>
    * <code>ionic start application-name [optional default theme]</code>
    * Generates all files needed to start an app (skeleton framework)
    * <code>ionic serve --lab</code> loads up the project into a Chrome emulator that provides auto-reloading after file change
  * <code>ion-*</code> tags
    * Angular directives under the hood
* Need to install SDKs for each platform (iOS, Android etc)
  * Takes a little more time
  * Android isnt super intuitive (it can be a PITA <- monkeh note)

Check out the [http://ionicframework.com/](http://ionicframework.com/) and [https://angularjs.org/](https://angularjs.org/)




---

### Winning with Vagrant, Puppet and Chef

Presented by Matt Gifford

---

### Killing Shark-Riding Dinosaurs with ORM

Presented by Joel Watson

* Shark-riding dinosaurs
  * are fed on bad (or no planning)
  * are attracted to the smell of code patches used to hold together a failed data model
  * are hard to kill because they are armed to the teeth and have self-destruct mechanisms
  * they are usually bigger than you

* Top Ten tips for ORM sanity:
  1. OO Modeling is key
    * ORM relationship modeling is key
    * OO is required
    * UML is your best friend
    * STOP THINKING ABOUT DATA
    * YOU ARE NOT MODELING A DATABASE
  2. Engine defaults are not great
    * Dont use CF engine defaults such as:
      * FlushAtRequestEnd (send to database)
      * Session management (transactions)
      * Caching
  3. Understand Hibernate Session
    * Similar name, but not the same as session scope
    * A transitory space
    * A caching layer
    * You need to be the one controlling when stuff gets sent to the database
    * Secondary caching...
  4. Transaction Demarcation
    * Transactions demarcate SQL boundaries
    * Important for ORM and SQL
    * Pretty much ZERO communication to DB should happen without it
  5. Lazy Loading is the key
    * Try your app without it and watch the fail
    * Do you have performance? Don't use lazy loading
    * Types of laziness:
      * **true** = only when you ask for stuff
      * **extra** = load proxy objects with primary keys
      * **proxy** = load a proxy object
    * <code>fetch=join</code> for single query performance win
    * batchsize: kind of like pagination to keep the size down
  6. Avoid bi-directional
    * use with caution, and only if you know what you're getting into
    * can cause serious headaches for complex relationships and scenarios
    * only use it if you need it
    * if you DO need it, provide some support for handling bi-directional linkage and unlinkage
  7. Don't store entities in scopes!
    * if relationships aren't lazy they will fail
    * Hibernate session doesnt know about your scope (nor does it care)
    * if you _have_ to put something from your entity in scope, use it's id and then load it faster
  8. Index like a boss
    * Failing to index is easily the #1 performance problem
  9. Caching is your friend
    * Don't cache EVERYTHING, develop a strategy instead
    * Use distribute caching for bonus points:
      * ehcache, couchbase etc
  10. OO Modeling is KEY
    * SO important it needs to be mentioned twice.

* Available ORM options for ColdBox applications: <code>box install cborm</code>
* Base ORM service
  * Service layer for any entity
  * OO querying, caching, transactions
  * Dynamic finders, getters, counters
  * Object metadata & session management
  * Exposes more features from Hibernate
* Virtual / Concrete ORM Services
  * Extends Base ORM Services
  * Roots itself to a single entity (less typing)

* Active Entity
  * Active record pattern
  * Validation integration
  * DI is available

* Base ORM Service comes with:
  * entity population via XML, JSON, queries, structs
  * compose relationships from simple value
  * <code>Null</code> support
  * exclude/include fields
  * server-side validation

* Criteria Builder
  * CF ORM only gets you so far
  * <code>entityLoad()</code> has limited features
  * default result set is ALL the entities (much slower)
  * complex relationships are HARD to query
  * you still build SQL/HQL strings by hand? Use the Criteria Builder.
  * Criteria Builder..
    * is a programmatic DSL builder
    * has a super-rich set of criteria
    * includes a SQL inspector that can tell you what the generated SQL statement will look like



---

### Migrating legacy applications to ColdBox MVC


Presented by Scott Caldwell

* If a view file exists, it can be called without a handler
* handler / event are implicitly created
* view doesnt need to know anything about ColdBox
* Drop existing application into the views directory and it would* run (*slight modifications may be necessary)

#### Must-Dos

**Making URLs compatible (index.cfm)**
  * Change from <code>/user/account.cfm</code> to <code>/index.cm/user/account</code>
  * NOTE .cfm extensions is no longer necessary but is permitted
  * enable SES URL setting in ColdBox; possibly use web server rewrite rules too

**Deal with Application.cfc/cfm from your legacy application**
  * ColdBox is now the application
  * Settings, environment variables and other magic must find a new home
    * use ColdBox settings and environments
  * Datasources, mappings etc can be moved to ColdBox's <code>Application.cfc</code>

**Routing**
  * ColdBox auto-generates (implicitly dispatches) handlers and routes for most cases
  * You will need custom routes for 2+ deep directories
    * <code>addroute(pattern="/ajax/tags/:action", handler="ajax/tags");</code>
  * use CLI tools to get a list for you (don't miss any)

**cfincludes, createObjects etc.. paths will need to change**
  * prepend all <code>cfinclude</code> templates values with <code>/views/</code>
  * same with objects: <code>myObj = createObject('component', 'views.cfc.myObject');</code>

#### Should-Dos

**CFC invocation**
  * <code>createObject()</code>should change to <code>getModel()</code>
  * Use WireBox inside of model objects
  * Consider how to handle the <code>init()</code> call, if applicable
    * Use WireBox

**Move settings and environmental settings to ColdBox.cfc**
  * ColdBox has great settings and environment management. Use them.
  * Switch <code>application.mySetting()</code> to <code>getSetting('mySetting')</code>


**Utilize Layouts**
  * Assign layouts to views in <code>ColdBox.cfc</code>
    * empty layout
  * control multiple layouts via <code>ColdBox.cfc</code>
  * Special cases:
    * blank layout for ajax responses


#### Could-Dos

* **Move static assets to <code>/includes</code> directory**
* **Move CFCs to <code>/models</code>**
* **Utilize Security interceptor**
* **Configure WireBox for models**
* **Use <code>RC</code> scope instead of <code>form</code> / <code>url</code>**

#### Going Forward

* New development can be 'ColdBoxy'
* Refactor legacy code to be MVC using models, handlers and views
* Tighter integration with ColdBox offerings (eg LogBox, ForgeBox items, etc)


#### Finally...

* Lay as much groundwork as you can, but get it out of the door
* Learn regex. Will help you with search and replace actions
* Use a build process, don't just rely on source control
  * It won't be as simple as a merge as you will have moved A LOT of files and made a lot of changes
  * It depends how long you think the refactor process will take



---

### Package Management and Automation with CommandBox

Presented by Brad Wood

http://ortus.gitbooks.io

Lots of demos of package management installing from ForgeBox through the CLI.

Get books from link above :)


---

### Powering AngularJS With RESTFul services

Presented by Curt Gratz and Nathaniel Francis
