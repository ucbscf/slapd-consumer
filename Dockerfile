FROM ubuntu:20.04

# Install
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ca-certificates ssl-cert rsyslog

# Add debconf-set-selections items
#ADD debconf.txt /root/debconf.txt
#RUN cat /root/debconf.txt | /usr/bin/debconf-set-selections

RUN export LC_ALL=C DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y slapd ldap-utils

RUN usermod -G ssl-cert openldap

# Add configuration files and schemas

RUN chown -R openldap:openldap /etc/ldap/
RUN chmod -R 640 /etc/ldap/
RUN chmod -R ug+X /etc/ldap/

#ADD ./etc/ssl/certs/* /etc/ssl/certs/
#ADD ./etc/ssl/private/* /etc/ssl/private/
#RUN chgrp -R ssl-cert /etc/ssl/private
#RUN chmod 440 /etc/ssl/private/*

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

CMD /usr/sbin/slapd -h "ldap:/// ldapi:///" \
	-u openldap -g openldap \
	-f /etc/ldap/SITE-slapd.conf \
	-d sync 2>&1
