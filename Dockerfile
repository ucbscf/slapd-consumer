FROM ubuntu:22.04

# Install
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install ca-certificates ssl-cert rsyslog

RUN export LC_ALL=C DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y slapd ldap-utils

RUN usermod -G ssl-cert openldap

# Add configuration files and schemas

RUN chown -R openldap:openldap /etc/ldap/
RUN chmod -R 640 /etc/ldap/
RUN chmod -R ug+X /etc/ldap/

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

CMD /usr/sbin/slapd -h "ldap:/// ldapi:/// ldaps:///" \
	-u openldap -g openldap \
	-f /etc/ldap/SITE-slapd.conf \
	-d sync 2>&1
