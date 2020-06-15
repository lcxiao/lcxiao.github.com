---
title: 18.SHELL循环
date: 2020-06-15 13:10:33
layout:
updated:
comments:
categories:
tags:
---
# BASH编程
顺序执行
选择执行    if，case
循环执行    for，while，until

## for循环格式：
for VARAIBLE in LIST；do
    循环体
done

## while循环：
while CONDITION；do
    循环体
    循环控制变量修正表达式
done

进入条件：CONDITION测试为真
退出条件：CONDITION测试为假

## until循环：（相当于while测试条件加！号）
until CONDITION；do
    循环体
    循环控制变量修正表达式
done
进入条件：CONDITION测试为假
退出条件：CONDITION测试为真

## 练习：
1.求100内偶数之和、100以内奇数之和
2、创建10个用户。user101-user110；密码同用户
3、打印99乘法表
4、打印逆序九九乘法表


