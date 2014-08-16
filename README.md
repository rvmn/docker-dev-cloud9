docker-dev-cloud9
=================

Docker Developer container with preinstalled Cloud9 IDE with Docker tools, Meteor, Nodejs & Ruby and all necessities preinstalled.
It uses the installation directory where you run the installscript as default storage volume. It is installs an Ubuntu 14.04 base image and
also installs Docker so you can relax and install docker containers from within Cloud9, fill them with your apps. Or push them to another container,
the production container.  

Pre-requisites:
----
  - Docker  - see [docker]
  - wget/curl
  - a linux-box/vm/cygwin
  - an install directory for your developing creations, name it nice, like boulder-builder, flower: 
```sh
wd='workspace' && mkdir $wd && cd $wd
``` OR
```sh
mc(){ mkdir $1 && cd $1 } && mc workspace
```
Install:
----
```js
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh
```
OR
```js
curl https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh
```
Optionally, recommended for sure, after previous command copy-paste add either:
```html
<user> <pass>
<user> <pass> <port>                                                    
<port> 

```
Otherwise defaults will be used:
- default port = 1337,3000
- default user = c9dev
- default pass = pass


After installation
------
Run the server using the newly created ``` drun ``` command, and try dalias to see the docker aliases. Start C9 IDE by going to your server-ip:port.
If you need to run the server using different settings, do:
```js
druns user pass port (all needed)
```
And you may want to refresh the page upon first load, this fixes the session problem and loads the files.
Then you can start a new meteor app:
```js																				___
meteor create appname                                                              ( | )/_/
																			    __( >O< )
alternatively a meteor boilerplate app (jade,stylus,coffeescript,msx/jsx): 		\_\(_|_) recursive  
/metbp.sh appname																	 |					
																	 	    _,-._	 
A new rails app after rails setup finalization (not working yet):		   / \_/ \
/rails-install.sh														   >-(_)-<    
rails new appname														   \_/ \_/
																		     `-'
A new node app:																						
																						
npm install express -g																						
express new appname																						
																						
												         _ _
												       _{ ' }_
												      { `.!.` }
												      ',_/Y\_,'
			     									    {_,_}
												          |
													    (\|  /)
or read the QuickStart.md for more info				     \| //
													   	  |//
													   \\ |/  //
												 ^^^^^^^^^^^^^^^```
P.S In case of a partial install just restart the whole thing and download the install script again, docker will continue
where it left.

Credits:
----
Nitrous-io - [ubuntu-dind]

gai00  - [docker-cloud9]

Cloud9 - [c9]

Docker - [docker]

Dean-Shi - [meteor-bp]

And a lot of enthusiast builders

License
----

MIT

[ubuntu-dind]:https://github.com/nitrous-io/ubuntu-dind
[docker-cloud9]:https://github.com/gai00/docker-cloud9
[mongohq]:https://www.mongohq.com/
[c9]:http://cloud9.io
[docker]:http://docker.io
[meteor-bp]:https://github.com/Dean-Shi/Meteor-Boilerplate.git