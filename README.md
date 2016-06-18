# 百度地图 Demo


## 一、环境设置

1.开发环境：Xocode 7.3.1

2.模拟器环境：iOS 9.3

3.百度地图 SDK：2.10.0

**可以直接去 [百度地图API 首页](http://lbsyun.baidu.com/index.php?title=iossdk/sdkiosdev-download) 下载**

![百度地图 API](百度地图API.png)

我这里选择的是全部下载，没有选择 BitCode 版。

> 注：
> bitcode 是 xcode 7 之后新增的配置选项，默认为 `YES`，我们提交程序到 App store 上时，Xcode 会将程序编译为一个中间表现形式(bitcode)。然后 App store 会再将这个 bitcode 编译为可执行的 64 位或 32 位程序。

在这个 Demo 里不需要使用 bitcode 功能，所以设置为了 `NO`。

![bitcode设置为NO](bitcode.png)

4.iOS 9 之后不能直接使用 HTTP 进行请求，需要在 Info.plist 新增一段用于控制 ATS 的配置：

```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```
也即：
![ATS配置](ATS.png)

配置完后就可以使用 HTTP 了。

5.导入百度地图 SDK

百度地图提供了两种导入方式，可以直接把 SDK 拖入到工程，也可以使用 CocoaPods ，这里我是用后面一种方式导入百度地图 SDK。具体配置开发环境可以看 [配置开发环境](http://lbsyun.baidu.com/index.php?title=iossdk/guide/buildproject)

![pod_install.png](pod_install.png)


## 二、










