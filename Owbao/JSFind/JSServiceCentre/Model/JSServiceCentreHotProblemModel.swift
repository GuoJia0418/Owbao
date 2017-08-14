//
//  JSServiceCentreHotProblemModel.swift
//  Owbao
//
//  Created by 一言难尽 on 2017/2/22.
//  Copyright © 2017年 xiaofeng. All rights reserved.
//

import UIKit

class JSServiceCentreHotProblemModel: NSObject {
    
     var modelArray =  [JSServiceCentreHotProblemDetailModel]()

    //0: 热门问题 1:认证注册  2：安全保障 3： 充值提现 4：投资福利 5：产品介绍 6：其他问题
    required init(modelType: Int) {
        super.init()
        self.configureData(modelType)
    }
    
    func configureData(_ type: Int) -> () {
        
        if type == 0 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "1.请登录http://www.jushengcaifu.com，然后点击右上角的“注册”，根据  指引一步步操作即可。\n2.关注微信公众号“嗷呜宝官微”，进行注册也可以。\n3.请到appstore 或者应用宝上直接搜索“嗷呜宝”，下载手机应用进行注册也可以。"
            model_0.title = "如何注册成为嗷呜宝的会员？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "银行存管是指按照有关法律、法规的规定，客户交易结算资金统一交由独立于平台的第三方存管机构来存管。第三方存管机构是指具备第三方存管资格的商业银行。存管银行按照法律、法规的要求，负责客户资金的存取与资金交收，平台交易操作保持不变。"
            model_1.title = "什么是银行存管？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "进入“我的账户”，点击【充值】按钮，进入充值页面，输入相应的信息进行充值。"
            model_2.title = "如何充值？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "成功注册投资即送666元新人专享现金红包。"
            model_3.title = "注册是否有红包？"
            modelArray.append(model_3)
            
            //5.
            let model_4 = JSServiceCentreHotProblemDetailModel()
            model_4.detailTitle = "财胜150的产品：最低800元起投，产品总额24万，投资周期是150天，预期基础年化利率9%.（投资就有机会抽中iphone7）"
            model_4.title = "财胜150是怎么样的产品，收益是多少？"
            modelArray.append(model_4)
            
            //6.
            let model_5 = JSServiceCentreHotProblemDetailModel()
            model_5.detailTitle = "投标前请认真分析所投资标的详细信息（起投金额，年化利率，投资期限等），以确定您所要投的标符合您的风险承受能力和所要求的投资回报率。"
            model_5.title = "投标前需要注意什么？"
            modelArray.append(model_5)
            
        } else if type == 1 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "银行存管是指按照有关法律、法规的规定，客户交易结算资金统一交由独立于平台的第三方存管机构来存管。第三方存管机构是指具备第三方存管资格的商业银行。存管银行按照法律、法规的要求，负责客户资金的存取与资金交收，平台交易操作保持不变。"
            model_0.title = "什么是银行存管？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "根据《关于促进互联网金融健康发展的指导意见》“（十四）客户资金第三方存管制度。除另有规定外，从业机构应当选择符合条件的银行业金融机构作为资金存管机构，对客户资金进行管理和监督，实现客户资金与从业机构自身资金分账管理。”银行存管是指用户在P2P平台上的交易资金交由银行进行管理，平台无法接触交易资金的一种资金管理模式。借款人、投资人和平台通过在银行方开设存管账户，来实现交易和资金的结算。"
            model_1.title = "为什么需要银行存管？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "1)系统分账监管\n嗷呜宝接入天府银行存管系统后，将由天府银行对您的交易资金及平台自有运营资金进行分账监管，二者完全独立且相互隔离，平台无法触碰您的资金。\n2)用户资金存管\n您进行的充值、绑卡、提现等每一笔与资金有关的操作，均需通过天府银行资金存管账户，由天府银行对您的资金信息进行管理，避免您的资金出现被挪用风险。\n3)用户授权操作\n您需要开通天府银行存管账户，并在天府银行存管页面单独设立交易密码。在进行任何与资金相关操作时，系统会验证密码，在得到您的授权后，由银行根据交易指令进行资金划转。\n4)交易真实有效\n天府银行根据合同约定及您发出的交易指令，对交易流程进行管理并对所有资金流水进行存档记录，确保借贷双方的资金流转和债权关系清晰明确。"
            model_2.title = "银行存管有什么优势？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "新用户：新用户注册账户成功后，进入我的账户-选择账户管理-安全认证前往天府银行页面开通存管账户，存管账户开通需用户提供真实姓名、身份证号、银行卡号、银行卡预留手机号码，并设置天府银行存管账户交易密码。开通成功后会自动跳转回嗷呜宝理财页面。\n老用户（有待收待还）：存管上线后，未激活天府银行存管账户的老用户在登录嗷呜宝网站或APP用户端后，进入我的账户-可通过指引前往天府银行页面开通存管账户，按照流程操作依次进行银行预留手机号填写、交易密码设置，即可成功激活存管账户。"
            model_3.title = "如何开通银行存管账户？"
            modelArray.append(model_3)
            
            //5.
            let model_4 = JSServiceCentreHotProblemDetailModel()
            model_4.detailTitle = "存管后您的交易资金将直接流向天府银行，由银行进行监管，平台无法触碰您的账户资金；您进行的任何充值、绑卡、提现等与资金相关的操作，均在天府银行存管页面进行，由银行对您的资金信息进行管理，资金及操作更加安全无忧。"
            model_4.title = "银行存管上线以后对我们的资金有什么影响？"
            modelArray.append(model_4)
            
            //6.
            let model_5 = JSServiceCentreHotProblemDetailModel()
            model_5.detailTitle = "银行存管后嗷呜平台会分为平台账户和存管账户，平台账户保留用户原账号下的账户余额，只可用于提现，目前到账时间为工作日16点前的提现申请当天到账；工作日16点后的提现申请，顺延至下个工作日（具体到账时间以银行处理时间为准）。\n存管账户提现天府银行会在收到提现申请的当日受理，下一个工作日到账，即T+1；遇双休日、国家法定节假日，到账日期顺延。"
            model_5.title = "银行存管上线后对提现有什么影响？"
            modelArray.append(model_5)
            
        } else if type == 2 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "1)系统分账监管\n嗷呜宝接入天府银行存管系统后，将由天府银行对您的交易资金及平台自有运营资金进行分账监管，二者完全独立且相互隔离，平台无法触碰您的资金。\n2)用户资金存管\n您进行的充值、绑卡、提现等每一笔与资金有关的操作，均需通过天府银行资金存管账户，由天府银行对您的资金信息进行管理，避免您的资金出现被挪用风险。\n3)用户授权操作\n您需要开通天府银行存管账户，并在天府银行存管页面单独设立交易密码。在进行任何与资金相关操作时，系统会验证密码，在得到您的授权后，由银行根据交易指令进行资金划转。\n4)交易真实有效\n天府银行根据合同约定及您发出的交易指令，对交易流程进行管理并对所有资金流水进行存档记录，确保借贷双方的资金流转和债权关系清晰明确。"
            model_0.title = "银行存管有什么优势？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "嗷呜宝推荐的每一款产品均有相对应的资产，对借款企业信息进行详细的纰漏，同时对借款企业进行贷前贷中贷后管理。"
            model_1.title = "借款项目如何审核与管理？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "嗷呜宝特聘大成和金诚同达顶级律师事务所专家团与权威法律顾问团队,为嗷呜商业模式的合法性、交易模式的合规性提供法律支持。"
            model_2.title = "平台是否有专业法律支持？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "1.原始债务企业为第一还款人，负有还款责任。\n2.当原始债务企业出现还款逾期时，原始债务企业的实际控制人承担无限连带保证责任，为第二还款人，负有还款责任。\n3.当第一、第二还款人出现还款逾期时，签订过商业保理协议业务的商业保理公司为第三还款人，负有还款责任。\n4.当以上还款人出现还款逾期时，签订过担保协议的担保公司为第四还款人，负有还款责任。"
            model_3.title = "如果出现还款逾期，平台怎么保证投资者的利益"
            modelArray.append(model_3)
            
            //5.
            let model_4 = JSServiceCentreHotProblemDetailModel()
            model_4.detailTitle = "3000万存款保障银行账户千万级存款保障，逾期先行垫付，为平台用户提供最贴心和安全的服务。（可查看资信证明书）"
            model_4.title = "嗷呜宝是否有银行存款保障？"
            modelArray.append(model_4)
            
            //6.
            let model_5 = JSServiceCentreHotProblemDetailModel()
            model_5.detailTitle = "1.层层审核，仅筛选优质借款人.规范筛选优质项目，实地考核审查。\n2.全程监管，保障资金安全。贷后监控管理，签订法律协议。\n3.多重防线，有效抵御风险，快速专业催款，足额抵押变现。追缴清收。"
            model_5.title = "平台风控如何？"
            modelArray.append(model_5)
            
        } else if type == 3 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "进入“我的账户”，点击【充值】按钮，进入充值页面，输入相应的信息进行充值。"
            model_0.title = "如何充值？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "投资者充值免费，嗷呜宝不收取手续费。"
            model_1.title = "充值是否收费？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "情况一、部分银行对单笔单天支出的金额有限制的。可参见网站上的银行信息。\n情况二、使用快捷支付方式也是有限额的。如果超过限额，可以使用网银支付。"
            model_2.title = "充值出现最高限额是怎么回事？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "（出现此类情况，需要联系技术人员核实）。\n使用快捷方式的情况下：\n情况一、掉单。即客户显示扣款，但是我们这边充值没有成功。此种情况下，一般是银行通信问题，第二天，未达成的交易会在原路退回到客户账户的。\n情况二、充值延时。充值一般2分钟以内会到账，延时情况会半小时左右。\n使用网银充值的情况下：\n银行插件不兼容。需要清除浏览器缓存，安装好插件后，重启浏览器。"
            model_3.title = "充值失败怎么处理？"
            modelArray.append(model_3)
            
            //5.
            let model_4 = JSServiceCentreHotProblemDetailModel()
            model_4.detailTitle = "登录个人账户，打开“我的账户”，点击“提现”；"
            model_4.title = "如何提现？"
            modelArray.append(model_4)
            
            //6.
            let model_5 = JSServiceCentreHotProblemDetailModel()
            model_5.detailTitle = "嗷呜宝使用银行资金存管模式，预计T+1个工作日内到账，如遇节假日顺延（具体到账时间以银行处理时间为准）"
            model_5.title = "提现后什么时候到账？"
            modelArray.append(model_5)
            
            //7.
            let model_6 = JSServiceCentreHotProblemDetailModel()
            model_6.detailTitle = "每位用户每月可享受2次免费提现，超出后提现手续费为2元/笔，手续费将从您的账户余额中扣除。"
            model_6.title = "提现怎么收费？"
            modelArray.append(model_6)
            
            //8.
            let model_7 = JSServiceCentreHotProblemDetailModel()
            model_7.detailTitle = "为了保障平台用户的资金安全，用户在平台充值和提现必须使用同一张银行借记卡（即只能是用户注册时绑定的银行卡），不可以提现至别人的账户的。"
            model_7.title = "可以提现至别人的银行账户吗？"
            modelArray.append(model_7)
            
            //9.
            let model_8 = JSServiceCentreHotProblemDetailModel()
            model_8.detailTitle = "1. 提现的银行卡在平台预留的银行信息有误；\n2. 绑定银行卡进行了注销。\n\n如不属上述情况，可咨询在线客服，询问具体原因。"
            model_8.title = "何种情况会造成提现失败？"
            modelArray.append(model_8)
            
            //10.
            let model_9 = JSServiceCentreHotProblemDetailModel()
            model_9.detailTitle = "投资人成功投标后是无法申请提前收款的。投资成功后，金额是有一个固定期限的，固定期结束后，才能获得返还"
            model_9.title = "投资后能不能提前收款？"
            modelArray.append(model_9)
            
        } else if type == 4 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "成功注册投资即送666元新人专享现金红包。"
            model_0.title = "注册是否有红包？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "成功注册即送100000元体验金。"
            model_1.title = "成功注册是否有体验金？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "复投不定时会有红包，用户可随时关注平台及资金账户。"
            model_2.title = "复投是否有复投红包？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "活动专区会推出优惠活动，将用户投资的利益最大化。"
            model_3.title = "平台是否有优惠活动？"
            modelArray.append(model_3)
            
        } else if type == 5 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "小胜30的产品：最低100元起投，产品总额100万，投资周期是35天，历史基础年化收益率6%."
            model_0.title = "小胜30是怎么样的产品，收益是多少？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "中胜60的产品：最低100元起投，产品总额50万，投资周期是60天，历史基础年化收益率7.5%."
            model_1.title = "中胜60是怎么样的产品，收益是多少？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "财胜150的产品：最低800元起投，产品总额24万，投资周期是150天，历史基础年化收益率9%.（投资就有机会抽中iphone7）"
            model_2.title = "财胜150是怎么样的产品，收益是多少？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "中胜180的产品：最低100元起投，产品总额30万，投资周期是180天，历史基础年化收益率10.5%."
            model_3.title = "中胜180是怎么样的产品，收益是多少？"
            modelArray.append(model_3)
            
            //5.
            let model_4 = JSServiceCentreHotProblemDetailModel()
            model_4.detailTitle = "嗷呜宝会不定期推出优惠活动，为用户推出优惠产品，使用户的收益最大化。用户可以随时关注平台活动。"
            model_4.title = "平台是否还有其他产品？"
            modelArray.append(model_4)
            
            
            //7.
            let model_6 = JSServiceCentreHotProblemDetailModel()
            model_6.detailTitle = "针对在嗷呜宝注册的新用户，使用嗷呜宝的体验金进行投资，标的为虚拟体验，可产生投资收益。体验金收益需要完成一次真实投资后才可提现。"
            model_6.title = "什么是体验标？"
            modelArray.append(model_6)
            
            //8.新手标上线后添加
//            let model_7 = JSServiceCentreHotProblemDetailModel()
//            model_7.detailTitle = "新手专享标：每位新用户仅有一次投资机会，100元起投，单笔投资最高限额20,000元，投资周期是7天，历史基础年化利率5%."
//            model_7.title = "新手专享标是怎么样的产品，收益是多少？"
//            modelArray.append(model_7)
            
        } else if type == 6 {
            
            //1.
            let model_0 = JSServiceCentreHotProblemDetailModel()
            model_0.detailTitle = "投标前请认真分析所投资标的详细信息（起投金额，年化利率，投资期限等），以确定您所要投的标符合您的风险承受能力和所要求的投资回报率。"
            model_0.title = "投标前需要注意什么？"
            modelArray.append(model_0)
            
            //2.
            let model_1 = JSServiceCentreHotProblemDetailModel()
            model_1.detailTitle = "打开“嗷呜宝”的首页，直接点击“我要投资”按钮；进入标的详情页，根据用户自己所需标的条件筛选后进行投资。"
            model_1.title = "如何投标？"
            modelArray.append(model_1)
            
            //3.
            let model_2 = JSServiceCentreHotProblemDetailModel()
            model_2.detailTitle = "目前平台暂时未收取佣金。"
            model_2.title = "投资是否需要收取佣金？"
            modelArray.append(model_2)
            
            //4.
            let model_3 = JSServiceCentreHotProblemDetailModel()
            model_3.detailTitle = "投资第二天开始计息，产品满标后第二天起息。"
            model_3.title = "投标后什么时候开始计息？"
            modelArray.append(model_3)
            
            //5.
            let model_4 = JSServiceCentreHotProblemDetailModel()
            model_4.detailTitle = "1.点击登录页面的忘记密码链接。\n2.填写注册时使用的手机号码，点击获取验证码。\n3.输入发送手机上的验证码和新设的密码，完成重置密码设置。"
            model_4.title = "如何找回登录密码？"
            modelArray.append(model_4)
            
            //6.
            let model_5 = JSServiceCentreHotProblemDetailModel()
            model_5.detailTitle = "目前平台的还款方式有一种：“到期一次性还清本息”。"
            model_5.title = "平台目前有几种还款方式？"
            modelArray.append(model_5)
            
            //7.
            let model_6 = JSServiceCentreHotProblemDetailModel()
            model_6.detailTitle = "平台投资回款有短信通知的服务。"
            model_6.title = "投资回款有短信通知吗？"
            modelArray.append(model_6)
            
            //8.
            let model_7 = JSServiceCentreHotProblemDetailModel()
            model_7.detailTitle = " 情况：1. 页面不断加载 。 2.没有网络。 3.手机硬件和软件不兼容。\n解决方案：1.建议退出APP重新\n登录 2. 卸载APP重新下载安装  3.重启手机在网络环境好的情况下尝试 。\n若以上方法都不能解决，及时联系客服提交技术处理。"
            model_7.title = "APP软件出现闪退有哪些情况及解决方案？"
            modelArray.append(model_7)
        }
    }
}

class JSServiceCentreHotProblemDetailModel: NSObject {
    var isOpen: Bool = false //true打开，false关闭
    var detailTitle: String = "xxxx"
    var title: String = "xxxx?"
}
