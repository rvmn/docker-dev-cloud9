#!/bin/bash
cd /
./install-meteor.sh
./install-rails.sh
/bin/bash ./docker-alias.sh
cat <<EOF

Ready!!

EOF