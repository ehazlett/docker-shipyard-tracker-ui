FROM debian:jessie
RUN apt-get update && apt-get install -y nginx \
    apache2-utils
COPY nginx.conf /etc/nginx.conf
COPY run.sh /usr/local/bin/run
COPY grafana /app
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/run"]
CMD [""]
