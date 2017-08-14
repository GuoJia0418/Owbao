
//
//  WinningPersonTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/8.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit
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


class WinningPersonTableViewCell: UITableViewCell {
    
    //头部视图
    lazy var headImageView: UIImageView = {
         var view = UIImageView()
         view = UIImageView(frame: CGRect(x: (SCREEN_WIDTH - 150 * SCREEN_WIDTH / 320) / 2, y: 10, width: 150 * SCREEN_WIDTH / 320, height: 150 * SCREEN_WIDTH / 320))
         view.layer.cornerRadius = view.frame.size.width / 2
         view.layer.masksToBounds = true
         view.backgroundColor = UIColor.blue
         view.image = UIImage(named: "prizer")
         self.addSubview(view)
         return view
    }()
    
    //中奖者
    lazy var prizerLabel: UILabel  = {
        let height = 15 * SCREEN_WIDTH / 320
        var label = UILabel(frame: CGRect(x: 0, y:  self.headImageView.frame.maxY + 10, width: (SCREEN_WIDTH - 5) / 2 , height: height))
        label.text = "中奖者"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        self.addSubview(label)
        return label
    }()
    
    //待中奖号
    lazy var codeLabel: UILabel = {
        let height = 15 * SCREEN_WIDTH / 320
        var label = UILabel(frame: CGRect(x: self.headImageView.frame.minX + 10, y: self.prizerLabel.frame.maxY + 10, width: 75 * SCREEN_WIDTH / 320, height: height))
        label.text = "中奖号"
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.right
        label.font = UIFont.systemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        self.addSubview(label)
        return label
    }()
    
    //待公布手机号码
    lazy var prizerPhone: UILabel = {
        let height = 15 * SCREEN_WIDTH / 320
        var label = UILabel(frame: CGRect(x: self.codeLabel.frame.maxX + 2, y: self.prizerLabel.frame.minY, width: (SCREEN_WIDTH - 5) / 2 , height: height))
        label.text = "待公布"
        label.textColor = DEFAULT_DARKGRAYCOLOR
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        self.addSubview(label)
        return label
    }()

    //待公布
    lazy var prizeCode: UILabel = {
        let height = 15 * SCREEN_WIDTH / 320
        var label = UILabel(frame: CGRect(x: self.codeLabel.frame.maxX + 2, y:self.codeLabel.frame.minY, width: 75 * SCREEN_WIDTH / 320, height: height))
        label.text = "待公布"
        label.textColor = DEFAULT_DARKGRAYCOLOR
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        self.addSubview(label)
        return label
    }()
    
    //TA说
    lazy var sayLabel: UILabel = {
        let height = 15 * SCREEN_WIDTH / 320
        var label = UILabel(frame: CGRect(x: 20, y: self.prizeCode.frame.maxY + 10, width: SCREEN_WIDTH - 40 , height: height))
        label.text = "TA说 “"
        label.font = UIFont.boldSystemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        label.textColor = DEFAULT_ORANGECOLOR
        label.textAlignment = NSTextAlignment.left
        self.addSubview(label)
        return label
    }()
    
    //获奖感言
    lazy var prizeWords: UILabel = {
        let height = 15 * SCREEN_WIDTH / 320
        var label = UILabel(frame: CGRect(x: 20, y: self.sayLabel.frame.maxY + 10, width: SCREEN_WIDTH - 40, height: 40 * SCREEN_WIDTH / 320))
        label.text = "待公布"
        label.textColor = DEFAULT_DARKGRAYCOLOR
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320)
        self.addSubview(label)
        return label
    }()
    
    //结束label
    lazy var endLabel: UILabel = {
        var label = UILabel(frame: CGRect(x: 20, y: self.prizeWords.frame.maxY, width: SCREEN_WIDTH - 40 , height: 15 * SCREEN_WIDTH / 320))
        label.text = "”"
        label.font = UIFont.boldSystemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        label.textColor = DEFAULT_ORANGECOLOR
        label.textAlignment = NSTextAlignment.right
        self.addSubview(label)
        return label
    }()
    
    //视频播放
    lazy var videoImgView: UIImageView = {
        //视频播放
        var view = UIImageView(frame: CGRect(x: (SCREEN_WIDTH - 276 * SCREEN_WIDTH / 320) / 2, y: self.endLabel.frame.maxY + 10, width: 276  * SCREEN_WIDTH / 320, height: 157 * SCREEN_WIDTH / 320))
        view.image = UIImage(named: "wait_notice")
        view.isUserInteractionEnabled = true
        //蒙板view
        let coverView = UIView(frame: CGRect(x: 0,y: 0, width: 276  * SCREEN_WIDTH / 320, height: 157 * SCREEN_WIDTH / 320))
        coverView.backgroundColor = UIColor(red: 180.0/255.0, green:180.0/255.0, blue: 180.0/255.0, alpha: 0.35)
        coverView.isUserInteractionEnabled = true
        view.addSubview(coverView)
        
        let openVideoImgView = UIImageView(frame: CGRect(x: (view.frame.size.width - 36 ) / 2, y: (view.frame.size.height - 36 ) / 2, width: 36, height: 36))
        openVideoImgView.image = UIImage(named: "video_open")
        coverView.addSubview(openVideoImgView)
        
        //红色
        let numImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 71 * SCREEN_WIDTH / 320, height: 71 * SCREEN_WIDTH / 320))
        numImageView.image = UIImage(named: "prizeNum")
        coverView.addSubview(numImageView)
        
        //添加点击手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapVideoAction))
        view.addGestureRecognizer(tap)
        self.addSubview(view)
        return view
    }()
    
    //期数
    lazy var numLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: -12 * SCREEN_WIDTH / 320, y: 18 * SCREEN_WIDTH / 320, width: 75 * SCREEN_WIDTH / 320, height: 20 * SCREEN_WIDTH / 320))
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15 * SCREEN_WIDTH / 320)
        label.textAlignment = NSTextAlignment.center
        label.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_4))
        self.videoImgView.addSubview(label)
        return label
    }()
    
    //模型数据
    var model: PrizePersonListModel?
    //点击播放视频回调闭包
    var tapVideoCallback:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func tapVideoAction() -> () {
        if self.tapVideoCallback != nil {
            self.tapVideoCallback!()
        }
    }
    
    //设置模型
    func configCellWithModel(_ model: PrizePersonListModel) -> () {
        self.model = model
        //设置模型
        if model.prizeHeadPhoto != nil && model.prizeHeadPhoto != "" {
            self.headImageView.sd_setImage(with: URL(string: model.prizeHeadPhoto!),placeholderImage:
                UIImage(named: "prizer"))
        }
        
        if model.activityPeriods != 0 {
            self.prizerLabel.text = "第\(model.activityPeriods)期中奖者"
            self.numLabel.text = "第\(model.activityPeriods)期"
        }
        
        if model.prizeMobile != nil && model.prizeMobile != "" {
            self.prizerPhone.textColor = DEFAULT_ORANGECOLOR
            self.prizerPhone.text = model.prizeMobile!.phoneNoAddAsterisk()
        } else {
            self.prizerPhone.text = "待公布"
        }
        
        if model.prizeCode != nil && model.prizeCode != "" {
            self.prizeCode.textColor = DEFAULT_ORANGECOLOR
            self.prizeCode.text = model.prizeCode
        } else {
            self.prizeCode.text = "待公布"
        }
        
        if model.prizeImgUrl != nil && model.prizeImgUrl != "" {
            self.videoImgView.sd_setImage(with: URL(string: model.prizeImgUrl!),placeholderImage:
                UIImage(named: "video_no"))
        }
        
        if model.prizeContent != nil && model.prizeContent != "" {
            let attributedString = NSMutableAttributedString(string: (model.prizeContent)!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttributes([NSParagraphStyleAttributeName:paragraphStyle], range: NSMakeRange(0, attributedString.length))
            //活动奖励
            self.prizeWords.numberOfLines = 0
            self.prizeWords.attributedText = attributedString
            self.prizeWords.sizeToFit()
        }
        self.setNeedsLayout()
    }

    //setNeedLayout  initWithFrame:  addSubView
    override func layoutSubviews() {
        super.layoutSubviews()
        //中奖者宣言
        if self.model != nil {
            let prizeWordsStr = self.model!.prizeContent
            let prizeWordsNewSize = prizeWordsStr?.getTextRectSize(UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), size: CGSize(width: SCREEN_WIDTH - 40 , height: 5000))
            //设置高度
            let height_prizeWordsStr = prizeWordsNewSize?.height < 20 ? 15: prizeWordsNewSize?.height
            self.prizeWords.frame = CGRect(x: 20, y: self.sayLabel.frame.size.height + self.sayLabel.frame.origin.y + 10, width: SCREEN_WIDTH - 40, height: height_prizeWordsStr!)
            self.endLabel.frame = CGRect(x: 20, y: self.prizeWords.frame.maxY, width: SCREEN_WIDTH - 40 , height: 15 * SCREEN_WIDTH / 320)
            self.videoImgView.frame = CGRect(x: (SCREEN_WIDTH - 276 * SCREEN_WIDTH / 320) / 2, y: self.endLabel.frame.size.height + self.endLabel.frame.origin.y + 10, width: 276 * SCREEN_WIDTH / 320, height: 157 * SCREEN_WIDTH / 320)
        }
    }
    
    /**
     * 通过PrizePersonListModel来算出cell的高度
     */
    class func cellHeightWithModel(_ model: PrizePersonListModel) -> CGFloat {
        let prizeWordsStr = model.prizeContent
        let prizeWordsNewSize = prizeWordsStr?.getTextRectSize(UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320), size: CGSize(width: SCREEN_WIDTH - 40 , height: 5000))
        //设置高度
        let height_prizeWordsStr = prizeWordsNewSize?.height < 20 ? 15 : prizeWordsNewSize?.height
        return  60 + 372 * SCREEN_WIDTH / 320 + height_prizeWordsStr!
    }
    
}
