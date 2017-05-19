#!/usr/bin/env bash

function copyArtifact() {
    echo "Getting build result from Github..."

    PIO_ENVIRONMENT=master

    TEMP_DIR=/tmp/recommender
    mkdir -p $TEMP_DIR
    cd $TEMP_DIR

    curl https://github.com/kahirul/PIO-Model/archive/${PIO_ENVIRONMENT}.zip
    unzip ${PIO_ENVIRONMENT}.zip
    rm ${PIO_ENVIRONMENT}.zip

    cp -r PIO-Model-${PIO_ENVIRONMENT}/* /root/engines/recommender-incubating/
    rm -fr PIO-Model-${PIO_ENVIRONMENT}

    echo "Done"
}

copyArtifact

/usr/bin/supervisord -n -c /root/files/supervisord.conf
