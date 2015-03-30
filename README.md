# Record and Play Back your API

This records API responses so you can play them back later, quickly and reliably.

If you're a front-end developer this means you can develop without an API server--even without the internet.

You can also write tests for front end components that have some API dependencies but shouldn't break if the API server has hiccups.

It's good for:

* Testing (The responses are always the same, and fast)
* Nomads (Work on JS apps without internet)
* Unstable APIs (the VCR smooths out API downtimes)
* Throttled APIs (don't get shut down for querying too much while developing)
* Dev teams that push back end changes frequently which require 30 minutes of API downtime to rebuild and deploy (ahem).

This is similar to [some](https://github.com/vcr/vcr) [other](http://www.mock-server.com/) [projects](https://github.com/assaf/node-replay). Other projects might be better for your needs. Some things make this different:
* Other solutions are focused on testing. That's great and valid, but I want to develop against something fast, deterministic, and reliable, too.
* This is written in Node, so it's easy to fit in with a front end developer's workflow.
* I store the responses as plain text JSON files so you can modify them whenever you want, and see very clearly where I create bugs or mismatch your expectations on API paths.
* You can fake out your own API by making a tree of `json` files. No recording necessary. That could be pretty useful, huh?
* Supports multiple API servers. You just run multiple instances and it stores data in a folder tree by hostname and port.


## Seeding data

Data is all in the local `data` folder. This is configurable, so you can store your data files with your project.

It uses folders to determine the api path it should respond to. If you'd like the server to respond to `users/1`, create this file in the repo:

    data/users/1.json


## Running

The first thing you probably want to do is run in record mode, which proxies requests to your API server and records the responses for later playback.

Run in record mode:

    node start.js --api=http://api.magicalsailboat.com:8080 --record

If you already have a good data set, either from manual creation or recording, you don't need to proxy requests to the api server or record any new reponses.

Run in offline playback mode:

    node start.js --api=http://api.magicalsailboat.com:8080


## Options

You can specify a port. This is useful for running more than once instance. The port of the API server is used by default, this keeping proxies straight a little easier if you have remote APIs identified by port.

Set the port:

    node start.js --port=1337

By default, data is stored locally in this project. You probably want to change where the data files are stored--maybe keep them in your own project.

Set the data path:

    node start.js --data=~/sites/myApp/testData

By default the vcr looks for a sibling if it can't find a requested object. If you ask for `user/7`, for example, it will return `user/42` if it has one.
This is awesome if you just want to keep working and it doesn't matter too much that it's the wrong user/product/sprocket/whatever.

Not everyone wants this behavior though. To turn it off:

    node start.js --noSiblings


## TODO

- [x] Start the app a `record` option
- [x] Logs all requests to console
- [x] Pass requests on to the recorded server
- [x] Create a directory structure that matches requests (namespace by server and port to support multiple APIs)
- [x] Store request responses as JSON files
- [ ] Have a simple index page with list of all routes we know about, for easy debugging/transparency
- [ ] Support query params
- [x] Support missing components intelligently (eg: if you have `surfboard/3` and they request `5`, return a sibling)
- [ ] Support response types other than JSON gracefully
- [ ] Support POST, PUT, DELETE (at least don't error, and return a sensible object)