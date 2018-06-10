FROM ruby:2.3-slim
MAINTAINER 	Vitor Caetano <vitor.e.caetano@gmail.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends \
    apache2

ADD ssl/icasei.com.br.pem /etc/ssl/apache2/icasei.com.br.pem
ADD ssl/icasei.com.br.key /etc/ssl/apache2/icasei.com.br.key
ADD ssl/gd_bundle.crt /etc/ssl/apache2/gd_bundle.crt

ADD admin_material.conf /etc/apache2/sites-available/admin_material.conf
ADD admin_material-ssl.conf /etc/apache2/sites-available/admin_material-ssl.conf

RUN a2enmod ssl
RUN a2ensite admin_material
RUN a2ensite admin_material-ssl

ENV INSTALL_PATH /admin_material
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY ./public ./public

WORKDIR /
COPY ./start.sh /

EXPOSE 80
EXPOSE 443

CMD ["./start.sh"]