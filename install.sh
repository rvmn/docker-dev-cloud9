#!/bin/bash
cd ~ && rm -rf Dockerfile && rm -rf dind && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/Dockerfile && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind
if [ ! -z "$1" ]&&[! -z "$2" ]&&[! -z "$3" ]; then
echo 'EXPOSE '$3'
CMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username '$1'","--password '$2'"]' >> Dockerfile
fi
if [ ! -z "$1" ]&&[! -z "$2" ]&&[ -z "$3" ]; then
echo 'EXPOSE 3030
CMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username '$1'","--password '$2'"]'  >> Dockerfile
fi
if [ ! -z "$1" ]&&[ -z "$2" ]; then
echo 'EXPOSE '$1'
CMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username c9dev","--password pass"]' >> Dockerfile
fi
if [ -z "$1" ]; then
echo 'EXPOSE 3030
CMD ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","--username c9dev","--password pass"]'  >> Dockerfile
fi
docker build -t docker-dev .
docker run -d -P docker-dev .

