#!/usr/bin/env bash

function copyArtifact() {
    echo "Getting build result from Github..."

    ENGINE_DIR=/root/engines/recommender-incubating
    mkdir -p $ENGINE_DIR

    TEMP_DIR=/tmp/recommender
    mkdir -p $TEMP_DIR
    cd $TEMP_DIR


    curl -LO https://github.com/kahirul/PIO-Model/archive/${PIO_ENVIRONMENT}.zip
    unzip ${PIO_ENVIRONMENT}.zip
    rm ${PIO_ENVIRONMENT}.zip

    cp -r PIO-Model-${PIO_ENVIRONMENT}/* $ENGINE_DIR/
    rm -fr PIO-Model-${PIO_ENVIRONMENT}

    echo "Done"
}

copyArtifact

/usr/bin/supervisord -n -c /root/files/supervisord.conf
