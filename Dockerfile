FROM kahirul/predictionio-builder

MAINTAINER Khairul

COPY files/ /root/files/
RUN chmod +x /root/files/start.sh

CMD ["/root/files/start.sh"]
