docker-dev-cloud9
=================

A Docker developering container with preinstalled Cloud9 IDE and Docker aliases, and out-of-the-box: Meteor/mrt, Nodejs & Ruby/Rails all preinstalled.
Setup uses an Ubuntu 14.04 (Trusty) base image and also installs Docker so you can relax and install docker containers from within Cloud9, 
fill them with your apps and push them to ypur other production server later. 

Fyi, the cloud9 container runs on port 3131, extra exposed ports are 3000,4000 and 5000, free for anything to run.
You can add any extra ports by trailing the ```dcset``` command described beneath with -p <PORT>:<PORT> (if needed multiple times; eg -p x:x -p y:y ).

Many thanks to Ajax.org for making this great JS IDE, Cloud9 is great.

(PS> for quick addins for the Docker file trail the install command with what you want to add)

Pre-requisites:
----
  - Docker  - see [docker]
  - wget/curl
  - a linux-box/vm/cygwin
  - a mongodb database (for meteor), f.e. [mongohq.com](http://mongohq.com)
 
Installation script:
----
```js
git clone https://github.com/rvmn/docker-dev-cloud9/
cd dock*
docker build -t cloud9 .
docker run -it -d --privileged -p 8181:8181 -p 5901:5901 -p 3200:3200 -p 3000:3000 -p 4000:4000 -p 5000:5000 -v /root/:/workspace/ cloud9
wget https://raw.githubusercontent.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh 
```
OR
```js
curl https://raw.githubusercontent.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh && ./install.sh 
```
In order for meteor to work copy paste the mongo-url to your database after the previous command.

After installation
------
Set the server creds using a newly created ``` dcset ``` alias, giving at least a username and pw: ``` dcset <user> <pass> ```. You can also
use env variable to set fe mongoDB like ``` dcset <user> <pass> -e MONGO_URL=<mongo-url>```.
Run the server with ``` dcrun ``` and if needed close using ``` dst ``` (closes last run docker), . Use ``` dhelp ``` to see all docker aliases. 
Open C9 IDE by going to your server-ip:3131, and refresh the page after first time loading it.
Enjoy and create nice stuff!

Read QuickStart.md for more info, update meteor using ``` meteor update ```

Postinstall script are not needed anymore, meteor and rails are now installed during build! 

Start a new meteor app:

```meteor create appname```
	
a meteor boilerplate app (jade,stylus,coffeescript,msx ): 

```/metbp.sh meteor-apps/appname```				

A new rails app:

```rails new appname```					
											        
A new node app:									    
```												      
npm install express -g							     
express new appname				     				
```													  
or read the QuickStart.md for more info				   
P.S In case of a partial install just download the install script again, docker will continue
where it left.

Credits:
----
Ajax.org and Docker for their awesome work!

Nitrous-io/jpetazzi - [dind]

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
