//
//  JSChooseAddressPickView.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/3/10.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSChooseAddressPickView: UIView,UIPickerViewDelegate {

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var MiddlePickerView: UIPickerView!
    
    fileprivate var selectRow_0: Int = 0
    fileprivate var selectRow_1: Int = 0
    fileprivate var selectRow_2: Int = 0
    fileprivate var componentNumber: Int = 3 //默认是3个
    
    var pickViewCallback: ((_ provinceName: String?,_ cityName: String?,_ districtName: String?) -> ())?

    //取消活动
    @IBAction func cancelAction(_ sender: AnyObject) {
        JSChooseAddressPickView.animateRemoveFromSuperView(self, animate: true)        
    }
    
    /**
     *   视图添加(动画推出)
     */
    class func animateWindowsAddSubView() -> JSChooseAddressPickView {
        //创建pushView
        let pickerView = Bundle.main.loadNibNamed("JSChooseAddressPickView", owner: self, options: nil)?.last as? JSChooseAddressPickView
        pickerView?.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        pickerView!.bottomView.frame = CGRect(x: 0, y: SCREEN_HEIGHT, width: SCREEN_WIDTH, height: 250.0)
        pickerView?.backgroundColor = UIColor(red: 76.0/255.0, green: 76.0/255.0, blue: 76.0/255.0, alpha: 0.5)
        UIApplication.shared.keyWindow?.addSubview(pickerView!)
        
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
    class func animateRemoveFromSuperView(_ pickerView: JSChooseAddressPickView,animate: Bool) -> () {
        
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
        //省模型
        let provinceModel = JSProvinceManager.share().dataArray[selectRow_0] as! JSProvinceModel
        //城市模型
        let cityModel = provinceModel.cityArray[selectRow_1] as! JSCityModel
        //区、县
        let distriModel = cityModel.districtArray[selectRow_2] as! JSDistrictModel
        
        //回调
        if self.pickViewCallback != nil {
            self.pickViewCallback!(provinceModel.name,cityModel.name,distriModel.name)
            JSChooseAddressPickView.animateRemoveFromSuperView(self, animate: true)
        }
    }
    
    //MARK: UIPickerViewDelegate
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return self.componentNumber
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            
            return JSProvinceManager.share().dataArray.count
            
        } else if component == 1 {
            
            let provinceModel = JSProvinceManager.share().dataArray[selectRow_0] as! JSProvinceModel
            return provinceModel.cityArray.count
            
        } else if component == 2 {
            
            let provinceModel = JSProvinceManager.share().dataArray[selectRow_0] as! JSProvinceModel
            let cityModel = provinceModel.cityArray[selectRow_1] as! JSCityModel
            return cityModel.districtArray.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            
            let provinceModel = JSProvinceManager.share().dataArray[row] as! JSProvinceModel
            return provinceModel.name
            
        } else if component == 1 {
            
            let provinceModel = JSProvinceManager.share().dataArray[selectRow_0] as! JSProvinceModel
            let cityModel = provinceModel.cityArray[row] as! JSCityModel
            return cityModel.name
            
        } else if component == 2 {
            
            let provinceModel = JSProvinceManager.share().dataArray[selectRow_0] as? JSProvinceModel
            let cityModel = provinceModel!.cityArray[selectRow_1] as! JSCityModel
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
