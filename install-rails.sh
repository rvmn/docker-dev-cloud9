#!/bin/bash
echo 'Installing Ruby and Rails'
echo 'step 1 of 7:' && rbenv install -l
echo 'step 2 of 7:' && rbenv install 2.1.2
echo 'step 3 of 7:' && rbenv global 2.1.2 && rbenv rehash
echo 'step 4 of 7:' && ruby -v
echo 'step 5 of 7:' && gem -v
echo 'step 6 of 7:' && gem install rails
echo 'step 7 of 7:' && rails -v && echo 'apt-get update; apt-get install -y libsqlite3-dev' | bash -l
echo 'Ruby and Rails are installed!'