FROM ubuntu:14.04
# install environment
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev mercurial man tree lsof wget apt-transport-https openssl
#install docker
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
RUN echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -yq lxc-docker-1.1.1
RUN apt-get install -y --no-install-recommends lxc=1.0.* cgmanager libcgmanager0
RUN useradd -u 12345 -g users -d /home/c9dev -s /bin/bash -p $(echo pass | openssl passwd -1 -stdin) c9dev
RUN sudo gpasswd -a c9dev docker
# nvm
ENV NODE_VERSION v0.10.29
RUN echo 'source /nvm/nvm.sh && nvm install ${NODE_VERSION}' | bash -l
ENV PATH /nvm/${NODE_VERSION}/bin:${PATH}
RUN npm install -g sm && /nvm/${NODE_VERSION}/lib/node_modules/sm/bin/sm install
RUN npm install -g forever
RUN cd /cloud9 && sm install && make ace && make worker
# meteor install
RUN cd ~ && curl http://c9install.meteor.com | sh && npm install -g meteorite
RUN echo ";metbp() { git clone https://github.com/Dean-Shi/Meteor-Boilerplate.git && mv Meteor-Boilerplate $1 && cd $1 && mrt install && mrt update && mrt add npm && npm install msx && echo '\
Done!! \
Some good packages to include in your project:\
---------------------------------------------------------------------------------------------------------------------------------\
meteor deploy           https://meteorhacks.com/deploy-a-meteor-app-into-a-server-or-a-vm.html          npm install -g mup\
accounts-merge          https://atmospherejs.com/package/accounts-merge                                 mrt add accounts-merge\
collection2             https://atmospherejs.com/package/collection2                                    mrt add collection2\
find-faster             https://atmospherejs.com/package/find-faster                                    mrt add find-faster\
fast-render             https://atmospherejs.com/package/fast-render                                    mrt add fast-render\
kadira                  https://atmospherejs.com/package/kadira                                         mrt add kadira\
queue                   https://atmospherejs.com/package/queue                                          mrt add queue\
routecore               https://atmospherejs.com/package/routecore                                      mrt add routecore\
smart-publish           https://atmospherejs.com/package/smart-publish                                  mrt add smart-publish\
single-page-login       https://atmospherejs.com/package/single-page-login/                             mrt add single-page-login' ; }" >> ~/.bashrc
# rails install
RUN git clone git://github.com/sstephenson/rbenv.git /.rbenv/
ENV PATH /.rbenv/bin:/.rbenv/shims:${PATH}
RUN cd /.rbenv && mkdir plugins && cd plugins && git clone git://github.com/sstephenson/ruby-build.git
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/QuickStart.md
RUN wget https://rawgit.com/rvmn/docker-dev-cloud9/master/rails-install.sh && chmod +x rails-install.sh
RUN curl -fsSL https://rawgit.com/rvmn/docker-dev-cloud9/master/docker-alias >> ~/.bashrc
USER c9dev 
# cloud9 install
RUN git clone https://github.com/creationix/nvm.git
RUN git clone https://github.com/ajaxorg/cloud9.git
# clean cache
RUN apt-get autoremove -y
RUN apt-get autoclean -y
RUN apt-get clean -y
ADD ./dind /dind
RUN chmod +x /dind
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN npm cache clean
VOLUME /workspace
# copy from kennethkl/cloud9
ENTRYPOINT ["/dind"]


