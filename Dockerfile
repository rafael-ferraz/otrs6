# Image - OTRS 6 / MariaDB

FROM ubuntu:latest

MAINTAINER Rafael Ferraz "rafaelferraz.df@gmail.com"
ENV TZ="America/Sao_Paulo"

# Update O.S repository
RUN apt-get update -y
RUN apt-get upgrade -y

ENV MYSQL_HOST=mysql
ENV MYSQL_USER=otrs
ENV MYSQL_PASSWORD=otrs

# Install Apache Server

RUN apt install apache2 -y

# Install Perl library and tools

RUN apt install libapache2-mod-perl2 libdbd-mysql-perl libtimedate-perl libnet-dns-perl libnet-ldap-perl \
libio-socket-ssl-perl libpdf-api2-perl libsoap-lite-perl libtext-csv-xs-perl libjson-xs-perl libapache-dbi-perl \
libxml-libxml-perl libxml-libxslt-perl libyaml-perl libarchive-zip-perl libcrypt-eksblowfish-perl libencode-hanextra-perl \
libmail-imapclient-perl libtemplate-perl libdatetime-perl libcrypt-ssleay-perl libdbd-odbc-perl libdbd-pg-perl libauthen-ntlm-perl \
libmoo-perl zip unzip sharutils wget -y

# Create otrs user and add to apache group

RUN useradd -r -d /opt/otrs -c 'OTRS User' otrs
RUN usermod -a -G www-data otrs

# Download OTRS Community source code and extract in proper directory

RUN wget -P /opt/ https://otrscommunityedition.com/download/otrs-community-edition-6.0.37.tar.gz
RUN tar -xzvf /opt/otrs-community-edition-6.0.37.tar.gz -C /opt/
RUN cd /opt/ && mv otrs-community-edition-6.0.37 otrs && chown -R otrs:otrs otrs

# Configure Apache to otrs site and set the proper permissions

RUN cp /opt/otrs/Kernel/Config.pm.dist /opt/otrs/Kernel/Config.pm
RUN sed -i "/^    \$Self->{DatabaseHost}/c\    \$Self->{DatabaseHost} = '$MYSQL_HOST';" /opt/otrs/Kernel/Config.pm
RUN sed -i "/^    \$Self->{DatabaseUser}/c\    \$Self->{DatabaseUser} = '$MYSQL_USER';" /opt/otrs/Kernel/Config.pm
RUN sed -i "/^    \$Self->{DatabasePw}/c\    \$Self->{DatabasePw} = '$MYSQL_PASSWORD';" /opt/otrs/Kernel/Config.pm
RUN /opt/otrs/bin/otrs.SetPermissions.pl --otrs-user=www-data --web-group=www-data
RUN ln -s /opt/otrs/scripts/apache2-httpd.include.conf /etc/apache2/sites-available/otrs.conf
RUN a2ensite otrs

# Restart Apache do load configuration and starts otrs Daemon

RUN service apache2 restart

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]



