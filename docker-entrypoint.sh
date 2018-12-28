#!/bin/bash
# rsyslogd start
/usr/sbin/rsyslogd

POSTGRES_HOSTNAME=${POSTGRES_HOSTNAME:-localhost}
POSTGRES_PORT=${POSTGRES_PORT:-5432}
POSTGRES_USER=${POSTGRES_USER:-postgres}
POSTGRES_PASS=${POSTGRES_PASS:-postgres}
# config set
pushd .
cd /opt/oneope/functions/
if [ ! -e api_resource/api_resource.conf.org ]; then
    cp -ap api_resource/api_resource.conf api_resource/api_resource.conf.org
fi
cat api_resource/api_resource.conf.org | sed -s "s/localhost:5432/$POSTGRES_HOSTNAME:$POSTGRES_PORT/" | sed -s "s/POSTGRES_USER/${POSTGRES_USER}/" | sed -s "s/POSTGRES_PASS/${POSTGRES_PASS}/" > api_resource/api_resource.conf
chmod 666 api_resource/api_resource.conf

if [ ! -e common_resource/common_resource.conf.org ]; then
    cp -ap common_resource/common_resource.conf common_resource/common_resource.conf.org
fi
cat common_resource/common_resource.conf.org | sed -s "s/localhost:5432/$POSTGRES_HOSTNAME:$POSTGRES_PORT/"  | sed -s "s/POSTGRES_USER/${POSTGRES_USER}/" | sed -s "s/POSTGRES_PASS/${POSTGRES_PASS}/" > common_resource/common_resource.conf
chmod 666 common_resource/common_resource.conf
popd

# tomcat start
ln -s /usr/share/tomcat/logs /var/log/tomcat
/usr/share/tomcat/bin/catalina.sh run
