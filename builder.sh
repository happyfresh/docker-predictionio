#!/usr/bin/env bash

ENGINE_ROOT=/root/engines
mkdir -p $ENGINE_ROOT

PIO_ENVIRONMENT_DIR="$ENGINE_ROOT/$PIO_ENVIRONMENT"

function prepareGit() {
    git config --global user.name "CLI Robot"
    git config --global user.email "mntbtq@gmail.com"
}

function environmentIsValid() {
    case $PIO_ENVIRONMENT in
        production|staging|sandbox-carbon) echo "Found: $PIO_ENVIRONMENT";;
        *)
            echo "Invalid environment: $PIO_ENVIRONMENT"
            exit 1;;
    esac
}

function getEngine() {
    environmentIsValid

    mkdir -p $PIO_ENVIRONMENT_DIR
    cd $PIO_ENVIRONMENT_DIR

    curl -LO https://github.com/happyfresh/Engines/archive/${PIO_ENVIRONMENT}.zip
    unzip ${PIO_ENVIRONMENT}.zip
    rm ${PIO_ENVIRONMENT}.zip

    if [[ -d "recommender-incubating" ]]; then
        date=`date +%Y%m%d-%H%M%S`
        mv recommender-incubating{,-$date}
    fi

    cp -r Engines-${PIO_ENVIRONMENT}/recommender-incubating .
    rm -fr Engines-${PIO_ENVIRONMENT}
}

function train() {
    getEngine

    cd "$PIO_ENVIRONMENT_DIR/recommender-incubating"

    pio build --verbose
    pio train -- --driver-memory 5G --executor-cores 3 --executor-memory 5G
}

function pushTrainedResult() {
    train
    prepareGit

    cd $PIO_ENVIRONMENT_DIR

    git clone https://github.com/kahirul/PIO-Model.git
    cd PIO-Model

    CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`
    if [ $CURRENT_BRANCH != "master" ]; then
        git checkout master
    fi

    git rev-parse --verify $PIO_ENVIRONMENT
    result=$?
    if [ $result -ne 0 ]; then
        git checkout -b $PIO_ENVIRONMENT
    else
        git checkout $PIO_ENVIRONMENT
    fi

    cp -r $PIO_ENVIRONMENT_DIR/recommender-incubating/model .
    cp -r $PIO_ENVIRONMENT_DIR/recommender-incubating/target .

    git add .
    git commit -m "Push build result"

    git push https://mntbtq:${GIT_ROBOT_PUSH_KEY}@github.com/kahirul/PIO-Model.git --all
}

pushTrainedResult
