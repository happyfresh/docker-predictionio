FROM ubuntu
MAINTAINER Khairul

ENV PIO_VERSION="0.11.0" \
    SPARK_VERSION="2.1.0" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    BUILD_SRC=/root/pio-build-dir

ENV PIO_HOME /root/PredictionIO-${PIO_VERSION}-incubating
ENV PATH=${PIO_HOME}/bin:$PATH

RUN mkdir -p ${PIO_HOME}/vendors \
    && mkdir -p ${BUILD_SRC} \
    && apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk unzip supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O http://apache.repo.unpas.ac.id/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && tar -xvzf apache-predictionio-${PIO_VERSION}-incubating.tar.gz -C ${BUILD_SRC} \
    && rm apache-predictionio-${PIO_VERSION}-incubating.tar.gz \
    && cd ${BUILD_SRC} \
    && ./make-distribution.sh

RUN tar zxvf PredictionIO-${PIO_VERSION}-incubating.tar.gz -C /root/

COPY conf/pio-env.sh ${PIO_HOME}/conf/pio-env.sh
COPY engines/ /root/

RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -C ${PIO_HOME}/vendors \
    && rm spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && curl -o ${PIO_HOME}/lib/postgresql-42.0.0.jar https://jdbc.postgresql.org/download/postgresql-42.0.0.jar
