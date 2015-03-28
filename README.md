# API VCR

The goal is to record a server's api responses so you can play them back later.

It stores the responses as plain text JSON files so you can modify them whenever you want.

You can fake out an API just by making a tree of `json` files. That could be pretty useful, huh?


## Seeding data

It can't record content yet, so seed the data yourself.

It's all in the `data` folder.

It uses folders to determine the api path it should respond to. If you'd like the server to respond to `users/1`, create this file in the repo:

    data/users/1.json

## Running

If you'd like to run in live record mode, which proxies requests to your API server and records the responses for later playback, run this command:

    node record.js http://api.magicalsailboat.com

If you'd like to run in offline playback mode, which serves up prerecorded data, run this command:

    node serve.js

## TODO

- [x] Start the app a `record` option
- [x] Logs all requests to console
- [.] Pass requests on to the recorded server (Tricky. Lots of protocol, method, and port cases. get this to work)
- [ ] Store requests (use a separate storage module so the mechanism can change between file and nosql in future)
- [ ] Support multiple servers. Namespace data store by server+port name
- [ ] Have a simple index page with list of all routes we know about, for easy debugging/transparency
- [ ] Support query params
- [ ] Support missing components intelligently (eg: if you have `surfboard/3` and they request `5`, return the closest match)

