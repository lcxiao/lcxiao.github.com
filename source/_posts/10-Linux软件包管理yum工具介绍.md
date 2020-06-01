---
title: 10.Linux软件包管理yum工具介绍
date: 2020-06-01 04:27:17
layout:
updated:
comments:
categories:
tags:
---

# Linux程序包管理

rpm在安装包时需要解决依赖关系，手动解决比较麻烦，所以依赖于前端工具自动解决依赖关系，所以YUM应运而生，最新的为DNF，fedora22引入，CentOS7（安装之后也可以使用）以上可用。



YUM接受命令后，通过配置文件访问源地址，URL（同一资源定位符）；

访问远程服务器主机，服务器提供程序包仓库，放了每一个程序包的名字，版本，依赖关系；

(rpm包的户口簿)，分析已安装的包和未安装的包，然后下载需要下载的包，缓存到本地。安装完之后会删除安装包，但源数据会被缓存本地，以后访问会访问本地的源数据去分析，源数据需要偶尔更新。（每次去请求源数据）

源较多，选择最快的即可；



镜像列表（使用互联网的或者自建仓库）；

将远程的镜像到本地；



YUM依赖于RPM而存在，只是一个前端工具；



FTP、HTTP



CREATEREPO

程序包分组



YUM（Yellowdog Updater, Modified）；是一个基于[RPM](https://zh.wikipedia.org/wiki/RPM)包管理的字符前端软件包管理器。能够从指定的服务器自动下载RPM包并且安装，可以处理依赖性关系，并且一次安装所有依赖的软件包，无须繁琐地一次次下载、安装。被[Yellow Dog Linux](https://zh.wikipedia.org/wiki/Yellow_Dog_Linux)本身，以及[Fedora](https://zh.wikipedia.org/wiki/Fedora)、[Red Hat Enterprise Linux](https://zh.wikipedia.org/wiki/Red_Hat_Enterprise_Linux)采用。



YUM repository：yum repo	/etc/yum.conf

存储了众多rpm包，以及包的相关的元数据文件（放于特定目录下，repodata）；

文件服务器：

* FTP://
* HTTP://
* nfs://
* file:///

yum 客户端：

* 配置文件：
  * /etc/yum.conf	：为所有仓库提供的公共配置
  * /etc/yum.repos.d/*.repo ：为仓库的指向提供配置



| `cachedir`          | 用于存储下载的软件包的目录。                                 |
| ------------------- | ------------------------------------------------------------ |
| `debuglevel`        | 日志记录级别，从0（无）到10（全部）。                        |
| `exactarch`         | 如果设置为1，则仅更新软件包以使用正确的体系结构。            |
| `exclude`           | 用空格分隔的要从安装或更新中排除的软件包列表，例如： `exclude=VirtualBox-4.? kernel*`。 |
| `gpgcheck`          | 如果设置为1，则通过检查GPG签名来验证软件包的真实性。`gpgcheck`如果软件包是未签名的，则可能需要将其设置 为0，但应注意该软件包可能已被恶意更改。 |
| `gpgkey`            | GPG公钥文件的路径名。                                        |
| `installonly_limit` | 任何一个软件包可以安装的最大版本数。                         |
| `keepcache`         | 如果设置为0，请在安装后删除软件包。                          |
| `logfile`           | yum日志文件的路径名。                                        |
| `obsoletes`         | 如果设置为1，则在升级过程中更换过时的软件包。                |
| `plugins`           | 如果设置为1，则启用扩展**yum**功能的插件。                   |
| `proxy`             | 代理服务器的URL，包括端口号。                                |
| `proxy_password`    | 使用代理服务器进行身份验证的密码。                           |
| `proxy_username`    | 使用代理服务器进行身份验证的用户名。                         |
| `reposdir`          | **yum**应该 在其中查找带有`.repo` 扩展名的存储库文件的目录。默认目录为 `/etc/yum.repos.d`。 |





仓库的定义：

* [repositoryID]
* name=Some name for this repository
* baseurl=url://path/to/repository/
* enable={1|0}
* gpgcheck={1|0}
* gpgkey=URL
* enablegroups={1|0}
* failovermethod={}
* cost=（默认1000）



YUM

* yum repolist ：显示仓库列表，默认仅显示启用的，显示未启用的(yum repolist disabled);
* yum list {all | updates|available|installed|glob_exp1}
* yum install ：安装程序包,后面直接跟上packagename，一次可安装多个,可选择版本安装，默认安装最新的版本；
* yum update ：升级指定程序包
* check-update ：检查升级；
* info [...] ：查看程序包的详细信息；
* remove | erase package1 [package2] [...] ：卸载包;
* provides | whatprovides feature1 [feature2] [...] ：查看包提供的特性（可以是某文件）是有哪个程序包提供;
* clean [ packages | metadata | expire-cache | rpmdb | plugins | all ] ：清理本地缓存
* makecache ：创建缓存；
* search string1 [string2] [...] ：根据指定的关键字搜索包名及summary信息;
* reinstall package1 [package2] [...]：重新安装，覆盖的方式安装；
* downgrade package1 [package2] [...]：降级安装;
* deplist package1 [package2] [...] ：依赖关系分析；查看指定包所依赖的capabilities；
* version [ all | installed | available | group-* | nogroups* | grouplist | groupinfo ] ：查看版本信息；
* history    [info|list|packages-list|packages-info|summary|addon-info|redo|undo|roll‐back|new|sync|stats] :查看YUM事务历史；
* localinstall rpmfile1 [rpmfile2] [...] ：安装本地rpm文件；可使用仓库的依赖关系解决；（已经废弃，直接使用install，update即可）;
* groups [...] ：包组相关命令；{info | install | list | remove | summary}；groupinfo,groupinstall,groupupdate,groupremove,grouplist;



TIPS：YUM可使用新版本的源，不能使用老版本的，比如6.0可使用6.1的，但是不能使用5.9的；



使用本地YUM源

使用本地光盘作为本地yum仓库:

1. 挂载光盘至某目录；
2. 创建配置文件；
   * [CentOS7]
   * name=
   * baseurl=
   * gpgcheck=
   * enabled=

YUM的命令行命令优先级高于配置文件；命令行选项：

* --nogpgcheck：禁止进行gpgcheck；
* -y ：自动回答yes；
* -q ：静默模式；
* --disablerepo=repoidglob ：临时禁用此处指定的repo；
* --enablerepo=repoidglob ：临时启用此处指定的repo；
* --noplugins : 临时禁用所有插件



YUM的repo配置文件中可使用的变量；

*  把远程服务器上所有访问路径固定下来，用变量来获取当前版本号，平台架构；
* $releaserver ：当前OS的发行版的版本号；
* $ARCH ：平台；
* $basearch ：基础平台；
* $YUM0~YUM9



创建YUM仓库

* 必须先安装这个createrepo程序包；
* createrepo [option] \<directory>

程序包编译安装：

* testapp-Version-release.src.rpm --> 安装后，使用rpmbuild命令制作成二进制格式的rpm包，而后再安装；
* 源代码 --> 预处理 --> 编译（GCC） --> 汇编 -- > 链接 --> 执行
* 源代码组织格式：
  * 多文件，文件中的代码之间，可能存在跨文件依赖关系；
  * C、C++ ：make（Configure --> Makefile.in --> makefile）项目管理工具，依赖编译器去编译程序；
  * JAVA ：maven

编译安装三步骤：

* ./configure:

  1. 通过选项传递参数，指定启用特性、安装路径等、执行时会参考用户的指定以及Makefile.in 文件生成makefile；
  2. 检查依赖的外部环境；

* make

  根据makefile文件，构建应用程序；

* make install



开发工具：

* autoconf：结合配置文件生成configure脚本
* automake：结合配置文件生成Makefile.in文件



建议：安装之前，阅读INSTALL文件，如果没有，阅读README文件；



开源程序源代码的获取：

1. 官方网站；官方自建站点
2. 代码托管网站：
   * Github
   * Gitlab
   * GoogleCode
   * SourceForge
   * Gitee 码云



C、C++：GCC（GNU C Complier）（早期也被称作CC）



编译C源代码：

* 前提要提供开发工具和开发环境；

  * 开发工具：make gcc
  * 开发环境：开发库，头文件
  * glibc：标准库
  * 通过 ”包组“ 提供开发组件：
    * CentOS6：Development Tool
    * CentOS7：Development and Creative Workstation
    * Debian系列：build-essential

* 第一步：configure脚本

  * 选项：指定安装位置，指定启用的特性；

  * --help：获取其支持使用的选项

    * 安装路径设定：--prefix=/path/to/somewhere ：指定安装位置；

    * 配置文件安装位置：--sysconfdir=/PATH/to/somewhere;

    * System Types:

    * Optional features :可选特性；

      * --disable-feature
      * --enable-feature[=ARG]

    * Optional Packages:可选包

      * --with-PACKAGE[=ARG]
      * --without-PACKAGE

      

* make 

* make install



安装后的配置

1. 导出二进制程序目录至PATH变量中；

   * 编辑/etc/profile.d/NAME.sh
     * export PATH=/PATH/TO/BIN:PATH

2. 导出库文件路径

   编辑/etc/ld.so.conf.d/NAME.conf

   添加新的库文件到此处；

   让系统重新生成缓存 ldconfig [-v]

3. 导出头文件

   ln -sv

4. 导出帮助手册

   编辑/etc/man.config

   添加一条manpath



练习：

1. YUM的配置和使用：包括yum repository的创建；
2. 编译安装apache 2.2；启动此服务；
3. 程序包管理，rpm、yum、编译
