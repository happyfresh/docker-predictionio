FROM kahirul/predictionio-dep

MAINTAINER Khairul

ENV PIO_VERSION=0.11.0-incubating \
    SPARK_VERSION=2.1.1 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    BUILD_SRC=/root/pio-build-dir

ENV PIO_HOME=/root/PredictionIO-${PIO_VERSION}
ENV PATH=${PIO_HOME}/bin:$PATH

WORKDIR $BUILD_SRC

COPY engines/ /root/
COPY files/ /root/files/

RUN mkdir -p ${PIO_HOME}/vendors \
    && mkdir -p /root/files \
    \
    && curl -OL https://github.com/kahirul/PredictionIO-Bin/raw/master/PredictionIO-${PIO_VERSION}.tar.gz \
    && tar xzvf PredictionIO-${PIO_VERSION}.tar.gz -C /root/ \
    && rm PredictionIO-0.11.0-incubating.tar.gz \
    \
    && curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    && tar xvzf spark-${SPARK_VERSION}-bin-hadoop2.7.tgz -C ${PIO_HOME}/vendors \
    && rm spark-${SPARK_VERSION}-bin-hadoop2.7.tgz \
    \
    && curl -o ${PIO_HOME}/lib/postgresql-42.0.0.jar https://jdbc.postgresql.org/download/postgresql-42.0.0.jar \
    && chmod +x /root/files/start.sh

COPY conf/pio-env.sh ${PIO_HOME}/conf/pio-env.sh

EXPOSE 7070 8000

CMD ["/root/files/start.sh"]
