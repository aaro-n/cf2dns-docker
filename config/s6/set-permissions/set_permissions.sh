#!/bin/bash

# 检查标志文件是否存在
if [ ! -f /tmp/cf2dns_initialized ]; then
    # 赋予执行权限
    chmod +x /home/www/cf2dns/cf2dns.py
    chmod +x /home/www/cf2dns/cf2dns-v4.py
    chmod +x /home/www/cf2dns/cf2dns-v6.py

    # 创建标志文件
    touch /tmp/cf2dns_initialized
fi
