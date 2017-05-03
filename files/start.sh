#!/bin/bash -xe

prepare_engine() {
    CWD=${PWD}
    RECS_ENGINES=${CWD}root/engines/recommender-0.4.0
    cd $RECS_ENGINES

    pio build --verbose
    pio train
}

prepare_engine

# Start supervisord and services
/usr/bin/supervisord -n -c /root/files/supervisord.conf
