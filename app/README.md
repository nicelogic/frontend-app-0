# app

[toc]

## todo

* server need support federation to support get contacts avatar url without too much effort
* restorationId 改造
* settings controller -> bloc优化
* l10n，当前都写死为英文字符串，后续所有功能都好了之后，全面进行改造
* local config & net config 方案全面设计，当前只使用local config
* flutter native splash
* poc: graphql server & client support apq to save bandwidth(low priority)

## cmd

flutter pub run build_runner build

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
* screen: 每个单独的页面， 每个页面由多个widget组成. widget不单独抽出来，影响screen目录
* 通用的(两个及以上screen需要)widget在widget里面管理（这么做的好处在于查看screen的时候脉络比较清晰）

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

另外：refresh token, 每4个小时（默认）才会发送给server, 攻击者要等那么长时间去获取到破解
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




## general state management mechanism

* the cache level in the hydrated bloc
  * means: graphql only use network function, no cache function
* only auth hydrated bloc not lazy, other bloc is lazy load
	* user see which screen that need the bloc, that bloc then load data
* a hydrated bloc load too large data, that bloc need just load a little data
  * need to customize load data mechanism
  * or to split a bloc to many bloc
* Generally speaking, one bloc has its exclusive repository. if many bloc want use a repository's state, there should a top level bloc to support common state, such as auth bloc
* me bloc is only needed in me screen, me->my profile screen, all screen just take it's needed bloc(every time load data and update date by hydrated bloc)
* there is a problem: if auth fail, closed hydrated bloc can't clear their state
but can do state clear in fromJson. after load State,check state whether belong to current user
* no select graphql cache mechanism, all query policy set nocache
	why: 
		* graphql cache more complex
		* graphql need consider "__typename,id" related api design
		* hydrate make screen own right data faster(hydrated bloc's init data) then get graphql cache, then emit state to bloc


* 一个页面可以取 n * feature bloc 去构建自己的数据
  * feature bloc的粒度尽量小, 这样各个页面需要取的数据就会尽量少
  * 该页面bloc理论上只获取该页面所需数据
  * 该页面每次进入刷新一次数据(通过远程，而非本地。这样其他多终端可刷新页面同步数据)（通过bloc transformer, debounce来屏蔽不需要的多次连续刷新）
* 每个页面的bloc, 不再监听auth bloc unauth 的状态。只在启动的时候判断是否userid相同。这样做的好处在于如果还是之前的user.则状态仍旧保存着
  不会丢失. 每个bloc event也不再需要unauth的event. repositorysCubit负责管理更新所有repository的access token
  每个Bloc/cubit如果api调用失败当前不会触发状态变成unauth. 
  TODO: 刷新失败也不会重试（此处因为其他原因导致的刷新失败，应该触发每分钟刷新一次）(真机断网启动，1分钟去刷新一次，而后重连网络,一旦刷新成功，取消定时器)
  bloc observer出现token invalid/token expired不需要变更状态为unauth。因为启动的时候会检测到refresh token是否过期从而退到登录状态
        其他原因不必到登录状态。4小时到了，刷新失败情况，就不让用api. 推到登录页面也没用。此时就是刷新不到token。
  而长期不用的情况才需要退到登录状态。启动的时候检测足矣。不必每个api都去判断一下.启动若能刷新到token,后面4小时到之前，3小时就开始刷了。刷不到token你退出去也
  登录不了了，用不了。还不如就是用户界面。可以看离线的消息。也就是用户TOken invalid/过期只影响他使用app新服务器功能。离线消息还是可以浏览。
  长时间不用的情况，登录的时候检测，退出到登录界面

### pagination

潜在问题： 当前server page fetch依赖的是cached page next page cursor,应该要依赖previous server page's next page cursor
当前解决方案： 每一页挺大的。。这样，下一页要刷的时候，上一页已经更新了server page
增加异常处理： 遇到上一页server page未fetch 情况， 有个定时器处理这种情况,直到上一页获取到为止
上一页获取异常，则也会不断重新去获取.这样只要有异常，就会不断获取每一页数据

1. 刷新的任务在于刷新cached和ui
2. 只有滑动到具体页面才需要刷新
3. 肯定是现刷到前面的页面才会到后面的页面

这样可以搞个刷新队列: await for(只能是await for,不可以是stream listen)，按照顺序处理刷新事件
关于异常：
如果前面的事件失败了。需要感知到
只要失败了，后续处理都失败
每次刷新获取的时候，重制失败错误码

一个重要的知识点： （await for vs stream listen)
A more imporant difference is that await for serializes the consumption of the stream items while listen will process them concurrently.



needn't: load cached page..if page size not equal to cached page size. adjust cached page to new page size(low priority)
will auto frefresh by refresh pag

## s3 and logic

upload asset use s3 repository
then url set to logic db
s3 asset path, control by s3 dir design
every user has user special key
app-0 only use app-0 bucket

app-0 bucket
	- users
    	- user-0
        	- avatar
				- avatar.png

follow: https://aws.amazon.com/cn/blogs/compute/uploading-to-amazon-s3-directly-from-a-web-or-mobile-application/
then user info contain the asset's url 

## image

https://developer.android.com/training/multiscreen/screendensities

## android special modify

frontend-app-0/app/android/app/src/main/AndroidManifest.xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.app">
   <application
   ###加了这一块，package:   image_cropper: ^3.0.1
           <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
    </application>
	###
</manifest>

## web special modify

frontend-app-0/app/web/index.html
<head>

   ###加了这一块，package:   image_cropper: ^3.0.1
  <!-- Croppie -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.css" />
  <script defer src="https://cdnjs.cloudflare.com/ajax/libs/exif-js/2.3.0/exif.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/croppie/2.6.5/croppie.min.js"></script>

</head>

## packages alternative

https://pub.dev/packages/search_choices
