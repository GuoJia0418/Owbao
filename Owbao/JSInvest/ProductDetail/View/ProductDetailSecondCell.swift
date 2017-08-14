//
//  ProductDetailSecondCell.swift
//  Owbao
//
//  Created by Feng Lu on 2017/2/14.
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
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ProductDetailSecondCell: UITableViewCell,UITextFieldDelegate {

    @IBOutlet weak var amountTextField: UITextField!        //金额输入框
    @IBOutlet weak var profitLabel: UILabel!         //收益
    @IBOutlet weak var inputViewTopConstains: NSLayoutConstraint! //输入框顶部约束
    @IBOutlet weak var leftTitleLabel: UILabel! //金额（元）label
    
    @IBOutlet weak var bottomBackgoundView: UIView! //底部收益label背景view
    @IBOutlet weak var bottomLineView: UIView!      //底部线条view
    
    @IBOutlet weak var rightChooseButton: UIButton! //右部选中/不选中按钮
    @IBOutlet weak var experienceBackgrounView: UIView! //触发体验金的背景view

    @IBOutlet weak var bottomBackgroundViewTopConstains: NSLayoutConstraint! //底部收益view顶部高度约束（注意：这个约束是相对于顶部金额输入框背景view）
    
    
    
    var beginInput: (()->())?                     //进入编辑状态
    var endInput: ((_ abc: String) ->())!           //金额输入完成
    var changeInput: ((_ abc: String) ->())!        //金额发生改变
    var noviceExceedingMaxLimit: ((_ maxLimitString: String) ->())!        //新手标用户输入超过最大的限制
    
    fileprivate var detailModel: ProductDetailsModel?  //保存的模型数据
    fileprivate var maxInvestAmount: Double = 5000     //最大的投资金额，若超过会触发体验金,暂时写死
    
    class func cellHeight(_ detailModel: ProductDetailsModel?) -> CGFloat {
        
        if detailModel != nil {
            
            //投即送、正常标、iPhone7活动标、新手标
            if detailModel!.map?.info?.status != 5 { //标的状态不为5时候 输入框关闭 ，需要改变cell的形状
                return 70.0
                
            } else {
                
                return 110.0
            }
        }
        
        return 170.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.amountTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: self.amountTextField)
    }
    
    @IBAction func rightButtonClickAction(_ sender: AnyObject) {
        //配置主动点击逻辑
        self.experienceChooseButtonSelected()
    }
    
    //正在输入且输入的为数字时候文字颜色black
    fileprivate func setTextFieldHighlightWhenInput(isInput: Bool?) {
        
        if isInput != nil {
            
            if isInput! {
                self.amountTextField.textColor = UIColor.black
            } else {
                self.amountTextField.textColor = UIColor.lightGray
            }
        }
    }
    
    //只要可以主动点击选择按钮，表示肯定 输入金额没有达到maxInvestAmount
    fileprivate func experienceChooseButtonSelected() -> () {
        
        self.rightChooseButton?.setImage(UIImage(named: "choosed"), for: UIControlState())
        self.rightChooseButton?.isEnabled = false  //不可点击
        
        //且当前输入金额大于条件金额
        if (amountTextField.text! as NSString).doubleValue >= self.maxInvestAmount { //投资金额大于最大的数目
            
        } else {
            amountTextField.text = "\(self.maxInvestAmount)"
        }
    }
    
    //根据体验金是否可用设置rightChooseButton是否可用
    fileprivate func setNewBgViewStatus() -> () {
        
        if amountTextField.text!.isNumber() {
            
            if (amountTextField.text! as NSString).doubleValue >= self.maxInvestAmount { //投资金额大于最大的数目
                self.rightChooseButton?.setImage(UIImage(named: "choosed"), for: UIControlState())
                self.rightChooseButton?.isEnabled = false  //不可点击
            } else {
                self.rightChooseButton?.setImage(UIImage(named: "unChoose"), for: UIControlState())
                self.rightChooseButton?.isEnabled = true  //可点击
            }
        }
    }
    
    //MARK: 通知
    func textFieldDidChange() {
        
        if self.changeInput != nil {
            
            //根据体验金是否可用，去显示不同状态
            self.setNewBgViewStatus()
            
            //输入金额时候修改文字颜色
            self.setTextFieldHighlightWhenInput(isInput: amountTextField.text?.isNumber())
            
            //如果为新手标，限制最大金额为1万
            self.setTextfieldMaxInputAmountNovice(isInput: amountTextField.text?.isNumber())
            
            self.changeInput(amountTextField.text!)
        }
    }
    
    //新手标输入金额设置最高上限
    fileprivate func setTextfieldMaxInputAmountNovice(isInput: Bool?) {
        
        if isInput != nil {
            
            if self.detailModel != nil && self.detailModel?.map?.controllerType == .novice && isInput == true {
                let inputAmount = NSString(string: amountTextField.text!)
                if  inputAmount.doubleValue > (self.detailModel?.map?.info?.maxAmount)! { //去提示
                    
                    //输入超过最大限制
                    if noviceExceedingMaxLimit != nil {
                       noviceExceedingMaxLimit!("\((self.detailModel?.map?.info?.maxAmount)!)")
                    }
                }
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //MARK: 刷新收益文字显示 selectCouponModel: 选中的红包
    func configureCell(_ detailModel: ProductDetailsModel?) -> () {
        
        if detailModel != nil {
            self.detailModel = detailModel //保存数据
            self.beginSetCellStatus(detailModel!) //开始设置cell状态
        }
    }
    
    //根据数据模型设置cell
    fileprivate func beginSetCellStatus(_ detailModel: ProductDetailsModel) -> () {
        
        if detailModel.map?.controllerType == .investGive { //投即送
            
            if detailModel.map?.info?.status != 5 { //标的状态不为5时候 输入框关闭 ，需要改变cell的形状
                self.viewsStatusWhileInvestEnd()  //开始改变cell状态
            } else {
                
                self.configureSubViewWithInvestGive((detailModel.map?.prize?.amount)!) //给标的投资额赋值
                
                //开始算出收益
                self.calculatedProfit(detailModel, selectCouponModel: detailModel.map?.selectCouponModel)
            }
            
        } else { //正常标、iPhone7活动标、新手标
            
            if detailModel.map?.info?.status != 5 { //标的状态不为5时候 输入框关闭 ，需要改变cell的形状
                self.viewsStatusWhileInvestEnd()
            } else {
                
                if detailModel.map?.controllerType == .novice {//1.新手标可用正常状态
                    self.subViewRenewNormalStatus_novice()
                } else { //1.正常标恢复可用正常状态
                    self.subViewRenewNormalStatus()
                }
                
                //2.记忆上次的输入
                if detailModel.map?.inputAmount != 0 {
                    self.amountTextField.text = "\(Int((detailModel.map?.inputAmount)!))" //设置成上次输入的数字
                } else {
                    self.amountTextField.text = "" //恢复初始化设置
                }
                
                //3.开始算出收益
                self.calculatedProfit(detailModel, selectCouponModel: detailModel.map?.selectCouponModel)
            }
        }
    }
    
    //计算收益，selectCouponModel为选中的红包，detailModel从控制器传过来的模型（并记忆用户输入金额、选中的红包）
    fileprivate func calculatedProfit(_ detailModel: ProductDetailsModel,
                                  selectCouponModel: MyCouponsListModel?) -> () {

        if detailModel.map?.inputAmount > 0 { //这里表示输入金额>0才能进行显示
            
            //detailModel是必选的,selectCouponModel是可选的
            var profitValue_1 = 0.00
            let rate = ((detailModel.map?.info?.rate)! + (detailModel.map?.info?.activityRate)!)
            let amount = (amountTextField.text! as NSString).doubleValue
            
            //算出收益
            profitValue_1 =  amount * (rate / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
            
            if selectCouponModel != nil { //表示选择了红包
                
                switch selectCouponModel!.type {
                case 1:  //返现券
                    
                    let profitValue_2 = (selectCouponModel?.amount)!
                    let attriString = NSMutableAttributedString(string: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))(返现红包)")
                    
                    attriString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: NSString(string: attriString.string).range(of: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))"))
                    
                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: attriString.string).range(of: "(返现红包)"))
                    
                    self.profitLabel.attributedText = attriString
                    break
                    
                case 2:  //加息券
                    
                    let profitValue_2 = (amountTextField.text! as NSString).doubleValue * (selectCouponModel!.raisedRates / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
                    
                    let attriString = NSMutableAttributedString(string: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))(加息收益)")
                    attriString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: NSString(string: attriString.string).range(of: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))"))
                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: attriString.string).range(of: "(加息收益)"))
                    
                    self.profitLabel.attributedText = attriString
                    
                    break
                case 3:   //体验金暂时没有
                    break
                case 4:  //翻倍券(只翻倍基础利率)
                    
                    let profitValue_2 = (amountTextField.text! as NSString).doubleValue * ((selectCouponModel!.multiple - 1) * (detailModel.map?.info?.rate)! / 360 / 100) * Double((detailModel.map?.info?.deadline)!)
                    
                    let attriString = NSMutableAttributedString(string: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))(翻倍收益)")
                    attriString.addAttribute(NSForegroundColorAttributeName, value: Global_red, range: NSString(string: attriString.string).range(of: "\(self.valueTransformatStandardString(profitValue_1))+\(self.valueTransformatStandardString(profitValue_2))"))
                    attriString.addAttribute(NSForegroundColorAttributeName, value: UIColor.darkGray, range: NSString(string: attriString.string).range(of: "(翻倍收益)"))
                    self.profitLabel.attributedText = attriString
                    
                    break
                default:
                    break
                }
                
            } else { //没有选择红包
                
                self.profitLabel.text = "\(self.valueTransformatStandardString(profitValue_1))"
            }
            
        } else { //如果没进行输入收益置为0
            
            self.profitLabel.text = "0.0"
        }
    }
    
    //当标可用，重新正常状态
    fileprivate func subViewRenewNormalStatus() {
        
        self.setTextFieldHighlightWhenInput(isInput: self.amountTextField.text?.isNumber())
        self.leftTitleLabel.textColor = UIColor.darkGray
        
        self.experienceBackgrounView.isHidden = true
        self.bottomBackgroundViewTopConstains.constant = 10
        
        self.amountTextField.placeholder = "\((self.detailModel?.map?.info?.leastaAmount)!)元起购买,\((self.detailModel?.map?.info?.increasAmount)!)元递增"
    }
    
    //当标可用，重新正常状态,新手标版
    fileprivate func subViewRenewNormalStatus_novice() {
        
        self.setTextFieldHighlightWhenInput(isInput: self.amountTextField.text?.isNumber())
        self.leftTitleLabel.textColor = UIColor.darkGray
        
        self.experienceBackgrounView.isHidden = true
        self.bottomBackgroundViewTopConstains.constant = 10
        
        self.amountTextField.placeholder = "\((self.detailModel?.map?.info?.leastaAmount)!)元起投,单笔最高\((self.detailModel?.map?.info?.maxAmount)!)元"
    }
    
    //当标不可用时，重新设置view
    fileprivate func viewsStatusWhileInvestEnd() -> () {
        self.amountTextField.text = "项目额度已募集结束"
        
        self.bottomBackgoundView.isHidden = true
        self.experienceBackgrounView.isHidden = true
        self.bottomLineView.isHidden = true
        
        self.setTextFieldHighlightWhenInput(isInput: self.amountTextField.text?.isNumber()) //设置输入框颜色
        self.leftTitleLabel.textColor = UIColor.lightGray
    }
    
    //标为投即送类型，重新设置子view
    fileprivate func configureSubViewWithInvestGive(_ inputAmount: Double) -> () {
        self.amountTextField.text = "\(inputAmount)"
        self.experienceBackgrounView.isHidden = true
        self.bottomBackgroundViewTopConstains.constant = 10
    }
    
    //标为iPhone7活动类型，重新设置子view
    fileprivate func configureSubViewWithIPhone7() -> () {
        self.experienceBackgrounView.isHidden = true
        self.bottomBackgroundViewTopConstains.constant = 10
    }
    
    //转换成标准的字符串
    fileprivate func valueTransformatStandardString(_ value: Double) -> String {
        return PD_NumDisplayStandard.standardString("\(value)", decimalPointType: 1, numVerification: false)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.endInput != nil {
            self.endInput!(amountTextField.text!)
        }
        //设置是否触发体验金使用条件
        self.setNewBgViewStatus()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location >= 8 {
            return false
        }
        
        if string.lengthOfBytes(using: String.Encoding.utf8) == 0 {
            return true
        }
        
//        //如果为新手标，限制最大金额为1万
//        if self.detailModel != nil && self.detailModel?.map?.controllerType == .novice {
//            
//            let inputAmount = NSString(string: textField.text!)
//            if  inputAmount.doubleValue >= 10000 {
//                return false
//            }
//        }
//        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        //如果标募集完成、投即送标，不能进行输入
        if self.detailModel != nil {
            
            if self.detailModel?.map?.info?.status == 5 && self.detailModel?.map?.controllerType != .investGive { //如果标不可投，禁止输入
                
                if self.beginInput != nil {
                    self.beginInput!()
                }
                
                return true
            }
        }
        
        return false
    }
}
