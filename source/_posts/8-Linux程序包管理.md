---
title: 8.Linux程序包管理
date: 2020-06-01 04:27:01
layout:
updated:
comments:
categories:
tags:
---

# Linux程序包管理

## 概述

软件层	shell（人机交互接口）

//		\\\

lib call(库调用)

//					\\\

system call(系统调用)]

//						\\\

底层硬件



**API：Application Program Interface**

API函数库是连接用户软件和系统内核桥梁，或者是“协议”，操作系统厂商写好函数库说明书，应用软件开发者不必关心其内部是如何实现的，用的时候对照着API手册查询就够了；应用软件也可以越过系统函数库通过system call（系统调用）直接调用os内核函数，如图中红色虚线所示，当然这种方式并不被推荐。

如果各系统平台都能提供相同的系统函数库，那么开发者在这个系统函数库基础之上编写软件代码，那么就很容易将软件移植到各个系统平台。然而，这只是个美好的愿望，IEEE就是为了达成这样的愿望才牵头制定POSIX标准。POSIX标准主要就是针对UNIX API而制订，不管函数如何包装、功能如何实现，但API按照标准约定来（比如函数变量等符号名称、数据结构、参数类型与个数、基本工具命令名称等），Linux完全兼容POSIX标准（部分函数符合POSIX，部分函数是Linux专有，即是POSIX的超集），微软声称Windows部分兼容POSIX标准。



**ABI：Application Binary Interface**

Unix-Like：ELF

Windows：exe，msi



### **从软件角度理解系统**

计算机世界里存在各种各样的操作系统，目前通用操作系统有主流的三大类：

- UNIX，通用操作系统鼻祖，发展出特别多衍生系统；
- Windows，微软家根基，桌面市场霸主；
- GNU/Linux，UNIX近亲，有各种发行版如Ubuntu、CentOS等。



> “All problems in computer science can be solved by another level of indirection（计算机科学领域的任何问题都可以通过增加一个间接的中间层来解决）”。

在硬件基础之上逐步堆叠了系统内核、系统函数库等中间层，在应用程序内部还可以继续细分多个层次，这样把最终用户与硬件隔离开来，增强了抽象能力、屏蔽底层细节，也让开发者分工，专注于各自层次的开发，同时降低了软件迁移的难度。

Cygwin就是在Windows中增加了一个中间层——兼容POSIX的模拟层，并在此基础上构建了大量Linux-like的软件工具。再来解释本文开头的回答，如下图，POSXI兼容环境包括以下两部分：

- cygwin1.dll，作为实现POSIX系统调用的模拟层，可原生运行在Windows中；
- 在cygwin1.dll之上构建的大量函数库、应用程序，如libc、zlib、bash、gcc、vim、awk、sed、git等等，与UNIX/Linux几乎等同*。

**注：Cygwin的libc是Newlib，Linux的libc是GNU libc，UNIX有的是BSD libc。*



### 库级别的虚拟化

Linux：WinE

Windows：Cygwin

*MinGW：MinGW，又称mingw32，是将GCC编译器和GNU Binutils移植到Win32平台下的产物，包括一系列头文件、库和可执行文件。 另有可用于产生32位及64位Windows可执行文件的MinGW-w64项目，是从原本MinGW产生的分支。如今已经独立发展。*



**系统级开发**：(注重性能)

C/C++ :httpd,vsftpd,nginx

新的热门语言：Go

**应用级开发**:

Java/Python/Perl/Ruby/Php

java：hadoop，hbase	（jvm）

python：openstack	（pvm）

perl：（perl解释器）

ruby：（ruby解释器）

php：（php解释器）



高级语言，开发周期端，性能不如C，库多，代码量少

标准C库



### 程序格式：

**源代码**：文本格式的程序代码；

​		编译开发环境：编译器、头文件、开发库

**二进制格式**：文本格式的程序代码-->二进制格式-->（二进制程序、库文件、配置文件、帮助文件）



**java/python程序格式：**

源代码：编译成能够在其虚拟机（jvm/pvm）运行的格式；

​		开发环境：编译器，开发库、导入的库（跟头文件实现功能相同）

二进制



**项目构建工具：**

C/C++：make

Java：maven





## 程序包管理器

源代码 --> 目标二进制代码 --> 组织成为一个或者有限几个`包`文件;

安装、升级、卸载、查询、校验

**程序包管理器：**

​		Debian：dpt，dpkg：“.deb”，

​		Redhat：redhat package manager，rpm：“rpm”；开始使用perl开发，后来C重写。

​		rpm事实上的工业标准；

​		SuSE：rpm，与红帽的组织格式不兼容，使用的rpm包管理器，“.rpm”

​		Gentoo：ports

​		Archlinux：pacman；



源代码：name-VERSION.tar.gz

Version：Major.minor.release

版本 -->主版本号 --> 次版本号 -->

rpm包命名格式：

name-Version-release.arch.rpm

Version：major.minor.release

release.arch：rpm包的发行号

​		release.os.:2.el7.i386.rpm

​		archetecture:I386,X64(amd64),ppc,noarch（java，python之类的不依赖凭平台的）

redis-3.0.2-1.centos7.x64.rpm

changelog:版本更新历史；

i386（旧32位cpu），i686（较新32位cpu），x64/amd64（64位cpu）



**拆包**：主包和支包

主包：name-version-release.arch.rpm

支包：name-function-version-release.arch.rpm

​		function：devel（开发版本），utils（工具程序），libs（库文件）



**组成格式**

Linux设计思想，小工具组合完成复杂任务；

包和包之间存在依赖关系：

X，Y，Z

X --> Y，Z

​	Y -->A，B，C

​	C --> Y

前端工具（自动解决复杂依赖关系）：

YUM：rpm包的前端工具；

APT：deb包的前端工具；（apt-get）（apt-cache）

zypper：suse的rpm包管理工具；（比yum稍微好用）

dnf：fedora22+系统上rpm包管理器的前端工具；

前端工具（apt，yum）配合后端（rpm，deb）管理工具，能提升使用效率；



#### **程序包管理器：**

功能：将编译好的应用程序的各组成文件打包成一个或者几个程序包文件，从而更方便的实现程序包的安装、升级、卸载和查询等管理操作；

1.程序包的组成清单（每个程序包都单独实现）；

​	文件清单

​	安装或卸载时运行的脚本；

2.数据库（公共）

​	程序包名称和版本；

​	依赖关系

​	功能说明；

​	安装生成的各文件的文件路径及校验码信息；

​	。。。

​	/var/lib/rpm



#### 获取程序包的途径：

1.系统发行版的光盘或者官方的文件服务器（或者镜像站点）：

2.项目的官方站点

3.第三方组织：

​	（a）EPEL

​	（b）搜索引擎

​		https://pkgs.org/

​		https://rpmfind.net/

​		http://rpm.pbone.net/

​	

4.自己动手，丰衣足食

建议：检查其合法性

​	来源合法性；信任的组织发布的

​	程序包的完整性：检验MD5，SHA1



#### CentOS系统上的rpm命令管理程序包：

安装、升级、卸载、查询和校验、数据库维护



#### rpm命令：

​	rpm [option] [Package_FILE]

​	安装： -i，--install

​	升级：-U，--update，-F，--freshen

​	卸载：-e，--erase

​	查询：-q，--query

​	校验：-V，--verify

​	数据库维护：--build，

​	

#### 安装：rpm -ivh（常用）

rpm {-i|--install} [install-options] PACKAGE_FILE

install-options：

​	-v，verbose 详细信息

​	-vv，更详细的信息

​	-h hash marks输出进度条；每个#表示2%的进度；

​	--test ：测试安装：不安装文件，仅检查并报告依赖关系、冲突错误。

​	--nodeps：忽略依赖关系，安装完成之后不一定会可以使用。有些场景可使用。

​	 rpm -ivh --replacepkgs：重新安装；

​	--justdb：不安装包，只更新数据库；

注意：rpm可以自带脚本：

4类：

​	preinstall：安装过程开始之前运行的脚本，%pre ，--nopre（跳过执行脚本）

​	postinstall：安装过程完成之后运行的脚本，%post ， --nopost

​	preuninstall：卸载过程真正开始执行之前运行的脚本；%preun， --nopreun

​	postuninstall：卸载过程完成之后运行的脚本，%postun， --nopostun

​	--noscripts（跳过执行所有脚本）

​	--nosignature	跳过检查包签名信息，即不检查来源合法性

​	--nodigest：不检查包完整性；



### 升级

rpm {-U|--upgrade} [install-options] PACKAGE_FILE ...

rpm {-F|--freshen} [install-options] PACKAGE_FILE ...

​	-U：升级或安装

​	-F：升级

​	rpm -Uvh PACKAGE_FILE...

​	rpm -Fvh PACKAGE_FILE...

​			--oldpackage：降级；

​			--force：强制升级；

注意：（1）不要对内核做升级操作；Linux支持多内核版本共存，因此，直接安装新版本内核即可；

​			（2）如果某原程序包的配置文件安装后曾被修改过，升级时，新版本的程序提供的同一个配置					  					 文件不会覆盖原有版本的配置文件，而是把新版本的配置文件重命名（filename.rpmnew）后提供。



### 卸载

rpm {-e|--erase} [--allmatches] [--justdb] [--nodeps] [--noscripts]
           [--notriggers] [--test] PACKAGE_NAME ...

​	--allmatches：卸载所有匹配指定名称的程序包的各版本；

​	--nodeps：忽略依赖关系；

​	--test：测试卸载，dry run模式（干跑）



### 查询

rpm {-q|--query} [select-options] [query-options]

select-options：

​	package_name：查询指定的包是安装，及其版本；

​	-a，--all：查询所有已安装的包

​	-f FILE：查询指定的文件由哪个程序包安装生成；

​	-g 查询指定包组包含哪些包；

​	-p，--package PACKAGE_FILE：用于实现对未安装的包执行查询操作；

​	--whatprovides CAPABILITY：查询指定的CAPABILITY由哪个程序包提供；

​	--whatrequires CAPABILITY：查询指定的CAPABILITY被哪个包依赖；



query-options：

​	--changelog ：查看更新历史

​	-c，--configfiles：列出程序包提供的配置文件

​	-l ，--list：列出程序包安装生成的所有文件列表

​	-i，--info：程序包相关的信息，版本号、大小、所属的包组、等；

​	-d，--docfiles：列出程序包提供的帮助文件列表

​	--provides：列出程序包提供的所有CAPABILITY；

​	--whatrequires：查询指定程序包被谁所依赖；

​	-R，--requires：查询指定程序包的依赖关系；

​	--scripts：查询程序包自带的脚本片段；

​	-ql PAKAGE，-qf FILE，-qc PACKAGE，-ql PACKAGE，-qd PACKAGE；

​	-qpi PACKAGE_FILE，-qpl PACKAGE_FILE，-qpc PACKAGE_FILE



### 校验

rpm {-V|--verify} [select-options] [verify-options]

        [--nodeps] [--nofiles] [--noscripts]
        [--nodigest] [--nosignature]
        [--nolinkto] [--nofiledigest] [--nosize] [--nouser]
        [--nogroup] [--nomtime] [--nomode] [--nordev]
        [--nocaps] [--noconfig] [--noghost]
       c %config configuration file.
       d %doc documentation file.
       g %ghost file (i.e. the file contents are not included in the package payload).
       l %license license file.
       r %readme readme file.
       S file Size differs
       M Mode differs (includes permissions and file type)
       5 digest (formerly MD5 sum) differs
       D Device major/minor number mismatch
       L readLink(2) path mismatch
       U User ownership differs
       G Group ownership differs
       T mTime differs
       P caPabilities differ


### 验证包来源合法性和完整性

**来源合法性验证：**

​		数字签名：非对称加密

​	（计算特征码）-->私钥加密特征码 -->公钥解密验证（安全获得公钥）CA

**完整性验证：**

​		获取并导入信任的包的制作者的密钥；

​		对于centos发行版来说，导入光盘中的KEY文件

​		导入公钥： rpm --important RPM-GPG-KEY-CENTOS7



**验证：**

​		1.安装此组织签名的程序时，会自动执行验证；

​		2.手动验证：rpm -k PACKAGE_FILE



### 数据库重建

rpm管理数据库路径：/var/lib/rpm

​		查询操作：通过此处的数据库进行；

获取帮助：

centos6：man rpm

centos7：man rpmdb

rpm {--initdb|--rebuilddb}

rpm {--initdb|--rebuilddb} [-v] [--dbpath DIRECTORY] [--root DIRECTORY]

​	--initdb：初始化数据库，当前无任何数据库可初始化创建一个新的，当前有时不执行任何操作；

​	--rebuilddb：重新构建，通过读取当前系统上的所有已安装过的数据包进行重建；





## Debian 全球镜像站

主要 Debian 镜像站

| 中国大陆 | [ftp2.cn.debian.org/debian/](http://ftp2.cn.debian.org/debian/) | amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| -------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 中国大陆 | [ftp.cn.debian.org/debian/](http://ftp.cn.debian.org/debian/) | amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |

次要 Debian 镜像站

| **中国大陆**                 |                                                         |                                                              |
| ---------------------------- | ------------------------------------------------------- | ------------------------------------------------------------ |
| ftp2.cn.debian.org           | [/debian/](http://ftp2.cn.debian.org/debian/)           | amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| ftp.cn.debian.org            | [/debian/](http://ftp.cn.debian.org/debian/)            | amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| mirror.lzu.edu.cn            | [/debian/](http://mirror.lzu.edu.cn/debian/)            | ALL amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| mirrors.163.com              | [/debian/](http://mirrors.163.com/debian/)              | amd64 i386                                                   |
| mirrors.bfsu.edu.cn          | [/debian/](http://mirrors.bfsu.edu.cn/debian/)          | ALL amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| mirrors.huaweicloud.com      | [/debian/](http://mirrors.huaweicloud.com/debian/)      | ALL amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| mirrors.tuna.tsinghua.edu.cn | [/debian/](http://mirrors.tuna.tsinghua.edu.cn/debian/) | amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |
| mirrors.ustc.edu.cn          | [/debian/](http://mirrors.ustc.edu.cn/debian/)          | amd64 arm64 armel armhf i386 mips mips64el mipsel ppc64el s390x |



## List of CentOS Mirrors

| Asia | Bangladesh | [CoLoCity](http://www.colocity.com.bd/)                      | http://mirror.myfahim.com/centos/     |                                     |                                                              |
| ---- | :--------- | ------------------------------------------------------------ | :------------------------------------ | ----------------------------------- | ------------------------------------------------------------ |
| Asia | Bangladesh | [dhakaCom Limited](http://www.dhakacom.com/)                 | http://mirror.dhakacom.com/centos/    |                                     |                                                              |
| Asia | Bangladesh | [XeonBD](https://www.xeonbd.com/)                            | http://mirror.xeonbd.com/centos/      |                                     |                                                              |
| Asia | Cambodia   | [Cambo.Host Ltd](https://cambo.host/)                        | http://mirror.cambo.host/centos/      |                                     | [rsync://mirror.cambo.host/centos/](rsync://mirror.cambo.host/centos/) |
| Asia | China      | [Alibaba Cloud Computing](http://www.aliyun.com/)            | http://mirrors.aliyun.com/centos/     |                                     |                                                              |
| Asia | China      | [Beijing Foreign Studies University](http://global.bfsu.edu.cn/) | http://mirrors.bfsu.edu.cn/centos/    | https://mirrors.bfsu.edu.cn/centos/ | [rsync://mirrors.bfsu.edu.cn/centos/](rsync://mirrors.bfsu.edu.cn/centos/) |
| Asia | China      | [Beijing Institute of Technology](http://www.bit.edu.cn/)    | http://mirror.bit.edu.cn/centos/      |                                     |                                                              |
| Asia | China      | [ChongQing University](http://lanunion.cqu.edu.cn/)          | http://mirrors.cqu.edu.cn/CentOS/     | https://mirrors.cqu.edu.cn/CentOS/  |                                                              |
| Asia | China      | [CN99 Corp.](http://www.cn99.com/)                           | http://mirrors.cn99.com/centos/       |                                     |                                                              |
| Asia | China      | [Dalian Neusoft University of Information](http://www.neusoft.edu.cn/) | http://mirrors.neusoft.edu.cn/centos/ |                                     |                                                              |






