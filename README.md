# telemetrics-backend

## Overview

This project provides the server-side component of a complete telemetrics
(telemetry + analytics) solution for Linux-based operating systems. The
client-side component source repository lives at
https://github.com/clearlinux/telemetrics-client.

It consists of two Flask applications: an ingestion app, [`collector`](collector), for
records received from telemetrics-client probes; and a web app, [`telemetryui`](telemetryui),
that exposes several views to visualize the telemetry data. The `telemetryui`
app also provides a REST API to perform queries on the data.

The applications run within a web stack, using the nginx web server, the uWSGI
application server, and PostgreSQL as the underlying database server.

The Flask apps have several other dependencies and are listed below.

* SQLAlchemy - for performing queries on the PostgreSQL database
* Flask-SQLAlchemy - for SQLAlchemy integration with Flask
* WTForms - for HTML form validation and rendering
* Flask-WTF - for WTForms integration with Flask
* alembic - for performing database migrations
* Flask-Migrate - for alembic integration with Flask
* Jinja2 - templating engine used by Flask
* Bootstrap - for styling of Jinja2 templates
* jQuery - for client-side scripting in templates
* Chart.js - for rendering of charts in templates

## Security considerations

The telemetrics-backend was written with a particular deployment scenario in
mind: single server/VM hosting and running on an internal LAN (e.g. a corporate
network not exposed to the public internet). Also, no identity management, user
authentication, or role-based access controls have yet been implemented for the
applications.

To control access to the applications, it is recommended that system
administrators leverage web server authentication.

Regarding alternate deployment scenarios, one might want to host the collector,
telemetryui, and database on three separate servers/VMs; and implement network
access controls for these systems. The in-tree deployment script does not
support these types of deployments, but with minimal modification to the
source, they should be possible.

## Installation

To install the telemetrics-backend, a deployment/installation script is
provided that auto-installs required dependencies for the applications,
configures nginx and uwsgi, deploys snapshots of the applications, and starts
all required services. The script is named `deploy.sh` and lives in the
scripts/ directory in this repository.

The script supports installation to the following Linux distributions: Ubuntu
Server 16.04 (or newer), and Clear Linux OS for Intel Architecture (any recent
build).

### Running the deployment script

To see all options, run:

```
$ cd scripts
$ ./deploy.sh -h
```

#### Prerequisites

* Copy the deploy.sh script to the system where you will be installing
  telemetrics-backend (e.g. using `scp`). Remote installations are not yet
  supported.

* On Ubuntu Server, make sure you `apt-get update` before continuing.

* Install `sudo` if needed, and add your user to sudoers.

* Set the `https_proxy` variable in the shell environment if your system is
  behind a proxy.

#### Installation

To perform a fresh installation on Ubuntu Server, run the following locally on
the system:

```
$ ./deploy.sh -H localhost -a install
```

If you are installing on Clear Linux OS, run:

```
$ ./deploy.sh -H localhost -d clr -a install
```

#### Installation Notes

During script execution, you will be prompted for user input:

* The first prompt begins with "DB password:", asking for a password to set for
  the `telemdb` database. If you do not enter a value before pressing ENTER,
  the password will be `postgres`.

* If your sudo access requires a password, you will be prompted for that
  password in the course of the installation.

* When installing to Clear Linux OS, you will be prompted to enter a password
  for the `postgres` user account. This is necessary because Clear Linux OS by
  default ships with a `postgres` system account, not a user account. Thus the
  script modifies the account and requires a password set to properly configure
  PostgreSQL.

When the installation is complete, you will see the following message:

```
Install complete (installation folder: /var/www/telemetry)
```

#### Other options

Other useful options for `deploy.sh` include `-r` and `-s`. The `-r` option
sets the location for the telemetrics-backend git source repository you are
working with. Its default value is the upstream repo location on
github.com/clearlinux. The `-s` option lets you select a different git branch
to install/deploy from rather than "master", the default value.


## Special configuration

### Configuring nginx for TLS

The `sites_nginx.conf` config file is already enabled to accept TLS connections
on port 443. However, you must install the X509 certificate chain and the
certificate private key to a specific location before running `deploy.sh`. Both
files should be in PEM format. Additional details on specific considerations
can be found in the [nginx documentation](https://nginx.org/en/docs/http/configuring_https_servers.html).

The certificate chain must be installed to `/etc/nginx/ssl/telemetry.cert.pem`
and the private key installed to `/etc/nginx/ssl/telemetry.key.pem`.

If the certificates are not preinstalled, the `deploy.sh` script will simply
comment out TLS-related nginx configuration. Specifically, it will comment out
the `listen 443 ssl`, `ssl_certificate`, `ssl_certificate_key`,
`ssl_protocols`, and `ssl_ciphers` directives.

### TID configuration

For collector TID configuration see details [here](collector/)


## Telemtryui

For more details about `telemetryui` and REST API click [here](telemetryui/)

## Collector

For more details about `collector` click [here](collector/)

## Software License

The telemetrics-backend project is licensed under the Apache License, Version
2.0. The full license text is found in the LICENSE file, and individual source
files contain the boilerplate notice described in the appendix of the LICENSE
file.
