//
//  JSNoviceDetailViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/6/26.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//  新手标详情

import UIKit

class JSNoviceDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bottomButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bottomButton.layer.cornerRadius = 4
        self.bottomButton.layer.masksToBounds = true
        
        self.title = "新手专享标"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSNoviceTableViewCell_0") as! JSNoviceTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSNoviceTableViewCell", owner: self, options: nil)?[0] as! JSNoviceTableViewCell!
            }
            return cell!
            
        } else if indexPath.section == 1 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSNoviceTableViewCell_1") as! JSNoviceTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSNoviceTableViewCell", owner: self, options: nil)?[1] as! JSNoviceTableViewCell!
            }
            return cell!
            
        } else if indexPath.section == 2 {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSNoviceTableViewCell_2") as! JSNoviceTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSNoviceTableViewCell", owner: self, options: nil)?[2] as! JSNoviceTableViewCell!
            }
            return cell!
            
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSNoviceTableViewCell_3") as! JSNoviceTableViewCell!
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSNoviceTableViewCell", owner: self, options: nil)?[3] as! JSNoviceTableViewCell!
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JSNoviceTableViewCell.cellHeight(indexPath.section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 7.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.000001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
    @IBAction func buttonClickAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - 设置XIB
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSNoviceDetailViewController")
        self.init(nibName: nibNameOrNil, bundle: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
