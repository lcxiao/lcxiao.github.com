---
title: progit
categories: Linux
tags:
  - git
  - linux
  - 版本控制
abbrlink: 4101521654
date: 2020-05-06 13:23:11
---
版本控制--> 版本控制系统-->本地版本控制系统-->集中化的版本控制系统-->分布式版本控制系统

# Git 是什么？ 
分布式版本控制系统 
客户端并不只提取最新版本的文件快照， 而是把代码仓库完整地镜像 下来，包括完整的历史记录。 这么一来，任何一处协同工作用的服务器发生故障，事后都可以用任何一个镜像 出来的本地仓库恢复。 因为每一次的克隆操作，实际上都是一次对代码仓库的完整备份.

- 直接记录快照，而非差异比较  *快照流*
- 近乎所有操作都是本地执行
- Git 保证完整性 
   - Git 用以计算校验和的机制叫做 SHA-1 散列
   - Git 数据库中保存的信息都是以文件内 容的哈希值来索引，而不是文件名.
- Git 一般只添加数据 

# 三种状态 
- 已提交（committed）
    - 已提交表示数据已经安全地保存在本地数据库中.
- 已修改（modified）
    - 修改了文件，但还没保存到数据库中。
- 已暂存（staged）
    - 示对一个已修改文件的当前版本做了标记，使之包含在下次提交的快照中。 

这会让我们的 Git 项目拥有三个阶段：工作区、暂存区以及 Git 目录。

工作区是对项目的某个版本独立提取出来的内容。 这些从 Git 仓库的压缩数据库中提取出来的文件，放在磁盘上 供你使用或修改。 

暂存区是一个文件，保存了下次将要提交的文件列表信息，一般在 Git 仓库目录中。 按照 Git 的术语叫做“索 引”，不过一般说法还是叫“暂存区”。 

Git 仓库目录是 Git 用来保存项目的元数据和对象数据库的地方。 这是 Git 中最重要的部分，从其它计算机克隆 仓库时，复制的就是这里的数据。 

# 基本的 Git 工作流程如下： 
1. 在工作区中修改文件。 
2. 将你想要下次提交的更改选择性地暂存，这样只会将更改的部分添加到暂存区。 
3. 提交更新，找到暂存区的文件，将快照永久性存储到 Git 目录。

如果 Git 目录中保存着特定版本的文件，就属于 `已提交` 状态。 如果文件已修改并放入暂存区，就属于 `已暂存` 状 态。 如果自上次检出后，作了修改但还没有放到暂存区域，就是 `已修改` 状态.

# 安装 
从源代码安装 :
从源码安装 Git，需要安装 Git 依赖的库：autotools、curl、zlib、openssl、expat 和 libiconv。

```bash
$ sudo dnf install dh-autoreconf curl-devel expat-devel gettext-devel \   openssl-devel perl-devel zlib-devel 
$ sudo apt-get install dh-autoreconf libcurl4-gnutls-dev libexpat1-dev \   
gettext libz-dev libssl-dev 
```

为了添加文档的多种格式（doc、html、info），需要以下附加的依赖：

```bash
$ sudo dnf install asciidoc xmlto docbook2X 
$ sudo apt-get install asciidoc xmlto docbook2x 
```

> 使用 RHEL 和 RHEL 衍生版，如 CentOS 和 Scientific Linux 的用户需要 开启 EPEL 库 以便下 载 docbook2X 包。 

使用基于 Debian 的发行版（Debian/Ubuntu/Ubuntu-derivatives），你也需要 install-info 包：
`$ sudo apt-get install install-info `

如果你使用基于 RPM 的发行版（Fedora/RHEL/RHEL衍生版），你还需要 getopt 包 （它已经在基于 Debian 的发行版中预装了）：
`sudo dnf install getopt `

此外，如果你使用 Fedora/RHEL/RHEL衍生版，那么你需要执行以下命令：
`$ sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi`

> 当你安装好所有的必要依赖，你可以继续从几个地方来取得最新发布版本的 tar 包。 你可以从 Kernel.org 网站 获取，网址为 https://www.kernel.org/pub/software/scm/git， 或从 GitHub 网站上的镜像来获得，网址为 https://github.com/git/git/releases。 通常在 GitHub 上的是最新版本，但 kernel.org 上包含有文件下载签 名，如果你想验证下载正确性的话会用到。 

```bash
tar -zxf git-2.8.0.tar.gz
cd git-2.8.0
make configure
./configure --prefix=/usr 
make all doc info
make install install-doc install-html install-info
```

完成后，你可以使用 Git 来获取 Git 的更新：
` git clone git://git.kernel.org/pub/scm/git/git.git`

# Git 基础 
获取 Git 仓库 
通常有两种获取 Git 项目仓库的方式：
1. 将尚未进行版本控制的本地目录转换为 Git 仓库； 
2. 从其它服务器 克隆 一个已存在的 Git 仓库。 两种方式都会在你的本地机器上得到一个工作就绪的 Git 仓库。 

如果在一个已存在文件的文件夹（而非空文件夹）中进行版本控制，你应该开始追踪这些文件并进行初始提交。 可以通过 git add 命令来指定所需的文件来进行追踪，然后执行 git commit ：

```bash
$ git add *.c 
$ git add LICENSE 
$ git commit -m 'initial project version' 
```

**克隆现有的仓库** 

 `git clone <url> `

工作目录中除已跟踪文件外的其它所有文件都属于未跟踪文件，它们既不存在于上次快照的记录中，也没有被放 入暂存区。 初次克隆某个仓库的时候，工作目录中的所有文件都属于已跟踪文件，并处于未修改状态，因为 Git 刚刚检出了它们， 而你尚未编辑过它们。

**检查当前文件状态** 

`git status`

**跟踪新文件** 

`git add`



**忽略文件** 

一般我们总会有些文件无需纳入 Git 的管理，也不希望它们总出现在未跟踪文件列表。 通常都是些自动生成的文 件，比如日志文件，或者编译过程中创建的临时文件等。 在这种情况下，我们可以创建一个名为 .gitignore 的文件，列出要忽略的文件的模式。 来看一个实际的 .gitignore 例子：

```
$ cat .gitignore 
*.[oa] 
*~ 
```

第一行告诉 Git 忽略所有以 .o 或 .a 结尾的文件。一般这类对象文件和存档文件都是编译过程中出现的。 第二 行告诉 Git 忽略所有名字以波浪符（~）结尾的文件，许多文本编辑软件（比如 Emacs）都用这样的文件名保存 副本。 此外，你可能还需要忽略 log，tmp 或者 pid 目录，以及自动生成的文档等等。 要养成一开始就为你的 新仓库设置好 .gitignore 文件的习惯，以免将来误提交这类无用的文件

**我们再看一个 .gitignore 文件的例子：**

```bash
# 忽略所有的 .a 文件 
*.a 
# 但跟踪所有的 lib.a，即便你在前面忽略了 .a 文件 
!lib.a 
# 只忽略当前目录下的 TODO 文件，而不忽略 subdir/TODO 
/TODO 
# 忽略任何目录下名为 build 的文件夹 
build/ 
# 忽略 doc/notes.txt，但不忽略 doc/server/arch.txt 
doc/*.txt 
# 忽略 doc/ 目录及其所有子目录下的 .pdf 文件 
doc/**/*.pdf 
```

**查看已暂存和未暂存的修改** 

要查看尚未暂存的文件更新了哪些部分，不加参数直接输入 `git diff`;

若要查看已暂存的将要添加到下次提交里的内容，可以用 `git diff --staged` 命令。 这条命令将比对已暂存 文件与最后一次提交的文件差异;

然后用 `git diff --cached` 查看已经暂存起来的变化（ --staged 和 --cached 是同义词）;



**提交更新** 

`git commit `

你也可以在 commit 命令后添加 -m 选项，将提交信息与命令放在同一行

请记住，提交时记录的是放在暂存区域的快照。 任何还未暂存文件的仍然保持已修改状态，可以在下次提交时 纳入版本管理。 每一次运行提交操作，都是对你项目作一次快照，以后可以回到这个状态，或者进行比较

**跳过使用暂存区域** 

尽管使用暂存区域的方式可以精心准备要提交的细节，但有时候这么做略显繁琐。 Git 提供了一个跳过使用暂 存区域的方式， 只要在提交的时候，给 git commit 加上 -a 选项，Git 就会自动把所有已经跟踪过的文件暂存 起来一并提交，从而跳过 git add 步骤：

```bash
$ git commit -a -m 'added new benchmarks'
[master 83e38c7] added new benchmarks
1 file changed, 5 insertions(+), 0 deletions(-) 
```

**移除文件** 

 要从 Git 中移除某个文件，就必须要从已跟踪文件清单中移除（确切地说，是从暂存区域移除），然后提交。 可以用 git rm 命令完成此项工作，并连带从工作目录中删除指定的文件，这样以后就不会出现在未跟踪文件清 单中了。 

**查看提交历史** 

`git log`


