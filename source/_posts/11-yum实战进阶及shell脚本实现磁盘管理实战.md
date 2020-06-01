---
title: 11.yum实战进阶及shell脚本实现磁盘管理实战
date: 2020-06-01 04:27:24
layout:
updated:
comments:
categories:
tags:
---

常用的桌面环境：

windows7/8/10；

Gnome

KDE

XFCE4

CINEMON



YUM C/S架构模型

yum client（yum）

yum repository（ftp/http/https）





Bash 脚本编程

过程式编程语言的执行流程：

* 顺序执行
* 选择执行
* 循环执行

选择执行:

* && ||
* if
* case

if语句：三种格式

* 单分支：

  if condition；then

  ​	if-true-分支；

  fi

* 双分支：、

  if condition； then

  ​	if-true-分支

  else

  ​	if-false分支

  fi

* 多分支的if语句

  if condition1；then

  ​	条件1为真分支；

  elif condition2； then

  ​	条件2为真分支

  elif condition3；then

  ​	条件3为真分支

  ...

  elif conditionN； then

  ​	条件N为真分支

  else

  ​	所有条件均不满足时的分支

  fi

* 注意：即使多个条件可能同时都会满足，分支只会选择执行其中一个，首先测试为“真”；

case 相当于一个简化版本的多分支if语句，但并不是所有的多分支if语句都可以转化为case语句；

示例：脚本参数传递一个文件路径给脚本，判断此文件的类型；

练习：写一个脚本：

1. 传递一个参数给脚本，此参数为用户名；
2. 根据ID号判断用户类型：
   * 0：管理员
   * 1-999 系统用户
   * 1000+ 登录用户





循环执行：将一段代码重复执行0、1或多次；

进入条件：条件满足时才进入循环；

退出条件：每个循环都应该有退出条件，以有机会退出循环；

* for循环
* while循环
* until循环



for循环

* 遍历列表
* 控制变量

for VARAIBLE in LIST；do

​	循环体

done

进入条件：只要列表有元素，即可进入循环；把列表中的元素挨个赋值给变量，每个来一遍；

退出条件：列表中的元素遍历完成；

LIST的生成：

1. 直接给出；
2. 整数列表；
   * {start..end}；（两个英文句号）
   * seq [start [incremtal]] last
3. 返回列表的命令；
4. glob
5. 变量引用



示例1，判断/var/log下文件类型

```bash
  1 #!/bin/bash
  2 for file in /var/log/*;do
  3     if [ -f $file ];  then
  4         type="Regular file."
  5     elif [ -d $file ]; then
  6         type="Directory."
  7     elif [ -L $file ]; then
  8         type="Symbolic link."
  9     elif [ -b $file ]; then
 10         type="Special file."
 11     fi
 12     echo "$file  $type"
 13 done
```

练习：

1. 分别求100以内所有偶数之和，以及所有奇数之和；

   ```bash
     1 #!/bin/bash
     2 # 计算100以内的奇数和和偶数和
     3 declare i jsum=1 osum=2
     4 for i in {3..100};do
     5     if [ $[$i%2] -eq 0 ]; then
     6         osum=$[$osum+$i]
     7     else
     8         jsum=$[$jsum+$i]
     9     fi
    10 done
    11 echo "奇数之和=$jsum."
    12 echo "偶数之和=$osum."
   ```

   

2. 计算当前系统上的所有用的id之和;

   ```bash
     1 #!/bin/bash
     2 # 计算系统上所有id之和
     3 declare i idsum=0
     4 users=$(cat /etc/passwd | cut -d: -f1)
     5 #echo $users
     6 for user in $users;do
     7     uid=$(id -u $user)
     8     idsum=$[$idsum+$uid]
     9 done
    10 echo "id之和: $idsum"
   ```

   

3. 通过脚本参数传递一个目录给脚本，而后计算此目录下所有文本文件的行数之和，并说明此类文件的总数；

   ```bash
     1 #!/bin/bash
     2 # 通过脚本参数传递一个目录给脚本，而后计算此目录下所有文本文件的行数之和，并说明此文件的总数
     3 
     4 [ $# -eq 0 ] && echo "Need a parament." && exit 1
     5 ! [ -d $1 ] && echo "Need a directory" && exit 2
     6 
     7 declare -i linesum=0
     8 declare -i filesum=0
     9 files=$(ls $1)
    10 cd $1
    11 for file in $files;do
    12     if [ -f $file ]; then
    13         line=$(wc -l $file | cut -d' ' -f1)
    14         linesum=$[$linesum+$line]
    15         let filesum++
    16     fi
    17 done
    18 echo "行数之和: $linesum"
    19 echo "文件总数: $filesum"
   ~                               
   ```

   
