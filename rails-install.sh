#!/bin/bash
rbenv install 2.1.2 && rbenv global 2.1.2 && rbenv rehash && gem install rails && echo 'apt-get update; apt-get install -y libsqlite3-dev' | bash -l && echo 'Rails is installed!'