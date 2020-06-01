---
title: Linux实现LVM逻辑卷及快照
date: 2020-06-01 04:26:12
layout:
updated:
comments:
categories:
tags:
---
# LVM2

Logical Volume Manager, Version2;

dm device mapper:
将一个或者多个底层块设备组织成一个逻辑设备;

## PV

查看 :
    pvs    #简要;
    pvdisplay   #详细;
创建 :
    pvcreate /dev/DEVICE 



## VG

**查看:**
    vgs
    vgdisplay
**创建:**
    vgcreate VG_NAME PV_DEVICE

-s PE大小

-P 最大PV数





**例如：**

vgcreate myvg /dev/sdb1 /dev/sdc1

扩展：
    vgextend vgNAME PhysicalDevicePath [PhysicalDevicePath] #扩展;
缩减：
    vgreduce vgNAME PhysicalDevicePath [PhysicalDevicePath] #缩减;
**修改**
**删除**
顺序执行
    lvremove
    vgremove
    pvremove

## LV

**查看**
    lvs #简要;
    lvdisplay   #详细;
**创建**
    lvcreate -L #[mMgGtT] -n NAME VolumeGroup(VG) 

**修改**
扩容：

1. 逻辑边界 

2. 物理空间
   lvextend -L #目标大小 [+][mMgGtT] #要增加的大小 /dev/VG_NAME/LV_NAME #扩展物理大小;

   example: lvextend --size +2g /dev/testvg/testlv

3. resize2fs /dev/VG_NAME/LV_NAME  #重新设置分区大小;

缩减：

1. 逻辑边界 #先卸载文件系统，离线进行，在线有文件丢失风险;
2. 物理空间
   umount /dev/VG_NAME/LV_NAME
   e2fsck -f /dev/VG_NAME/LV_NAME
   resize2fs /dev/VG_NAME/LV_NAME #[mMgGtT]
   lvreduce -L [-][mMgGtT] /dev/VG_NAME/LV_NAME    #注意 `-L` 和 + 的区别；# 如果是其他文件系统，使用其他工具;
   mount
   删除：
   lvremove /dev/VG_NAME/LV_NAME
   vgremove
   pvremove

## 练习1:

创建一个至少有两个PV组成的大小为20G的名为testvg的VG；要求PE大小为16MB；
而后在卷组中创建大小为5G的逻辑卷testlv；挂载至/users目录；

`pvcreate /dev/sdb1 /dev/sdc1`

`vgcreate -s 16m testvg /dev/sdb1 /dev/sdc1`

`lvcreate -L 5G -n testlv testvg`

`mkfs -v -t ext4 /dev/mapper/testvg-testlv`

`mkdir -pv /users`

`mount /dev/mapper/testvg-testlv /users/`

练习2：
新建用户archlinux，要求其家目录为/users/archlinux, 而后su切换至archlinux用户，复制/etc/pam.d目录至自己的家目录；

`mkdir -pv /users/archlinux`

`useradd -d /users/archlinux/ archlinux`

`su archlinux`

`cp -av /etc/pam.d ~`



练习3：扩展testlv至7G，要求archlinux用户的文件不能丢失；

umount /dev/mapper/testvg-testlv

lvextend -L 7g /dev/testvg/testlv

e2fsck -f /dev/mapper/testvg-testlv

resize2fs /dev/mapper/testvg-testlv 7g

mount /dev/mapper/testvg-testlv /users/

练习4：收缩testlv至3G，要求archlinux用户的文件不能丢失；

umount /dev/mapper/testvg-testlv 
e2fsck -f /dev/mapper/testvg-testlv 
resize2fs /dev/mapper/testvg-testlv 3g
lvreduce -L 3g /dev/testvg/testlv 
mount /dev/mapper/testvg-testlv /users/



## 文件系统挂载使用中的问题：

挂载光盘设备：
光盘设备文件: /dev/
    IDE: /dev/hdc
    SATA: /dev/sr0
符号链接文件：
    /dev/cdrom
    /dev/dvdrom
    /dev/dvd

挂载：
mkdir -pv /medir/cdrom
mount -r /dev/sr0 /media/cdrom

U 盘的挂载：
新挂载的设备，以大小来判断：
    /dev/sdx
    fdisk -l

一个小命令的应用
DD： 一个实现文件底层拷贝的工具
复制命令
convert and copy a file
用法：
dd if=/PATH/FROM/SRC of=/PATH/TO/DEST
bs=# blocksize 块大小 默认为字节；
count=# 数量 多少个上面的块；
因为是复制的底层实现，所以拷贝效率高：
直接拷贝磁盘：
dd if=/dev/sda of=/dev/sdb

备份MBR
dd if=/dev/sda of=/mbr.bak bs=512 count=1

损坏MBR #瞬间让一个磁盘分区表失效
dd if=/dev/zero of=/dev/sda bs=512 count=1

精准破坏BootLoader：
dd if=/dev/zero of=/dev/sda bs=256 count=1

## 两个特殊设备：

/dev/null   数据黑洞
/dev/zero   吐零机

测试硬盘系统读写速度：
dd if=/dev/zero of=/dev/null bs=1G count=2

# 快照： snapshot

对文件系统做快照，相当于对文件系统在某一时间做一次快速扫描，
备份
序列化
文件序列化后如何还原；
因为备份的时间短，在备份时后面的数据如果发生改变的话，会造成备份后的数据和原来想要备份的不一样
所以需要对文件做一次快照；
快照卷，类似于硬链接，执行原来的文件，本来是不存在任何数据的，监控原数据，任何时刻，当文件要变化时，拷贝一份；

使用 LVM 创建 Linux 快照
`lvcreate -s [-L <size>] -n SNAP_VOLUME SOURCE_VOLUME_PATH`
如果不指定大小，快照会创建为瘦快照。
`lvcreate -s -L 1G -n linux01-snap /dev/lvm/linux01`
快照将被创建为 /dev/lvm/linux01-snap 卷。

-p #读写权限 -s -n snapshot_lv_name 


监视快照
`lvdisplay SNAP_VOLUME`

删除 Linux 快照
`lvremove SNAP_VOLUME_PATH`

例如：
`sudo lvremove /dev/lvmvg/linux01-snap`


存储快照的原理：

![](https://pic3.zhimg.com/v2-dbdc599a74b0cfa0b311e56e2642797d_1200x500.gif)
快照是完全可用的拷贝，但不是一份完整的拷贝;

存储快照的使用场景:
场景一：
存储快照，是一种数据保护措施，可以对源数据进行一定程度的保护，通俗地讲，可以理解为----后悔药。
![](https://pic1.zhimg.com/80/v2-ce2e26a65fb74f821def18ff0c9fc0d4_720w.jpg)
如上图，假设在t0时刻，有一份完整的源数据，我们在t1时刻，针对这份源数据创建一份快照。

t2时刻，若因为各种原因（误操作、系统错误等）导致源数据损毁，那么，我们可以通过回滚（rollback）快照，将源数据恢复至快照创建时的状态（即t1时刻），这样，可以尽量降低数据损失（损失的数据，是t1到t2之间产生的数据）。

这种功能，常用于银行、公安户籍、科研单位等。操作系统、软件升级或机房设备更替，一般会选择在夜间或其他无生产业务时，进行高危操作，操作前会对数据进行快照，若操作失败，则将快照进行rollback，将源数据恢复至操作前的状态。

场景2：
前面说过，快照是一份完全可用的副本，那么，它完全可以被上层业务当做源数据;
![](https://pic2.zhimg.com/80/v2-c19d1d2e7e3ac832c3e1887294ce1231_720w.jpg)
如上图，针对源数据，创建快照后，将快照卷映射给其他上层业务，可以用于数据挖掘和开发测试等工作，针对快照的读操作不影响源卷的数据。

这种功能，常用于直播（视频&图片）鉴黄、科研数据模拟开发测试等，比如，视频直播平台需要将某一段时间的视频提供给执法机构进行筛查分析，那么可以通过对特定时间点保存的数据创建快照，将快照映射给执法机构的业务主机去进行挖掘分析。

存储快照的实现原理
目前，快照的实现方式均由各个厂商自行决定，但主要技术分为2类，一种是写时拷贝COW（Copy On Write），另一种，是写重定向ROW（Redirect On Write）。

写时拷贝COW
COW(Copy-On-Write)，写时拷贝，也称为写前拷贝。
创建快照以后，如果源卷的数据发生了变化，那么快照系统会首先将原始数据拷贝到快照卷上对应的数据块中，然后再对源卷进行改写。
![](https://pic3.zhimg.com/v2-cf04fb26d7526ece20fda116c47aa936_b.webp)

写操作：

如上图简要示例，快照创建以后，若上层业务对源卷写数据X，X在缓存中排队，快照系统将X即将写入的位置（逻辑地址）上的数据Y，拷贝到快照卷中对应的位置（逻辑地址）上，同时，生成一张映射表，表中一列记录源卷上数据变化的逻辑地址，另一列记录快照卷上数据变化的逻辑地址。我们可以看到，上层业务每下发一个数据块，存储上，发生了两次写操作：一次是源卷将数据写入快照卷（即图中Y），一次是上层业务将数据写入源卷（即图中X）。
![](https://pic4.zhimg.com/v2-d65390e6faee92f05481f56c203edc5f_b.webp)

读操作：

如上图，快照卷若映射给上层业务进行数据分析等用途时，针对快照进行读操作时，首先由快照系统判断，上层业务需要读取的数据是否在快照卷中，若在，直接从快照卷读取，若不在，则查询映射表，去对应源卷的逻辑地中读取（这个查表并去源卷读的操作，也叫读重定向）。这一点，恰好就解释了为什么快照是一份完全可用的副本，它没有对源卷进行100%的拷贝，但对上层业务来说，却可以将快照看做是和源卷“一模一样”的副本。

针对源卷进行读操作时，与快照卷没有数据交互。

我们可以看到，快照对源卷的数据具有很好的保护措施，快照可以单独作为一份可以读取的副本，但并没有像简单的镜像那样，一开始就占用了和源卷一样的空间，而是根据创建快照后上层业务产生的数据，来实时占用必需的存储空间。

快照回滚（rollback）：
![](https://pic1.zhimg.com/v2-c1865d4d0044c54fc857adb9956511a0_b.webp)

如上图，回滚操作的前提条件是，锁定源卷（暂停对待回滚的逻辑地址上的IO操作），然后通过查映射表，将快照卷上的对应数据回拷到源卷中。

快照删除：

采用COW技术的快照，其源卷即保存着完整的实时数据，因此，删除快照时，直接销毁了快照卷和映射表，与源卷不存在数据交互。

写时重定向ROW
ROW(Redirect-on-write )，也称为写时重定向。

创建快照以后，快照系统把对数据卷的写请求重定向给了快照预留的存储空间，直接将新的数据写入快照卷。上层业务读源卷时，创建快照前的数据从源卷读，创建快照后产生的数据，从快照卷读。
![](https://pic2.zhimg.com/v2-e5f7abc31f11459d563eee8cd9cae269_b.webp)

写操作：

如上图简要示例，快照创建以后，若上层业务对源卷写数据X，X在缓存中排队，快照系统判断X即将写入源卷的逻辑地址，然后将数据X写入快照卷中预留的对应逻辑地址中，同时，将源卷和快照卷的逻辑地址写入映射表，即写重定向。我们可以看到，上层针对源卷写入一个数据块X，存储上只发生一次写操作，只是写之前进行了重定向。

读操作：

若快照创建以后，上层业务对源卷进行读，则有两种情况：1）若读取的数据，在创建快照前产生，数据是保存在源卷上的，那么，上层就从源卷进行读取；2）若需要读取的数据是创建快照以后才产生的，那么上层就查询映射表，从快照卷进行读取（即读重定向）。

若快照创建以后，上层业务对快照卷进行读，同样也有两种情况：1）若读取的数据，在创建快照前产生，数据是保存在源卷上的，那么上层就查询映射表，从源卷进行读取；2）若需要读取的数据是创建快照以后才产生的，那么上层就直接从快照卷进行读取。

我们可以看到，ROW快照也是根据创建快照后上层业务产生的数据，来实时占用必需的存储空间。

快照回滚（rollback）：

采用ROW技术的快照，其源卷始终保存着快照创建前的完整数据，快照创建后，上层业务产生的数据都写入了快照中，因此，快照的回滚只是取消了对源卷的读重定向操作。通俗地说，就是源卷上没有进行任何数据操作，上层业务对源卷的读，仅限于读源卷（即不会去读取快照卷的数据）。

快照删除：
![](https://pic4.zhimg.com/v2-ff2b6084856227cde5386203a2ca6183_b.webp)
采用ROW技术的快照，其源卷始终保存着快照创建前的完整数据，快照创建后，上层业务产生的数据都写入了快照中。因此，若要删除快照，必然要先将快照卷中的数据，回拷到源卷中，拷贝完成才能删除，如上图。此时我们可以设想，如果，针对一份源数据，在18:00创建了快照，上层业务持续产生大量新的数据，19:00又创建了快照，20:00又创建了快照……那么，在有多份快照的情况下，如果需要删除快照，就会出现，多个快照向源卷回拷数据的情况，可能导致回拷量非常大，耗时很长。


两种技术对比
![](https://pic3.zhimg.com/80/v2-948ac88dbe0a3cd5adb5e4554e73735e_720w.jpg)

如上表，COW的写时拷贝，导致每次写入都有拷贝操作，大量写入时，源卷的写性能会有所下降，而读源卷是不会受到任何影响的，删除快照时，只是解除了快照和源卷的关系，同时删除了快照卷的数据而已。ROW在每次写入仅做了重定向操作，这个操作耗时是几乎可以忽略不计的，源卷的写性能几乎不会受到影响，但读源卷时，则需要判断数据是创建快照前还是创建快照后，导致大量读时，性能受到一定影响，比较致命的是，若源卷有多个快照，在删除快照时，所有快照的数据均需要回拷到源卷才可以保证源卷数据的完整性。

总结：
上面简单地介绍了存储快照的实现原理，实际上，快照特性应用广泛，其应用对象是很多的：
![](https://pic4.zhimg.com/80/v2-35e470c5846221bd84c836f117457d73_720w.jpg)

目前，主流厂商在自研产品上，对上面的ROW和COW技术都有小范围的改动，也有一些新兴的快照技术已经诞生，但这个行业里，没有最好的快照技术。技术为业务服务，只有针对业务类型做好本地化适配，才能达到最佳效用。



## 参考

[知乎：揭秘：存储快照的实现](https://zhuanlan.zhihu.com/p/39916936)
[LVM 卷快照](https://documentation.suse.com/zh-cn/sles/12-SP4/html/SLES-all/cha-lvm-snapshots.html)
[逻辑卷 (LVM)](https://documentation.suse.com/zh-cn/sles/12-SP4/html/SLES-all/part-lvm.html)
