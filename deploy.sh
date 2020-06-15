#!/bin/bash

## 提交本地的更改到远程仓库
cd /root/blog
git add .
git commit -m "New Push"
git push origin master:gh-pages

