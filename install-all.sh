#!/bin/bash
cd /
./install-meteor.sh
./install-rails.sh
/bin/bash ./docker-alias
cat <<EOF

Ready!!

EOF