---
title: 15.Linux进程管理命令
date: 2020-06-15 13:09:04
layout:
updated:
comments:
categories:
tags:
---
## 系统调用
read（），open（），write（）；

程序开发成内部多个执行流，每个执行流可单独运行与一个cpu核心上
多线程运行编程模型；
并行计算；
必须拥有多核心才可以；

每个进程分配固定的线程，每个线程实现一个连接；
linux线程即进程；

## 随时鉴定服务器的各种状态；
cpu、内存、进程
垃圾回收策略，
运维基本能力；

管理进程的运行数量，占用资源，优先级如何；

## 进程管理命令
客户访问慢。全方位去诊断，查看，网络，磁盘，程序bug；（了解程序运行法则）不背锅；


Linux系统上的进程查看及管理工具：
pstree、ps、pidof、pgrep、top、htop、glances、pmap、vmstat、dstat、kill、pkill、job、bg、fg、nohup、nice、renice、killall...

CentOS5：SYSV init；
CentOS6：UPstart（并行启动）dbus通信
CentOS7：Systemd：（红帽的程序员参考MacOS开发）（开关机都非常快）

## pstree：查看进程树；

```bash
init-+-getty
     |-getty
     |-getty
     `-getty
```
Systemd:
```bash
systemd─┬─VGAuthService
        ├─atd
        ├─auditd───{auditd}
        ├─crond
        ├─dbus-daemon───{dbus-daemon}
        ├─login───bash
        ├─lvmetad
        ├─master─┬─pickup
        │        └─qmgr
        ├─mysqld_safe───mysqld───18*[{mysqld}]
        ├─polkitd───6*[{polkitd}]
        ├─rsyslogd───2*[{rsyslogd}]
        ├─sshd───sshd───bash───pstree
        ├─systemd-journal
        ├─systemd-logind
        ├─systemd-udevd
        ├─tuned───4*[{tuned}]
        └─vmtoolsd───{vmtoolsd}
```

## PS：
/proc   内核中的状态信息：
    内核参数：
        可设置其值从而调整内核运行特性的参数:/proc/sys
        状态变量：其用于输出内核中统计信息和状态信息，仅用于查看；

        参数，模拟成文件系统类型；
        proc中数字目录为进程号：
        进程：
            /proc/#
                #:PID

## ps： report a snapshot of the current processes.
取当前命令执行这一刻的状态；
三种风格：


1   UNIX options, which may be grouped and must be preceded by a dash.
2   BSD options, which may be grouped and must not be used with a dash.
3   GNU long options, which are preceded by two dashes.

1:带一个“-"
2:带两个“-”
3：长选项“--”

启动进程的方式：
    系统启动过程中自动启动；与终端无关的进程；
    用户通过终端启动：与终端相关的进程；

    a：所有与终端相关的进程
    x：所有与终端无关的进程
        []内核线程
    u：以用户为中心组织进程状态信息显示；
        VSZ ：虚拟内存级，占用的虚拟内存大小（非swap）；
        RSS ：常驻内存级；（不能放交换分区的数据）；
        STAT ：当前进程的运行状态：BSD风格；R:running S:interruptable sleeping D :uninter... T :stopped Z:zombie
        带+ 号表示前台进程，
        l ：多线程进程
        N ：高优先级
        < ：高优先级
        s ：session leader
    -e ：Unix风格：显示所有进程；
    -f ：full format 完整格式的
    常用组合2： ps -ef

    -F ：显示完整格式的进程信息
        C：cpu utilization CPU占用
        PSR：运行于哪颗cpu上；
    -H ：以层级结构显示进程的相关信息；

    常用组合之三：-eFH
    常用组合之四：
    -eo : 自定义要显示的字段；以逗号分割了；
    axo ：field1，field2.。。常见的field，pid、nl、prl、psr、pcpu、stat、comm、tty、ppid；
        nl：nice值
        priority：优先级；
        rtprio：实时优先级；
## pgrep、pkill命令：
进程过滤    关闭进程
pgrep 
-u ：uid user；
-U ：UID read user；
-t terminal ：与指定的终端相关的进程；
-l ：显示进程名；
-a ：显示完整格式的进程名；
-p pid ：显示此进程的子进程；


## pidof命令
根据进程名，取其pid

## top命令：

uptime命令：显示系统时间、运行时长以及平均负载
top第一行显示的就是此信息；

PID 用户    优先级  nice值  虚拟内存级  常驻内存级  共享内存级  运行状态    CPU百分比   内存百分比  运行时长

排序
P   :以占据cpu百分比排序
M   ：以占据内存百分比
T   ：累计占用cpu时间排序

首部信息：
    uptime信息：l命令
    task及cpu信息：t命令
    内存信息：m命令

退出：q
修改刷新：s
终止指定的进程：k

选项：
-d #：刷新时间间隔，默认3s
-b ：批次方式显示；
-n #：显示多少批次；


## HTOP
    -d # ：指定延迟时间间隔；
    -u USer Name ：仅显示指定用户的进程
    -s colume：以指定字段进行排序
子命令：
    l：显示进程所打开的所有文件；
    s：跟踪选定的进程的系统调用
    t：以层级关系显示各进程状态
    a：将选定的进程绑定至某个cpu核心上；


## vmstat：报告虚拟内存的使用情况：
procs：
    r:等待运行的进程的个数；cpu上等待运行的任务的队列长度；
    b：处于不可中断睡眠态的进程个数；被阻塞的任务队列的长度；
memory：
    swpd ：交换内存使用总量；
    free ：空闲的物理内存总量
    buff ：用于buffee的内存总量
    cache :用于cache的内存总量
swap：
    si : 数据进入swap的速率：单位是（kb/s）
    so ：数据离开swap的速率，（kb/s）
io：
    bi ：从块设备读入数据到系统的速率（kb/s）
    bo ：保存数据到块设备的速率（kb/s）
system：
    in ：中断速率
    cs ：上下文切换的速率

cpu ：
    us ：用户空间的程序所占用cpu的百分比
    sy ：system
    id ：idle
    wa ：wait
    st ：被虚拟化技术偷走的

选项：
    -s ：显示内存统计信息；


## pmap
pmap [options] pid [...]

pmap -x 1
    -x :显示详细格式的信息；
    另一种查看的方式
    cat /proc/PID/maps

## glances 命令：
常见选项：
    -b ：以Byte为单位显示网卡数据速率；
    -d ：关闭磁盘I/O模块
    -m ：关闭mount模块
    -n ：关闭network模块
    -t # ：刷新时间间隔
    -1 ：每个cpu的相关数据单独显示；
    -o ：指定输出格式；

## Dstat:
强大的实时系统信息显示：
    -c --cpu        CPU相关
        -C total
    -d --disk       磁盘相关
        -D sda sdb total
    -g 显示page相关的统计数据
    -m 内存相关
    -n 网络
    -p 进程相关统计
    -r IO
    -s swap
    --tcp 显示tcp
    --udp
    --raw
    --socket

    --ipc   进程间通信

    --top-cpu 最占用cpu的进程
    --top-io 
    --top-memory
    --top-lantency 延迟最大的进程

## kill 命令： terminate a process
用于向进程发送信号，以实现对进程的管理；

kill -l 显示系统当前的信号列表
每个信号的标识方法有三种：
    * 信号的数字标识    1
    * 信号的完整名称    SIGHUP
    * 信号的简写名称    HUP

向进程发信号：
    kill [-s |signal|-SIGNAL] PID...

    常用信号：
    * 1号进程：SIGHUP ：无需关闭进程让其重读配置文件；
    * 2号进程：SIGINT ：中止正在运行的进程，相当于ctrl+C
    * 9号进程：SIGKILL ：杀死运行中的进程；不管是否打开文件。直接杀掉；可能会损坏该进程打开的文件
    * 15号进程：SIGTERM：终止运行中的进程；
    * 18 ：SIGCONT 
    * 19 ：SIGSTOP 

## killall 命令：
kill process by NAME
`killall httpd`

