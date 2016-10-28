//
//  DiaryDetailView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/1.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let pregDiaryTipsColumn = 3
private let cornerImageViewWidth:CGFloat = 30
private let diaryDetailTipsWidth = upRateWidth(40)
private let diaryDetailTipsHeight = upRateHeight(15)

class DiaryDetailView: UIView {
    init(frame: CGRect,model:Diary) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let imageView = UIImageView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) * (3 / 5)))
        imageView.image = model.images.count == 0 ? UIImage.imageWithName("yunfumama.png") : UIImage.imageWithName(model.images[0])
        self.addSubview(imageView)
        let labels = NoteLabelBL.findVia(model.noteLabels)
        for i in 0 ..< labels.count {
            let columnIndex = i % pregDiaryTipsColumn
            let rowIndex = i / pregDiaryTipsColumn
            let itemLabel = UILabel.init(frame: CGRectMake(upRateWidth(10) + CGFloat(columnIndex) * (diaryDetailTipsWidth + upRateWidth(2)), upRateHeight(10) + CGFloat(rowIndex) * (diaryDetailTipsHeight + upRateHeight(3)), diaryDetailTipsWidth, diaryDetailTipsHeight))
            itemLabel.layer.cornerRadius = upRateWidth(3)
            itemLabel.layer.masksToBounds = true
            itemLabel.backgroundColor = UIColor.hexStringToColor("#d95b7d")
            itemLabel.font = UIFont.systemFontOfSize(upRateWidth(10))
            itemLabel.text = labels[i]
            itemLabel.textAlignment = .Center
            itemLabel.textColor = UIColor.whiteColor()
            self.addSubview(itemLabel)
        }
        
//        let weightLabel = UILabel.init(frame: CGRectMake((3 / 4) * CGRectGetWidth(self.frame), upRateHeight(10) + diaryDetailTipsHeight / 2, CGRectGetWidth(self.frame) / 4, upRateHeight(25)))
//        weightLabel.textAlignment = .Center
//        let fullFont = FontAttribute.init(font: UIFont.systemFontOfSize(upRateWidth(25)), effectRange: NSMakeRange(0, model.weight.characters.count))
//        let fullColor = ForegroundColorAttribute.init(color: UIColor.colorFromRGB(204, g: 100, b: 132)!, effectRange: NSMakeRange(0, model.weight.characters.count))
//        let partFont = FontAttribute(font: UIFont.systemFontOfSize(upRateWidth(12)), effectRange: NSMakeRange(model.weight.characters.count - 2, 2))
//        
//        weightLabel.attributedText = model.weight.mutableAttributedStringWithStringAttributes([fullFont,partFont,fullColor])
//        self.addSubview(weightLabel)
        
        let date2Label = UILabel.init(frame: CGRectMake(CGRectGetMidX(imageView.frame), CGRectGetMaxY(imageView.frame) - upRateHeight(25), CGRectGetWidth(imageView.frame) / 2 - 10, upRateHeight(25)))
        date2Label.text = "第 \(model.breedStatusDate) 天"
        date2Label.textAlignment = .Right
        date2Label.font = UIFont.boldSystemFontOfSize(15)
        date2Label.textColor = UIColor.colorFromRGB(204, g: 100, b: 132)
        self.addSubview(date2Label)
        
        
        let faceImageView = UIImageView.init(frame: CGRectMake(CGRectGetMaxX(date2Label.frame) - upRateWidth(20), CGRectGetMinY(date2Label.frame) - upRateWidth(20), upRateWidth(20), upRateWidth(20)))
        faceImageView.image = UIImage.imageWithName(self.moodStatus(model.moodStatus))
        faceImageView.layer.cornerRadius = upRateWidth(20) / 2
        faceImageView.layer.masksToBounds = true
        self.addSubview(faceImageView)
        
        let descLabel = UILabel.init(frame: CGRectMake(upRateWidth(10) + diaryDetailTipsWidth / 2, CGRectGetHeight(self.frame) * (4 / 5) - upRateHeight(30), CGRectGetWidth(self.frame) - 2 * (upRateWidth(10) + diaryDetailTipsWidth / 2), 2 * upRateHeight(30)))
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.textColor = UIColor.lightGrayColor()
        descLabel.numberOfLines = 0
        descLabel.font = UIFont.systemFontOfSize(upRateHeight(12))
        descLabel.text = model.content
        self.addSubview(descLabel)
        
        let date1Label = UILabel.init(frame: CGRectMake(CGRectGetMinX(descLabel.frame), CGRectGetMinY(descLabel.frame) - 15, CGRectGetWidth(descLabel.frame), upRateWidth(20)))
        date1Label.text = model.createDate
        date1Label.textColor = UIColor.lightGrayColor()
        date1Label.font = UIFont.systemFontOfSize(upRateHeight(17))
        self.addSubview(date1Label)
        
        let cornerImageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(self.frame) - cornerImageViewWidth, CGRectGetHeight(self.frame) - cornerImageViewWidth, cornerImageViewWidth, cornerImageViewWidth))
        cornerImageView.image = UIImage.imageWithSize(CGSizeMake(cornerImageViewWidth, cornerImageViewWidth), fillColor: UIColor.colorFromRGB(197, g: 107, b: 93, a: 1.0)!, alphaColor: UIColor.colorFromRGB(197, g: 107, b: 93, a: 0.1)!)
        self.addSubview(cornerImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
