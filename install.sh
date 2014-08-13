#!/bin/bash
mkdir ~/tmp/ && cd ~/tmp/ || cd ~/tmp/  && rm -rf Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
if [ ! -z "$1" ]&&[! -z "$2" ]&&[! -z "$3" ]; then
sed -i -e 's/devel/cloud9./devel/cloud9. --username '$1' --password '$2' -p '$3'/g' Dockerfile 
fi
if [ ! -z "$1" ]&&[! -z "$2" ]; then
sed -i -e 's/devel/cloud9./devel/cloud9. --username '$1' --password '$2'/g' Dockerfile 
fi
if [ ! -z "$1" ]&&[ -z "$2" ]; then
sed -i -e 's/devel/cloud9./devel/cloud9. -p '$1'/g' Dockerfile 
fi
docker build -t docker-dev:14.04 .
docker run -d docker-dev:14.04 .

