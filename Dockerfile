FROM alpine:3.16

# 准备运行环境
RUN apk --no-cache add \
  curl \
   git\
  dcron libcap \
  python3  \
  py3-pip  \
  tzdata \
  supervisor && \
  rm -rf /var/cache/apk/*

# 将代码复制到容器
COPY config/docker-entrypoint.sh /var/docker-entrypoint.sh

# COPY cf2dns /home/www/cf2dns
RUN git clone https://github.com/ddgth/cf2dns.git /home/www/cf2dns

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

COPY config/cron.conf /etc/crontabs/nobody 

COPY config/time /etc/localtime

COPY config/cron.sh /var/cron.sh

# 设置权限及安装依赖
RUN chown -R nobody.nobody /home/www/ && \
  chmod +x /var/docker-entrypoint.sh && \
  chmod +x /var/cron.sh && \
  chown -R nobody.nobody /run && \
  chown -R nobody.nobody /etc/crontabs/nobody && \
  echo "Shanghai/Asia" > /etc/timezone && \
  /usr/bin/pip install -r /home/www/cf2dns/requirements.txt

# Switch to use a non-root user from here on
USER nobody

# Add application
WORKDIR /home/www/

# COPY html /var/www/html  
USER root

Run chown nobody:nobody /usr/sbin/crond && \
    setcap cap_setgid=ep /usr/sbin/crond 

USER nobody

# Let supervisord start nginx & php-fpm
ENTRYPOINT /var/docker-entrypoint.sh

