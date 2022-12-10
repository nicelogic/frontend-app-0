# app

[toc]

## principle

* flutter favorite package可以用, 其他能不用尽量不用

## Assets

The `assets` directory houses images, fonts, and any other files you want to
include with your application.

The `assets/images` directory contains [resolution-aware
images](https://flutter.dev/docs/development/ui/assets-and-images#resolution-aware).

## Localization

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.

To support additional languages, please visit the tutorial on
[Internationalizing Flutter
apps](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## project structure

* 每个微服务对应一个repository, model在repository中定义
* feature: 各个bloc
* screen: 每个单独的页面， 每个页面由多个widget组成
* 各个widget在widget里面管理（这么做的好处在于查看screen的时候脉络比较清晰）

## feature

### setting

* 本地默认配置文件，云配置文件。有云, 默认云配置文件
* 后续支持
* 你没办法做到始终用云。。下载是可能失败的