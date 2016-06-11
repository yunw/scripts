#!/bin/bash
# set -x
BASE_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
thisScript="${0}"
scriptName=${thisScript##*/}
t_usage()
{
    echo
    echo "Usage: ${scriptName} [-s] <hostname> | [-f] <application name filter> | [-e] <staging environment> | [-t ] <test suite name> | -h "
    echo ""
	echo "Options:"
    echo "   -s <hostname> Hostname to run tests on, default: "
	echo "   -t <test suite> Test suite to run on host, default: test:"
	echo "   -h help usage"
    echo ""
    echo "#########################################################################"
    echo ""
    echo ""
    echo " Debug environment"
    echo " bash -  open a bash shell with the base enivronment"
    echo ""
    echo "#########################################################################"
    echo " To see the UI tests on Virtual Desktop point your VNC client to "
    echo " 10.245.1.2:5900 and use the password \"t\""
    echo "#########################################################################"
    exit -1
} # t_usage
while [ $# -gt 0 ]
do
key="$1"
case $key in
    -s|--server)
    SERVER_HOSTNAME=${2}
    shift
    ;;
	-un|--username)
    USER_NAME=${2}
    shift
    ;;
	-pd|--password)
    PASSWORD=${2}
    shift
    ;;
    -t | --test)
    TEST_SUITE=${2}
    shift
    ;;
    -e | --env)
    STAGING_ENV=${2}
    shift
    ;;
    -f | --filter)
    APP_FILTER=${2}
    shift
    ;;
    # -r | --report)
    # REPORT_FOLDER=${2}
    # shift
    # ;;
    -h | --help)
    t_usage
    ;;
    --default)
    t_usage
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
