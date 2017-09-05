yum install python-pip -y
cd
mkdir ~/.pip && cd .pip
cat > pip.conf<<a
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
 
[install]
trusted-host=mirrors.aliyun.com
a
