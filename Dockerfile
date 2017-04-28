FROM ubuntu
MAINTAINER Khairul

ENV PIO_VERSION="0.11.0-incubating" \
    PIO_SCALA_VERSION="2.10.5" \
    PIO_SPARK_VERSION="2.1.0" \
    PIO_HADOOP_VERSION="2.7.3" \
    PIO_ELASTICSEARCH_VERSION="5.3.2" \
    JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    BUILD_SRC=/root/pio-build-dir \
    JVM_OPTS="-Dfile.encoding=UTF8 -Xms2048M -Xmx2048M -Xss8M -XX:MaxPermSize=512M -XX:ReservedCodeCacheSize=256M"

ENV PIO_HOME /root/PredictionIO-${PIO_VERSION}
ENV PATH=${PIO_HOME}/bin:$PATH

RUN mkdir -p ${PIO_HOME}/vendors \
    && mkdir -p ${BUILD_SRC} \
    && apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk unzip supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O http://apache.repo.unpas.ac.id/incubator/predictionio/${PIO_VERSION}/apache-predictionio-${PIO_VERSION}.tar.gz \
    && tar -xvzf apache-predictionio-${PIO_VERSION}.tar.gz -C ${BUILD_SRC} \
    && rm apache-predictionio-${PIO_VERSION}.tar.gz \
    && cd ${BUILD_SRC} \
    && ./make-distribution.sh \
        -Dscala.version=$PIO_SCALA_VERSION \
        -Dspark.version=$PIO_SPARK_VERSION \
        -Dhadoop.version=$PIO_HADOOP_VERSION \
        -Delasticsearch.version=$PIO_ELASTICSEARCH_VERSION

RUN tar zxvf PredictionIO-${PIO_VERSION}.tar.gz -C /root/

COPY conf/pio-env.sh ${PIO_HOME}/conf/pio-env.sh
COPY engines/ /root/

RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${PIO_SPARK_VERSION}-bin-hadoop2.7.tgz \
    && tar -xvzf spark-${PIO_SPARK_VERSION}-bin-hadoop2.7.tgz -C ${PIO_HOME}/vendors \
    && rm spark-${PIO_SPARK_VERSION}-bin-hadoop2.7.tgz \
    && curl -o ${PIO_HOME}/lib/postgresql-42.0.0.jar https://jdbc.postgresql.org/download/postgresql-42.0.0.jar

EXPOSE 7070 8000
