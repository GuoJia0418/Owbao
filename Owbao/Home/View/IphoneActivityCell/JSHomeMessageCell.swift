//
//  JSHomeMessageCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/9.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class JSHomeMessageCell: UITableViewCell {

//    var iconImageView:UIImageView!      //财 图标
//    var titleLabel:UILabel!             //标题
//    var secondTitleLabel:UILabel!       //第二个标题
    
//    var limitLabel:UILabel!             //条件限制
//    var limitsLabel:UILabel!
//    var rateLabel:UILabel!              //基础利率
//    var addRateLabel:UILabel!           //增加利率
//    var deadlineLabel:UILabel!          //期限
//    var pertProgressView:KDCircularProgress!    //募集进度的圆圈
//    var pertLabel:UILabel!                      //募集进度
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupChildUI()
    }
    
    class func cellHeight() -> CGFloat {
        return 69 * SCREEN_SCALE_W
    }
    
    //创建UI
    func setupChildUI()
    {
        self.contentView.backgroundColor = DEFAULT_BGCOLOR
        
        let iconImageArray = ["js_gray_money","js_gray_safety","js_gray_law"]
        let titleArr = ["严格甄选","6大还款","两大知名律师"]
        let smallTitleArr = ["优质产品","来源保障","事务所支持"]
        let viewW = (SCREEN_WIDTH - 50 * SCREEN_SCALE_W ) / 3
        let viewX = 25 * SCREEN_SCALE_W
        let viewH = 28 * SCREEN_SCALE_W
        let viewY = 18 * SCREEN_SCALE_W
        for i in 0..<3 {
            let view = setupView(i, imageName: iconImageArray[i], title: titleArr[i], smallTitle: smallTitleArr[i],viewW: viewW,viewX: viewX + viewW * CGFloat(i),viewH: viewH,viewY: viewY)
            self.contentView.addSubview(view)
        }
    }
   
    func setupView(_ i:Int,imageName:String,title:String,smallTitle:String,viewW:CGFloat,viewX:CGFloat,viewH:CGFloat,viewY:CGFloat)->UIView
    {
        let view = UIView(frame: CGRect(x: viewX, y: viewY, width: viewW, height: viewH))
        view.backgroundColor = DEFAULT_BGCOLOR
        
        let iconImageView = UIImageView(image: UIImage(named: imageName))
        iconImageView.size = (iconImageView.image?.size)!
        view.addSubview(iconImageView)
        
        let titleLabel = setupLabel(iconImageView.x + iconImageView.width + 2, y: 0, width: 80 * SCREEN_SCALE_W, height: 14 * SCREEN_SCALE_W, font: 10 * SCREEN_SCALE_W, textColor: DEFAULT_DARKGRAYCOLOR, textAlignment: .left, text: title, ishaveBorder: false, view: view)
        
        let secondTitleLabel = setupLabel(titleLabel.x, y: titleLabel.y + titleLabel.height, width: 80 * SCREEN_SCALE_W, height: 14 * SCREEN_SCALE_W, font: 10 * SCREEN_SCALE_W, textColor: DEFAULT_DARKGRAYCOLOR, textAlignment: .left, text: smallTitle, ishaveBorder: false, view: view)

        return view
    }
    
    func setupLabel(_ x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,font:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment,text:String,ishaveBorder:Bool,view:UIView) -> UILabel
    {
        let label = UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        label.font = UIFont.systemFont(ofSize: font)
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.text = text
        if ishaveBorder {
            label.layer.cornerRadius = 2.0
            label.layer.masksToBounds = true
            label.layer.borderColor = DEFAULT_ORANGECOLOR.cgColor
            label.layer.borderWidth = 1.0
        }
        view.addSubview(label)
        return label
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
