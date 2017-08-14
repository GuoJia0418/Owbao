//
//  JSServiceCentreDisplayProblemController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSServiceCentreDisplayProblemController: BaseViewController {
    
    var dataModel: JSServiceCentreHotProblemModel?
    var titleString: String?
    var type: Int = 1
    
    //懒加载
    lazy var centreHeaderView: JSServiceCentreHeaderView = {
        let view = Bundle.main.loadNibNamed("JSServiceCentreHeaderView", owner: self , options:  nil)![1] as? JSServiceCentreHeaderView
        view?.backgroundColor = UIColor.white
        return view!
    }()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = titleString
        
        self.dataModel = JSServiceCentreHotProblemModel(modelType: self.type)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate / UITableViewDataSource
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "JSServiceCentreHeaderView") as? JSServiceCentreHeaderView
        if view == nil {
            
            view = Bundle.main.loadNibNamed("JSServiceCentreHeaderView", owner: self , options:  nil)![1] as? JSServiceCentreHeaderView
            view?.backgroundColor = UIColor.white
        }
        
        //配置模型
        view!.configureHeaderView(dataModel!.modelArray[section])
        //回调
        view!.tapCallBack = { (handleModel: JSServiceCentreHotProblemDetailModel) in
            self.dataModel!.modelArray[section] = handleModel
            self.tableView.reloadData()
        }
        
        return view!
    }
 
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataModel!.modelArray[section].isOpen {
            return 1
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        return dataModel!.modelArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        return JSServiceCentreDisplayTitleTableViewCell.getHeigth(dataModel!.modelArray[indexPath.section].detailTitle)
    }
    
     func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "JSServiceCentreDisplayTitleTableViewCell") as? JSServiceCentreDisplayTitleTableViewCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("JSServiceCentreDisplayTitleTableViewCell", owner: self, options: nil)![0] as? JSServiceCentreDisplayTitleTableViewCell
        }
        
        cell?.displayTitle.text = dataModel!.modelArray[indexPath.section].detailTitle
        return cell!
    }

    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSServiceCentreDisplayProblemController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }

}
