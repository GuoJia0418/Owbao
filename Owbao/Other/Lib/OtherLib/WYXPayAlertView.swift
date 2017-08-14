//
//  WYXPayAlertView.swift
//  Owbao
//
//  Created by user on 16/8/8.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class WYXPayAlertView: UIView {
    
    fileprivate let tradePasswordViewHeight:CGFloat = 400           //alert的高度
    
    fileprivate let tradePasswordViewWidth:CGFloat = SCREEN_WIDTH   //alert 的宽度

    fileprivate var tradePasswordView:UIView!                       //显示的alertview
    
    fileprivate var blackDotArray = [UILabel]()                     //"●"数组
    
    fileprivate var passWord:String! = ""                            //密码记录
    
    var completeBlock : (((String) -> Void)?)                    //密码输入完成的回调
    
    var forgetPassword : (()->())!                               //忘记密码回调方法
    var alertMsgLabel:UILabel!                                  //提示信息
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        createDetail()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func createDetail() {
        
        tradePasswordView = UIView(frame:CGRect(x: 0,y: SCREEN_HEIGHT - tradePasswordViewHeight,width: tradePasswordViewWidth,height: tradePasswordViewHeight))
        tradePasswordView.backgroundColor = UIColor.white
        tradePasswordView.layer.cornerRadius = 5
        tradePasswordView.clipsToBounds = true
        self.addSubview(tradePasswordView)
        
        let backButton = UIButton(frame:CGRect(x: 10,y: 0,width: 30,height: 30))
        backButton.setImage(UIImage(named: "leftArrow"), for: UIControlState())
        backButton.addTarget(self, action: #selector(WYXPayAlertView.backAction(_:)), for: UIControlEvents.touchUpInside)
        tradePasswordView.addSubview(backButton)
        
        let titleLabel = UILabel(frame:CGRect(x: 30,y: 0,width: SCREEN_WIDTH - 60,height: 30))
        titleLabel.text = "交易密码"
        titleLabel.font = UIFont.systemFont(ofSize: 16 * SCREEN_WIDTH / 320)
        titleLabel.textAlignment = NSTextAlignment.center
        tradePasswordView.addSubview(titleLabel)
        
        let grayLineView = UIView(frame:CGRect(x: 0,y: 30,width: SCREEN_WIDTH,height: 1))
        grayLineView.backgroundColor = DEFAULT_GRAYCOLOR
        tradePasswordView.addSubview(grayLineView)
        
        let inputWhiteView = UIView(frame: CGRect(x: 10, y: grayLineView.frame.origin.y + 1 + 20, width: tradePasswordViewWidth - 20, height: 44))
        inputWhiteView.backgroundColor = UIColor.white
        inputWhiteView.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
        inputWhiteView.layer.borderWidth = 1.0
        tradePasswordView.addSubview(inputWhiteView)
        
        let width = inputWhiteView.frame.size.width / 6
        for i in 0...5 {
            let blackDot = UILabel(frame:CGRect(x: CGFloat(i) * width,y: 0,width: width,height: inputWhiteView.frame.size.height))
            blackDot.textColor = UIColor.black
            blackDot.text = "●"
            blackDot.textAlignment = NSTextAlignment.center
            blackDot.font = UIFont.systemFont(ofSize: 20)
            blackDot.isHidden = true
            inputWhiteView.addSubview(blackDot)
            blackDotArray.append(blackDot)
            if i > 0 {
                let verticalLine = UIView(frame:CGRect(x: CGFloat(i) * width,y: 0,width: 1,height: inputWhiteView.frame.size.height))
                verticalLine.backgroundColor = DEFAULT_GRAYCOLOR
                inputWhiteView.addSubview(verticalLine)
            }
        }
        let forgetPasswordBtn = UIButton(frame:CGRect(x: tradePasswordViewWidth - 130, y: inputWhiteView.frame.origin.y + inputWhiteView.frame.size.height + 20, width: 130, height: 30))
        forgetPasswordBtn.setTitle("忘记密码？", for: UIControlState())
        forgetPasswordBtn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
        forgetPasswordBtn.titleLabel?.textAlignment = NSTextAlignment.right
        forgetPasswordBtn.addTarget(self, action: #selector(WYXPayAlertView.forgetClick), for: UIControlEvents.touchUpInside)
        tradePasswordView.addSubview(forgetPasswordBtn)
        
        let grayLine = UIView(frame:CGRect(x: 0,y: forgetPasswordBtn.frame.origin.y + forgetPasswordBtn.frame.size.height + 50,width: tradePasswordViewWidth,height: 1))
        grayLine.backgroundColor = DEFAULT_GRAYCOLOR
        tradePasswordView.addSubview(grayLine)
        
//        var keyTitleArray = [0,1,2,3,4,5,6,7,8,9]
        
        let arr = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        let numbers = arr.sorted { (_, _) -> Bool in
            arc4random() < arc4random()
        }
        
        let row = 4
        let coloumn = 3
        let keyWidth = SCREEN_WIDTH / CGFloat(coloumn)
        let keyHeight = (tradePasswordViewHeight - grayLine.frame.origin.y - 1) / CGFloat(row)
        for i in 0...11
        {
            let button = UIButton(frame:CGRect(x: CGFloat(i % coloumn) * keyWidth, y: grayLine.frame.origin.y + 1 + CGFloat(i / coloumn) * keyHeight, width: keyWidth, height: keyHeight))
            if i == 9 {
                button.setTitle("清空", for: UIControlState())
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320)
                button.tag = 101
            }else if i == 11 {
                button.setTitle("删除", for: UIControlState())
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320)
                button.tag = 102
            }else {
                
                if i >= 0
                {
                    if i == 10
                    {
                        button.setTitle(numbers[9], for: UIControlState())
                        button.tag = Int(numbers[9])!
                    }
                    else
                    {
                        button.setTitle(numbers[i], for: UIControlState())
                        button.tag = Int(numbers[i])!
                    }
                    
                }

                
                //修改过的
//                let num = Int(arc4random() % keyTitleArray.count)
//                let titleStr = keyTitleArray[num]
//                button.setTitle("\(titleStr)", forState: UIControlState.Normal)
//                button.tag = titleStr
//                keyTitleArray.removeAtIndex(num)
                
            }
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.addTarget(self, action: #selector(WYXPayAlertView.keyInputAction(_:)), for: UIControlEvents.touchUpInside)
            tradePasswordView.addSubview(button)
            
            for i in 0...row {
                let keyHLine = UIView(frame:CGRect(x: 0, y: grayLine.frame.origin.y + 1 + keyHeight * CGFloat(i + 1), width: keyWidth * 3, height: 1))
                keyHLine.backgroundColor = DEFAULT_GRAYCOLOR
                self.tradePasswordView.addSubview(keyHLine)
            }
            for i in 0...coloumn {
                let keyWLine = UIView(frame:CGRect(x: CGFloat(i + 1) * keyWidth,y: grayLine.frame.origin.y + 1,width: 1,height: keyHeight * 4))
                keyWLine.backgroundColor = DEFAULT_GRAYCOLOR
                self.tradePasswordView.addSubview(keyWLine)
            }
        }
    }

    
    /*
     MARK : view的显示
     */
    func show() {
        let showWindow = UIApplication.shared.keyWindow
        showWindow?.addSubview(self)
        tradePasswordView.transform = CGAffineTransform(scaleX: 0.5,y: 0.5)
        tradePasswordView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT)
        tradePasswordView.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions(), animations: ({
            self.tradePasswordView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.tradePasswordView.center = CGPoint(x: self.tradePasswordViewWidth / 2, y: SCREEN_HEIGHT - self.tradePasswordViewHeight / 2)
            self.tradePasswordView.alpha = 1
        }), completion: nil)

    }
    func dismiss() {
        
        UIView.animate(withDuration: 0.7, animations: ({
            self.tradePasswordView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
          
            self.tradePasswordView.center = CGPoint(x: SCREEN_WIDTH / 2, y: SCREEN_HEIGHT)
            self.tradePasswordView.alpha = 0
            self.alpha = 0
        }), completion: { (finishd: Bool) -> Void in
            self.removeFromSuperview()
        }) 
    }
    /*
     MARK : button Click方法
     */
    //返回
    func backAction(_ button:UIButton) {
        dismiss()
    }
    //忘记密码
    func forgetClick() {
        self.forgetPassword()
    }
    //密码输入按钮事件
    func keyInputAction(_ button:UIButton) {
        if button.tag == 101 {
            for blackDot in blackDotArray {
                passWord = ""
                blackDot.isHidden = true
            }
        }else if button.tag == 102 {
            if passWord.length > 0 {
                let dot = blackDotArray[passWord.characters.count - 1]
                dot.isHidden = true
                let str = (passWord as NSString).substring(with: NSMakeRange(0, passWord.characters.count - 1))
                passWord = str
            }
        }else {
            if passWord.characters.count < 6 {
                passWord = passWord + "\(button.tag)"
                for i in 0 ..< passWord.characters.count {
                    blackDotArray[i].isHidden = false
                }
            }
            if passWord.characters.count == 6 {
                completeBlock!(passWord)
            }
        }
    }
 
}
