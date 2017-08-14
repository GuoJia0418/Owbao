
//
//  WinningPersonController.swift
//  Owbao
//
//  Created by 一言难尽 on 2016/12/9.
//  Copyright © 2016年 wangyuxi. All rights reserved.
//

import UIKit

class WinningPersonController: BaseViewController,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var pid:Int = 0                      //产品id
    var vcType: Int = -1                 // 0: 未开奖   1：中奖者
    var prizerModel: PrizePersonModel?   //中奖者model
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "中奖者"
        self.loadDataFromServer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadDataFromServer() -> () {
        view.showLoadingHud()
        
        PrizePersonApi(Pid: pid).startWithCompletionBlock(success: { (request:YTKBaseRequest!) in
            self.view.hideHud()
            let resultDict = request.responseJSONObject as? [String:AnyObject]
            self.prizerModel = PrizePersonModel(dictionary: resultDict!)
            print("中奖者界面的数据\(resultDict) 一级是否手机 \(self.prizerModel!.success)")
        
            if self.prizerModel?.success == true {
                
                if self.prizerModel?.map?.list.count == 0 {
                    self.createNoPrizer()
                    self.view.hideHud()
                } else {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    self.view.hideHud()
                }
                
            } else {
                
                if self.prizerModel?.errorCode == "9999" {
                    self.view.showTextHud("系统错误")
                } else if self.prizerModel?.errorCode == "9998" {
                    //弹出登录控制器
                    JSLoginViewController.presentLoginControllerDismissGoHomeType(self)
                } else {
                    if self.prizerModel?.errorMsg != "" {
                        self.view.showTextHud((self.prizerModel?.errorMsg)!)
                    } else {
                        self.view.showTextHud("发生了未知错误")
                    }
                }
            }
            
        }) { (request: YTKBaseRequest!) in
            self.view.hideHud()
            self.view.showTextHud("网络错误,请稍后重试")
        }
    }
    //若没开奖，则创建该view
    func createNoPrizer() {
        self.tableView.isHidden = true
        self.view.backgroundColor = DEFAULT_GRAYCOLOR
        let x = (SCREEN_WIDTH - 110) / 2
        let y = 140 * SCREEN_WIDTH / 320
        let noPrizerImageView = UIImageView(frame: CGRect(x: x, y: y, width: 110, height: 120))
        noPrizerImageView.image = UIImage(named: "icon_noPrizer")
        self.view.addSubview(noPrizerImageView)
    }
    
    /**
     *  UITableViewDelegate / UITableViewDataSource
     */
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "WinningPersonTableViewCell") as? WinningPersonTableViewCell
        if cell == nil {
            cell = WinningPersonTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "WinningPersonTableViewCell")
        }
        //通过PrizePersonListModel来显示数据
        if self.prizerModel != nil {
            cell?.configCellWithModel((self.prizerModel?.map?.list[0])!)
        }
        //点击视频回调
        cell?.tapVideoCallback = {
            print("点击视频")
            if self.prizerModel?.map?.list.count != 0 {
                let model = (self.prizerModel?.map?.list)![0]
                if model.prizeVideoLink != nil && model.prizeVideoLink != "" {
                    let web = LocationController()
                    web.homeBtnIndex = 6
                    web.linkURL = model.prizeVideoLink
                    web.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(web, animated: true)
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.prizerModel != nil {
            return WinningPersonTableViewCell.cellHeightWithModel((self.prizerModel?.map?.list[0])!)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("WinningPersonController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
}
