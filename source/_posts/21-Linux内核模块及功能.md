---
title: Linux内核模块及功能
date: 2020-06-19 14:49:19
layout:
updated:
comments:
categories:
tags:
---
## CentOS启动流程--POST--Bootloader（BIOS，MBR）--kernel -- rootfs ---switch root--sbin/init


## ldd 打印共享依赖库
`ldd /bin/ls | grep -o "/lib[^[:space:]]*"`

内核设计体系：
单内核、微内核
linux：单内核设计，但充分借鉴了微内核设计体系的设计有点，为内核引入了模块化机制；

## 内核的组成部分：
    kernel：内核核心，一般为bzimage，通常位于/boot目录、名称为vmlinuz-VERSION-release;
    kernel object：内核对象，即内核模块、一般防止与/lib/modules/VERSION-release/
        内核模块与内核核心版本一定要严格匹配；
        [ ]：N
        [M]：Module
        [*]：Y、编译至内核核心
    内核模块：动态装载和卸载；
ramdisk ：辅助性文件，并非必须的，这取决与内核是否能直接驱动rootfs所在的设备；
    目标设备驱动，例如SCSI设备的驱动；
    逻辑设备驱动，例如LVM设备的驱动
    文件系统，例如xfs文件系统；

    ramdisk：是一个简装版的根文件系统；（运行与内存的系统）
    下一步要做跟切换，持久化

## 内核信息获取：
### uname ：print system information
    -a ：all
    -r ：release号，发行号
    -m ：machine 平台架构
    -n ：当前主机名

模块信息获取：
### lsmod
显示当前系统的

### modinfo
显示模块详细信息；
-F field    ：仅显示指定字段的信息
-n 显示文件路径

### modprobe
实现模块动态装载卸载
默认是/etc/modprobe.conf
格式:
`modprobe MODULE_NAME` 装载模块
`modprobe -r MODULE_NAME` ：卸载模块

不要随便卸载模块，除非你知道自己在做什么；

### depmod
生成modules.dep和map文件；
内核模块依赖关系生成的工具；

### 模块的装载和卸载的另一组命令：
`insmode`
    `insmode [filename] [module options...]
        filename :模块的文件路径
`rmmode`
    `rmmod btrfs`
    rmmod [-f] [-s] [-v] [modulename]

ramdisk 文件的管理；
1. mkinitrd
   1. 为使用中的内核重新制作ramfs文件；
   2. --with=<module>：除了默认的模块之外需要装载至initramfs中的模块
   3. --preload=<module>:initramfs所提供的模块需要预先装载的模块；
   4. mkinitrd /boot/initramfs-$(uname -r) $(uname -r)
2. dracut   较为底层的制作initramfs文件的工具（选项较多，强大）
   1. dracut [option...] <image> [<kernel version>]
    例：`dracut initramfs-$(uname -r).img $(uname -r)`


## 操作系统上的两个伪文件系统：
/proc
    内核状态及统计信息的输出接口；同时，还提供了一个配置接口：/proc/sys
    参数：
        只读；信息输出/proc/#/*
        可写：可接受用户指定的一个“新值“来实现对内核某功能和特性的配置；/proc/sys


/sys    调优就是改这里的参数
必须充分理解内核各项参数

不应该使用文本编辑器命令去编辑
而是应该使用重定向的方式去覆盖里面的值

1. sysctl ：专用的命令

`sysctl net.ipv4.ip_forward`
`sysctl -w net.ipv4.ip_forward=1`

    sysctl -a ：显示所有可修改的值；
    sysctl variable； 对用/proc/sys目录下有对应关系的文件
    修改其值：
        #sysctl -w variable=value   写入
        -p ：从指定文件中加载；默认是/etc/sysctl.conf
        直接sysctl -p 就可以，必要时可以添加文件路径；

2. 文件系统命令
    查看：cat /proc/sys/net/ipv4/ip_forward
    设定：echo “VALUE” > /proc/sys/net/ipv4/ip_forward

注意，这两种方式设定的只是当前有效，重启失效
要永久有效必须保存至文件/etc/sysctl.conf 、/etc/sysctl.d/*.conf

内核参数：核心转发/proc/sys/net/ipv4/ip_forward
        vm.drop_cache   缓存的内存 （0、1、2）
        kernel.hostname 主机名
        /proc/sys/net/ipv4/icmp_echo_ignore_all 忽略ping操作

sysfs ：/sys 目录
输出内核识别出的各硬件设备的相关属性信息，也有内核对硬件特性的可设置参数，对此些参数的修改，即可定制硬件设备工作特性；

udev：通过读取/sys目录下的硬件设备信息，按需为硬件设备创建设备文件；
udev 是用户空间程序；正是/sys的存在才能创建设备

专用工具：
devadmin
hotplug
udev为设备创建设备文件时，会读取事先定义好的规则文件，一般在/etc/udev/rules.d/目录下，以及/usr/lib/udev/rules.d/

