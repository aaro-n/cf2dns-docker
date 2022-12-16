## 使用说明
* 下载[docker-compose-text.yml](https://raw.githubusercontent.com/aaro-n/cf2dns-docker/main/docker-compose-text.yml)并重命名为docker-compose.yml。
* 执行`mkdir config`创建配置文件夹。
* 进入`config`文件夹，创建`cf2dns.py`和`cron.sh`文件。
## 配置文件说明
* `cf2dns.py`可以从[cf2dns源码仓库](https://raw.githubusercontent.com/ddgth/cf2dns/master/cf2dns.py)下载并按照说明修改，修改后请执行命令`chmod 777 cf2dns.py`，赋予其权限。
* `cron.sh`是执行定时任务的脚本，创建后请执行`chmod 777 cron.sh`和`chmod +x cron.sh`，赋予其执行权限。
* 定时任务源码
```
#!/usr/bin/env sh
/bin/echo "37 22 * * * /usr/bin/python3 /home/www/cf2dns/cf2dns.py" > /etc/crontabs/nobody 
```
要根据自身需求修改
## 注意事项
要按照说明赋予创建的文件所需的权限，可以通过`docker exec -it cf2dns /bin/sh`进入容器，查看查看运行日志。
