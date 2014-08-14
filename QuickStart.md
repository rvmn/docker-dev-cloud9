#Cloud9 Setup
-----
Under View you can pick a theme, set syntax highlighting and much more.

Base shortcuts: alt-z opens Zen-mode, alt-space does autocomplete, 

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
dish    =   run shell in a subcontainer, e.g., dsh tcnksm/test 
dind    =   run docker command inside a dind-container, e.g., dind tcnksm/test 
dcm     =   commit a container to an image, e.g., dcm some-cont-id tcnksm/test 
dstart  =   start a container, e.g. dstart name/contnr
dstop   =   stop all containers
drm     =   remove all containers, except running ones!
drmrf   =   stop and remove all containers
dri     =   remove all images, except of running containers!
dalias  =   show all aliases
drun    =   run this server
druns   =   run server with options
```
#Boilerplates
-------
##Meteor
Meteor and meteorite (it's package manager) come preinstalled.
To start a meteor boilerplate run:
```sh
/metbp.sh myapp
```
or a default meteor app:
```sh
meteor create myapp
```

##Ruby on Rails
Install Ruby 2.1.2 and rails using:
```sh
/rails-install.sh
```
Start a project with:
```sh
rails new myapp
```


TODO:
- emmet custom snippet plugin - https://github.com/sergeche/emmet-sublime
- make nicer intro (autostart html)
- mithril integration and jade-mithril plugin