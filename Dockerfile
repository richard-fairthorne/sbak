FROM alpine
COPY * /sbakinst/
RUN cd /sbakinst/ && ./install.sh && apk --no-cache add rsync

CMD /usr/local/bin/sbak
