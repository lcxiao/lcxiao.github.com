---
title: 7.压缩工具与shell编程
date: 2020-06-01 04:26:54
layout:
updated:
comments:
categories:
tags:
---

压缩和解压缩
压缩比，越大压缩后的文件越小
压缩的目的：
时间换空间
CPU的时间：用CPU的运算时间换存储空间
当cpu空闲时可以执行压缩，一定要知道压缩的目的。
compress/uncompress: .Z
gzip/gunzip: .gz
bzip2/bunzip2: .bz
xz/unxz: .xz
zip/unzip
tar
cpio

1.gzip/gunzip :
    gzip/gunzip,zcat compress or expand files
    zcat可以查看小的压缩后的gz文件，大文件不要使用zcat查看
    gzip [option...] FILE...
    -d 解压缩，相当于gunzip;
    -# 指定压缩比，默认是6，越大越浪费cpu周期，一般默认即可；
    -c 输出至标准输出，不删除源文件；
        gzip -c files > files.gz

2. bzip2/bunzip2/zcat
    -d 解压缩
    -# 指定压缩比，默认6
    -k 保留源文件
    bzip2 [option]... FILE...

3.xz/unxz/xzcat
lzma/unlzma/lzcat

    xz [option]... FILE...
        -d 解压缩
        -# 压缩比
        -k 保留源文件

这几种压缩工具都不支持对文件夹进行压缩，在linux上如果要压缩目录需要先归档；

归档 tar,cpio

tar 目录可以不加‘-’;
    tar [option]... FILE...
    1.创建归档 -c
        -c -f /PATH/to/FILE
        -cf
        cf

    2.展开归档 -x
    3.查看归档文件内的文件列表 -t
    4.指定目录 -C
归档并压缩
-z：gzip
tar czf gzfile sourcefile...
解压缩
tar xzf gzfile
z可省略，会自动判断文件类型

-j:bzip2
-jcf
-jxf

-J :xz
-Jcf
-Jxf

zip

zip/unzip

.zip

zip file.zip file

lftp下载文件

lftp [url/ip]/path/to/file

lftp>mget file



Bash 脚本编程之用户交互：

脚本参数

可以直接与用户交互

交互：通过键盘输入数据，从而完成变量复制操作；

灵活的执行方式实现有2种方法：

通过传入参数

尽量避免与用户交互

read内嵌命令

help read

read -p "message:" var

[ -z $name ] && echo "name is needed." && exit 2

如空可自行赋值：

read -p "Enter name. [jack]:" name

[ -z $name ] && name='Tom'  



bash -n 检测语法错误

只能检查语法错误，逻辑错误无法检测

bash -x debug模式

按步执行,调试执行




