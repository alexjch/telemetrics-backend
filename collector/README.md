# Collector

## `collector` operation

The `collector` app is an ingestion app that handles POST requests to `/`
or `/v2/collector` at the web server location where telemetrics-backend has
been installed. The requests are analyzed to make sure required header fields
are present and that values are correct.

Generally, the POST requests are sent by probes from the telemetrics-client,
since these probes use the client library, libtelemetry, to create well-formed
records capable of being processed by telemetrics-backend.

At minimum, make sure that your telemetrics-client configuration in
`/etc/telemetrics/telemetrics.conf` specifies the correct server URL for the
`server` config option. For example, if telemetrics-backend is hosted at
`example.com`, the client config should contain `server=http://example.com/` or
`server=http://example.com/v2/collector`.


## Configuring the `collector` TID

The `collector` requires a Telemetry ID (TID) header value set with the HTTP
header `X-Telemetry-TID`. The telemetrics-client daemon adds this header to
telemetry records, and its default value is used for identifying records from
Clear Linux OS systems.

However, when you are deploying your own instance of telemetrics-backend and
have deployed telemetrics-client to systems configured to send records to this
instance, it is recommended to generate your own random TID (e.g. using the
`uuidgen` program). Once you have generated a TID, the following steps are needed:

* Configure telemetrics-client to add this TID to records by modifying the
  `tidheader` value in `/etc/telemetrics/telemetrics.conf` on systems sending
  the telemetry data to your `collector`.
* Configure your `collector` app to accept records with this TID by modifying
  `collector/collector/config.py`.

## Configuring record retention time

The `collector` app uses the uWSGI cron interface to purge records in the
database on a daily basis that are older than a certain age. By default, a
record will only be kept in the database for 5 weeks (starting from the
timestamp the `collector` received the record). To modify the retention
time, update the `MAX_WEEK_KEEP_RECORDS` value in
`collector/collector/config.py` after installation, and restart
uWSGI for the new setting to take effect.

