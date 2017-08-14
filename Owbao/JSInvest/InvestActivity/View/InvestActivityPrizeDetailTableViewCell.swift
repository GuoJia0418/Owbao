//
//  InvestActivityPrizeDetailTableViewCell.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/26.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class InvestActivityPrizeDetailTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //设置圆角
        if self.zeroShareView != nil {
            self.zeroShareView.layer.cornerRadius = 25
            self.zeroShareView.layer.masksToBounds = true
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    //*********** 第一个xib ***********//
    @IBOutlet weak var displayImageView_first: UIImageView!
    
    @IBOutlet weak var zeroShareView: UIView!
    
    //下载图片
    func configureCell_xibFirst(_ imageViewURLString: String) -> () {
        self.displayImageView_first.sd_setImage(with: URL(string: imageViewURLString), placeholderImage: Common.image(with: UIColorFromRGB(235, green: 235, blue: 235)), options: SDWebImageOptions.refreshCached)
    }
    
    class func cellHeightWithXib_first() -> CGFloat {
        return 226.0 * SCREEN_WIDTH / 320.0
    }
    
    //*********** 第二个xib ***********//
    @IBOutlet weak var displayImageView_second: UIImageView!
    //设计图比例 58 : 43
    class func cellHeightWithXib_second(_ imageSize: CGSize) -> CGFloat {
        return imageSize.height * SCREEN_WIDTH / imageSize.width
    }
    
    var loadImageSuccessCallback: ((_ imageSize: CGSize)->())?
    
    //下载图片
    
    func configureCell_xibSecond(_ imageViewURLString: String) -> () {

        if self.displayImageView_second.image != nil  {
            return
        }
        
        SDWebImageManager.shared().downloadImage(with: URL(string: imageViewURLString), options: SDWebImageOptions.refreshCached, progress: { (receivedSize:Int, expectedSize:Int) in
            
        }) { (image:UIImage?, error:Error?, cacheType:SDImageCacheType, finished:Bool, imageURL:URL?) in
            self.displayImageView_second.image = image
            if self.loadImageSuccessCallback != nil {
                if image != nil {
                    self.loadImageSuccessCallback!((image?.size)!)
                }
                
            }
        }

        
//        SDWebImageManager.shared().downloadImage(with: URL(string: imageViewURLString), options: SDWebImageOptions.refreshCached, progress: { (receivedSize:Int, expectedSize:Int) in
//            
//        }) { (image:UIImage!, error:NSError!, cacheType:SDImageCacheType, finished:Bool, imageURL:URL!) in
//
//            self.displayImageView_second.image = image
//            
//            if self.loadImageSuccessCallback != nil {
//                if image != nil {
//                    self.loadImageSuccessCallback!(imageSize: image.size)
//                }
//                
//            }
//        }
    }
    
}
