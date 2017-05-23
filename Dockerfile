FROM kahirul/predictionio-base

MAINTAINER Khairul

COPY files/ /root/files/
RUN chmod +x /root/files/start.sh

EXPOSE 7070 8000

CMD ["/root/files/start.sh"]
