# app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application that follows the
[simple app state management
tutorial](https://flutter.dev/docs/development/data-and-backend/state-mgmt/simple).

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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