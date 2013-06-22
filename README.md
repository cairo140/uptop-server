uptop-server
============

A server to find people to high five. Send a request with your latitude and longitude, and we'll tell you if there's someone nearby to high five. If there is, raise you hand and start looking around!

Usage
-----

Send a GET request with latitude and longitude coordinates:

    GET http://uptop.herokuapp.com/v1/uptop?latitude=38.4495&longitude=-78.8715

In any case, the server will respond with a JSON object that has an object as the `body` attribute.

If there is someone to high five, the server will respond with something like this:

    {"status":"success","body":{"uptop":true}}

If there is nobody to high five, the server will respond with something like this:

    {"status":"not_found","body":{"uptop":false}}

Development
-----------

Dependencies: [nodejs](http://nodejs.org/), [npm](https://npmjs.org/)

Install dependencies and start up the server

    npm install
    ./node_modules/.bin/coffee server.coffee

You can send requests manually with cURL. For example:

    curl "http://localhost:5000/v1/uptop?latitude=38.4495&longitude=-78.8715"

You may have to open up multiple terminals to have requests sent concurrently.
