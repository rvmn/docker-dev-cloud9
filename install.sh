#!/bin/bash
cd ~ && rm -rf Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc && source ~/.bashrc
if [ ! -z "$1" ]&&[! -z "$2" ]&&[! -z "$3" ]; then
echo $( cat Dockerfile ; echo 'EXPOSE '$3'\nCMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username '$1'","--password '$2'"]' ) > Dockerfile
fi
if [ ! -z "$1" ]&&[! -z "$2" ]&&[ -z "$3" ]; then
echo $( cat Dockerfile ; echo 'EXPOSE 3030\nCMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username '$1'","--password '$2'"]' ) > Dockerfile
fi
if [ ! -z "$1" ]&&[ -z "$2" ]; then
echo $( cat Dockerfile ; echo 'EXPOSE '$1'\nCMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username c9dev","--password pass"]' ) > Dockerfile
fi
if [ -z "$1" ]; then
echo $( cat Dockerfile ; echo 'EXPOSE 3030\nCMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username c9dev","--password pass"]' ) > Dockerfile
fi
docker build -t docker-dev .
docker run -d -P docker-dev .

