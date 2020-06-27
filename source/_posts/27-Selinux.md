---
title: 27.Selinux
date: 2020-06-27 07:32:29
layout:
updated:
comments:
categories:
tags:
---
Selinux
    Secure Enhanced Linux

工作于内核中
强制访问控制

DAC：自主访问控制：


MAC：强制访问控制：

最小权限法则

解决进程启动之后拥有属主所有权限的问题


sandbox：沙箱机制

任何进程启动之后，会处于一个我们提供的最小权限环境下，即使脱离控制，也不能随意造成破坏；

不需要把所有进程都置入沙箱

若果ps top 都被替换？

通常别人能够访问到的服务进程应该纳入selinux

SElinux2种工作级别：
    strict：每个进程都受到SElinux的控制：
    targeted：有限的进程受到SElinux的控制：只监控容易被入侵的进程；


安全法则模型：
    subject：进程
    object：其他进程或文件
        文件：open、read、write、close、chown、chmod
    subject：domain 域
    object：type    类型

ls -Z 
ps auxZ

SElinux为每个文件提供了安全标签，也为进程提供了安全标签；
user：role：type
    user：SElinux的user；
    role：角色
    type：类型


