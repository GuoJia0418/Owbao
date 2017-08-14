import UIKit
// MARK: - 存储属性及初始化
class Circle: UIView {
    var state: CircleState = CircleState.normal {
        didSet{
            setNeedsDisplay()
        }
    }
    var angle: CGFloat = 0
    var row: Int
    var col: Int
    
    init (row: Int, col: Int, frame: CGRect){
        self.row = row
        self.col = col
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - 设置angle
extension Circle{
    func setAagle(_ nextCircle: Circle){
        let lhs = nextCircle.col - col
        let rhs = nextCircle.row - row
        angle = atan2(CGFloat(lhs), CGFloat(rhs)) + CGFloat(M_PI_2)
    }
}
// MARK: - 画图形
extension Circle{
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        transformCtx(ctx, rect: rect)
        drawOutCircle(ctx, rect: rect)
        drawInCircle(ctx, rect: rect)
        drawTrangle(ctx, rect: rect)
    }
    // 中心旋转
    func transformCtx(_ ctx: CGContext, rect: CGRect){
        let len = rect.width / 2
        ctx.translateBy(x: len, y: len)
        ctx.rotate(by: angle)
        ctx.translateBy(x: -len, y: -len)
    }
    
    // 绘制外圆
    func drawOutCircle(_ ctx: CGContext, rect: CGRect){
        let len = rect.width
        let edgeWidth = len * CommonConfig.Circle.edgeWidthRadio
        // 注意ios绘制的线是，内外以path为分割各一半，于是edgeWidth要取一半...可以调大edgeWidth试下
        let circleRect = CGRect(x: edgeWidth / 2, y: edgeWidth / 2, width: len - edgeWidth, height: len - edgeWidth)
        let path = CGMutablePath()
        
        let transform = CGAffineTransform.identity
        path.addEllipse(in: circleRect, transform: transform)
        //        path.addEllipse(in: circleRect, transform: nil)
        //        path.addEllipse(in: circleRect, transform: transform)
        //        CGPathAddEllipseInRect(path,  &transform, circleRect)
        ctx.addPath(path)
        ctx.setLineWidth(edgeWidth)
        state.getOutColor().set()
        ctx.strokePath()
    }
    
    // 绘制内圆，且实心
    func drawInCircle(_ ctx: CGContext, rect: CGRect){
        let path = CGMutablePath()
        let len = rect.width * CommonConfig.Circle.inRadio / 2
        let start = rect.width / 2 - len
        let circleRect = CGRect(x: start, y: start, width: len * 2, height: len * 2)
        
        let transform = CGAffineTransform.identity
        path.addEllipse(in: circleRect, transform: transform)
        //        CGPathAddEllipseInRect(path, &transform, circleRect)
        ctx.addPath(path)
        state.getInColor().set()
        ctx.fillPath()
    }
    
    // 绘制三角形
    func drawTrangle(_ ctx: CGContext, rect: CGRect){
        let path = CGMutablePath()
        let len = rect.size.width / 2 * CommonConfig.Circle.trLenRadio
        let startX = rect.size.width / 2
        let startY = rect.size.width / 2 * (1.0 - CommonConfig.Circle.trPosRadio)
        
        let transform = CGAffineTransform.identity
        path.move(to: CGPoint(x: startX, y: startY), transform: transform)
        path.addLine(to: CGPoint(x: startX - len/2, y: startY + len/2), transform: CGAffineTransform())
        path.addLine(to: CGPoint(x: startX + len/2, y: startY + len/2), transform: CGAffineTransform())
        
        //        CGPathMoveToPoint(path, &transform, startX, startY);
        //        CGPathAddLineToPoint(path, &transform, startX - len/2, startY + len/2);
        //        CGPathAddLineToPoint(path, &transform, startX + len/2, startY + len/2);
        
        ctx.addPath(path);
        state.getTrColor().set()
        ctx.fillPath();
    }
}
