//
//  AdvertisementView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/15.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//  封装的app启动时广告页

import UIKit

open class AdvertisementView: UIView,CAAnimationDelegate {
    
    var callback: ((_ success: Bool) -> ())?
    var tapAdvertisementViewCallback: ((_ URLString: String,_ title: String) -> ())? //点击广告视图
    
    let showTime: Int = 3 //广告时间
    var bannerModel: AdverstisementSysBannerModel? //保存的链接
    
    //主界面数据
    let adsView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds =  true
        imageView.backgroundColor = UIColor.white
        return imageView
    }()
    
    //跳过按钮
    let countButton: UIButton = {
       
        let buttonW: CGFloat = 60
        let buttonH: CGFloat = 30
        
        let button = UIButton(type: UIButtonType.custom)
        button.frame = CGRect(x: SCREEN_WIDTH - buttonW - 24, y: buttonH, width: buttonW, height: buttonH)
        button.setTitle("跳过5", for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.backgroundColor = UIColor.darkGray
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //显示视图
        self.addSubview(adsView)
        self.adsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        //显示跳过按钮
        self.addSubview(countButton)
        self.countButton.addTarget(self, action: #selector(cancelAction), for: UIControlEvents.touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //点击事件
    func tapAction() -> () {
        if self.tapAdvertisementViewCallback != nil {
            
            if self.bannerModel != nil {
                self.tapAdvertisementViewCallback!((self.bannerModel?.location)!,(self.bannerModel?.title)!)
            }
        }
    }
    
    //跳过点击事件
    func cancelAction() -> () {
        self.removeAdsView()
    }
    
    //开始加载广告，当广告时间结束，或者用户主动点击跳过才会回调
    open class func loadAdsImage(superView: UIView) -> AdvertisementView {
        
        //先创建视图
        let view = AdvertisementView(frame: superView.frame)
        
        //1.调用广告接口
        Adverstisement_Api().startWithCompletionBlock(success: { (request:YTKBaseRequest?) in
            let resultDict = request?.responseJSONObject as? [String: AnyObject]
            print("广告 = \(resultDict)")
            let model = AdverstisementModel(dict: resultDict!)
            
            if model.map != nil {
                
                if model.map?.sysBanner != nil {
                    
                    view.bannerModel = model.map?.sysBanner //保存模型数据
                    view.configureFileWithModel((model.map?.sysBanner)!,superView: superView)//开始判断
                    
                } else {
                    if view.callback != nil {
                        view.callback!(false) //数据有误直接回调
                    }
                }
                
            } else {
                if view.callback != nil {
                    view.callback!(false) //数据有误直接回调
                }
            }
            
            
        }) { (request:YTKBaseRequest?) in
            
            if view.callback != nil {
                view.callback!(false) //数据有误直接回调
            }
        }
        
        return view
    }
    
    //开始判断
    func configureFileWithModel(_ bannerModel: AdverstisementSysBannerModel,superView: UIView) -> () {
        
        let imageName = bannerModel.imgUrl.components(separatedBy: "/").last //获取当前图片名字
        
        if self.filePathIsExist(self.getImageDataSavePath(imageName!)) == true { //文件存在本地,直接显示
            self.displayAdvertisementView(superView,loadImage: UIImage(contentsOfFile: self.getImageDataSavePath(imageName!))!) //开始显示
            
        } else { //文件名字不存在，可能第一次启动app或者广告需要更新了
            
            //开始下载图片
            SDWebImageManager.shared().downloadImage(with: URL(string:bannerModel.imgUrl), options: .refreshCached, progress: { (receivedSize:Int, expectedSize:Int) in
                
            }, completed: { (image:UIImage?, error:Error?, cacheType:SDImageCacheType, finished:Bool, imageURL:URL?) in
                if finished == true {
                    self.displayAdvertisementView(superView,loadImage: image!) //显示图片
                    self.fileSaveInDomin(imageName!, displayImage: image!) //保存图片进沙盒
                } else {
                    
                    if self.callback != nil {
                        self.callback!(false) //下载失败回调开始回调
                    }
                }
            })
        }
    }
    
    /**
     * 根据图片名字拼接地址
     */
    func getImageDataSavePath(_ imageName: String) -> String {
        let homePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask,true)
        return ((homePath.first)! + imageName)
    }
    
    /**
     *  判断文件是否存在
     */
    func filePathIsExist(_ filePath: String) -> Bool {
        let manager = FileManager.default
        var isDir: ObjCBool = ObjCBool(false)
        return manager.fileExists(atPath: filePath, isDirectory: &isDir)
    }
    
    //保存图片文件
    func fileSaveInDomin(_ imageName: String,displayImage: UIImage) -> () {
        
        if ((try? UIImagePNGRepresentation(displayImage)?.write(to: URL(fileURLWithPath: self.getImageDataSavePath(imageName)), options: [.atomic])) != nil) == true {
            
            print("保存成功") //删除之前的图片
            self.deleteOldImageSaveNewImageName(imageName)
            
        } else {
           print("保存失败")
        }
    }
    
    //删除之前的图片名字,保存新的图片名字
    func deleteOldImageSaveNewImageName(_ imageName: String) -> () {
        
        if UserDefaults.standard.object(forKey: "aaaa") != nil { //非第一次
            
            let oldImageName = UserDefaults.standard.object(forKey: "aaaa") as! String //旧的图片
            if oldImageName != imageName { //表示两次名字不一样，需要删除之前的
                
                let path = self.getImageDataSavePath(oldImageName)
                
                do {
                    try FileManager.default.removeItem(atPath: path)
                } catch let error as NSError{
                    print("error is \(error)")
                }
                //保存新的图片名字
                UserDefaults.standard.set(imageName, forKey: "aaaa")
                UserDefaults.standard.synchronize()
            }
            
        } else { //第一次
            //保存新的图片名字
            UserDefaults.standard.set(imageName, forKey: "aaaa")
            UserDefaults.standard.synchronize()
        }
    }
    
    //开始创建、显示
    func displayAdvertisementView(_ superView: UIView,loadImage: UIImage) -> () {
        self.adsView.image = loadImage //开始赋值
        superView.addSubview(self)
        self.startCount()
    }
    
    //倒计时
    func startCount() -> () {
        
        var timeout: Int = showTime  //倒计时间 + 1
        let queue: DispatchQueue = DispatchQueue.global()
        let source: DispatchSource = DispatchSource.makeTimerSource(flags: [], queue: queue) as! DispatchSource
        source.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: DispatchTimeInterval.seconds(1))
        
        //开始执行
        source.setEventHandler { 
            
            if timeout <= -1 {
                
                source.cancel()
                DispatchQueue.main.async(execute: {
                    self.countButton.setTitle("跳过\(timeout)", for: UIControlState())
                    self.removeAdsView()
                })
                
            } else {
                
                DispatchQueue.main.async(execute: {
                    self.countButton.setTitle("跳过\(timeout)", for: UIControlState())
                    timeout = timeout - 1
                })
            }
        }
        source.resume()
    }
    
    //动画(水滴效果，苹果私有api可能会被拒)版移除广告界面
    func removeAdsView() -> () {
        let animation: CATransition = CATransition()
        animation.type = "rippleEffect"
        animation.subtype = kCATransitionFromRight //设置动画方向
        animation.duration = 0.5
        animation.delegate = self
        animation.isRemovedOnCompletion = true
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        self.isHidden = true
        self.layer.add(animation, forKey: "rippleEffectAnimation")
        
        if self.callback != nil {
            self.callback!(true) //下载失败回调开始回调
        }
    }
    
    //动画代理
    open func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.removeFromSuperview()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        self.adsView.frame = self.frame
    }
}

//**************** api ********************//
class Adverstisement_Api: BaseApi {
    
    override init() {
        super.init()
    }
    override func requestUrl() -> String! {
        return StartAdvertisement_Api
    }
}
//**************** 模型 ********************//
class AdverstisementModel: NSObject {
    
    var map :AdverstisementMapModel?
    var success:Bool = false
    var errorCode: String?
    // MARK: - 构造函数
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "map" {
            // 判断 value 是否是 一个 有效的 字典
            if let dict = value as? [String: AnyObject] {
                // 创建用户数据
                map = AdverstisementMapModel(dict: dict)
            }
            return
        }
        super.setValue(value, forKey: key)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class AdverstisementMapModel: NSObject {
    
    var sysBanner: AdverstisementSysBannerModel?
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "sysBanner" {
            // 判断 value 是否是一个有效的字典
            if let dict = value as? [String: AnyObject] {
                sysBanner = AdverstisementSysBannerModel(dict: dict)
            }
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

class AdverstisementSysBannerModel: NSObject {
    
    var imgUrl: String = ""
    var location: String = ""
    var title: String = ""
    
    init(dict: [String: AnyObject]) {
        super.init()
        // KVC
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
}

