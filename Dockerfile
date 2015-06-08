FROM gai00/cloud9:latest

# install docker
RUN apt-get update && apt-get install -yq apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -yq lxc-docker-1.1.1
RUN apt-get install -y --no-install-recommends lxc=1.0.* cgmanager libcgmanager0

# install autoparts & meteor
RUN npm install -g autoparts
RUN parts install meteor

# ruby
RUN git clone git://github.com/sstephenson/rbenv.git /.rbenv/
ENV PATH /.rbenv/bin:/.rbenv/shims:${PATH}
RUN cd /.rbenv && mkdir plugins && cd plugins && git clone git://github.com/sstephenson/ruby-build.git

# copy from kennethkl/cloud9
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0"]
