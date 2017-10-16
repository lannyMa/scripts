## zabbix安装 server&agent
- docker安装,简单方便
- 宿主机跑

思路:指定server的ip,自身主机名等信息,server上去添加agent,server主动或者被动的获取到主机监控项结果


## zabbix架构
![](https://ws1.sinaimg.cn/large/9e792b8fgy1fkk7c6tb0ij20bp0ayq3m.jpg)
- 流程: 
agent采集-->zabbixserver接锅-->db-->webui展示

- 名词
  - 主机 主机组
  - items
  - 触发器
  - 模板


## 添加一个主机
pass

## 使用脚本监控,发到server监控
- 1.正确姿势存放脚本:
```
$ pwd
/etc/zabbix
$ tree .
.
├── shells
│   └── zabbix_linux_plugin.sh
├── zabbix_agentd.conf
└── zabbix_agentd.d
    ├── userparameter_mysql.conf
    └── zabbix_linux_plugin.conf

```
参考脚本: http://www.52devops.com/chuck/646.html

- 2.自定义监控key
打开agent配置包含:
```
Include=/etc/zabbix/zabbix_agentd.d/
```

```

$ cat zabbix_agentd.d/zabbix_linux_plugin.conf 
UserParameter=linux_status[*],/etc/zabbix/shells/zabbix_linux_plugin.sh "$1" "$2" "$3"
```



- 3.确保脚本本地执行能获取到数据
```
[root@test1 shells]# ./zabbix_linux_plugin.sh tcp_status ESTAB
3
```

- 4.在zabbixserver上确保agent上自定义的key有效
```
[root@zabbix-test120 ~]# zabbix_get -s 192.168.6.11 -k linux_status[tcp_status,ESTAB]
4
```

- 5.webui上添加监控项
两种方法:
  - 1.导入模板,主机引用模板即可(网上有很多模板)
  - 2.一个个自己添加 items-->template,host调用
