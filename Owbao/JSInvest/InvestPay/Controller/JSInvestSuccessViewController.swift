//
//  JSInvestSuccessViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/21.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  投资成功(正常标、iPhone7标、新手标三种类型）

import UIKit

class JSInvestSuccessViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    fileprivate var myInvestButton: UIButton!            //查看我的投资
    fileprivate var featureButton: UIButton!             //更多精选
    fileprivate var bottomWindow: UIWindow?               //显示弹窗的window

    //*********** 数据 *************//
    var detailModel: ProductDetailsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "投资成功"
        
        if detailModel != nil && detailModel.map != nil {
            if detailModel.map?.controllerType.rawValue == 1 {
                MobClick.event("0400025")
            } else if detailModel.map?.controllerType.rawValue == 2 {
                MobClick.event("0400046")
            }
        }

        self.popType = .reloadApp     //返回主界面
    }
    override func leftBarButtonItemAction() {
        super.leftBarButtonItemAction()
        
        if detailModel != nil && detailModel.map != nil {
            if detailModel.map?.controllerType.rawValue == 1 {
                MobClick.event("0400028")
            } else if detailModel.map?.controllerType.rawValue == 2 {
                MobClick.event("0400049")
            }
        }
        
    }
    //MARK: - UITableViewDelegate,UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {

        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return JSInvestSuccessMessageCell.numberRowForCell(self.detailModel)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return indexPath.section == 0 ? 120 * SCREEN_SCALE_W : 40 * SCREEN_SCALE_W
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 5 {
            return 80 * SCREEN_SCALE_W
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if self.detailModel != nil {
                self.firstCell?.configureCell((self.detailModel.map?.inputAmount)!)
            }
            
            return self.firstCell!
            
        } else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvestSuccessMessageCell") as! JSInvestSuccessMessageCell!
            
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvestSuccessMessageCell", owner: self, options: nil)?.first as? JSInvestSuccessMessageCell
            }
            
            //配置模型
            cell?.configureCellWithDetailModel(self.detailModel, indexPath: indexPath)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
           let controller = JSPrizeDetailViewController()
           controller.pid = (self.detailModel.map?.info?.id)!
           controller.investId = (self.detailModel.map?.investId)!
           self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
        return self.setupFooterView()
    }
    
    //MARK: - 放弃机会弹窗
    func showAbandonWindow()
    {
        let width = 301 * SCREEN_WIDTH / 320
        let height = 161 * SCREEN_WIDTH / 320
        let x = (SCREEN_WIDTH - width) / 2
        let y = (SCREEN_HEIGHT - height) / 2
        
        //黄色背景
        let bgView = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        bgView.layer.cornerRadius = 2.0
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = UIColorFromRGB(207, green: 207, blue: 207)
        
        let viewH = 160 * SCREEN_SCALE_W / 3
        for i in 0...2 {
            let view = UIView()
            view.x = 0
            view.width = width
            view.height = viewH
            view.backgroundColor = UIColor.white
            bgView.addSubview(view)
            
            if i == 0 {
                view.y = CGFloat(0)
                
                let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
                messageLabel.text = "提示"
                messageLabel.textColor = UIColor.black
                messageLabel.textAlignment = NSTextAlignment.center
                messageLabel.font = UIFont.systemFont(ofSize: 20 * SCREEN_WIDTH / 320)
                view.addSubview(messageLabel)
            }
            else if i == 1 {
                
                view.y = viewH
                //领取机会
                let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height))
                messageLabel.text = "领取机会仅一次,确定放弃？"
                messageLabel.textColor = DEFAULT_DARKGRAYCOLOR
                messageLabel.textAlignment = NSTextAlignment.center
                messageLabel.font = UIFont.systemFont(ofSize: 18 * SCREEN_WIDTH / 320)
                view.addSubview(messageLabel)
            }
            else
            {
                view.y = viewH * 2 + 1
                view.backgroundColor = UIColorFromRGB(207, green: 207, blue: 207)
                //两个button
                let btnWidth = (view.width - 1) / 2
                
                let abandonBtn = UIButton(type: .custom)
                abandonBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: view.height)
                abandonBtn.setTitle("放弃机会", for: UIControlState())
                abandonBtn.setTitleColor(DEFAULT_DARKGRAYCOLOR, for: UIControlState())
                abandonBtn.backgroundColor = UIColor.white
                abandonBtn.addTarget(self, action: #selector(JSInvestSuccessViewController.abandonClick(_:)), for: UIControlEvents.touchUpInside)
                view.addSubview(abandonBtn)
                
                let goOnBtn = UIButton(type: .custom)
                goOnBtn.frame = CGRect(x: abandonBtn.x + abandonBtn.width + 1, y: 0, width: btnWidth, height: view.height)
                goOnBtn.setTitle("我再想想", for: UIControlState())
                goOnBtn.setTitleColor(DEFAULT_ORANGECOLOR, for: UIControlState())
                goOnBtn.backgroundColor = UIColor.white
                goOnBtn.addTarget(self, action: #selector(cancelClickAction), for: UIControlEvents.touchUpInside)
                view.addSubview(goOnBtn)
            }
        }
        
        let cover = UIButton(frame: UIScreen.main.bounds)
        cover.backgroundColor = UIColor.black
        cover.alpha = 0.5
        
        let wd = UIWindow(frame: UIScreen.main.bounds)
        wd.windowLevel = UIWindowLevelAlert
        wd.addSubview(cover)
        wd.addSubview(bgView)
        wd.makeKeyAndVisible()
        
        bottomWindow = wd
    }

    
    //MARK: - 放弃机会
    func abandonClick(_ sender: UIButton) {
        self.cancelClickAction()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - 关闭弹窗
    func cancelClickAction() {
        self.bottomWindow?.isHidden = true
        self.bottomWindow = nil
    }
    
    //MARK: - 查看我的投资
    func seeMyInvest(_ sender: UIButton) {
        
        if detailModel != nil && detailModel.map != nil {
            if detailModel.map?.controllerType.rawValue == 1 {
                MobClick.event("0400026")
            } else if detailModel.map?.controllerType.rawValue == 2 {
                MobClick.event("0400047")
            }
        }

        let myInvestVC = JSMyInvestViewController()
        self.navigationController?.pushViewController(myInvestVC, animated: true)
    }
    
    //MARK: - 更多精选
    func moreFeature(_ sender: UIButton) { //返回列表
        
        if detailModel != nil && detailModel.map != nil {
            if detailModel.map?.controllerType.rawValue == 1 {
                MobClick.event("0400027")
            } else if detailModel.map?.controllerType.rawValue == 2 {
                MobClick.event("0400048")
            }
        }
        
        RootNavigationController.goToInvestList(controller: self)
    }
    
    //MARK: - 懒加载
    lazy var  firstCell: JSInvestSuccessFirstCell? = {
    
        let cell:JSInvestSuccessFirstCell = Bundle.main.loadNibNamed("JSInvestSuccessFirstCell", owner: self, options: nil)?.first as! JSInvestSuccessFirstCell
        cell.selectionStyle = .none
        return cell
    }()
    
    lazy var noviceFooterView: JSNoviceFooterView? = {
    
        let footerView: JSNoviceFooterView = Bundle.main.loadNibNamed("JSNoviceFooterView", owner: self, options: nil)?.first as! JSNoviceFooterView
        return footerView
    }()
    
    //MARK: - 非新手标的footerViewxx
    func setupFooterView()-> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 80 * SCREEN_SCALE_W))
        
        let buttonW = (SCREEN_WIDTH - 80)/2
        myInvestButton = UIButton(type: .custom)
        myInvestButton.frame = CGRect(x: 30, y: 40 * SCREEN_SCALE_W, width: buttonW, height: 40 * SCREEN_SCALE_W)
        myInvestButton.setTitle("查看我的投资", for: UIControlState())
        myInvestButton.setTitleColor(UIColorFromRGB(159, green: 159, blue: 159), for: UIControlState())
        myInvestButton.layer.cornerRadius = 5.0
        myInvestButton.layer.masksToBounds = true
        myInvestButton.layer.borderColor = UIColorFromRGB(159, green: 159, blue: 159).cgColor
        myInvestButton.layer.borderWidth = 1.0
        myInvestButton.backgroundColor = UIColor.white
        myInvestButton.addTarget(self, action: #selector(JSInvestSuccessViewController.seeMyInvest(_:)), for: .touchUpInside)
        view.addSubview(myInvestButton)
        
        featureButton = UIButton(type: .custom)
        featureButton.frame = CGRect(x: 20 + myInvestButton.width + myInvestButton.x, y: myInvestButton.y , width: buttonW, height: 40 * SCREEN_SCALE_W)
        featureButton.setTitle("更多精选", for: UIControlState())
        featureButton.setTitleColor(UIColor.white, for: UIControlState())
        featureButton.layer.cornerRadius = 5.0
        featureButton.layer.masksToBounds = true
        featureButton.backgroundColor = DEFAULT_REDCOLOR
        featureButton.addTarget(self, action: #selector(JSInvestSuccessViewController.moreFeature(_:)), for: .touchUpInside)
        view.addSubview(featureButton)
        
        return view
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvestSuccessViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
