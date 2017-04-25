#!/usr/bin/env bash
#
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Copy this file as pio-env.sh and edit it for your site's configuration.
# PredictionIO Main Configuration
#
# This section controls core behavior of PredictionIO. It is very likely that
# you need to change these to fit your site.

# SPARK_HOME: Apache Spark is a hard dependency and must be configured.
SPARK_HOME=$PIO_HOME/vendors/spark-1.6.3-bin-hadoop2.6

POSTGRES_JDBC_DRIVER=$PIO_HOME/lib/postgresql-42.0.0.jar

# Filesystem paths where PredictionIO uses as block storage.
PIO_FS_BASEDIR=$HOME/.pio_store
PIO_FS_ENGINESDIR=$PIO_FS_BASEDIR/engines
PIO_FS_TMPDIR=$PIO_FS_BASEDIR/tmp

# PredictionIO Storage Configuration
# http://predictionio.incubator.apache.org/system/anotherdatastore/

# Storage Repositories

# Default is to use PostgreSQL
PIO_STORAGE_REPOSITORIES_METADATA_NAME=pio_meta
PIO_STORAGE_REPOSITORIES_METADATA_SOURCE=PGSQL

PIO_STORAGE_REPOSITORIES_EVENTDATA_NAME=pio_event
PIO_STORAGE_REPOSITORIES_EVENTDATA_SOURCE=PGSQL

PIO_STORAGE_REPOSITORIES_MODELDATA_NAME=pio_model
PIO_STORAGE_REPOSITORIES_MODELDATA_SOURCE=PGSQL

# Storage Data Sources

PIO_STORAGE_SOURCES_PGSQL_TYPE=jdbc
PIO_STORAGE_SOURCES_PGSQL_URL=jdbc:postgresql://$PG_HOST:5432/$DB_NAME
PIO_STORAGE_SOURCES_PGSQL_USERNAME=$PG_USER
PIO_STORAGE_SOURCES_PGSQL_PASSWORD=$PG_PASS
