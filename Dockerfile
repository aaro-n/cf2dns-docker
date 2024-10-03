FROM debian:latest

# 准备运行环境
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    git \
    cron \
    libcap2 \
    python3 \
    python3-pip \
    python3-venv \
    tzdata \
    s6 execline  \
    coreutils && \
    apt-get purge -y systemd && \
    apt-get clean &&  \
    rm -rf /var/cache/apt/* && \
    groupadd -r www && useradd -r -g www www && \
    # 设置时区为北京时间
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    # Clone cf2dns
    git clone https://github.com/ddgth/cf2dns.git /home/www/cf2dns && \
    # 创建 s6 服务目录
    mkdir -p /etc/s6/services

# 复制 s6 服务配置
COPY config/s6/ /etc/s6/services/

# 复制 cron 任务文件
COPY config/cronjob /home/www/cronjob
COPY config/cronjob /etc/cron.d/cronjob

# 创建虚拟环境并安装依赖
RUN python3 -m venv /home/www/venv && \
    /home/www/venv/bin/pip install --upgrade pip && \
    /home/www/venv/bin/pip install --no-cache-dir -r /home/www/cf2dns/requirements.txt && \
    # 设置权限
    chown -R www:www /home/www/ && \
    chmod -R +x /etc/s6/services/* && \
    find /etc/s6/services -name run -exec chmod +x {} \; && \
    # 设置 cron 任务文件的权限
    chmod 0644 /etc/cron.d/cronjob && \
    crontab /etc/cron.d/cronjob 

# Add application
WORKDIR /home/www/

# 使用 s6 启动
ENTRYPOINT ["/usr/bin/s6-svscan", "/etc/s6/services"]
