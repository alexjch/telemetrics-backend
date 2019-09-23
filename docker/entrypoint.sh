#!/bin/bash
# Copyright © 2019 Intel Corporation
#
# SPDX-License-Identifier: GPL-3.0-only

# Apply upgrade
pushd ${ROOTDIR}/telemetryui && \
      FLASK_APP=${ROOTDIR}/telemetryui/run.py flask db upgrade

# Start application
/usr/bin/uwsgi --http 0.0.0.0:5000 --chdir ${ROOTDIR}/telemetryui --uid webapp \
               --module telemetryui:app --spooler ${ROOTDIR}/telemetryui/uwsgi-spool
