***20250426由于固件太大，所以放于云盘，地址为：https://www.123865.com/s/9JnLTd-boTHd   提取码:Nimm***

**T760（U20-F50）系列终结5G竞赛——RAX3000M开启飞猫U20轻NAS挂载详细教程**

软件版本号：RAX3000M-MTK.ZD.01

非常感谢大家支持，让RAX3000Me教程成功突破10w浏览量！下面直接进入实操教程！

一、准备工作

1. 建议使用Ubuntu虚拟机，确保OpenSSL版本大于3.0，支持aes-256-cbc -pbkdf2。

2. 下载所需文件，链接：https://github.com/Daniel-Hwang/RAX3000Me ，进入20250426-RAX3000M-suc目录。

二、配置文件导出与导入

1. 导出并修改配置文件

- 导出配置文件后，使用Linux终端解压配置文件：
```
openssl aes-256-cbc -d -pbkdf2 -k '$CmDc#RaX30O0M@\!$' -in cfg_export_config_file.conf -out - | tar -zxvf -
```
- 修改`etc/config/dropbear`中`option enable '0'`为`1`。
- 修改`etc/shadow`，删除第一行首个冒号至第二个冒号之间的内容。
- 打包新的配置文件：
```
tar -zcvf - etc | openssl aes-256-cbc -pbkdf2 -k '$CmDc#RaX30O0M@\!$' -out cfg_export_config_file_new.conf
```

2. 配置文件导入

- 下载我提供的配置文件或使用自己打包的新配置文件，上传到路由器后台导入配置，重启后即可开启SSH。

三、SSH更新Uboot

- 使用网线连接路由器LAN口，SSH登录路由器（默认IP：192.168.10.1，无密码）。
- 在Windows系统中使用`HTTP_File_Server.exe`（Win8兼容模式），加入`mt7981_cmcc_rax3000m-fip-fixed-parts.bin`，并开启HTTP服务。
- SSH终端执行：
```
wget -P /tmp http://192.168.10.2/mt7981_cmcc_rax3000m-fip-fixed-parts.bin
mtd write /tmp/mt7981_cmcc_rax3000m-fip-fixed-parts.bin FIP
```

路由器IP变为192.168.1.x段后，开始刷入OpenWrt固件。

四、刷入OpenWrt固件

- 电脑IP设置为192.168.1.2，子网掩码255.255.255.0，网关192.168.1.1。
- 浏览器进入192.168.1.1，刷入`20250425-mt7981-cmcc_rax3000m-squashfs-factory-HY.bin`固件，重启。
- 电脑改为自动获取IP，浏览器访问192.168.5.1，继续升级为`20250425-mt7981-cmcc_rax3000m-squashfs-sysupgrade-HY.bin`固件。

五、固件功能特色

- 默认管理界面：http://192.168.5.1（用户名：root，无密码）
- 支持NAS模式、Docker、VPN、DDNS、广告过滤、下载管理、微信推送、内网穿透、链路聚合、iStore商店等丰富功能。
- 自动加载外置USB硬盘，支持NTFS，手机USB网络共享（RNDIS），支持多种4G/5G设备。
- DIY主题支持，界面美化自由度高。

本固件已全面支持飞猫U20、中兴F50等主流5G设备，轻松实现5G速度全开体验！快去尽情享受OpenWrt带来的乐趣吧！


20250426-支持向导模式
20250426-RAX3000M版固件-NAS模式页面更新
20250426-RAX3000M版固件-支持软件源
20250426-RAX3000M版固件网络连接
20250426-RAX3000M版固件网络连接OpenWRT首页
20250426-RAX3000M版固件-支持passwall、滤广告等
20250426-RAX3000M版固件-多界面更新
