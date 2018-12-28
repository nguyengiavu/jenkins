# Centos based version 7.3
# https://hub.docker.com/_/centos/
FROM centos:7.3.1611

LABEL maintainer="APIO(APIO-MAINT)"
#LABEL maintainer="Kensuke Takahashi <takahashi.kensuke@lab.ntt.co.jp>"

# Prepare environment 
ENV CATALINA_HOME /usr/share/tomcat
ENV PATH $PATH:${CATALINA_HOME}/bin:${CATALINA_HOME}/scripts
# Resource files from host folder.
ENV LIBS_DIR ./libs
ENV TEMP_FOLDER /tmp
ENV TOMCAT_VERSION apache-tomcat-8.5.3
ENV JAVA_VERSION jdk-8u144-linux-x64
# Copy files
COPY ${LIBS_DIR}/${JAVA_VERSION}.rpm ${TEMP_FOLDER}/${JAVA_VERSION}.rpm
# Upgrade files
COPY ./logrotate.d/tomcat /etc/logrotate.d/tomcat
COPY ./logrotate.d/syslog /etc/logrotate.d/syslog
COPY ./rsyslog/rsyslog.conf /etc/rsyslog.conf
COPY ./oneope /opt/oneope
COPY ./webapps /opt/oneope/webapps/
COPY --chown=0:0 ./docker-entrypoint.sh /docker-entrypoint.sh


# Install prepare infrastructure
RUN set -x && \
 yum -y install epel-release && \
 yum -y install bzip2 tcpdump lsof net-tools curl jq crontabs rsyslog tar openssh-clients iproute && \
 yum -y update && \
 yum clean all && \
 mkdir /var/log/apio/ && \
 sed -i -e 's/#Storage=auto/Storage=persistent/g' /etc/systemd/journald.conf && \
 sed -i -e 's/#MaxRetentionSec=/MaxRetentionSec=90day/g'  /etc/systemd/journald.conf && \
 sed -i -e 's/#MaxFileSec=1month/MaxFileSec=1day/g' /etc/systemd/journald.conf && \
 rpm -ivh ${TEMP_FOLDER}/${JAVA_VERSION}.rpm && \
 rm ${TEMP_FOLDER}/${JAVA_VERSION}.rpm && \
 curl -sOL https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.3/bin/apache-tomcat-8.5.3.tar.gz && \
 tar zxf apache-tomcat-8.5.3.tar.gz && \
 rm apache-tomcat-8.5.3.tar.gz && \
 mv apache-tomcat-8.5.3 /usr/share/tomcat && \
 chmod 644 /etc/logrotate.d/tomcat && \
 echo 'export JAVA_HOME=/usr/java/jdk1.8.0_144/' >> ~/.bashrc && \
 echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc && \
 echo 'export JRE_HOME=/usr/java/jdk1.8.0_144/jre' >> ~/.bashrc && \
 echo 'export PATH=$PATH:$JRE_HOME' >> ~/.bashrc && \
 mv /usr/share/tomcat/webapps/ROOT /usr/share/tomcat/webapps/ROOT_bk
 
COPY ./tomcat/conf/server.xml ${CATALINA_HOME}/conf/
COPY ./tomcat/conf/context.xml ${CATALINA_HOME}/conf/
COPY ./tomcat/conf/web.xml ${CATALINA_HOME}/conf/
COPY ./tomcat/conf/logging.properties ${CATALINA_HOME}/conf/
COPY ./tomcat/bin/catalina.sh ${CATALINA_HOME}/bin/

RUN set -x && \ 
 chmod +x ${CATALINA_HOME}/bin/*sh && \
 chmod 755 /docker-entrypoint.sh && \
 find /opt/ && \
 chmod +x /opt/oneope/scripts/*.sh && \
 mkdir -p /var/log/apio/access && \
 mkdir -p /var/log/apio/order && \
 mkdir -p /var/log/apio/history && \
 mkdir -p /var/log/apio/debug && \
 chmod u+x /opt/oneope/logrotate/LogRotate.sh && \
 chmod 644 /opt/oneope/logrotate/apio_rotate && \
 (crontab -l; echo "0 0 * * * /opt/oneope/logrotate/LogRotate.sh > /dev/null 2>&1") | crontab -

# Working place
WORKDIR ${CATALINA_HOME}

EXPOSE 8080

ENTRYPOINT [ "/docker-entrypoint.sh" ]
