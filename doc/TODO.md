
# TODO

##  feature(release v1)

* auth 设计
* user be ready(merge contacts service to user), design how user data client and server sync(support multi client)
  design contact list sync mechinenism
  design pubsub service是否还需要
* build a db migrate mechinenism(db design is unreliable) 
  * rename account db & account collection to user
  * some user's name in info, extract to name field
  * move user contacts to contacts collection
* update user micro service and use access token
* update auth service and support refresh access token 
* upate  contacts service to use access token
* client support refresh token
* client use contacts repository
* client support cache
* message service optimize
* client support new message repository
* upgrade client & server graphql list search -> pagination then use paginatin widget
	* contacts
	* new friend request
	* search contacts
	* chat
	* message
* full feature cache mechanism(use graphql cache mechanism & hydrate bloc)
* optimize
  * pubsub->add_contact_bloc relationship should more clear and repository stream reduce
  * rename contact->contacts
  * rename account->user
  * rename accountBloc->userBloc
* bug
	* think how to refresh cached user avatar
* remove contact(the contact who silent removed u too)
* remove chat(u only)
* has a default contact(app assistant,every user has special one that belong to one)
* new chat feature
	* support emoji
	* support send picture, video, gif
	* support unread message badge
	* support navigate to first unread message
	* support send voice record and video record
* video
	* adjust video part bloc archtecture
	* video chat notification
	* support p2p video turn service
        * use local mediasoup service
* other feature
  * login use phone(login solution)
  * international
* safe
        * all service graphql use jwt
	* ferry token刷新机制(暂时时间放长，但是需要token失效情况，重新登陆机制) * access_token授权机制，包含权限 * token refresh问题(搞清楚auth+account联系, 失败之后要功能感知到，并且能够重新登陆)
* log
	* use new log mechianism
	* efk  
* server side problem
  * mongo service重启，其他service如何获取到其ip
  * account & auth code optimize

## v2 feature

* understand fragment in graphql(each view has a little fragment and large viem group frament)
	so repository support detail method, only get all needed data
* web cdn & web white page
* register a compamy
* only support wechat login
* full feature system notificatin(fcm(web+ios+need foreign to send fcm, this solution not consider) + android(mipush+huawei push + oppo push + vivo push + meizu psuh)=>use mixpush push)
* ios, web support 
* big surface support
* appTheme(important, can quicky produce a new production)
* firebase anylics
* ab/test, cloud config

## v3 feature

* tinker集成(bugly坑太多,而且非谷歌官方推荐,目前没有这个技术实力去驾驭)(官方维护及文档也不够达到使用的程度)
* 根源上还是android不支持google play，fuchsia迟迟未来，尴尬的时间段
* 版本信息（全量+增量）显示


## back

* project optimize
	* me project: resume
	* company project: company home page
	* base project: base project
		* backend service 应该整合到一个namespace中去(一个app一个namespace), service git作为基准目录。所有新项目始于此
			其代表了最先进最优秀的综合全能架构
			各个新项目基于此，增删代码来实现
* auth backend重构
	* 支持用户名+密码
	* 支持微信，qq...
	* 后续可以随时支持邮箱登陆，人脸识别登陆，手机号码短信登陆，手机号码一键登录

* graphql
	* 学习code first
	* fragment使用及view从facebook借鉴下。如何做到每个view一个graphql
	* graphql cache使用

## be

* 