## curl命令-网站如果3次不是200或301则报警
```
curl -o /dev/null -s -w "%{http_code}" baidu.com
-k/--insecure	允许不使用证书到SSL站点
-H/--header     自定义头信息传递给服务器
-I/--head       只显示请求头信息
-w/--write-out [format]	什么输出完成后
-s/--silent	    静默模式。不输出任何东西
-o/--output	    把输出写到该文件中
```

## linux正则
- 基本
```
. 匹配任何单个字符
* 前面出现0个或者多个
^ 以..开始
$ 以..结束
```


- 举个例子
```
china  :  匹配此行中任意位置有china字符的行

^china : 匹配此以china开关的行

china$ : 匹配以china结尾的行

^china$ : 匹配仅有china五个字符的行

[Cc]hina : 匹配含有China或china的行

Ch.na : 匹配包含Ch两字母并且其后紧跟一个任意字符之后又有na两个字符的行

Ch.*na : 匹配一行中含Ch字符，并且其后跟0个或者多个字符，再继续跟na两字符
```

- 扩展正则
```
? : 匹配前面正则表达式的零个或一个扩展
+ : 匹配前面正则表达式的一个或多个扩展
{n,m}: 前面出现1个或2个或3个
| : 匹配|符号前或后的正则表达式
( ) : 匹配方括号括起来的正则表达式群
```

## grep
- 参数
```
-n, --line-number
-i, --ignore-case   不区分大小写
-r, --recursive     按照目录
-o, --only-matching 只显示匹配行中匹配正则表达式的那部分
-v, --invert-match  排除
-c, --count         统计url出现次数
grep -nr
grep -oP
```

- 过滤ip
```
192.168.100.100
ifconfig|grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}"
```

- 过滤邮箱
```
cat >>tmp.txt<<EOF
iher-_@qq.com
hello
EOF

cat tmp.txt|grep -oP "[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\.[a-zA-Z]+)+"
```

- 统计baidu关键字的url在这个大文件中出现的次数
```
$ cat >file.txt<<EOF  
wtmp begins Mon Feb 24 14:26:08 2014  
192.168.0.1  
162.12.0.123  
"123"  
123""123  
njuhwc@163.com  
njuhwc@gmil.com 123  
www.baidu.com  
tieba.baidu.com  
www.google.com  
www.baidu.com/search/index  
EOF

grep -cn ".*baidu.com.*" file.txt  
3 
```
