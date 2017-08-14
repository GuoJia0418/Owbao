//
//  ProductDetailAgreementCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/16.
//  Copyright © 2017年 wangyuxi. All rights reserved.
//

import UIKit

class ProductDetailAgreementCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var firstImgView: UIImageView!
    @IBOutlet weak var firstContentLabel: UILabel!
    @IBOutlet weak var secondImgView: UIImageView!
    @IBOutlet weak var secondContentLabel: UILabel!
    @IBOutlet weak var thirdImgView: UIImageView!
    @IBOutlet weak var thirdContentLabel: UILabel!
    
    weak var delegate: BaseViewController? //代理
    var listArray = [DetailsListPicListModle]()
    var browser: IDMPhotoBrowser?
    
    class func cellHeight()-> CGFloat {
        return 300 * SCREEN_SCALE_W
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //cell高度
    class func cellHeight(_ imageListModle: DetailsListModle?,type: Int) -> CGFloat { //941.0 * 1280 //941: 1280 图片的宽高比
        if imageListModle != nil && imageListModle?.map != nil && imageListModle?.map?.picList != nil {
            let array = NSArray(array: (imageListModle?.map?.picList)!).filtered(using: NSPredicate(format: "type == %d",type))
            
            if array.count > 0 {
                
                let row = (array.count + 3 - 1) / 3
                
                let MarginW: CGFloat = 30.0
                let MarginH: CGFloat = 40.0
                
                let imageViewW = (SCREEN_WIDTH - 4 * MarginW) / 3
                let imageViewH  = imageViewW / 941.0 * 1280 //941: 1280 图片的宽高比
                
                return 60 + CGFloat(row) * (imageViewH + MarginH) + 10 // 60是顶部留白，10 是底部留白
                
            }
        }
        return 37.0 + 10
    }
    
    func selectImageView(_ showIndex: Int) -> () {
        
        var array = [IDMPhoto]()
        
        for model in self.listArray {
            let photo = IDMPhoto(url: URL(string: model.bigUrl!))
            array.append(photo!)
        }
        
        //创建图片浏览器
        let browser = IDMPhotoBrowser(idmPhotoArray: array)
        browser?.forceHideStatusBar = true
        browser?.displayDoneButton = false
        browser?.displayToolbar = true
        browser?.autoHideInterface = false
        browser?.displayActionButton = false
        browser?.displayArrowButton = true
        browser?.displayCounterLabel = true
        browser?.animationDuration = 1.0
        browser?.disableVerticalSwipe = true
        browser?.usePopAnimation = true
        browser?.setInitialPageIndex(UInt.init(showIndex))
        //弹出图片浏览器
        self.delegate?.present(browser!, animated: true, completion: nil)
        self.browser = browser //保存
        browser?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissController)))
    }
    
    func dismissController() -> () {
        self.browser!.dismiss(animated: false, completion: nil)
    }
    
    func tapAction(_ gestureRecognizer: UITapGestureRecognizer) -> () {
        let imageView = gestureRecognizer.view as! UIImageView
        self.selectImageView(imageView.tag)
    }
    
    //设置cell
    func configureCell(_ imageListModle: DetailsListModle?,type: Int) -> () {
        
        if imageListModle != nil && imageListModle?.map != nil && imageListModle?.map?.picList != nil{
            let array = NSArray(array: (imageListModle?.map?.picList)!).filtered(using: NSPredicate(format: "type == %d",type))
            
            self.listArray = array as! [DetailsListPicListModle] //保存数组
            
            if array.count > 0 { //数组有元素
                
                for index in 0 ... array.count - 1 {
                    let model = array[index] as! DetailsListPicListModle
                    
                    //imageView
                    let imageView = UIImageView()
                    imageView.tag = index
                    imageView.isUserInteractionEnabled = true
                    imageView.sd_setImage(with: URL(string: model.bigUrl!), placeholderImage: Common.image(with: UIColorFromRGB(237, green: 237, blue: 237)), options: SDWebImageOptions.progressiveDownload)
                    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
                    self.addSubview(imageView)
                    
                    //显示的label
                    let label = UILabel()
                    label.text = (model.name)!
                    label.textColor = UIColor.darkGray
                    label.textAlignment = NSTextAlignment.center
                    label.font = UIFont.systemFont(ofSize: 15)
                    self.addSubview(label)
                    
                    //坐标
                    let MarginW: CGFloat = 30.0
                    let MarginH: CGFloat = 40.0
                    
                    let imageViewW = (SCREEN_WIDTH - 4 * MarginW) / 3
                    let imageViewH  = imageViewW / 941.0 * 1280 //941: 1280 图片的宽高比
                    
                    let col = index % 3
                    let row = index / 3
                    
                    let x = CGFloat(col) * (imageViewW + MarginW) + MarginW
                    let y = CGFloat(row) * (imageViewH + MarginH) + 60

                    imageView.frame = CGRect(x: x, y: y, width: imageViewW, height: imageViewH)
                    label.frame = CGRect(x: imageView.frame.minX, y: imageView.frame.maxY + 5, width: imageView.frame.width, height: 20)
                }
            }
        }
    }
}
