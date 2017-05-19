FROM kahirul/predictionio-base

MAINTAINER Khairul

RUN apt-get update \
    && apt-get install -y --auto-remove --no-install-recommends git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY builder.sh /root/builder.sh
RUN chmod +x /root/builder.sh

EXPOSE 4040 6066 7070 7071 7077 8000 9000

CMD ["/root/builder.sh"]
