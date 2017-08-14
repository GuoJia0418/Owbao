//
//  JSChooseAddressPickView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/10.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSChoosePickView: UIView,UIPickerViewDelegate {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var MiddlePickerView: UIPickerView!
    
    fileprivate var selectRow_0: Int = 0
    fileprivate var selectRow_1: Int = 0
    fileprivate var selectRow_2: Int = 0
    fileprivate var dataArray = [JSProvinceModel]()
    
    
    var componentNumber: Int = 3 //默认是3个
    var pickViewCallback: ((_ provinceModel: JSProvinceModel?,_ cityModel: JSCityModel?,_ districtModel: JSDistrictModel?) -> ())?

    //取消活动
    @IBAction func cancelAction(_ sender: AnyObject) {
        JSChoosePickView.animateRemoveFromSuperView(self, animate: true)
    }
    
    /**
     *   视图添加(动画推出)
     */
    class func animateWindowsAddSubView(dataArray: [JSProvinceModel]) -> JSChoosePickView {
        
        //创建pushView
        let pickerView = Bundle.main.loadNibNamed("JSChoosePickView", owner: self, options: nil)?.last as? JSChoosePickView
        pickerView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        pickerView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 250.0)
        pickerView?.backgroundColor = UIColor(red: 76.0/255.0, green: 76.0/255.0, blue: 76.0/255.0, alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(pickerView!)
        pickerView?.dataArray = dataArray //保存数据
        
        //动画般显示pushView
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            pickerView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT - 250.0, width: SCREEN_WIDTH, height: 250.0);
        }) { finished -> () in
        }
        
        return pickerView!
    }
    
    /**
     *  视图移除(动画般从上向下移除)
     */
    class func animateRemoveFromSuperView(_ pickerView: JSChoosePickView,animate: Bool) -> () {
        
        if animate == true {
            
            UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: {
                pickerView.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH,height: 250.0);
            }) { finished ->() in
                pickerView.removeFromSuperview()
            }
            
        } else {
            pickerView.removeFromSuperview()
        }
    }
    
    func reloadView(_ componentNumber: Int) -> () {
        self.componentNumber = componentNumber
        self.MiddlePickerView.reloadAllComponents()
    }
    
    @IBAction func conformAction(_ sender: AnyObject) {
        
        if self.componentNumber == 3 {
            //省模型
            let provinceModel = dataArray[selectRow_0]
            //城市模型
            let cityModel = provinceModel.cityArray[selectRow_1] as! JSCityModel
            //区、县
            let distriModel = cityModel.districtArray[selectRow_2] as! JSDistrictModel
            
            if self.pickViewCallback != nil {
                self.pickViewCallback!(provinceModel,cityModel,distriModel)
                JSChoosePickView.animateRemoveFromSuperView(self, animate: true)
            }
            
        } else if self.componentNumber == 2 {
            
            //省模型
            let provinceModel = dataArray[selectRow_0]
            //城市模型
            let cityModel = provinceModel.cityArray[selectRow_1] as! JSCityModel
            
            if self.pickViewCallback != nil {
                self.pickViewCallback!(provinceModel,cityModel,nil)
                JSChoosePickView.animateRemoveFromSuperView(self, animate: true)
            }
            
        } else {
            
            //省模型
            let provinceModel = dataArray[selectRow_0]
            
            if self.pickViewCallback != nil {
                self.pickViewCallback!(provinceModel,nil,nil)
                JSChoosePickView.animateRemoveFromSuperView(self, animate: true)
            }
        }
    }
    
    //MARK: UIPickerViewDelegate
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return self.componentNumber
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return dataArray.count
            
        } else if component == 1 {
            
            if dataArray.count > 0 {
                let provinceModel = dataArray[selectRow_0]
                return provinceModel.cityArray.count
            }
            
        } else if component == 2 {
            
            if dataArray.count > 0 {
                
                let provinceModel = dataArray[selectRow_0]
                
                if provinceModel.cityArray.count > 0 {
                    let cityModel = provinceModel.cityArray[selectRow_1] as! JSCityModel
                    return cityModel.districtArray.count
                }
            }
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            let provinceModel = dataArray[row]
            return provinceModel.name
            
        } else if component == 1 {
            
            let provinceModel = dataArray[selectRow_0]
            let cityModel = provinceModel.cityArray[row] as! JSCityModel
            return cityModel.name
            
        } else if component == 2 {
            
            let provinceModel = dataArray[selectRow_0]
            let cityModel = provinceModel.cityArray[selectRow_1] as! JSCityModel
            let distriModel = cityModel.districtArray[row] as! JSDistrictModel
            return distriModel.name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            
            selectRow_0 = row
            selectRow_1 = 0  //重置上次选择，防止数组越界
            selectRow_2 = 0  //重置上次选择，防止数组越界
            
            if self.componentNumber == 3 {
                pickerView.reloadComponent(1)
                pickerView.reloadComponent(2)
            } else if self.componentNumber == 2 {
                pickerView.reloadComponent(1)
            }
            
        } else if component == 1 {
            selectRow_1 = row
            selectRow_2 = 0  //重置上次选择，防止数组越界
            
            if self.componentNumber == 3 {
                pickerView.reloadComponent(2)
            }
            
        } else {
            selectRow_2 = row
        }
    }
}
