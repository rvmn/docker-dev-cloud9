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
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod+x install.sh && ./install.sh
```
OR
```sh
curl https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod+x install.sh && ./install.sh
```
Optionally after previous commands add either:
```sh
<port> 
<user> <pass>
<user> <pass> <port>

f.e. ./install.sh 80 or ./install.sh myname mypass 80
```

default port = 3131

Credits go to:
----
Nitrous-io - [ubuntu-dind]
gai00  - [docker-cloud9]

License
----

MIT

[ubuntu-dind]:https://github.com/nitrous-io/ubuntu-dind
[docker-cloud9]:https://github.com/gai00/docker-cloud9
[docker]:https://www.docker.com/
