import UIKit

extension CALayer{
    func shake(){
        let kfa = CAKeyframeAnimation(keyPath: "transform.translation.x")
        
        kfa.values = [-5,0,5,0,-5,0,5,0]
        
        kfa.duration = 0.3
        
        kfa.repeatCount = 2
        
        kfa.isRemovedOnCompletion = true
        
        self.add(kfa, forKey: "shake")
    }
}
class UnlockLabel: UILabel {
    static let frame = CGRect(
        x: 0,
        y: UIScreen.main.bounds.size.height * 1.45 / 5,
        width: UIScreen.main.bounds.size.width,
        height: 14)
    static let fontSizeRadio: CGFloat = 0.04
    static let normalColor: UIColor = CommonConfig.white
    static let warnColor: UIColor = CommonConfig.red

    convenience init() {
        self.init(frame: UnlockLabel.frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textColor = CommonConfig.white
        let fontSize = UIScreen.main.bounds.size.width * UnlockLabel.fontSizeRadio
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textAlignment = NSTextAlignment.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func showNormalMsg(_ msg: String){
        self.text = msg
        self.textColor = UnlockLabel.normalColor
    }
    func showWarnMsg(_ msg: String){
        self.text = msg
        self.textColor = UnlockLabel.warnColor
    }
    func showWarnMsgAndShake(_ msg: String){
        self.text = msg
        self.textColor = UnlockLabel.warnColor
        self.layer.shake()
    }
}
