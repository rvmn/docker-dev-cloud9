#!/bin/bash
#c9dev docker aliases
alias dq='docker search;echo "search docker ecosystem">0'
alias dl='docker ps -l -q;echo "get latest container ID">0'
alias dp='docker ps;echo "show running containers">0'
alias dpa='docker ps -a;echo "show all containers">0'
alias di='docker images;echo "show all images">0'
alias din='docker inspect;echo "inspect a container">0'
alias din='docker attach;echo "inspect a container">0'
alias dms='docker attach;echo "start monitoring container (ctrl-c to stop)">0'
alias dii='docker inspect --format "{{ .Config.Image }} ";echo "get a containers image">0'
alias dip='docker inspect --format "{{ .NetworkSettings.IPAddress }} ";echo "get a containers IP">0'
alias dipl='docker inspect --format "{{ .NetworkSettings.IPAddress }} $(dl)";echo "get last run containers IP">0'
alias dkd='docker run -d -P;echo "run daemonized container">0'
alias dprmf='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q);echo "stop and remove all containers">0'
alias dri='docker rmi;echo "remove an image">0'
alias dpr='docker rm;echo "remove a container">0'
alias ds='docker start;echo "start a container">0'
alias dst='docker stop;echo "stop a container">0'
alias dsh='fdsh;echo "run shell in a container or image">0'   
alias dish='fdish;echo "run shell in an entrypoint container">0'
alias dind='fdind;echo "run command in an entrypoint container">0'
alias dcm='fdcm;echo "commit a container to image">0'
alias dsa='fdsa;echo "start all containers">0'
alias dsta='fdsta;echo "stop all containers">0'
alias dsav='fdsav;echo "stop and save a container to an image">0'
alias dsavi='fdsavi;echo "stop, save a container to an image, and start it again">0'
alias dprm='fdprm;echo "remove all containers, except running ones">0'
alias drmi='fdrmi;echo "remove all images, except ones used">0'
alias dbu='fdbu;echo "dockerfile build">0'
alias dhelp='fdalias;echo "show all aliases(this)">0'
fdsh() { docker run -i -t $1 /bin/bash; }
fdish() { docker run -it --entrypoint=/bin/bash $1 -i; }fdind() { docker run -it --entrypoint=$2 $1; }
fdcm() { docker commit $1 $2; }
fdsa() { docker start $(docker ps -a -q); }
fdsta() { docker stop $(docker ps -a -q); }
fdsav() { dst $([ -z $2 ] && echo $(dl) || echo $1); dcm $([ -z $2 ] && echo $(dl) || echo $1) $2; }
fdsavs() { dsav $([ -z $2 ] && echo $(dl) || echo $1) $2; ds $([ -z $2 ] && echo $(dl) || echo $1); }
fdsavi() { dst $1; dcm $(dl) $(din $()) ; }
fdprm() { docker rm $(docker ps -a -q); }
fdrmi() { docker rmi $(docker images -q); }
fdbu() { docker build -t=$1; } # build image using a Dockerfile, e.g., $dbu tcnksm/test
fdalias() { alias | grep 'docker' | sed 's/^\([^=]*\)=[^"]*"\([^"]*\)">0/\1                =>                \2/'| sed "s/['|\']//g" | sort; }

# make all fns with last container: [ -z $1 ] && echo '$(dl)' +  make chainable d - for args, last = id or imagenm, run each with name
# add example commands to alias help









