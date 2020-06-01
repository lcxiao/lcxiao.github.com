---
title: Linux平台RAID
categories: Linux
tags:
  - RAID
  - linux
  - 磁盘
  - 文件系统
abbrlink: 4124124590
date: 2020-05-06 13:23:39
---
# RAID
`R`edundant `A`rray of `I`ndependent `D`isks `独立硬盘冗余阵列`,旧称`廉价磁盘冗余阵列`.
简称`磁盘阵列`。利用虚拟化存储技术把多个硬盘组合起来，成为一个或多个硬盘阵列组，目的为提升性能或数据冗余，或是两者同时提升。

在运作中，取决于 RAID 层级不同，数据会以多种模式分散于各个硬盘，RAID 层级的命名会以 RAID 开头并带数字，例如：RAID 0、RAID 1、RAID 5、RAID 6、RAID 7、RAID 01、RAID 10、RAID 50、RAID 60。每种等级都有其理论上的优缺点，不同的等级在两个目标间获取平衡，分别是增加数据可靠性以及增加存储器（群）读写性能。

简单来说，RAID把多个硬盘组合成为一个逻辑硬盘，因此，操作系统只会把它当作一个实体硬盘。RAID常被用在服务器电脑上，并且常使用完全相同的硬盘作为组合。由于硬盘价格的不断下降与RAID功能更加有效地与主板集成，它也成为普通用户的一个选择，特别是需要大容量存储空间的工作，如：视频与音频制作。

|RAID等级|最少硬盘|最大容错|可用容量|读取性能|写入性能|安全性 |目的  |应用产业|
|  ---- |  ---- |  ---- |  ---- | ----  |  ----  |  ---- | ----  | ----  |
|0	|2	|0|	n|	n|	n	|一个硬盘异常，全部硬盘都会异常|	追求最大容量、速度|	影片剪接缓存用途|
|1	|2	|n-1|	1|	n	|1	    |高，一个正常即可	|追求最大安全性	|个人、企业备份|
|5	|3	|1	|n-1|	n-1	|n-1	|高	                |追求最大容量、最小预算	|个人、企业备份|
|6	|4	|2	|n-2|	n-2	|n-2	|安全性较RAID 5高	|同RAID 5，但较安全	|个人、企业备份|
|10	|4	|	|	|	|	|高	    |综合RAID 0/1优点，理论速度较快	|大型数据库、服务器|
|50	|6	|	|	|	|	|高	    |提升数据安全	|
|60	|8	|	|	|	|	|高	    |提升数据安全	|
|单一硬盘	|(参考)	|0|	1|	1	|1|	无|	
|jBOD| 1|0|n|1|1|无（同RAID 0）|增加容量|个人（暂时）存储备份|

## 标准RAID

### 参数说明
    1. n代表硬盘总数
    2. JBOD（Just a Bunch Of Disks）指将数个物理硬盘，在操作系统中合并成一个逻辑硬盘，以直接增加容量
    3. 依不同 RAID 厂商实现算法对于性能表现会有不同，性能公式仅供参考
    4. RAID 10、50、60 依实现 Parity 不同公式也不同

### RAID 0
它将两个以上的磁盘并联起来，成为一个大容量的磁盘。在存放数据时，分段后分散存储在这些磁盘中，因为读写时都可以并行处理，所以在所有的级别中，`RAID 0的速度是最快的`。但是`RAID 0既没有冗余功能`，也`不具备容错能力`，如果一个磁盘（物理）损坏，所有数据都会丢失。

读写性能提升：
可用空间：N*min(S1,S2...)
无容错能力
最小磁盘数:2

![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/RAID_0.svg/130px-RAID_0.svg.png)

### RAID 1
两组以上的N个磁盘相互作镜像，在一些多线程操作系统中能有很好的读取速度，`理论上读取速度等于硬盘数量的倍数`，与RAID 0相同。另外`写入速度有微小的降低`。只要一个磁盘正常即可维持运作，`可靠性最高`。其原理为在主硬盘上存放数据的同时也在镜像硬盘上写一样的数据。当主硬盘（物理）损坏时，镜像硬盘则代替主硬盘的工作。因为有镜像硬盘做数据备份，所以`RAID 1的数据安全性在所有的RAID级别上来说是最好的`。但无论用多少磁盘做RAID 1，仅算一个磁盘的容量，是所有RAID中`磁盘利用率最低的一个级别`。

读性能提升、写性能略微下降：
可用空间：1*min(S1,S2...)
有冗余能力
最少磁盘数：2

![](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/RAID_1.svg/130px-RAID_1.svg.png)

### RAID 2 (不常见)
这是RAID 0的改良版，以汉明码（Hamming Code）的方式将数据进行编码后分割为独立的比特，并将数据分别写入硬盘中。因为在数据中加入错误修正码（ECC，Error Correction Code），所以数据整体的容量会比原始数据大一些。

RAID 2最少要三台磁盘驱动器方能运作。
![](https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/RAID2_arch.svg/300px-RAID2_arch.svg.png)

### RAID 3 (不常见)
采用Bit－interleaving（数据交错存储）技术，它需要通过编码再将数据比特分割后分别存在硬盘中，而将同比特检查后单独存在一个硬盘中，但由于数据内的比特分散在不同的硬盘上，因此就算要读取一小段数据资料都可能需要所有的硬盘进行工作，所以这种规格比较适于读取大量数据时使用。
![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/RAID_3.svg/220px-RAID_3.svg.png)

### RAID 4
它与RAID 3不同的是它在分割时是以区块为单位分别存在硬盘中，但每次的数据访问都必须从同比特检查的那个硬盘中取出对应的同比特数据进行核对，由于过于频繁的使用，所以对硬盘的损耗可能会提高。（块交织技术，Block interleaving）
1101,0110,1011

![](https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/RAID_4.svg/220px-RAID_4.svg.png)

### RAID 5
RAID Level 5是一种储存性能、数据安全和存储成本兼顾的存储解决方案。它使用的是Disk Striping（硬盘分割）技术。

RAID 5至少需要三个硬盘，RAID 5不是对存储的数据进行备份，而是把数据和相对应的奇偶校验信息存储到组成RAID5的各个磁盘上，并且奇偶校验信息和相对应的数据分别存储于不同的磁盘上。当RAID5的一个磁盘数据发生损坏后，可以利用剩下的数据和相应的奇偶校验信息去恢复被损坏的数据。RAID 5可以理解为是RAID 0和RAID 1的折衷方案。RAID 5可以为系统提供数据安全保障，但保障程度要比镜像低而磁盘空间利用率要比镜像高。RAID 5具有和RAID 0相近似的数据读取速度，只是因为多了一个奇偶校验信息，写入数据的速度相对单独写入一块硬盘的速度略慢，若使用“回写缓存”可以让性能改善不少。同时由于多个数据对应一个奇偶校验信息，RAID 5的磁盘空间利用率要比RAID 1高，存储成本相对较便宜。

读写性能提升
可用空间：(N-1)*min(S1,S2...)
有容错能力，1块硬盘
最少磁盘数3

![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/64/RAID_5.svg/220px-RAID_5.svg.png)

### RAID 6
读写性能提升
可用空间：(N-2)*min(S1,S2...)
有容错能力，2块硬盘
最少磁盘数4

![](https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/RAID_6.svg/270px-RAID_6.svg.png)


## 混合RAID

### JBOD
just a bunch of disks
功能：将多块硬盘的空间合并一个大的连续空间使用；
可用功能：sum(S1,S2...)
![](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e2/JBOD.svg/175px-JBOD.svg.png)


### RAID 10
读写性能提升
可用空间：N*min(S1,S2...)/2
有容错能力：每组镜像最多只能坏一块；
最少磁盘数4

![](https://upload.wikimedia.org/wikipedia/commons/thumb/b/bb/RAID_10.svg/220px-RAID_10.svg.png)

### RAID 01

![](https://upload.wikimedia.org/wikipedia/commons/thumb/a/ad/RAID_01.svg/220px-RAID_01.svg.png)

### RAID 50
![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/RAID_50.png/500px-RAID_50.png)

### RAID 60
![](https://upload.wikimedia.org/wikipedia/commons/thumb/9/9d/Raid_60.jpg/300px-Raid_60.jpg)

## 应用
RAID2、3、4较少实际应用，因为RAID0、RAID1、RAID5、RAID6和混合RAID已经涵盖所需的功能，因此RAID2、3、4大多只在研究领域有实现，而实际应用上则以RAID0、RAID1、RAID5、RAID6和混合RAID为主。

RAID4有应用在某些商用机器上，像是NetApp公司设计的NAS系统就是使用RAID4的设计概念。

## 种类
根据实现模式，分为软件和硬件两种：
`CentOS6`上面 软件方式实现：
结合内核中的`md(multi devices)`
`mdadm` 模式化的工具

命令的语法格式： `mdadm [mode] <raiddevice> [options] <componet-devices>`
支持的RAID级别：`LINEAR,RAID0,RAID1,RAID4,RAID5,RAID6,RAID10`;

模式：
```bash
创建： -C
装配： -A
监控： -F
```

```
管理： -f， -r， -a
    <raiddevice>: /dev/md#
    <component-devices>: 任意块设备

-C: 创建模式：
    -n #: 使用#个块设备来创建此RAID；
    -l #: 指明要创建的RAID的级别；
    -a:  {yes| no} 自动创建目标RAID设备的设备文件；
    -c: CHUNK_SIZE 指定块大小
    -x: 指明空闲盘的个数
```

**例如：创建一个10G可用空间的RAID5；**

创建
`mdadm -C /dev/md0 -a yes -n 3 -x 1 -l 5 /devsda{7,8,9,10}`
格式化
`mkfs -v -t ext4 /dev/md0`
挂载使用：
`mount /dev/md0 MOUNT_POINT`

**显示设备信息:**
-D：显示RAID的详细信息；
`mdadm -D /dev/md#`

**管理模式：**
-f 标记指定磁盘为损坏；
`mdadm /dev/md0 -fdev/sda#`

-a 添加磁盘
`mdadm /dev/md0 -adev/sda#`

-r 移除磁盘 
`mdadm /dev/md0 -rdev/sda#`



观察md的状态；
`cat /proc/mdstat`

停止md设备
`mdadm -S /dev/md#`

**先卸载设备**
`umount /dev/md0`
`mdadm -S /dev/md0`

watch 命令：
`-n # 刷新间隔，单位是秒`
`watch -n# "command"`

练习1：创建一个可用空间为10G的RAID1设备，要求其chunk大小为128k，文件系统为ext4，有一个空闲盘，开机可自动挂载至/backup目录；
```bash
mdadm -C /dev/md0 -c 128K -x 1 -n 2 -l 1 -a yes /deb/sda{5,6,7}
mkfs -v -t ext4
echo "`blkid /dev/md0 | awk '{print $3}'` /backup ext4 defaults 0 0" >> /etc/fstab
```

练习2：创建一个可用空间为10G的RAID10设备，要求chunk大小为256k，文件系统为ext4，开机可自动挂载至/mydata目录；
```bash
mdadm -C /dev/md0 -c 256K -n 4 -l 10 -a yes /dev/sdb{7,8,9,10}
mkfs -v -t ext4
echo "`blkid /dev/md0 | awk '{print $3}'` /mydata ext4 defaults 0 0" >> /etc/fstab
```

### 磁盘阵列相关客户类型
- 一般消费者备份数据之用、企业创建ERP系统或NAS系统时的重要数据备份。
- 影音多媒体数字内容创作公司、个人影音剪辑数字内容工作室、摄影工作室、摄影公司。
- 电视台、广播电台及互联网内容提供商等传统媒体及新媒体。
- 数字监控系统（DVR）、网络监控系统（NVR）等等需要大量存储影片的监控系统业者，军方、赌场因为需要大量监控系统也是常见使用磁盘阵列的客户。
- 证券、银行等金融行业保管重要客户数据。

## 参考
[Arch Wiki](https://wiki.archlinux.org/index.php/RAID_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87))


## 常用级别：
RAID-0、RAID-1、RAID-5、RAID-10、RAID-50、JBOD

## ????RAID各级别特性

