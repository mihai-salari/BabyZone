//
//  LMRuler.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/2.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let SHEIGHT:CGFloat = 8

class LMRulerScrollView: UIScrollView {
    private var distanceLeftAndRight:CGFloat = 8
    private var distanceValue:CGFloat = 8
    private var distanceTopAndBottom:CGFloat = 0
    
    private var rulerCount:Int = 0
    private var rulerAverage:NSNumber!
    private var rulerHeight:CGFloat = 0
    private var rulerWidth:CGFloat = 0
    var rulerValue:CGFloat = 0
    private var mode:Bool = false
    private var shortRulerColor:UIColor!
    private var longRulerColor:UIColor!
    private var rulerTextColor:UIColor!
    
    init(frame: CGRect, count:Int, currentValue:CGFloat, distanceLeftAndRight:CGFloat, distanceValue:CGFloat, distanceTopAndBottom:CGFloat, minimumMode:Bool, shortRulerColor:UIColor, longRulerColor:UIColor, rulerTextColor:UIColor, average:NSNumber) {
        super.init(frame: frame)
        self.rulerCount = count
        self.distanceLeftAndRight = distanceLeftAndRight
        self.distanceValue = distanceValue
        self.distanceTopAndBottom = distanceTopAndBottom
        self.mode = minimumMode
        self.rulerTextColor = rulerTextColor
        self.shortRulerColor = shortRulerColor
        self.longRulerColor = longRulerColor
        self.rulerAverage = average
        self.rulerValue = currentValue
        self.rulerWidth = CGRectGetWidth(frame)
        self.rulerHeight = CGRectGetHeight(frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawRuler(){
        let pathRef1 = CGPathCreateMutable()
        let pathRef2 = CGPathCreateMutable()
        
        let shapeLayer1 = CAShapeLayer()
        shapeLayer1.strokeColor = self.shortRulerColor.CGColor
        shapeLayer1.fillColor = UIColor.clearColor().CGColor
        shapeLayer1.lineWidth = 1
        shapeLayer1.lineCap = kCALineCapButt
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.strokeColor = self.longRulerColor.CGColor
        shapeLayer2.fillColor = UIColor.clearColor().CGColor
        shapeLayer2.lineWidth = 1
        shapeLayer2.lineCap = kCALineCapButt
        
        for i in 0 ... self.rulerCount {
            let ruleLabel = UILabel()
            ruleLabel.textColor = self.rulerTextColor
            ruleLabel.text = "\(Float(i) * self.rulerAverage.floatValue)"
            let textSize = NSString.init(string: ruleLabel.text!).sizeWithAttributes([NSFontAttributeName : ruleLabel.font])
            
            if i % 10 == 0 {
                CGPathMoveToPoint(pathRef2, nil, self.distanceLeftAndRight + self.distanceValue * CGFloat(i), self.distanceTopAndBottom)
                CGPathAddLineToPoint(pathRef2, nil, self.distanceLeftAndRight + self.distanceValue * CGFloat(i), self.rulerHeight - self.distanceTopAndBottom - textSize.height)
                ruleLabel.frame = CGRectMake(self.distanceLeftAndRight + self.distanceValue * CGFloat(i) - textSize.width / 2, self.rulerHeight - self.distanceTopAndBottom - textSize.height, 0, 0)
                ruleLabel.sizeToFit()
                self.addSubview(ruleLabel)
            }else if i % 5 == 0{
                CGPathMoveToPoint(pathRef1, nil, self.distanceLeftAndRight + self.distanceValue * CGFloat(i), self.distanceTopAndBottom)
                CGPathAddLineToPoint(pathRef1, nil, self.distanceLeftAndRight + self.distanceValue * CGFloat(i), self.rulerHeight - self.distanceTopAndBottom - textSize.height - 10)
            }else{
                CGPathMoveToPoint(pathRef1, nil, self.distanceLeftAndRight + self.distanceValue * CGFloat(i), self.distanceTopAndBottom)
                CGPathAddLineToPoint(pathRef1, nil, self.distanceLeftAndRight + self.distanceValue * CGFloat(i), self.rulerHeight - self.distanceTopAndBottom - textSize.height - 30)
            }
        }
        shapeLayer1.path = pathRef1
        shapeLayer2.path = pathRef2
        
        self.layer.addSublayer(shapeLayer1)
        self.layer.addSublayer(shapeLayer2)
        
        self.frame = CGRectMake(0, 0, self.rulerWidth, self.rulerHeight)
        
        if self.mode {
            self.contentInset = UIEdgeInsetsZero
            print("ruler value \(self.rulerValue)")
            self.contentOffset = CGPointMake(self.distanceValue * (self.rulerValue / CGFloat(self.rulerAverage.floatValue)) - self.rulerWidth + (self.rulerWidth / 2 + self.distanceLeftAndRight), 0)
        }else{
            self.contentOffset = CGPointMake(self.distanceValue * (self.rulerValue / CGFloat(self.rulerAverage.floatValue)) - self.rulerWidth + (self.rulerWidth / 2 + self.distanceLeftAndRight), 0)
        }
        self.contentSize = CGSizeMake(CGFloat(self.rulerCount) * self.distanceValue + self.distanceLeftAndRight * 2, self.rulerHeight)
    }
}

class LMRuler: UIView,UIScrollViewDelegate {

    private var distanceLeftAndRight:CGFloat = 8
    private var distanceValue:CGFloat = 8
    private var distanceTopAndBottom:CGFloat = 0
    private var rulerScrollView:LMRulerScrollView!
    private var rulerWidth:CGFloat = 0
    private var rulerHeight:CGFloat = 0
    private var rulerHandler:((rulerView:LMRulerScrollView)->())?
    private var rulerLineColor:UIColor = UIColor.whiteColor()
    private var rulerIndicatorColor:UIColor = UIColor.whiteColor()
    
    init(frame: CGRect, count:Int, distanceLeftAndRight:CGFloat, distanceValue:CGFloat, distanceTopAndBottom:CGFloat, currentValue:CGFloat, minimumMode:Bool, shortRulerColor:UIColor, longRulerColor:UIColor, rulerTextColor:UIColor, average:NSNumber, handler:((rulerView:LMRulerScrollView)->())?) {
        super.init(frame: frame)
        self.rulerScrollView = LMRulerScrollView.init(frame: frame, count: count, currentValue: currentValue, distanceLeftAndRight: distanceLeftAndRight, distanceValue: distanceValue, distanceTopAndBottom: distanceTopAndBottom, minimumMode: minimumMode, shortRulerColor: shortRulerColor, longRulerColor: longRulerColor, rulerTextColor: rulerTextColor, average: average)
        self.rulerScrollView.showsHorizontalScrollIndicator = false
        self.rulerScrollView.delegate = self
        self.rulerHandler = handler
        self.rulerScrollView.drawRuler()
        self.addSubview(self.rulerScrollView)
        self.drawRacAndLine()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK:___Scroll view delegate___
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.isKindOfClass(LMRulerScrollView) {
            let scrollView = scrollView as! LMRulerScrollView
            let offsetX = scrollView.contentOffset.x + CGRectGetWidth(self.frame) / 2 - self.distanceLeftAndRight
            let rulerValue = (offsetX / self.distanceValue) * CGFloat(scrollView.rulerAverage.floatValue)
            if rulerValue < 0 {
                return
            }else if (rulerValue > CGFloat(scrollView.rulerCount) * CGFloat(scrollView.rulerAverage.floatValue)){
                return
            }
            
            if !scrollView.mode {
                scrollView.rulerValue = rulerValue
            }
            scrollView.mode = false
            self.handleRuler(scrollView)
        }
        
    }
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        if scrollView.isKindOfClass(LMRulerScrollView) {
//            let scrollView = scrollView as! LMRulerScrollView
////            self.animationRebound(scrollView)
//        }
//        
//    }
//    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.isKindOfClass(LMRulerScrollView) {
//            let scrollView = scrollView as! LMRulerScrollView
////            self.animationRebound(scrollView)
//        }
//    }
    
    private func drawRacAndLine(){
        //直线
        let solidShapeLayer = CAShapeLayer()
        let solidShapePath = CGPathCreateMutable()
        solidShapeLayer.fillColor = UIColor.clearColor().CGColor
        solidShapeLayer.strokeColor = self.rulerLineColor.CGColor
        solidShapeLayer.lineWidth = 1
        CGPathMoveToPoint(solidShapePath, nil, 0, 0)
        CGPathAddLineToPoint(solidShapePath, nil, CGRectGetWidth(self.frame), 0)
        
        solidShapeLayer.path = solidShapePath
        self.layer.addSublayer(solidShapeLayer)
        
        //渐变
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        
        gradient.colors = [UIColor.whiteColor().colorWithAlphaComponent(1),UIColor.whiteColor().colorWithAlphaComponent(0),UIColor.whiteColor().colorWithAlphaComponent(1)]
        gradient.locations = [NSNumber.init(float: 0),NSNumber.init(float: 0.6)]
        gradient.startPoint = CGPointMake(0, 0.5)
        gradient.endPoint = CGPointMake(1, 0.5)
        
        
        //指示器
        let shapeLayerLine = CAShapeLayer()
        shapeLayerLine.strokeColor = UIColor.clearColor().CGColor
        shapeLayerLine.fillColor = self.rulerIndicatorColor.CGColor
        shapeLayerLine.lineWidth = 1
        shapeLayerLine.lineCap = kCALineCapSquare
        
        let pathLine = CGPathCreateMutable()
        CGPathMoveToPoint(pathLine, nil, CGRectGetWidth(self.frame) / 2, CGRectGetHeight(self.frame) - self.distanceTopAndBottom)
        CGPathAddLineToPoint(pathLine, nil, CGRectGetWidth(self.frame) / 2, self.distanceTopAndBottom + SHEIGHT)
        CGPathAddLineToPoint(pathLine, nil, (CGRectGetWidth(self.frame) - SHEIGHT) / 2, self.distanceTopAndBottom)
        CGPathAddLineToPoint(pathLine, nil, (CGRectGetWidth(self.frame) + SHEIGHT) / 2, self.distanceTopAndBottom)
        CGPathAddLineToPoint(pathLine, nil, CGRectGetWidth(self.frame) / 2, self.distanceTopAndBottom + SHEIGHT)
        
        shapeLayerLine.path = pathLine
        self.layer.addSublayer(shapeLayerLine)
        
    }
    
//    private func animationRebound(scrollView:LMRulerScrollView){
//        let offsetX = scrollView.contentOffset.x + CGRectGetWidth(self.frame) / 2 - self.distanceLeftAndRight
//        var oX = (offsetX / self.distanceValue) * CGFloat(scrollView.rulerAverage.floatValue)
//        if self.valueIsInteger(scrollView.rulerAverage) {
//            oX = self.notRounding(oX, afterPoint: 0)
//        }else{
//            oX = self.notRounding(oX, afterPoint: 1)
//        }
//        
//        let offX = (oX / CGFloat(scrollView.rulerAverage.floatValue)) * self.distanceValue + self.distanceLeftAndRight - CGRectGetWidth(self.frame) / 2
//        UIView.animateWithDuration(0.2) { 
//            scrollView.contentOffset = CGPointMake(offX, 0)
//        }
//        
//    }
    
    private func handleRuler(scrollView:LMRulerScrollView){
        if NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue() {
            if let handle = self.rulerHandler {
                handle(rulerView: scrollView)
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), { 
                if let handle = self.rulerHandler {
                    handle(rulerView: scrollView)
                }
            })
        }
    }
    
    private func notRounding(price:CGFloat, afterPoint:Int) ->CGFloat{
        let roundingBehavior = NSDecimalNumberHandler.init(roundingMode: .RoundPlain, scale: Int16(afterPoint), raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let ouncesDecimal = NSDecimalNumber.init(float: Float(price))
        let roundedOunces = ouncesDecimal.decimalNumberByRoundingAccordingToBehavior(roundingBehavior)
        return CGFloat(roundedOunces.floatValue)
    }
    
    
    private func valueIsInteger(number:NSNumber) ->Bool{
        let value = "\(number.floatValue)"
        if value != "" {
            let valueEnd:NSString = value.componentsSeparatedByString(".")[1]
            var temp = ""
            for i in 0 ..< valueEnd.length {
                temp = valueEnd.substringWithRange(NSMakeRange(i, 1))
                if temp != "0" {
                    return false
                }
            }
        }
        return true
    }
}
