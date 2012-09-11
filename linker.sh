#!/bin/sh

mounted=`df -h |grep "/opt"`
FILES="\
    optware.shutdown \
    optware.startup \
    etc/profile 
"

for l in `echo $FILES`
do
    ln -s /opt/optware/$l /opt/$l
done

#autorun at startup
ln -s /opt/optware/optware.startup /opt/.autorun

