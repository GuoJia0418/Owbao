//
//  JSSaveManagerAccountDetailViewController.swift
//  Owbao
//
//  Created by Feng Lu on 2017/5/25.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSSaveManagerAccountDetailViewController: BaseViewController {
    @IBOutlet weak var fuiouMobilePhoneLabel: UILabel!      //手机号
    @IBOutlet weak var fuiouNameLabel: UILabel!     //姓名
    @IBOutlet weak var fuiouIDCardsLabel: UILabel!     //身份证号
    @IBOutlet weak var fuiouBankImgView: UIImageView!       //银行卡
    @IBOutlet weak var resetFuiouTradePwdBtn: UIButton!     //重置交易密码
    var informationModel: MyInformationModel?            //账户信息
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "存管账户"
        self.refreshViews()
        
    }
    
    func refreshViews()
    {
        if informationModel != nil && informationModel?.map != nil
        {
            fuiouMobilePhoneLabel.text = informationModel?.map?.bankMobileFuiou
            fuiouNameLabel.text = informationModel?.map?.realName
            fuiouIDCardsLabel.text = informationModel?.map?.idCards
            fuiouBankImgView.image = UIImage(named: "\((self.informationModel?.map?.bankIdFuiou)!)")
        }
    }

    //MARK: - 重置存管交易密码
    @IBAction func resetFuiouTradePwdClick(_ sender: UIButton) {
        
        let viewModel = JSFuiouResetTradePwdViewModel()
        self.view.showLoadingHud()
        
        viewModel.requestServer(JSFuiouResetTradePwdApi(Uid: UserModel.shareInstance.uid!, Busi_tp: "3"), modelName: "JSFuiouResetTradePwdModel", callback: { (baseModel) in
            self.view.hideHud()
            let model = baseModel as! JSFuiouResetTradePwdModel
            
            if model.success == true
            {
                let web = CustodyWebViewController()
                web.navigationItem.title = "重置支付密码"
                let model_api = ApiModel()
                model_api.apiURL = model.map?.fuiouUrl
                model_api.postData = model.getFormString()
                web.apiModel = model_api
                self.navigationController?.pushViewController(web, animated: true)
            }
            else
            {
                self.view.showTextHud(model.errorMsg)
            }
            
        }) { (errorString) in
            
            self.view.hideHud()
            self.view.showTextHud(errorString)
        }
    }
    

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSSaveManagerAccountDetailViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }


}
