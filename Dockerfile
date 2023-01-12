FROM nestybox/ubuntu-focal-systemd-docker:latest
ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

ENV TZ=Europe/Amsterdam
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ="Europe/Amsterdam" apt-get install -y tzdata

# ------------------------------------------------------------------------------
# Install base
RUN apt-get update
RUN apt-get install -y build-essential g++ curl libssl-dev apache2-utils git libxml2-dev wget nano

# Install dependencies:
RUN apt-get update && apt-get install -y ca-certificates openssh-client \
    wget curl iptables locales \
    && rm -rf /var/lib/apt/list/* \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
 && /usr/sbin/update-locale LANG=en_US.UTF-8

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Node.js
RUN mkdir /root/.nvm
ENV NVM_DIR /root/.nvm
RUN apt-get update \
  && apt-get install -y openssh-server git bash openssl g++ make curl wget python2 gnupg apache2-utils \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install 10 \
  && npm i -g forever yarn \
  && git clone https://github.com/sirhypernova/c9launcher && cd c9launcher && cp config-example.json config.json && yarn install && cd ..
 # Expose c9launcher
EXPOSE 8080

# Install VNC
ADD startvnc.sh /startvnc.sh
ENV USER root
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y lxde-core lxterminal tightvncserver xfce4 xfce4-goodies && \
  rm -rf /var/lib/apt/lists/*
EXPOSE 5901
#RUN mkdir  ~/.vnc && echo "#!/bin/sh\
#xrdb "$HOME/.Xresources"\
#xsetroot -solid grey\
#export XKL_XMODMAP_DISABLE=1\
#/etc/X11/Xsession\
#startxfce4\
#" > ~/.vnc/xstartup

# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

# Tweak standlone.js conf
#ADD standalone.js /cloud9/plugins/c9.vfs.standalone/
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js

#ADD run.sh /
#RUN chmod +x /run.sh

# Install snap
ENV container docker
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update &&\
 DEBIAN_FRONTEND=noninteractive\
 apt-get install -y fuse snapd snap-confine squashfuse sudo init &&\
 apt-get clean &&\
 dpkg-divert --local --rename --add /sbin/udevadm &&\
 ln -s /bin/true /sbin/udevadm
VOLUME ["/sys/fs/cgroup"]
VOLUME ["/lib/modules"]
STOPSIGNAL SIGRTMIN+3

RUN systemctl enable snapd

# Example of a systemd service created to showcase a custom entry-point.
COPY start.sh /usr/bin/
COPY start.service /lib/systemd/system/
RUN chmod +x /usr/bin/start.sh &&                               \
    ln -sf /lib/systemd/system/start.service                    \
       /etc/systemd/system/multi-user.target.wants/start.service
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
EXPOSE 3000
EXPOSE 4000
EXPOSE 5000
#ENTRYPOINT [ "/usr/bin/start.sh" ]
# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["/sbin/init"]
#CMD ["--auth",":"]
#CMD ["/lib/systemd/systemd"]
# Set systemd as entrypoint.
#ENTRYPOINT [ "/sbin/init", "--log-level=err" ]
