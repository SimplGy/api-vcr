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

    node start.js --record=api.magicalsailboat.com

If you'd like to run in offline playback mode, which serves up prerecorded data, run this command:

    node start.js


## Options

To specify a port (useful for running more than once instance):

    node start.js --port=1337

By default, data is stored locally in this project. You probably want to change where the data files are stored--maybe keep them in your own project.

You can specify a data path like this:

    node start.js --data=~/sites/myApp/testData


## TODO

- [x] Start the app a `record` option
- [x] Logs all requests to console
- [x] Pass requests on to the recorded server
- [x] Create a directory structure that matches requests (namespace by server and port to support multiple APIs)
- [ ] Store request responses as JSON files

- [ ] Have a simple index page with list of all routes we know about, for easy debugging/transparency
- [ ] Support query params
- [ ] Support missing components intelligently (eg: if you have `surfboard/3` and they request `5`, return the closest match)


try this code:

    app.use('/api', function(req, res) {
      var url = 'http://my.domain.com/api' + req.url;
      req.pipe(request(url)).pipe(res);
    });
    // add req.end()


look at this code:

    var http = require('http');

    /* your app config here */

    app.post('/api/BLABLA', function(req, res) {

      var options = {
        // host to forward to
        host:   'www.google.com',
        // port to forward to
        port:   80,
        // path to forward to
        path:   '/api/BLABLA',
        // request method
        method: 'POST',
        // headers to send
        headers: req.headers
      };

      var creq = http.request(options, function(cres) {

        // set encoding
        cres.setEncoding('utf8');

        // wait for data
        cres.on('data', function(chunk){
          res.write(chunk);
        });

        cres.on('close', function(){
          // closed, let's end client request as well
          res.writeHead(cres.statusCode);
          res.end();
        });

        cres.on('end', function(){
          // finished, let's finish client request as well
          res.writeHead(cres.statusCode);
          res.end();
        });

      }).on('error', function(e) {
        // we got an error, return 500 error to client and log error
        console.log(e.message);
        res.writeHead(500);
        res.end();
      });

      creq.end();

    });
