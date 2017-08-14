//
//  JSSuggestionViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSSuggestionViewController: BaseViewController,UITextViewDelegate{
    
    @IBOutlet weak var textView: GJTextView!
    @IBOutlet weak var indicatorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        self.textView.placeholder = "嗷呜宝力求向您提供优质，高效的服务，请您留下宝贵的建议..."
        self.submitButton.layer.cornerRadius = 3
        self.submitButton.layer.masksToBounds = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "意见反馈")!.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBarButtonAction))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserModel.shareInstance.isLogin == 0 {
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
        }
    }

    //右部按钮点击事件
    func rightBarButtonAction() -> () {
       let popView = AlertPopView.configureView(UIApplication.shared.keyWindow!,
                                                viewTpye: .forth)
        //开始写标题
        popView.titleLabel_first.text = "拨打客服电话"
        popView.titleLabel_second.text = "400-671-7711"
        
        popView.titleLabel_second.textColor = UIColor.black
        popView.titleLabel_first.font = UIFont.systemFont(ofSize: 17)
        popView.titleLabel_second.font = UIFont.systemFont(ofSize: 19)
        
        popView.titleLabel_third.text = "热线服务时间：09:00~21:00"
        popView.titleLabel_forth.text = "周末节假日：09:00~18:00"
        popView.leftButton.setTitle("取消", for: UIControlState())
        popView.rightButton.setTitle("拨打", for: UIControlState())
        
        popView.conformCallback = {
            UIApplication.shared.openURL(URL(string: "tel://4006717711")!)
        }
    }
    
    @IBAction func commitAction(_ sender: AnyObject) {
        self.commitToServer(textView.text)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text != "" {
            if textView.text.length >= 200 {
                return false
            } else {
                
                return true
            }
            
        } else {
            
            if text == "\n" { //按了返回
                textView.resignFirstResponder()
                self.commitToServer(textView.text)
                return false
            }
            return true
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        self.indicatorLabel.text = "\(textView.text.length)/\(200)"
        
        if textView.text.characters.count > 200 {
            view.showTextHud("内容限制在200字)")
        }
    }
    
    //提交
    func commitToServer(_ text: String) -> () {
        
        if textView.text.trim().characters.count == 0 {
            view.showTextHud("请留下您的宝贵意见")
            return
        }
        
        if textView.text.characters.count > 200 {
            view.showTextHud("超出\(textView.text.characters.count - 200)字符)")
            return
        }
        
        view.showLoadingHud()
        weak var weakSelf = self
        
        FeedbackApi(Uid: UserModel.shareInstance.uid ?? 0, Content: text).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            weakSelf!.view.hideHud()
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            let model = FeedbackModel(dict: resultDict!)
            
            if model.success == false {
                weakSelf!.view.showTextHud("\((model.errorCode)!)")
            } else {
                self.view.showTextHud("反馈成功")
                delay(1, block: { 
                    self.navigationController?.popViewController(animated: true)
                })
            }
            
        }) { (request: YTKBaseRequest!) -> Void in
            self.view.hideHud()
            self.view.showTextHud("网络错误")
        }
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSSuggestionViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
