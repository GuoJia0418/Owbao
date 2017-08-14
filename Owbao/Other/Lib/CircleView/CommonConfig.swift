import UIKit

class CommonConfig: NSObject { // 颜色设定默认就好
    static let white = CommonConfig.rgba(241, g: 241, b: 241, a: 1.0)
    
    //static let blue = CommonConfig.rgba(34, g: 178, b: 246, a: 1.0)
    static let blue = CommonConfig.rgba(254, g: 118, b: 52, a: 1.0)
    static let red = CommonConfig.rgba(254, g: 82, b: 92, a: 1.0)
    //static let bk = CommonConfig.rgba(13, g: 52, b: 89, a: 1)
    static let bk = CommonConfig.rgba(31, g: 35, b: 46, a: 1.0)
    static let tra = UIColor.clear
    static func rgba(_ r: Int, g: Int, b: Int, a: CGFloat)->UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
}
// mark - Circle setting
extension CommonConfig {
    class Circle {
        static let edgeWidthRadio: CGFloat = 0.02 //取圆直径的百分比
        static let inRadio: CGFloat = 0.4 //取内圆占外圆的百分比
        static let trPosRadio: CGFloat = 0.8 //以圆心为中心，偏移半径的百分比
        static let trLenRadio: CGFloat = 0.4 //同上
    }
}
/// 不同状态要素颜色不同
enum CircleState{
    case normal, selected, error, lSelected, lError
    func getOutColor()->UIColor {
        switch self {
        case .normal:
            return CommonConfig.white
        case .selected, .lSelected:
            return CommonConfig.blue
        case .error, .lError:
            return CommonConfig.red
        }
    }
    func getInColor()->UIColor {
        switch self {
        case .normal:
            return CommonConfig.tra
        case .selected, .lSelected:
            return CommonConfig.blue
        case .error, .lError:
            return CommonConfig.red
        }
    }
    func getTrColor()->UIColor {
        switch self {
        case .normal, .lSelected, .lError:
            return CommonConfig.tra
        case .selected:
            return CommonConfig.blue
        case .error:
            return CommonConfig.red
        }
    }
}
// mark - Unlock setting
extension CommonConfig {
    class Unlock {
        static let circleRadiusRadio: CGFloat = 0.66 //对于9宫格，圆相对九宫格的大小
        static let edgeMarginRadio: CGFloat = 0.08 //相对于屏幕宽度的，九宫相对于屏幕边缘的距离
        static let edgeWidthRadio: CGFloat = 0.0038 //相对于frame的宽度
        // 默认,屏幕3/5位置，且与屏幕边框edgeMargin = UIScreen.mainScreen().bounds.size.width * edgeMarginRadio值
        static let frame = CGRect(
            x: UIScreen.main.bounds.size.width * Unlock.edgeMarginRadio,
            y: UIScreen.main.bounds.size.height * 3 / 5 - (UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * Unlock.edgeMarginRadio * 2) / 2,
            width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * Unlock.edgeMarginRadio * 2,
            height: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * Unlock.edgeMarginRadio * 2)
    }
}
enum UnlockState{
    case normal, error
    func getColor()->UIColor {
        switch self {
        case .normal:
            return CommonConfig.blue
        case .error:
            return CommonConfig.red
        }
    }
}
// mark - UnlockInfo setting
extension CommonConfig {
    class UnlockInfo {
        static let circleRadiusRadio: CGFloat = 0.76 //对于9宫格，圆相对九宫格的大小
        static let edgeMarginRadio: CGFloat = 0.445 //相对于屏幕宽度的，九宫相对于屏幕边缘的距离
        static let edgeWidthRadio: CGFloat = 0.13 //相对于frame的宽度
        
        // 默认,屏幕1.2/5位置，且与屏幕边框edgeMargin = UIScreen.mainScreen().bounds.size.width * edgeMarginRadio值
        static let frame = CGRect(
            x: UIScreen.main.bounds.size.width * UnlockInfo.edgeMarginRadio,
            y: UIScreen.main.bounds.size.height * 1.2 / 5 - (UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * UnlockInfo.edgeMarginRadio * 2) / 2,
            width: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * UnlockInfo.edgeMarginRadio * 2,
            height: UIScreen.main.bounds.size.width - UIScreen.main.bounds.size.width * UnlockInfo.edgeMarginRadio * 2)
    }
}
enum UnlockInfoState {
    case normal
    case selected(String)
    func getColor()->UIColor {
        switch self{
        case .normal:
            return CommonConfig.white
        case .selected(_):
            return CommonConfig.blue
        }
    }
}
extension CommonConfig {
    class GestureUnlockViewController {
        static let backgroundColor = CommonConfig.bk
    }
}
enum GestureUnlockState {
    case set, verify, reset
}
