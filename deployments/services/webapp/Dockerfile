# Copyright (C) 2020 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
FROM clearlinux:latest

WORKDIR /var/www/webapp

RUN swupd bundle-add python3-basic uwsgi
RUN mkdir -p /var/www/webapp/uwsgi-spool /var/www/webapp/log /var/www/webapp/socket
COPY ./deployments/services/webapp/requirements.txt ./deployments/services/webapp/webapp.ini ./
COPY ./telemetryui/. /var/www/webapp
COPY ./utils/shared_utils/crash.py ./utils/shared_utils/model.py /var/www/webapp/telemetryui/
RUN pip3 install -r requirements.txt
RUN groupadd -r webapp && useradd -r -g webapp webapp
RUN chown -R webapp:webapp /var/www/webapp

USER webapp

CMD ["uwsgi", "--ini", "/var/www/webapp/webapp.ini"]
