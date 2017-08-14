//
//  ProductDetailPicCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/15.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

let title_color = UIColorFromRGB(102, green: 102, blue: 102)

class ProductDetailPictureCell: UITableViewCell {

    var bgView:UIView!                  //背景view
    var secondView:UIView!              //第二部分view
    var iconImgView:UIImageView!        //竖线图标
    var titleLabel:UILabel!             //标题
    
    let marginX = 40
    let marginY = 10
    let viewW = (SCREEN_WIDTH - 120) / 2
    let viewH = 167 * SCREEN_SCALE_W
    var pictureArray:[String] = []{
    
        didSet{
        
            if pictureArray.count != 0
            {
                    for i in 0...pictureArray.count - 1 {
                    
                    let view = commonView(CGFloat(i % 2) * (viewW + CGFloat(marginX)) + CGFloat(marginX), y: CGFloat(marginY) + CGFloat(i / 2) * (viewH + CGFloat(marginY)),w: viewW, h: viewH, image: "", title: "企业法人身份证")
                    secondView.addSubview(view)
                }
            }
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCompanyView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bgView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH,height: 37 * SCREEN_SCALE_W)
        
        iconImgView.size = (iconImgView.image?.size)!
        iconImgView.center = CGPoint(x: 12, y: bgView.height / 2)
        
        titleLabel = setupLabel(iconImgView.x + iconImgView.width + 5, y: (bgView.height - 15) / 2, width: SCREEN_WIDTH - 25 * SCREEN_SCALE_W, height: 15, font: 15, textColor: title_color, textAlignment: .left, text: "原债方企业资料", ishaveBorder: false, view: bgView)
        
        secondView.frame = CGRect(x: 0, y: bgView.y + bgView.height + 1, width: SCREEN_WIDTH, height: self.contentView.height - 45 * SCREEN_SCALE_W)
    }
    func setupCompanyView()
    {
        //企业资料
        self.contentView.backgroundColor = DEFAULT_BGCOLOR
        
        bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.contentView.addSubview(bgView)

        iconImgView = UIImageView(image: UIImage(named: "js_product_detail_vertical_line"))
        bgView.addSubview(iconImgView)
        
        titleLabel = UILabel()
        bgView.addSubview(titleLabel)
        
        secondView = UIView()
        secondView.backgroundColor = UIColor.white
        self.contentView.addSubview(secondView)
        
    }
    class func cellHeight(_ pictureArray:NSArray)->CGFloat
    {
        if pictureArray.count / 2 == 0
        {
            return (232 + CGFloat(pictureArray.count / 2 - 1) * 175) * SCREEN_SCALE_W
        }
        else
        {
            return (232 + CGFloat(pictureArray.count / 2) * 175) * SCREEN_SCALE_W
        }
    }
    func commonView(_ x:CGFloat,y:CGFloat,w:CGFloat,h:CGFloat,image:String,title:String) -> UIView
    {
        let view = UIView(frame: CGRect(x: x, y: y, width: w, height: h))
        view.backgroundColor = UIColor.white
        
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: w, height: 139 * SCREEN_SCALE_W))
        imgView.image = UIImage(named: image)
        imgView.backgroundColor = UIColor.orange
        view.addSubview(imgView)
        
        let label = setupLabel(0, y: imgView.y + imgView.height + 10, width: w, height: 11, font: 11 , textColor: title_color, textAlignment: .center, text: title, ishaveBorder: false, view: view)
        label.backgroundColor = UIColor.white
        
        return view
    }
    
    //设置Attribute
    func setAttributedString(_ superString:String,subString:String,attributeName:String,isSetFont:Bool,font:CGFloat,location:Int,length:Int,label:UILabel)
    {
        let attributedString = NSMutableAttributedString(string: superString)
        if isSetFont
        {
            attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: font), range: NSMakeRange(location,length))
        }
        label.attributedText = attributedString
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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
