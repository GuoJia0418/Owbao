//
//  GlobalFunc.swift
//  Owbao
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

// MARK: - 全局函数
/// 延迟 delta 执行 block
func delay(_ delta: TimeInterval = 1.0, block: @escaping (()->())) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * delta)) / Double(NSEC_PER_SEC), execute: { () -> Void in
            
            // 执行 block
            block()
    })
}


