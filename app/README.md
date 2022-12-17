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

### token机制

采用refresh token + access token机制
authentication之后， 颁发refresh token(default ttl: 90 days), access token(default ttl: 2 hours)
app启动之后，定时通过refresh token刷新access token, access token过期之后，通过refresh token刷新access token
如果连refresh token也过期，则跳转到登录页
app状态authticated = refresh token valid
每次使用refresh token刷新access token的时候，refresh token的生命周期也会得到刷新,同时返回新的refresh token(标准： refresh token rotation)
(当以前使用的刷新令牌发送到授权服务器时，最近颁发的刷新令牌立即失效至关重要。这可以防止使用同一令牌系列中的任何刷新令牌来获取新的访问令牌.
使用refresh token rotation, 则refresh token可以存储在client)
(因此，不再拥有长期存在的刷新令牌，如果该令牌遭到破坏，可能会提供对资源的非法访问。随着刷新令牌不断交换和失效，威胁降低了。)
(令牌轮换机制中，如果攻击者使用之前的refresh token访问，则不仅之前的refresh token失效，最新颁发的refresh token也失效.因为可能是攻击者
先使用了泄露的refresh token去更新refresh token,则合法用户后使用的refresh token会被认为是非法的，但其实是合法的。让最新颁发的也失效，则攻击者
也必须重新登录.而合法用户也必须登录。但是这仅仅发生在发生了攻击的行为时刻。正常使用的用户是不受影响的)
这样比如90天内没用app了，则直接跳到登录页.在此期间有用到,则可以一直不需要登录
使用了refresh token rotation, 则refresh token , access token相当于都是短期的token了
但是因为refresh token每次颁发的时间都比较长，则app长时间不用的情况，也还是可以用refresh token去刷新refresh token + access token
那为什么不直接使用refresh token呢。。因为access token更可能泄漏。每次api都带。而refresh token只在定期刷新reresh token + access token的时候
暴露.相当于加了一层保护

但是refresh token rotation似乎是因为spa(single page web app)无法安全存储refresh token才需要的
而且如果用户长时间不登录，攻击者还是可以任意使用refresh token(长时间的refresh token当然也没有办法处理这种情况)
rotation增加了安全性,特别是web. app中可以安全保护refresh token

但是从接口设计上来讲，refreshToken 每次还是会返回 access token + refresh token
这样，refresh token本身也是需要刷新生命周期的，使用新的refresh token,不需要去存储
refresh token过期时间长，所以可以用户长时间不登录，也可以继续使用app无需登录
access token用于访问资源。被窃取了，因为时间短也不怕。
refresh token 默认acesss token过期前去刷新一次。攻击者要等这段时间。而且refresh token 在client - auth service之间的安全性可以调非常高
所以可以非常安全。而access token和资源服务器之间的安全性就仅仅jwt级别。平衡了安全和性能和简单性
目前市面上基本也基于access token, refresh token去做auth
access token访问各个service这个层面是不变的
过期了要用refresh token去刷新。auth bloc也应该定期刷新access token,避免过期了再去访问。让api速度不变因为access token过期而变慢
当然考虑到网络情况，还是需要考虑access token过期的情况，要能触发刷新access token, refresh token
refresh每次使用都刷新过期时间，可以保证活跃用户一直可以使用app,不必登录
市面上微信之类都是这种做法

当前暂不支持rotation检测。所有未过期的refresh token还是可以继续刷新refresh token + access token
理论上，新颁发了refresh token之后，后续只能使用这个refresh token来获取refresh token + access token
优先级不高。安全要做得好，无上限的。保持接口稳定即可。后续需要再支持rotation检测

#### 为什么使用access token + refresh机制

因为acess token在使用过程中，可能被捕获
如果acess token时间非常长，则有风险
短时间被截获，只能短时间使用
关键是refresh token不能被截获(但完全也有可能)
但是有一点区别在于： refresh token需要不断去auth service刷新，交互
那么就可以在auth service上控制某个用户，不让他使用服务
所以需要使用refresh token, access token机制
通过定时交互的方式去强制更新授权
要不然一个用户拿到acess token之后，服务端都限制不了他了
之前在上个公司的时候就遇到这种情况，一个终端逻辑出问题了，发现这个用户，但是没机制让他登出

我们可以通过一些方法检测到攻击者，然后通过refresh token撤掉的方式，让攻击者无权使用
关于这点，就不是安全范畴的事情了，而是app政治范畴了

另外：refresh token, 每2个小时（默认）才会发送给server, 攻击者要等那么长时间去获取到破解
而如果是长期的access token的机制，则每个请求都会带有access token
(虽然使用了https，可以保证很难被破解)
但是这样让安全性更高了

oauth0.com:
	刷新令牌可以帮助您平衡安全性和可用性.由于刷新令牌通常寿命较长，因此您可以在较短寿命的访问令牌过期后使用它们来请求新的访问令牌。
	刷新令牌轮换保证每次应用程序交换刷新令牌以获取新的访问令牌时，也会返回一个新的刷新令牌。因此，您不再拥有长期存在的刷新令牌，如果它遭到破坏，它可能会提供对资源的非法访问。随着刷新令牌不断交换和失效，非法访问的威胁减少了。





### setting

* 本地默认配置文件，云配置文件。有云, 默认云配置文件
* 后续支持
* 你没办法做到始终用云。。下载是可能失败的

## todo

* restorationId 改造
* settings controller -> bloc优化

## cmd

flutter pub run build_runner build

## general state management mechanism

* the cache level in the hydrated bloc
  * means: graphql only use network function, no cache function
* only auth hydrated bloc not lazy, other bloc is lazy load
	* user see which screen that need the bloc, that bloc then load data
* a hydrated bloc load too large data, that bloc need just load a little data
  * need to customize load data mechanism
  * or to split a bloc to many bloc
* Generally speaking, one bloc has its exclusive repository. if many bloc want use a repository's state, there should a top level bloc to support common state, such as auth bloc
