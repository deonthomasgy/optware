#!/bin/sh

mounted=`df -h |grep "/opt"`
FILES="\
    optware.shutdown \
    optware.startup \
    etc/profile \
    etc/squid/squid.conf 
"

for l in `echo $FILES`
do
    [ -e "/opt/optware/$l" ] && rm /opt/optware/$l
    ln -s /opt/optware/$l /opt/$l
done

#autorun at startup
ln -s /opt/optware/optware.startup /opt/.autorun

