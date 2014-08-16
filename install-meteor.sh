#!/bin/bash
RUN cd / && curl http://c9install.meteor.com | sh 
RUN npm install -g meteorite