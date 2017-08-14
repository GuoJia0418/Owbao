//
//  JSBaseViewModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/27.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit
import Alamofire
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class JSBaseViewModel: NSObject {
    
    var isPresentLoginController: Bool = true //默认是弹出登录控制器的
    var dataModel: JSBaseModel?               //从服务器获取的数据
    
    /**
     * 带有预处理controller下载数据方法（例如：初次下载视图才会有蒙版、显示错误信息、出现错误视图等、只处理9998，9999系统错误其余需要自己处理），只有模型成功转换才会调用callback回调
     *
     * @param requestApi 请求的api对象
     *
     * @param controller 需要进行预处理的controller
     *
     * @param modelName  待转换的模型名称,待转换的模型需要继承自JSBaseModel(转换模型使用YYModel，若遇到多层数据需要完成一个函数modelContainerPropertyGenericClass)
     */
    func startLoadingData(_ requestApi: BaseApi?,
                          controller: BaseViewController?,
                          modelName: String,
                          callback: ((_ returnValue: JSBaseModel) -> ())?,
                          errorCallback: ((_ errorCode: AnyObject) -> ())?) -> () {
        
        //第一次请求服务器加载的loading界面
        if controller != nil && controller?.loadingCount == 0 {
//            controller?.loadFirstLoadingView()
        }
        
        //开始请求数据
        self.requestServer(requestApi, modelName: modelName, callback: { (returnValue) in
            
            controller?.view.hideHud() //隐藏HUD
            
            //初次请求数据加载的loading界面
            if controller != nil {
                controller?.loadingCount += 1
//                controller?.hideFristLoadingView()
                controller?.hideErrorView()
            }
            
            //回调处理数据
            if callback != nil {
                callback!(returnValue)
            }
            
            if returnValue.success == false { //预处理控制器
                
                if returnValue.errorCode == "9998" {
                    
                    if controller != nil  {
                        //弹出登录控制器
                        if self.isPresentLoginController {
                            JSLoginViewController.presentLoginControllerDismissGoHomeType(controller!)
                        }
                    }
                } else if returnValue.errorCode == "9999" {
                    
                    if controller != nil  {
                        controller?.view.showTextHud("系统错误")
                    }
                }
            }
            
            }) { (errorMsg) in
                
                controller?.view.hideHud() //隐藏HUD
                
                //第一次请求服务器加载的loading界面并出现下载失败处理
                if controller != nil {
                    
                    if controller?.loadingCount == 0 {
                        
                        if errorMsg == "" { //错误消息为空
                            controller?.loadDataError()
                        } else {//错误消息不为空
                            controller?.loadDataErrorWithErrorString(errorMsg)
                        }
                    }
                    
                    controller?.loadingCount += 1 //增加控制器请求服务器次数
//                    controller?.hideFristLoadingView()
                }
                
                //处理错误的请求
                if errorCallback != nil {
                    errorCallback!(errorMsg as AnyObject)
                }
        }
    }
    
    /**
     * 只请求服务器并转化模型（这个方法适合自己处理返回数据）
     *
     * @param requestApi 请求的api对象
     *
     *
     * @param   modelName    待转换的模型名称,待转换的模型需要继承自JSInvitedModel
     * @return  returnValue  服务器成功的返回的模型
     * @return  errorMsg     请求服务器失败反馈的错误，比如404
     */
    func requestServer(_ requestApi: BaseApi?,
                          modelName: String,
                          callback: ((_ returnValue: JSBaseModel) -> ())?,
                          errorCallback: ((_ errorMsg: String) -> ())?) -> () {
        
        requestApi?.startWithCompletionBlock(success: { (request: YTKBaseRequest!) in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let string = NSStringFromClass(self.classForCoder)
            
            if resultDict != nil {
                print("//****************************************************\n\n视图模型：\(string)\n模型：\(modelName)\n\n数据： \(resultDict!)\n\n****************************************************//")
            }
            
            if modelName != "" && resultDict != nil {
                
                let modelClass: AnyClass? = NSClassFromString("Owbao.\(modelName)")
                
                if modelClass != nil {
                    
                    let model = modelClass!.yy_model(with: resultDict!) as? JSBaseModel
                    
                    if model != nil {
                        
                        if callback != nil {
                            callback!(model!)
                        }
                    } else {
                        //处理错误
                        if errorCallback != nil {
                            errorCallback!("发生了未知错误")
                        }
                    }
                    
                } else {
                    //处理错误
                    if errorCallback != nil {
                       errorCallback!("发生了未知错误")
                    }
                }
                
            } else {
                
                //处理错误
                if errorCallback != nil {
                    errorCallback!("请求数据有误")
                }
            }
            
            }, failure: { (request: YTKBaseRequest!) in
                
                //处理错误的请求
                if errorCallback != nil {
                    if request != nil {
                        errorCallback!(self.handleError(request))
                    }
                }
        })
    }
    
    /**
     * 利用Alamofire请求服务器并转化模型（这个方法适合自己处理返回数据）
     *
     * @param   subApi 服务器地址
     *
     * @param   modelName    待转换的模型名称,待转换的模型需要继承自JSInvitedModel
     * @return  returnValue  服务器成功的返回的模型
     * @return  errorMsg     请求服务器失败反馈的错误，比如404
     */
    func requestAlamofire(params: Parameters,
            subApi: String,
            modelName: String,
            callback: ((_ returnValue: JSBaseModel) -> ())?,
            errorCallback: ((_ errorMsg: String) -> ())?) -> () {
        
        let headers: HTTPHeaders = [:]
        
        Alamofire.request(BASE_URL + subApi, method: .post, parameters: self.argument_alamofire(param: params), encoding: URLEncoding.default, headers: headers).validate().responseJSON { response in
            
            switch response.result {
            case .success:
                self.handleData(response: response.value as! [String : AnyObject], modelName: modelName, callback: callback, errorCallback: errorCallback)
             break
            case .failure(let error):
                
                if let error_af: AFError = error as? Alamofire.AFError {
                    
                    if errorCallback != nil {
                        errorCallback!(self.handleError_alamofire(error_af.responseCode!))
                    }
                } else {
                    
                    if errorCallback != nil {
                        errorCallback!(self.handleError_alamofire((error as NSError).code))
                    }
                }
                break
            }
        }
    }
    
    func handleData(response: [String: AnyObject],
             modelName: String,
             callback: ((_ returnValue: JSBaseModel) -> ())?,
             errorCallback: ((_ errorMsg: String) -> ())?) -> () {
        
        let string = NSStringFromClass(self.classForCoder)
        
        print("//****************************************************\n\n视图模型：\(string)\n模型：\(modelName)\n\n数据： \(response)\n\n****************************************************//")

        if modelName != "" {
            
            let modelClass: AnyClass? = NSClassFromString("Owbao.\(modelName)")
            
            if modelClass != nil {
                
                let model = modelClass!.yy_model(with: response) as? JSBaseModel
                
                if model != nil {
                    
                    if callback != nil {
                        callback!(model!)
                    }
                } else {
                    //处理错误
                    if errorCallback != nil {
                        errorCallback!("发生了未知错误")
                    }
                }
                
            } else {
                //处理错误
                if errorCallback != nil {
                    errorCallback!("发生了未知错误")
                }
            }
            
        } else {
            
            //处理错误
            if errorCallback != nil {
                errorCallback!("发生了未知错误")
            }
        }
    }
    
    //处理错误信息
    fileprivate func handleError_alamofire(_ operation: Int) -> String {
        
        if operation == 400 {
            return "404请求的语法有误"
        } else if operation == 401 {
            return "401请求未授权"
        } else if operation == 403 {
            return "403服务器禁止请求"
        } else if operation == 404 {
            return "404请求地址错误"
        } else if operation == 405 {
            return "405请求方法不被允许"
        } else if operation == 406 {
            return "406请求中指定的方法被禁用"
        } else if operation > 500 {
            return "\(operation)服务器开小差了，请稍后再试"
        }
        
        return "网络错误，请稍后再试"
    }
    
    //处理错误信息
    fileprivate func handleError(_ request: YTKBaseRequest?) -> String {
        
        if request != nil {
            
            let operation = request?.responseStatusCode
            
            if operation == 400 {
                return "404请求的语法有误"
            } else if operation == 401 {
                return "401请求未授权"
            } else if operation == 403 {
                return "403服务器禁止请求"
            } else if operation == 404 {
                return "404请求地址错误"
            } else if operation == 405 {
                return " 405请求方法不被允许"
            } else if operation == 406 {
                return "406请求中指定的方法被禁用"
            } else if operation > 500 {
                return "\(operation!)服务器开小差了，请稍后再试"
            }
        }
        
        return "网络错误，请稍后再试"
    }
    
    func argument_alamofire(param: Parameters) -> Parameters {
        
        var param_sub: Parameters = [:]

        // 1.获取程序当前的版本
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        
        if param["uid"] == nil {
            let dict: Parameters = ["version": currentVersion, "channel":"1"]
            param_sub = self.combined_alamofire(first: param, second: dict)
        } else {
            let dict: Parameters = ["version": currentVersion, "channel": "1","token": UserModel.shareInstance.token!]
            param_sub = self.combined_alamofire(first: param, second: dict)
        }
        return param_sub
    }
    
    func combined_alamofire(first: Parameters,second: Parameters) -> Parameters {
        
        var newDict = first
        for (key, value) in second {
            newDict[key] = value
        }
        return newDict
    }
}





