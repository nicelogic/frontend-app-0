
# niceice app design

[toc]

## think_area

目录结构改造完成
后续需要不断思考和调整，目标是目录结构清晰，并且具备一致性
再次通读bloc的概念部分文档。还有就是需要思考，我到底需要做什么
然后再去寻找demo进行对比学习
niceice是一个综合不断扩大的项目
通用的平台app,包罗万象，就是我的世界
啥功能都有的一个app 是自我的一个项目
而面向市场的项目是根据外部的需要，推出的
niceice是我的项目的全部需要
其他app是用户的真正需要
用户需要什么我就做什么
niceice是所有的功能平台

## app定位

所有功能的集合: 聊天，视频会议，等等
所以我要先做一个聊天功能
然后视频会议

## 功能

## principle

* 遵循最简原则

## 目录组织架构

```puml

@startmindmap
!include E:\niceice\knowledge\tool\markdown\my.iuml

* lib
** main.dart
** common
*** common.dart
*** util.dart
*** material.dart,flutter_bloc.dart...
*** theme.dart
*** constant.dart
** components
*** connect_server
**** bloc
*** account
**** bloc
*** navigator
**** bloc
*** personal_info
**** bloc
*** address_book
**** bloc

@endmindmap
```

## 启动页面

启动页面 = 大屏master + slave, 小屏则是： 导航页面
暂时都一样的，后续再做优化调整

## 待优化

* niceice.cn改成可配置的服务器url地址 k8s configmap
