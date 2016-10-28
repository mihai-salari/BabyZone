//
//  CustomView.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class CustomView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}


//MARK:___SWITCH___

@IBDesignable @objc public class HMSwitch: UIControl {
    // public
    
    /*
     *   Set (without animation) whether the switch is on or off
     */
    @IBInspectable public var on: Bool {
        get {
            return switchValue
        }
        set {
            switchValue = newValue
            self.setOn(newValue, animated: false)
        }
    }
    
    /*
     *	Sets the background color that shows when the switch off and actively being touched.
     *   Defaults to light gray.
     */
    @IBInspectable public var activeColor: UIColor = UIColor(red: 0.89, green: 0.89, blue: 0.89, alpha: 1) {
        willSet {
            if self.on && !self.tracking {
                backgroundView.backgroundColor = newValue
            }
        }
    }
    
    /*
     *	Sets the background color when the switch is off.
     *   Defaults to clear color.
     */
    @IBInspectable public var inactiveColor: UIColor = UIColor.clearColor() {
        willSet {
            if !self.on && !self.tracking {
                backgroundView.backgroundColor = newValue
            }
        }
    }
    
    /*
     *   Sets the background color that shows when the switch is on.
     *   Defaults to green.
     */
    @IBInspectable public var onTintColor: UIColor = UIColor(red: 0.3, green: 0.85, blue: 0.39, alpha: 1) {
        willSet {
            if self.on && !self.tracking {
                backgroundView.backgroundColor = newValue
                backgroundView.layer.borderColor = newValue.CGColor
            }
        }
    }
    
    /*
     *   Sets the border color that shows when the switch is off. Defaults to light gray.
     */
    @IBInspectable public var borderColor: UIColor = UIColor(red: 0.78, green: 0.78, blue: 0.8, alpha: 1) {
        willSet {
            if !self.on {
                backgroundView.layer.borderColor = newValue.CGColor
            }
        }
    }
    
    /*
     *	Sets the knob color. Defaults to white.
     */
    @IBInspectable public var thumbTintColor: UIColor = UIColor.whiteColor() {
        willSet {
            if !userDidSpecifyOnThumbTintColor {
                onThumbTintColor = newValue
            }
            if (!userDidSpecifyOnThumbTintColor || !self.on) && !self.tracking {
                thumbView.backgroundColor = newValue
            }
        }
    }
    
    /*
     *	Sets the knob color that shows when the switch is on. Defaults to white.
     */
    @IBInspectable public var onThumbTintColor: UIColor = UIColor.whiteColor() {
        willSet {
            userDidSpecifyOnThumbTintColor = true
            if self.on && !self.tracking {
                thumbView.backgroundColor = newValue
            }
        }
    }
    
    /*
     *	Sets the shadow color of the knob. Defaults to gray.
     */
    @IBInspectable public var shadowColor: UIColor = UIColor.grayColor() {
        willSet {
            thumbView.layer.shadowColor = newValue.CGColor
        }
    }
    
    /*
     *	Sets whether or not the switch edges are rounded.
     *   Set to NO to get a stylish square switch.
     *   Defaults to YES.
     */
    @IBInspectable public var isRounded: Bool = true {
        willSet {
            if newValue {
                backgroundView.layer.cornerRadius = self.frame.size.height * 0.5
                thumbView.layer.cornerRadius = (self.frame.size.height * 0.5) - 1
            }
            else {
                backgroundView.layer.cornerRadius = 2
                thumbView.layer.cornerRadius = 2
            }
            
            thumbView.layer.shadowPath = UIBezierPath(roundedRect: thumbView.bounds, cornerRadius: thumbView.layer.cornerRadius).CGPath
        }
    }
    
    /*
     *   Sets the image that shows on the switch thumb.
     */
    @IBInspectable public var thumbImage: UIImage! {
        willSet {
            thumbImageView.image = newValue
        }
    }
    
    /*
     *   Sets the image that shows when the switch is on.
     *   The image is centered in the area not covered by the knob.
     *   Make sure to size your images appropriately.
     */
    @IBInspectable public var onImage: UIImage! {
        willSet {
            onImageView.image = newValue
        }
    }
    
    /*
     *	Sets the image that shows when the switch is off.
     *   The image is centered in the area not covered by the knob.
     *   Make sure to size your images appropriately.
     */
    @IBInspectable public var offImage: UIImage! {
        willSet {
            offImageView.image = newValue
        }
    }
    
    /*
     *	Sets the text that shows when the switch is on.
     *   The text is centered in the area not covered by the knob.
     */
    public var onLabel: UILabel!
    
    /*
     *	Sets the text that shows when the switch is off.
     *   The text is centered in the area not covered by the knob.
     */
    public var offLabel: UILabel!
    
    // internal
    internal var backgroundView: UIView!
    internal var thumbView: UIView!
    internal var onImageView: UIImageView!
    internal var offImageView: UIImageView!
    internal var thumbImageView: UIImageView!
    // private
    private var currentVisualValue: Bool = false
    private var startTrackingValue: Bool = false
    private var didChangeWhileTracking: Bool = false
    private var isAnimating: Bool = false
    private var userDidSpecifyOnThumbTintColor: Bool = false
    private var switchValue: Bool = false
    
    /*
     *   Initialization
     */
    public convenience init() {
        self.init(frame: CGRectMake(0, 0, 50, 30))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    override public init(frame: CGRect) {
        let initialFrame = CGRectIsEmpty(frame) ? CGRectMake(0, 0, 50, 30) : frame
        super.init(frame: initialFrame)
        
        self.setup()
    }
    
    
    /*
     *   Setup the individual elements of the switch and set default values
     */
    private func setup() {
        
        // background
        self.backgroundView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height))
        backgroundView.backgroundColor = UIColor.clearColor()
        backgroundView.layer.cornerRadius = self.frame.size.height * 0.5
        backgroundView.layer.borderColor = self.borderColor.CGColor
        backgroundView.layer.borderWidth = 1.0
        backgroundView.userInteractionEnabled = false
        backgroundView.clipsToBounds = true
        self.addSubview(backgroundView)
        
        // on/off images
        self.onImageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height))
        onImageView.alpha = 1.0
        onImageView.contentMode = UIViewContentMode.Center
        backgroundView.addSubview(onImageView)
        
        self.offImageView = UIImageView(frame: CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height))
        offImageView.alpha = 1.0
        offImageView.contentMode = UIViewContentMode.Center
        backgroundView.addSubview(offImageView)
        
        // labels
        self.onLabel = UILabel(frame: CGRectMake(0, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height))
        onLabel.textAlignment = NSTextAlignment.Center
        onLabel.textColor = UIColor.lightGrayColor()
        onLabel.font = UIFont.systemFontOfSize(12)
        backgroundView.addSubview(onLabel)
        
        self.offLabel = UILabel(frame: CGRectMake(self.frame.size.height, 0, self.frame.size.width - self.frame.size.height, self.frame.size.height))
        offLabel.textAlignment = NSTextAlignment.Center
        offLabel.textColor = UIColor.lightGrayColor()
        offLabel.font = UIFont.systemFontOfSize(12)
        backgroundView.addSubview(offLabel)
        
        // thumb
        self.thumbView = UIView(frame: CGRectMake(1, 1, self.frame.size.height - 2, self.frame.size.height - 2))
        thumbView.backgroundColor = self.thumbTintColor
        thumbView.layer.cornerRadius = (self.frame.size.height * 0.5) - 1
        thumbView.layer.shadowColor = self.shadowColor.CGColor
        thumbView.layer.shadowRadius = 2.0
        thumbView.layer.shadowOpacity = 0.5
        thumbView.layer.shadowOffset = CGSizeMake(0, 3)
        thumbView.layer.shadowPath = UIBezierPath(roundedRect: thumbView.bounds, cornerRadius: thumbView.layer.cornerRadius).CGPath
        thumbView.layer.masksToBounds = false
        thumbView.userInteractionEnabled = false
        self.addSubview(thumbView)
        
        // thumb image
        self.thumbImageView = UIImageView(frame: CGRectMake(0, 0, thumbView.frame.size.width, thumbView.frame.size.height))
        thumbImageView.contentMode = UIViewContentMode.Center
        thumbImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth
        thumbView.addSubview(thumbImageView)
        
        self.on = false
    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        
        startTrackingValue = self.on
        didChangeWhileTracking = false
        
        let activeKnobWidth = self.bounds.size.height - 2 + 5
        isAnimating = true
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.BeginFromCurrentState], animations: {
            if self.on {
                self.thumbView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
                self.backgroundView.backgroundColor = self.onTintColor
                self.thumbView.backgroundColor = self.onThumbTintColor
            }
            else {
                self.thumbView.frame = CGRectMake(self.thumbView.frame.origin.x, self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
                self.backgroundView.backgroundColor = self.activeColor
                self.thumbView.backgroundColor = self.thumbTintColor
            }
            }, completion: { finished in
                self.isAnimating = false
        })
        
        return true
    }
    
    override public func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        super.continueTrackingWithTouch(touch, withEvent: event)
        
        // Get touch location
        let lastPoint = touch.locationInView(self)
        
        // update the switch to the correct visuals depending on if
        // they moved their touch to the right or left side of the switch
        if lastPoint.x > self.bounds.size.width * 0.5 {
            self.showOn(true)
            if !startTrackingValue {
                didChangeWhileTracking = true
            }
        }
        else {
            self.showOff(true)
            if startTrackingValue {
                didChangeWhileTracking = true
            }
        }
        
        return true
    }
    
    override public func endTrackingWithTouch(touch: UITouch?, withEvent event: UIEvent?) {
        super.endTrackingWithTouch(touch, withEvent: event)
        
        let previousValue = self.on
        
        if didChangeWhileTracking {
            self.setOn(currentVisualValue, animated: true)
        }
        else {
            self.setOn(!self.on, animated: true)
        }
        
        if previousValue != self.on {
            self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        }
    }
    
    override public func cancelTrackingWithEvent(event: UIEvent?) {
        super.cancelTrackingWithEvent(event)
        
        // just animate back to the original value
        if self.on {
            self.showOn(true)
        }
        else {
            self.showOff(true)
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        if !isAnimating {
            let frame = self.frame
            
            // background
            backgroundView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
            backgroundView.layer.cornerRadius = self.isRounded ? frame.size.height * 0.5 : 2
            
            // images
            onImageView.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height)
            offImageView.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)
            self.onLabel.frame = CGRectMake(0, 0, frame.size.width - frame.size.height, frame.size.height)
            self.offLabel.frame = CGRectMake(frame.size.height, 0, frame.size.width - frame.size.height, frame.size.height)
            
            // thumb
            let normalKnobWidth = frame.size.height - 2
            if self.on {
                thumbView.frame = CGRectMake(frame.size.width - (normalKnobWidth + 1), 1, frame.size.height - 2, normalKnobWidth)
            }
            else {
                thumbView.frame = CGRectMake(1, 1, normalKnobWidth, normalKnobWidth)
            }
            
            thumbView.layer.cornerRadius = self.isRounded ? (frame.size.height * 0.5) - 1 : 2
        }
    }
    
    /*
     *   Set the state of the switch to on or off, optionally animating the transition.
     */
    public func setOn(isOn: Bool, animated: Bool) {
        switchValue = isOn
        
        if on {
            self.showOn(animated)
        }
        else {
            self.showOff(animated)
        }
    }
    
    /*
     *   Detects whether the switch is on or off
     *
     *	@return	BOOL YES if switch is on. NO if switch is off
     */
    public func isOn() -> Bool {
        return self.on
    }
    
    /*
     *   update the looks of the switch to be in the on position
     *   optionally make it animated
     */
    private func showOn(animated: Bool) {
        let normalKnobWidth = self.bounds.size.height - 2
        let activeKnobWidth = normalKnobWidth + 5
        if animated {
            isAnimating = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.BeginFromCurrentState], animations: {
                if self.tracking {
                    self.thumbView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
                }
                else {
                    self.thumbView.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), self.thumbView.frame.origin.y, normalKnobWidth, self.thumbView.frame.size.height)
                }
                
                self.backgroundView.backgroundColor = self.onTintColor
                self.backgroundView.layer.borderColor = self.onTintColor.CGColor
                self.thumbView.backgroundColor = self.onThumbTintColor
                self.onImageView.alpha = 1.0
                self.offImageView.alpha = 0
                self.onLabel.alpha = 1.0
                self.offLabel.alpha = 0
                }, completion: { finished in
                    self.isAnimating = false
            })
        }
        else {
            if self.tracking {
                thumbView.frame = CGRectMake(self.bounds.size.width - (activeKnobWidth + 1), thumbView.frame.origin.y, activeKnobWidth, thumbView.frame.size.height)
            }
            else {
                thumbView.frame = CGRectMake(self.bounds.size.width - (normalKnobWidth + 1), thumbView.frame.origin.y, normalKnobWidth, thumbView.frame.size.height)
            }
            
            backgroundView.backgroundColor = self.onTintColor
            backgroundView.layer.borderColor = self.onTintColor.CGColor
            thumbView.backgroundColor = self.onThumbTintColor
            onImageView.alpha = 1.0
            offImageView.alpha = 0
            onLabel.alpha = 1.0
            offLabel.alpha = 0
        }
        
        currentVisualValue = true
    }
    
    /*
     *   update the looks of the switch to be in the off position
     *   optionally make it animated
     */
    private func showOff(animated: Bool) {
        let normalKnobWidth = self.bounds.size.height - 2
        let activeKnobWidth = normalKnobWidth + 5
        
        if animated {
            isAnimating = true
            UIView.animateWithDuration(0.3, delay: 0.0, options: [UIViewAnimationOptions.CurveEaseOut, UIViewAnimationOptions.BeginFromCurrentState], animations: {
                if self.tracking {
                    self.thumbView.frame = CGRectMake(1, self.thumbView.frame.origin.y, activeKnobWidth, self.thumbView.frame.size.height)
                    self.backgroundView.backgroundColor = self.activeColor
                }
                else {
                    self.thumbView.frame = CGRectMake(1, self.thumbView.frame.origin.y, normalKnobWidth, self.thumbView.frame.size.height)
                    self.backgroundView.backgroundColor = self.inactiveColor
                }
                
                self.backgroundView.layer.borderColor = self.borderColor.CGColor
                self.thumbView.backgroundColor = self.thumbTintColor
                self.onImageView.alpha = 0
                self.offImageView.alpha = 1.0
                self.onLabel.alpha = 0
                self.offLabel.alpha = 1.0
                
                }, completion: { finished in
                    self.isAnimating = false
            })
        }
        else {
            if (self.tracking) {
                thumbView.frame = CGRectMake(1, thumbView.frame.origin.y, activeKnobWidth, thumbView.frame.size.height)
                backgroundView.backgroundColor = self.activeColor
            }
            else {
                thumbView.frame = CGRectMake(1, thumbView.frame.origin.y, normalKnobWidth, thumbView.frame.size.height)
                backgroundView.backgroundColor = self.inactiveColor
            }
            backgroundView.layer.borderColor = self.borderColor.CGColor
            thumbView.backgroundColor = self.thumbTintColor
            onImageView.alpha = 0
            offImageView.alpha = 1.0
            onLabel.alpha = 0
            offLabel.alpha = 1.0
        }
        
        currentVisualValue = false
    }
}

//MARK:___UIVIEW___

private let selectionImageViewWidth:CGFloat = upRateWidth(30)
private let selectionMoreViewWidth:CGFloat = upRateWidth(20)
private let selectionMoreViewHeight:CGFloat = upRateWidth(25)
private let selectionItemLabelOriginX:CGFloat = 15

class SelectionView: UIView {
    
    private var itemLabel:UILabel!
    private var imageView:UIImageView!
    private var buttonHandler:(()->())?
    
    init(frame: CGRect,backgroundColor:UIColor = UIColor.whiteColor(),item:String = "",image:String = "",forward:Bool = false,completionHandler:(()->())?) {
        super.init(frame: frame)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        let txtRect = textRect(item, fontSize: upRateWidth(18), size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        
        if forward == true {
            self.itemLabel = UILabel.init(frame: CGRectMake((CGRectGetWidth(self.frame) - CGRectGetWidth(txtRect)) / 20, 0, CGRectGetWidth(txtRect), CGRectGetHeight(self.frame)))
            
            
            self.imageView = UIImageView.init(frame: CGRectMake(CGRectGetMinX(self.itemLabel.frame), (CGRectGetHeight(self.frame) - selectionImageViewWidth) / 2, selectionImageViewWidth, selectionImageViewWidth))
            
        }else{
            self.itemLabel = UILabel.init(frame: CGRectMake(selectionItemLabelOriginX, 0, CGRectGetWidth(txtRect), CGRectGetHeight(self.frame)))
            
            let moreView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(self.frame) - 30, (CGRectGetHeight(self.frame) - selectionMoreViewHeight) / 2, selectionMoreViewWidth, selectionMoreViewHeight))
            moreView.image = UIImage.imageWithName("right_arrow.png")
            self.addSubview(moreView)
            
            self.imageView = UIImageView.init(frame: CGRectMake(CGRectGetMinX(moreView.frame) - 5 - selectionImageViewWidth, (CGRectGetHeight(self.frame) - selectionImageViewWidth) / 2, selectionImageViewWidth, selectionImageViewWidth))
        }
        self.itemLabel.font = UIFont.systemFontOfSize(upRateWidth(15))
        self.itemLabel.text = item
        self.itemLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.itemLabel)
        
        self.imageView.image = UIImage.imageWithName(image)
        self.addSubview(self.imageView)
        
        let button = UIButton.init(type: .Custom)
        button.frame = self.bounds
        button.addTarget(self, action: #selector(SelectionView.selectionButtionClick), forControlEvents: .TouchUpInside)
        self.addSubview(button)
        
        self.buttonHandler = completionHandler
        
    }
    
    func selectionButtionClick() -> Void {
        if let handler = self.buttonHandler {
            handler()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:___UIIMAGE___

extension UIImage{
    
    func imageCompressForTargetSize(targetSize:CGSize) ->UIImage?{
        var newImage:UIImage? = nil
        
        let imageSize = self.size
        
        let width = imageSize.width
        
        let height = imageSize.height
        
        let targetWidth = size.width
        
        let targetHeight = size.height
        
        var scaleFactor:CGFloat = 0.0
        
        var scaledWidth = targetWidth
        
        var scaledHeight = targetHeight
        
        var thumbnailPoint = CGPointMake(0.0, 0.0)
        
        
        if(CGSizeEqualToSize(imageSize, size) == false){
            
            
            let widthFactor = targetWidth / width
            
            let heightFactor = targetHeight / height
            
            
            if(widthFactor > heightFactor){
                
                scaleFactor = widthFactor
                
                
            }
                
            else{
                
                
                scaleFactor = heightFactor
                
            }
            
            scaledWidth = width * scaleFactor
            
            scaledHeight = height * scaleFactor
            
            
            if(widthFactor > heightFactor){
                
                
                thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5
                
            }else if(widthFactor < heightFactor){
                
                
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5
                
            }
            
        }
        
        
        UIGraphicsBeginImageContext(size)
        
        
        var thumbnailRect = CGRectZero
        
        thumbnailRect.origin = thumbnailPoint
        
        thumbnailRect.size.width = scaledWidth
        
        thumbnailRect.size.height = scaledHeight
        
        
        self.drawInRect(thumbnailRect)
        
        
        newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        if(newImage == nil){
            
            
            
        }
        
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    /**
     气泡背景
     
     - returns: UIImage
     */
    class func BubbleIncoming()->UIImage{
        return UIImage.init(named: "BubbleIncoming")!
    }
    
    /**
     左上，右下三角
     
     - parameter size:       大小
     - parameter fillColor:  填充颜色
     - parameter alphaColor: 透明度
     
     - returns: UIImage
     */
    class func imageWithSize(size:CGSize,fillColor:UIColor = UIColor.whiteColor(),alphaColor:UIColor = UIColor.whiteColor()) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        var path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, size.width))
        path.addLineToPoint(CGPointMake(size.width, size.height))
        path.addLineToPoint(CGPointMake(size.height, 0))
        path.addLineToPoint(CGPointMake(0, size.width))
        fillColor.setFill()
        path.fill()
        path.closePath()
        
        path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(0, size.width))
        path.addLineToPoint(CGPointMake(size.height, 0))
        path.addLineToPoint(CGPointMake(0, 0))
        alphaColor.setFill()
        path.fill()
        path.closePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

//MARK:___BUTTON___

private let HMButtonImageWidth:CGFloat = 16
private let HMButtonImageHeight:CGFloat = 16

private let HMButtonTitleWidth:CGFloat = 90
private let HMButtonTitleHeight:CGFloat = 15

class HMButton: UIButton {
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetWidth(contentRect) / 2 - HMButtonImageWidth / 2, CGRectGetHeight(contentRect) / 2 - HMButtonImageHeight / 5, HMButtonImageWidth, HMButtonImageHeight)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((CGRectGetWidth(contentRect) - HMButtonTitleWidth) / 2 + downRateWidth(HMButtonTitleHeight), (CGRectGetHeight(contentRect) - HMButtonTitleHeight) / 2, HMButtonTitleWidth, HMButtonTitleHeight)
    }
}

private let ToolButtonImageWidth:CGFloat = 40
private let ToolButtonImageHeight:CGFloat = 40
private let ToolButtonTitleWidth:CGFloat = 120
private let ToolButtonTitleHeight:CGFloat = 40

class ToolButton: UIButton {
    
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setRect(imageR:CGRect, titleR:CGRect) -> Void {
        imageRect = imageR
        titleRect = titleR
    }
    
    func setCustomImage(image:String) -> Void {
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
    }
    
    func setCustomTitle(title:String) -> Void {
        self.setTitle(title, forState: .Normal)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(imageRect) / 2, CGRectGetMidY(contentRect) - CGRectGetHeight(imageRect) / 2, imageRect.width, imageRect.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(imageRect) / 2, CGRectGetMaxY(imageRect), titleRect.width, titleRect.height)
    }
}

class GreenButton: UIButton {
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setRect(imageR:CGRect, titleR:CGRect) -> Void {
        imageRect = imageR
        titleRect = titleR
    }
    
    func setCustomImage(image:String) -> Void {
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
    }
    
    func setCustomTitle(title:String) -> Void {
        self.setTitle(title, forState: .Normal)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(imageRect) / 2, upRateWidth(15), CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(titleRect) / 2, CGRectGetMaxY(imageRect) + upRateWidth(20), CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class NursingButton: UIButton {
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setRect(imageR:CGRect, titleR:CGRect) -> Void {
        imageRect = imageR
        titleRect = titleR
    }
    
    func setImageRect(imageR:CGRect, image:String,title:String = "",fontSize:CGFloat) -> Void {
        imageRect = imageR
        titleRect = textRect(title, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.setTitle(title, forState: .Normal)
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
        
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMinX(self.titleLabel!.frame) - CGRectGetWidth(imageRect) , (CGRectGetHeight(contentRect) - CGRectGetHeight(imageRect)) / 2, CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(titleRect) / 2, (CGRectGetHeight(contentRect) - CGRectGetHeight(titleRect)) / 2, CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class DiaryButton: UIButton {
    
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setImageRect(imageR:CGRect, image:String, title:String, fontSize:CGFloat) -> Void {
        imageRect = imageR
        titleRect = textRect(title, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.setTitle(title, forState: .Normal)
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
        
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(0 , (CGRectGetHeight(contentRect) - CGRectGetHeight(imageRect)) / 2, CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMaxX(imageRect) + 5, (CGRectGetHeight(contentRect) - CGRectGetHeight(titleRect)) / 2, CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class DiaryRecordButton: UIButton {
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setImageRect(imageR:CGRect, image:String, title:String, fontSize:CGFloat) -> Void {
        imageRect = imageR
        titleRect = textRect(title, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.setTitle(title, forState: .Normal)
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMaxX(self.titleLabel!.frame) + CGRectGetWidth(imageRect), (CGRectGetHeight(contentRect) - CGRectGetHeight(imageRect)) / 2, CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(titleRect) / 2 + CGRectGetWidth(imageRect) / 2, (CGRectGetHeight(contentRect) - CGRectGetHeight(titleRect)) / 2, CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class ChildAccountButton: UIButton {
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setImageRect(imageR:CGRect, image:String, title:String, fontSize:CGFloat) -> Void {
        imageRect = imageR
        titleRect = textRect(title, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.setTitle(title, forState: .Normal)
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func setCustomImage(image:String,state:UIControlState) -> Void {
        self.setImage(UIImage.imageWithName(image), forState: state)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetWidth(contentRect) - 2 * CGRectGetWidth(imageRect) , (CGRectGetHeight(contentRect) - CGRectGetHeight(imageRect)) / 2, CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(10, (CGRectGetHeight(contentRect) - CGRectGetHeight(titleRect)) / 2, CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class AddChildAccountButton: UIButton {
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setImageRect(imageR:CGRect, image:String, title:String, fontSize:CGFloat) -> Void {
        imageRect = imageR
        titleRect = textRect(title, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.setTitle(title, forState: .Normal)
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMinX(self.titleLabel!.frame) - CGRectGetWidth(imageRect) - 2, (CGRectGetHeight(contentRect) - CGRectGetHeight(imageRect)) / 2, CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - CGRectGetWidth(titleRect) / 2 + CGRectGetWidth(imageRect) / 2, (CGRectGetHeight(contentRect) - CGRectGetHeight(titleRect)) / 2, CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class AbnormalButton: UIButton {
    private var imageRect:CGRect = CGRectZero
    private var titleRect:CGRect = CGRectZero
    
    func setImageRect(imageR:CGRect, image:String, title:String, fontSize:CGFloat) -> Void {
        imageRect = imageR
        titleRect = textRect(title, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)))
        self.setTitle(title, forState: .Normal)
        self.setImage(UIImage.imageWithName(image), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((CGRectGetWidth(contentRect) - CGRectGetWidth(imageRect)) / 2, CGRectGetHeight(contentRect) / 2 - CGRectGetHeight(imageRect) * (5 / 7), CGRectGetWidth(imageRect), CGRectGetHeight(imageRect))
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((CGRectGetWidth(contentRect) - CGRectGetWidth(titleRect)) / 2 , CGRectGetMidY(contentRect) + CGRectGetHeight(titleRect) * (3 / 2), CGRectGetWidth(titleRect), CGRectGetHeight(titleRect))
    }
}

class ConnectButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String, selectedImage:String, normalTitle:String, selectedTitle:String, fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        self.setTitle(selectedTitle, forState: .Selected)
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetWidth(contentRect) - imageSize.width * 2 , CGRectGetHeight(contentRect) / 2 - imageSize.height * (5 / 7), imageSize.width, imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetMidX(contentRect) - titleSize.width, CGRectGetMinY(contentRect), titleSize.width, titleSize.height)
    }
}

class BabyStatusButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String, selectedImage:String = "", normalTitle:String, selectedTitle:String = "", fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        if selectedTitle != "" {
            self.setTitle(selectedTitle, forState: .Selected)
        }
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        if selectedImage != "" {
            self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
        }
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(imageSize.width * (2 / 3), (CGRectGetHeight(contentRect) - imageSize.height) / 2, imageSize.width, imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(imageSize.width * (5 / 2), (CGRectGetHeight(contentRect) - titleSize.height) / 2, titleSize.width, titleSize.height)
    }
}

class BabyButton: UIButton {
    
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageSize(imgSize:CGSize, normaImage:String,title:String,fontSize:CGFloat) -> Void {
        imageSize = imgSize
        titleSize = title.size(UIFont.systemFontOfSize(fontSize))
        self.setTitle(title, forState: .Normal)
        self.setTitleColor(UIColor.hexStringToColor("#db6570"), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize - 1)
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.width - titleSize.width) / 2, y: contentRect.height / 2 + titleSize.height, width: titleSize.width, height: titleSize.height)
    }
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.width - imageSize.width) / 2, y: contentRect.height / 2 - imageSize.height, width: imageSize.width, height: imageSize.height)
    }
    
}

class MusicButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    
    func setImageSize(imgSize:CGSize, normaImage:String, selectedImage:String) -> Void {
        imageSize = imgSize
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.width - imageSize.width) * (2 / 3), y: (contentRect.height  - imageSize.height) * (2 / 3), width: imageSize.width, height: imageSize.height)
    }
}



class MoreArctileButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String, selectedImage:String = "", normalTitle:String, selectedTitle:String = "", fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        if selectedTitle != "" {
            self.setTitle(selectedTitle, forState: .Selected)
        }
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        if selectedImage != "" {
            self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
        }
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(CGRectGetWidth(contentRect) - imageSize.width * (3 / 2), (CGRectGetHeight(contentRect) - imageSize.height) / 2, imageSize.width, imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake(titleSize.width * (1 / 5), (CGRectGetHeight(contentRect) - titleSize.height) / 2, titleSize.width, titleSize.height)
    }
}

class DiaryListButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String) -> Void {
        imageSize = imageS
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((CGRectGetWidth(contentRect) - imageSize.width) * (1 / 2), (CGRectGetHeight(contentRect) - imageSize.height) / 2, imageSize.width, imageSize.height)
    }
    
}

class DeleteButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String) -> Void {
        imageSize = imageS
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRectMake((CGRectGetWidth(contentRect) - imageSize.width) * (1 / 2), (CGRectGetHeight(contentRect) - imageSize.height) / 2, imageSize.width, imageSize.height)
    }
}

class UserLoginButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String, normalTitle:String, fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.minX , y: (contentRect.height - imageSize.height) * (1 / 2), width: imageSize.width, height: imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.minX + imageSize.width * (3 / 2.5), y: (contentRect.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
    }
}

class CountDownButton: UIButton {
    private var reSendHandler:(()->())?
    
    var shouldStartAction:Bool!{
        didSet{
            if shouldStartAction == true {
                setTimeoutInterval(60, continuedHandler: { (continued) in
                    self.setTitle("\(Int(continued))", forState: .Normal)
                    self.userInteractionEnabled = false
                }) {
                    self.userInteractionEnabled = true
                    self.setTitle("重新发送", forState: .Normal)
                }
            }else{
                
            }
        }
    }
    
    
    func setupBase(frame:CGRect, tColor:UIColor = UIColor.whiteColor(), completionHandler:(()->())?) {
        self.frame = frame
        self.layer.cornerRadius = frame.height / 2
        self.layer.masksToBounds = true
        self.addTarget(self, action: #selector(CountDownButton.countDownClick(_:)), forControlEvents: .TouchUpInside)
        self.setTitle("发送验证码", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(10)
        self.reSendHandler = completionHandler
    }

        
    func countDownClick(btn:UIButton) -> Void {
        if let send = self.reSendHandler{
            send()
        }
    }
}

class DateButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageRect(imageS:CGSize, normaImage:String, normalTitle:String, fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.maxX - imageSize.width, y: contentRect.midY, width: imageSize.width, height: imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.width - titleSize.width) / 2, y: (contentRect.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
    }
}

class SexButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageSize(imageS:CGSize, normaImage:String, selectedImage:String = "", normalTitle:String, selectedTitle:String = "", fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        if selectedTitle != "" {
            self.setTitle(selectedTitle, forState: .Selected)
        }
        if normaImage != "" {
            self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        }
        if selectedImage != "" {
            self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
        }
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.maxX - (3 / 2) * imageSize.width, y: (contentRect.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.minX + titleSize.width * (3 / 2), y: (contentRect.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
    }
}

class PregStatusButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageSize(imageS:CGSize, normaImage:String, selectedImage:String = "", normalTitle:String, selectedTitle:String = "", fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = textRect(normalTitle, fontSize: fontSize, size: CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))).size
        self.setTitle(normalTitle, forState: .Normal)
        if selectedTitle != "" {
            self.setTitle(selectedTitle, forState: .Selected)
        }
        if normaImage != "" {
            self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        }
        if selectedImage != "" {
            self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
        }
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.maxX - (3 / 2) * imageSize.width, y: (contentRect.height - imageSize.height) / 2, width: imageSize.width, height: imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.minX + titleSize.width * (1 / 3), y: (contentRect.height - titleSize.height) / 2, width: titleSize.width, height: titleSize.height)
    }
}

class DeviceButton: UIButton {
    private var imageSize:CGSize = CGSizeZero
    private var titleSize:CGSize = CGSizeZero
    
    func setImageSize(imageS:CGSize, titleS:CGSize, normaImage:String, selectedImage:String = "", normalTitle:String, selectedTitle:String = "", fontSize:CGFloat) -> Void {
        imageSize = imageS
        titleSize = titleS
        self.setTitle(normalTitle, forState: .Normal)
        self.titleLabel?.textAlignment = .Left
        self.titleLabel?.lineBreakMode = .ByWordWrapping
        self.titleLabel?.numberOfLines = 0
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(fontSize)
        if selectedTitle != "" {
            self.setTitle(selectedTitle, forState: .Selected)
        }
        if normaImage != "" {
            self.setImage(UIImage.imageWithName(normaImage), forState: .Normal)
        }
        if selectedImage != "" {
            self.setImage(UIImage.imageWithName(selectedImage), forState: .Selected)
        }
    }
    
    func addCustomTarget(target:AnyObject?, sel:Selector) -> Void {
        self.addTarget(target, action: sel, forControlEvents: .TouchUpInside)
    }
    
    func setCustomTitleColor(color:UIColor = UIColor.lightGrayColor()) -> Void {
        self.setTitleColor(color, forState: .Normal)
    }
    
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.minX, y: contentRect.minY + imageSize.height / 2, width: imageSize.width, height: imageSize.height)
    }
    
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: contentRect.minX + 1.2 * imageSize.width, y: contentRect.minY, width: titleSize.width, height: titleSize.height)
    }
}

//MARK:_____PAGECONTROL_____


@IBDesignable public class FilledPageControl: UIView {
    
    // MARK: - PageControl
    
    @IBInspectable public var pageCount: Int = 0 {
        didSet {
            updateNumberOfPages(pageCount)
        }
    }
    @IBInspectable public var progress: CGFloat = 0 {
        didSet {
            updateActivePageIndicatorMasks(progress)
        }
    }
    public var currentPage: Int {
        return Int(round(progress))
    }
    
    
    // MARK: - Appearance
    
    override public var tintColor: UIColor! {
        didSet {
            inactiveLayers.forEach() { $0.backgroundColor = tintColor.CGColor }
        }
    }
    
    public var borderColor:UIColor!{
        didSet{
            inactiveLayers.forEach() {$0.borderColor = borderColor.CGColor}
        }
    }
    
    @IBInspectable public var inactiveRingWidth: CGFloat = 1 {
        didSet {
            updateActivePageIndicatorMasks(progress)
        }
    }
    @IBInspectable public var indicatorPadding: CGFloat = 10 {
        didSet {
            layoutPageIndicators(inactiveLayers)
        }
    }
    @IBInspectable public var indicatorRadius: CGFloat = 5 {
        didSet {
            layoutPageIndicators(inactiveLayers)
        }
    }
    
    private var indicatorDiameter: CGFloat {
        return indicatorRadius * 2
    }
    private var inactiveLayers = [CALayer]()
    
    
    // MARK: - State Update
    
    private func updateNumberOfPages(count: Int) {
        // no need to update
        guard count != inactiveLayers.count else { return }
        // reset current layout
        inactiveLayers.forEach() { $0.removeFromSuperlayer() }
        inactiveLayers = [CALayer]()
        // add layers for new page count
        inactiveLayers = 0.stride(to:count, by:1).map() { _ in
            let layer = CALayer()
            layer.backgroundColor = self.tintColor.CGColor
            layer.borderWidth = 1
            layer.borderColor = self.borderColor == nil ? self.tintColor.CGColor : self.borderColor.CGColor
            self.layer.addSublayer(layer)
            return layer
        }
        layoutPageIndicators(inactiveLayers)
        updateActivePageIndicatorMasks(progress)
        self.invalidateIntrinsicContentSize()
    }
    
    
    // MARK: - Layout
    
    private func updateActivePageIndicatorMasks(progress: CGFloat) {
        // ignore if progress is outside of page indicators' bounds
        guard progress >= 0 && progress <= CGFloat(pageCount - 1) else { return }
        
        // mask rect w/ default stroke width
        let insetRect = CGRectInset(
            CGRect(x: 0, y: 0, width: indicatorDiameter, height: indicatorDiameter),
            inactiveRingWidth, inactiveRingWidth)
        let leftPageFloat = trunc(progress)
        let leftPageInt = Int(progress)
        
        // inset right moving page indicator
        let spaceToMove = insetRect.width / 2
        let percentPastLeftIndicator = progress - leftPageFloat
        let additionalSpaceToInsetRight = spaceToMove * percentPastLeftIndicator
        let closestRightInsetRect = CGRectInset(insetRect, additionalSpaceToInsetRight, additionalSpaceToInsetRight)
        
        // inset left moving page indicator
        let additionalSpaceToInsetLeft = (1 - percentPastLeftIndicator) * spaceToMove
        let closestLeftInsetRect = CGRectInset(insetRect, additionalSpaceToInsetLeft, additionalSpaceToInsetLeft)
        
        // adjust masks
        for (idx, layer) in inactiveLayers.enumerate() {
            let maskLayer = CAShapeLayer()
            maskLayer.fillRule = kCAFillRuleEvenOdd
            
            let boundsPath = UIBezierPath(rect: layer.bounds)
            let circlePath: UIBezierPath
            if leftPageInt == idx {
                circlePath = UIBezierPath(ovalInRect: closestLeftInsetRect)
            } else if leftPageInt + 1 == idx {
                circlePath = UIBezierPath(ovalInRect: closestRightInsetRect)
            } else {
                circlePath = UIBezierPath(ovalInRect: insetRect)
            }
            boundsPath.appendPath(circlePath)
            maskLayer.path = boundsPath.CGPath
            layer.mask = maskLayer
        }
    }
    
    private func layoutPageIndicators(layers: [CALayer]) {
        let layerDiameter = indicatorRadius * 2
        var layerFrame = CGRect(x: 0, y: 0, width: layerDiameter, height: layerDiameter)
        layers.forEach() { layer in
            layer.cornerRadius = self.indicatorRadius
            layer.frame = layerFrame
            layerFrame.origin.x += layerDiameter + indicatorPadding
        }
    }
    
    override public func intrinsicContentSize() -> CGSize {
        return sizeThatFits(CGSize.zero)
    }
    
    override public func sizeThatFits(size: CGSize) -> CGSize {
        let layerDiameter = indicatorRadius * 2
        return CGSize(width: CGFloat(inactiveLayers.count) * layerDiameter + CGFloat(inactiveLayers.count - 1) * indicatorPadding,
                      height: layerDiameter)
    }
}

//MARK:____NSCALENDAR____
private let kRow:CGFloat = 7
private let kCol:CGFloat = 7
private let kTotalNum:Int = (Int)((kRow - 1) * kCol)
private let kButtonStartTag = 100

class MyCalendar: UIView {
    private var year:Int = 0
    private var month:Int = 0
    private var titleLabel:UILabel!
    private var weekColor:UIColor!
    private var dayColor:UIColor!
    private var selectedImage:UIImage!
    private var dayWidth:CGFloat!
    private var currentMonthDaysArray:[NSTimeInterval]!
    private var currentMonthStartIndex:Int = 0
    private var selectedArray:[NSTimeInterval]!
    private var dateTimeHandler:((year:Int, month:Int, day:Int)->())?
    var defaultDays:[NSTimeInterval]!{
        didSet{
            self.selectedArray = defaultDays
        }
    }
    
    init(frame: CGRect, weekColor:UIColor = UIColor.whiteColor(), dayColor:UIColor = UIColor.whiteColor(), selectedImage:UIImage?, completionHandler:((year:Int,month:Int, day:Int)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 223 / 255.0, green: 98 / 255.0, blue: 113 / 255.0, alpha: 0.8)
        self.weekColor = weekColor
        self.dayColor = dayColor
        self.dayWidth = CGRectGetWidth(self.frame) / 7
        self.selectedImage = selectedImage == nil ? UIImage.imageWithSize(CGSizeMake(self.dayWidth, self.dayWidth), fillColor: UIColor.redColor(), alphaColor: UIColor.redColor()) : selectedImage

        self.initializeData()
        
        self.dateTimeHandler = completionHandler
    }
    
    deinit{
        self.selectedArray = nil
        self.currentMonthDaysArray = nil
        self.weekColor = nil
        self.dayColor = nil
        self.selectedImage = nil
        self.titleLabel = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showCalendar() -> Void {
        self.hidden = false
    }
    
    func hideCalendar() -> Void {
        self.hidden = true
    }
    
    func refreshCalendar(year:Int, month:Int) -> Void {
        self.year = year
        self.month = month
        self.refreshDays()
    }
    
    func confirmDate(completionHandler:((dates:[NSTimeInterval])->())?) -> Void {
        if let handle = completionHandler {
            handle(dates: self.selectedArray)
        }
        self.hideCalendar()
    }
        
    private func initializeData(){
        self.selectedArray = []
        self.currentMonthDaysArray = []
        self.currentMonthStartIndex = 0
        for _ in 0 ... kTotalNum {
            self.currentMonthDaysArray.append(0)
        }
        
        self.refreshDays()
    }
    
    private func refreshDays(){
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        self.drawTitles()
        self.drawCurrentMonthDate()
        self.refreshDateView()
    }
    
    private func drawTitles(){
        let titles = ["一","二","三","四","五","六","日"]
        for i in 0 ..< titles.count {
            let titleLabel = UILabel.init(frame: CGRectMake(CGFloat(i) * self.dayWidth, 0, self.dayWidth, self.dayWidth))
            titleLabel.text = titles[i]
            titleLabel.textColor = self.weekColor
            titleLabel.font = UIFont.systemFontOfSize(15)
            titleLabel.textAlignment = .Center
            self.addSubview(titleLabel)
        }
    }
    
    private func drawCurrentMonthDate(){
        let monthFirstDay = NSDate.date(year: year, month: month, day: 1)
        self.currentMonthStartIndex = monthFirstDay.weekday
        if self.currentMonthStartIndex == 1 {
            self.currentMonthStartIndex = 6
        }else{
            self.currentMonthStartIndex -= 2
        }
        var baseRect = CGRectMake(CGFloat(self.currentMonthStartIndex) * self.dayWidth, dayWidth, dayWidth, dayWidth)
        for i in self.currentMonthStartIndex ..< kTotalNum {
            if CGFloat(i) % kCol == 0 && i != 0 {
                baseRect.origin.y += baseRect.size.height
                baseRect.origin.x = 0.0
            }
            self.setupButtons(i - self.currentMonthStartIndex, frame: baseRect)
            baseRect.origin.x += baseRect.size.width
        }
    }
    
    private func setupButtons(index:Int, frame:CGRect){
        let btn = UIButton.init(type: .Custom)
        btn.tag = kButtonStartTag + index
        btn.frame = frame
        btn.titleLabel?.font = UIFont.systemFontOfSize(15)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        
        let monthFirstDay = NSDate.date(year: self.year, month: self.month, day: 1)
        let date = monthFirstDay + index.days
        self.currentMonthDaysArray[index] = date.timeIntervalSince1970
        var title = "\(date.day)"
        if date.isEqualToDate(NSDate.today()) {
            title = "今天"
        }else if date.day == 1{
            let monthLable:UILabel   = UILabel.init(frame: CGRectMake(0, frame.size.height - CGRectGetHeight(frame) / 5, frame.size.width, CGRectGetHeight(frame) / 5))
            monthLable.textAlignment = NSTextAlignment.Center
            monthLable.font          = UIFont.systemFontOfSize(7)
            monthLable.textColor     = UIColor.hexStringToColor("#c0c0c0")
            monthLable.text          = String(date.month)
            btn.addSubview(monthLable)
        }
        
        if date > NSDate.today() {
            btn.setTitleColor(UIColor.hexStringToColor("#2b2b2b"), forState: .Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: .Selected)
            btn.setBackgroundImage(self.selectedImage, forState: .Selected)
            btn.setBackgroundImage(nil, forState: .Normal)
            btn.enabled = true
        }
//        else{
//            btn.setTitleColor(UIColor.hexStringToColor("#bfbfbf"), forState: .Disabled)
//            btn.enabled = false
//        }
        btn.setTitle(title, forState: .Normal)
        btn.addTarget(self, action: #selector(MyCalendar.dayButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(btn)
    }
    
    
    private func refreshDateView(){
        for i in 0 ..< kTotalNum {
            let btn = self.viewWithTag(kButtonStartTag + i) as? UIButton
            if let selectedBtn = btn {
                if self.selectedArray.contains(self.currentMonthDaysArray[i]) {
                    selectedBtn.selected = true
                }
            }
        }
    }

    func dayButtonClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        
        let currentInterval = self.currentMonthDaysArray[btn.tag - kButtonStartTag]
        if btn.selected == true {
            if !self.selectedArray.contains(currentInterval) {
                self.selectedArray.append(currentInterval)
            }
        }else{
            if self.selectedArray.contains(currentInterval) {
                self.selectedArray.removeAtIndex(self.selectedArray.indexOf(currentInterval)!)
            }
        }
        
        let date = NSDate.init(timeIntervalSince1970: currentInterval)
        if btn.selected && date.month > self.month {
            self.switchToRight()
        }
        if btn.selected && date.month < self.month {
            self.switchToLeft()
        }
        if let dateHandle = dateTimeHandler {
            var day = 0
            if let btnTitle = btn.titleLabel?.text {
                if let titleDay = Int(btnTitle) {
                    day = titleDay
                }
            }
            
            dateHandle(year: self.year, month: self.month, day: day)
        }
    }
    
    
    private func switchToLeft(){
        if self.month > 1 {
            self.month -= 1
        }else{
            self.month = 12
            self.year -= 1
        }
        self.refreshDays()
    }
    
    private func switchToRight(){
        if self.month < 12 {
            self.month += 1
        }else{
            self.month = 1
            self.year += 1
        }
        self.refreshDays()
    }
}

class HMToolbar: UIToolbar {
    
    private var enterHandler:(()->())?
    
    init(frame: CGRect,enterCompletionHandler:(()->())?) {
        super.init(frame: frame)
        let spaceBar = UIBarButtonItem.init(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let dismissBar = UIBarButtonItem.init(title: "完成", style: .Plain, target: self, action: #selector(HMToolbar.dismissKeyboard))
        let buttons = [spaceBar, dismissBar]
        self.items = buttons
        self.enterHandler = enterCompletionHandler
    }
    
    func dismissKeyboard() -> Void {
        if let handle = self.enterHandler {
            handle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}






