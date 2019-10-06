---
layout: post
title: HTML5 Giveaway Winners
slug: html5-giveaway-winners
date: 2010-10-18
categories:
- Development
tags:
- Books
- monkehTime
status: publish
type: post
published: true
---
<p>Last week, I held a competition for four lucky people to win a copy of the awesome book "Introducing HTML5".</p>
<p>I have to say that the response was phenomenal, and my Twitter mention column was getting a beating with replies and posts from everyone entering the competition. A massive thank you to everyone who did enter.</p>
<p>The results were drawn this morning, completely randomly from the list of all entrants using the #HTML5Giveaway hashtag, and you can see the results in the video below.</p>
<p>To make things a little more fun, the results were obtained by storing all entries into a local web SQL database and selecting the winners using a randomly generated number (based upon the current number of records within the database)..</p>
<p>yup, if you're going to hold a competition giving away an HTML5 book, the results SHOULD be drawn using some fancy HTML5 goodness (or that's my opinion at least) :)</p>
<p>[hdplay id=5 ]</p>
<p>So, a massive congratulations to the winners of the competition. I'll hit you all up on Twitter to get your details to send the books to you.</p>
<p>Here is the script used to create the database, populate the table with the original entrants, and randomly generate (and display) the winners.</p>
<pre name="code" class="xml">
&lt;button value="Get Winner!"
		onclick="getWinner()"&gt;Get Winner!&lt;/button&gt;

&lt;div id="winner"&gt;&lt;/div&gt;

&lt;h2&gt;And the winners are...&lt;/h2&gt;
&lt;ul id="winnerList"&gt;&lt;/ul&gt;

&lt;div id="errorContent"&gt;&lt;/div&gt;

&lt;script&gt;
var db;
var totalRecords;

/*
 * Run onclick of the button, this function will generate
 * a random number and using that integer will select a record
 * from the entrants table (our winner.. good times).
 *
 * We'll save that person into the winner table, display on the
 * screen to inform them of their victory, and then pass
 * the row ID to be deleted (to avoid a duplicate win)
 */
function getWinner() {
	getCurrentTotal();
	var randomTweet = Math.floor(Math.random()*totalRecords);

	db.transaction(function (tx) {
		tx.executeSql('SELECT * FROM entries WHERE (id = ?)',
						[randomTweet], function (tx, results) {
			for (var i = 0; i &lt; results.rows.length; i++) {
				var row = results.rows.item(i);
				console.log("Winner[" + row.id + "] = "
					+ row.screen_name);

				// Store the winners
				tx.executeSql('INSERT INTO winners ' +
					'(tweetid, screen_name, text) VALUES (?, ?, ?)',
					[row.id, row.screen_name, row.text]);

				newWinner = '&lt;h1&gt;@'+ row.screen_name + '&lt;/h1&gt;&lt;strong&gt;' +
				'Congratulations, you are a winner!&lt;/strong&gt;';

				document.getElementById('winner').innerHTML = newWinner;

				// Delete this winner from the entries table,
				// to avoid them being selected again
				deleteByID(randomTweet);
			}
		});
	})
	// Display the winners in the list
	showWinnerList();
}

/* Delete the selected record from the entries table,
 * as that person has won.
 * We do this to remove the possibility of picking them again.
 */
function deleteByID(winnerID) {
	db.transaction(function (tx) {
		tx.executeSql('DELETE FROM entries WHERE (id = ?)',
			[winnerID], function (tx, results) {
		});
	})
}

/* Make the call to the Twitter search API
 * to obtain the search matches
 * */
function getTweets(page) {
  var script = document.createElement('script');
  script.src = 'http://search.twitter.com/search.json?rpp=100&page=' +
  					page + '&q=HTML5Giveaway&callback=saveTweets';
  document.body.appendChild(script);
}

/* The Twitter API callback function.
 * Once the data has been returned, we'll loop over each record
 * and insert it into the entries database table
 * to populate our competition entrants
 */
function saveTweets(tweets) {
  tweets.results.forEach(function (tweet) {
    db.transaction(function (tx) {
      var time = (new Date(Date.parse(tweet.created_at))).getTime();
      tx.executeSql('INSERT INTO entries '+
	  	'(tweetid, screen_name, date, text) ' +
	  	'VALUES (?, ?, ?, ?)',
		[tweet.id, tweet.from_user, time / 1000, tweet.text]);
	});  

  });
}

/* We'll use this function to obtain the current number
 * of records within the entries table, which will be used
 * when creating our random number to select our winners
 */
function getCurrentTotal() {
	db.transaction(function (tx) {
	    tx.executeSql('SELECT * FROM entries',
			[],
			function (tx, results) {
			totalRecords = results.rows.length;
			console.log("There are currently " + totalRecords +
						" entrants left");
		});
	});
}

function setupDatabase() {
	/* Prepare the return message to any users
	 * with an non-supported (crap) browser
	 */
	if (!window.openDatabase) {
	document.getElementById('errorContent').innerHTML =
			'&lt;p&gt;The Web SQL Database API is not available in this browser.' +
			'Get a better browser. One that, ya know... works.&lt;/p&gt;';
	return;
	}

  	// Create the database and run the transactions to build the tables.
	db = openDatabase('HTML5Giveaway_SQLAPI_',
						'1.0',
						'db of tweets',
						2 * 1024 * 1024);

	db.transaction(function (tx) {

	// Create the table for all of our returned tweets to be added to.
	tx.executeSql('CREATE TABLE entries (id INTEGER NOT NULL '+
					'PRIMARY KEY AUTOINCREMENT,'+
					' tweetid unique, screen_name, date integer, text)');

	// Create the winners table. Victory for all who end up here
	tx.executeSql('CREATE TABLE winners (id INTEGER NOT NULL '+
					'PRIMARY KEY AUTOINCREMENT, '+
					' tweetid unique, screen_name, text)');
	});
	// Run a quick loop to ensure we have ALL of the entries to select from
	for (var i = 1; i &lt; 6; i++) {
		getTweets(i);
	}
}

// This function reads from the winners table, and outputs
// all rows into the ul list so we can see who has won!
function showWinnerList() {
	db.transaction(function (tx) {
		tx.executeSql('SELECT * FROM winners', [], function (tx, results) {
			var html = []
			for (var i=0; i &lt; results.rows.length; i++) {
				html.push('&lt;li&gt;@' + results.rows.item(i).screen_name + '&lt;/li&gt;');
			}
			// Assign the created list items to the winnerList ul element
			document.getElementById('winnerList').innerHTML = html.join('');
		});
	})
}

// Run the initial call to set up the database
setupDatabase();
&lt;/script&gt;
</pre>
