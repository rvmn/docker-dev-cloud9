# Pull base image.
FROM dcagatay/ubuntu-dind
MAINTAINER Roberto van Maanen <roberto.vanmaanen@outlook.com>

ARG DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm

# replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

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


# Install Node.js
RUN mkdir /root/.nvm
ENV NVM_DIR /root/.nvm
RUN apt-get update \
  && apt-get install -y openssh-server git bash openssl g++ make curl wget python2 python-is-python2 gnupg apache2-utils \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash \
  && source $NVM_DIR/nvm.sh \
  && nvm install 8 \
  && npm i -g forever yarn
RUN export TERM=xterm

# Install php 7.4 and composer
RUN apt update && apt install -y software-properties-common && LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
   && apt update && apt-cache search php && apt install -y php7.4 php7.4-mbstring php7.4-dom php7.4-mysql \
   && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
   && php composer-setup.php  --install-dir=/usr/local/bin --filename=composer \
   && php -r "unlink('composer-setup.php');"

# Docker
#RUN apt-get install -y \
#    apt-transport-https \
#    ca-certificates \
#    curl \
#    gnupg \
#    lsb-release \
#    lxc \
#    iptables
#RUN  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg    
#RUN echo \
#  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
#  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
#RUN  apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Install the magic wrapper.
#ADD ./wrapdocker /usr/local/bin/wrapdocker
#RUN chmod +x /usr/local/bin/wrapdocker

# Install Cloud9
RUN git clone https://github.com/c9/core.git /cloud9
WORKDIR /cloud9
RUN scripts/install-sdk.sh

ADD run.sh /
RUN chmod +x /run.sh

# Tweak standlone.js conf
ADD standalone.js /cloud9/plugins/c9.vfs.standalone/
RUN sed -i -e 's_127.0.0.1_0.0.0.0_g' /cloud9/configs/standalone.js


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
EXPOSE 3000-5001
ENTRYPOINT ["/run.sh"]
# ------------------------------------------------------------------------------
# Start supervisor, define default command.
CMD ["--auth",":"]
