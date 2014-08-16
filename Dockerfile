FROM ubuntu:14.04

# install environment
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev mercurial man tree lsof wget openssl

# install docker
RUN apt-get update && apt-get install -yq apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -yq lxc-docker-1.1.1
RUN apt-get install -y --no-install-recommends lxc=1.0.* cgmanager libcgmanager0

# get cloud9
RUN git clone https://github.com/creationix/nvm.git
RUN git clone https://github.com/ajaxorg/cloud9.git

# nvm
ENV NODE_VERSION v0.10.29
RUN echo 'source /nvm/nvm.sh && nvm install ${NODE_VERSION}' | bash -l
ENV PATH /nvm/${NODE_VERSION}/bin:${PATH}
RUN npm install -g sm && /nvm/${NODE_VERSION}/lib/node_modules/sm/bin/sm install
RUN npm install -g forever
RUN cd /cloud9 && sm install && make ace && make worker

# ruby
RUN git clone git://github.com/sstephenson/rbenv.git /.rbenv/
ENV PATH /.rbenv/bin:/.rbenv/shims:${PATH}
RUN cd /.rbenv && mkdir plugins && cd plugins && git clone git://github.com/sstephenson/ruby-build.git
ENV GEM_PATH /lib/ruby/gems

# dind
ADD ./dind /dind
RUN chmod +x /dind

# alias and extra function
#RUN curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc
#RUN echo 'source ~/.bashrc' | bash -l

# clean cache
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN npm cache clean


# set up workspace
VOLUME /workspace
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/QuickStart.md
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install-meteor.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install-rails.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install-all.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/metbp.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/README.md
RUN chmod +x metbp.sh && chmod +x install-meteor.sh && chmod +x install-rails.sh && chmod +x install-all.sh && chmod +x docker-alias.sh
RUN cat docker-alias.sh >> /cloud9/bin/cloud9.sh
RUN mkdir meteor-apps && mkdir rails-apps 
EXPOSE 1337
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0","/dind"]
# OR optionally REPLACE that with: CMD /cloud9/bin/cloud9.sh -l 0.0.0.0 -p 5000 -w /var/lib/docker/workspace

