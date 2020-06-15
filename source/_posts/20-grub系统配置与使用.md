---
title: 20.grub系统配置与使用
date: 2020-06-15 13:11:21
layout:
updated:
comments:
categories:
tags:
---
# GRUB （Boot Loader）

grub0.x grub legacy
    stage1  MBR
    stage1.5    MBR之后的扇区，让stage1中的bootloader能识别stage2所在的分区上的文件系统
    stage2  磁盘分区（/boot/grub）

    配置文件：/boot/grub/grub.conf <-- /etc/grub.conf
    
    stage2及内核通常防止与一个基本磁盘分区；
功用：
1. 提供一个菜单、并提供交互式接口
    e：编辑模式，用于编辑菜单：
    c：命令模式，交互式接口
2. 加载用户选择的内核或操作系统
    允许传递参数给内核
    可隐藏此菜单
3. 为菜单提供了包含机制
    为编辑菜单进行认证
    为启用内核或操作系统进行认证

## grep的命令行接口
help ：获取帮助列表
help keyword：详细帮助信息
find （hd0，0）/PATH/TO/FILE
root （hd#，#）设置为grub的根
kernel /PATH/TO/KERNEL_FILE ：设定本次启动时用到的内核文件；
initrd /PATH/TO/INITRAMFS_FILE:设定为选定的内核提供额外文件的ramdisk：
boot：引导启动选定的内核

手动在grub命令行接口启动系统：
grub>root (hd#,#)
grub> kernel /vmlinux---
grub> initrd /initramfs---
grub> boot

配置文件/boot/grub/grub.conf
    配置项：
    default=#：设定默认启动的菜单项：落单项（title）编号从0开始；
    timeout=#:指定菜单项等待选项选择的时长；
    splashimage=（hd#，#）/PATH/TO/XPM_PIC_FILE ：指明菜单背景图片的文件路径；
    hideenmenu：隐藏菜单
    title TITLE：定义菜单项”标题“，可出现多次，引导多个不同的内核
    root（hd#，#） ：grub查找stage2及kernel文件所在设备分区：为grub的根；
    kernel /PATH/TO/VMLINUZ_FILE :启动的内核
    initrd /PATH/TO/initramfs :内核匹配的ramfs文件；
    password [--md5] STRING :启动选定的内核或操作系统时进行认证；

grub-md5-crypt 命令
输入两次密码后生成一个加密字符串，拷贝至grub配置文件中；

进入单用户模式：
* 编辑grub菜单（选定要编辑的title，而后使用e命令）；
* 在选定的kernrl后附加
  * 1，s，S或single都可以
* 在kernel所在行，键入b命令；

## 安装grub：
在运行正常的系统
grub-install 命令：
可以安装到任意磁盘

例如：挂载另一块磁盘来做启动，
* 为磁盘分区，设置boot分区 /dev/sdb1 根分区/dev/sdb2
* 挂载分区 mount /dev/sdb1 /mnt/boot   -- mount /dev/sdb2 /mnt/sysroot
* grub install --root-directory=/mnt /dev/sdb
  * 在/mnt/boot目录拷贝vmlinuz和initramfs.img文件作为启动内核；
  * 编辑grub配置文件：
    ```bash
    default=0
    timeout=5
    title CentOS(test)
          root (hd0,0)
          kernel /vmlinuz ro root=/dev/sda1 
          initrd /initramfs.img
    ```
* 在/mnt/sysroot文件夹下建立FHS标准文件夹，作为根问价您系统，拷贝bash程序和动态依赖库文件到相同目录
  * mkdir -pv bin sbin mnt home usr lib lib64 proc etc media root ...
  * cp /bin/bash /mnt/sysroot/bin
  * ldd /bin/bash
  * cp *.so /mnt/sysroot
  * chroot /mnt/sysroot
grub配置文件中 kernerl /vmlinuz ro root=/dev/sda1 (selinux=0) init=/bin/bash

有点类似于ARClinux安装的流程；

## 手动修复损坏的grub：(本机的grub)
* grub-install --root-directory=/ /dev/sda
  * --root-directory=（boot目录的父目录）
* grub命令提示符下安装（要求有boot目录，且存在stage1，stage1.5文件）
    grub> root (hd0,0)
    grub> setup （hd0）
    grub> exit

* 进入系统安装光盘，进入救援模式：
  * Rescue installed system
  * 或者ESC键输入linux rescue （类似winPE）
  * -->continue-->挂载在/mnt/sysimage-->shell(start shell)
  * chroot /mnt/sysroot
  * 在命令提示符下grub-install
  * exit --> reboot

练习：
1. 添加硬盘，提供直接单独运行bash系统
2. 破坏本机grub stage1，而后在救援模式下修复之；
3. 为grub设备保护功能；

grub的保护password
grub-crypt --sha-256		-->		grub-crypt
grub-crypt --md5			-->		grub-md5-crypt
/etc/grub.conf文件增加下面这一行，则启动时如果需要编辑grub选项需要先按P键输入密码
password --encrypted ^9^32kwzzX./3WISQ0C

如果在特定title下添加
password --encrypted STRING 则选择引导这个内核或者系统时需要先认证；

如：

grub-md5-crypt

password --md5 STRING

```bash
default=0
timeout=5
splashimage=(hd0,0)/grub/splash.xpm.gz
hiddenmenu
password --md5 $1$OOmpy0$wue.j4urx8NNf6wfQZkmF/		#密码的MD5加密形式
title CentOS (2.6.32-754.27.1.el6.x86_64)
        root (hd0,0)
        kernel /vmlinuz-2.6.32-754.27.1.el6.x86_64 ro root=/dev/mapper/VolGroup-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=VolGroup/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=auto rd_LVM_LV=VolGroup/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
        initrd /initramfs-2.6.32-754.27.1.el6.x86_64.img
title CentOS 6 (2.6.32-754.el6.x86_64)
        lock		#保护开启
        root (hd0,0)
        kernel /vmlinuz-2.6.32-754.el6.x86_64 ro root=/dev/mapper/VolGroup-lv_root rd_NO_LUKS LANG=en_US.UTF-8 rd_NO_MD rd_LVM_LV=VolGroup/lv_swap SYSFONT=latarcyrheb-sun16 crashkernel=auto rd_LVM_LV=VolGroup/lv_root  KEYBOARDTYPE=pc KEYTABLE=us rd_NO_DM rhgb quiet
        initrd /initramfs-2.6.32-754.el6.x86_64.img
```



grub-crypt

password --sha-256 STRING

在title后面root上一行可以给要保护的启动项添加lock字段，则自动时必须按p键输入密码才能启动；

```
# (0) Arch Linux
title  Arch Linux
lock
root   (hd0,1)
kernel /boot/vmlinuz-linux root=/dev/disk/by-label/Arch_Linux ro
initrd /boot/initramfs-linux.img
```



如果boot分区单独分区的话，此分区就是grub的根分区；
/vmlinuz 
/grub/grub.conf

如果没有单独分区的话，
这个分区是根，那么vmlinuz文件就是在/boot/vmlinuz
/boot/grub/grub.conf

grub访问的一般为基本磁盘分区
单独分区是因为根文件系统比较复杂；


如何识别设备：
hd#，#      两个数字的含义：第几块磁盘，第几个分区；
（hd0，0） 第一个磁盘的第一个主分区；

grub1.x grub2


