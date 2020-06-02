---
layout: trinity
title: Master版本编译安装总结
date: 2020-06-01 05:18:30
tags:
---
# TrinityCore

## 项目简介：

**TrinityCore**是主要基于C ++ 的*MMORPG*框架。

它是从*MaNGOS*（*大型网络游戏对象服务器*）派生而来的，它基于该项目的代码，该代码随着时间的流逝发生了很大的变化，以在优化游戏机制和功能的同时优化，改进和清理代码库。MANGOS技术组骨干成员进行研发，在技术和经验上都有很好的保证 。

TrinityCore维护的版本目前有2个，分别是：3.3.5a的WLK版本、master（同步官服）版本;

* 官网：[https://www.trinitycore.org](https://www.trinitycore.org/)
* 源码：https://github.com/TrinityCore



## Requirements

```bash
Processor with SSE2 support 
Boost ≥ 1.58
MySQL ≥ 5.7.0
OpenSSL ≥ 1.0.x
CMake ≥ 3.13.4
Clang  ≥ 5 (heavy recommended, especially on master branch) or GCC ≥ 7.1.0
zlib ≥ 1.2.7
```

debian 10.x

```bash
apt-get update
apt-get install git clang cmake make gcc g++ libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip default-libmysqlclient-dev
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

ubuntu 19.10+

```bash
apt-get update
apt-get install git clang cmake make gcc g++ libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip libmariadb-client-lgpl-dev-compat
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

Fedora based distributions

```bash
dnf install https://dev.mysql.com/get/mysql57-community-release-fc27-1.noarch.rpm
dnf install git clang cmake make gcc gcc-c++ community-mysql-devel compat-openssl10-devel bzip2-devel readline-devel ncurses-devel boost-devel community-mysql-server p7zip
rm -f /usr/bin/c++
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

## Core Installation

`sudo adduser <username>`

`sudo su - <username>`

### Building the server itself

#### Getting the source code

**3.3.5 (wotlk client)**

```bash
cd ~/
git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git
```

**master**

```bahs
cd ~/
git clone -b master git://github.com/TrinityCore/TrinityCore.git
```

#### Compiling the source code

Creating the build-directory

```bash
cd TrinityCore
mkdir build
cd build
```

#### Configuring for compiling

`cmake ../ [additional parameters]`

TIPS:

```bash
By default this is the only row you will need to run to setup your install:
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/<username>/server
 
Another Examples Below:
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/wow/server -DTOOLS=0
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/$USER/server -DTOOLS=0 -DWITH_WARNINGS=1
```

#### Building the core

```bash
make
make install
```

#### Keeping the code up to date

```bash
cd ~/TrinityCore/
# For 3.3.5 Branch
git pull origin 3.3.5
  
# For master Branch
git pull origin master
```

### Installing MySQL Server

rename the **worldserver.conf.dist** and **authserver.conf.dist** files in **worldserver.conf** and **authserver.conf**

## Extractors

| Directory | Branch      |                    |
| --------- | ----------- | ------------------ |
| dbc       | all         | Mandatory          |
| maps      | all         | Mandatory          |
| vmaps     | all         | HIGHLY Recommended |
| mmaps     | all         | HIGHLY Recommended |
| cameras   | all         | Recommended        |
| gt        | master only | Mandatory          |

## Extracting DBC, Maps, VMaps & MMaps

#### DBC and Maps files

```
cd ``/home//server/bin/mapextractor``mkdir /home//server/data`` ` `# Next line is 3.3.x only``cp -r dbc maps /home//server/data``# Next line is 6.x, 7.x only``cp -r dbc maps gt /home//server/data` `edit worldserver.conf and change datadir from ``"."` `to ``"../data"
```

#### Visual Maps (aka vmaps) Note: If you stop vmap4extractor before finish you will need to delete the Buildings directory before start again.

You can also extract vmaps which will take quite a while depending on your machine (up to hours on ancient hardware).

```
cd ``/home//server/bin/vmap4extractor``mkdir vmaps``/home//server/bin/vmap4assembler Buildings vmaps``cp -r vmaps /home//server/data
```

When this is complete you will receive the following message which can be safely ignored.

```
Processing Map 724``[################################################################]``Extracting GameObject models...Extracting World\Wmo\Band\Final_Stage.wmo``No such file.``Couldn't open RootWmo!!!``Done!`` ` `Extract V4.00 2012_02. Work complete. No errors.
```

#### Movement Maps  (aka mmaps - optional RECOMMENDED)

Extracting mmaps will take quite a while depending on your machine (up to hours).

```
cd ``mkdir mmaps``/home//server/bin/mmaps_generator``cp -r mmaps /home//server/data

```

## Setting up the configuration files

First of all you need to find the two default config files (named **worldserver.conf.dist** and **authserver.conf.dist (\**bnetserver.conf.dist in 6.x)\**** ) and copy these to their namesakes without the **.dist** extension. You can find them within /trinitycore/etc/ (may vary).

```
cp worldserver.conf.dist worldserver.conf``cp authserver.conf.dist authserver.conf # 3.3.5 only``cp bnetserver.conf.dist bnetserver.conf # 6.x, 7.x only
```

## Databases Installation

3.3.5

```mysql
CREATE USER 'trinity'@'localhost' IDENTIFIED BY 'trinity' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0;

GRANT USAGE ON * . * TO 'trinity'@'localhost';

CREATE DATABASE `world` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE DATABASE `characters` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE DATABASE `auth` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

GRANT ALL PRIVILEGES ON `world` . * TO 'trinity'@'localhost' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON `characters` . * TO 'trinity'@'localhost' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON `auth` . * TO 'trinity'@'localhost' WITH GRANT OPTION;
```

master

```mysql
GRANT USAGE ON * . * TO 'trinity'@'localhost' IDENTIFIED BY 'trinity' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 ;

CREATE DATABASE `world` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE DATABASE `characters` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE DATABASE `auth` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

CREATE DATABASE `hotfixes` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

GRANT ALL PRIVILEGES ON `world` . * TO 'trinity'@'localhost' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON `characters` . * TO 'trinity'@'localhost' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON `auth` . * TO 'trinity'@'localhost' WITH GRANT OPTION;

GRANT ALL PRIVILEGES ON `hotfixes` . * TO 'trinity'@'localhost' WITH GRANT OPTION;
```

#### Populating the MySQL Trinity databases

下载github页面上的TDB文件，解压到程序主目录，就是有bin目录的那一层目录；

## Worldserver and Authserver configurations

更新数据库的**Realmlist Table**

Open the **auth** database and find the **realmlist** table. You need to edit the `address` field 

- LAN IP (192.168.x.x) - If you are installing TrinityCore on a different computer from where you run WoW, but all the computers involved are on the same network (router) use that computer's Local Area Network IP.
- 127.0.0.1 - Also known as "localhost". Leave this setting alone here and in your configs if you've installed TrinityCore on the same computer you run WoW on, and only you are connecting to it.
- External IP – If you want other people to connect to your server, use your external IP. Visit http://www.whatismyip.com/ to find your external IP address.

## Account Creation Examples:

## 3.3.5

**To create your account: very important, don't use @ on account names.**

Type: **account create  **

Example: **account create test test**

**To set your account level:**

Type: **account set gmlevel  3 -1**

Example: **account set gmlevel test 3 -1**

**Login to your account:**

Log in with account **test** and **password** test through **wow.exe.**

## master

**To create your account:**

Type: **bnetaccount create  **

Example: **bnetaccount create test@test test**

**To set your account level:**

Type: **account set gmlevel  3 -1**

Example: **account set gmlevel 1#1 3 -1**

Note: The **username** used for setting your **gmlevel** is **not the same as** the **username** you create with **bnetaccount**. You must manually **find** the **username in auth.account.username**. These are formatted as **1#1, 2#1, etc.**

**NOTE2: if you have connected before using this command you will need to relog.**

**Login to your account:**

Log in with email **test@test** and password **test**.through a **Custom Client Launcher (Not provided).**

## Client Setup

3.35only

- Open the realmlist.wtf file inside your World of Warcraft\Data folder. The IP in the realmlist.wtf file should be exactly the same as the IP address you entered in the realmlist table above.
  - Change the first line to: **set realmlist **
  - Example: ***set realmlist 127.0.0.1\***
- (Optional) If you wish to use the WoW Launcher.exe to run your client then you must change your **set patchlist** to the same ip/dns name as your realmlist.

master only

- Change **Config.wtf**: SET portal "****"
- The IP in the Config.wtf file should be exactly the same as the IP address you entered in the realmlist table above. (Example: **SET portal "127.0.0.1"**)

Note: you will need a custom client launcher (not provided) to connect to master branch server.

NOTE don't use localhost for address, if you need to connect to localhost use 127.0.0.1
