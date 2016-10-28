//
//  DiaryListView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/9.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let pregDiaryRowHeight:CGFloat = upRateHeight(120)


private let diaryArrowImageViewWidth:CGFloat = 10
private let diaryArrowImageViewHeight:CGFloat = 15
class DiaryListHeaderView: UIView {

    private var month:Int = 0
    private var year:Int = 0
    private var day:Int = 0
    private var clickHandler:((month: Int, year: Int, day:Int)->())?
    private var dateLabel:UILabel!
    
//    private var calendarView:MyCalendar!
//    private var selected:Bool!{
//        didSet{
//            if selected == true && self.calendarView == nil {
//                self.calendarView = MyCalendar.init(frame: CGRectMake((ScreenWidth - 250) / 2, (ScreenHeight - 250) / 2, 250, 250), selectedImage: nil, completionHandler: { [weak self](year, month, day) in
//                    if let weakSelf = self {
//                        weakSelf.dateLabel.text = weakSelf.formatDate(month, year: year)
//                        weakSelf.month = month
//                        weakSelf.year = year
//                        weakSelf.day = day
//                        if let handle = weakSelf.clickHandler {
//                            handle(month: month, year: year, day: day)
//                        }
//                    }
//                })
//                self.calendarView.refreshCalendar(self.year, month: self.month)
//                UIApplication.sharedApplication().keyWindow?.addSubview(self.calendarView)
//                
//            }
//                
//            if self.selected == false && self.calendarView != nil {
//                self.calendarView.removeFromSuperview()
//                self.calendarView = nil
//            }
//        }
//    }
    
    
    
    
    init(frame: CGRect, clickCompletionHandler:((month: Int, year: Int, day:Int)->())?) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.hexStringToColor("#de7a85")
//        self.selected = false
        self.month = NSDate.today().month
        self.year = NSDate.today().year
        self.day = NSDate.today().day
        
        let leftImageView = UIImageView.init(frame: CGRectMake(15, (CGRectGetHeight(self.frame) - diaryArrowImageViewHeight) / 2, diaryArrowImageViewWidth, diaryArrowImageViewHeight))
        leftImageView.image = UIImage.imageWithName("arrow_left.png")
        self.addSubview(leftImageView)
        
        let rightImageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(self.frame) - 15 - diaryArrowImageViewWidth, CGRectGetMinY(leftImageView.frame), CGRectGetWidth(leftImageView.frame), CGRectGetHeight(leftImageView.frame)))
        rightImageView.image = UIImage.imageWithName("arrow_left.png")
        rightImageView.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        self.addSubview(rightImageView)
        
        self.dateLabel = UILabel.init(frame: CGRectMake((CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame) * (1 / 3))) / 2, 0, CGRectGetWidth(self.frame) / 3, CGRectGetHeight(self.frame)))
        self.dateLabel.text = self.formatDate(self.month, year: self.year)
        self.dateLabel.textColor = UIColor.whiteColor()
        self.dateLabel.textAlignment = .Center
        self.dateLabel.font = UIFont.systemFontOfSize(upRateWidth(18))
        self.addSubview(self.dateLabel)
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(DiaryListHeaderView.calendarNavViewClick(_:)))
        self.addGestureRecognizer(tapGesture)
        
        self.clickHandler = clickCompletionHandler
        if let handle = clickCompletionHandler {
            handle(month: self.month, year: self.year, day: self.day)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func formatDate(month:Int, year:Int) ->String{
        return "\(month)月 \(year)年"
    }
    
    
    func calendarNavViewClick(tap:UITapGestureRecognizer) -> Void {
        let location = tap.locationInView(self)
        let tapViewWidth = CGRectGetWidth(self.frame)
        switch location.x {
        case 0 ..< tapViewWidth / 3:
            self.switchLeft()
        case tapViewWidth / 3 ..< tapViewWidth * (2 / 3):
            break
//            self.selected = !self.selected
        case tapViewWidth * (2 / 3) ..< tapViewWidth:
            self.swithRight()
        default:
            break
        }
        self.dateLabel.text = self.formatDate(self.month, year: self.year)
//        if self.calendarView != nil {
//            self.calendarView.refreshCalendar(self.year, month: self.month)
//        }
        if let handle = self.clickHandler{
            handle(month: self.month, year: self.year, day: self.day)
        }
    }
    
    private func switchLeft(){
        if self.month > 1 {
            self.month -= 1
        }else{
            self.month = 12
            self.year -= 1
        }
    }
    
    private func swithRight(){
        if self.month < 12 {
            self.month += 1
        }else{
            self.month = 1
            self.year += 1
        }
    }
}

class DiaryListCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func refreshCell(model:Diary) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame.size.height = pregDiaryRowHeight
        
        let imageHeight = CGRectGetHeight(self.contentView.frame) * (2 / 3)
        let imageView = UIImageView.init(frame: CGRectMake(10, (CGRectGetHeight(self.contentView.frame) - imageHeight) / 2, imageHeight, imageHeight))
        if model.images.count > 0 {
            imageView.setImageURL(model.images[0])
        }else{
            imageView.image = UIImage.imageWithName("pregnantMama.png")
        }
        self.contentView.addSubview(imageView)
        
        let dateLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMinY(imageView.frame), CGRectGetWidth(self.frame) / 3.3, CGRectGetHeight(imageView.frame) / 4))
        dateLabel.text = model.createTime
        dateLabel.textColor = UIColor.darkGrayColor()
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.font = UIFont.systemFontOfSize(upRateWidth(15))
        self.contentView.addSubview(dateLabel)
        
        let faceHeight = DiaryButton.init(frame: CGRectMake(CGRectGetMinX(dateLabel.frame) + 3, CGRectGetMidY(imageView.frame) - CGRectGetHeight(imageView.frame) / 4, CGRectGetWidth(dateLabel.frame) - 5, CGRectGetHeight(imageView.frame) / 4))
        faceHeight.setImageRect(CGRectMake(0, 0, upRateWidth(15), upRateWidth(15)), image: self.moodStatus(model.moodStatus), title: "第\(self.weakAndDayFromNumber(model.breedStatusDate).0)周+\(self.weakAndDayFromNumber(model.breedStatusDate).1)天", fontSize: upRateWidth(12))
        faceHeight.enabled = false
        faceHeight.setCustomTitleColor(UIColor.darkGrayColor())
        self.contentView.addSubview(faceHeight)
        
        let descLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(dateLabel.frame), CGRectGetMidY(imageView.frame), ScreenWidth - 2 * viewOriginX - CGRectGetMinX(dateLabel.frame) - 10, CGRectGetHeight(imageView.frame) / 2))
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.minimumScaleFactor = 0.8
        descLabel.font = UIFont.systemFontOfSize(upRateWidth(12))
        descLabel.text = model.content == "" ? "测试测试，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据，测试测试，测试数据" : model.content
        descLabel.numberOfLines = 0
        descLabel.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(descLabel)
        
        let tipWidth = CGRectGetWidth(self.contentView.frame) * (1 / 11)
        let tipHeight = CGRectGetHeight(dateLabel.frame) * (2 / 3)
        let labels = NoteLabelBL.findVia(model.noteLabels)
        for i in 0 ..< labels.count {
            let columnIndex = i % pregDiaryTipsColumn
            let rowIndex = i / pregDiaryTipsColumn
            let itemLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(dateLabel.frame) + CGFloat(columnIndex) * (tipWidth + upRateWidth(2)), CGRectGetMidY(dateLabel.frame) + CGFloat(rowIndex) * (tipHeight + upRateHeight(3)) - tipHeight / 2, tipWidth, tipHeight))
            itemLabel.layer.cornerRadius = upRateWidth(3)
            itemLabel.layer.masksToBounds = true
            itemLabel.layer.borderColor = UIColor.colorFromRGB(204, g: 100, b: 132)!.CGColor
            itemLabel.layer.borderWidth = upRateWidth(1)
            itemLabel.font = UIFont.systemFontOfSize(upRateWidth(10))
            itemLabel.text = labels[i]
            itemLabel.textAlignment = .Center
            itemLabel.textColor = UIColor.colorFromRGB(204, g: 100, b: 132)
            self.contentView.addSubview(itemLabel)
        }
    }
    
}
