
//
//  JSInvitedViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/4/7.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSInvitedViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var invitedModel: JSInvitedModel?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "我的邀请"
        self.bottomButton.layer.cornerRadius = 4
        self.bottomButton.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        self.loadData()
    }

    @IBAction func bottomAction(_ sender: AnyObject) {
        
        if UserModel.shareInstance.isLogin == 0 { //弹出登录界面
            JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
            return
        }
        
        var image = UIImage(named: "shareThreeImage")
        let urlStr = URL(string: SHARE_ICON_URL)
        let data = try? Data(contentsOf: urlStr!)
        
        if data != nil {
            if UIImage(data: data!) != nil {
                image = UIImage(data: data!)!
            }
        }
        
        //分享给微信朋友模型
        let wxShareToFriendsModel = ShareInfoModel(shareImageURLString: "", shareImage: image!, shareURLString: BASE_URL + "/friendreg?recommCode=\((UserModel.shareInstance.mobilephone)!)", shareTitle: SHARE_TITLE5,shareDescription: SHARE_DESCRIPTION2)
        
        //分享到微信朋友圈模型
        let wxTimeLineModel = ShareInfoModel(shareImageURLString: "", shareImage: image!, shareURLString: BASE_URL + "/friendreg?recommCode=\((UserModel.shareInstance.mobilephone)!)", shareTitle: SHARE_TITLE5,shareDescription: SHARE_DESCRIPTION2)
        
        //分享到QQ用到的模型
        let qqModel = ShareInfoModel(shareImageURLString: SHARE_ICON_URL, shareImage: UIImage(), shareURLString: BASE_URL + "/friendreg?recommCode=\((UserModel.shareInstance.mobilephone)!)", shareTitle: SHARE_TITLE5,shareDescription: SHARE_DESCRIPTION2)
        
        //开始分享
        let view = InvitedBottowPushView.animateWindowsAddSubView(wxShareToFriendsModel, WXTimelineModel: wxTimeLineModel, QQModel: qqModel)
        
        //分享回调
        view.shareCallback = { (isSuccess: Bool) in
            
        }
    }
    
    //MARK: - 下载数据
    override func loadData() {
        self.loadDataFromServer()
    }
    
    func loadDataFromServer() -> () {

        let viewModel = JSInitedViewModel()
        self.view.showLoadingHud()
        
        viewModel.startLoadingData(JSInvitedApi(Uid: UserModel.shareInstance.uid ?? 0),
                                   controller: self,
                                   modelName: "JSInvitedModel",
                                   callback: { (returnValue) in
                                    
                                    self.invitedModel = returnValue as? JSInvitedModel
                                    self.tableView.reloadData()
                                    
            }) { (errorCode) in
                
                self.view.showTextHud(errorCode as! String)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvitedFirstTableViewCell") as! JSInvitedFirstTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvitedFirstTableViewCell", owner: self, options: nil)!.last as? JSInvitedFirstTableViewCell
            }
            
            cell?.tapActionCallback = {
                (URLString: String) in
                
                let controller = LocationController()
                controller.model = HomeBannerModel(dict: ["location": URLString as AnyObject,"title":"活动详情" as AnyObject])
                self.navigationController?.pushViewController(controller, animated: true)
            }
            cell?.configureCell(self.invitedModel)
            
            return cell!
            
        } else if indexPath.row == 1 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvitedRepeatedTableViewCell") as! JSInvitedRepeatedTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvitedRepeatedTableViewCell", owner: self, options: nil)!.last as? JSInvitedRepeatedTableViewCell
            }
            cell?.configureCell(self.invitedModel, index: 0)
            return cell!
            
        } else if indexPath.row == 2 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvitedRepeatedTableViewCell_1") as! JSInvitedRepeatedTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvitedRepeatedTableViewCell", owner: self, options: nil)!.last as? JSInvitedRepeatedTableViewCell
            }
            
            cell?.configureCell(self.invitedModel, index: 1)
            return cell!
            
        } else  {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSInvitedLastTableViewCell") as! JSInvitedLastTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSInvitedLastTableViewCell", owner: self, options: nil)!.last as? JSInvitedLastTableViewCell
            }
            cell?.configureCell(self.invitedModel)
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            
            return JSInvitedFirstTableViewCell.cellHeight()
            
        } else if indexPath.row == 1 {
            return JSInvitedRepeatedTableViewCell.cellHeight()
            
        } else if indexPath.row == 2 {
            
            return JSInvitedRepeatedTableViewCell.cellHeight()
        } else {
            return JSInvitedLastTableViewCell.cellHeight()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSInvitedViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
