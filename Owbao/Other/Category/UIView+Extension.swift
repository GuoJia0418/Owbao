//
//  UIView+Extension.swift
//  Owbao
//
//  Created by mac on 16/2/16.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import Foundation

extension UIView {

    func showTextHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
//        hud.color = UIColor(red:0, green:0, blue:0, alpha:0.8)
        hud.bezelView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.8)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = message
        hud.label.textColor = UIColor.white
        hud.detailsLabel.textColor = UIColor.white
        hud.hide(animated: true, afterDelay: 1.0)
        
    }
    
//    -(void)gifPlay6{
//    UIImage  *image=[UIImage sd_animatedGIFNamed:@"test"];
//    UIImageView  *gifview=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
//    gifview.image=image;
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.color=[UIColor grayColor];//默认颜色太深了
//    hud.mode = MBProgressHUDModeCustomView;
//    hud.labelText = @"加载中...";
//    hud.customView=gifview;
//    }
    
    func loadingStartAnimate(_ animateView:UIView){
        UIView.animate(withDuration: 0.1, animations: {
            animateView.transform = animateView.transform.rotated(by: CGFloat(M_PI/2))
        }, completion: { (finish:Bool) in
            if finish {
                self.loadingStartAnimate(animateView)}
        
        }) 
    }
    func showLoadingHud() {
 
        let imageView = YLImageView(frame: CGRect(x: 0, y: 0, width: 37, height: 37))
        imageView.image = YLGIFImage(named: "testLoading.gif")
//        imageView.image = YLGIFImage(named: "testLoading.gif")
//        imageView.image = UIImage(named: "loadingLogo")
        
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.mode = MBProgressHUDMode.customView
        hud.bezelView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.8)
        hud.detailsLabel.text = "读取中..."
        hud.customView = imageView
        hud.detailsLabel.textColor = UIColor.white
        
    }

    func hideHud() {
        MBProgressHUD.hide(for: self, animated: true)
//         GiFHUD.dismiss()
        
    }
    func showLongTextHud(_ message: String) {
        let hud = MBProgressHUD.showAdded(to: self, animated: true)
        hud.bezelView.backgroundColor = UIColor(red:0, green:0, blue:0, alpha:0.8)
        hud.tintColor = UIColor(red:0, green:0, blue:0, alpha:0.8)
        
        hud.mode = MBProgressHUDMode.text
        hud.detailsLabel.text = message

        hud.detailsLabel.textColor = UIColor.white
        hud.detailsLabel.font = UIFont.systemFont(ofSize: 15)
        hud.hide(animated: true, afterDelay: 1.5)
    }
    
}
