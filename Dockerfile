FROM ubuntu:14.04
MAINTAINER rvmn
RUN apt-get update && apt-get install -yq apt-transport-https wget
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -yq lxc-docker-1.1.1
RUN apt-get install -y --no-install-recommends lxc=1.0.* cgmanager libcgmanager0

RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/cloud9/Dockerfile
RUN docker build -t devel/cloud9 .
RUN docker run -d -v $(pwd):/workspace -p 3131:3131 devel/cloud9.

ADD ./dind /dind
RUN chmod +x /dind
VOLUME /var/lib/docker
ENTRYPOINT ["/dind"]