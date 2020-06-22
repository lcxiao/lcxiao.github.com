---
title: 22.Linux内核模块功能定制
date: 2020-06-22 14:57:32
layout:
updated:
comments:
categories:
tags:
---
# Linux内核模块功能定制
## 编译内核：

程序包的编译安装：
./configure ,make ,make install
配置参数，make是项目构建工具，调用各种编译工具完成构建，
二进制文件，库文件，配置文件，帮助文件，make install 完成复制

编译前提：开发环境
开发工具（gcc）、开发库（API）库和头文件/usr/include/

开源：源代码--可执行格式
发行版：以通用为目标；主包:支包 选择性安装功能
实在需要发行版没有编译进的功能的话，只有自己编译了


## 准备工作：
* 开发环境；
* 目标主机硬件设备的相关信息；
* 获取目标主机系统功能的相关信息，要启用的文件系统；
* 获取内核代码：www.kernel.org

CentOS6,7：
    Development Tools
    Server Platform Development

确保安装的包组里面有ncurses包

获取目标主机上硬件的信息
CPU:
    cat /proc/cpuinfo
    lscpu
    x86info -a(包x86info)
PCI:
    lspci
    -v
    -vv

USB:
    lsusb
    -v
    -vv

lsblk

全部硬件设备信息：
    hal-device
    lshw


## 编译过程
    解压内核文件到/usr/src
    tar xvf kernel.tar.gz -C /usr/src
    ln -sv linux-x.x.x linux
    cd linux
    make menuconfig         #编译内核选项
    make -j CPU核心数
    make modules_install    #安装内核模块
    make install            #安装内核

make --help


## screen:
    打开新的screen窗口：screen
    命名新窗口：screen -S TITLE_NAME
    拆除screen： ctrl+a，d
    列出screen：screen -ls
    连接至screen：screen -r SCREEN_ID
    关闭screen：在screen内部exit

screen不会因为ssh的连接断开而中断任务

### 模板文件
复制/boot目录下的配置文件作为模板，之后修改这个文件

内核配置模板文件：
有些发行版在/boot目录下有配置文件模板
有的在/proc/config.gz

## （1）配置内核选项
### 详细说明：
配置选项：
* make config ：基于命令行以遍历的方式去配置内核中可配置的每个选项；
* make menuconfig ：基于ncurses 方式的配置窗口
* make gconfig ：基于gtk开发环境的窗口界面界面；桌面平台开发包组
* make xconfig : 基于QT开发环境的窗口界面

支持“全新配置”模式进行配置
* make defconfig ：基于内核为目标平台提供的“默认”为模板进行配置；
* make allnoconfig：所有选项为no；基于此选项来定制

### 编译：
* make -j # 多线程编译（提高编译速度）
* 编译内核中的部分功能
  * 只编译某子目录中的代码--切换到源码树（cd /usr/src/linux）(make path/to/dir)
  * 只编译一个特定的模块--切换到源码树（编译某个模块的源码,例如xxx.c）(make xxx.ko)（编译完成之后记得要自行复制到相对应的目录中去）(驱动就是/lib/modules/xxxx/driver/)
  * 交叉编译：目标平台与编译操作不同平台
    * make ARCH=arch_name
    * 帮助信息：make ARCH=arm help 获取目标平台帮助信息

### 如何在执行编译操作的内核源码树上做重新编译：
* make clean    ：清理编译生成的绝大多数文件，但会保留config文件，以及编译外部模块所需要的文件；
* make mrproper ：清理编译生成的所有文件，包括配置生成的config文件以及某些备份文件
* make distclean    ：相当于mrproper ，额外清理各种patches以及编辑器备份文件；




