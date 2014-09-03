#!/bin/bash
git clone https://github.com/Dean-Shi/Meteor-Boilerplate.git && mv Meteor-Boilerplate $1 && cd $1 && meteor update && mrt add npm && npm install msx && meteor add particle4dev:sass
 && cat <<EOF

Done!! 

Some good packages to include in your project:
---------------------------------------------------------------------------------------------------------------------------------
meteor deploy           https://meteorhacks.com/deploy-a-meteor-app-into-a-server-or-a-vm.html          npm install -g mup
accounts-merge          https://atmospherejs.com/package/accounts-merge                                 mrt add accounts-merge
collection2             https://atmospherejs.com/package/collection2                                    mrt add collection2
find-faster             https://atmospherejs.com/package/find-faster                                    mrt add find-faster
fast-render             https://atmospherejs.com/package/fast-render                                    mrt add fast-render
kadira                  https://atmospherejs.com/package/kadira                                         mrt add kadira
queue                   https://atmospherejs.com/package/queue                                          mrt add queue
routecore               https://atmospherejs.com/package/routecore                                      mrt add routecore
smart-publish           https://atmospherejs.com/package/smart-publish                                  mrt add smart-publish
single-page-login       https://atmospherejs.com/package/single-page-login/                             mrt add single-page-login


EOF
