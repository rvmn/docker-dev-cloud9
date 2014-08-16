#!/bin/bash
rm -rf Dockerfile && rm -rf dind && apt-get install curl wget && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
cat <<EOF  
---------------------------------------------------------------------------------------------

										Dockerfile

---------------------------------------------------------------------------------------------
EOF
cat <<EOF  
---------------------------------------------------------------------------------------------

      			 Starting install upon a key press or after 7 seconds

---------------------------------------------------------------------------------------------
EOF
read -t 7

# workspace files
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/QuickStart.md
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/meteor-install.sh && chmod +x meteor-install.sh
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/metbp.sh && chmod +x metbp.sh
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/README.md
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias.sh

#build!
docker build -t docker-dev .

# add aliases to bashrc of host
( grep '#c9dev docker aliases' ~/.bashrc | wc -l ; )>0 || curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc && source ~/.bashrc
[ -z $( grep 'brca()' ~/.bashrc) ] && echo 'brca(){ [ ! -z $( grep $1 ~/.bashrc) ] && sed "s/$1()/$1(){ $2; }/" -i ~/.bashrc || echo "${1}(){ ${2}; }" >> ~/.bashrc; source ~/.bashrc; }' >> ~/.bashrc $$ source ~/.bashrc
brca dcset 'brca dcrun "docker run -d -v $(pwd):/workspace -e $4 -p $3:$3 docker-dev --username $1 --password $2 -p $3"'

# postinstall clean
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/rails-install.sh && chmod +x rails-install.sh
rm -rf dind && rm -rf Dockerfile && rm -rf install.sh
echo 'Done!! Hopefully all went good, first run: dcset <user> <name> <port> MONGOENV=<mongolink>, then start with dcrun, if not installed, do di and check image, try rerunning install url or remove the image and then rerun'
exit