---
title: 19.Linux系统启动流程
date: 2020-06-15 13:10:58
layout:
updated:
comments:
categories:
tags:
---
# 系统启动流程
Linux系统组成部分：内核，根文件系统
内核：进程管理，内存管理、网络协议栈、文件系统、驱动程序、安全功能（加密解密协议栈。selinux）
    IPC：Inter Process Communication
    消息队列、semerphor、shm
    socket
文件系统工作在内核空间

启动分区：/boot
rootfs：FHS：/bin /sbin /lib /proc /sys /etc
init 程序--


内核设计流派：
* 单内核 ：所有功能集成与同一个程序；
  * Linux
* 微内核 ：每种功能使用一个单独的子系统实现；
  * Windows，Solaris

Linux内核特点：
* 支持模块化    .ko（Kernel Object）
* 支持模块运行时动态装载或卸载；
* ramdisk 使用缓存和缓冲来加速对磁盘上的文件访问；

Linux内核组成部分：
* 核心文件  /boot/vmlinuz-VERSION-release
* 模块文件  /lib/modules/VERSION-release


vmlinux ----> ramdisk ----> rootfs
内核    --  临时根文件系统  --  切换真正的根文件系统
ramdisk：
centos5 /boot/initrd-VERSION-release.img
CentOS6,7: /boot/initramfs-VERSION-release.img

模块文件：/lib/modules/VERSION-release 



PC架构的主机系统启动流程，（MBR）：
POST：rom（只读）CMOS --BIOS--basic input output system
ROM + RAM 
加电自检
Boot Sequence：启动次序,按次序查找各引导设备；第一个有引导程序的设备即为本次启动要用到的设备；
bootloader：引导加载器，程序；
    windows：ntloader
    linux：
        LILO：Linux loader
        grub ：grand uniform BootLoader
        grub0.X grub legacy
        grub1.x grub2
功能：提供一个界面，允许用户选择要启动的系统或者不同版本的内核，把用户选定的内核装载到RAM中的特定空间中，解压、展开而后把系统控制权移交给内核；

MBR：Master Boot Record
    512bytes:
        446bytes:bootloader
        64bits:fat
        2bytes:55AA
GRUB:
    Bootloader:1st stage
    partition :filesystem driver ,1.5 stage
    partition : /boot/grub 2nd stage

之后是kernel：
    自身初始化：
        探测可识别到的所有硬件设备
        加载硬件驱动程序；（有可能会借助于ramdisk加载驱动）
        以只读方式挂载根文件系统；
        运行用户空间的第一个程序；INIT?
    ramdisk 动态创建；
        
INIT文件类型:
SYSV,Upstart,Systemd
    CentOS5:SysV init 配置文件/etc/inittab
    CentOS6: Upstart /etc/inittab   /etc/init/*.conf
    CentOS7:Systemd 配置文件：/usr/lib/systemd/system/,/etc/systemd/system
注意GPT、UEFI可能不一样？


安卓手机使用lilo引导





对自己编译的内核来说，ramdisk可以是非必须的，（直接把硬盘驱动编译至内核）
可以使用工具创建：
CentOS5：mkinitrd
centos6，7
initramfs 工具程序
dracut ，mkinitrd


系统初始化流程（内核级别）：POST--BootSequence（BIOS）--BootLoader（MBR）--kernel(ramdisk)--rootfs(readonly)--/sbin/init?

sbin/init:
SysV init:
运行级别 （0-6）
* 0 ：关机
* 1 单用户级别  root 无需认证 ；维护模式
* 2 带网络的单用户  启动网络功能，不会启动NFS，维护模式
* 3 multiuser mode 多用户。完全认证，完整模式
* 4 预留，未用
* 5 graphic mode 图形界面
* 6 重启

默认3 5
级别切换 init #
级别查看：
who -r
runlevel

配置文件： /etc/inittab

CentOS5：每行定义一种action以及与之对应的process
id：runlevels：action：process
    id：一个任务的标识符
    runleves：在哪些级别启动此任务；#，###，也可以为空，表示所有级别；
    action：在什么条件下启动此任务；
    process：任务；

action：
    wait：等待切换至此任务所在的级别时执行一次；
    respawn：一旦此任务终止，就自动重新启动之；
    initdefault：设定默认运行级别；此时，process省略；
    sysinit：设定系统初始化方式，此处一般为指定/etc/rc.d/ec.sysinit脚本；

例如：
id：3:initdefault:
si::sysinit:/etc/rc.d/ec.sysinit
l0:0:wait:/etc/rc.d/rc 0
    意味着去启动或关闭/etc/rc.d/rc3.d/目录下的服务脚本所控制服务；
    K* ：要停止的服务；K##*，优先级，数字越小，越是优先关闭；依赖的服务先关闭；而后关闭被依赖的；
    S*：要启动的服务；S##*，优先级，数字越小，越是优先启动，被依赖的服务先启动，而依赖的服务后启动；



rc脚本：接受一个运行级别数字为参数；
脚本框架:
for srv in /etc/rc.d/rc#.d/K*;do
    $srv stop
done

for srv in /etc/rc.d/rc#.d/S*;do
    $srv start
done

/etc/init.d/* 脚本执行方式：
service SRV_SCRIPT {start | stop | status |restart}
/etc/init.d/SRV_SCRIPT {start | stop |status |restart}

Chkconfig 管理这些脚本软连接的
管控/etc/init.d /每个服务脚本在各级别下的启动和关闭状态；

chkconfig SERVICE on | off
脚本文件中 “-” 表示 所有级别全关 
chkconfig --list

刚添加的脚本还没有创建链接？
chkconfig --add
chkconfig --del

#chkconfig：LLL NN NN   LLL：运行级别。NN：开启优先级 NN：关闭优先级  
#description：说明

修改指定的链接类型
chkconfig {--level LEVELS} name 《on | off | reset》
默认2345

正常级别下，最后一个启动的服务S99local没有链接至/etc/init.d下的某脚本，而是链接到了/etc/rc.d/rc.local脚本；因此，不方便或者不需写服务脚本的程序期望开机自动运行时，直接放置于此脚本文件中即可；

rc.local
用户自定义开机运行的程序

tty1：:2345：respawn：/usr/sbin/mingetty tty1
mingetty会调用login，
打开虚拟终端的程序除了mingetty之外，还有诸如getty等；


系统初始化脚本 /etc/rc.d/rc.sysinit
* 设置主机名
* 设置欢迎信息
* 激活udev和selinux （udev主要是创建设备文件）
* 挂载/etc/fstab文件中定义的所有文件系统；
* 检测根文件系统，并以读写方式重新挂载根文件系统；
* 设置系统时钟
* 根据/etc/sysctl.conf文件来设置内核参数
* 激活LVM及软RAID设备
* 激活swap设备；
* 加载额外需要的驱动程序；
* 清理操作


总结（用户空间的启动流程）：/sbin/init (etc/inittab)
设置默认运行级别 --> 运行系统初始化脚本 ，完成系统初始化 --> 关闭对应级别下要停止的服务，启动对应级别下需要开启的服务 --> 设置登录终端 --> 【启动图形终端】（可选）；

通读/etc/rc.d/rc.sysinit 文件；搞清楚每一步做了什么？


CentOS6：
init程序：upstart，但依然为/sbin/init（/etc/inittab）
/etc/init/*.conf /etc/inittab （仅用于定义默认运行级别）

注意：*.conf 为upstart风格的配置文件；

rcS.conf
init-system-dbus.conf
start-ttys.conf


CentOS7: Systemd,配置文件：/usr/lib/systemd/system/* , /etc/systemd/system/*

systemctl get-default
systemctl set-default multi-user.target

systemctl status
完全兼容SysV脚本机制；因此，service命令依然可用，但是，建议使用systemctl命令来控制服务

systemctl {status | start | stop | restart | reload} SERVICE

CentOS系统启动流程；

