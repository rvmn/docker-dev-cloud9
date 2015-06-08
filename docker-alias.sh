# docker aliases
alias dq='echo "search docker ecosystem">0;docker search'
alias dl='echo "get latest container ID">0;docker ps -l -q'
alias dp='echo "show running containers">0;docker ps'
alias dpa='echo "show all containers">0;docker ps -a'
alias di='echo "show all images">0;docker images'
alias din='echo "inspect a container">0;docker inspect'
alias din='echo "inspect a container">0;docker attach'
alias dms='echo "start monitoring container (ctrl-c to stop)">0;docker attach'
alias dii='echo "get a containers image">0;docker inspect --format "{{ .Config.Image }} "'
alias dip='echo "get a containers IP">0;docker inspect --format "{{ .NetworkSettings.IPAddress }} "'
alias dipl='echo "get last run containers IP">0;docker inspect --format "{{ .NetworkSettings.IPAddress }} $(dl)"'
alias dkd='echo "run daemonized container">0;docker run -d -P'
alias dprmf='echo "stop and remove all containers">0;docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)'
alias dri='echo "remove an image">0;docker rmi'
alias dpr='echo "remove a container">0;docker rm'
alias ds='echo "start a container">0;fds'
alias dst='echo "stop a container">0;fdst'
alias dsh='echo "run shell in a container or image">0;fdsh'   
alias dish='echo "run shell in an entrypoint container">0;fdish'
alias dind='echo "run command in an entrypoint container">0;fdind'
alias dcm='echo "commit a container to image">0;fdcm'
alias dsa='echo "start all containers">0;fdsa'
alias dsta='echo "stop all containers">0;fdsta'
alias dsav='echo "stop and save a container to an image">0;fdsav'
alias dsavi='echo "stop, save a container to an image, and start it again">0;fdsavi'
alias dprm='echo "remove all containers, except running ones">0;fdprm'
alias drmi='echo "remove all images, except ones used">0;fdrmi'
alias dbu='echo "build dockerfile">0;fdbu'
alias dalias='echo "add alias,e.g. dbalias name command-string">0;fdalias'
alias dhelp='echo "show all aliases(this)">0;fdhelp'
fds(){ docker start $(echo ${1-$(dl)}); }
fdst(){ docker stop $(echo ${1-$(dl)}); }
fdsh() { docker run -it $1 /bin/bash; }
fdish() { docker run --privileged -it --entrypoint=/bin/bash $1 -i; }
fdind() { docker run --privileged -it --entrypoint=$2 $1; }
fdcm() { docker commit $1 $2; }
fdsa() { docker start $(docker ps -a -q); }
fdsta() { docker stop $(docker ps -a -q); }
fdsav() { dst $([ -z $2 ] && echo $(dl) || echo $1); dcm $([ -z $2 ] && echo $(dl) || echo $1) $2; }
fdsavs() { dsav $([ -z $2 ] && echo $(dl) || echo $1) $2; ds $([ -z $2 ] && echo $(dl) || echo $1); }
fdsavi() { dst $1; dcm $(dl) $(din $()) ; }
fdprm() { docker rm $(docker ps -a -q); }
fdrmi() { docker rmi $(docker images -q); }
fdbu() { docker build -t=$1; }
fdhelp() { alias | grep 'alias d' | sed 's/^\([^=]*\)=[^"]*"\([^"]*\)">0.*/\1                =>                \2/'| sed "s/['|\']//g" | sort; }
fdalias(){ grep -q $1 ~/.bashrc && sed "s/$1.*/$1(){ $2 ; }/" -i ~/.bashrc || sed "$ a\\$1(){ $2 ; }" -i ~/.bashrc; source ~/.bashrc; }

# make all fns with last container: [ -z $1 ] && echo '$(dl)' +  make chainable d - for args, last = id or imagenm, run each with name
# add example commands to alias help

