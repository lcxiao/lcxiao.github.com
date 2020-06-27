---
title: 23.anaconda配置定制自动化安装Linux
date: 2020-06-27 07:30:47
layout:
updated:
comments:
categories:
tags:
---
安装操作系统的过程就是规划系统，把需要的功能和响应的文件放到合适的位置；
创建用户
init程序
可以自动化实现

CentOS系统安装：
bootloader--kernel（initrd（rootfs））--anaconda
安装程序：anaconda
必须先启动内核：
提供一个界面。首先，创建一个bootloader（安装在光盘或者U盘）
之后加载设备上某个路径的kernel（vmlinuz）
之后借助于initrd（rootfs）直接内存作为根文件系统；
之后启动anaconda程序（作为sbin/init）用户空间的第一个程序

anaconda两个界面
tui：基于cureses的文本配置窗口
gui：图形界面

CentOS的安装过程启动流程：
MBR：boot.cat
stage2：isolinux/isolinux.bin
    配置文件：isolinux/isolinux.cfg

每个对应的菜单选项：
    加载内核：isolinux/vmlinuz
    向内核传递参数：append initrd=initrd.img 

获取根文件系统，并启动anaconda
    默认界面是图形界面；至少需要512MB内存，否则无法使用图形界面
    如果需要显示指定启动tui接口，向启动内核传递一个参数“text”即可；

    ESC：
    boot：linux text

注意：上述内容一般位于引导设备（光盘或者U盘）或者是网络上；
anaconda启动之后剩余的过程，后续的anaconda及其安装用到的程序包等；
可以来自于程序包仓库，此仓库的位置可以为：
* 本地光盘
* 本地硬盘
* ftp服务器
* http服务器
* nfs服务器

如要手动指明安装仓库：则按ESC键
    boot：linux method（询问用户，让用户选择安装方法）


anaconda的工作过程：
安装前配置阶段
    安装过程使用的语言
    键盘类型
    安装目标存储设备
        Basic Storage：本地磁盘
        Special Storage：iscsi
    设定主机名
    配置网络接口
    时区
    管理员密码
    设定分区方式及MBR的安装位置；
    创建一个普通用户；
安装阶段
    在目标磁盘创建分区并执行格式化
    将选定的程序包安装至指定位置
    安装bootloader
首次启动
    iptables
    selinux
    core dump（核心转储，崩溃时，把内存数据备份下来）（可做分析用）（内存小于2G无法开启）

anaconda配置方式
    1. 交互式配置方式
    2. 支持通过读取配置文件中实现定义好的配置项自动完成配置；遵循特定的语法格式，此文件即为kickstart文件；

此文件可以放在本地文件服务器上；

安装引导选项：
text：文本安装方式
method：手动指定使用的安装方法
与网路相关的引导选项：
    ip=IPADDR
    netmask=NETMASK
    gateway=GW
    dns=DNS_SERVER_IP
远程访问功能相关的引导选项：
    VNC
    vncpasswd='password'
启动紧急救援模式：
    rescue
装载额外驱动：
    dd

www.redhat.com/docs 《installation guide》


## CentOS系统安装：
    ks：指明kickstart文件的位置
    ks=
        DVD driver：ks=cdrom:PATH/TO/KICKSTART_FILE
        Hard_Driver:ks=hd:/DEVICE/PATH/TO/KICKSTART_FILE
        HTTP Server  ks=http://HOST[:PORT]/PATH/TO/KICKSTART_FILE
        FTP Server ks=ftp://HOST[:PORT]/PATH/TO/KICKSTART_FILE
        HTTPS Server: ks=https://HOST[:PORT]/PATH/TO/KICKSTART_FILE

    kickstart文件的格式
        命令段  指定各种安装前配置选项，如键盘类型等；
            必备命令
            可选命令

        程序包段    
            指明要安装的程序包，以及包组，也包括不安装的程序包；
            %packages 表示程序包段开始，中间的都表示程序包
            @group_name 安装包组
            package 安装
            -package    不安装
            %end        结束

        脚本段
            %pre 安装前脚本
                运行环境：运行安装介质上的微型linux系统环境
            %post 安装后脚本
                运行环境：安装完成的系统
            
### 命令端中的选项
auth | authconfig   认证方式配置
`auth --enableshadow --passalgo=sha512`
bootloader  定义bootloader的安装位置及相关配置
`bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sda`
Keyboard layouts    设置键盘类型
`keyboard --vckeymap=us --xlayouts='us'`
System language 语言类型
`lang en_US.UTF-8`
part    分区布局
```
   
    # Disk partitioning information
    part /boot --fstype="xfs" --ondisk=sda --size=1024
    part / --fstype="xfs" --ondisk=sda --size=17404
    part swap --fstype="swap" --ondisk=sda --size=204
```
 Partition clearing information 清空磁盘分区
    clearpart --none --initlabel

volgroup：创建卷组
logvol：

Root password       设置密码：
rootpw --iscrypted $6$TWt34GTGFsaxobTC$cR4TOgqr/2uf7RDAPFlPT6QgPbhoMZVNsKMAKpk3FduEsGB4F92Gx8Vivm.26QdEnnGlCUcbMWHQYqoA8QPnz.

使用openssl手动生成一个：$ openssl passwd -1 -salt `openssl rand -hex 4`

System timezone 时区
timezone Asia/Shanghai --isUtc --nontp

### 可选命令：
install OR upgrade ：安装或升级
text ：安装界面类型 text为tui ，默认为GUI
network ：配置网络接口
    network --onboot=yes --device eth0 --bootproto dhcp --noipv6
firewall： 防火墙
    firewall --disable
selinux ：SELinux
    selinux --disable

系统安装之后禁用防火墙：
    CentOS6：
        service iptables off
        chkconfig iptables off
    CentOS7：
        systemctl stop firewalld
        systemctl disable firewalls
    
系统安装之后禁用selinux
    /etc/sysconfig/selinux 修改SELINUX的值为下面2.3项即可
        enforcing
        permissive
        disable
    getenforce  获取状态
    setenforce 0 设置关闭，立即生效
编辑/etx/sysconfig/selinux 或者 /etc/selinux/config

halt、poweroff 或者reboot 安装完成之后的行为：
repo：指定安装时使用的repository：
    repo --name="CentOS" --baseurl=cdrom:sr0 --cost=100
url:指明安装时使用的repository，但为url格式：
url --url=http://xxxx
必须定义好网络，能够访问才行；

其他可参考官方文档：《Installation Guide》

### 如何编辑anaconda-ks.cfg文件
yum install system-config-kickstart包


ESC 
linux ip=xxx.xxx.xxx.xxx netmask=255.255.255.xxx ks=http://PATH/to/file

把光盘的isolinux文件夹拷贝过来
把ks文件复制过来
放在光盘根目录或者isolinux文件夹下都可以
创建光盘镜像
mkisofs -R -J -T -v --no-emul-boot --boot-load-size 4 --boot-info-table -V "光盘名字" -c isolinux/boot.cat -b isolinux/isolinux.bin -o /root/boot.iso myboot/



网络启动
dhcp服务器
tftp服务器
网络仓库


自动化安装过程
DVD ： ks=cdrom：/PATH/TO/KS_FILE
HTTP: ks=http://HOST:PORT/PATH/TO/KS_FILE


