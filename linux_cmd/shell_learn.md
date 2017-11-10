
一、条件选择、判断（if·、case）

二、四个循环（for、while、until、select）

三、循环里的一些命令与技巧（continue、break、shift...）


## 参数
```
$1 $2
$# 总个数
$? 执行结果(函数return获取)

$* 所有参数,(整体)
$@


clear
set -ue

#for i in "$*";do
#    printf "\$i is %s\n" $i
#done

for i in "$@";do
    echo $i
done


for i in "$*";do
    echo $i
done

```

## 输入输出
- echo
- printf
- tee



- 判断文件,目录
  -d -f

- 序列
```
  {1..10}
  seq 10

seq 10 |sed 's#^#$#g'|tr "\n" " "
seq -s " " 15|sed 's# # $#g'

```



## 数据类型
```
数值
  比较 ((10<20))
  相加 

if((10<20));then
    echo 123213123123213213213213
fi


字符串
  比较[ 'maotai' == 'maotai1' ]
      [[ $num =~ [^0-9] ]]
```

## 条件
```
if then fi
    if
    if else
    if elif
```

## case

```    
case
  case $ans in
  'ok' | 'yes')
    echo 'yes'
    ;;
  
  case $ans in
  [nN][oO][nN])
    echo no
    ;;
```
## for循环


for do doen
    for i in 列表;do{}done
    for((i=0;i<10;i++))
    for((1,2,3))
```

- 写法: 举个例子
```
clear

- 第一种
  for i in $(seq 10);do
    echo $i
    sleep 1
  done

- 第二种
  for((i=1;i<=10;i++));do
    echo $i
  done
```

## while循环
```
while :;do
done
``` 

## 函数
```
function
    local
```


## shell技巧
- 1、生成随机字符 cat /dev/urandom
```
　　生成8个随机大小写字母或数字 cat /dev/urandom |tr -dc [:alnum:] |head -c 8
```
- 2、生成随机数 echo $RANDOM
```

　　确定范围 echo $[RANDOM%7] 随机7个数（0-6）

　　　　　　 echo $[$[RANDOM%7]+31] 随机7个数（31-37）
```

- 3、echo打印颜色字
```
echo -e "\033[31malong\033[0m" 显示红色along

echo -e "\033[1;31malong\033[0m" 高亮显示红色along

echo -e "\033[41malong\033[0m" 显示背景色为红色的along

echo -e "\033[31;5malong\033[0m" 显示闪烁的红色along

color=$[$[RANDOM%7]+31]

echo -ne "\033[1;${color};5m*\033[0m" 显示闪烁的随机色along


print_green() {
  printf '%b' "\033[92m$1\033[0m\n"
}
```
