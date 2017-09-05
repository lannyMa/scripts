更新 2017年9月5日

# 01ansib生产

## 安装包
```
yum install -y libselinux-python
```

## [在通过执行 play脚本的过程中 有步骤结束后 必须重启一下 目标电脑](http://docs.ansible.com/ansible/latest/wait_for_connection_module.html) 

```
- name: Waiting for server to come back
  local_action: wait_for host={{ ansible_host }} port=22 state=started delay=30 timeout=600
  become: no

```

##  关于用户
1,批量创建用用户
```
ansible all -m shell -a 'useradd apps -m -d /home/apps -s /bin/bash -u 2222'
ansible all -m shell -a 'useradd apps -u 2222'
```
检查
```
ansible all -m shell -a "id apps"
```

2.批量修改密码
```
$ ansible all -m shell -a 'echo apps:ABCedf123 | chpasswd' #centos 7
$ ansible all -m shell -a 'echo ABCedf123 | passwd --stdin apps' #centos 6
```

3.批量做互信
```
$ su - apps && ssh-keygen
$ ansible web -m authorized_key -a "user=apps state=present key=\"{{ lookup('file', '/home/apps/.ssh/id_rsa.pub') }}\"" -k

```

## 过滤setup内容
```
ansible 192.168.14.132 -m setup -a 'filter=ansible_all_ipv4_addresses' -o

ansible 192.168.14.132 -m setup
ansible 192.168.14.132 -m setup -a 'filter=ansible_all_ipv4_addresses'
```

playbook的过滤: 返回的ansible_eth0是字典.可以过滤
```
[root@node1 ~]# cat t.yml 
- hosts: 192.168.14.133
  tasks:
    - debug: msg="{{ ansible_eth0['device'] }}"
```
这样就有问题了
```
ansible all -m setup -a "filter=ansible_eth0['device']"
ansible all -m setup -a "filter=ansible_eth0|ipv4"
```

```
- hosts: 192.168.14.132
  tasks:
    - debug: msg="{{ ansible_user_shell }}"
```
这样ok
```
ansible all -m setup -a 'filter=ansible_eth[0-2]'
```
## 修改内核参数
```
# 开启路由转发的功能
- sysctl: name="net.ipv4.ip_forward" value=1 sysctl_set=yes
```

## ansible多线程
ansible在多任务下，推荐使用多进程模式的。其实就是用multiprocess做的多进程池 ！  -f 10  就是limit 10个任务并发。










## 书写格式
```
- hosts: 192.168.14.133
  tasks: 
  - debug: msg="hi1"
  - debug: msg="hi2"

```
也就是很多笔记这样写的原因了.
```
- lineinfile: dest=/etc/selinux/config regexp=^SELINUX= line=SELINUX=enforcing      # 将以“SELINUX”开头的行换成 “SELINUX=enforcing” 
- lineinfile: dest=/etc/sudoers state=absent regexp="^%wheel"                       # 将以 %wheel 开头的行删除
- lineinfile: dest=/etc/hosts regexp='^127\.0\.0\.1' line='127.0.0.1 localhost' owner=root group=root mode=0644
- lineinfile: dest=/etc/httpd/conf/httpd.conf regexp="^Listen " insertafter="^#Listen " line="Listen 8080" # 将以 #Listen 开头行的下面的 以Listen开头的行换成  Listen 8080
- lineinfile: dest=/etc/httpd/conf/httpd.conf insertafter="^#Listen " line="Listen 8080"            # 在 #Listen 开头行的下面的 添加 Listen 8080 新行
- lineinfile: dest=/etc/httpd/conf/httpd.conf regexp="^Listen " insertbefore="^#Listen " line="Listen 8080" # 将以 #Listen 开头行的上面的 以Listen开头的行换成  Listen 8080
- lineinfile: dest=/tmp/testfile line="192.168.1.99 foo.lab.net foo"  # 添加一个新行

```
## 可以写一行
```
  - name: Copy Nginx Software To Redhat Client
    copy: src=nginx-{{ nginx_version }}.tar.gz dest=/tmp/nginx-{{ nginx_version }}.tar.gz owner=root group=root
    when: ansible_os_family == "RedHat" and ansible_distribution_version|int >=6
  - name: Uncompression Nginx Software To Redhat Client
    shell: tar zxf /tmp/nginx-{{ nginx_version }}.tar.gz -C /usr/local/
    when: ansible_os_family == "RedHat" and ansible_distribution_version|int >=6
  - name: Copy Nginx Start Script To Redhat Client
    template: src=nginx dest=/etc/init.d/nginx owner=root group=root mode=0755
    when: ansible_os_family == "RedHat" and ansible_distribution_version|int >=6
  - name: Copy Nginx Config To Redhat Client
    template: src=nginx.conf dest=/usr/local/nginx-{{ nginx_version }}/conf/ owner=root group=root mode=0644
    when: ansible_os_family == "RedHat" and ansible_distribution_version|int >=6
  - name: Copy Nginx Vhost Config to RedHat Client
    template: src=vhost.conf dest=/usr/local/nginx-{{ nginx_version }}/conf/vhost/ owner=root group=root mode=0644
    when: ansible_os_family == "RedHat" and ansible_distribution_version|int >=6
```

## ansible安装zabiix
```
---
  - hosts: "{{ host }}"
    remote_user: "{{ user }}"
    gather_facts: false
    tasks:
        - name: Install the 'Development tools' package group
          yum:
              name: "@Development tools"
              state: present
          tags:
              - Dev_tools
 
        - name: Install packages
          yum: state=present name={{ item }}
          with_items:
              - gcc
              - gcc-c++
              - autoconf
              - automake
              - libxml2-devel
              - sysstat
              - vim
              - iotop
              - unzip
              - htop
              - iotop
              - strace
              - wget
              - tar
              - libselinux-python
              - rsync
              - rdate
          tags:
              - packages
        - name: Selinux modify disabled
          lineinfile:
              dest: /etc/selinux/config
              regexp: '^SELINUX='
              line: 'SELINUX=disabled'
          tags:
              - testselinux
 
        - name: Modify lineinfile
          lineinfile:
              dest: "{{ item.dest }}"
              state: present
              regexp: "{{ item.regexp }}"
              line: "{{ item.line }}"
              validate: 'visudo -cf %s'
          with_items:
                # - { 
                #   dest: "/etc/zabbix/zabbix_agentd.conf",
                #   regexp: "^Include",
                #   line: "\n\n###Add include\nInclude=/etc/zabbix/zabbix_agentd.conf.d/*.conf" }
              - {
                dest: "/etc/sudoers",
                regexp: "^Defaults    requiretty",
                line: "# Defaults    requiretty" }
          tags:
              - testline
 
        - name: Copy configuration file
          copy:
              src=\'#\'" /etc/init.d/zabbix_agentd",
                dest: "/etc/init.d/zabbix_agentd",
                mode: "0755"}
          tags:
              - testcopy
        - name: Create a directory
          file: path={{ item }} state=directory mode=0750
          with_items:
              - /etc/sudoers.d
          tags:
              - testdir
 
        - name: Looping over Fileglobs
          copy: src={{ item }} dest=/etc/sudoers.d/ owner=root mode=0440
          with_fileglob:
              - /etc/sudoers.d/*
          tags:
              - test_fileglobs
 
        - name: synchronization of src on the control machine to dest on the remote hosts
          synchronize:
            src=\'#\'" /etc/zabbix",
                dest: "/etc/"}
              - {
                src=\'#\'" /usr/local/zabbix",
                dest: "/usr/local/"}
          tags:
              - sys_dir
 
        - name: Ensure two job that runs of crontab
          cron:
            name: "{{ item.name }}"
            minute: "{{ item.minute}}"
            job: "{{ item.job}}"
          with_items:
                - {
                  name: "Time synchronization",
                  minute: "10",
                  job: "/usr/bin/rdate -s 192.168.1.163 > /dev/null 2>&1"}
                - {
                  name: "a job vmstat_output",
                  minute: "1",
                  job: "vmstat 1 10 > /tmp/vmstat_output"}
                - {
                  name: "a job iostat_output",
                  minute: "1",
                  job: "bin/bash /usr/local/zabbix/script/iostat.sh"}
          tags:
              - testcron
 
        - name: Starting zabbix_agentd
          shell: /usr/local/zabbix/script/zabbix_agent.sh
          tags:
              - starting_zabbix_aqentd
 
        - name: Install omsa
          shell: sh /usr/local/zabbix/script/dell.sh
          tags:
              - install_omsa
```

# 02ansible常用

## ansible配置文件
```
yum install -y libselinux-python 
```
```
/etc/ansible/ansible.cfg(主要参数解析,这里主要有两个需要解释的选项)
  library        = /usr/share/ansible  #ansible模块存放位置
  remote_tmp     = $HOME/.ansible/tmp  #客户端临时文件的路径(ansible通过ssh通道在远程主机上根据playbook生成对应的临时python代码,
                                       #然后远程执行这一段临时代码,
                                       #并在执行完成后删除,
                                       #我们在执行的时候可以去客户端执行ps命令看到这个过程的)
/etc/ansible/hosts  (主机配置文件)
  文件的配置格式为
  [definename]
  host or hostname
  #在定义主机的时候,主要需要注意的有
  1) 要以主机名定义客户机的时候要保证server端能够正确的解析这个主机名;
  2) 主机定义的时候可以有很多匹配规则,如web-[a-z].host.com,db-[01:30].host.com;
```

## ansible命令格式

```
#命令格式:
ansible all -m copy -a 'src=/etc/my.cnf dest=/etc/'
```

几个重要参数的含义:
-i    #指定inventory文件(主机定义文件) 栗子: ```ansible -i test all -m ping ```
all   #表示在host文件中定义的所有的主机,可以替换成响应的组名或IP地址

针对于主机可以使用匹配规则(所有的匹配都基于配置文件中的主机)
  IP地址: ansible  192.168.239.132  栗子: ansible -i test 192.168.14.13* -m ping
  IP匹配: ansible  192.168.239.*
  IP匹配: ansible  *
  组匹配: ansible 组名:&hostname     <表示这个组跟其他组的一个主机>
  组匹配: ansible 组名:!hostname     <表示这个组但是出除去这个组的这个主机>
类似的匹配还很多,几乎能想到的匹配都能支持,具体参照http://docs.ansible.com/intro_patterns.html
-m    #指定使用哪个模块,默认采用command模块
-a    #指定模块的参数,每个模块都有相应的模块参数
-u    #指定远端机器的用户


## 查看帮助
列出模块
```
ansible-doc -l
```
查看某一模块详情
```
ansible-doc ping
```
查看参数
```
ansible-doc -s ping 
```
参数
```
ansible all -m ping -o -f 3
```

初始化目录结构
```
ansible-galaxy init test1
```

## 常用模块
```
command   <执行linux命令的>
  #ansible all  -m command -a 'ifconfig'

copy     <实现文件复制>
  #ansible all  -m copy -a 'src=/etc/my.cnf dest=/etc/my.cnf owner=mysql group=mysql' #owner group 可以根据选择自定义的决定要不要指定

file    <实现目录文件权限的修改/创建与删除>
  #ansible all -m file -a 'dest=/etc/rsync.d/secrets  mode=600 owner=root group=root'
  #ansible all -m file -a 'dest=/data/install mode=755 owner=root grou=root state=directory' #创建这个不存在的目录
  #ansible all -m file -a 'dest=/data/tmp state=absent'  #删除这个目录

yum     <使用yum进行软件包的管理>
  #ansible all -m yum -a 'name=httpd state=installed'
  
  更新包:
  ansible all -m yum -a 'name=htop state=latest'

service   <管理linux系统服务>
  #ansible all -m service -a 'name=httpd state=started'
  #state选项主要有:started,stopped,restarted,reloaded

cront      <管理linux计划任务>
  #ansible all -m cron -a 'name="you autoupdate" weekday="2" minute=0 hour=12 user="root" job="/usr/sbin/yum-autoupdate" cron_file=ansible_yum-autoupdate'
  栗子:
  ansible all -m cron -a "name=ntpdate job=ntpdate ntp.pool.ntp.org" hour=*/2 user="root"

```


## 帮助
```
ansible-doc modulename
```

## 常见模块主要参数
```
yum模块中:
关于yum模块有几个状态参数<即state=>
  latest    #安装最新的一个版本
  installed #安装一个包
  removed   #卸载已经安装的软件包
  present   #安装指定的软件包<需要提供软件包的位置>,如
#yum: name=http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm state=present
#yum: name=/usr/local/src/nginx-release-centos-6-0.el6.ngx.noarch.rpm state=present
关于name参数的选项<即name=>


  *       #匹配所有的已经安装的包
#ansible all -m yum -a 'name=* state=latest'  #表示更新所有的已经安装的rpm包


  @       #表示安装软件包组
#ansible all -m yum -a 'name=@Development Tools state=present'
 ```



service模块中:
  #state选项有start,restart,stop
  ```ansible 192.168.14.132 -m service -a "name=nginx state=restarted enabled=yes"  ```
  
  
  
  
cron,模块中:
  name     #相当于计划任务的注释说明,会在crontab里面以注释行的形式出现
  关于时间的定义
   #minute  #指定分的格式:*(每分)(默认值) */5(每五分) 01(01分) 15(15分)
   #hour    #指定小时的格式: *(每小时)(默认值) */5(没五小时) 01(1点) 15(15点)
   #day     #指定天的格式: *(每天)(默认值) */5(每五天) 01(每个的1日)  (0-31)
   #month   #指定月的格式: *(每月)(默认值) */5(每五个月) 01(一月) (1-12)
   #weekday #指定周的日期: *(每周)(默认值) */2(每两周) 1(周一)(1-7)
  reboot  #这个计划任务是否等下次重启后再生效
  user    #指定哪个用户的计划任务


## playbook语法格式


## ansible-playbook

### 资产
+ 存在父子关系
+ 调用资产时,可以给资产传变量

```
192.168.14.132 ansible_ssh_pass="123456"
192.168.14.132 ansible_ssh_pass="123456"

[docker]
192.168.14.13[2:3]

[docker:vars]
ansible_ssh_pass="123456"

[ansible:children]
docker
```

### playbook基本骨架
```
host: web
tasks:
  - name: install nginx
    yum: xxx
  - name: xxx
    shell: xxx
    
```

### 官网playbook几个书写栗子
```
- hosts: node14
  remote_user: root
  tasks:
    - name: xxx
      yum: name=openldap
    - name: xxx
      yum: name=nginx
      
- hosts: node67
  remote_user: root
  tasks: #clean
    - name: Keeps scm-data.tar.gz of 7 days in local
      shell: find /data/backup/scm-data/ -name "*.tar.gz"  -type f -mtime +7|xargs rm -f

```

带 handler
```
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running (and enable it at boot)
    service: name=httpd state=started enabled=yes
  handlers:
    - name: restart apache
      service: name=httpd state=restarted

```


```
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum:
      name: httpd
      state: latest
  - name: write the apache config file
    template:
      src: /srv/httpd.j2
      dest: /etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running
    service:
      name: httpd
      state: started
  handlers:
    - name: restart apache
      service:
        name: httpd
        state: restarted

```
```
---
- hosts: webservers
  remote_user: root
tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
- hosts: databases
  remote_user: root
tasks:
  - name: ensure postgresql is at the latest version
    yum: name=postgresql state=latest
  - name: ensure that postgresql is started
    service: name=postgresql state=started
```
### adhoc转换为playbook
```
host: web
tasks:
  - name: "nginx install"
    yum: name=nginx state=present
  - name: enable nginx&start nginx
    service: name=nginx state=restarted enabled=yes
```

```
ansible 192.168.14.132 -m service -a "name=nginx state=restarted enabled=yes"
```

## playbook实用选项
列出主机和task
```
ansible-playbook web.yaml --list-hosts
ansible-playbook web.yaml --list-tasks
```
缩小执行范围
```
ansible-playbook web.yaml --limit=192.168.14.132
ansible-playbook web.yaml -l 192.168.14.132
```
以这个用户身份运行
```
ansible-playbook web.yaml --become-user=maotai 
```
```
-u REMOTE_USER, --user=REMOTE_USER
    connect as this user (default=None)
--become-user=BECOME_USER
    run operations as this user (default=root)
```


## playbook试验

### step1错误 则step2不会被执行
```
- hosts: web
  tasks:
    - name: step1
      shell: cat /tmp/1.txt
    - name: step2
      shell: cat /etc/hosts

```

### 返回内容看不到具体值 只看到结果 但是adhoc可以看到执行输出内容
```
- hosts: web
  tasks:
    - name: step1
      shell: ls /tmp
    - name: step2
      shell: cat /etc/hosts

```

### 定义变量

```
- hosts: test
  strategy: debug
  gather_facts: no
  vars:
    var1: value1
  tasks:
    - name: wrong variable
      ping: data={{ wrong_var }}
```

## debug模块
平时我们在使用ansible编写playbook时，经常会遇到错误，很多时候有不知道问题在哪里 。这个时候可以使用-vvv参数打印出来详细信息，不过很多时候-vvv参数里很多东西并不是我们想要的，这时候就可以使用官方提供的debug模块来查找问题出现在哪里。
```
- hosts: 192.168.14.132
  tasks:
    - name: debug test one host
      debug:
        msg: "System {{ inventory_hostname }} has uuid {{ ansible_product_uuid }}"
```
msg: 默认是"hello world",赋值形式
+ msg:
+ msg=


## template模块
把/mytemplates/foo.j2文件经过填写参数后，复制到远程节点的/etc/file.conf，文件权限相关略过
```
- template: src=/mytemplates/foo.j2 dest=/etc/file.conf owner=bin group=wheel mode=0644
```
跟上面一样的效果，不一样的文件权限设置方式
```
- template: src=/mytemplates/foo.j2 dest=/etc/file.conf owner=bin group=wheel mode="u=rw,g=r,o=r"
```



## rgistry变量--输出字典
```
- hosts: 192.168.14.132
  tasks:
    - name: registry vars
      shell: hostname
      register: info
    - name: display var
      debug: msg="The regis var is {{ info }}"
```
rgistry变量--过滤结果
```
- hosts: 192.168.14.132
  tasks:
    - name: registry vars
      shell: hostname
      register: info
    - name: display var
      debug: msg="The regis var is {{ info['stdout'] }}"
```


## 1,变量-通过hosts
给某台定义变量
```
192.168.14.132 key=132
192.168.14.133 key=133 #优先级比组高
```

为一个组所机器定义变量
```
[nginx]
192.168.14.13[2:3]
[nginx:vars]
key=nginx
```


```
- hosts: web
  tasks:
    - name: var via hosts
      debug: msg="the {{ inventory_hostname }} value is {{ key }}"
```

同时给某一主机和组指定变量,key的结果 132 133
```
#cat /etc/ansible/hosts 
192.168.14.132 key=132
192.168.14.133 key=133
[web]
192.168.14.132
192.168.14.133

[web:vars]
key=webserver
#cat y1.yaml 
- hosts: web
  tasks:
    - name: var via var-files
      debug: msg="the {{ inventory_hostname }} value is {{ key }}"
```

给组指定变量,key的结果webserver
```
#192.168.14.132 key=132
#192.168.14.133 key=133
[web]
192.168.14.132
192.168.14.133

[web:vars]
key=webserver
#cat y1.yaml 
- hosts: web
  tasks:
    - name: var via var-files
      debug: msg="the {{ inventory_hostname }} value is {{ key }}"
```


## 2,变量--通过文件vars_file
```
#cat var.yaml 
key: hello world  # 变量名为key
```

```
#cat y1.yaml 
- hosts: web
  vars_files:
    - var.yaml
  tasks:
    - name: var via var-files
      debug: msg="the {{ inventory_hostname }} value is {{ key }}"
```

## 3,变量定义--通过命令行传入

```
[root@node1 an]# cat y3.yaml 
- hosts: web
  tasks:
    - name: var via var-files
      debug: msg="the {{ inventory_hostname }} value is {{ key }}"
```
```
ansible-playbook y3.yaml -e "key=KEY"
ansible-playbook y3.yaml -e "@var.yaml" #通过指定的文件传入
```

## 4,变量定义--playbook中使用vars
```
- hosts: web
  vars:
    key: Ansible
  tasks:
    - name: var via vars
      debug: msg="the {{ inventory_hostname }} value is {{ key }}"
```

## 5,变量定义--通过vars_prompt
```
- hosts: web
  vars_prompt:
    - name: "one"
      prompt: "pls input one value"
      private: no
    - name: "two"
      prompt: "pls input two value"
      default: good
      private: yes
  tasks:
    - name: display one value
      debug: msg="one value is {{ one }}"
    - name: display two value
      debug: msg="one value is {{ two }}"
```
执行过程
```
[root@node1 an]# ansible-playbook y4.yaml 
pls input one value: one    
pls input two value [good]:   #这就是private的好处,输入的时候不显示

PLAY [web] 
```
注: 如果输入为空,则 key="",可以执行成功

## playbook循环

## 简单循环item
key是item
```
[root@node1 an]# cat y5.yaml 
- hosts: web
  tasks:
    - name: debug
      debug: msg="name----->{{ item }}"
      with_items:
        - one
        - tow
        - three
```
## item是字典类型
item数据理性是python类型.
```
[root@node1 an]# cat y6.yaml 
- hosts: web
  gather_facts: False
  tasks:
    - name: debug loops
      debug: msg="key----->{{ item.key }} value----->{{ item.value }}"
      with_items:
        - {key: "one",value: "VALUE1"}
        - {key: "two",value: "VALUE2"}

```

## 随机选一个
## 从上到下,first优先
## template调用自定义变量

[ansible分支when](http://diannaowa.blog.51cto.com/3219919/1682061)
[ansible循环](http://diannaowa.blog.51cto.com/3219919/1681885)

```
# cat httpd.j2 
{{ key }}

# cat y3.yaml
- hosts: 192.168.14.132
  vars:
    key: ansible
  tasks:
    - name: template调用var
      template: src=./httpd.j2 dest=/root/an/httpd2.conf
验证
# cat httpd2.conf 
ansible
```

# 03ansible模块

## role
按照anisble标准创建目录,目录间联系不需要管.如下面,include即可以执行了
```
ansible-galaxy init somedir
```
```
$ tree
.
├── roles
│   └── common
│       ├── handlers
│       ├── meta
│       └── tasks
│           └── main.yml
└── test.yml

5 directories, 2 files
$ cat roles/common/tasks/main.yml 
- name:
  debug: msg="helllllllo"
```
```
$ cat test.yml 
- hosts: 192.168.14.132
  roles:
    - common
```
## cron模块
```
ansible all -m cron -a 'name="jutest" hour="5" job="/bin/bash /tmp/test.sh"'
效果如下：
* 5 * * *  /bin/bash /tmp/test.sh
```
## template模块
把/mytemplates/foo.j2文件经过填写参数后，复制到远程节点的/etc/file.conf，文件权限相关略过
```
- template: src=/mytemplates/foo.j2 dest=/etc/file.conf owner=bin group=wheel mode=0644
```
跟上面一样的效果，不一样的文件权限设置方式
```
- template: src=/mytemplates/foo.j2 dest=/etc/file.conf owner=bin group=wheel mode="u=rw,g=r,o=r"
```
## setup模块

通过命令获取所有的系统信息
搜集主机的所有系统信息
```
ansible all -m setup
```
搜集系统信息并以主机名为文件名分别保存在/tmp/facts 目录
```
ansible all -m setup --tree /tmp/facts
```
#搜集和内存相关的信息
```
nsible all -m setup -a 'filter=ansible_*_mb'
```
搜集网卡信息
```
ansible all -m setup -a 'filter=ansible_eth[0-2]'

```
## archive模块
支持的格式:```gz,bz2,zip,tar```
0,压缩单个目录得到最根的目录
```
- hosts: 192.168.x.x
  tasks:
    - name: 测试压缩模块
      archive:
        path: /opt/test
        dest: /root/an/test.tar
        format: tar
解压后得到: test
```
1.压缩多个目录
```
- hosts: 192.168.x.x
  tasks:
    - name: 测试压缩模块
      archive:
        path:
            - /opt/test
            - /tmp/test2/test3/1.txt
        dest: /root/an/test.tar
        format: tar
解压后得到: /opt/test
            /tmp/test2/test3/
```
注:空文件或目录压缩不计入压缩范围.


## 发邮件
```
- hosts: node67
  remote_user: root
  tasks:
    - name: cat hosts
      shell: cat /etc/hosts
      register: info
      
    - name: sendMail to op
      mail:
        host: smtp.sina.com
        port: 25
        username: lanny@sina.com
        password: 123456
        from: lanny@sina.com (lanny)
        to: maotai <maotai@qq.com>
        # cc: John Doe <j.d@example.org>, Suzie Something <sue@example.com>
        # cc: Mao Tai2 <maotai2@qq.com>, Mao Tai3 <maotai3@qq.com>
        # attach: /etc/fstab /etc/hosts
        subject: Backup-scm successfully
        body: 'System {{ ansible_hostname }}-192.168.x.x {{ info['stdout_lines'] }}'

```


## synchronize模块
### rsync同步
```
#ansible test -m synchronize -a "src=/data/adminshell/ dest=/data/adminshell/ "
```
### rsync无差异同步
```
#ansible test -m synchronize -a "src=/data/adminshell/ dest=/data/adminshell/ delete=yes"
"msg": "*deleting   test.txt\n"
```

### 排除同步
```
#同步目录，排除某个文件
ansible test -m synchronize -a "src=/data/adminshell/ dest=/data/adminshell/ rsync_opts="--exclude=exclude.txt" "
#同步目录，排除多个文件
ansible test -m synchronize -a "src=/data/adminshell/ dest=/data/adminshell/ rsync_opts="--exclude=\*.conf,--exclude=\*.html,--exclude=test1" "
```
> 相对copy模块
* 1.copy没mode,只能发出去
* 2.copy是全量的

## replace模块
```
ansible 192.168.14.133 -m replace -a "dest=/etc/hosts regexp='^Old' replace='New' backup=yes"
```
```
#备份效果
[root@node2 tmp]# ll /etc/hosts*
-rw-r--r--  1 root root 350 Jul 20 16:56 /etc/hosts
-rw-r--r--  1 root root 312 Jul 20 16:43 /etc/hosts.63296.2017-07-20@16:44:03~
-rw-r--r--  1 root root 350 Jul 20 16:55 /etc/hosts.63677.2017-07-20@16:56:53~

```
注: copy fetch模块也有backup的功能.


## copy模块
```
#拷贝本地的/etc/hosts 文件到myserver主机组所有主机的/tmp/hosts（空目录除外）,如果使用playbooks 则可以充分利用template 模块
ansible myserver -m copy -a "src=/etc/hosts dest=/tmp/hosts mode=600 owner=ju group=ju"
#file 模块允许更改文件的用户及权限
ansible webservers -m file -a "dest=/srv/foo/a.txt mode=600"
ansible webservers -m file -a "dest=/srv/foo/b.txt mode=600 owner=ju group=ju"
#使用file 模块创建目录，类似mkdir -p
ansible webservers -m file -a "dest=/path/to/c mode=755 owner=ju group=ju state=directory"
#使用file 模块删除文件或者目录
ansible webservers -m file -a "dest=/path/to/c state=absent"
```

## raw模块
```
- hosts: node14-scm
  remote_user: root
  vars:
  - sfpath: "/backup/scm-data/*_$(date +%F -d '-1 day')_scmdata.tar.gz"
  - dfpath: "/data/backup/scm-data/"
  tasks:
    #清理远端的压缩包,远端进保留一天scm-data.tar.gz  2,远端打包并将压缩包取回
    - name: Clean | keeping [scm-server-node14]'s /backup/scm-data dir only have one tar pkg
      shell: find /backup/scm-data/ -name "*.tar.gz"  -type f -mtime -7 |xargs rm -f

    - name: Package | make /root/.scm to tar.gz package on node14
      raw: 
           cd /backup/scm-data && \
           \rm -rf .scm && \
           cp -r /root/.scm /backup/scm-data/ && \
           tar zcf /backup/scm-data/`ifconfig|sed -n '2p'|awk -F':' '{print $2}'|awk '{print $1}'`_$(date +%F -d '-1 day')_scmdata.tar.gz .scm

```
```
- hosts: node1
  task:
    - name: 清理/tmp
      raw: 
           cd /tmp && \
           \rm -rf * 

```

## tags
如果你有一个很大的playbook，而你只想run其中的某个task，这个时候tags是你的最佳选择。
此时若你希望只run其中的某个task，这run 的时候指定tags即可

```
tasks:
 
    - yum: name={{ item }} state=installed
      with_items:
         - httpd
         - memcached
      tags:
         - packages
 
    - template: src=templates/src.j2 dest=/etc/foo.conf
      tags:
         - configuration
```
```
ansible-playbook example.yml --tags "configuration,packages"   #run 多个tags
ansible-playbook example.yml --tags packages                   # 只run 一个tag
```
相反，也可以跳过某个task
```
ansible-playbook example.yml --skip-tags configuration
```
tags 和role 结合使用
tags 这个属性也可以被应用到role上，例如:
```
roles:
  - { role: webserver, port: 5000, tags: [ 'web', 'foo' ] }
```

tags和include结合使用
```
- include: foo.yml tags=web,foo
```
这样，fool.yml 中定义所有task都将被执行


## blockinfile模块
```
- hosts: 192.168.14.133
  tasks: 
  - name: Edit profile JDK conf
    blockinfile:
      dest: /etc/profile
      backup: yes
      marker: "# {mark} jdk config"
      content: |
        JAVA_HOME=/usr/java/jdk1.8.0_66
        CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
        PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$PATH
        export JAVA_HOME CLASSPATH PATH
```
```
#cat profile
...
# BEGIN jdk config
JAVA_HOME=/usr/java/jdk1.8.0_66
CLASSPATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
PATH=$JAVA_HOME/bin:$ANT_HOME/bin:$PATH
export JAVA_HOME CLASSPATH PATH
# END jdk config
```

## lineinfile模块
ansible实现sed功能
### 替换目标文件中的某行
```
- hosts: 192.168.14.132
  tasks:
    - name: seline modify enforcing
      lineinfile:
        dest: /etc/selinux/config
        regexp: '^SELINUX='
        line: 'SELINUX=enforcing'
```

### 删除一行
```
- hosts: 192.168.14.132
  tasks:
    - name: 删除一行
      lineinfile:
        path: /root/an/httpd2.conf
        state: absent
        regexp: '^an'
```
### 在目标文件某行前添加一行
```
- name: httpd.conf modify 8080
  lineinfile:
     dest: /opt/playbook/test/http.conf
     regexp: '^Listen'
     insertbefore: '^#Port'   
     line: 'Listen 8080'
  tags:
   - http8080
验证:
[root@master test]# cat http.conf 
#Listen 12.34.56.78:80
#Listen 80
Listen 8080
#Port
```

### 在目标文件某行后添加一行
```
- name: httpd.conf modify 8080
      lineinfile:
        dest: /opt/playbook/test/http.conf
        regexp: '^Listen'
        insertafter: '^#Port'   
        line: 'Listen 8080'
      tags:
        - http8080
验证:
[root@master test]# cat http.conf 
#Listen 12.34.56.78:80
#Listen 80
#Port
Listen 8080
```


## lookup templates
```
#lookups.j2 
worker_process {{ ansible_processor_cores }}
IPaddress {{ ansible_eth0.ipv4.address }}
```
```
- hosts: 192.168.14.132
  vars:
    # contents相当于f.read,将文件读取成了1个大的字符串
    contents: "{{ lookup('template','./lookups.j2') }}"
  tasks:
  - name: debug lookups
    # 使用jinja2对文件进行遍历.
    debug: msg="The contents is {% for i in contents.split("\n") %} {{ i }} {% endfor %}"

# 结果 由此可见是模板渲染后的结果做了行遍历
#"msg": "The contents is  worker_process 1  IPaddress 192.168.14.132     "
```

## authorized_key建互信
```
ansible web -m authorized_key -a "user=root state=present key=\"{{ lookup('file', '/root/.ssh/id_rsa.pub') }}\"" -k

ansible all -m authorized_key -a "user=root state=present key=\"{{ lookup('file', '/root/.ssh/id_rsa.pub') }}\"" -k    # 将本地root的公钥导入到远程用户root的authorized_keys里
ansible all -m authorized_key -a "user=root state=present key=\"{{ lookup('file', '/home/test/.ssh/id_rsa.pub') }}\"" -k # 将本地test的公钥导入到远程用户root的authorized_keys里
```
```
vi /etc/ansible/ansible.cfg
host_key_checking = False
```

## script模块
相对shell,好处是script可以集中管理脚本,过程是:将shell下发到目标机执行. 
而shell必须将shell下发下去执行
```
$　cat s.sh 
#!/bin/sh

/bin/tar -xf /tmp/opt.tar.gz -C /tmp
```
执行过程
```
$ansible 192.168.14.133 -m script -a '/tmp/s.sh' -o
192.168.14.133 | SUCCESS => {"changed": true, "rc": 0, "stderr": "Shared connection to 192.168.14.133 closed.\r\n", "stdout": "", "stdout_lines": []}
```
结果
```
$ ll
total 128
drwxr-xr-x 6 root root    157 Jul 20 17:07 opt
-rw-r--r-- 1 root root 128187 Jul 21 16:29 opt.tar.gz

```


## unarchive 解压缩
可以将本地的压缩包直接解压到远程
可以将远程压缩包直接解压
```
  src
  copy  yes|no  # yes:默认，压缩包在本地,src=本地压缩包路径，dest=解压到远程路径；no远程主机已存在压缩包，src=远程压缩包路径，dest=解压到远程路径
  creates  # 创建文件目录，当文件存在就不执行
  dest
  group
  mode
  owner  
  unarchive: src=foo.tgz dest=/var/lib/foo
  unarchive: src=/tmp/foo.zip dest=/usr/local/bin copy=no
  unarchive: src=/tmp/test.tar.gz dest=/opt/tmp/ creates=/opt/tmp/ copy=no
```

# 04ansible when
## ansible条件-简单的条件
```
tasks:
  - name: "shut down Debian flavored systems"
    command: /sbin/shutdown -t now
    when: ansible_os_family == "Debian"
    # note that Ansible facts and vars like ansible_os_family can be used
    # directly in conditionals without double curly braces
```

## ansible条件-or
```
tasks:
  - name: "shut down CentOS 6 and Debian 7 systems"
    command: /sbin/shutdown -t now
    when: (ansible_distribution == "CentOS" and ansible_distribution_major_version == "6") or
          (ansible_distribution == "Debian" and ansible_distribution_major_version == "7")
```
## ansible条件-and
```
tasks:
  - name: "shut down CentOS 6 systems"
    command: /sbin/shutdown -t now
    when:
      - ansible_distribution == "CentOS"
      - ansible_distribution_major_version == "6"
```
## ansible条件-jinja2
```
tasks:
  - command: /bin/false
    register: result
    ignore_errors: True

  - command: /bin/something
    when: result|failed

  # In older versions of ansible use |success, now both are valid but succeeded uses the correct tense.
  - command: /bin/something_else
    when: result|succeeded

  - command: /bin/still/something_else
    when: result|skipped
```

# ansible-playbook高级

## [参考](https://www.ibm.com/developerworks/cn/linux/1608_lih_ansible/index.html)
## 任务委派
1.在14.132执行, 14.133上没任何变动
```
- hosts: 192.168.14.133
  tasks:
    - shell: "echo '1.1.1.1 www.abc.com' >> /etc/hosts"
      delegate_to: 192.168.14.132
```
2.先在14.133上输出字符串,然后再触发让14.132去干活(即修改hosts)
```
$ cat t.yml 
- hosts: 192.168.14.133
  tasks:
    - debug: msg="hello node2"
    - shell: "echo '1.1.1.1 www.abc.com' >> /etc/hosts"
      delegate_to: 192.168.14.132
```
验证:
```
[root@node1 ~]# cat /etc/hosts
...
1.1.1.1 www.abc.com

```
任务委派功能还可以用于以下场景：
> + 在部署之前将一个主机从一个负载均衡集群中删除。
> + 当你要对一个主机做改变之前去掉相应 dns 的记录
> + 当在一个存储设备上创建 iscsi 卷的时候
> + 当使用外的主机来检测网络出口是否正常的时候

## 本地操作功能 --local_action
Ansible 默认只会对控制机器执行操作，但如果在这个过程中需要在 Ansible 本机执行操作呢？细心的读者可能已经想到了，可以使用 delegate_to( 任务委派 ) 功能呀。没错，是可以使用任务委派功能实现。不过除了任务委派之外，还可以使用另外一外功能实现，这就是 local_action 关键字。
```
- name: add host record to center server 
  local_action: shell 'echo "192.168.1.100 test.xyz.com " >> /etc/hosts'
```
当然您也可以使用 connection:local 方法，如下:
```
- name: add host record to center server 
  shell: 'echo "192.168.1.100 test.xyz.com " >> /etc/hosts'
  connection: local
```

## 委托者的facts
默认情况下, 委托任务的facts是inventory_hostname中主机的facts, 而不是被委托机器的facts. 在ansible 2.0 中, 设置delegate_facts为true可以让任务去收集被委托机器的facts.

```
- hosts: app_servers
  tasks:
    - name: gather facts from db servers
      setup:
      delegate_to: "{{item}}"
      delegate_facts: True
      with_items: "{{groups['dbservers'}}"
```
该例子会收集dbservers的facts并分配给这些机器, 而不会去收集app_servers的facts


## RUN ONCE
```
通过run_once: true来指定该task只能在某一台机器上执行一次. 可以和delegate_to 结合使用

- command: /opt/application/upgrade_db.py
  run_once: true
  delegate_to: web01.example.org
```
指定在"web01.example.org"上执行这
如果没有delegate_to, 那么这个task会在第一台机器上执行






## [异步和轮询](http://www.cnblogs.com/v394435982/p/5180933.html)
Ansible 有时候要执行等待时间很长的操作,  这个操作可能要持续很长时间, 设置超过ssh的timeout. 这时候你可以在step中指定async 和 poll 来实现异步操作

async 表示这个step的最长等待时长,  如果设置为0, 表示一直等待下去直到动作完成.

poll 表示检查step操作结果的间隔时长.

例1:
```
---
- name: Test
  hosts: localhost
  tasks:
    - name: wair for
      shell: sleep 16
      async: 10
      poll: 2
```
结果:
```
TASK: [wair for] ************************************************************** 
ok: [localhost]
<job 207388424975.101038> polling, 8s remaining
ok: [localhost]
<job 207388424975.101038> polling, 6s remaining
ok: [localhost]
<job 207388424975.101038> polling, 4s remaining
ok: [localhost]
<job 207388424975.101038> polling, 2s remaining
ok: [localhost]
<job 207388424975.101038> polling, 0s remaining
<job 207388424975.101038> FAILED on localhost

这个step失败, 因为操作时间超过了最大等待时长
```
例2:
```
---
- name: Test
  hosts: localhost
  tasks:
    - name: wair for
      shell: sleep 16
      async: 10
      poll: 0
```
结果:
```
TASK: [wair for] ************************************************************** 
<job 621720484791.102116> finished on localhost

PLAY RECAP ********************************************************************

poll 设置为0, 表示不用等待执行结果, 该step执行成功
```

例3:
```
---
- name: Test
  hosts: localhost
  tasks:
    - name: wair for
      shell: sleep 16
      async: 0
      poll: 10
```
结果:
```
# time ansible-playbook xiama.yml 
TASK: [wair for] ************************************************************** 
changed: [localhost]

PLAY RECAP ******************************************************************** 
localhost                  : ok=2    changed=1    unreachable=0    failed=0   


real    0m16.693s

async设置为0, 会一直等待直到该操作完成.
```

Play执行时的并发限制
一般情况下, ansible会同时在所有服务器上执行用户定义的操作, 但是用户可以通过serial参数来定义同时可以在多少太机器上执行操作.

- name: test play
  hosts: webservers
  serial: 3

webservers组中的3台机器完全完成play后, 其他3台机器才会开始执行,
serial参数在ansible-1.8以后就开始支持百分比.

最大失败百分比
默认情况下, 只要group中还有server没有失败,  ansible就是继续执行tasks. 实际上, 用户可以通过"max_fail_percentage" 来定义, 只要超过max_fail_percentage台的server失败, ansible 就可以中止tasks的执行.
```
- hosts: webservers
  max_fail_percentage: 30
  serial: 10
Note: 实际失败机器必须大于这个百分比时, tasks才会被中止. 等于时是不会中止tasks的.
```

## 任务暂停


![image](http://ww1.sinaimg.cn/large/9e792b8fgy1fhw0nplamxj20kc0h87o4)


# ansible-playbook

[参考](http://www.361way.com/ansible-playbook-example/4441.html)

一、一个简单的示例


下面给出一个简单的ansible-playbook示例，了解下其构成。
```
# cat user.yml
- name: create user
  hosts: all
  user: root
  gather_facts: false
  vars:
  - user: "test"
  tasks:
  - name: create  user
    user: name="{{ user }}"
```


三、playbook的构成


playbook是由一个或多个“play”组成的列表。play的主要功能在于将事先归并为一组的主机装扮成事先通过ansible中的task定义好的角色。从根本上来讲所谓task无非是调用ansible的一个module。将多个play组织在一个playbook中即可以让它们联同起来按事先编排的机制同唱一台大戏。其主要有以下四部分构成

playbooks组成：
- Target section：   定义将要执行 playbook 的远程主机组
- Variable section： 定义 playbook 运行时需要使用的变量
- Task section：     定义将要在远程主机上执行的任务列表
- Handler section：  定义 task 执行完成以后需要调用的任务


而其对应的目录层为五个，如下：

一般所需的目录层有：(视情况可变化)
- vars     变量层
- tasks    任务层
- handlers 触发条件
- files    文件
- template 模板

2、任务列表和action
```
tasks:
  - name: make sure apache is running
    service: name=httpd state=running
在众多模块中只有command和shell模块仅需要给定一个列表而无需使用“key=value”格式例如
tasks:
  - name: disable selinux
    command: /sbin/setenforce 0  如果命令或脚本的退出码不为零可以使用如下方式替代
tasks:
 - name: run this command and ignore the result
    shell: /usr/bin/somecommand || /bin/true
或者使用ignore_errors来忽略错误信息
tasks:
  - name: run this command and ignore the result
    shell: /usr/bin/somecommand
    ignore_errors: True 
```
![image](http://ww1.sinaimg.cn/large/9e792b8fgy1fhv3uj4qofj20np0b0my8)

3,给task添加触发器notify,触发handler
```
- name: template configuration file
  template: src=template.j2 dest=/etc/foo.conf
  notify:
  - restart memcached
  - restart apache
handler是task列表这些task与前述的task并没有本质上的不同。
handlers:
  - name: restart memcached
    service: name=memcached state=restarted
  - name: restart apache
    service: name=apache state=restarted 

```
# ansible-galaxy


[Ansible Galaxy]https://ipaas.com.cn/blog/post/seanzhau/7185546cc669) 

ansible-galaxy是一个工具，我们可以利用它快速的创建一个标准的roles目录结构，还可以通过它在https:/galaxy.ansible.com上下载别人写好的roles，直接拿来用。

通过ansible-galaxy初始化一个roles的目录结构，方法如下：
```
ansible-galaxy init /etc/ansible/roles/websrvs
```
安装别人写好的roles：
```
ansible-galaxy install -p /etc/ansible/roles bennojoy.mysql
```
列出已安装的roles：
```
ansible-galaxy list
```
查看已安装的roles信息：
```
ansible-galaxy info bennojoy.mysql
```
卸载roles：
```
ansible-galaxy remove bennojoy.mysql
```
