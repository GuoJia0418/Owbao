//
//  UIViewController+Extension.swift
//  Owbao
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

extension UIViewController {
    fileprivate struct AssociatedKeys {
        static var lastViewControllerKey = "lastViewControllerKey"

    }
    var lastViewController: UIViewController? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.lastViewControllerKey) as? UIViewController
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.lastViewControllerKey, newValue as UIViewController?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
 
}
