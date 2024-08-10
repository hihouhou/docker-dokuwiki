#
# Dokuwiki Dockerfile with lighttpd
#
# https://github.com/
#

# Pull base image.
FROM debian:latest

LABEL org.opencontainers.image.authors="hihouhou < hihouhou@hihouhou.com >"

# Set the version you want of Twiki
ENV DOKUWIKI_VERSION release-2024-02-06

# Update & install packages
RUN apt-get update && \
    apt-get install -y nginx php5-fpm php5-gd wget 

# Download & deploy twiki
RUN mkdir /usr/share/dokuwiki && cd /usr/share/dokuwiki && wget http://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz && tar xf dokuwiki-stable.tgz --strip-components=1


# Cleanup
RUN rm /usr/share/dokuwiki/dokuwiki-stable.tgz

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-enabled/*
ADD dokuwiki.conf /etc/nginx/sites-enabled/
ADD local.php /usr/share/dokuwiki/conf/
ADD acl.auth.php /usr/share/dokuwiki/conf/
ADD users.auth.php /usr/share/dokuwiki/conf/

# Set up ownership
RUN chown -R www-data:www-data /usr/share/dokuwiki

#port used
EXPOSE 80

#volume added
VOLUME ["/usr/share/dokuwiki/data"]


CMD /usr/sbin/php5-fpm && /usr/sbin/nginx
