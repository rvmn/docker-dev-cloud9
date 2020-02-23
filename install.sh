#!/bin/bash
rm -rf docker-dev-cloud9 && apt-get install -y curl wget git && git clone https://raw.githubusercontent.com/rvmn/docker-dev-cloud9 && cd docker-dev-cloud9
[ ! -z $1 ] && echo "ENV MONGO_URL $1" >> Dockerfile

read -p "Install c9launcher? [Y/n]" -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Nn]$ ]]
then
    echo "
[program:c9launcher]
command = node /c9launcher/index.js
directory = /c9launcher
user = root
autostart = true
autorestart = true
stdout_logfile = /var/log/supervisor/c9launcher.log
stderr_logfile = /var/log/supervisor/c9launcher_errors.log
environment = NODE_ENV='production'" >> supervisord.conf
fi
read -p "Use a user:pass for Cloud9 [Y/n]:"  -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Nn]$ ]]
then
  echo "
[program:cloud9]
command = node /cloud9/server.js --listen 0.0.0.0 --port 8181 -w /workspace 
directory = /cloud9
user = root
autostart = true
autorestart = true
stdout_logfile = /var/log/supervisor/cloud9.log
stderr_logfile = /var/log/supervisor/cloud9_errors.log
environment = NODE_ENV='production'" >> supervisord.conf
else
  read -p "Enter a username:" user
  read -p "Enter a password:" pass
  echo "
[program:cloud9]
command = node /cloud9/server.js --listen 0.0.0.0 --port 8181 -w /workspace --auth $user:$pass
directory = /cloud9
user = root
autostart = true
autorestart = true
stdout_logfile = /var/log/supervisor/cloud9.log
stderr_logfile = /var/log/supervisor/cloud9_errors.log
environment = NODE_ENV='production'" >> supervisord.conf

fi
cat supervisord.conf
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
#dalias dcset 'dalias dcrun "docker run --privileged -d -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 8181:8181 -p 5901:5901 $1 cloud9"'
dalias dcrun "docker run --privileged -d -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 8181:8181 -p 5901:5901 $1 cloud9"
#build!
docker build -t cloud9 .

# postinstall clean
cd .. && rm -rf docker-dev-cloud9
echo "Done!! Hopefully all went good, on init run `dcset [-p portnum:portnum]` to pass a run command with open ports into .bashrc, then start the server with 'dcrun'"
exit
