#!/bin/bash
rm -rf docker-dev-cloud9 && apt-get install -y curl wget git && git clone https://raw.githubusercontent.com/rvmn/docker-dev-cloud9 && cd docker-dev-cloud9
[ ! -z $1 ] && echo "ENV MONGO_URL $1" >> Dockerfile
cat <<EOF  
---------------------------------------------------------------------------------------------

					Dockerfile

---------------------------------------------------------------------------------------------
EOF
cat Dockerfile
cat <<EOF  
---------------------------------------------------------------------------------------------

      			 Check the Dockerfile ^^^ and press ENTER

---------------------------------------------------------------------------------------------
EOF
read -t 7

# add aliases to bashrc of host system
[ -z $( grep '# docker aliases' ~/.bashrc) ] && curl -fsSL https://raw.githubusercontent.com/rvmn/docker-dev-cloud9/master/docker-alias.sh >> ~/.bashrc && source ~/.bashrc
dalias dcset 'brcadd dcrun "docker run --privileged -d -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 8181:8181 -p 5901:5901 $3 $4 cloud9 --username $1 --password $2"'

#build!
docker build -t cloud9 .

# postinstall clean
cd .. && rm -rf docker-dev-cloud9
echo "Done!! Hopefully all went good, to set username and password: 'dcset <user> <name>', then start with 'dcrun'"
exit
