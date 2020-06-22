#!/bin/bash

usage(){
    echo "Usage: 输入数字选择功能: "
    echo "1 #提交blog源程序目录."
    echo "2 #清理日志，等待重新生成"
    echo "3 #添加一篇新的日志"
    echo "4 #添加新的页面"
    echo "5 #部署到github"
    echo "q exit."
}

[ $# -lt 1 ] && usage && exit 1

case $1 in
1)
#提交blog源程序目录
git add .
git commit -m "New blog"
git push origin master:gh-pages
;;
2)
#清理日志，等待重新生成
hexo clean
;;
3)
#添加一篇新的日志
hexo n BLOG_NAME
;;
4)
#添加新的页面
hexo new page PAGE_NAME
;;
5)
#部署到github
hexo g -d
;;
q)
exit 0
;;
*)
exit 0
;;
esac

