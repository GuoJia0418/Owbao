//
//  CouponListView.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/16.
//  Copyright © 2017年 wangyuxi. All rights reserved.
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class CouponListView: UIView,UITableViewDataSource,UITableViewDelegate,POPAnimationDelegate {
    
    fileprivate var contentView: UIView!
    fileprivate var listView: UITableView!
    fileprivate var titleLabel: UILabel!             //优惠券标题
    fileprivate var messageLabel: UILabel!           //信息label
    fileprivate var closeBtn: UIButton!              //关闭按钮
    fileprivate var subView: UIView!
    fileprivate var checkBtn: UIButton!
    
    fileprivate var couponModel: MyCouponsModel?     //下载红包模型
    var selectCouponModel: MyCouponsListModel?   //选中的红包
    
    var tapCallback: ((_ listModel: MyCouponsListModel) -> ())?  //选中回调
    var checkCallback: (() -> ())?            //点击查看优惠券回调
    
    let subViewH = 60 * SCREEN_SCALE_W
    let margin = 90 * SCREEN_SCALE_W + 64
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupContent()
    }
    
    deinit {
        self.listView = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func dismissViewWithGesture(ges: UITapGestureRecognizer) {
        
        let point = ges.location(in: self)
        
        if point.y < self.contentView.frame.minY {
            self.dismissView()
        }
    }
    
    func setupContent() {
        
        self.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        self.backgroundColor = PopView_BackgroundColor
        
        //tapBackgroundView
        let tapView = UIView()
        tapView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: margin)
        tapView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        self.addSubview(tapView)
        
        tapView.isUserInteractionEnabled = true
        tapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissViewWithGesture)))
        
        //背景半透明视图
        contentView = UIView(frame: CGRect(x: 0, y: margin, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - margin))
        contentView.backgroundColor = UIColorFromRGB(230, green: 230, blue: 230)
        self.addSubview(contentView)
        
        //头部背景视图
        subView = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: subViewH))
        subView.backgroundColor = UIColor.white
        contentView.addSubview(subView)
        
        titleLabel = setupLabel(SCREEN_WIDTH / 2 - 30, y: 0, width: 60, height: subViewH / 2, font: 16 , textColor: UIColorFromRGB(48, green: 48, blue: 48), textAlignment: .center, text: "优惠券", ishaveBorder: false, view: subView)
        
        //查看优惠券按钮
        checkBtn = UIButton(type: .custom)
        checkBtn.frame = CGRect(x: titleLabel.frame.maxX - 7,y: titleLabel.frame.minY,width: titleLabel.frame.height, height: titleLabel.frame.height)
        checkBtn.setImage(UIImage(named: "问号.png")?.withTintColor(UIColorFromRGB(250, green: 76, blue: 66)), for: UIControlState())
        checkBtn.addTarget(self, action: #selector(checkButtonAction), for: .touchUpInside)
        subView.addSubview(checkBtn)
        
        messageLabel = setupLabel(20, y: titleLabel.y + titleLabel.height, width: SCREEN_WIDTH  - 40, height: titleLabel.height, font: 12, textColor: UIColorFromRGB(115, green: 115, blue: 115), textAlignment: .center, text: "按照当前投资收益由高到低排列", ishaveBorder: false, view: subView)
        
        closeBtn = UIButton(type: .custom)
        closeBtn.frame = CGRect(x: SCREEN_WIDTH - 30, y: 5, width: 30, height: 30)
        closeBtn.setBackgroundImage(UIImage(named: "js_close_btn"), for: UIControlState())
        closeBtn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        subView.addSubview(closeBtn)
        
        //UITableView
        listView = UITableView(frame: CGRect.zero, style: UITableViewStyle.grouped)
        listView.separatorStyle = .none
        listView.delegate = self
        listView.dataSource = self
        listView.backgroundColor = UIColorFromRGB(230, green: 230, blue: 230)
        listView.tableFooterView = UIView()
        contentView.addSubview(listView)
    }
    
    //点击查看优惠券回调
    func checkButtonAction() -> () {
        self.dismissView() //先消失
        
        if self.checkCallback != nil {
            self.checkCallback!()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //UITableView坐标
        self.listView.frame = CGRect(x: 0, y: self.subView.frame.maxY, width: SCREEN_WIDTH,height: self.contentView.frame.height  - self.subView.frame.maxY)
    }
    
    //下载数据
    func loadDataFromServers(_ pid: Int,amount: Double) -> () {
        self.contentView.showLoadingHud()
        JSInvestDetailCouponApi(Uid: UserModel.shareInstance.uid ?? 0,Pid: pid,Amount: amount).startWithCompletionBlock(success: { (request: YTKBaseRequest!) -> Void in
            
            let resultDict = request.responseJSONObject as? [String: AnyObject]
            print("我的账户 - 首页数据\(resultDict)")
            self.couponModel = MyCouponsModel(dict: resultDict!)
            
            self.listView.reloadData()
            self.contentView.hideHud()
            self.displayIndicateWithCouponModel(self.couponModel) //开始配置messageLabel显示文字

        }) { (request: YTKBaseRequest!) -> Void in
            self.contentView.hideHud()
            self.showTextHud("网络错误")
        }
    }
    
    //显示头部视图
    func displayIndicateWithCouponModel(_ couponsModel: MyCouponsModel?) -> () {
        
        if couponsModel != nil {
            var flag: Int = 0
            if couponsModel!.map?.list.count >= 0 {
                for model in (couponsModel!.map?.list)! { //MyCouponsListModel
                    if model.status == 0 { //表示可使用
                        flag += 1
                    }
                }
            }
            
            if flag == 0 { //表示有无可以使用的优惠券
                messageLabel.text = "购买金额/项目期限未满足红包卡券使用条件"
                messageLabel.textColor = UIColorFromRGB(234, green: 57, blue: 65)
            } else {
                messageLabel.text = "按照当前投资收益由高到低排列"
                messageLabel.textColor = UIColorFromRGB(115, green: 115, blue: 115)
            }
        }
    }
    
    //MARK: - UITableViewDelegate,UITableViewDataSource
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.couponModel?.map != nil && self.couponModel?.map?.list != nil {
            return (couponModel?.map?.list.count)!
        }
        
        return 0
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectCouponCell") as! SelectCouponCell!
        if cell == nil{
            cell = SelectCouponCell(style: .default, reuseIdentifier: "SelectCouponCell")
        }
        
        cell?.configureCellWithCouponModel(couponModel?.map?.list[indexPath.row],selectListModel: self.selectCouponModel) //配置数据
        
        //显示第一个
        if indexPath.row == 0 {
            cell?.maxProfitImgView.isHidden = true
        } else {
            cell?.maxProfitImgView.isHidden = true
        }
        
        return cell!
    }
    
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115 * SCREEN_SCALE_W
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中第\(indexPath.row)个cell")
        
        let listModel = (couponModel?.map?.list[indexPath.row])!
        
        //状态未使用才能点击
        if listModel.status == 0 {
            if self.tapCallback != nil  {
                dismissView()
                self.tapCallback!(listModel) //点击回调
            }
        }
    }
    
    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    internal func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    //MARK: - 展示从底部向上弹出的UIView（包含遮罩）
    func showCouponView(_ view: UIView) {
        view.addSubview(self)

        contentView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: view.frame.size.height - self.margin)
        
//        位移动画
        let animation =  POPBasicAnimation()
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.property = POPAnimatableProperty.property(withName: kPOPLayerPositionY) as! POPAnimatableProperty
        animation.fromValue = SCREEN_HEIGHT + (view.frame.size.height - self.margin) / 2
        animation.toValue = self.margin + (view.frame.size.height - self.margin) / 2
        contentView.layer.pop_add(animation, forKey: "positionAnimation")
        
        //渐变动画
        let animation_1 =  POPBasicAnimation()
        animation_1.duration = 0.25
        animation_1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation_1.property = POPAnimatableProperty.property(withName: kPOPLayerOpacity) as! POPAnimatableProperty
        animation_1.fromValue = 0
        animation_1.toValue =  1
        self.layer.pop_add(animation_1, forKey: "OpacityKey")
    }
    
    //MARK: - 移除从上向底部弹下去的UIView（包含遮罩）
    func dismissView() {
        
         MobClick.event("0400016")
        
         contentView.frame = CGRect(x: 0, y: self.margin, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - self.margin)
        
        //移动动画
        let animation =  POPBasicAnimation()
        animation.duration = 0.25
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.property = POPAnimatableProperty.property(withName: kPOPLayerPositionY) as! POPAnimatableProperty
        animation.fromValue = self.margin + (self.frame.size.height - self.margin) / 2
        animation.toValue =  SCREEN_HEIGHT + (self.frame.size.height - self.margin) / 2
        contentView.layer.pop_add(animation, forKey: "positionAnimation")
        
        //渐变动画
        let animation_1 =  POPBasicAnimation()
        animation_1.duration = 0.3
        animation_1.delegate = self
        animation_1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation_1.property = POPAnimatableProperty.property(withName: kPOPLayerOpacity) as! POPAnimatableProperty
        animation_1.fromValue = 1
        animation_1.toValue =  0
        contentView.layer.pop_add(animation, forKey: "positionAnimation")
        self.layer.pop_add(animation_1, forKey: "OpacityKey")
        
        //所有的子视图增加渐变效果
        for view in contentView.subviews {
            view.layer.pop_add(animation_1, forKey: "OpacityKey")
        }
    }
    
    //MARK: POPAnimationDelegate
    func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
        if finished {
            self.removeFromSuperview()
        }
    }
    
    func setupLabel(_ x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,font:CGFloat,textColor:UIColor,textAlignment:NSTextAlignment,text:String,ishaveBorder:Bool,view:UIView) -> UILabel {
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
}
