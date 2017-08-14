//
//  MoreScreenSlidingRootController.swift
//  Owbao
//
//  Created by user on 16/7/21.
//  bb
//

import UIKit

class MoreScreenSlidingRootController: BaseViewController,UIScrollViewDelegate {
    
    var bgScrollView: UIScrollView!                //滑动视图
    var lineView: UIView?                       //移动的线条
    var btnArray: [UIButton] = []                  //装button的数组
    var buttonTitleArray:[String]?              //3个按钮的title数组
    var isTouch:Bool! = false                   //判断是否点击
    
    var vcType: Int! = 0                     //VC标记，0为消息，1为红包，2为投资 3为活动中心 4赚钱任务 5体验金  6优惠券
    var invalidCouponBtn: UIButton!  //查看失效优惠券
    
    let statusNum = [1,3,0]                     //状态值, 我的投资页面
    let prizeStatus = [3,0,1]                   //活动中心  状态值
    let couponType = [2,3,4]                    //优惠券  2=返现券 3=加息券 4=翻倍券
    var isFromMyAccount:Int = 0
    var isFromAuthentication:Int = 0            //来自信息验证页面
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (navigationController?.navigationBar.isHidden)! {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
    
    func backAction() {
        let vc = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
        self.navigationController?.popToViewController(vc!, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        constantSet()
        createUI()
        
        if isFromMyAccount == 1 || isFromAuthentication == 1 {
            self.popType = .reloadApp
        }
        
        //我的优惠券
        if vcType == 6
        {
            //去投资
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "去投资", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MoreScreenSlidingRootController.goInvest))
        }
    }

    //MARK: - 去投资
    func goInvest()
    {
        RootNavigationController.goToInvestList(controller: self)
    }

    
    /**
     常量的设置
     */
    func constantSet() {
        switch vcType {
        case 0:
            buttonTitleArray = ["交易","活动","系统"]
            self.title = "我的消息"
            break
        case 1:
            buttonTitleArray = ["未使用","已使用","已失效"]
            self.title = "我的红包"
            break
        case 2:
            buttonTitleArray = ["待回款","已回款","募集中"]
            self.title = "我的投资"
            break
        case 3:
            buttonTitleArray = ["全部","未开奖","已开奖"]
            self.title = "活动中心"
            break
        case 4:
            buttonTitleArray = ["全部","进行中","已结束"]
            self.title = "活动专区"
            break
        case 5:
            buttonTitleArray = ["未使用","已使用","已失效"]
            self.title = "我的体验金"
            break
        case 6:
            buttonTitleArray = ["返现红包","加息券","翻倍券"]
            
            //自定义导航栏标题
            let titleView = UIView(frame: CGRect(x: 0,y: 0, width: 100, height: 40))
            
            //label
            let label = UILabel()
            label.frame = CGRect(x: 10, y: 0, width: 60, height: 40)
            label.text = "优惠券"
            label.textAlignment = .center
            titleView.addSubview(label)
            
            //button
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "问号.png")?.withTintColor(UIColorFromRGB(250, green: 76, blue: 66)), for: UIControlState())
            button.addTarget(self, action: #selector(buttonClickAction), for: .touchUpInside)
            button.frame = CGRect(x: 60, y: 0, width: 40, height: 40)
            titleView.addSubview(button)
            navigationItem.titleView = titleView
            
            break
        default:
            break
        }
    }
    
    //按钮点击action
    func buttonClickAction() -> () {
        let controller = JSCouponExplainViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    /**
     界面的创建
     */
    func createUI() {
        
        self.view.backgroundColor = DEFAULT_GRAYCOLOR
        
        let btnWidth = SCREEN_WIDTH / 3
        var btnHeight:CGFloat = 0.00
        if vcType == 6
        {   //优惠券
            btnHeight = 40
        }
        else
        {
            btnHeight = 35
        }
        
        if vcType == 3
        {
            //中奖记录
            let headLabel = UILabel(frame: CGRect(x: 10, y: 0, width: SCREEN_WIDTH - 10, height: 30 * SCREEN_WIDTH / 320))
            headLabel.backgroundColor = DEFAULT_GRAYCOLOR
            headLabel.textColor = DEFAULT_DARKGRAYCOLOR
            headLabel.text = "中奖记录"
            headLabel.textAlignment = NSTextAlignment.left
            headLabel.font = UIFont.systemFont(ofSize: 14 * SCREEN_WIDTH / 320)
            self.view.addSubview(headLabel)
            
            for i in 0...buttonTitleArray!.count - 1
            {
                let btn = UIButton(frame: CGRect( x: CGFloat(i) *  btnWidth, y: 30 * SCREEN_WIDTH / 320, width: SCREEN_WIDTH / CGFloat(buttonTitleArray!.count), height: btnHeight))
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 15 * SCREEN_WIDTH / 320)
                if i == 0 {
                    btn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
                }else {
                    btn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                }
                btn.setTitle(buttonTitleArray![i], for: UIControlState())
                btn.tag = 100 + i
                btn.addTarget(self, action: #selector(MoreScreenSlidingRootController.btnClick(_:)), for: UIControlEvents.touchUpInside)
                self.view.addSubview(btn)
                btnArray.append(btn)
                
            }
            
        }
        else
        {
            for i in 0...buttonTitleArray!.count - 1
            {
                let btn = UIButton(frame: CGRect( x: CGFloat(i) *  btnWidth, y: 0, width: SCREEN_WIDTH / CGFloat(buttonTitleArray!.count), height: btnHeight))
                btn.backgroundColor = UIColor.white
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                if i == 0 {
                    btn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
                }else {
                    btn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                }
                
                btn.setTitle(buttonTitleArray![i], for: UIControlState())
                btn.tag = 100 + i
                btn.addTarget(self, action: #selector(MoreScreenSlidingRootController.btnClick(_:)), for: UIControlEvents.touchUpInside)
                self.view.addSubview(btn)
                btnArray.append(btn)
                
            }
        }
        
        //移动的线条
        lineView = UIView (frame: CGRect(x: 0, y: btnHeight , width: btnWidth,height: 2))
        if vcType == 3 {
            lineView = UIView (frame: CGRect(x: 0, y: btnHeight + 30, width: btnWidth,height: 2))
        }
        lineView!.backgroundColor = UIColor.clear
        self.view.addSubview(lineView!)
        
        let line = UIView(frame:CGRect(x: btnWidth / 4, y: 0, width: btnWidth / 2, height: 2))
        line.backgroundColor = DEFAULT_ORANGECOLOR
        lineView!.addSubview(line)
        
        if vcType == 6
        {
            //优惠券
            bgScrollView = UIScrollView(frame: CGRect(x: 0, y: btnHeight + 2 + 20, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - btnHeight - 2 - 64))
        }
        else
        {
            bgScrollView = UIScrollView(frame: CGRect(x: 0, y: btnHeight + 2 + 30 * SCREEN_WIDTH / 320, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - btnHeight - 2 - 64))
        }
        bgScrollView.contentSize = CGSize(width: SCREEN_WIDTH * 3, height: bgScrollView!.frame.size.height)
        bgScrollView.delegate = self
        bgScrollView.backgroundColor = DEFAULT_GRAYCOLOR
        bgScrollView.isPagingEnabled = true
        
        self.view.addSubview(bgScrollView!)
        switch vcType {
        case 0:
//            for i in 0...2 {
//                let vc = MyMailChildViewController()
//                self.addChildViewController(vc)
//                vc.view.frame = CGRect( x: bgScrollView.frame.size.width * CGFloat(i), y: 0, width: bgScrollView.frame.size.width, height: (bgScrollView?.frame.size.height)!)
//                self.bgScrollView?.addSubview(vc.view)
//                vc.type = 3 - i
//            }
            break
        case 1:
//            for i in 0...2 {
//                let vc = MyCouponsChildViewController()
//                self.addChildViewController(vc)
//                vc.view.frame = CGRect( x: bgScrollView.frame.size.width * CGFloat(i), y: 0, width: bgScrollView.frame.size.width, height: (bgScrollView?.frame.size.height)!)
//                self.bgScrollView?.addSubview(vc.view)
//                vc.couponsStatus = i
//            }
            break
        case 2:
//            for i in 0...2 {
//                let vc = MyInvestChildViewController()
//                self.addChildViewController(vc)
//                vc.view.frame = CGRect( x: bgScrollView.frame.size.width * CGFloat(i), y: 0, width: bgScrollView.frame.size.width, height: (bgScrollView?.frame.size.height)!)
//                self.bgScrollView?.addSubview(vc.view)
//                vc.status = statusNum[i]
//            }
            break
        case 3:
//            for i in 0...2 {
//                let vc = ActivityCenterViewController1()
//                self.addChildViewController(vc)
//                vc.view.frame = CGRect( x: bgScrollView.frame.size.width * CGFloat(i), y: 0, width: bgScrollView.frame.size.width, height: (bgScrollView?.frame.size.height)!)
//                self.bgScrollView?.addSubview(vc.view)
//                vc.prizeStatus = prizeStatus[i]
//            }
            break
            
        case 4:
//            for i in 0...2 {
//                
//                let vc = MakeMoneyTaskViewController()
//                self.addChildViewController(vc)
//                vc.view.frame = CGRect( x: bgScrollView.frame.size.width * CGFloat(i), y: 0, width: bgScrollView.frame.size.width, height: (bgScrollView?.frame.size.height)!)
//                self.bgScrollView?.addSubview(vc.view)
//                //赚钱任务
//                vc.makeMoneyStatus = i
//            }
            break
            
        case 5: //体验金
//            for i in 0...2 {
//                let vc = ExperienceInvestListViewController()
//                self.addChildViewController(vc)
//                vc.view.frame = CGRectMake( bgScrollView.frame.size.width * CGFloat(i), 0, bgScrollView.frame.size.width, (bgScrollView?.frame.size.height)!)
//                self.bgScrollView?.addSubview(vc.view)
//                vc.couponsStatus = i
//            }
            break
            
        case 6: //优惠券
            for i in 0...2 {
                let vc = JSCouponViewController()
                self.addChildViewController(vc)
                vc.view.frame = CGRect(x: bgScrollView.frame.size.width * CGFloat(i), y: 0, width: bgScrollView.frame.size.width, height: ((bgScrollView?.frame.size.height)! - 70))
                vc.view.backgroundColor = DEFAULT_GRAYCOLOR
                self.bgScrollView?.addSubview(vc.view)
                vc.couponType = couponType[i]
                
                let invalidCouponBtn = UIButton(frame: CGRect(x: bgScrollView.frame.size.width * CGFloat(i), y: vc.view.height + vc.view.y + 5, width: SCREEN_WIDTH, height: 45))
                invalidCouponBtn.setTitle("失效优惠券", for: UIControlState())
                invalidCouponBtn.setTitleColor(UIColorFromRGB(21, green: 21, blue: 21), for: UIControlState())
                invalidCouponBtn.backgroundColor = UIColor.white
                invalidCouponBtn.addTarget(self, action: #selector(MoreScreenSlidingRootController.invalidCouponClick(_:)), for: .touchUpInside)
                bgScrollView.addSubview(invalidCouponBtn)

            }
            break
        default: break
            
        }
        
        self.navigationItem.rightBarButtonItem = nil
    }
    
    //MARK: - 查看失效优惠券
    func invalidCouponClick(_ sender:UIButton)
    {
        print("点击查看失效券")
        let validCouponVC = JSInvalidCouponViewController()
        self.navigationController?.pushViewController(validCouponVC, animated: true)
    }
    
    
    /*
     button 点击事件
     */
    func btnClick(_ button:UIButton) {
        
        self.isTouch = true
        var newFrame = CGRect( x: CGFloat((button.tag - 100)) * SCREEN_WIDTH / CGFloat(btnArray.count), y: button.frame.size.height, width: SCREEN_WIDTH / CGFloat(btnArray.count), height: 2)
        if vcType == 3 {
            newFrame = CGRect( x: CGFloat((button.tag - 100)) * SCREEN_WIDTH / CGFloat(btnArray.count), y: button.frame.size.height + 30 * SCREEN_WIDTH / 320, width: SCREEN_WIDTH / CGFloat(btnArray.count), height: 2)
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.lineView?.frame = newFrame
            for i in 0...self.btnArray.count-1 {
                let btn = self.view.viewWithTag(i + 100) as! UIButton
                if i == button.tag - 100 {
                    btn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
                }else {
                    btn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                }
            }
        }, completion: { (finished:Bool) -> Void in
            self.isTouch = false
        }) 
        bgScrollView?.setContentOffset(CGPoint( x: CGFloat((button.tag - 100)) * SCREEN_WIDTH, y: 0), animated: true)
    }
    /*
     scrollview代理
     */
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !isTouch {
            var newFrame = self.lineView?.frame
            newFrame?.origin.x = scrollView.contentOffset.x / 3
            self.lineView?.frame = newFrame!
        }
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
        
        if !isTouch {
            var newFrame = self.lineView?.frame
            newFrame?.origin.x = scrollView.contentOffset.x / 3
            self.lineView?.frame = newFrame!
        }
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.btnClick(btnArray[Int(scrollView.contentOffset.x / SCREEN_WIDTH)])
    }
    
}
