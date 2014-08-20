FROM ubuntu:14.04

# install environment
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev mercurial man tree lsof wget openssl supervisor nano python

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
RUN rbenv install -l
RUN rbenv install -v 2.1.2
RUN rbenv global 2.1.2 && rbenv rehash
RUN gem install rails
RUN echo 'apt-get update; apt-get install -y libsqlite3-dev' | bash -l
ENV PATH /.rbenv/versions/2.1.2/bin/:/bin:${PATH}

# meteor
#RUN curl https://install.meteor.com | /bin/sh
RUN cd ~ && wget https://rawgit.com/rvmn/docker-dev-cloud9/master/c9-meteor.tar.gz
RUN tar -zxvf c9-meteor.tar.gz
RUN mv /meteor /.meteor
RUN apt-get install git screen tmux
RUN npm install -g meteorite bower grunt-cli yo demeteorizer
ENV PATH /.meteor:/bin:${PATH}
ENV BIND_IP $IP
RUN mkdir -p /data/db && chmod -R 775 /data

# python
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

# julia
RUN apt-get install -y julia 

# dind using supervisor
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/dind && chmod +x /dind
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/supervisord.conf
RUN mv ./dind /usr/local/bin/
RUN mv ./supervisord.conf /etc/supervisor/conf.d/
RUN echo "var exec = require('child_process').exec,child=exec('/usr/bin/supervisord')" >> /cloud9/server.js

# alias and extra functions
RUN curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias.sh >> ~/.bashrc
RUN echo 'source ~/.bashrc' | bash -l

# clean cache
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN apt-get clean -y
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN npm cache clean

# set up workspace
VOLUME /workspace
VOLUME /var/lib/docker
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/QuickStart.md
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install-meteor.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install-rails.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/install-c9.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/metbp.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/README.md
RUN chmod +x metbp.sh && chmod +x install-meteor.sh && chmod +x install-rails.sh && chmod +x install-c9.sh 
RUN mkdir meteor-apps && mkdir rails-apps 
EXPOSE 80:80
EXPOSE 443:443
EXPOSE 3131
ENTRYPOINT ["forever","/cloud9/server.js","-w","/workspace","-l","0.0.0.0"]
