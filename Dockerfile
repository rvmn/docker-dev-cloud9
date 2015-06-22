# ------------------------------------------------------------------------------
# Based on a work at https://github.com/docker/docker.
# ------------------------------------------------------------------------------
# Pull base image.
FROM kdelfour/supervisor-docker
MAINTAINER Roberto van Maanen <roberto.vanmaanen@gmail.com>

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev sshfs wget nano

# ------------------------------------------------------------------------------
# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup | bash -
RUN apt-get install -y nodejs
    
# ------------------------------------------------------------------------------
# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

#Install Java & Maven
RUN wget --no-verbose -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
RUN echo "87e5cc81bc4ab9b83986b3e77e6b3095 /tmp/apache-maven-3.2.2.tar.gz" | md5sum -c
# install maven
RUN tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.2.2 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.2.2.tar.gz
ENV MAVEN_HOME /opt/maven

# set shell variables for java installation
ENV java_version 1.8.0_11
ENV filename jdk-8u11-linux-x64.tar.gz
ENV downloadlink http://download.oracle.com/otn-pub/java/jdk/8u11-b12/$filename

# download java, accepting the license agreement
RUN wget --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" -O /tmp/$filename $downloadlink 

# unpack java
RUN mkdir /opt/java-oracle && tar -zxf /tmp/$filename -C /opt/java-oracle/
ENV JAVA_HOME /opt/java-oracle/jdk$java_version
ENV PATH $JAVA_HOME/bin:$PATH

# configure symbolic links for the java and javac executables
RUN update-alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 20000 && update-alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 20000

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
RUN /bin/bash -l -c "gem install rails"
RUN /bin/bash -l -c "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"

RUN npm install -g forever

# install parts
RUN ruby -e "$(curl -fsSL https://raw.github.com/nitrous-io/autoparts/master/setup.rb)"

# Install VNC
#ADD startvnc.sh /startvnc.sh
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver && \
  rm -rf /var/lib/apt/lists/*
#apt-get update \
#    && apt-get install -y --force-yes --no-install-recommends supervisor \
#        sudo vim-tiny \
#        net-tools \
#        lxde x11vnc xvfb python python-numpy unzip geany menu\
#        gtk2-engines-murrine ttf-ubuntu-font-family \
#        libreoffice firefox &&\
#    cd /root && git clone https://github.com/kanaka/noVNC.git && \
#    cd noVNC/utils && git clone https://github.com/kanaka/websockify websockify && \
#    cd /root && \
#    chmod 0755 /startvnc.sh
    
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
EXPOSE 5901
# Expose extra ports
EXPOSE 3000-3199
EXPOSE 4000-5001

# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
ENTRYPOINT ["forever", "/cloud9/server.js", "-w", "/workspace", "-l", "0.0.0.0", "-p", "8181"]
