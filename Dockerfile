# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Roberto van Maanen <roberto.vanmaanen@gmail.com>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs wget nano ruby ruby-dev ruby-bundler

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs software-properties-common htop
    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Install Java 8 & Maven
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get -y -q update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN  \
  export DEBIAN_FRONTEND=noninteractive && \
  sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y oracle-java8-installer maven
  
# Docker
ADD https://get.docker.io/builds/Linux/x86_64/docker-latest /usr/local/bin/docker
ADD ./wrapdocker /usr/local/bin/wrapdocker
RUN chmod +x /usr/local/bin/docker /usr/local/bin/wrapdocker
VOLUME /var/lib/docker

# Install Nodervisor
#RUN git clone https://github.com/TAKEALOT/nodervisor ~/nodervisor && cd ~/nodervisor && npm install && chmod +x app.js && chmod +x config.js && sed -i s/1234567890ABCDEF/"$(od -vAn -N4 -tu4 < /dev/urandom)"/ config.js && sed -i "s/3000/3200/" config.js

# Install Meteor
RUN curl https://install.meteor.com/ | sh

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
#RUN /bin/bash -l -c "gem install rails"

# install autoparts
RUN /bin/bash -l -c 'ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"'

# Install noVNC
ADD startvnc.sh /root/startvnc.sh
RUN apt-get update -y && \
    apt-get install -y git x11vnc wget python python-numpy unzip Xvfb firefox openbox geany menu && \
    cd /root && git clone https://github.com/kanaka/noVNC.git && \
    cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify && \
    cd /root && \
    chmod 0755 /root/startvnc.sh && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

# Install Docker from Docker Inc. repositories.
RUN curl -sSL https://get.docker.com/ubuntu/ | sh

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
EXPOSE 6080
# Expose extra ports
EXPOSE 3000-6000

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
