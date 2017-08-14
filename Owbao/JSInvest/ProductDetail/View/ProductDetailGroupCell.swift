//
//  ProductDetailGroupCell.swift
//  Owbao
//
//  Created by Panda on 16/4/22.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class ProductDetailGroupCell: UITableViewCell {
    
    
    var lineView:UIView! //黄线
    
    var btnsArray:[UIButton]! = [UIButton]()
    //    var leftLineView:UIView!
    //    var rightLineView:UIView!
    
    //    var max:((isMax:Bool)->())!           //最大按钮
    var groupChange:((_ buttonIndex:Int)->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createBtns(["项目介绍","安全保障","投资记录"])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /**
     初始化
     
     - parameter titles: 标题数组
     */
    func createBtns(_ titles:[String]){
        let width = SCREEN_WIDTH / CGFloat(titles.count)
        let height:CGFloat = 38
        for i in 0...titles.count - 1 {
            let btn = UIButton(frame: CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height))
            btn.addTarget(self, action: #selector(ProductDetailGroupCell.btnAction(_:)), for: UIControlEvents.touchUpInside)
            
            btn.tag = i
            
            if i == 0 {
                
                lineView = UIView(frame: CGRect(x: 16, y: height, width: width * 3 / 5, height: 2))
                lineView.backgroundColor = DEFAULT_ORANGECOLOR
                self.contentView.addSubview(lineView)
                
                btn.frame = CGRect(x: 16, y: 0, width: width - 16, height: height)
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
                
            } else if i == 2 {
                btn.frame = CGRect(x: 2 * width, y: 0, width: width - 16, height: height)
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
            }
            btnsArray.append(btn)
            self.contentView.addSubview(btn)
            btn.setTitle(titles[i], for: UIControlState())
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        
    }
    /**
     显示第几个分组
     
     - parameter index: 下标
     */
    func selGroupIndex(_ index:Int){
        
        var btnFrame = lineView.frame
        //        btnFrame.origin.x = CGFloat(index) * width
        if index == 0 {
            btnFrame.origin.x = 16
        } else if index == 1 {
            btnFrame.origin.x = (SCREEN_WIDTH - btnFrame.size.width) / 2
        } else {
            btnFrame.origin.x = SCREEN_WIDTH - 16 - btnFrame.size.width
        }
        lineView.frame = btnFrame
        
        for i in 0...btnsArray.count - 1 {
            let btn = btnsArray[i]
            if i == index {
                btn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
            } else {
                btn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
            }
        }
    }
    @IBAction func btnAction(_ sender: AnyObject) {
        //        if sender.tag == 0 {
        //            var point:CGPoint = self.lineView.center
        //            point.x = SCREEN_WIDTH / 4
        //
        //            self.leftButton.enabled = false
        //            self.rightButton.enabled = true
        //            UIView.animateWithDuration(0.2, animations: { () -> Void in
        //                self.lineView.center = point
        //                }, completion: { (Bool) -> Void in
        //                    self.leftButton.setTitleColor(DEFAULT_ORANGECOLOR, forState: .Normal)
        //                    self.rightButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //
        //
        //            })
        //        } else {
        //            var point:CGPoint = self.lineView.center
        //            point.x = SCREEN_WIDTH / 4 * 3
        //            self.leftButton.enabled = true
        //            self.rightButton.enabled = false
        //            UIView.animateWithDuration(0.2, animations: { () -> Void in
        //                self.lineView.center = point
        //                }, completion: { (Bool) -> Void in
        //                    self.rightButton.setTitleColor(DEFAULT_ORANGECOLOR, forState: .Normal)
        //                    self.leftButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        //                    
        //            })
        //        }
        self.groupChange(sender.tag)
        
    }
    
}
