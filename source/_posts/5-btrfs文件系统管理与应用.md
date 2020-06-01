---
title: 5.btrfs文件系统管理与应用
date: 2020-06-01 04:26:33
layout:
updated:
comments:
categories:
tags:
---
技术预览版。GPL，开源版本 2007 ORACLE Cow；取代linux系统的ext系列文件系统
`B-tree`
`Butter FS`
`Better FS`

**特性**
多物理卷支持：可由多个底层物理卷组成，支持RAID，已联机添加、移除、修改；
写入时复制（cow）：复制、更新、以及替换指针；而非传统的“就地”更新；
数据及元数据校验码：checksum：极大的保证了数据的可靠性；
子卷：sub_volume；
快照：支持快照的快照；
透明压缩:节约时间，但是会浪费CPU时钟周期；
**btrfs**
**mkfs.btrfs**

```bash
[root@Centos7 ~]# mkfs.btrfs 
btrfs-progs v4.9.1
See http://btrfs.wiki.kernel.org for more information.

Usage: mkfs.btrfs [options] dev [ dev ... ]
Options:
  allocation profiles:
        -d|--data PROFILE       data profile, raid0, raid1, raid5, raid6, raid10, dup or single
        -m|--metadata PROFILE   metadata profile, values like for data profile
        -M|--mixed              mix metadata and data together
  features:
        -n|--nodesize SIZE      size of btree nodes
        -s|--sectorsize SIZE    data block size (may not be mountable by current kernel)
        -O|--features LIST      comma separated list of filesystem features (use '-O list-all' to list features)
        -L|--label LABEL        set the filesystem label
        -U|--uuid UUID          specify the filesystem UUID (must be unique)
  creation:
        -b|--byte-count SIZE    set filesystem size to SIZE (on the first device)
        -r|--rootdir DIR        copy files from DIR to the image root directory
        -K|--nodiscard          do not perform whole device TRIM
        -f|--force              force overwrite of existing filesystem
  general:
        -q|--quiet              no messages except errors
        -V|--version            print the mkfs.btrfs version and exit
        --help                  print this help and exit
  deprecated:
        -A|--alloc-start START  the offset to start the filesystem
        -l|--leafsize SIZE      deprecated, alias for nodesize
```

-L `LABEL`

-d <type>: raid0, raid1, raid5, raid6, raid10, single, dup

-O <feature>: raid0, raid1, raid5, raid6, raid10, single, dup

​	-O list-all: 列出支持的所有feature；

```bash
[root@Centos7 ~]# mkfs.btrfs -O list-all
Filesystem features available:
mixed-bg            - mixed data and metadata block groups (0x4, compat=2.6.37, safe=2.6.37)
extref              - increased hardlink limit per file to 65536 (0x40, compat=3.7, safe=3.12, default=3.12)
raid56              - raid56 extended format (0x80, compat=3.9)
skinny-metadata     - reduced-size metadata extent refs (0x100, compat=3.10, safe=3.18, default=3.18)
no-holes            - no explicit hole extents for files (0x200, compat=3.14, safe=4.0)

```

`mkfs.btrfs -L mydata /dev/sdb /dev/sdc -f`

```bash
[root@Centos7 ~]# mkfs.btrfs -L mydata /dev/sdb /dev/sdc -f
btrfs-progs v4.9.1
See http://btrfs.wiki.kernel.org for more information.

Label:              mydata
UUID:               7c9e06ee-52ee-4350-b066-d23e980f6b88
Node size:          16384
Sector size:        4096
Filesystem size:    20.00GiB
Block group profiles:
  Data:             RAID0             2.00GiB
  Metadata:         RAID1             1.00GiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  2
Devices:
   ID        SIZE  PATH
    1    10.00GiB  /dev/sdb
    2    10.00GiB  /dev/sdc
```

显示

```bash
[root@Centos7 ~]# btrfs filesystem show
Label: 'mydata'  uuid: 7c9e06ee-52ee-4350-b066-d23e980f6b88
        Total devices 2 FS bytes used 112.00KiB
        devid    1 size 10.00GiB used 2.01GiB path /dev/sdb
        devid    2 size 10.00GiB used 2.01GiB path /dev/sdc
```



之后就可以挂载使用了

`mount -t btrfs /dev/sdc MOUNT_POINT`

```bash
[root@Centos7 ~]# mkdir -pv /mnt/mydata
mkdir: created directory ‘/mnt/mydata’
[root@Centos7 ~]# mount -t btrfs /dev/sd
sda   sda1  sda2  sda3  sdb   sdc   
```

只要使用sdb和sdc效果一样

`/dev/sdb on /mydata type btrfs (rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)`

卸载umount即可



透明压缩机制：

`mount -o compress={lzo|zlib} DEVICE MOUNT_POINT`



`btrfs resize`



增加：

`btrfs device add /dev/sd? mount_point`



balance均衡操作：

`btrfs balance {status|start|pause|cancel|resume}`



联机拆除设备，不影响数据，会自动移动文件

`btrfs device delete /dev/sd? mount_point`



改变raid级别

`btrfs balance start -dconvert=raid5 /mydata`	数据块的

`btrfs balance start -mconvert=raid5 /mydata` 元数据的



子卷：

`btrfs subvolume`

创建：create

```bash
[root@Centos7 ~]# btrfs subvolume create /mydata/logs
Create subvolume '/mydata/logs'
```

列出；

list

`btrfs subvolume list /mydata`

只挂载子卷：

先卸载父卷

`mount -o subvol=logs /dev/sdb /mydata/`

使用子卷ID挂载：

`mount -o subvolid=1 /dev/sdb /mydata`



子卷删除：

`btrfs subvolume delete /mydata/logs` 



创建快照：

子卷的快照必须与子卷在一个父卷中：

`btrfs subvolume snapshot /mydata/logs /mydata/log_snapshot`

删除:

` btrfs subvolume delete /mydata/logs_snapshot/`

对一个文件创建快照：

cp --reflink file file_snapshot

另一个文件最好在当前卷下某个路径下



无损转换文件系统：

ext4转换为btrfs

`fsck -f device`

`btrfs-convert device`

回滚为ext4

`btrfs-convert -r device`

`blkid`




