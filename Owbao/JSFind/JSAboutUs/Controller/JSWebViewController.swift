//
//  JSWebViewController.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/7/18.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSWebViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var index: Int = 0  //0表示三亿验资  1表示保证金专户
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MAKR: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if index == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSImageTableViewCell") as? JSImageTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSImageTableViewCell", owner: self, options: nil)?.first as? JSImageTableViewCell
            }
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: "JSImageTableViewCell") as? JSImageTableViewCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("JSImageTableViewCell", owner: self, options: nil)?.last as? JSImageTableViewCell
            }
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return JSImageTableViewCell.cellHeight(index: self.index)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience  init() {
        let nibNameOrNil = String?("JSWebViewController")
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
