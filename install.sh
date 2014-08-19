#!/bin/bash
rm -rf Dockerfile && apt-get install curl wget && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile
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
[ ! -z $1 ] && echo "ENV ${1}" >> Dockerfile

#build!
docker build -t docker-c9 .

# add aliases to bashrc of host
[ -z $( grep '#c9dev docker aliases' ~/.bashrc) ] && curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc && source ~/.bashrc
bradd dcset 'bradd dcrun "docker run --privileged -d -v $(pwd):/workspace -p 3000:3000 -e $3 docker-c9 --username $1 --password $2 -p 3000"'

# postinstall clean
rm -rf Dockerfile && rm -rf install.sh
echo 'Done!! Hopefully all went good, first run: dcset <user> <name> MONGO_URL=<mongolink>, then start with dcrun, if not installed try rerunning all or remove the image and rerun'
exit