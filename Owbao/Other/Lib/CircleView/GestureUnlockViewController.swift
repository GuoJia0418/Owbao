import UIKit

class GestureUnlockViewController: UIViewController {
    // mark = 初始化都在这里...统一管理
    var state: GestureUnlockState! {
        didSet{
            stateInit()
        }
    }
    var tpsw: String!
    var unlock: Unlock!
    //var rightBtn: UIBarButtonItem!
    var unlockInfo: UnlockInfo!
    var unlockLabel: UnlockLabel!
    var welcomeLabel: UILabel!           //欢迎词
    var wrongCnt = 0
    
    var setSuc: ((String)->Void)?
    var transitorilyNotSet:(() -> ())?  //暂不设置
    var verifyResult: ((Bool)->Void)?
    var resetResult: ((Bool)->Void)?
    
    /*
     lufeng 改。。。7.1，navigationbar去掉,加其他填充控件
     */
    var titleLabel:UILabel!             //标题
    var backButton:UIButton!            //返回
    var rightButton:UIButton!           //右按钮
    var accountLoginButton:UIButton!    //账户登录button

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = CommonConfig.GestureUnlockViewController.backgroundColor
        

        prepare()
//        stateInit()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func createView(){
        
        let textFont:CGFloat = 15
        
        titleLabel = UILabel()
        let titleLabelWidth:CGFloat = 200
        titleLabel.frame = CGRect(x: (SCREEN_WIDTH - titleLabelWidth) / 2, y: 20, width: titleLabelWidth, height: 44)
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.textColor = UIColor.white
        self.view.addSubview(titleLabel)
        
        backButton = UIButton()
        backButton.frame = CGRect(x: 20, y: SCREEN_HEIGHT - 50 * SCREEN_WIDTH / 320, width: 80, height: 30 * SCREEN_WIDTH / 320)
        //backButton.setImage(UIImage(named: "icon_arrows"), forState: UIControlState.Normal)
        backButton.setTitle("暂不设置", for: UIControlState())
        backButton.setTitleColor(UIColor.white, for: UIControlState())
        backButton.addTarget(self, action: #selector(GestureUnlockViewController.backClick), for: UIControlEvents.touchUpInside)
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: textFont)
        self.view.addSubview(backButton)
        
        rightButton = UIButton()
        rightButton.frame = CGRect(x: SCREEN_WIDTH - 16 - 80, y: SCREEN_HEIGHT - 50 * SCREEN_WIDTH / 320, width: 80, height: 30 * SCREEN_WIDTH / 320)
        rightButton.addTarget(self, action: #selector(GestureUnlockViewController.reset), for: UIControlEvents.touchUpInside)
        rightButton.setTitle("重新绘制", for: UIControlState())
        rightButton.setTitleColor(UIColor.white, for: UIControlState())
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: textFont)
        self.rightButton.isHidden = true
        self.view.addSubview(rightButton)
        
        let accountLoginButtonWidth:CGFloat = 200
        
        accountLoginButton = UIButton(frame: CGRect(x: (SCREEN_WIDTH - accountLoginButtonWidth) / 2, y: SCREEN_HEIGHT - 50 * SCREEN_WIDTH / 320, width: accountLoginButtonWidth, height: 30 * SCREEN_WIDTH / 320))
        accountLoginButton.isHidden = true
        accountLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: textFont)
        accountLoginButton.setTitle("使用账号登录", for: UIControlState())
        accountLoginButton.setTitleColor(UIColor.white, for: UIControlState())
        accountLoginButton.addTarget(self, action: #selector(GestureUnlockViewController.loginAction), for: UIControlEvents.touchUpInside)
        self.view.addSubview(accountLoginButton)
    }
    
    func loginAction() { //获取到根控制器
        self.navigationController?.pushViewController(JSLoginViewController.getLoginControllerDismissGoHome(), animated: true)
    }
    
    func backClick() {
        self.dismiss(animated: true, completion: nil)
        transitorilyNotSet?()
    }
    
    func stateInit() {
    
        switch self.state! {
    
        case GestureUnlockState.set:
            tpsw = nil
            unlock?.processClear()
            unlockInfo?.state = .normal
            unlockInfo?.isHidden = false
            unlockLabel?.showNormalMsg("绘制手势图案")
            titleLabel.text = "设置手势密码"
            
        case GestureUnlockState.verify:
            //获取tpsw
           
            tpsw = Defaults.object(forKey: "GesturePassword") as! String
            unlock?.processClear()
            unlockInfo?.isHidden = true
            unlockLabel?.showNormalMsg("请输入手势密码")
            wrongCnt = 0
            titleLabel.text = "验证手势密码"
            self.backButton.isHidden = true
            self.rightButton.isHidden = true
            self.accountLoginButton.isHidden = false
            welcomeLabel.isHidden = false
            
        case GestureUnlockState.reset:
            tpsw = Defaults.object(forKey: "GesturePassword") as! String
            unlock?.processClear()
            unlockInfo?.isHidden = true
            unlockLabel?.showNormalMsg("请输入原手势密码")
            wrongCnt = 0
            titleLabel.text = "重设手势密码"
            welcomeLabel.isHidden = false
        }
        
    }
}
// mark - view prepare
extension GestureUnlockViewController {
    func prepare(){
        unlock = Unlock()
        unlock.result = {
            psw in
            if psw.characters.count < 4{
                self.unlockLabel.showWarnMsgAndShake("最少连接4个点，请重新输入")
                self.unlock.processWrong()
                return
            }
            switch self.state!{
            case GestureUnlockState.set:
                self.processSet(psw)
                return
            case GestureUnlockState.verify:
                self.processVerify(psw)
                return
            case GestureUnlockState.reset:
                self.processReset(psw)
                return
            }
        }
        self.view.addSubview(unlock)
        
        unlockInfo = UnlockInfo()
        self.view.addSubview(unlockInfo)
        
        unlockLabel = UnlockLabel()
        self.view.addSubview(unlockLabel)
        
        welcomeLabel = UILabel(frame:CGRect(
            x: 0,
            y: UIScreen.main.bounds.size.height * 1.25 / 5,
            width: UIScreen.main.bounds.size.width,
            height: 14))
        let phoneText = "\((UserModel.shareInstance.mobilephone)!)".phoneNoAddAsterisk()
        welcomeLabel.text = "\(phoneText),欢迎回来！"
        let fontSizeRadio: CGFloat = 0.04
        let fontSize = UIScreen.main.bounds.size.width * fontSizeRadio
        welcomeLabel.font = UIFont.systemFont(ofSize: fontSize)
        welcomeLabel.textColor = UIColor.white
        welcomeLabel.isHidden = true
        welcomeLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(welcomeLabel)
    }
}
// mark - process
extension GestureUnlockViewController{
    func processSet(_ psw: String){
        if tpsw == nil {
            tpsw = psw
            unlock.processRight()
            unlockInfo.state = UnlockInfoState.selected(psw)
            unlockLabel.showWarnMsg("再次绘制解锁图案")
            rightButton.isHidden = false
        } else if tpsw == psw {
            setSuc!(psw)

            self.dismiss(animated: true, completion: { 
                
            })

        } else {
            //self.navigationItem.rightBarButtonItem = self.rightBtn
            self.view.addSubview(self.rightButton)
            unlockLabel.showWarnMsgAndShake("与上次绘制不一致，请重新绘制")
            unlock.processWrong()
        }
    }
    func processVerify(_ psw: String){
        if tpsw == psw{
            
            print("验证成功")
            verifyResult?(true)
            unlock.processRight()
            //navigationController?.popViewControllerAnimated(true)
            self.dismiss(animated: true, completion: nil)
        } else {
            wrongCount()
            unlockLabel.showWarnMsgAndShake("密码错误，您还可以尝试\(3-wrongCnt)次")
            unlock.processWrong()
        }
    }
    func processReset(_ psw: String){
        if tpsw == psw {
            print("重置成功")
            resetResult?(true)
            state = GestureUnlockState.set
            unlockLabel.showNormalMsg("重新绘制解锁图案")
//            self.dismissViewControllerAnimated(true, completion: {
//                
//            })
        } else {
            wrongCount()
            unlockLabel.showWarnMsgAndShake("密码错误，您还可以尝试\(3-wrongCnt)次")
            unlock.processWrong()
        }
    }
    func reset(_ sender: AnyObject?){
        self.state = GestureUnlockState.set
        self.rightButton.isHidden = true
    }
    func wrongCount(){
        wrongCnt += 1
        if wrongCnt >= 3 {
            print("错误超过4次，验证失败")
            verifyResult?(false)

//            self.dismissViewControllerAnimated(true, completion: {
//             
//            })
        }
    }
}
