docker-dev-cloud9
=================

A Docker developering container with preinstalled Cloud9 IDE and Docker aliases, and out-of-the-box: Meteor/mrt, Nodejs & Ruby all preinstalled.
Setup uses an Ubuntu 14.04 (Trusty) base image and also installs Docker so you can relax and install docker containers from within Cloud9, 
fill them with your apps and push them to ypur other production server later. 

It works but is not tested extensively, rails runs into problems. Docker works great. When it is fixed I can't promise.
Many thanks to Ajax.org for making this great JS IDE, Cloud9 is a fantastic IDE.

Pre-requisites:
----
  - Docker  - see [docker]
  - wget/curl
  - a linux-box/vm/cygwin
 
Installation script:
----
```js
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh
```
OR
```js
curl https://rawgit.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh
```

After installation
------
Set the server creds using a newly created ``` dset ``` alias, giving at least a username and pw: ``` dset <user> <pass> ```. Better also
use env variable to set mongoDB like ``` dset <user> <pass> MONGO_URL=<mongo-url>```, you can get free service at fe. [mongohq.com](http://mongohq.com).
Then run the server with ``` drun ``` and if needed close using ``` dst ``` (closes last run docker). Use ``` dhelp ``` to see all docker aliases. 
Open C9 IDE by going to your server-ip:3000, and refresh the page after first time loading it.
Enjoy and create nice stuff!

Read QuickStart.md for more info

Postinstall script are not needed anymore, meteor and rails are now installed during build! 
```js											 	 ___
						                            ( | )/_/
												 __( >O< )
Start a new meteor app:							 \_\(_|_) recursive  
meteor create appname								 					
															_,-._	 
a meteor boilerplate app (jade,stylus,coffeescript,msx ):  / \_/ \
														   >-(_)-<    
/metbp.sh meteor-apps/appname							   \_/ \_/
														     `-'
																						
																						
A new rails app:																						
rails new appname																					
																							
												         _ _
A new node app:									       _{ ' }_
												      { `.!.` }
npm install express -g							      ',_/Y\_,'
express new appname				     				    {_,_}
												          |
													    (\|  /)
or read the QuickStart.md for more info				     \| //
													   	  |//
													   \\ |/  //
												 ^^^^^^^^^^^^^^^```
P.S In case of a partial install just download the install script again, docker will continue
where it left.

Credits:
----
Ajax.org and Docker for their awesome work!

Nitrous-io/jpetazzi - [ubuntu-dind]

gai00  - [docker-cloud9]

Cloud9 - [c9]

Docker - [docker]

Dean-Shi - [meteor-bp]

And a lot of enthusiast developers sharing their 

License
----

MIT

[dind]:https://github.com/nitrous-io/ubuntu-dind
[docker-cloud9]:https://github.com/gai00/docker-cloud9
[mongohq]:https://www.mongohq.com/
[c9]:http://cloud9.io
[docker]:http://docker.io
[meteor-bp]:https://github.com/Dean-Shi/Meteor-Boilerplate.git