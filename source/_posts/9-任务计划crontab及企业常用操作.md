---
title: 9.任务计划crontab及企业常用操作
date: 2020-06-01 04:27:09
layout:
updated:
comments:
categories:
tags:
---

# Linux 任务计划、周期性任务执行

未来的某个时间点执行以此某任务：at，batch

周期性运行某任务：crontab

执行结果：会通过邮件发送给用户

这个邮件只用于本机，以及本机各用户之间

/var/spool/mail/USER

用户的邮箱

ss -ntlp

master 进程属于postfix进程负责监听的，为本地主机个用户之间传递邮件用的



**本地电子邮件服务：**

smtp： simple mall transmission protocol

pop3：post office protocol

imap4：Internet mall access protocol

**mail命令**

mailx - send and receive Internet mall

MUA：mall USer Agent 用户收发邮件的工具程序

mailx [-s SUBJECT] USERNAME@[HOSTNAME]



mail不带任何命令表示收邮件

输入邮件编号即可查看邮件

subject：标题

hostname：在发给本机用户时可省略

content-type:正文内容

from：谁发的

to：发给谁

DAte：时间

user-agent：用什么程序发的；



**示例：**

mail -s "fstab file" root < /etc/fstab

cat /etc/fstab | mail -s "fstab file" centos

邮件正文的输入：

1：交互式输入：单独成行可以表示正文结束，ctrl+d 提交亦可

2：输入重定向

3：通过管道



## AT命令：

at [OPTION]... TIME

at now+2min

at>直接输入你要执行的命令

ctrl+d提交

at -l 显示任务队列

at的作业有队列，用单个字母表示，默认都使用a队列；

常用选项：

-l 查看作业队列，相当于atq

-f /path/from/somefile 从文件读入作业任务，而不用再交互式输入

-d 删除任务队列，相当与atrm

-c 查看指定作业的具体内容；

-q queue：指明队列；

注意，作业执行结果是以邮件发给提交作业的用户；



## batch

batch会让系统自行选择在系统资源空闲的时间去执行指定的任务；其他与at相同



## crontab

周期性执行任务

cron机制：

服务程序：

cronle：主程序包，提供了crond守护进程及相关辅助工具；

systemctl status crond

service crond status

向crond提交作业的方式不同于at，它需要使用专用的配置文件，此文件有固定的格式，不建议使用文本编辑器直接编辑此文件；需要使用crontab命令；

cron任务分为2类：

#### 系统cron任务：主要用于实现系统自身的维护；

手动编辑：/etc/crontab 文件

用户cron任务：

命令：crontab命令

SHELL=/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
MAILTO=root

For details see man 4 crontabs

Example of job definition:

.---------------- minute (0 - 59)

|  .------------- hour (0 - 23)

|  |  .---------- day of month (1 - 31)

|  |  |  .------- month (1 - 12) OR jan,feb,mar,apr ...

|  |  |  |  .---- day of week (0 - 6) (Sunday=0 or 7) OR sun,mon,tue,wed,thu,fri,sat

|  |  |  |  |

*  *  *  *  * user-name  command to be executed



**注意：**

1.每一行定义一个周期性任务；

* * * * * 定义周期性时间
        * user-name 运行任务的用户身份
        * command to be excuted 任务，最好使用程序的绝对路径

2.此处的环境变量不同与用户登陆后获得的环境，因此，建议命令使用绝对路径，或者自定义PATH变量

3.执行结果会以邮件的形式mailto指定的用户

#### 用户cron的配置格式：/var/spool/cron/USERNAME

**注意：**

1.每行定义一个cron任务，共6个字段；

2.此处的环境变量不同与用户登陆后获得的环境，因此，建议命令使用绝对路径，或者自定义PATH变量

3.执行结果会以邮件的形式发给当前用户

### 时间表示法：

1.特定表示法；

给定时间点有效取值范围的值；

注意：day of week 和day of month 一般不同时使用；

2.* 给定时间点上有效取值范围内的所有值；min（0-59），每分，每小时

3.离散取值法：在给定时间点上使用逗号分割的多个值；

#，#，#

4.连续取值： -

在时间点上使用-连接开头和结束

#-#

5 在指定时间点上，定义步长；

*/# :# 及步长

**注意：**

1.指定时间点不能被步长整除时，其意义将不复存在；

2.最小单位为 `分钟` ，想完成 `秒`级任务，需要额外借助于其他机制；

定义每分钟任务：而在利用脚本实现在每分钟之内，循环执行多次；

**示例：**

1.3 * * * * ：每小时执行一次；每小时的第3分钟；

2.3 4 * * 5 : 每周执行一次；每周5的4点3分；

3.5 6 7 * * ：每月执行一次，每月的7号的6点5分；

4.7 8 9 10 * ：每年执行一次；每年的10月9号8点7分

5.9 8 * * 3,7 ：每周三和周日；8点9分

6.* 8,20 * * 3,7 ; 每周三和周日的8点和20点各执行一次；

7.0 9-18 * * 1-5：周一到周五的9-18点，工作日的每小时；

8.*/5 * * * * ：每5分钟执行一次；

9.*/7 * * * * :



### crontab命令：

crontab [-u user] [-l | -r | -e] [-i] [-s]

-e 编辑任务；

-l 列出所有任务

-r 移除所有任务；即删除/var/spool/cron/USERNAME文件；

-i 在使用-r选项移除所有任务时提示用户确认；

-u user：root用户可指定为某个用户编辑任务；



**注意**：运行结果以邮件通知给当前用户；如果拒绝接受邮件：

1.command >/dev/null

2.command &> /dev/null

**(确保正常执行再加/dev/null，否则就悲剧了)**

注意：定义command，如果命令需要用到%，需要对其转义；但放置于单引号中的%不用转义亦可；

某任务在指定的时间因关机未能执行，下次开机会不会自动执行？

不会！！

如果期望某时间因故未能按时执行，下次开机后无论是否到了时间点都要执行一次，可用anacron实现；

课外作业：anacron及其应用；



练习：

1.每12个小时备份一个/etc 目录至/backup 目录中，保存文件格式为“etc-yyyy-mm-dd-hh.tar.xz”;

2.每周2,4,7备份/var/log/secure 文件至/logs目录中，文件名格式为 "secure-yyyymmdd";

3.每两小时取出当前系统/proc/meminfo文件中以S或M开头的行信息追加到/tmp/meminfo.txt文件中；


