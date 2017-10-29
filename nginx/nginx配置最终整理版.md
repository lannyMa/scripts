#### nginx配置

- 错误日志记录
- 日志json格式
- stub_status & 开启认证
- 404错误页配置,并重定向
- 某些后缀文件拒绝访问(default.conf)
- 配置include(简化)

```nginx
worker_processes auto;
worker_rlimit_nofile 65535;
error_log stderr notice;
error_log /var/log/nginx/error.log;

events {
    multi_accept on;
    use epoll;
    worker_connections 51200;
}

http {
    include                       mime.types;
    default_type                  application/octet-stream;
    server_name_in_redirect       off;
    client_max_body_size          20m;
    client_header_buffer_size     16k;
    large_client_header_buffers 4 16k;
    sendfile                      on;
    tcp_nopush                    on;
    keepalive_timeout             65;
    server_tokens                 off;
    gzip                          on;
    gzip_min_length               1k;
    gzip_buffers                  4 16k;
    gzip_proxied                  any;
    gzip_http_version             1.1;
    gzip_comp_level               3;
    gzip_types                    text/plain application/x-javascript text/css application/xml;
    gzip_vary                     on;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    log_format json '{"@timestamp": "$time_iso8601",'
    '"@version": "1",'
    '"client": "$remote_addr",'
    '"url": "$uri", '
    '"status": $status, '
    '"domain": "$host", '
    '"host": "$server_addr",'
    '"size":"$body_bytes_sent", '
    '"response_time": $request_time, '
    '"referer": "$http_referer", '
    '"http_x_forwarded_for": "$http_x_forwarded_for", '
    '"ua": "$http_user_agent" } ';

    #access_log  /var/log/nginx/access.log  json;
    upstream owncloud {
        server 127.0.0.1:8000;
    }
    server {
        listen       80;
        server_name  ownclouds.maotai.org;
        location / {
            proxy_next_upstream error timeout invalid_header http_500 http_503 http_404 http_502 http_504;
            proxy_pass http://owncloud;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    
    upstream gogs {
        server 127.0.0.1:53000;
    }
    server {
        listen       80;
        server_name  gogs.maotai.org;
        location / {
            proxy_next_upstream error timeout invalid_header http_500 http_503 http_404 http_502 http_504;
            proxy_pass http://gogs;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    server {
        listen 80;
        server_name 192.168.100.60;
        location /ngx_status {
            stub_status on;
            access_log off;
            allow all;
        }
    }
}
```

#### nginx精简版配置-包含

```nginx
worker_processes auto;
worker_rlimit_nofile 65535;
error_log stderr notice;
error_log /var/log/nginx/error.log;

events {
    multi_accept on;
    use epoll;
    worker_connections 51200;
}

http {
    include                       mime.types;
    default_type                  application/octet-stream;
    server_name_in_redirect       off;
    client_max_body_size          20m;
    client_header_buffer_size     16k;
    large_client_header_buffers 4 16k;
    sendfile                      on;
    tcp_nopush                    on;
    keepalive_timeout             65;
    server_tokens                 off;
    gzip                          on;
    gzip_min_length               1k;
    gzip_buffers                  4 16k;
    gzip_proxied                  any;
    gzip_http_version             1.1;
    gzip_comp_level               3;
    gzip_types                    text/plain application/x-javascript text/css application/xml;
    gzip_vary                     on;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    log_format json '{"@timestamp": "$time_iso8601",'
    '"@version": "1",'
    '"client": "$remote_addr",'
    '"url": "$uri", '
    '"status": $status, '
    '"domain": "$host", '
    '"host": "$server_addr",'
    '"size":"$body_bytes_sent", '
    '"response_time": $request_time, '
    '"referer": "$http_referer", '
    '"http_x_forwarded_for": "$http_x_forwarded_for", '
    '"ua": "$http_user_agent" } ';

    include /etc/nginx/conf.d/*.conf;
}
```

- /etc/nginx/conf.d/www.maotai.com

  ```nginx- 
  server {
      listen       80;
      server_name  localhost;
      access_log  /var/log/nginx/host.access.log  main;
      location / {
          root   /usr/share/nginx/html;
          index  index.html index.htm;
      }
  }
  ```

- /etc/nginx/conf.d/default.conf(某些后缀拒绝访问)

  ```nginx
  server {
      listen       80;
      server_name  localhost;

      #charset koi8-r;
      #access_log  /var/log/nginx/host.access.log  main;

      location / {
          root   /usr/share/nginx/html;
          index  index.html index.htm;
      }

      #error_page  404              /404.html;

      # redirect server error pages to the static page /50x.html
      #

      error_page   500 502 503 504  /50x.html;
      location = /50x.html {
          root   /usr/share/nginx/html;
      }

      # proxy the PHP scripts to Apache listening on 127.0.0.1:80
      #
      #location ~ \.php$ {
      #    proxy_pass   http://127.0.0.1;
      #}

      # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
      #
      #location ~ \.php$ {
      #    root           html;
      #    fastcgi_pass   127.0.0.1:9000;
      #    fastcgi_index  index.php;
      #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
      #    include        fastcgi_params;
      #}

      # deny access to .htaccess files, if Apache's document root
      # concurs with nginx's one
      #
      #location ~ /\.ht {
      #    deny  all;
      #}
  }
  ```

- /etc/nginx/conf.d/nginx-status.conf

  ```nginx
  #==================================================
  #                nginx status start
  #==================================================
      #yum install -y httpd-tools
      ## 首次创建密码文件
      #htpasswd -cmb /usr/local/nginx/conf/.pass admin 123456
      #
  ## 添加用户
      #htpasswd .pass guest
      #
  ## 改密码
      #htpasswd .pass fdipzone

      ## 删除用户
      #htpasswd -D .pass guest
      server {
          listen 80;
          server_name 192.168.100.60;
          auth_basic "secret";
          auth_basic_user_file /etc/nginx/conf/.pass;

          location /ngx_status {
              stub_status on;
              allow all;
              access_log off;
              allow 127.0.0.1;
              allow 192.168.1.0/24;
              allow 192.168.100.0/24;
              deny all;
          }

          #第三方状态模块: https://github.com/vozlt/nginx-module-vts
          location /ngx_statuss {
              vhost_traffic_status_display;
              vhost_traffic_status_display_format html;
              access_log off;
              allow 127.0.0.1;
              allow 192.168.1.0/24;
              allow 192.168.100.0/24;
              deny all;
          }
      }
  ```

#### nginx配置详细版-无include

```nginx
worker_processes auto;
worker_rlimit_nofile 65535;
error_log stderr notice;
error_log /var/log/nginx/error.log;

events {
    multi_accept on;
    use epoll;
    worker_connections 51200;
}

http {
    include                       mime.types;
    default_type                  application/octet-stream;
    server_name_in_redirect       off;
    client_max_body_size          20m;
    client_header_buffer_size     16k;
    large_client_header_buffers 4 16k;
    sendfile                      on;
    tcp_nopush                    on;
    keepalive_timeout             65;
    server_tokens                 off;
    gzip                          on;
    gzip_min_length               1k;
    gzip_buffers                  4 16k;
    gzip_proxied                  any;
    gzip_http_version             1.1;
    gzip_comp_level               3;
    gzip_types                    text/plain application/x-javascript text/css application/xml;
    gzip_vary                     on;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';

    log_format json '{"@timestamp": "$time_iso8601",'
    '"@version": "1",'
    '"client": "$remote_addr",'
    '"url": "$uri", '
    '"status": $status, '
    '"domain": "$host", '
    '"host": "$server_addr",'
    '"size":"$body_bytes_sent", '
    '"response_time": $request_time, '
    '"referer": "$http_referer", '
    '"http_x_forwarded_for": "$http_x_forwarded_for", '
    '"ua": "$http_user_agent" } ';

    #access_log  /var/log/nginx/access.log  json;
    upstream owncloud {
        server 127.0.0.1:8000;
    }
    server {
        listen       80;
        server_name  ownclouds.maotai.org;
        location / {
            proxy_next_upstream error timeout invalid_header http_500 http_503 http_404 http_502 http_504;
            proxy_pass http://owncloud;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }


    upstream gogs {
        server 127.0.0.1:53000;
    }
    server {
        listen       80;
        server_name  gogs.maotai.org;
        location / {
            proxy_next_upstream error timeout invalid_header http_500 http_503 http_404 http_502 http_504;
            proxy_pass http://gogs;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        }
    }
    #==================================================
    #                nginx status start
    #==================================================
    #yum install -y httpd-tools
    ## 首次创建密码文件
    #htpasswd -cmb /usr/local/nginx/conf/.pass admin 123456
    #
## 添加用户
    #htpasswd .pass guest
    #
## 改密码
    #htpasswd .pass fdipzone

    ## 删除用户
    #htpasswd -D .pass guest
    server {
        listen 80;
        server_name 192.168.100.60;
        #        auth_basic "secret";
        #        auth_basic_user_file /etc/nginx/conf/.pass;

        location /ngx_status {
            stub_status on;
            allow all;
            access_log off;
            #            allow 127.0.0.1;
            #            allow 192.168.1.0/24;
            #            allow 192.168.100.0/24;
            #            deny all;
        }

        #--------- https://github.com/vozlt/nginx-module-vts
        #        location /ngx_statuss {
        #            vhost_traffic_status_display;
        #            vhost_traffic_status_display_format html;
        #            access_log off;
        #            allow 127.0.0.1;
        #            allow 192.168.1.0/24;
        #            allow 192.168.100.0/24;
        #            deny all;
        #        }

    }
    #==================================================
    #                nginx status stop
    #==================================================
}
```

#### nginx tcp端口映射

```nginx
error_log stderr notice;

worker_processes auto;
events {
  multi_accept on;
  use epoll;
  worker_connections 1024;
}

stream {
        upstream kube_apiserver {
            least_conn;
            server 192.168.8.161:6443;
            server 192.168.8.162:6443;
            server 192.168.8.163:6443;
                    }

        server {
            listen        127.0.0.1:6443;
            proxy_pass    kube_apiserver;
            proxy_timeout 10m;
            proxy_connect_timeout 1s;

        }
}
```



#### nginx补丁

http://jweiang.blog.51cto.com/8059417/1433675

[vhost_traffic_status第三方nginx状态模块](https://github.com/vozlt/nginx-module-vts)

