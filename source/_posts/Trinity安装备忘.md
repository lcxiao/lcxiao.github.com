---
title: Trinity安装备忘
date: 2020-06-02 15:29:35
layout:
updated:
comments:
categories:
tags:
---
# Trinity core 3.3.5

## 1. Linux Requirements

### debian 10.4

```bash
apt update
apt install git clang cmake make gcc g++ libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip default-libmysqlclient-dev
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

### ubuntu 19.10

```bash
apt update
apt install git clang cmake make gcc g++ libmariadbclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev mariadb-server p7zip libmariadb-client-lgpl-dev-compat
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

### Fedora based distributions

```bash
dnf install https://dev.mysql.com/get/mysql57-community-release-fc27-1.noarch.rpm
dnf install git clang cmake make gcc gcc-c++ community-mysql-devel compat-openssl10-devel bzip2-devel readline-devel ncurses-devel boost-devel community-mysql-server p7zip
rm -f /usr/bin/c++
update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100
update-alternatives --install /usr/bin/c++ c++ /usr/bin/clang 100
```

## 2. Core Installation

```bash
adduser <username>
su - <username>
git clone -b 3.3.5 git://github.com/TrinityCore/TrinityCore.git
cd TrinityCore
mkdir build
cd build
cmake ../ [additional parameters]

```

### The above parameters when combined into a full example :

```bash
By default this is the only row you will need to run to setup your install:
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/<username>/server
 
Another Examples Below:
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/wow/server -DTOOLS=0
cmake ../ -DCMAKE_INSTALL_PREFIX=/home/$USER/server -DTOOLS=0 -DWITH_WARNINGS=1
```

### 3. Building the core

```
make -j<number of cores>
make install
```

### update

```bash
cd ~/TrinityCore/
# For 3.3.5 Branch
git pull origin 3.3.5
```

## 4. Server Setup

| Directory | Branch      |                    |
| --------- | ----------- | ------------------ |
| dbc       | all         | Mandatory          |
| maps      | all         | Mandatory          |
| vmaps     | all         | HIGHLY Recommended |
| mmaps     | all         | HIGHLY Recommended |
| cameras   | all         | Recommended        |
| gt        | master only | Mandatory          |

```bash
cd <your WoW client directory>
/home/<username>/server/bin/mapextractor
mkdir /home/<username>/server/data
  
# Next line is 3.3.x only
cp -r dbc maps /home/<username>/server/data

# edit worldserver.conf and change datadir from "." to "../data"
```

```bash
cd <your WoW client directory>
/home/<username>/server/bin/vmap4extractor
mkdir vmaps
/home/<username>/server/bin/vmap4assembler Buildings vmaps
cp -r vmaps /home/<username>/server/data
```

```bash
cd <your WoW client directory>
mkdir mmaps
/home/<username>/server/bin/mmaps_generator
cp -r mmaps /home/<username>/server/data
```

```bash
cp worldserver.conf.dist worldserver.conf
cp authserver.conf.dist authserver.conf # 3.3.5 only
cp bnetserver.conf.dist bnetserver.conf # 6.x, 7.x only
```

## 5. Databases Installation

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



## 6. Networking

```bash
mysql -u root -p
use auth
update realmlist set address='IP';
```

## 7. Final Server Steps

**account create USER PASSWORD**

**account set gmlevel USER 3 -1**

## 8. Client Setup

- Open the realmlist.wtffile inside your World of Warcraft\Data folder. The IP in the realmlist.wtf file should be exactly the same as the IP address you entered in the realmlist table above.
  - Change the first line to: **set realmlist **
  - Example: **set realmlist 127.0.0.1**
- (Optional) If you wish to use the WoW Launcher.exe to run your client then you must change your **set patchlist** to the same ip/dns name as your realmlist.

# mysql命令导入

## 1 mysql命令导入多个sql文件方法：

```
$ for SQL in *.sql; do mysql -uroot -p"123456" mydb < $SQL; done
```

## 2 source命令导入

`source`命令需要首先进入**MySQL命令行**：

```
$ mysql -uroot -p"123456"
```

**导入多个sql****文件**需要先创建一个额外的文件，名字随意，这里我们取：**all.sql**，内容：

```
source user1.sql
source user2.sql
source user3.sql
```

**注意，这里每行一条，必须以source命令开头。**

然后用`source`命令执行该文件：

```
mysql > use mydb;
mysql > source /home/gary/all.sql
```
