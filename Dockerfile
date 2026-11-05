FROM ubuntu:24.04

ENV DEBIAN_PRIORITY=high
ENV DEBIAN_FRONTEND=noninteractive

RUN groupadd -r -g 509 ssl-cert
RUN groupadd -r -g 389 openldap && \
    useradd -r -u 389 -g 389 -d /var/lib/ldap -s /bin/false openldap

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        ca-certificates \
        ssl-cert \
        rsyslog \
        slapd \
        ldap-utils

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN usermod -G ssl-cert openldap

EXPOSE 389 636

CMD ["/usr/sbin/slapd", "-h", "ldap:/// ldaps:/// ldapi:///", \
     "-u", "openldap", "-g", "openldap", \
     "-f", "/etc/ldap/SITE-slapd.conf", "-d", "sync"]
