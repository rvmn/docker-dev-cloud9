docker-dev-cloud9 (updated, 2021 version)
=================

A Docker Live development container with pre-installed Cloud9 IDE with Docker, and out-of-the-box preinstalled: PHP7.4 (composer), Nodejs (nvm), Python3.
Setup uses an Ubuntu 18.04 (Xenial) base image and also installs Docker in Docker so you can relax and install docker containers from within Cloud9, 
fill them with your apps and push them to your other production server later. 

Opened ports are 3000-5000, free for anything to run.
You can add any extra ports by trailing the ```dcrun``` command described beneath with -p <PORT>:<PORT> (if needed multiple ports; eg -p x:x -p y:y ).

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
Run the server with ``` dcrun ```, later if needed close using ``` dst ``` (closes last run docker container). 
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
echo "command to run" | bash -l			     				
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
