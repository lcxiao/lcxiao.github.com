---
title: Text to AscII Art
date: 2020-05-06 07:02:19
layout:
updated:
comments:
categories:
tags:
---
# Figlet
# Toilet

## figlet
```bash
Usage: figlet [ -cklnoprstvxDELNRSWX ] [ -d fontdirectory ]
              [ -f fontfile ] [ -m smushmode ] [ -w outputwidth ]
              [ -C controlfile ] [ -I infocode ] [ message ]
```

## toilet
```bash
-f, --font <name>        select the font
  -d, --directory <dir>    specify font directory
  -s, -S, -k, -W, -o       render mode (default, force smushing,
                           kerning, full width, overlap)
  -w, --width <width>      set output width
  -t, --termwidth          adapt to terminal's width
  -F, --filter <filters>   apply one or several filters to the text
  -F, --filter list        list available filters
      --gay                rainbow filter (same as -F gay)
      --metal              metal filter (same as -F metal)
  -E, --export <format>    select export format
  -E, --export list        list available export formats
      --irc                output IRC colour codes (same as -E irc)
      --html               output an HTML document (same as -E html)
  -h, --help               display this help and exit
  -I, --infocode <code>    print FIGlet-compatible infocode
  -v, --version            output version information and exit
Usage: toilet [ -hkostvSW ] [ -d fontdirectory ]
              [ -f fontfile ] [ -F filter ] [ -w outputwidth ]
              [ -I infocode ] [ -E format ] [ message ]
```

## 生成艺术字
```c
root@testlab:/usr/share/figlet/fonts# figlet -f Graffiti.flf jack
     __               __    
    |__|____    ____ |  | __
    |  \__  \ _/ ___\|  |/ /
    |  |/ __ \\  \___|    < 
/\__|  (____  /\___  >__|_ \
\______|    \/     \/     \/
```

```c
root@testlab:~# figlet -f /usr/share/figlet/fonts/Graffiti.flf "A man from Mars!" -t
   _____                              _____                           _____                      ._.
  /  _  \     _____ _____    ____   _/ ____\______  ____   _____     /     \ _____ _______  _____| |
 /  /_\  \   /     \\__  \  /    \  \   __\\_  __ \/  _ \ /     \   /  \ /  \\__  \\_  __ \/  ___/ |
/    |    \ |  Y Y  \/ __ \|   |  \  |  |   |  | \(  <_> )  Y Y  \ /    Y    \/ __ \|  | \/\___ \ \|
\____|__  / |__|_|  (____  /___|  /  |__|   |__|   \____/|__|_|  / \____|__  (____  /__|  /____  >__
        \/        \/     \/     \/                             \/          \/     \/           \/ \/
```
