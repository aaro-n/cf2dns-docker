## 使用说明
* 下载[docker-compose-eg.yml](https://raw.githubusercontent.com/aaro-n/cf2dns-docker/main/docker-compose-eg.yml)并重命名为docker-compose.yml。
* 执行`mkdir config`创建配置文件夹。
* 进入`config`文件夹，创建`cf2dns.py`和`cronjob`文件。
## 配置文件说明
* `cf2dns.py`可以从[cf2dns源码仓库](https://raw.githubusercontent.com/ddgth/cf2dns/master/cf2dns.py)下载并按照说明修改，可以将修改后的文件另存为`cf2dns-v4.py`和`cf2dns-v6.py`
* 定时任务`cronjob`
```
52 6-23 * * * /home/www/venv/bin/python /home/www/cf2dns/cf2dns-v4.py 2>&1 | /usr/bin/tee -a /tmp/cf2dns.log
23 7-23 * * * /home/www/venv/bin/python /home/www/cf2dns/cf2dns-v6.py 2>&1 | /usr/bin/tee -a /tmp/cf2dns.log
```
## 定时说明
以`52 6-23 * * * /home/www/venv/bin/python /home/www/cf2dns/cf2dns-v4.py 2>&1 | /usr/bin/tee -a /tmp/cf2dns.log`为例

`52 6-23 * * *`定时任务运行时间，镜像使用的时间时北京时间。

`/home/www/venv/bin/python` 虚拟python环境安装路径。

`/home/www/cf2dns/cf2dns-v4.py` cf2dns脚本文件绝对路径。

`2>&1 | /usr/bin/tee -a /tmp/cf2dns.log` 将cf2dns运行日志输出到/tmp/cf2dns.log，注意必须输出到/tmp/cf2dns.log，否则控制台无法滚动显示cf2dns运行记录，必须通过日志查看。

要根据自身需求修改

## 注意事项
* 要按照说明赋予创建的文件所需的权限，可以通过`docker exec -it cf2dns /bin/sh`进入容器，查看查看运行日志。
* 容器里的时间是北京时间

## 更新日志
24-10-03 主要有以下修改：
   * 将基础镜像切换为Debian
   * 控制台能显示运行日志
   * 将进程管理软件由supervisor改为s6

23-09-09 主要有以下修改：
   * 删除源码文件，每次构建镜像时自动从`ddgth/cf2dns`获取源码。
   * 添加定时任务，每月运行一次镜像构建。
   * 镜像标签除`aaronlee/cf2dns:latest`外，还有`aaronlee/cf2dns:镜像构建时间` 和`aaronlee/cf2dns:源码仓库SHA值前7位`
 构建的镜像已经测试，可以正常运行。
