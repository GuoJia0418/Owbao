//
//  SIZE_CONST.swift
//  Owbao
//
//  Created by lufeng on 16/2/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
//#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]

// 适配的比例
let PHONE_SCALE_X =  ((SCREEN_WIDTH > 667) ? (1.0) : (SCREEN_WIDTH / 375))
let PHONE_SCALE_Y = ((SCREEN_HEIGHT > 667) ? (1.0) : (SCREEN_HEIGHT / 667))

let SHARE_TITLE = "亲，国资控股平台嗷呜宝给新人送礼啦，来就送10万体验金+666元现金红包！"
let SHARE_TITLE1 = "知道你又败家了，送你10万体验金+666元红包，拿走不谢！"
let SHARE_TITLE3  = "鸡冻！这个年纪居然领到了5888元压岁钱，无关年龄，是“宝宝”的都快来领!"

//投即送分享标题
let SHARE_TITLE4 =  "不花钱也能消费，爆款好礼免费送！"
let SHARE_DESCRIPTION4 = "智慧投资，0元消费~ "
let SHARE_ICON_URL4 = "https://www.jushengcaifu.com/images/app/toujisong_fenxiang.jpg"

let SHARE_TITLE5 = "撸起袖子加油赚，想财富自由先来领第一桶金！"

//邀请好友三重礼
let SHARE_TITLE2  = "撸起袖子加油赚，想财富自由先来领第一桶金！"
let SHARE_DESCRIPTION2 = "送10万元体验金、666元红包、1.2倍翻倍券等新手大礼包!"
let SHARE_ICON_URL = "https://www.jushengcaifu.com/images/newbie.png"

//翻翻乐
let SHARE_TITLE_LOTTERY  = "翻出一个亿，我们不做平凡人！"
let SHARE_DESCRIPTION_LOTTERY = "送福利！点击即可参与幸运翻翻乐，红包、加息券等大奖等你拿！"
let SHARE_ICON_URL_LOTTERY = "https://www.jushengcaifu.com/images/app2lottery.png"

//IPhone7活动标的分享
let SHARE_IPHONE_TITLE  = "你换iPhone7我买单！"
let SHARE_IPHONE_DESCRIPTION = "惊“红”不止一瞥，红色特别版现已加入"
let SHARE_IPHONE_ICON_URL = "https://www.jushengcaifu.com/images/ip7.png"

//端午节分享
let SHARE_DragonBoatFestival_TITLE  = "前所未有的端午高息福利"
let SHARE_DragonBoatFestival_DESCRIPTION = "调好闹钟充足电，限时秒杀，疯狂开抢！"
let SHARE_DragonBoatFestival_ICON_URL = "https://www.jushengcaifu.com/images/dragonboat.jpg"

let W320_PHONE_SCALE_Y: CGFloat = 568.0 / 667.0
let PHONE_FIT_W = SCREEN_WIDTH / 320
let PHONE_FIT_H = SCREEN_HEIGHT / 568

//适配比例
let SCREEN_SCALE_W = UIScreen.main.bounds.size.width / 320

//#define iphone4x_3_5 ([UIScreen mainScreen].bounds.size.height==480.0f)
//
//#define iphone5x_4_0 ([UIScreen mainScreen].bounds.size.height==568.0f)
//
//#define iphone6_4_7 ([UIScreen mainScreen].bounds.size.height==667.0f)
//
//#define iphone6Plus_5_5 ([UIScreen mainScreen].bounds.size.height==736.0f || [UIScreen mainScreen].bounds.size.height==414.0f)

let IS_IPHONE4 = (SCREEN_HEIGHT == 480)
let IS_IPHONE5 = (SCREEN_HEIGHT == 568)
let IS_IPHONE6 = (SCREEN_HEIGHT == 667)
let IS_IPHONE6_PLUS = (SCREEN_HEIGHT == 736) || (SCREEN_HEIGHT == 414)

// 判断当前是否是 iphone 4 4s
let IS_PHONE_4 = (SCREEN_HEIGHT == 480)
// 判断设备 是否是 iphone 5s 5 4 4s
let IS_PHONE_WIDTH_320 = (SCREEN_WIDTH == 320)

let FONT_SIZE_22 = UIFont.systemFont(ofSize: 22)

let FONT_SIZE_20 = UIFont.systemFont(ofSize: 20)

let FONT_SIZE_18 = UIFont.systemFont(ofSize: 18)

let FONT_SIZE_16 = UIFont.systemFont(ofSize: 16)

let FONT_SIZE_14 = UIFont.systemFont(ofSize: 14)

let FONT_SIZE_12 = UIFont.systemFont(ofSize: 12)

func UIColorFromRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1)
}
func ColorFromRGBA(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha:CGFloat) -> UIColor {
    return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
}

let DEFAULT_GRAYCOLOR = UIColorFromRGB(240, green: 240, blue: 240)
let BORDER_GRAYCOLOR = UIColorFromRGB(210, green: 210, blue: 210)
let TITLE_GRAYCOLOR = UIColorFromRGB(180, green: 180, blue:180)
let DEFAULT_ORANGECOLOR = UIColorFromRGB(223, green: 41, blue: 40)
let DEFAULT_DARKGRAYCOLOR = UIColorFromRGB(122, green: 122, blue: 122)
let DEFAULT_NOTICECOLOR = UIColorFromRGB(243, green: 233, blue: 221)       //公告栏的颜色

let DEFAULT_BGCOLOR = UIColorFromRGB(241, green: 241, blue: 241)           //APP整体灰色背景
let VERTICALLINE_BGCOLOR = UIColorFromRGB(150, green: 150, blue: 150)      //理财列表页竖线背景色
let DEFAULT_TRACKCOLOR = UIColorFromRGB(235, green: 235, blue: 235)        //圆圈进度条背景色
let DEFAULT_PROGRESSCOLOR = UIColorFromRGB(229, green: 143, blue: 138)     //进度条颜色
let DEFAULT_REDCOLOR = UIColorFromRGB(236, green: 91, blue: 89)          //APP全局红色
let DEFAULT_CELLCOLOR = UIColorFromRGB(230, green: 230, blue: 230)          //优惠券背景颜色

let DEFAULT_PWD_GRAYCOLOR = UIColorFromRGB(200, green: 200, blue: 200)      //交易密码灰色背景
let DEFAULT_PWD_REDCOLOR = UIColorFromRGB(238, green: 132, blue: 128)      //交易密码红色背景

//圆圈进度条
let DEFAULT_PROCOLOR = UIColorFromRGB(235, green: 235, blue: 235)  //底部圈颜色
let DEFAULT_TRACK = UIColorFromRGB(240, green: 153, blue: 147)      //进度条

//红色背景
let JS_REDCOLOR = UIColorFromRGB(236, green: 92, blue: 89)

//投资列表
//333333
let Default_All3_Color = UIColorFromRGB(51, green: 51, blue: 51)
//666666
let Default_All6_Color = UIColorFromRGB(102, green: 102, blue: 102)
//999999
let Default_All9_Color = UIColorFromRGB(153, green: 153, blue: 153)
//d6d6d6
let Default_D6_Color = UIColorFromRGB(214, green: 214, blue: 214)      //进度条灰色
//ff9593
let Default_FF9593_Color = UIColorFromRGB(255, green: 149, blue: 147)  //进度条底部红色
//f18583
let Default_Rate_Color = UIColorFromRGB(241, green: 133, blue: 131)     //列表收益  结束状态
//8c8c8c
let Default_Deadline_Color = UIColorFromRGB(140, green: 140, blue: 140)   //列表期限  结束状态

//APP2.0 TabBar选中的文字颜色
let Default_TabBar_Title_Color = UIColorFromRGB(185, green: 68, blue: 60)

//弹窗的背景视图背景颜色
let PopView_BackgroundColor = UIColor(red: 1.0 / 255.0, green: 1.0 / 255.0, blue: 1.0 / 255.0, alpha: 0.4)


//全局黄色
let Global_yellow_light = UIColor(hexString: "FFe600")!
let Global_yellow_deep = UIColor(hexString: "FFC800")!
let Global_red = UIColor(hexString: "ff6400")!

