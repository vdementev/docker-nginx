FROM alpine:3.16

RUN apk update && \
  apk upgrade && \
  apk add --no-cache \
  curl \
  nginx \
  nginx-mod-http-brotli \
  tzdata \
  && rm -rf /var/cache/apk/ \
  && rm -rf /root/.cache \
  && rm -rf /tmp/* \
  && mkdir /nginx-fcgi-cache \
  && mkdir /nginx-proxy-cache \
  && mkdir /etc/nginx/servers

COPY nginx.conf /etc/nginx/nginx.conf
COPY fastcgi.conf /etc/nginx/fastcgi.conf

WORKDIR /app

HEALTHCHECK --interval=5s --timeout=1s \
  CMD curl -f http://127.0.0.1:8080/ping/ || exit 1

ENTRYPOINT ["nginx", "-g", "daemon off;"]