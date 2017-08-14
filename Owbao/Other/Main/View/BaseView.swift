//
//  BaseView.swift
//  JSApp
//
//  Created by lufeng on 16/2/2.
//  Copyright © 2016年 lufeng. All rights reserved.
//

import UIKit

class BaseView: UIViewController{
    
    @IBOutlet weak var IMAgeView: UIImageView!
    override init(nibName nibNameOrNil: String?, bundle nibBundelOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundelOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init() {
        let nibNameOrNil = String("BaseView")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        StartAnimation()
//        Timer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //动画效果
    func startAnimation() {
        let Time :TimeInterval = 4.0
        let shrinkDuration = Time * 0.3
        let growDuration = Time * 0.7
        UIView.animate(withDuration: shrinkDuration, delay: 0, usingSpringWithDamping: 0.7 ,initialSpringVelocity: 10, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            let scaleTransform : CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)
            self.IMAgeView.transform = scaleTransform
            }) { (finished :Bool) -> Void in
                UIView.animate(withDuration: growDuration, animations: { () -> Void in
                    let scaleTransform : CGAffineTransform = CGAffineTransform(scaleX: 10, y: 10)
                    self.IMAgeView.transform = scaleTransform
                    self.IMAgeView.alpha = 0;
                    }, completion: { (finished :Bool) -> Void in
//                        let Base = BaseTabBarController()
//                        self.presentViewController(Base, animated: true, completion: nil)
                })
        }
    }
    //计时器
    func Timer() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: { () -> Void in
//                let Base = BaseTabBarController()
//                self.presentViewController(Base, animated: true, completion: nil)
//                return
                self.startAnimation()
        })
    }
}
