#!/bin/bash
rm -rf Dockerfile && rm -rf dind && apt-get install curl wget && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
echo 'dcruns(){ docker run -d -v $(pwd):/workspace -p "$3":"$3" docker-dev --username "$1" --password "$2"; }' >> ~/.bashrc && source ~/.bashrc
if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ]; then
echo 'EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
echo 'dcrun(){ dcruns '$1' '$2' '$3'; }' >> ~/.bashrc && source ~/.bashrc
fi
if [! -z "$1" ] && [! -z "$2" ] && [ -z "$3" ]; then
echo 'EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]'  >> Dockerfile
echo 'dcrun(){ dcruns '$1' '$2' 3000; }' >> ~/.bashrc && source ~/.bashrc
fi
if [! -z "$1" ] && [ -z "$2" ]; then
echo 'EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
echo 'dcrun(){ dcruns run c9dev pass '$1'; }' >> ~/.bashrc && source ~/.bashrc
fi
if [ -z "$1" ]; then
echo 'EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
echo 'dcrun(){ dcruns c9dev pass 3000; }' >> ~/.bashrc && source ~/.bashrc
fi
docker build -t docker-dev .
# postinstall
rm -rf Dockerfile
rm -rf dind
( grep '#c9dev docker aliases' ~/.bashrc | wc -l ; )>0 && curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc && source ~/.bashrc
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/QuickStart.md
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/metbp.sh
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/README.md
mkdir meteor-apps
mkdir rails-apps
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/rails-install.sh && chmod +x rails-install.sh
rm -rf install.sh
exit

