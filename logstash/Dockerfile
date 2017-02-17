FROM logstash
MAINTAINER chvugrin@microsoft.com

# Logstash config
COPY conf/logstash.conf /logstash/config/logstash.conf

CMD ["-f","/logstash/config/logstash.conf"]
