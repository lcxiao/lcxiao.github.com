---
title: 26.Systemd
date: 2020-06-27 07:32:05
layout:
updated:
comments:
categories:
tags:
---
Systemd
POST--Bootsequeue --bootloader（MBR）--kernel--rootfs-init
centos5 ：Sysv
centos6 ：upstart
centos7 ：systemd

新特性:
系统引导时实现服务并行启动；
按需激活进程
系统状态快照
基于依赖关系定义服务控制逻辑

核心概念 unit
    由其相关配置文件进行标识、识别和配置；文件中主要包含了系统服务、监听的socket、保存的快照以及其他与init相关的信息；
    这些配置文件主要保存在
    /etc/systemd
    /lib/systemd/system
    /usr/lib/systemd/system
    /run/systemd/syetem

    
unit的常见类型；
Service unit 文件扩展名是.service，用于定义系统服务
Target unit 文件扩展为.target 用于模拟实现“运行级别”
Device unit  .device 用于定义内核识别的设备
Mount unit .mount 定义文件系统挂载点 （用户组和名称空间）
Socket unit 。socket 用于标识进程间通信用到的socket文件；
Snapshot .snapshot 管理系统快照
Swap unit .swap 用于标识swap设备
Automount unit .automount 文件系统自动点设备
Path unit .path 用于定义文件系统中的文件或目录

关键特性：
    基于socket的激活机制：socket与程序分离
    基于bus的激活机制；
    基于device的激活机制；
    基于path的激活机制；
    系统快照：保存各unit的当前状态信息于持久存储设备中；实现回滚
    向后兼容SYSV的init脚本
        /etc/init.d
    不兼容：
        systemctl 的命令是固定不变的；
        非由systemd启动的服务，systemctl无法与之通信，无法控制此服务；（自己写个unit）

管理系统服务；
centos7 ：service类型的unit文件：
 systemctl [OPTIONS...] COMMAND [NAME...]

启动、停止、重启、状态：
service NAME start  ===》 systemctl start NAME
stop
restart
status
    loaded：表示已装载，被管理
    Active：inactive（停止dead）（disabled）（不自启）
    Active: active (running）（运行中）
    
条件式重启：
    systemctl try-restart NAME

重载或重启服务：
systemctl reload-or-try-restart NAME
reload-or-restart
reload-or-try-restart

查看服务当前启动与否？
systemctl is-active NAME

查看所有已激活的服务；
systemctl list-units 

systemctl list-units --type service
查看所有服务（已激活和未激活）
systemctl list-units -t service --all
chkconfig --list

开机自启
chkconfig NAME on
systemctl enable NAME

关闭自启
chkconfig NAME off
systemctl disable NAME


查看某服务是否能开机自启
systemctl is-enabled NAME
chkconfig --list NAME

禁止某服务设置为开机自启：
systemctl mask NAME

取消此限制
systemctl unmask NAME


查看服务的依赖关系：
systemctl list-dependencies NAME

管理target units：
运行级别：
0 == runlevel0.target poweroff.target
 systemctl poweroff

1 == runlevel.target rescue.target

2 == runlevel2.target  multi-user.target
3 == runlevel3.target   multi-user.target
4 == runlevel4.target   multi-user.target

5 == runlevel5.target   graphical.target

6 == runlevel6.target   reboot.target

级别切换： 
init N 
systemctl isolate NAME.target

查看级别： 
runlevel
systemctl list-units -t target

查看所有target
systemctl list-units -t target --all

获取默认运行级别
systemctl get-default

修改默认运行级别
systemctl set-default multi-user.target 

sysv：修改inittab文件

切换至紧急救援模式：
systemctl rescue    会加载驱动以及1级别的

切换至紧急模式：
systemctl emergency    各种设置及驱动都不会，最简洁的模式

其他常见命令
    关机：systemctl halt ，systemctl poweroff 
    重启：  systemctl reboot
    挂起：systemctl suspend
    快照：systemctl hibernate
    快照并挂起：systemctl hybrid-sleep、

SERVICE unit 文件组成
通常三部分组成
\[Unit] ：定义与unit类型无关的通用选项；用于提供unit的描述信息，unit行为以及依赖关系等；
\[Service] :与特定类型相关的专用选项；此处为service类型；
\[Install] ：定义由systemctl enable 以及 systemctl disable 命令在实现服务启用或禁用时用到的一些选项；

Unit段的常用选项；
    Description：描述信息；意义性描述
    After：定义unit的启动次序；表示当前unit应该晚于哪些unit启动；其功能与Before相反；
    Requles ：依赖到的其他units，强依赖，被依赖的units无法激活时，当前unit无法激活
    Wants：依赖到的其他units；弱依赖；
    Conflicts：定义units之间的冲突关系；

Service段常用选项：
    TYPE:  定义影响ExecStart及相关参数的功能的unit进程启动类型；
        类型：
            simple：父进程和子进程（nginx之类的）
            forklng：后续进程启动之后这个进程会退出
            oneshot：
            dbus：后续进程只有在主进程得到
            notify：类似于simple
            idle：类似simple
    Environment: 定义环境配置文件，在ExecStart之前启动，并为之提供一些自定义选项；
    ExecStart ：指明启动unit要运行的命令或脚本；ExecStartPre、ExecStartPost
    ExecReload
    ExecStop ：指明停止unit要运行的命令或脚本
    Restart：意外终止。。


Install段：
    Alias：
    RequlredBy：被哪些unit所依赖
    WantedBy：被哪些units所依赖

注意：对于新创建的unit文件，或修改了的unit文件，必须要通知systemd重载此配置文件；
systemctl daemon-reload


练习：为当前系统的httpd服务提供一个unit文件

