#!/bin/bash

WEBAPP_ROOT=/var/www/telemetrics-backend-latest/telemetryui

# Apply upgrade
pushd ${WEBAPP_ROOT} && \
      FLASK_APP=${WEBAPP_ROOT}/run.py flask db upgrade

# Start application
uwsgi --http 0.0.0.0:5000 --chdir ${WEBAPP_ROOT} --uid webapp \
      --module telemetryui:app --spooler ${WEBAPP_ROOT}/uwsgi-spool
