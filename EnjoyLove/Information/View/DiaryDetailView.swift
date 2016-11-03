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
    init(frame: CGRect,model:Diary, isConfirm:Bool = false) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        let imageContainView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height:  self.frame.height * (3 / 5)))
        self.addSubview(imageContainView)
        if model.imageArr != nil && model.imageArr.count > 0 {
            if model.imageArr.count == 1 {
                imageContainView.layer.contents = UIImage.imageWithName("mamaHeader.png")?.CGImage
                imageContainView.layer.contents = model.imageArr[0].CGImage
            }else{
                let imageWidth = imageContainView.frame.width * (1 / 3) - 2 * 5
                let imageHeight = imageContainView.frame.height * (1 / 2) - 5
                for i in 0 ..< model.imageArr.count {
                    let columnIndex = i % pregDiaryTipsColumn
                    let rowIndex = i / pregDiaryTipsColumn
                    
                    let imageView = UIView.init(frame: CGRect.init(x: 5 + CGFloat(columnIndex) * (imageWidth + 5), y: 5 + CGFloat(rowIndex) * (imageHeight + 5), width: imageWidth, height: imageHeight))
                    imageView.layer.contents = UIImage.imageWithName("mamaHeader.png")?.CGImage
                    imageView.layer.contents = model.imageArr[i].CGImage
                    imageContainView.addSubview(imageView)
                }
            }
        }else{
            if isConfirm == true {
                let label = UILabel.init(frame: imageContainView.bounds)
                label.text = "您未选择图片"
                label.textColor = UIColor.hexStringToColor("#986273")
                label.textAlignment = .Center
                imageContainView.addSubview(label)
            }else{
                imageContainView.layer.contents = UIImage.imageWithName("mamaHeader.png")?.CGImage
            }
        }
        
        let labels = model.noteLabels == nil ? NoteLabelBL.findVia(model.noteLabels) : model.noteLabels
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
        
        
        let date2Label = UILabel.init(frame: CGRectMake(CGRectGetMidX(imageContainView.frame), CGRectGetMaxY(imageContainView.frame) - upRateHeight(25), CGRectGetWidth(imageContainView.frame) / 2 - 10, upRateHeight(25)))
        let babyId = BabyZoneConfig.shared.BabyBaseInfoKey.defaultString()
        if babyId != "" {
            if let baseInfo = BabyBaseInfoBL.find(babyId) {
                date2Label.text = self.resultDay(baseInfo)
            }else{
                date2Label.text = "第0周第0天"
            }
        }else{
            date2Label.text = "第0周第0天"
        }
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
    
    
    private func resultDay(babyInfo:BabyBaseInfo) ->String{
        var resultDay = babyInfo.day
        switch babyInfo.infoType {
        case "1":
            if let day = Int.init(babyInfo.day) {
                resultDay = "\(day % 365)"
                resultDay = "第\(self.weakAndDayFromNumber(resultDay).0) 周+\(self.weakAndDayFromNumber(resultDay).1)天"
            }
            resultDay = "第\(self.weakAndDayFromNumber(resultDay).0) 周+\(self.weakAndDayFromNumber(resultDay).1)天"
        case "2":
            if let day = Int.init(babyInfo.day) {
                resultDay = "\(day % 300)"
                "第\(self.weakAndDayFromNumber(resultDay).0) 周 \(self.weakAndDayFromNumber(resultDay).1) 天"
            }
            resultDay = "第\(self.weakAndDayFromNumber(resultDay).0) 周+\(self.weakAndDayFromNumber(resultDay).1)天"
        default:
            break
        }
        return resultDay
    }
    
}
