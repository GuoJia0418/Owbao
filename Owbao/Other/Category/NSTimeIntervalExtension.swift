//
//  NSTimeIntervalExtension.swift
//  Owbao
//
//  Created by lufeng on 16/2/1.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation
//处理时间戳
func TimeStampToStringTypeOne(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy.MM.dd"
    return format.string(from: date)
}
//返回timeStamp 前一天的日期类型String
func TimeStampToStringMinusOneDay(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy.MM.dd"
    return format.string(from: date.addingTimeInterval(-24 * 60 * 60))
}

func TimeStampToStringTypeTwo(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    
    let format = DateFormatter()
    
    //    format.timeZone = NSTimeZone(name: "shanghai")
    
    format.dateFormat = ("yyyy-MM-dd HH:mm:ss")
    return format.string(from: date)
}

func TimeStampToStringTypeThree(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy.MM.dd HH:mm"
    return format.string(from: date)
}

func TimeStampToStringTypeFour(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return format.string(from: date)
}
func TimeStampToStringTypeFive(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy.MM.dd"
    return format.string(from: date)
}
func TimeStampToStringTypeSix(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy.MM.dd HH:mm:ss"
    return format.string(from: date)
}
func TimeStampToString(_ timeStamp: TimeInterval, isHMS: Bool) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = (isHMS ? "yyyy-MM-dd hh:mm:ss": "yyyy-MM-dd")
    return format.string(from: date)
}

func TimeStampToStringTypeSuccess(_ timeStamp: TimeInterval) -> String{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return format.string(from: date)
}

func TimeStampToStringTypeNew(_ timeStamp: TimeInterval) -> String
{
    let date = Date(timeIntervalSince1970: (timeStamp/1000))
    let format = DateFormatter()
    format.dateFormat = "yyyy-MM-dd"
    return format.string(from: date)
}
