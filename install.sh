#!/bin/bash
cd ~ && rm -rf Dockerfile && rm -rf dind && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
if [ ! -z "$1" ]; then
echo 'EXPOSE '$1'
CMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]' >> Dockerfile
fi
if [ -z "$1" ]; then
echo 'EXPOSE 3030
CMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]'  >> Dockerfile
fi
docker build -t docker-dev .
echo 'devr(){ docker run -d -v $(pwd):/workspace -p 3131:3131 gai00/cloud9 --username c9dev --password pass }' >> ~/.bashrc && source ~/.bashrc

