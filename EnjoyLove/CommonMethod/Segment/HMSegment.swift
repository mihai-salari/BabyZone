//
//  HMSegment.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/14.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let HMSegmentStartIndex = 100000
class HMSegment: UIScrollView {
    
    var cornerRadius:CGFloat = 0{
        didSet{
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    var borderColor:UIColor = UIColor.clearColor(){
        didSet{
            if let btns = self.buttons {
                for button in btns {
                    button.layer.borderColor = self.borderColor.CGColor
                }
            }
        }
    }
    
    var borderWidth:CGFloat = 0{
        didSet{
            if let btns = self.buttons {
                for button in btns {
                    button.layer.borderWidth = self.borderWidth
                }
            }
        }
    }
    
    var normalTitleColor:UIColor = UIColor.blackColor(){
        didSet{
            if let btns = self.buttons {
                for button in btns {
                    button.setTitleColor(normalTitleColor, forState: .Normal)
                }
            }
        }
    }
    
    var selectedTitleColor:UIColor = UIColor.blackColor(){
        didSet{
            if let btns = self.buttons {
                for button in btns {
                    button.setTitleColor(selectedTitleColor, forState: .Selected)
                }
            }
        }
    }
    
    var font:UIFont = UIFont.systemFontOfSize(15){
        didSet{
            if let btns = self.buttons {
                for button in btns {
                    button.titleLabel?.font = font
                }
            }
        }
    }
    
    
    
    var indicatorColor:UIColor = UIColor.whiteColor(){
        didSet{
            if let view = self.indicatorView {
                view.backgroundColor = indicatorColor
            }
        }
    }
    
    var indicatorImage = ""{
        didSet{
            if let view = self.indicatorView {
                view.backgroundColor = indicatorColor
            }
        }
    }
    
    var selectedSegmentIndex:Int = 0{
        didSet{
            
            if let handle = self.segmengHandler {
                handle(index: self.selectedSegmentIndex)
            }
            
            if let btns = self.buttons {
                for i in 0 ..< btns.count {
                    if i == selectedSegmentIndex {
                        btns[i].selected = true
                        UIView.animateWithDuration(0.3) {
                            self.indicatorView.frame.origin = CGPointMake(CGFloat(self.selectedSegmentIndex) * CGRectGetWidth(btns[i].frame), 0)
                        }
                    }else{
                        btns[i].selected = false
                    }
                }
            }
        }
    }
    
    var indicatorOffset:CGPoint = CGPointZero{
        didSet{
            if let view = self.indicatorView {
                view.frame.origin = indicatorOffset
            }
        }
    }
    
    var showPage:Int = 3{
        didSet{
            if self.indicatorView != nil && self.buttons != nil && self.buttons.count > 0 {
                let viewWidth = self.width / CGFloat(showPage)
                self.contentSize = CGSizeMake(viewWidth * CGFloat(self.buttons.count), self.height)
                self.indicatorView.width = viewWidth
                for btn in self.buttons {
                    btn.width = viewWidth
                }
            }
            
        }
    }
    
    
    private var indicatorView:UIImageView!
    private var items:[AnyObject]!
    private var buttons:[UIButton]!
    private var segmengHandler:((index:Int)->())?
    
    init(frame:CGRect, items:[AnyObject]?, completionHandler:((index:Int)->())?){
        super.init(frame: frame)
        if let ms = items {
            if  ms.count > 0 {
                self.items = ms
            }else{
                self.items = ["item1", "item2"]
            }
        }else{
            self.items = ["item1", "item2"]
        }
        self.initializeSubviews()
        self.segmengHandler = completionHandler
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeSubviews(){
        
        self.layer.cornerRadius = self.cornerRadius
        self.showsHorizontalScrollIndicator = false
        
        var size = CGSizeZero
        if let item = self.items {
            let itemStr = item[0] as! String
            size = NSString.init(string: itemStr).boundingRectWithSize(CGSizeMake(CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(self.frame)), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(25)], context: nil).size
        }
        self.contentSize = CGSizeMake(size.width * CGFloat(self.items.count), CGRectGetHeight(self.frame))
        self.indicatorView = UIImageView.init(frame: CGRectMake(0, 0, size.width, CGRectGetHeight(self.frame)))
        if self.indicatorImage != "" {
            self.indicatorView.image = UIImage.init(named: self.indicatorImage)
        }else{
            self.indicatorView.backgroundColor = self.indicatorColor
        }
        self.indicatorView.backgroundColor = UIColor.blackColor()
        self.addSubview(self.indicatorView)
        
        self.buttons = []
        for i in 0 ..< self.items.count {
            let itemButton = UIButton.init(type: .Custom)
            itemButton.frame = CGRectMake(size.width * CGFloat(i), 0, size.width, CGRectGetHeight(self.frame))
            if i == self.selectedSegmentIndex {
                itemButton.selected = true
            }
            if self.items[i].isKindOfClass(UIImage) {
                let image = self.items[i] as! UIImage
                itemButton.setImage(image, forState: .Normal)
            }else if self.items[i].isKindOfClass(NSString){
                let item = self.items[i] as! String
                itemButton.setTitle(item, forState: .Normal)
                itemButton.setTitleColor(self.normalTitleColor, forState: .Normal)
                itemButton.setTitleColor(self.selectedTitleColor, forState: .Selected)
            }
            itemButton.addTarget(self, action: #selector(HMSegment.didSelectedSegment(_:)), forControlEvents: .TouchUpInside)
            itemButton.layer.borderColor = self.borderColor.CGColor
            itemButton.layer.borderWidth = self.borderWidth
            itemButton.tag = HMSegmentStartIndex + i
            self.addSubview(itemButton)
            self.buttons.append(itemButton)
            
        }
        
    }
    
    
    func didSelectedSegment(btn:UIButton) ->Void{
        if self.selectedSegmentIndex ==  btn.tag - HMSegmentStartIndex{
            return
        }
        self.selectedSegmentIndex = btn.tag - HMSegmentStartIndex
        
        let rightDistance = CGRectGetWidth(self.frame) - CGRectGetMaxX(self.indicatorView.frame)
        if rightDistance < CGRectGetWidth(self.indicatorView.frame) {
            UIView.animateWithDuration(0.5, animations: {
                if Int(CGRectGetMaxX(self.indicatorView.frame)) == Int(self.contentSize.width){
                    return
                }else{
                    self.contentOffset.x = CGRectGetWidth(self.indicatorView.frame) - rightDistance
                }
            })
        }
        
        if CGRectGetMinX(self.indicatorView.frame) - self.contentOffset.x < CGRectGetWidth(self.indicatorView.frame){
            UIView.animateWithDuration(0.5, animations: {
                self.contentOffset.x = 0
            })
        }
    }
    
    func fetchSegmentIndex(completionHandler:((index:Int)->())?) -> Void {
        if let handle = completionHandler {
            handle(index: self.selectedSegmentIndex)
        }
        self.segmengHandler = completionHandler
    }
    
}
