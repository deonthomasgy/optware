#!/bin/sh

mounted=`df -h |grep "/opt"`
FILES="\
    optware.shutdown \
    optware.startup \
    etc/profile 
"

for l in `echo $FILES`
do
    echo ln -s /opt/optware/$l /opt/$l
done
