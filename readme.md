# Collaborative markdown editor

the far goal of this project is to make a web app which allows
collaborative editing like in an etherpad with the option to render
markdown live.

## How

probably with the following approach

- websocket for the communication between server and clients
- redis as data backend with pub/subscribe for the clients to a pad
- only diffs of the text will be send between server and client

## Problems / ToDos

- somehow the diffs will be merged and saved to limit da nessecary data
  send
- perhaps some kind of detection on the client if the server is still
  reachable
- ^^ for the server too ( some kind of hardbeat which can be monitored )
- detect broken connection and attempt reconnect


# Who

[Andreas Eger](http://sch1zo.github.com) / [@sch1zo](http://www.twitter.com/sch1zo)
