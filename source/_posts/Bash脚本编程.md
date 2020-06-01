---
title: Bash脚本编程
categories: Linux
tags:
  - Bash
  - linux
  - shell
abbrlink: 1681557695
date: 2020-05-06 13:22:33
---
### 脚本文件格式
第一行写上`#!/bin/bash`
注释信息 `#`
代码注释：
适当的缩进和空白行；

语言：编程语法格式，库，算法和数据结构；
编程思想：
问题空间 --> 解空间

Bash是典型的弱类型的编程语言
数据类型：字符型、整数值
弱类型：字符型

### 变量：
局部变量
本地变量
环境变量
位置参数变量
特殊变量

### 算数运算
```bash
+, -, *, /, %, **
let VAR=expression
VAR=$[expression]
VAR=$((expression))
VAR=$(expr argu1 argu2 argu3)
```

增强型赋值
变量做某种算数运算后回存到此变量中；
```bash
let i=$i+#
let i+=#
```

`+=, -=, *=, /=, %=`

### 条件测试：
判断某需求是否满足；需要测试机制来实现；
1. 执行命令，根据命令的返回值来判断；
0：成功
1-255： 失败
2. 测试表达式；
test expression
[ expression ]
[[ expression ]]
注意： expression两端必须有空白字符，否则为语法错误；

### Bash的测试类型：
- 数值测试
- 字符串测试
- 文字测试

#### 数值测试： 数值比较；
    -eq： 是否等于；[ A -eq B ];
    -ne： 是否不等于；
    -gt： 是否大于；
    -ge： 是否大于等于；
    -lt： 是否小于；
    -le： 是否小于等于；
代码中的 [] 执行基本的算数运算，如：
```bash
#!/bin/bash

a=5
b=6

result=$[a+b] # 注意等号两边不能有空格
echo "result 为： $result"
```

#### 字符串测试:
```bash
    ==： 是否等于；
    >： 是否大于；
    <： 是否小于；
    !=：是否不等于；
    =~： 左侧字符串是否能被右侧的PATTERN匹配；
    -z "STRING"： 判断指定的字符串是否为空；空为真，非空为假。
    -n "STRING"： 判断指定的字符串是否非空，非空为真，空为假；
```

注意：
- 字符串要加引用；
- 要使用[[ ]];


#### 文件测试：
1. 存在测试：
```bash
    -a FILE
    -e FILE: 如果文件存在则为真
```

2. 存在及类型测试：
```bash
    -b 如果文件存在且为块特殊文件则为真
    -c 如果文件存在且为字符型特殊文件则为真
    -d 如果文件存在且为目录则为真
    -f 如果文件存在且为普通文件则为真
    -h 链接文件
    -p 管道文件
    -S 套接字文件
    3. 文件权限测试：
    -r 存在且可读
    -w 存在且可写
    -x 存在且可执行
    4. 特殊权限测试：
    -u 存在且拥有suid
    -g 存在且拥有sgid
    -k 存在且拥有sticky
```

5. 文件内容测试：
```bash
    -s 是否有内容
```

6. 时间戳：
```bash
    -N FILE ：文件自上一次读操作后是否被修改；
```

7. 从属关系测试：
```bash
    -O FILE：当前用户是否为文件的属主；
    -G FILE：当前用户是否为文件的属组；
```

1. 双目测试：
```bash
    FILE1 -ef FILE2；FILE1与FILE2是否指向同一个文件系统的相同inode的硬链接；
    FILE1 -nt FILE2：FILE1是否新于FILE2；
    FILE1 -ot FILE2：FILE1是否旧于FILE2；
```

###  组合测试条件：
逻辑运算：
```bash
1. 
    COMMAND1 && COMMAND2
    COMMAND1 || COMMAND2
    !COMMAND
    [ -O FILE ] && [ -r FILE ]
2. 
    EXPRESSION1 -a EXPRESSION2
    EXPRESSION1 -O EXPRESSION2
    !EXPRESSION
    [ -O FILE -a -x FILE ]
```

练习：将当前主机名称保存至hostname变量中：
主机名如果为空，或者为localhost.localdomain,则将其设置为www.magedu.com;
```bash
#!/bin/bash
hostname=$(hostname)
[ -z "$hostname" -o "$hostname"=="localhost.localdomain" -o "$hostname"=="localhost" ] && hostname www.magedu.com

```

### 脚本的状态返回值：
默认是脚本执行的最后一条命令的返回值；
自定义状态退出状态码:
exit [n]：n为自己指定的状态码；
注意：SHELL进程遇到exit时，即会终止，因此整个脚本执行即为结束。

###  向脚本传递参数
#### 位置参数变量
myscript.sh
引用方式：
$1,$2,$3...$10,$11...
轮替：
shift [n]: 位置参数轮替：
```bash
    #!/bin/bash
    file1_lines=$(grep "^$" $1 | wc -l)
    file2_lines=$(grep "^$" $2 | wc -l)
    echo "Total blank lines: $[$file1_lines+$file2_lines]"
```

#### 特殊变量：
```bash
$0:脚本文件路径本身;
$#:脚本参数的个数；
$*:所有参数 （分割为多个字符串）
$@:所有参数 （合并为一个字符串）
```

`[ $# -lt 2 ] && echo "At least two files" && exit 1`
如果参数个数小于2个，提示至少需要2个参数，并退出，状态码1

过程式编程语言的代码执行顺序：
顺序执行： 逐条执行；
选择执行：
    代码有一个分支： 条件满足时才会执行；
    两个或以上的分支：只会执行其中一个满足条件的分支；
循环执行：
    某代码片段（循环体）要执行0、1或者多个来回；
选择执行：
单分支的if语句：
if 测试条件
then
    代码分支
fi

双分支的if语句
if 测试条件；then
    条件为真时执行的分支
else
    条件为假时执行的分支
fi

示例： 通过参数传递一个用户名给脚本，此用户不存在时，则添加之；
```bash
#!/bin/bash
#
[ $# -lt 1 ] && echo "At least one username." && exit 1

if ! grep "^$1\>" /etc/passwd &> /dev/null; then
    useradd $1
    echo $1 | passwd --stdin $1 &> /dev/null
    echo "Add user $1 finished."
else
    echo "user $1 exist."
fi
```

练习1： 通过命令行参数给定两个数字，输出其中较大的数值；
练习2： 通过命令行参数指定一个用户名，判断其ID号是偶数还是奇数；
练习3： 通过命令行参数给定两个文本文件名，如果某文件不存在，则结束脚本执行；
        都存在时返回每个文件的行数，并说明其中行数较多的文件；

