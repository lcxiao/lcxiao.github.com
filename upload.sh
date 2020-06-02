#!/bin/bash

echo "博客自用脚本"
read -p "Your Choice:" choice
if [ "$choice" -eq 1 ]


#提交blog源程序目录
git push origin master:gh-pages

#清理日志，等待重新生成
hexo clean

#添加一篇新的日志
hexo n BLOG_NAME

#添加新的页面
hexo new page PAGE_NAME

#部署到github
hexo deploy

