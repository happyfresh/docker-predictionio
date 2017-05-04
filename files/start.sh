 #!/usr/bin/env bash

prepare_engine() {
    CWD=${PWD}
    RECS_ENGINES=/root/engines/recommender-0.4.0
    cd $RECS_ENGINES

    app_count=`pio app list | grep HFRecommender | wc -l`
    if [ $app_count -eq 0 ]; then
        echo "App not found. Create them first and build the engine"
        exit 1
    fi

    # Start supervisord and services
    /usr/bin/supervisord -n -c /root/files/supervisord.conf
}

prepare_engine
