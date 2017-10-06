

# linux复习整体思路

----------

- history 补全
- alias
- 输入输出重定向
- 管道
- 变量
- 环境变量
- 位置参数变量
- 预定义变量
- 数值运算
- 字符串处理(cut/printf/awk/sed)
- 正则
- 条件判断 if,case,for,while

# 从磁盘到操作系统
- 磁盘结构(raid)
- MBR分区
- 格式化(文件系统)(inode/block)
- 安装os
- 优化os
- 安装rpm(数据/日志+服务管理)



## 一个rpm的生命周期:
- 服务的分类
- 安装
- (数据/日志+服务管理)
  - 进程管理
  - 任务管理
  - 定时任务


## 服务分类
- rpm包管理
- 进程管理
- 工作管理
- 系统资源查看
- 定时任务

## 日志管理
- rsyslog
- 日志滚动
- 启动管理
  - 运行级别
  - 启动过程
  - grub配置/加密
  - 系统修复
备份恢复


## 文件管理
- 文件
- 目录
- 链接
- 权限管理
- 文件搜索

## 用户和用户组
- 权限管理:
  - ACL
  - 特殊权限:SUID/SGID
  - chattr
  - sudo

----------


## 文件权限-面试
```
umask: 022   (666-022)644
             (777-022)755

umask  045(所有奇数位都要+1)-->046
                             777 - 046 = 731
                             666 - 046 = 620
```

## 给某flie.txt所有用户+x
```
chmod a+x file.txt  #而不是chmod o+x file.txt
```





# mysql for win

## 示例sql语句
```
create databse bbs;

create table users( user  varchar(50),pwd varchar(50));

desc users;

select * from users;

insert into users values("maotai",'123456');

delete from users where user='maotai';

update users set pwd='123' where user="maotai";

```



- 下载安装
MySQL Community Server 5.7.16 
http://dev.mysql.com/downloads/mysql/
```
cd D:\Program Files\mysql-5.7.19-winx64\bin
mysqld --initialize-insecure
```
- 添加path
```
D:\Program Files\mysql-5.7.19-winx64\bin
```
 
- 启动MySQL服务

```
"D:\Program Files\mysql-5.7.19-winx64\bin\mysqld" --install

net start mysql

mysql -u root -p


"D:\Program Files\mysql-5.7.19-winx64\bin\mysqld" --remove
net stop mysql
```

- 字符集
```
SET NAMES 'utf8'; 
SET character_set_client = utf8;
SET character_set_connection = utf8;
SET character_set_database = utf8;
SET character_set_results = utf8;
SET character_set_server = utf8;

SET collation_connection = utf8_general_ci;
SET collation_database = utf8_general_ci;
SET collation_server = utf8_general_ci;

缺陷是: 登出后设置的就失效了.
```


- 另一种配置文件持久化:
```
D:\Program Files\mysql-5.7.19-winx64\my.ini
[mysqld]
character-set-server=utf8 
collation-server=utf8_general_ci 

[mysql]
default-character-set = utf8

[mysql.server]
default-character-set = utf8


[mysqld_safe]
default-character-set = utf8


[client]
default-character-set = utf8

参考: http://blog.csdn.net/u013474104/article/details/52486880

show variables like '%storage_engine%';

show VARIABLES like '%max_allowed_packet%';
show variables like '%storage_engine%';
show variables like 'collation_%';
show variables like 'character_set_%';
```
- mysql生产配置参考
https://www.teakki.com/p/57e227aea16367940da625f8



- 配置文件查找先后顺序
```
C:\ProgramData\MySQL\MySQL Server 5.7\my.ini
C:\windows\my.ini
C:\my.ini
E:\dev\mysql57\my.ini

通过配置文件设置字符集

default-storage-engine = innodb
innodb_file_per_table = 1
character-set-server = utf8
collation-server = utf8_general_ci
init-connect = 'SET NAMES utf8'
```

- 查看建表语句
```
show create database test;
```

- 查看权限
```
show grants
```


## ubuntu16阿里云源

- 源优化
```
cp /etc/apt/sources.list /etc/apt/sources.list_backup
 
cat >> /etc/apt/sources.list <<EOF
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse
EOF

apt-get update

```

- pip优化
```
apt-get install python-pip -y
cd
mkdir ~/.pip
cat >> .pip/pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
 
[install]
trusted-host=mirrors.aliyun.com
EOF
```

- 时间优化
```
rm -rf /etc/localtime && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && ntpdate time-nw.nist.gov

```

- vim优化
```
git clone https://github.com/chxuan/vimplus.git
cd ./vimplus
sudo ./install.sh
```


# 黄色不伤害眼睛的rgb
- 255 251 232
- FFFBE8


## github文件夹灰色
[参考](http://blog.csdn.net/xiaozhuxmen/article/details/51536967)

```
git rm -r --cached
```

## 存放一些经常遇到的脚本/工具优化配置/一些kownledge



## gitbash设置
- 最终效果
![](http://ww1.sinaimg.cn/large/9e792b8fgy1fj7x2v8smcj20w90hzjtj)

- 背景色前景色设置
![](http://ww1.sinaimg.cn/large/9e792b8fgy1fj7x1c7d9aj20nl0g2goc)
![](http://ww1.sinaimg.cn/large/9e792b8fgy1fj7x2hukvsj20ma0f4tbb)

- 修改gitbash提示符
```
C:\Program Files\Git\etc\profile.d\git-prompt.sh
C:\Program Files\Git\etc\vimrc
```

[相关代码](https://github.com/lannyMa/scripts)

## env配置文件
```
•    ~/.bash_profile：用户每次登录时执行
•    ~/.bashrc：每次进入新的Bash环境时执行
•    ~/.bash_logout：用户每次退出登录时执行
```

## sedmail发邮件配置
```
yum install sendmail -y
cat >>/etc/mail.rc<<EOF

set from=xxx@tt.com
set smtp=smtp.exmail.qq.com
set smtp-auth-user=xxx@tt.com
set smtp-auth-password=123456
set smtp-auth=login
EOF
source /etc/mail.rc
```
- 发消息
```
echo "test"| mail -s "邮件标题" iher@foxmail.com
```
- 发文件
```
mail -s "邮件标题" iher@foxmail.com < /etc/passwd
```
- 发附件
```
mail -s "邮件标题" -a /var/log/messages iher@Foxmail.com < /etc/passwd
```

- 邮件相关目录
```
C6 postfix /var/spool/postfix/maildrop
C5 sedmail /var/spool/clientmqueue
```
注: centos6.5已经不自动安装sendmail了所以没必要走这一步优化

- 写脚本自动清理邮箱

```
mkdir -p /server/scripts

cat /root/shell/spool_clean.sh

#!/bin/sh
find/var/spool/clientmqueue/-type f -mtime +30|xargs rm-f
```

```
echo '*/30 * * * * /bin/sh /server/scripts/spool_clean.sh >/dev/null 2>&1'>>/var/spool/cron/root
```

## locale字符集-面试
- 查本地支持的所有字符集
```
# locale -a
```
- 查当前使用的字符集
```
locale #调取了/etc/sysconfig/i18n
```
- 系统默认字符集:
```
export LANG='zh_CN.UTF-8'
```

## 监控网卡实时流量
- 监控网卡流量历史流量
```
yum install sysstat
sar -n DEV 1 5  #1s监控1次,共监控5次.
sar -n DEV  (-n network)
```
```
watch more /proc/net/dev
```


## find干掉超过10天的
- mtime 10天内  10天外
```
find . -mtime +10 -exec rm -rf {} \;
find . -mtime +10|xargs rm -f
```
![](http://ww1.sinaimg.cn/large/9e792b8fgy1fj7blirtkaj20gc06lwf7)



## 测试udp端口是否通-面试

```
$ nc -vuz 192.168.6.6 53
Connection to 192.168.6.6 53 port [udp/domain] succeeded!
```
实际使用时可以只用-u参数，-u代表udp协议 ，-v代表详细模式，-z代表只监测端口不发送数据。


## 使用nc+tar传文件
- client发交互式到服务器的console
```
nc -l -u 8021             --server #可以配置tcpdump -i eth0 port 8021 -nnv抓包
nc -u 192.168.6.52 8021   --client #交互式发送消息
```
- client发文件到服务端console
```
server: nc -l -u 8021
client: nc -u 192.168.6.52 8021 < /etc/hosts
```
- tar+nc传文件
```
server： tar -cf - /home/database  | nc -l 5677 #将/home/database文件
client： nc 192.168.6.52 5677 | tar -xf -       #传到client的当前目录
```

## 生成密码：
```
openssl rand -hex 8
```

```
$mkpasswd -l 16 -s 2
3Hte^bd-pkylSbf7
```

```
echo "ansible"|passwd --stdin ansible #centos7改用户密码
```

## fstab挂载

- fstab挂载硬盘
```
cat /etc/fstab
需挂载的设备                挂载点  fs类型   参数        备份 检查
/dev/mapper/centos-data    /data  xfs      defaults    0 0
```
- nfs挂载(centos7放fstab)
```
192.168.8.68:/data/backup/no75/confluence/data /data/confluence/  nfs     defaults        0 0
```
- nfs挂载(centos6放/etc/rc.local里即可)
```
/usr/bin/mount -t nfs 192.168.8.68:/data/owncloud /data/owncloud-192.168.8.68
```

- nfs服务端设置:
```
/data/backup/no75/confluence/data 192.168.8.0/24(rw,sync,no_root_squash)
```

- (磁盘扩容)关于tmpfs空间满，会影响其中的服务使用吗

```
Filesystem Size Used Avail Use% Mounted on
/dev/sda1 32G 1.3G 29G 5% /
tmpfs 16G 16G 0 100% /dev/shm
 
mount -o remount,size=18G /dev/shm
```

- 只读mount

```
Mount the file system and make it writeable
mount -uw /
 
Make the filesystem read only again.
mount -ur /
``` 


## date命令小结
- 前一天日期
```
date  +%Y-%m-%d~%H-%M-%S -d "-1 day"
```
```
date  "+%Y-%m-%d %H-%M-%S" -d "-1 day"
```
- 压缩带日期
```
tar zcvf etc_$(date +%F -d "-1 day").tar.gz /etc/
```

## 系统时间优化
- 时区校准
```
rm -rf /etc/localtime && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && ntpdate ntp1.aliyun.com
```
- 设置同步时间
``` 
/user/sbin/ntpdate ntp1.aliyun.com
echo '*/5 * * * * /usr/sbin/ntpdate ntp1.aliyun.com >/dev/null 2 >&1' >>/var/spool/cron/root
```

- 手动修改时间
```
date -s "2016/06/11 22:50"
``` 

## 过滤网卡ip
```
ifconfig eth0|grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}"|sed -n '1p'
ifconfig|sed -n '2p'|sed -r 's#^.*addr:(.*) Bcast.*$#\1#g'
ifconfig|sed -n '2p'|awk -F':' '{print $2}'|awk '{print $1}'
```

## 回车擦除^H
```
echo "stty erase ^H" >>/root/.bash_profile
source /root/.bash_profile
```

## centos7安装nslookup ifconfig
How to install dig, host, and nslookup – bind-utils on CentOS:
```
yum install bind-utils -y [c6使用nslookup]
yum install net-tools -y [c7使用ifconfig]
``` 

## selinux优化
```
setenforce 0
sed -i 's#SELINUX=enforcing#SELINUX=disabled#g' /etc/selinux/config
getenforce
/etc/init.d/iptables stop
```

## 文件描述符优化
```
ulimit -SHn 65535
echo '* - nofile 65536' >>/etc/security/limits.conf
 
echo "* soft nproc 65535" >>/etc/security/limits.conf
echo "* hard nproc 65535" >>/etc/security/limits.conf
echo "* soft nofile 65535" >>/etc/security/limits.conf
echo "* hard nofile 65535" >>/etc/security/limits.conf
```

## 清除系统版本banner
```
> /etc/issuse
>/etc/redhat-release
```

## 添加普通用户并进行sudo授权管理

```
$ useradd sunsky
$ echo "123456"|passwd --stdin sunsky&&history –c
$ visudo # 99gg
在root ALL=(ALL) ALL  #此行下，添加如下内容
sunsky ALL=(ALL) ALL
lanny  ALL=(ALL) ALL=/sbin/mount /mnt/cdrom, /sbin/umount /mnt/cdrom #仅允许他执行这些命令
```

## ssh慢优化
```
\cp /etc/ssh/sshd_config /etc/ssh/sshd_config.ori
sed -i 's#\#UseDNS yes#UseDNS no#g' /etc/ssh/sshd_config
sed -i 's#GSSAPIAuthentication yes#GSSAPIAuthentication no#g' /etc/ssh/sshd_config
/etc/init.d/sshd restart
 

Port 22345
PermitRootLogin no
PermitEmptyPasswords no
UseDNS no
ListenAddress 192.168.138.24
GSSAPIAuthentication no
```
 
## crt设置超时
```
export TMOUT=10
echo "export TMOUT=10" >>/etc/profile
source /etc/profile
```

## vim安装优化
```
yum -y install vim-enhanced
cat >>/etc/vimrc<<a
set nu
set cursorline
set nobackup
set ruler
set autoindent
set vb t_vb=
set ts=4
set expandtab
a
. /etc/vimrc
``` 
 
## rsync安装配置

- rsync server配置(rpm -qa|grep rsync):

```
cat /usr/local/rsync/rsync.conf


uid = root
gid = root
use chroot = no
max connections = 10
strict modes = yes
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsyncd.log
[web]
path = /code/pp100web/target/ROOT
comment = web file
ignore errors
read only = no
write only = no
hosts allow = 192.168.14.132
list = false
uid = root
gid = root
auth users = webuser
secrets file = /usr/local/rsync/rsync.passwd
```

- 重启rsync

```
kill -HUP `cat /var/run/rsyncd.pid`
/usr/bin/rsync --daemon --config=/usr/local/rsync/rsync.conf

ps -ef|grep rsync
```

- 配置允许同步的的客户端
```
vim /usr/local/rsync/rsync.conf
hosts allow = 192.168.14.132,192.168.14.133
```
注意:密码文件统一600,且普通用户为谁,属主即为谁.


 
## java环境变量(附带tomcat)

```
export JAVA_HOME=/usr/local/jdk
export PATH=$JAVA_HOME/bin:$JAVA_HOME/jre/bin:$PATH
export CLASSPATH=.$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib:$JAVA_HOME/lib/tools.jar
export TOMCAT_HOME=/usr/local/tomcat
export CATALINA_BASE="/data/tomcat"
export PATH=/usr/local/mysql/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/jdk1.7.0_45/bin:/root/bin:/usr/local/jdk1.7.0_45/bin:/root/bin
```


## 换源&安装常用软件
```
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo
wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-6.repo
yum clean all
yum makecache
yum install lrzsz ntpdate sysstat dos2unix wget telnet tree -y
```

## 添加定时任务
```
crontab -l
*/5 * * * * /usr/sbin/ntpdate times.windows.com >/dev/null 2>&1
```

## 优化退格键
```
stty erase "^H" #追加到/etc/profile
```
## 优化history:
```
export HISTTIMEFORMAT="%F %T `whoami` "
echo "export HISTTIMEFORMAT="%F %T `whoami` "" >> /etc/profile
```
## 优化message:格式
```
export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });logger "[euid=$(whoami)]":$(who am i):[`pwd`]"$msg";}'
```
 
## 过滤日志
```
cat /etc/salt/master |grep -v "#" | sed '/^$/d'

grep -nir
-i 不区分大小写
-n 显示行号
-r 查找目录, grep -r 'xx' .
```

## kill服务
```
/usr/bin/killall -HUP syslogd
/bin/kill -USR1 $(cat /var/run/nginx.pid 2>/dev/null) 2>/dev/null || :
```
 
## 禁止ping
```
echo "net.ipv4.icmp_echo_ignore_all=1">>/etc/sysctl.conf
tail -1 /etc/sysctl.conf
sysctl -p
echo 1 > /proc/sys/net/ipv4/ip_forward #这样好处可以tab
```

```
sysctl -w net.ipv4.ip_forward=1 #好像没写到/etc/sysctl.conf里
```
 
## sed 在某行（指具体行号）前或后加一行内容
```
sed -i 'N;4addpdf' a.txt
sed -i 'N;4ieepdf' a.txt
sed -i 'N;4a44444444444444444444444444testt' 1.log在第四行后加一行
http://www.361way.com/sed-process-lines/2263.html
```
 

 

## 关闭bell:[需reboot]
```
sed -i 's#^\#set bell-style none#set bell-style none#g' /etc/inputrc
echo "modprobe -r pcspkr" > /etc/modprobe.d/blacklist
```
 
 
## 关掉ctrl+alt+delete关机
```
\cp /etc/init/control-alt-delete.conf /etc/init/control-alt-delete.conf.bak
sed -i 's#exec /sbin/shutdown -r now "Control-Alt-Deletepressed"#\#exec /sbin/shutdown -r now "Control-Alt-Deletepressed"#g'
```
```
yum groupinstall base -y
yum groupinstall core -y
yum groupinstall development libs -y
yum groupinstall development tools -y
```
 
## echo高亮显示
```
echo -e "\033[32m crontab has been added successfully \033[0m"
```

## nfs安装配置
- 服务端&客户端
```
yum install nfs-utils rpcbind -y
```
- 服务端:
```
/etc/init.d/rpcbind start
ps -ef |grep rpc
/etc/init.d/rpcbind status
rpcinfo -p localhost
```

- 服务端配置共享目录
```
echo "/data 10.0.0.0/24(rw,sync,no_root_squash)" >> /etc/exports
chkconfig rpcbind on
chkconfig nfs on
```

- 客户端挂载

```
/etc/init.d/rpcbind start
chkconfig rpcbind on
showmount -e 10.1.1.10
mount -t nfs 10.1.1.10:data /mnt

写到/etc/rc.local里
```
 
## nginx编译安装
- 1.安装依赖
```
yum install pcre pcre-devel openssl openssl-devel –y
```
- 2.添加nginx用户
```
useradd -s /sbin/nologin -M nginx
```
- 3.编译安装
```
./configure --user=nginx --group=nginx --prefix=/usr/local/nginx-1.6.2 --with-http_stub_status_module --with-http_ssl_module
make && make install
echo $?
ln -s /usr/local/nginx-1.6.2 /usr/local/nginx
```

- 4.检查nginx.conf语法

```
/usr/local/sbin/nginx       # -t检查配置文件语法
/usr/local/nginx/sbin/nginx # 启动
```

- 5.添加nginx服务到PATH

```
echo PATH=/application/nginx/sbin/:$PATH >> /etc/profile
source /etc/profile
 
netstat -ntulp |grep nginx
lsof -i:80
curl 192.168.14.151
nginx -s stop
nginx -s reload
```

- 7.nginx反代配置nignx.conf

```
worker_processes auto;
events {
  multi_accept on;
  use epoll;
  worker_connections 51200;
}
error_log stderr notice;

worker_rlimit_nofile 65535;

http {
    include       mime.types;
    default_type  application/octet-stream;
    server_info  off;
    server_tag   off;
    server_tokens  off;
    server_name_in_redirect off;
    client_max_body_size 20m;
    client_header_buffer_size 16k;
    large_client_header_buffers 4 16k;
    sendfile        on;
    tcp_nopush     on;
    keepalive_timeout  65;
    server_tokens on; 
    gzip  on;
    gzip_min_length 1k;
    gzip_buffers 4 16k;
    gzip_proxied   any;
    gzip_http_version 1.1;
    gzip_comp_level 3;
    gzip_types text/plain application/x-javascript text/css application/xml;
    gzip_vary on;
    
    upstream owncloud {
        server 127.0.0.1:8000;
    }
    
    upstream confluence {
        server 127.0.0.1:8090;
    }


    server {
        listen       80;
        server_name  owncloud.maotai.org;
        location / {
            proxy_next_upstream error timeout invalid_header http_500 http_503 http_404 http_502 http_504;
            proxy_pass http://owncloud;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    server {
        listen       80;
        server_name  confluence.maotai.org;
        location / {
            proxy_next_upstream error timeout invalid_header http_500 http_503 http_404 http_502 http_504;
            proxy_pass http://confluence;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    server {
        listen  80;
        server_name status-no189.maotai.org;
        location /nginx_status {
            stub_status on;
            access_log off;
        }
    }
}
```


## logrotate nginx日志切割
```
cat > /etc/logrotate.d/nginx
/usr/local/nginx/logs/*.log {
    daily
    missingok
    rotate 7
    dateext
    compress
    delaycompress
    notifempty
    sharedscripts
    postrotate
        if [ -f /usr/local/nginx/logs/nginx.pid ]; then
            kill -USR1 `cat /usr/local/nginx/logs/nginx.pid`
        fi
    endscript
}
```

## 网卡配置
```
DEVICE=eth0
TYPE=Ethernet
ONBOOT=yes
NM_CONTROLLED=yes
BOOTPROTO=static
IPADDR=192.168.6.28
NETMASK=255.255.255.0
GATEWAY=192.168.6.1
```


## 修改console提示符
- Ubuntu的promote
```
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\u@\h:\w\$"
```
- centos的promote
```
export PS1="[\u@\h \W]\$"
```

## yum安装lamp

- yum安装lamp:
```
yum install -y httpd php php-cli php-common php-pdo php-gd
yum install -y httpd php php-cli php-common php-pdo php-gd mysql mysql-server php-mysql
yum install -y httpd php php-ldap php-gd
```
- php配置:
```
vim /etc/php.ini
729 post_max_size = 16M
946 date.timezone = PRC #(中华人民共和国)
```

## 批量创建用户脚本
```
cat adduser.sh

#!/bin/bash
# Add system user
for ldap in {1..5};do
if id user${ldap} &> /dev/null;then
echo "System account already exists"
else
adduser user${ldap}
echo user${ldap} | passwd --stdin user${ldap} &> /dev/null
echo "user${ldap} system add finish"
fi
done
# chmod +x adduser.sh
# ./adduser.sh
# id user1
uid=502(user1) gid=502(user1) groups=502(user1)
```
 
```
useradd test -u 6000 -g 6000 -s /sbin/nologin -M -d /dev/null
```

## [shell] $*和$@的区别

- 单独的  $*和$@ 没区别
- "$*"和"$@"区别如下

```
[root@node1 ~]# cat test.sh 
#!/bin/sh

for i in "$*";do
echo $i
done
[root@node1 ~]# sh test.sh 1 2 3 4
1 2 3 4

[root@node1 ~]# cat test.sh 
#!/bin/sh

for i in "$@";do
echo $i
done
[root@node1 ~]# sh test.sh 1 2 3 4 5
1
2
3
4
5
```

## [shell] [linux exec与重定向](http://xstarcd.github.io/wiki/shell/exec_redirect.html)

## [shell] [shell学习之变量](http://lovelace.blog.51cto.com/1028430/1211141)

## [shell] 定义列表
- 使用小括号为数组赋值
```a=（1 2 3）```注意: 默认空格隔开

- 为数组b赋值-方法1
```
$ b=(bbs www http ftp)
$ echo ${b[*]}
bbs www http ftp
```

- 打印出第一个和第三个数据项

```
$ echo ${b[0]};echo '*******';echo ${b[2]}
bbs
*******
http
```
注: 记住是小括号，不是大括号


- 为数组b赋值-方法2

```
name=(
alice
bob
cristin
danny
)

for i in "${!name[@]}";do
echo ${name[$i]}
done
```

- 取得数组元素的个数-方法1
```
length=${#array_name[@]}
```

- 取得数组元素的个数-方法2
```
length=${#array_name[*]}
```

- 取得数组单个元素的长度
```
lengthn=${#array_name[n]}
```



优化小结:
一清： 定时清理日志/var/spool/clientsqueue
一精： 精简开机启动服务
一增： 增大文件描述符
两优： linux内核参数的优化、yum源优化
四设：设置系统的字符集、设置ssh登录限制、设置开机的提示信息与内核信息、设置block的大小
七其他：文件系统优化、sync数据同步写入磁盘、不更新时间戳、锁定系统关键文件、时间同步、sudo集权管理、关闭防火墙和selinux
 
 
centos一键优化脚本:
- [细节:](http://oldboy.blog.51cto.com/2561410/1336488) 
- [linux生产服务器有关网络状态的优化措施](http://oldboy.blog.51cto.com/2561410/1184228)
- [linux定时任务Crond之定时任务优化系统案例15](http://oldboy.blog.51cto.com/2561410/1216730)
- 一键脚本:
  - [较简单: ](http://mofansheng.blog.51cto.com/8792265/1710247)
  - [较健全:](http://chocolee.blog.51cto.com/8158455/1424587) 
 
[本文 centos 6.5 优化 的项有18处:](http://www.lvtao.net/server/centos-server-setup.html)
- 1、centos6.5最小化安装后启动网卡
- 2、ifconfig查询IP进行SSH链接
- 3、更新系统源并且升级系统
- 4、系统时间更新和设定定时任
- 5、修改ip地址、网关、主机名、DNS
- 6、关闭selinux，清空iptables
- 7、创建普通用户并进行sudo授权管理
- 8、修改SSH端口号和屏蔽root账号远程登陆
- 9、锁定关键文件系统（禁止非授权用户获得权限）
- 10、精简开机自启动服务
- 11、调整系统文件描述符大小
- 12、设置系统字符集
- 13、清理登陆的时候显示的系统及内核版本
- 14、内核参数优化
- 15、定时清理/var/spool/clientmqueue
- 16、删除不必要的系统用户和群组
- 17、关闭重启ctl-alt-delete组合键
- 18、设置一些全局变量
 
## 优化内核:
```
\cp /etc/sysctl.conf /etc/sysctl.conf.$(date +%F)
cat >>/etc/sysctl.conf<<EOF
net.ipv4.tcp_fin_timeout = 2
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_keepalive_time = 600
net.ipv4.ip_local_port_range = 4000 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 36000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 16384
net.core.netdev_max_backlog = 16384
net.ipv4.tcp_max_orphans = 16384
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
EOF
sysctl -p
```
注: 以下参数是对centos6.x的iptables防火墙的优化，防火墙不开会有提示，可以忽略不理。
如果是centos5.X需要吧netfilter.nf_conntrack替换成ipv4.netfilter.ip
centos5.X为net.ipv4.ip_conntrack_max = 25000000

```
net.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
```
 