#!/bin/bash
rm -rf Dockerfile && apt-get install curl wget && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile
[ ! -z $1 ] && echo "ENV MONGO_URL $1" >> Dockerfile
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
docker build -t docker-c9 .

# add aliases to bashrc of host
[ -z $( grep '#c9dev docker aliases' ~/.bashrc) ] && curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias.sh >> ~/.bashrc && source ~/.bashrc
brcadd dcset 'brcadd dcrun "docker run --privileged -d -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 3131:3131 $3 $4 docker-c9 --username $1 --password $2"'

# postinstall clean
rm -rf Dockerfile && rm -rf install.sh
echo 'Done!! Hopefully all went good, first run: dcset <user> <name> MONGO_URL=<mongolink>, then start with dcrun, if not installed try rerunning all or remove the image and rerun'
exit
