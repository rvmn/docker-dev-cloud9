#!/bin/bash
sudo apt install jq
cd /tmp && wget https://downloads.nestybox.com/sysbox/releases/v0.5.2/sysbox-ce_0.5.2-0.linux_amd64.deb
dpkg -i sysbox-ce_0.5.2-0.linux_amd64.deb
rm sysbox-ce_0.5.2-0.linux_amd64.deb

# add aliases to bashrc of host system
[ -z $( grep '# docker aliases' ~/.bashrc) ] && curl -fsSL https://raw.githubusercontent.com/rvmn/docker-dev-cloud9/master/docker-alias.sh >> ~/.bashrc && source ~/.bashrc
dalias dcset 'dalias dcrun "docker run --name=cloud9 --runtime=sysbox-runc --privileged -d  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /lib/modules:/lib/modules:ro -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 8181:8181 -p 5901:5901 $1 cloud9"'
dalias dcrun "docker run --name=cloud9 --runtime=sysbox-runc --privileged -d  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /lib/modules:/lib/modules:ro -v $(pwd):/workspace -p 3000:3000 -p 4000:4000 -p 5000:5000 -p 8181:8181 -p 5901:5901 $1 cloud9"
#build!
docker build -t cloud9 .

# postinstall clean
cd .. && rm -rf docker-dev-cloud9
echo "Done!! Hopefully all went good, on init run `dcset [-p portnum:portnum]` to pass a run command with open ports into .bashrc, then start the server with 'dcrun'"
exit
