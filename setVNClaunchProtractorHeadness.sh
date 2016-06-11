#!/bin/bash
# set -x
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
thisScript="${0}"
scriptName=${thisScript##*/}
env
start_time=$SECONDS

# path where source is mounted
# export BASE_SRC=${BASE_FOLDER}

# name for user who is performing the build
USER=$(id -un)

# result code
RESULT=0

# user ID for user mapping, passed as argument
USER_ID=$(id -u)



# permissions to write in node_modules

[ -d ~/.npm_docker ] && { chown -R ${USER}:${USER} ~/.npm_docker; }
[ -d ~/.npm ] && { chown -R ${USER}:${USER} ~/.npm; }
[ -d "/usr/local/lib/node_modules/" ] && { chown -R ${USER}:${USER} /usr/local/lib/node_modules; }
###############################################################################
installProtractor() {
  # Setup Node Modules and grunt
  pushd ${1}
  #set the location of npm cache and install package node modules
  [ -f "${1}/package.json" ] && { npm config set cache ${BASE_DIR}/npm; npm -q install; }
  # Install grunt libs
  [ -f "${1}/Gruntfile.js" ] && grunt install
  # set ownership of node modules
  [ -d "${1}/node_modules" ] && { chown ${USER}:${USER} ${1}/node_modules; }

  [ -f "${1}/node_modules/protractor/bin/webdriver-manager" ] && \
  node ${1}/node_modules/protractor/bin/webdriver-manager update
  if [ -d "${1}/node_modules/protractor/selenium" ]; then
    ssvr=$(find ${1}/node_modules/protractor/selenium |grep "selenium-server-standalone")
    lnssvr=$(echo "${ssvr}"|sed -e "s/\-\([0-9]\{0,2\}\.[0-9]\{0,2\}\.[0-9]\{0,2\}\)//g")
    ln -s ${ssvr} ${lnssvr}
  chmod 777 -R ${1}/node_modules/protractor/selenium *
  fi
  popd
}
###############################################################################
startVNC() {
  # setup XWindows
  /usr/bin/Xvfb :1 -screen 0 ${DISPLAY_SIZE} &
  export DISPLAY=:1
  sleep 5
  PARAMETER="SERVER_HOSTNAME=${SERVER_HOSTNAME} BROWSER=${BROWSER} DISPLAY_SIZE=${DISPLAY_SIZE}"
  echo "Parameter: ${PARAMETER}"
  x11vnc -display "${DISPLAY}" -xkb -forever -shared -bg  -passwd t123 -autoport 5900 &
}
###############################################################################
showENV() {
  echo "######################################################################"

  echo "user ID: ${USER_ID}"
  echo "user Name: ${USER}"
  echo "Current Directory:${PWD}"
  env
  echo "######################################################################"
}


eval "${EVAL_CMD}"


######################################################

if [ $? -ne 0 ]; then
        # failed to build
        RESULT=1
fi

finish_time=${SECONDS}
elapsed_time="$((finish_time - start_time)) sec."

# done
if [ ${RESULT} -eq 0 ]; then
	echo "Done - success in $elapsed_time"
	exit 0
else
	echo "Build failed! (in $elapsed_time)"
	exit $RESULT
fi

