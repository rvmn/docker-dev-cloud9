FROM ubuntu:14.04

# install environment
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev mercurial man tree lsof wget openssl supervisor nano python npm

# install docker
RUN apt-get update && apt-get install -yq apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -yq lxc-docker-1.1.1
RUN apt-get install -y --no-install-recommends lxc=1.0.* cgmanager libcgmanager0

# get cloud9
RUN git clone https://github.com/ajaxorg/cloud9.git

# nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh
RUN var=$(nvm ls-remote | tail -1 | cut -d'v' -f 2) 
RUN echo nvm ls-remote | tail -1 | echo "var=$(nvm ls-remote | tail -1 | cut -d'v' -f 2) && source ~/.nvm/nvm.sh && nvm install $var" | bash -l
RUN echo nvm ls-remote | tail -1 | echo "/nvm/$var/bin:${PATH}" >> ~/.bashrc
RUN cat ~/.bashrc
RUN $(echo "nvm use $var")
RUN echo 'source ~/.bashrc' | bash -l
RUN echo 'node -v' | bash -l
RUN echo "npm install -g sm && /nvm/$var/lib/node_modules/sm/bin/sm install" | bash -l
RUN npm install -g forever
RUN cd /cloud9 && sm install && make ace && make worker

# ruby
RUN git clone git://github.com/sstephenson/rbenv.git /.rbenv/
ENV PATH /.rbenv/bin:/.rbenv/shims:${PATH}
RUN cd /.rbenv && mkdir plugins && cd plugins && git clone git://github.com/sstephenson/ruby-build.git
RUN rbenv install -l 
RUN rbenv install 2.1.2 && rbenv global 2.1.2 && rbenv rehash
RUn exec $SHELL -l
RUN gem install rails
ENV GEM_PATH /lib/ruby/gems
RUN echo 'apt-get update; apt-get install -y libsqlite3-dev' | bash -l

# meteor
ENV BIND_IP $IP
RUN mkdir -p /data/db && chmod -R 775 /data
ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
RUN echo "alias parts='/.parts/autoparts/bin/parts'" > ~/.bashrc
RUN echo 'source' | bash -l
RUN parts install meteor

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
