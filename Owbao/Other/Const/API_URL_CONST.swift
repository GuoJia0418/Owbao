//
//  API_URL_CONST.swift
//  Owbao
//
//  Created by lufeng on 16/2/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation


//正式
let BASE_URL = "https://m.jushengcaifu.com"
let PROTOCOL_URL = "https://www.jushengcaifu.com"

//测试环境
//let BASE_URL = "http://192.168.3.236:8080/awb_app"         //测试嗷呜
//let PROTOCOL_URL = "http://192.168.1.246"                  //协议总地址

//let BASE_URL = "http://192.168.1.120:8080"         //测试嗷呜
//let PROTOCOL_URL = "http://192.168.1.120"          //协议总地址

//let BASE_URL = "http://192.168.1.53:8888"          //李煜电脑
//let PROTOCOL_URL = "http://192.168.1.53"

//let BASE_URL = "http://m.jushengcaifu.com:8181"
//let PROTOCOL_URL = "https://www.jushengcaifu.com"

//let BASE_URL = "http://180.173.163.81:10000"          //测试存管的外网地址  本机ip + 10000端口号
//let PROTOCOL_URL = "http://192.168.1.246"

/********************************* .do的接口 ********************************/

/****************** 注册登录/相关接口 *****************/
let LOGIN_API                  = "/login/doLogin.dos"//用户登录 接口
let VERIFY_PHONE_EXISIT_API    = "/register/existMobilePhone.dos" //验证手机号是否存在
let GAIN_VERIFY_CODE_API       = "/register/sendAppRegMsg.dos"  //注册验证码短信 type: 1验证码 2 语音验证码
let REGISTER_API               = "/register/reg.dos"  //注册
let FIND_PASSWORD_API          = "/memberSetting/forgetPwdSmsCode.dos" //重置（忘记）登录密码 -> 发送短信验证码
let UPDATE_LOGIN_PASSWORD_API  = "/memberSetting/updateLoginPassWord.dos" //设置登录密码
let FORGET_PWD_VERIFY_CODE_API = "/memberSetting/sendForgetTpwdCode.dos"  //重置交易密码->发送短信验证码
let PIC_CODE_API               = "/login/validateCode.dos"       //获取图形验证码
/******************     首页    相关接口    *****************/
let Home_Api = "/index/index.dos"                         //首页
let NewHead_Api = "/index/isNewHead.dos"                  //接口文档没有  （此API没有用到）
let Renewal_Api = "/app/renewal.dos"                      //app更新，版本控制的
let NewHeadExpire_API = "/index/isNewHeadExpire.dos"      //用户首投

let UrgentNotice_Api = "/index/urgentNotice.dos"  //系统紧急公告 首页->获取列表->系统紧急公告

//平台公告
let System_UrgentNotice_Api  = "/system/urgentNotice.dos"

/******************     我要投资    相关接口    *****************/
let Investment_Api     = "/product/list.dos"   //产品列表
let OpenGoldEgg_Api    = "/activity/getRandomCouponByProductId.dos"  //砸金蛋  随机加息券


let ProductDetails_Api = "/product/detail.dos"//产品详情接口
let DetailsList_Api    = "/product/detail_info.dos"//产品的详细资料   产品投资记录/图片/审核项目
let Usable_Api         = "/activity/usable.dos"//获取可用红包
let ProductInvest_Api  = "/product/invest.dos"//产品投资接口
let Apponintment_Api   = "/product/getReservation.dos"//开始预约
let JSInvestDetailCoupon_Api = "/activity/getUsableCoupon.dos" //投资获取可用优惠券
let JSInvetProductActivity_APi = "/product/activityPrizeBanner.dos"    //产品列表banner

/****************** 我的信息相关接口    *****************/
let MyAccount_Api     = "/accountIndex/info.dos"//我的帐户接口
let MyInformation_Api = "/memberSetting/index.dos"//我的信息接口 -> 首页
let MyBankCard_Api    = "/memberSetting/myBankInfo.dos"//我的银行卡接口
let MyMessage_Api     = "/messageCenter/getMessage.dos"//我的站内信接口  （我的消息->获取信息列表）
let MemberSet_Api     = "/memberSetting/sendBankMsg.dos"//银行验证码 （信息认证 -> 发送验证码）
let MemberSetBank_Api = "/memberSetting/bankInfoVerify.dos"      //银行四要素和添加银行卡
let GetBankQuotaList_Api = "/recharge/getBankQuotaList.dos"      // 银行限额列表
let MyAssets_Api      = "/accountIndex/myFunds.dos"//我的资产接口
let MyAccumulatedIncome_Api = "/assetRecord/getAccumulatedIncome.dos" //累计收益接口
let JYPassWord_Api    = "/memberSetting/updateTpwdBySms.dos"//重置交易密码接口   （接口文档：设置交易密码）
let MyActivity_Api    = "/activity/index.dos"//我的红包接口
let MyAssetRecord_Api = "/assetRecord/index.dos"//我的明细接口
let MyInvitation_Api  = "/activity/myRecommend.dos"//我的邀请接口

let MyBackToRecord_Api = "/investCenter/repayInfoDetail.dos" //我的投资 - 投资回款记录
let MyAccountGetMoney_Api = "/assetRecord/getTheRewards.dos" //我的账户 - 马上领取
let GetActivityFriendAll_Api = "/activity/getActivityFriendConfigAll.dos"  //我的账户-》赚钱任务
let GetActivityAll_Api = "/activity/getAllActivity.dos"        //我的账户-》活动中心

let GetMoneyDidSelected_Api = "/inviteFriend"   //赚钱任务 - 》 cell点击
let OpenEggShare_Api = "/newcomer?wap=true&toFrom=zjdfxfx"  //砸金蛋 -》 分享

let GetPromoteRedCoupon_Api = "/member/getPromoteRedelivery.dos"  //点击红包和我要取现
let GetUse_Api = "/member/getUse.dos"                //立即变现
let ExperienceDetail =  "/product/experienceDetail.dos" //体验标详情
let ExperienceInvest = "/product/experienceInvest.dos"  //投资体验标

/******************     我的投资    相关接口    *****************/
let MyInvest_Api = "/investCenter/productList.dos" //我的投资接口 -> 投资记录
let GetAddress_Api = "/member/getReceiptAddress.dos" //获取收货地址、联系电话、姓名
let SaveAddress_Api = "/member/insertReceiptAddress.dos" //上传收获地址、联系电话、姓名

let InvestAppoinment_Api = "/activity/insertPrizeInfo.dos" //添加预约
let SelectProduct_Prize =   "/activity/selectProductPrize.dos" //查询产品绑定的奖品奖品

let MyInvest_GiftDetail_Api = "/investCenter/prizeInfo.dos"    //投即送 奖品详情
let MyInvest_PrizeDetail_Api = "/product/getMyLuckCodesAndStatus.dos"    //IPhone7 奖品详情
let JSGiveTelephoneFare_Api  = ""                               //APP2.0，投即送中充话费功能

/******************     充值提现    相关接口    *****************/
let Recharge_Api      = "/recharge/index.dos"//充值首页接口
let RechargeMsg_Api   = "/recharge/sendRechargeMsg.dos"//充值短信接口 (旧版)
let RechargeGo_Api    = "/recharge/goJYTPay.dos"//充值接口 （旧版）
let Withdrawals_Api   = "/withdrawals/index.dos"//提现首页接口
let WithdrawalsGo_Api = "/withdrawals/addWithdrawals.dos"//提现接口
let CreatePayOrder_Api = "/recharge/createPayOrder.dos"   //创建订单
let SendRechargeSms_Api = "/recharge/sendRechargeSms.dos"    //发送验证码
let GoPay = "/recharge/goPay.dos"        //认证充值

/******************     更多    相关接口    *****************/
let Feedback_Api = "/system/feedback.dos" //意见反馈接口


/******************     协议  相关接口    *****************/
let NewhandDetail_Api = "/XSXQ"     //新手标详情
let MoreSecurity_Api =  "/aqbz"     //更多安全保障
let NormalBiaoSecurity_Api = "/aqbzDetail"   //标的安全保障


let RegisterProtocol_Api = "/zc"   //注册协议
let LoanProtocol_Api = "/loan"     //借款协议

let ActivityDetail_Api = "/iPhone"         //iPhone活动标详情 -> web详情
let AuthenticationInformation_Api = "/pay"
/**********************     版本获取     *******************/
//版本获取
let GetVersion_Api = "/system/version.dos"

/**********************     广告启动页面     *******************/
let StartAdvertisement_Api =  "/index/startAdvertisement.dos"

/**********************     活动标接口     *******************/

//let GetMyLuckCodes = "/product/getMyLuckCodes.dos"   //活动页  我的幸运码
//let GetNewActivityProduct = "/product/getNewActivityProduct.dos" //产品详情

let  PrizePerson_Api = "/activity/getPrizeInfoByProductId.dos"    //查询中奖者
let  GetPrizeRecords_Api = "/activity/getMyPrizeRecords.dos"      //活动中心 - 中奖记录
let  LuckyMoney_Api = "/activity/luckyMoneyIndex.dos"                 //压岁钱主界面
let  GetLuckyMoney_Api = "/activity/getLuckyMoney.dos"                //领取压岁钱

/*****************  写死的接口     *********************/
let  JSBanner_Api = "888/app/getIndexBanner.dos"

/*******************   (接口文档有)  ***********************/
//4.8.2 权益转让及受让协议
let AgreeMent_Api = "/agreement/product.dos"
// 4.9.2 消息标记为已读
let UpdateUnReadMsg_Api = "/messageCenter/updateUnReadMsg.dos"
// 4.9.3 删除消息
let DelMsg_Api = "/messageCenter/delMsg.dos"

// 4.13.1 自动投标个人设置
let AutoInvest_Conf_Api  = "/autoInvest/autoInvestConf.dos"
// 4.13.2  修改自动投标设置
let AutoInvest_UpdateConf_Api = "/autoInvest/updateAutoInvestConf.dos"

//好友信息邀请
let Invited_api = "/activity/myInvitation.dos"
//新闻动态
let PublicNotice_api = "/aboutus/newsInformationList.dos"

/******************* 新手标续投接口  ***********************/
//领取现金金额接口
let GetContinueReward_Api = "/product/getContinueReward.dos"
//续投接口
let AddContinueReward_Api = "/product/addContinueReward.dos"
//投即送
let GetOpenRedCoupon_Api = "/member/getOpenRed.dos"
/*********************** 双旦活动 tabbar ***********************/
let IsInDoubleEggActivity_APi = "/activity/isInDoubleEggActivity.dos"

//************************ 开放日 接口 **************************//
let ActList = "/actList"
let Openday_Url = "/openday"                                 //开放日活动详情
let Enroll_Api           = "/activity/SignUp.dos"            //在线预约接口
let EnrollGetPicture_Api = "/activity/getOpenDayDetail.dos"   //在线预约获取图片接口

//************************ 三重好礼活动接口 **************************//
let InviteFriendTri_Api =  "/inviteFriendTri"

//**************** 新版我的邀请 ****************//
let JSNewInvited_Api = "/activity/firstInvestList.dos"

// 1.2.4新加接口
let LastLogin_Api = "/login/lastLogin.dos"     //最后登录时间更新

/*********************** 系统维护 ***********************/
let XTWH_Api = "/template/pages/maintenance.html"
let Set_Push_RegistrationId = "/app/setPushRegistrationId.dos"    //app推送,设置对象
//体验金使用规则
let ExperienceRule = "/GGXQ?artiId=75"

/********************* 翻翻乐 *************************/
let FlopShare_Api = "/activity/flopShare.dos"

//银行卡限额接口
let BankLimitAmount_Api = "/CP080"

/*********************** 关于我们 ***********************/
//走进嗷呜
let GSJS = "/GSJS"
//历程回顾
let LCHG = "/LCHG"
//股东介绍
let GDJS = "/GDJS"
//管理团队
let GLTD = "/GLTD"
//公司资质
let GSZZ = "/GSZZ"
//一亿验资
let YYYZ = "/YYYZ"
//网站公告,需要加上afid
let GGXQ = "/GGXQ"
//一亿验资
let YanZi_Api = "/YYYZ"
//公司概况//媒体报道
let CompanySituation_Api = "/GYWM"
//媒体报道详情
let Report = "/GGXQ"

/************************ 存管账户 ****************************/

//开通存管 uid&phone&token&channel&version
//其他 uid&token&channel&version

//开户
let CustodyOpenAccount = "/setDepository"

//存管提现
let CustodyWithdrawal = "/appGetcash"

//充值
let CustodyRecharge = "/recharge"

//存管账户信息
let CustodyAccountInformation = "/myDepository"

//线下活动接口
let OfflineActivity_Api = "/activity/offlineActivityList.dos"

//存管提现form表单形式
let GetCash_Api =  "/withdrawals/depositsWithdrawals.dos"

//开户直连
let OpenAccount_Api = "/member/openAccount.dos"

//富友获取充值验证码直连
let RchargeVerification_Api = "/recharge/fuiouSendSms.dos"

//富友充值直连
let Rcharge_Api = "/recharge/fuiouFastRecharg.dos"

//安全中心 -> 存管账户:重置交易密码
let ResetFuiouTradePwd_Api = "/memberSetting/fuiouUpdatePwd.dos"

let FuiouProtect = "/storage"  //富友协议地址



