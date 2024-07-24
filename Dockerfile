FROM registry.access.redhat.com/ubi8/ubi

MAINTAINER Diego Callejo
ENV foo=text

RUN dnf install -y httpd mod_wsgi mod_auth_gssapi
RUN dnf install -y curl krb5-workstation
RUN dnf clean all -y
ADD index.html /var/www/html/
ADD script-cgi /var/www/cgi-bin/
RUN chmod 644 /var/www/html/index.html
RUN chmod 755 /var/www/cgi-bin/script-cgi

# need to change some permissions to allow non-root user to start things
# had to do these steps to give the httpd deamon the ability to.
# This actually appears due to a bug with Windows and Mac. It looks like
# we could have just "ls" on the directory to get the chmod to stick
RUN rm -rf /run/httpd && mkdir /run/httpd && chmod -R a+rwx /run/httpd

USER 1001

CMD /usr/sbin/apachectl -DFOREGROUND

EXPOSE 8080
