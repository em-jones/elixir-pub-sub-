# PubSubUmrella

This is the umbrella application for the various modules supporting this pub/sub queue management system

## Functionality
Currently limited to running an http server on port 8000 (set in web_server/application.ex) and receiving GET requests
that should print "Implementation 1: [message]" when accessed at localhost:8000/publish/[message]

## /apps

### /store
Implementation 1 - using standard Elixir Task library abstractions for async support

### /queue_server
Implementation 1 - using standard Elixir Task library abstractions for async support

### /web_server
Implementation agnostic - simple plug_cowboy http server for sending messages to our queue management system



