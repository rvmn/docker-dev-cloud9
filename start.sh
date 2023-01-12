#!/bin/bash
function INFO(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [INFO] [${0}] $msg"
}


function DEBUG(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [DEBUG] [${0}] $msg"
}

function ERROR(){
    local function_name="${FUNCNAME[1]}"
    local msg="$1"
    timeAndDate=`date`
    echo "[$timeAndDate] [ERROR]  $msg"
}
function wait_for_process () {
    local max_time_wait=30
    local process_name="$1"
    local waited_sec=0
    while ! pgrep "$process_name" >/dev/null && ((waited_sec < max_time_wait)); do
        INFO "Process $process_name is not running yet. Retrying in 1 seconds"
        INFO "Waited $waited_sec seconds of $max_time_wait seconds"
        sleep 1
        ((waited_sec=waited_sec+1))
        if ((waited_sec >= max_time_wait)); then
            return 1
        fi
    done
    return 0
}

#/sbin/init &
export NVM_DIR=/root/.nvm \
  && source $NVM_DIR/nvm.sh \
  && forever start  /cloud9/server.js -w /workspace --listen 0.0.0.0 --collab --auth :
# $@
