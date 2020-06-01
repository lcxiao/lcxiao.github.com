---
title: Git 和 GitHub 使用入门
date: 2020-05-06 07:03:09
layout:
updated:
comments:
categories:
tags:
---
# 使用常见 Git 命令
## 推送提交到远程仓库
使用 `git push` 将本地分支上的提交推送到远程仓库。
git push 命令使用两个参数：
- 远程命令，如 `origin`
- 分支名称，如 `master`
例如：
`git push  <REMOTENAME> <BRANCHNAME> `
例如，您通常运行 git push origin master 来推送本地更改到在线仓库。

**重命名分支**
要重命名分支，同样使用 git push 命令，但要加上一个或多个参数：新分支的名称。
 例如：
`git push  <REMOTENAME> <LOCALBRANCHNAME>:<REMOTEBRANCHNAME> `
这会将 `LOCALBRANCHNAME` 推送到 `REMOTENAME`，但其名称将改为 `REMOTEBRANCHNAME`。
如果仓库的本地副本未同步或“落后于”您推送到的上游分支，您会收到一条消息表示：non-fast-forward updates were rejected。 这意味着您必须检索或“提取”上游更改，然后才可推送本地更改。

**推送标记**
默认情况下，没有其他参数时，git push 会发送所有名称与远程分支相同的匹配分支。
要推送单一标记，可以发出与推送分支相同的命令：
`git push  <REMOTENAME> <TAGNAME> `
要推送所有标记，可以输入命令：
`git push  <REMOTENAME> --tags`

**删除远程分支或标记**
删除分支的语法初看有点神秘：
`git push  <REMOTENAME> :<BRANCHNAME> `

**远程和复刻**
在克隆您拥有的仓库时，向其提供远程 URL，告知 Git 到何处提取和推送更新。 如果要协作处理原始仓库，可添加新的远程 URL（通常称为 upstream）到本地 Git 克隆：
`git remote add upstream  <THEIR_REMOTE_URL> `

## 从远程仓库获取更改
您可以使用常用 Git 命令访问远程仓库。
与远程仓库交互时，这些命令非常有用。 `clone` 和 `fetch` 用于从仓库的远程 URL 将远程代码下载到您的本地计算机，`merge` 用于将其他人的工作与您的工作合并在一起，而 `pull` 是 `fetch` 和 `merge` 的组合。

**克隆仓库**
要获取其他用户仓库的完整副本，请使用 `git clone`，如下所示：
`git clone https://github.com/USERNAME/REPOSITORY.git`
`将仓库克隆到您的计算机`
运行 git clone 时，将发生以下操作：
- 创建名为 `repo` 的文件夹
- 将它初始化为 Git 仓库
- 创建名为 `origin` 的远程仓库，指向用于克隆的 URL
- 将所有的仓库文件和提交下载到那里
- 检出默认分支（通常称为`master`）
对于远程仓库中的每个 foo 分支，在本地仓库中创建相应的远程跟踪分支 `refs/remotes/origin/foo`。 通常可以将此类远程跟踪分支名称缩写为` origin/foo`。

**从远程仓库获取更改**
使用 `git fetch` 可检索其他人完成的新工作。 从仓库获取将会获取所有新的远程跟踪分支和标记，但不会将这些更改合并到您自己的分支中。
如果已经有一个本地仓库包含为所需项目设置的远程 URL，您可以在终端使用 `git fetch *remotename*` 获取所有新信息：
`git fetch remotename`
`获取远程仓库的更新`

**合并更改到本地分支**
合并可将您的本地更改与其他人所做的更改组合起来。

通常将远程跟踪分支（即从远程仓库获取的分支）与您的本地分支进行合并：
```
git merge remotename/branchname
将在线更新与您的本地工作进行合并
```

**从远程仓库拉取更改**
`git pull` 是在同一个命令中完成 `git fetch` 和 `git merge` 的便捷方式。
```
git pull remotename branchname
获取在线更新并将其与您的本地工作进行合并
```
## 管理远程仓库
 添加远程
`git remote add` 命令使用两个参数：
- 远程命令，如 `origin`
- 远程 URL，如 `https://github.com/user/repo.git`

**重命名远程**
`git remote rename` 命令使用两个参数：
- 现有的远程名称，例如 `origin`
- 远程的新名称，例如 `destination`

**删除远程**
`git remote rm` 命令使用一个参数：
远程名称，例如 `destination`

[将子文件夹拆分成新仓库](https://help.github.com/cn/github/using-git/splitting-a-subfolder-out-into-a-new-repository)


## 在 Git 中设置用户名
- 全局设置：
    `git config --global user.name "Mona Lisa"`
- 为一个仓库设置 Git 用户名
    `git config user.name "Mona Lisa"`
- 在 Git 中设置您的提交电子邮件地址
    `git config --global user.email "email@example.com"`
**在 Git 中缓存 GitHub 密码**
如果使用 HTTPS 克隆 GitHub 仓库
- windows: `git config --global credential.helper wincred`
- linux: ` git config --global credential.helper cache`
- 更改默认的密码缓存时限: `git config --global credential.helper 'cache --timeout=3600'`(以秒为单位)
  
**为什么 Git 总是询问我的密码？**
如果 Git 在您每次尝试与 GitHub 交互时均提示输入用户名和密码，则您可能为仓库使用的是 HTTPS 克隆 URL。

## 新增 SSH 密钥到 GitHub 帐户
1. 将 SSH 密钥复制到剪贴板
- `ssh-keygen -t rsa -b 4096 -C "your_email@example.com"`
- `Copy` your `.ssh/id_rsa.pub`

2. 在任何页面的右上角，单击您的个人资料照片，然后单击 Settings（设置）。
<img src="https://github-images.s3.amazonaws.com/enterprise/2.20/assets/images/help/settings/userbar-account-settings.png" width="20%">

3. 在用户设置侧边栏中，单击 SSH and GPG keys（SSH 和 GPG 密钥）。
<img src="https://github-images.s3.amazonaws.com/enterprise/2.20/assets/images/help/settings/settings-sidebar-ssh-keys.png" width="30%">

4. 单击 New SSH key（新 SSH 密钥）或 Add SSH key（添加 SSH 密钥）。
<img src="https://github-images.s3.amazonaws.com/enterprise/2.20/assets/images/help/settings/ssh-add-ssh-key.png" width="50%">

5. 在 "Title"（标题）字段中，为新密钥添加描述性标签。 例如，如果您使用的是个人 Mac，此密钥名称可能是 "Personal MacBook Air"。

6. 将密钥粘贴到 "Key"（密钥）字段。
<img src="https://github-images.s3.amazonaws.com/enterprise/2.20/assets/images/help/settings/ssh-key-paste.png" width="50%">

7. 单击 Add SSH key（添加 SSH 密钥）。
<img src="https://github-images.s3.amazonaws.com/enterprise/2.20/assets/images/help/settings/ssh-add-key.png" width="10%">

8. 如有提示，请确认您的 GitHub Enterprise 密码。
<img src="https://github-images.s3.amazonaws.com/enterprise/2.20/assets/images/help/settings/sudo_mode_popup.png" width="20%">

*参考：*[使用 SSH 连接到 GitHub](https://help.github.com/cn/enterprise/2.20/user/github/authenticating-to-github/connecting-to-github-with-ssh)
