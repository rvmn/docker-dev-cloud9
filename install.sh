#!/bin/bash
rm -rf Dockerfile && rm -rf dind && apt-get install curl wget && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
cat <<EOF  
---------------------------------------------------------------------------------------------

					Dockerfile

---------------------------------------------------------------------------------------------
EOF
cat Dockerfile
cat <<EOF  
---------------------------------------------------------------------------------------------

      			 Time to ENTER or wait, for 7 seconds or ..

---------------------------------------------------------------------------------------------
EOF
read -t 7

#build!
docker build -t docker-dev .

# add aliases to bashrc of host
( grep '#c9dev docker aliases' ~/.bashrc | wc -l ; )>0 || curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc && source ~/.bashrc
[ -z $( grep 'brca()' ~/.bashrc) ] && echo 'brca(){ [ ! -z $( grep $1 ~/.bashrc) ] && sed "s/$1()/$1(){ $2; }/" -i ~/.bashrc || echo "${1}(){ ${2}; }" >> ~/.bashrc; source ~/.bashrc; }' >> ~/.bashrc $$ source ~/.bashrc
brca dcset 'brca dcrun "docker run -privileged -d -v $(pwd):/workspace -e $4 -p $3:$3 docker-dev --username $1 --password $2 -p $3"'

# postinstall clean
rm -rf dind && rm -rf Dockerfile && rm -rf install.sh
echo 'Done!! Hopefully all went good, first run: dcset <user> <name> <port> MONGO_URL=<mongolink>, then start with dcrun, if not installed, do di and check image, try rerunning install url or remove the image and then rerun'
exit