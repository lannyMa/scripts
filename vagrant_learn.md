

- provider: vbox vmware
- box: 镜像.vagrant根据privider提供了基础镜像,在s3上,可以基于这些做自己的
- project: 一个目录+目录中的vagrantfile.项目的虚拟实例并不存在于这里
- vagrantfile: vagrant的配置文件.使用ruby描述.定义了所用的box.网络.共享目录.privision脚本
- provisioning: 虚拟机实例启动后,所要做的基础配置
- plugin
- 