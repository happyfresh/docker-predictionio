FROM kahirul/predictionio-dep

MAINTAINER Khairul

ENV PIO_VERSION=0.10.0-incubating \
    SPARK_VERSION=1.6.3 \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    BUILD_SRC=/root/pio-build-dir

ENV PIO_HOME=/root/PredictionIO-${PIO_VERSION}
ENV PATH=${PIO_HOME}/bin:$PATH

WORKDIR $BUILD_SRC

RUN mkdir -p /${PIO_HOME}/vendors \
    && mkdir -p /root/files \
    && apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends curl openjdk-8-jdk unzip supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN curl -O http://apache.repo.unpas.ac.id/incubator/predictionio/${PIO_VERSION}/apache-predictionio-${PIO_VERSION}.tar.gz \
    && tar -xvzf apache-predictionio-${PIO_VERSION}.tar.gz -C $BUILD_SRC \
    && rm apache-predictionio-${PIO_VERSION}.tar.gz \
    && cd apache-predictionio-${PIO_VERSION} \
    && ./make-distribution.sh

RUN tar zxvf apache-predictionio-${PIO_VERSION}/PredictionIO-${PIO_VERSION}.tar.gz -C /root/
RUN rm -r apache-predictionio-${PIO_VERSION}

COPY conf/pio-env.sh ${PIO_HOME}/conf/pio-env.sh
COPY engines/ /root/
COPY files/ /root/files/

RUN curl -O http://d3kbcqa49mib13.cloudfront.net/spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
    && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop2.6.tgz -C ${PIO_HOME}/vendors \
    && rm spark-${SPARK_VERSION}-bin-hadoop2.6.tgz \
    && curl -o ${PIO_HOME}/lib/postgresql-42.0.0.jar https://jdbc.postgresql.org/download/postgresql-42.0.0.jar \
    && chmod +x /root/files/start.sh

EXPOSE 7070 8000

CMD ["/root/files/start.sh"]
