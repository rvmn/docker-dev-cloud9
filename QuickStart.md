#Cloud9 Setup
-----
Under View you can pick a theme, set syntax highlighting and much more.

Base shortcuts: alt-z opens Zen-mode, alt-space does autocomplete, 
in the complete right bottom the small button toggles the console up and down. 

Don't forget to run the Cloud installation script using:
``` /install-c9.sh ```
or run ``` /install-meteor.sh ``` or ``` install-rails.sh ``` seperately 

Extensions
------
To install extensions paste the URL into Tools > Extension Manager

Emmet support:    https://raw.github.com/rmariuzzo/cloud9-emmet-ext/master/cloud9-emmet-ext.js

Hitlist:          https://github.com/c9/hitlist

Scratchpad:       https://github.com/lennartcl/cloud9-scratchpad

Markdown preview: https://raw.github.com/brads-tools/c9ext-mdpreview/master/ext.mdpreview/mdpreview.js


Extension info:
-------
Emmet howto:
http://www.smashingmagazine.com/2013/03/26/goodbye-zen-coding-hello-emmet/

#Docker
-------
Shortcut list:
```sh
dl      =   get latest container ID
dc      =   get container process / show running containers
dca     =   show all containers
di      =   show all images
dip     =   get container IP
dipl    =   get last container's IP
dkd     =   run daemonized container, e.g., $dkd base /bin/echo hello
dki     =   run interactive container, e.g., $dki base /bin/bash
dsh     =   run shell in a container or image, e.g., dsh tcnksm/test 
dish    =   run shell in a dind-subcontainer, e.g., dsh tcnksm/test 
dind    =   run docker command inside a dind-subcontainer, e.g., dind tcnksm/test 
dcm     =   commit a container to an image, e.g., dcm some-cont-id tcnksm/test 
dstart  =   start a container, e.g. dstart name/contnr
dstop   =   stop all containers
drm     =   remove all containers, except running ones!
drmrf   =   stop and remove all containers
dri     =   remove all images, except of running containers!
dhelp   =   show all aliases
```
#Boilerplates
-------
##Meteor
For meteor apps you need to have a mongoDB database, you can create one
for free at f.e. [mongohq](http://mongohq.com), or get a docker container (docker search mongodb). Make a db and run:
``` export MONGO_URL=mongodb://<user>:<password>@kahana.mongohq.com:10007/<your-db-name> ```
and better yet run ``` dcset <user> <pass> MONGO_URL=<mongo-url> ``` from your host shell to rebuild the ```dcrun``` command
To start a meteor boilerplate run:
``` /metbp.sh myapp ```
or a default meteor app:
``` meteor create myapp ```
to install dependencies:
``` mrt install ```
to run:
``` meteor ```
or do both at the same time, simply:
``` mrt ```
##Ruby on Rails
```
Start a project with:
```sh
rails new myapp
```
install dependencies:
```sh
bundle
```
run server:
```sh
rails s
```



TODO:
- fix rails - done!
- make docker aliases work in c9 & install using non-root user
- emmet snippet adding plugin - https://github.com/sergeche/emmet-sublime
- mithril integration and jade-mithril plugin
- code-sharing plugin(s) (plunkr,mdn css,clker-scg,colourlovers)