import UIKit

class UnlockInfo: UIView {
    var state: UnlockInfoState = .normal{
        didSet{
            setNeedsDisplay()
        }
    }
    
    convenience init() {
        self.init(frame: CommonConfig.UnlockInfo.frame)
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        let circleRadius = rect.size.width / 3.0 * CommonConfig.UnlockInfo.circleRadiusRadio
        let circleMargin = rect.size.width / 3.0 - circleRadius
        for row in 0..<3{
            for col in 0..<3{
                let x = CGFloat(row) * (circleMargin + circleRadius) + circleMargin / 2.0
                let y = CGFloat(col) * (circleMargin + circleRadius) + circleMargin / 2.0
                let nframe = CGRect(x: x, y: y, width: circleRadius, height: circleRadius)
                switch state {
                case .normal:
                    drawOutCircle(ctx, rect: nframe)
                case .selected(let psw):
                    if contain(psw as NSString as NSString, num: row * 3 + col) {
                        drawInCircle(ctx, rect: nframe)
                    } else {
                        drawOutCircle(ctx, rect: nframe)
                    }
                }
            }
        }
    }
    func drawOutCircle(_ ctx: CGContext, rect: CGRect){
        let len = rect.width
        let edgeWidth = len * CommonConfig.UnlockInfo.edgeWidthRadio
        // 注意ios绘制的线是，内外以path为分割各一半，于是edgeWidth要取一半...可以调大edgeWidth试下
        let circleRect = CGRect(
            x: rect.origin.x + edgeWidth / 2,
            y: rect.origin.y + edgeWidth / 2,
            width: len - edgeWidth,
            height: len - edgeWidth)
        let path = CGMutablePath()
        
        path.addEllipse(in: circleRect, transform: CGAffineTransform.identity)
        //        CGPathAddEllipseInRect(path, &transform, circleRect)
        ctx.addPath(path)
        ctx.setLineWidth(edgeWidth)
        state.getColor().set()
        ctx.strokePath()
    }
    // 绘制内圆，且实心
    func drawInCircle(_ ctx: CGContext, rect: CGRect){
        let path = CGMutablePath()
        
        path.addEllipse(in: rect, transform: CGAffineTransform.identity)
        //        CGPathAddEllipseInRect(path, &transform, rect)
        ctx.addPath(path)
        state.getColor().set()
        ctx.fillPath()
    }
    func contain(_ psw: NSString, num: Int)->Bool{
        let str = "\(num)"
        let range = psw.range(of: str)
        return range.length > 0
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
