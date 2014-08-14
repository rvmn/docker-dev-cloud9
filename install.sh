#!/bin/bash
rm -rf Dockerfile && rm -rf dind && apt-get install curl wget && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
( grep 'dcruns' ~/.bashrc | wc -l ; )>0 || echo 'dcruns(){ docker run -d -v $(pwd):/workspace -p "$3":"$3" docker-dev --username "$1" --password "$2"; }' >> ~/.bashrc
if [ ! -z "$1" ] && [ ! -z "$2" ] && [ ! -z "$3" ]; then
echo '
EXPOSE '$3'
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
#grep -q "dcrun()" ~/.bashrc && sed "s/dcrun()/dcrun(){ dcruns $1 $2 $3; }/" -i ~/.bashrc || sed "$ a\dcrun(){ dcruns $1 $2 $3; }" -i ~/.bashrc
fi
if [ ! -z "$1" ] && [ ! -z "$2" ] && [ -z "$3" ]; then
echo '
EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]'  >> Dockerfile
#grep -q "dcrun()" ~/.bashrc && sed "s/dcrun()/dcrun(){ dcruns $1 $2 3000; }/" -i ~/.bashrc || sed "$ a\dcrun(){ dcruns $1 $2 3000; }" -i ~/.bashrc
fi
if [ ! -z "$1" ] && [ -z "$2" ]; then
echo '
EXPOSE '$1'
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
#grep -q "dcrun()" ~/.bashrc && sed "s/dcrun()/dcrun(){ dcruns dvr pass $1; }/" -i ~/.bashrc || sed "$ a\dcrun(){ dcruns dvr pass $1; }" -i ~/.bashrc
fi
if [ -z "$1" ]; then
echo '
EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
#grep -q "dcrun()" ~/.bashrc && sed "s/dcrun()/dcrun(){ dcruns c9dev pass 3000; }/" -i ~/.bashrc || sed "$ a\dcrun(){ dcruns c9dev pass 3000; }" -i ~/.bashrc
fi
cat Dockerfile
read -t 7 -p "Starting upon key press or after 7 seconds"
source ~/.bashrc
docker build -t docker-dev
# workspace setup
( grep '#c9dev docker aliases' ~/.bashrc | wc -l ; )>0 || curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc && source ~/.bashrc
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/QuickStart.md
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/metbp.sh
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/README.md
mkdir meteor-apps && mkdir rails-apps
# postinstall clean
wget https://rawgit.com/rvmn/docker-dev-cloud9/master/rails-install.sh && chmod +x rails-install.sh
rm -rf dind && rm -rf Dockerfile && rm -rf install.sh
echo 'Done!! Hopefully all went right, otherwise just rerun, contact me if needed'
exit