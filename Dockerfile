FROM ubuntu:14.04

# install environment
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN apt-get update && apt-get upgrade -y
RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe multiverse >> /etc/apt/sources.list
RUN apt-get install -y build-essential g++ libssl-dev python-software-properties ruby-build apache2-utils git libxml2-dev mercurial man tree lsof wget openssl supervisor nano python ack-grep git-core curl zlib1g-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev  libffi-dev libgdbm-dev libncurses5-dev automake libtool bison python-pip python-dev 
ENV SHELL /bin/bash
ENV HOME /root
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# install docker
RUN apt-get update && apt-get install -yq apt-transport-https
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -yq lxc-docker-1.1.1
RUN apt-get install -y --no-install-recommends lxc=1.0.* cgmanager libcgmanager0

# nvm
#RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.16.1/install.sh | sh
#RUN source ~/.nvm/nvm.sh && echo "source ~/.nvm/nvm.sh" >> ~/.bashrc && source ~/.bashrc && var=0.10.35;new=$(nvm ls-remote | tail -1 | cut -d'v' -f 2) && echo "var=0.10.35;new=$(nvm ls-remote | tail -1 | cut -d'v' -f 2)" >> ~/.bashrc && source ~/.bashrc && echo "~/.nvm/v${var}/bin:${PATH}" >> ~/.bashrc && echo "alias node='~/.nvm/v${var}/bin/node'" >> ~/.bashrc && cat ~/.bashrc && nvm install $var && source ~/.bashrc && $(echo "alias node='~/.nvm/v$var/bin/node'") && node -v && npm -v && npm install -g sm && $(echo "~/.nvm/$var/lib/node_modules/sm/bin/sm install") && npm install -g forever && cd /cloud9 && sm install && make ace && make worker
RUN git clone https://github.com/creationix/nvm.git
ENV NODE_VERSION v0.10.18
RUN echo 'source /nvm/nvm.sh && nvm install ${NODE_VERSION}' | bash -l
ENV PATH /nvm/${NODE_VERSION}/bin:${PATH}
RUN apt-get install -y npm
#RUN echo "${HOME}/nvm/${NODE_VERSION}/bin:${PATH}" >> ~/.bashrc && source ~/.bashrc && npm install -g sm && npm install -g forever && /nvm/${NODE_VERSION}/lib/node_modules/sm/bin/sm install-command && sm install-npm && cd /cloud9 && sm install && make ace && make worker

#RUN git clone https://github.com/ajaxorg/cloud9.git /cloud9
#WORKDIR /cloud9
#RUN npm install
#RUN npm install -g sm
#WORKDIR /cloud9/node_modules/ace
#RUN make clean build
#WORKDIR /cloud9/node_modules/packager
#RUN rm -rf node_modules
#RUN sm install
#WORKDIR /cloud9
#CMD ["make"]
#RUN node ./node_modules/mappings/scripts/postinstall-notice.js

# ruby
RUN sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | sudo bash -s stable
#RUN echo 'source ~/.rvm/scripts/rvm' | bash -l
RUN /usr/local/rvm/bin/rvm install 2.2.1
RUN /usr/local/rvm/bin/rvm use 2.2.1 --default
RUN ruby -v
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
RUN gem install bundler
#RUN gem install rails -v 4.2.0
ENV GEM_PATH /lib/ruby/gems

# meteor
ENV BIND_IP $IP
RUN mkdir -p /data/db && chmod -R 775 /data
RUN ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"
RUN echo "alias parts='~/.parts/autoparts/bin/parts'" > ~/.bashrc
RUN echo 'source ~/.bashrc' | bash -l
RUN ~/.parts/autoparts/bin/parts install meteor

# python
RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
ENV PATH $HOME/.pyenv/bin:${PATH}
RUN eval "$(~/.pyenv/bin/pyenv init -)"
RUN eval "$(~/.pyenv/bin/pyenv virtualenv-init -)"
RUN pip install virtualenv

# Install Cloud9
RUN git clone https://github.com/c9/core cloud9 && cd cloud9 && ./scripts/install-sdk.sh && npm install -g sm && cd ..
#C9H RUN git clone https://github.com/AVGP/cloud9hub.git cloud9hub && cd cloud9hub && npm install
#C9E

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
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/metbp.sh 
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/README.md
RUN chmod +x metbp.sh
RUN mkdir meteor-apps && mkdir rails-apps 
EXPOSE 80:80
EXPOSE 443:443
EXPOSE 3131
ENTRYPOINT ["forever","/cloud9/server.js","-w","/workspace","-l","0.0.0.0"]
