#!/usr/bin/env bash

function copyArtifact() {
    echo "Getting build result from Github..."

    ENGINE_ROOT=/root/engines
    ENGINE_DIR=${ENGINE_ROOT}/${PIO_ENVIRONMENT}/recommender-incubating
    mkdir -p $ENGINE_DIR

    TEMP_DIR=/tmp/recommender
    mkdir -p $TEMP_DIR
    cd $TEMP_DIR

    curl -o Engines.zip -L https://github.com/happyfresh/Engines/archive/${PIO_ENVIRONMENT}.zip
    unzip Engines.zip

    curl -o Model.zip -L https://github.com/kahirul/PIO-Model/archive/${PIO_ENVIRONMENT}.zip
    unzip Model.zip

    cp -r Engines-${PIO_ENVIRONMENT}/recommender-incubating/* $ENGINE_DIR/
    cp -r PIO-Model-${PIO_ENVIRONMENT}/* $ENGINE_DIR/
    rm -fr PIO-Model-${PIO_ENVIRONMENT} Engines-${PIO_ENVIRONMENT} Engines.zip Model.zip

    ln -s $ENGINE_DIR $ENGINE_ROOT/recommender-incubating

    echo "Done"
}

copyArtifact

/usr/bin/supervisord -n -c /root/files/supervisord.conf
