docker-dev-cloud9
=================

A Docker Live development container with pre-installed Cloud9 IDE with Docker, and out-of-the-box support for: Ruby, Meteor, Nodejs, Python, Java/Maven.
Setup uses an Ubuntu 14.04 (Trusty) base image and also installs Docker so you can relax and install docker containers from within Cloud9, 
fill them with your apps and push them to your other production server later. 

Opened ports are 3000,4000 and 5000, free for anything to run.
You can add any extra ports by trailing the ```dcset``` command described beneath with -p <PORT>:<PORT> (if needed multiple times; eg -p x:x -p y:y ).

Many thanks to Ajax.org for making this great JS IDE, Cloud9 is great.

(PS> for quick addins for the Docker file trail the install command with what you want to add)

Pre-requisites:
----
  A box with: 
  - Docker  - see [docker]
  - wget/curl
  - an online mongodb database (for meteor), f.e. [mongohq.com](http://mongohq.com)
 
Installation script:
----
```js
wget https://raw.githubusercontent.com/rvmn/docker-dev-cloud9/master/install.sh && chmod +x install.sh
./install.sh <your-mongodb-url>
```

After installation
------
Set the server creds using a newly created ``` dcset ``` alias, open extra ports using ``` dcset -p 3050:3050 ```.
Run the server with ``` dcrun ``` and if needed close using ``` dst ``` (closes last run docker), . 
Use ``` dhelp ``` to see all docker shortcuts. 
Open Cloud9 IDE by going to your server-ip:8181, and refresh the page after first time loading it.
Enjoy and create nice stuff!

To install rails, open the cloud9 IDE and use:
```
gem install rails
```

Start a new meteor app:

```meteor create appname```

A new rails app:

```rails new appname```					
											        
To use root access:									    
```												      
/bin/bash -c "command to run"				     				
```													  


Credits:
----
Ajax.org and Docker for their awesome work!

jpetazzi - [dind]

gai00  - [docker-cloud9]

Docker - [docker]

License
----

MIT

[dind]:https://github.com/nitrous-io/ubuntu-dind
[docker-cloud9]:https://github.com/gai00/docker-cloud9
[mongohq]:https://www.mongohq.com/
[c9]:http://cloud9.io
[docker]:http://docker.io
