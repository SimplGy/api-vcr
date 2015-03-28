# API VCR

The goal is to record a server's api responses so you can play them back later.

It stores the responses as plain text JSON files so you can modify them whenever you want.

You can fake out an API just by making a tree of `json` files. That could be pretty useful, huh?


## Seeding data

It can't record content yet, so seed the data yourself.

It's all in the `data` folder.

It uses folders to determine the api path it should respond to. If you'd like the server to respond to `users/1`, create this file in the repo:

    data/users/1.json

## Recording Data

To record data from an API server, start the app this way:

    node start.js --record=http://api.foo.com


## TODO

- [ ] Start the app with a `--record=http://api.foo.com` option
- [ ] Logs all requests to console
- [ ] Pass requests on to the recorded server
- [ ] Store requests (use a separate storage module so the mechanism can change between file and nosql in future)

- [ ] Just listen to all requests, and try to fetch data dynamically when a request comes in. Right now I'm building routes ahead of time (silly).
- [ ] Have a simple index page with list of all routes we know about, for easy debugging/transparency
- [ ] Record traffic and responses to an api server, and record them. How can node monitor http requests and responses on the system?
Can the app proxy traffic through it and record responses as it gets them?
- [ ] Support query params
- [ ] Support missing components intelligently (eg: if you have `surfboard/3` and they request `5`, return the closest match)

