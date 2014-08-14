docker-dev-cloud9
=================

Docker-in-docker Developer install with preinstalled Cloud9 IDE container with Nodejs & Rails support

Pre-requisites:
----
  - Docker  - see [docker]
  - wget/curl
  - a linux-box/vm/cygwin

Install:
----
```sh
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh
```
OR
```sh
curl https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh
```
Optionally after previous commands add either:
```sh
<port> 
<user> <pass>
<user> <pass> <port>

f.e. ./install.sh 88 or ./install.sh usrname usrpass 88
```
Otherwise defaults will be used:
- default port = 3030
- default user = c9dev
- default pass = pass


After installation
------
Open C9 IDE by going to your servers-ip:port, you may want to refresh the page upon first load, this fixes the session.
Then you can start a new meteor app:
```sh
meteor create appname
```
alternatively a meteor boilerplate app (jade,stylus,coffeescript,msx/jsx):
```sh
metbp appname
```
A new rails app:
```sh
rails new appname
```
A new node app:
```sh
npm install express -g
express new appname
```
or read the QuickStart.md for more info

Credits go to:
----
Nitrous-io - [ubuntu-dind]
gai00  - [docker-cloud9]
Cloud9 - [c9]
Docker - [docker]
And a lot of enthusiast builders

License
----

MIT

[ubuntu-dind]:https://github.com/nitrous-io/ubuntu-dind
[docker-cloud9]:https://github.com/gai00/docker-cloud9
[mongohq]:https://www.mongohq.com/
[c9]:http://cloud9.io
[docker]:http://docker.io
