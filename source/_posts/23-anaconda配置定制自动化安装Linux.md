---
title: 23.anaconda配置定制自动化安装Linux
date: 2020-06-22 14:58:07
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

www.redhat.com/docs <<installation guide>>



