#!/bin/bash
############################################################
# $Name:         common_service_status.sh
# $Version:      v1.3
# $Function:     monitor common_service status
# $Author:       Scott.wang
# $organization: pp100.com
# $Create Date:  2017-3-15 16:17:42
# $Description:  Monitor PHP、Nginx、Redis-server、mycat、squid、memcached 
############################################################

nginx_status(){
        /sbin/pidof  nginx  | wc -l
}

php_status(){
        /sbin/pidof  php-fpm  | wc -l
}
redis-server_status(){
        /sbin/pidof  redis-server | wc -l
}
postgres_service_status(){
        /sbin/pidof postgres  | wc -l
}
#added  by v1.2
mycat_status(){
       /bin/ps aux | grep "/data/mycat/bin"  | grep -v grep  > /dev/null 
       if [[ $? -eq 0 ]]; then
         echo 1
     else
         echo 0 
     fi
}
squid_status(){
        /sbin/pidof  squid | wc -l
}
memcached_status(){
        /sbin/pidof  memcached | wc -l
}
#added  by v1.2
mysql_status(){
        /sbin/pidof  mysqld | wc -l
}
#added by v1.3
ntpd_status(){
    /sbin/pidof  ntpd |  wc -l 
}
main(){
        case $1 in
                nginx_status)
                        nginx_status ;
                        ;;
                php_status)
                        php_status ;
                        ;;
                redis-server_status)
                        redis-server_status ;
                        ;;
                mycat_status)
                        mycat_status ;
                        ;;                        
                squid_status)
                        squid_status ;
                        ;;                        
                memcached_status)
                        memcached_status ;
                        ;;    
                postgres_service_status)
                        postgres_service_status ;
                        ;;         
                mysql_status )
                        mysql_status ;
                        ;;                           
                ntpd_status )
                        ntpd_status;
                        ;;
                *)
                echo $"Usage: $0 {php_status key|nginx_status key | redis-server_status key | ntpd_status }"
                echo $"Usage: $0 {mycat_status key | memcached_status key | postgres_service_status key | mysql_status key }"
        esac
}
main $1 
