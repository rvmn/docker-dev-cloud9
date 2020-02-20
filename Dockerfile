# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Roberto van Maanen <roberto.vanmaanen@outlook.com>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs wget nano ruby ruby-dev ruby-bundler

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs software-properties-common htop

# Install c9launcher
RUN read -p "Install c9launcher? [y/N]" -n 1 -r
RUN echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
RUN git clone https://github.com/sirhypernova/c9launcher.git
RUN cd c9launcher
RUN cp config-example.json config.json

RUN read -p "c9launcher crypto phrase:"
RUN sed -i -e 's_"crypto": "a secret to encrypt workspace passwords"_"crypto": "$REPLY"_g' config.json 
RUN npm install
RUN cd ..
 # Expose c9launcher
EXPOSE 8080
fi
# Install Java 8 & Maven
RUN read -p "Install Java JDK? [y/N]" -n 1 -r
RUN echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
#RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y -q update
#RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
#RUN  \
#  export DEBIAN_FRONTEND=noninteractive && \
#  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
#  apt-get update && \
#  apt-get -y upgrade && \
#  apt-get install -y oracle-java8-installer maven
RUN apt-get install openjdk-11-jdk
fi

# Docker
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker
VOLUME /var/lib/docker

# Install Meteor
RUN read -p "Install Meteor? [y/N]" -n 1 -r
RUN echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
RUN curl https://install.meteor.com/ | sh
fi

# Install Ruby and Rails
RUN apt-get install -y patch gawk gcc make libc6-dev patch libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN /bin/bash -l -c "curl -L get.rvm.io | bash -s stable"
RUN /bin/bash -c "source /etc/profile.d/rvm.sh"
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install ruby"
RUN /bin/bash -l -c "rvm use ruby --default"
RUN /bin/bash -l -c "rvm rubygems current"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

# install parts
RUN /bin/bash -l -c 'ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"'

# Install VNC
#ADD startvnc.sh /startvnc.sh
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver && \
  rm -rf /var/lib/apt/lists/*

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js 

# Add supervisord conf
ADD supervisord.conf /etc/supervisor/conf.d/

# ------------------------------------------------------------------------------
# Add volumes
RUN mkdir /workspace
VOLUME /workspace

# Install Docker aliases
ADD dockeraliases /root/
RUN chmod +x /root/dockeraliases && cat /root/dockeraliases >> ~/.bashrc
RUN /bin/bash -c 'source ~/.bashrc'
# ------------------------------------------------------------------------------
# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ------------------------------------------------------------------------------
# Expose ports.
 # Expose cloud9
EXPOSE 8181
 # Expose VNC LXDE
EXPOSE 5901
# Expose extra ports
EXPOSE 3000-3199
EXPOSE 4000-5001

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
