



## htpasswd使用
```
# yum install -y httpd-tools
## 首次创建密码文件
    #htpasswd -cmb /usr/local/nginx/conf/.pass admin 123456
    #
## 添加用户
    #htpasswd .pass guest
    #
## 改密码
    #htpasswd /usr/local/nginx/conf/.pass  admin

## 删除用户
    #htpasswd -D .pass guest
```


## nginx_upstream_check_module
![](http://ww1.sinaimg.cn/large/9e792b8fgy1fkdezdrlzoj20o1057jsx)
参考:
http://nolinux.blog.51cto.com/4824967/1594029

```
    upstream nexus {
        server 192.168.66.222:8081;
        check interval=60000 rise=2 fall=5 timeout=1000 type=tcp; #仅需要添加这行即可
    }
    
    
    server {
        listen 80;
        server_name 192.168.60.123;
        auth_basic "secret";
        auth_basic_user_file /usr/local/nginx/conf/.pass;
        location /ngx_status {
            stub_status on;
            # access_log  off;
            allow 127.0.0.1;
            allow 192.168.10.0/24;
            allow 192.168.60.0/24;
            deny all;
        }
        location /ngx_statuss {
            check_status;
            # access_log off;
            #allow IP;
            #deny all;
        }
    }
```


## nginx-module-vts
参考: 
https://github.com/vozlt/nginx-module-vts#installation

https://github.com/kubernetes/ingress-nginx
```
mkdir /usr/local/nginx/3rdmodules
cd /usr/local/nginx/3rdmodules
git clone git://github.com/vozlt/nginx-module-vts.git

./configure --user=nginx --group=nginx --prefix=/usr/local/tengine-2.1.2 --with-http_stub_status_module --with-http_ssl_module --add-module=/usr/local/nginx/3rdmodules/nginx-module-vts
make && make install
```

```

    server {
        listen 80;
        server_name 192.168.6.123;
        auth_basic "secret";
        auth_basic_user_file /usr/local/nginx/conf/.pass;

        location /ngx_status {
            stub_status on;
            allow 127.0.0.1;
            allow 192.168.8.0/24;
            allow 192.168.9.0/24;
            deny all;
        }
        location /ngx_statuss {
            stub_status on;
            vhost_traffic_status_display;
            vhost_traffic_status_display_format html;
            allow 127.0.0.1;
            allow 192.168.8.0/24;
            allow 192.168.9.0/24;
            deny all;
        }
    }
```