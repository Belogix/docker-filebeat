#!/bin/bash

set -e

CONFIG=""
COMMAND="$@"

while [[ $# > 1 ]]
do
key="$1"

case $key in
    -c)
    	CONFIG="$2"
    	shift # past argument
    ;;
    *)
	# other or unknown option
    ;;
esac
shift # past argument or value
done

if [ "$CONFIG" = '' ]; then
	CONFIG=/filebeat.yml
fi

# Add filebeat as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- filebeat "$@"
fi

# Render config file
cat $CONFIG | sed "s/LOGSTASH_HOST/$LOGSTASH_HOST/" | sed "s/LOGSTASH_PORT/$LOGSTASH_PORT/" | sed "s/INDEX/$INDEX/" > $CONFIG.tmp
cat $CONFIG.tmp > $CONFIG
rm $CONFIG.tmp

exec "$@"
