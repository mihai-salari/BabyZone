//
//  PregInfoView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/1.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let pregDaysLabelHeight:CGFloat = upRateHeight(25)
private let pregInfoCircleWidth:CGFloat = upRateHeight(120)
private let pregRecordViewHeight:CGFloat = upRateWidth(35)
private let pregBabyImageViewWidth:CGFloat = upRateWidth(70)
private let pregBabyImageViewHeight = upRateWidth(60)
private let pregMoreViewWidth:CGFloat = upRateWidth(20)
private let pregMoreViewHeight:CGFloat = upRateWidth(20)
private let pregFaceViewWidth:CGFloat = upRateWidth(30)


class PregInfoView: UIView {
    
    private var cirleView:HMCirclePercentView!
    private var pregDaysLabel:UILabel!
    private var weightLabel:UILabel!
    private var heightLabel:UILabel!
    private var dueDatesLabel:UILabel!
    private var recordButton:UIButton!
    private var babyImageView:UIImageView!
    private var faceImageView:UIImageView!
    private var switchHandler:(()->())?
    private var recordHandler:(()->())?
    
    
    init(frame: CGRect,babyModel:BabyBaseInfo, switchCompletionHandler:(()->())?, recordCompletionHandler:(()->())?) {
        super.init(frame: frame)
        
        self.cirleView = HMCirclePercentView.init(frame: CGRectMake((CGRectGetWidth(self.frame) - pregInfoCircleWidth) / 2, CGRectGetHeight(self.frame) * (2 / 5.3) - pregInfoCircleWidth / 2, pregInfoCircleWidth, pregInfoCircleWidth), showText: false)
        
        self.cirleView.drawCircleWithPercent(self.resultDay(babyModel).1, duration: 2, trackWidth: 5, progressWidth: 5, clockwise: true, lineCap: kCALineCapRound, trackFillColor: UIColor.clearColor(), trackStrokeColor: UIColor.hexStringToColor("#e37580"), progressFillColor: UIColor.clearColor(), progressStrokeColor: UIColor.hexStringToColor("#ffffff"), animatedColors: nil)
        
        self.cirleView.startAnimation()
        self.addSubview(self.cirleView)
        
        
        self.pregDaysLabel = UILabel.init(frame: CGRectMake(0, 0, ScreenWidth, CGRectGetMinY(self.cirleView.frame)))
        self.pregDaysLabel.font = UIFont.boldSystemFontOfSize(upRateHeight(22))
        self.pregDaysLabel.text = self.resultDay(babyModel).0
        self.pregDaysLabel.textAlignment = .Center
        self.pregDaysLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.pregDaysLabel)
        
        
        self.babyImageView = UIImageView.init(frame: CGRectMake((CGRectGetWidth(self.cirleView.frame) - pregBabyImageViewWidth) / 2, (CGRectGetHeight(self.cirleView.frame) - pregBabyImageViewHeight) / 2, pregBabyImageViewWidth, pregBabyImageViewHeight))
        self.babyImageView.image = UIImage.imageWithName(babyModel.babyHeadImage)
        self.babyImageView.layer.cornerRadius = 10
        self.babyImageView.layer.masksToBounds = true
        self.cirleView.addSubview(self.babyImageView)
        
        let babyButton = UIButton.init(type: .Custom)
        babyButton.frame = self.cirleView.bounds
        babyButton.addTarget(self, action: #selector(PregInfoView.switchBabyClick), forControlEvents: .TouchUpInside)
        self.cirleView.addSubview(babyButton)
        
        self.weightLabel = UILabel.init(frame: CGRectMake(0, CGRectGetHeight(self.frame) * (3 / 4.7), CGRectGetWidth(self.frame) / 3, 15))
        self.weightLabel.textColor = UIColor.whiteColor()
        self.weightLabel.text = "\(babyModel.minWeight)~\(babyModel.maxWeight)"
        self.weightLabel.textAlignment = .Center
        self.weightLabel.font = UIFont.boldSystemFontOfSize(upRateWidth(18))
        self.addSubview(self.weightLabel)
        
        let kgLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(self.weightLabel.frame), CGRectGetMaxY(self.weightLabel.frame) + upRateWidth(5), CGRectGetWidth(self.weightLabel.frame), CGRectGetHeight(self.weightLabel.frame)))
        kgLabel.font = UIFont.systemFontOfSize(upRateWidth(11))
        kgLabel.textColor = UIColor.whiteColor()
        kgLabel.textAlignment = .Center
        kgLabel.text = "体重(kg)"
        self.addSubview(kgLabel)
        
        self.heightLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(self.weightLabel.frame), CGRectGetMinY(self.weightLabel.frame), CGRectGetWidth(self.weightLabel.frame), CGRectGetHeight(self.weightLabel.frame)))
        self.heightLabel.text = "\(babyModel.minHeight)~\(babyModel.maxHeight)"
        self.heightLabel.textColor = UIColor.whiteColor()
        self.heightLabel.textAlignment = .Center
        self.heightLabel.font = UIFont.boldSystemFontOfSize(upRateWidth(18))
        self.addSubview(self.heightLabel)
        
        let cmLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(self.heightLabel.frame), CGRectGetMinY(kgLabel.frame), CGRectGetWidth(self.heightLabel.frame), CGRectGetHeight(self.heightLabel.frame)))
        cmLabel.textAlignment = .Center
        cmLabel.textColor = UIColor.whiteColor()
        cmLabel.text = "身高(cm)"
        cmLabel.font = UIFont.systemFontOfSize(upRateWidth(11))
        self.addSubview(cmLabel)
        
        self.dueDatesLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(self.heightLabel.frame), CGRectGetMinY(self.heightLabel.frame), CGRectGetWidth(self.weightLabel.frame), CGRectGetHeight(self.weightLabel.frame)))
        self.dueDatesLabel.text = "\(babyModel.minHead)~\(babyModel.maxHead)"
        self.dueDatesLabel.textColor = UIColor.whiteColor()
        self.dueDatesLabel.textAlignment = .Center
        self.dueDatesLabel.font = UIFont.boldSystemFontOfSize(upRateWidth(18))
        self.addSubview(self.dueDatesLabel)
        
        let ddLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(self.dueDatesLabel.frame), CGRectGetMinY(kgLabel.frame), CGRectGetWidth(self.dueDatesLabel.frame), CGRectGetHeight(self.dueDatesLabel.frame)))
        ddLabel.textAlignment = .Center
        ddLabel.textColor = UIColor.whiteColor()
        ddLabel.text = "头围(cm)"
        ddLabel.font = UIFont.systemFontOfSize(upRateWidth(11))
        self.addSubview(ddLabel)
        
        var line = UIView.init(frame: CGRectMake(CGRectGetMaxX(self.weightLabel.frame), CGRectGetMinY(self.weightLabel.frame) + upRateWidth(3), 0.8, 2 * (CGRectGetHeight(self.weightLabel.frame) - upRateWidth(3))))
        line.backgroundColor = UIColor.colorFromRGB(227, g: 130, b: 144)
        self.addSubview(line)
        
        line  = UIView.init(frame: CGRectMake(CGRectGetMaxX(self.heightLabel.frame), CGRectGetMinY(self.weightLabel.frame) + upRateWidth(3), 0.8, 2 * (CGRectGetHeight(self.weightLabel.frame) - upRateWidth(3))))
        line.backgroundColor = UIColor.colorFromRGB(227, g: 130, b: 144)
        self.addSubview(line)
        

        
        let diaryRecordButton = DiaryRecordButton.init(frame: CGRectMake(10, CGRectGetMaxY(kgLabel.frame) + upRateWidth(10), CGRectGetWidth(self.frame) - 20, pregRecordViewHeight))
        diaryRecordButton.setImageRect(CGRectMake(0, 0, 10, 16), image: "arrow_right.png", title: "记录下宝宝的成长瞬间!", fontSize: upRateWidth(16))
        diaryRecordButton.backgroundColor = UIColor.hexStringToColor("#e37580")
        diaryRecordButton.setCustomTitleColor(UIColor.whiteColor())
        diaryRecordButton.layer.cornerRadius = pregRecordViewHeight / 2
        diaryRecordButton.layer.masksToBounds = true
        diaryRecordButton.addCustomTarget(self, sel: #selector(self.recordDiaryClick))
        self.addSubview(diaryRecordButton)
        
        self.switchHandler = switchCompletionHandler
        self.recordHandler = recordCompletionHandler
    }
    
    func refreshViews(model:BabyBaseInfo) -> Void {
        if let daysLabel = self.pregDaysLabel {
            daysLabel.text = model.day
        }
        if let image = self.babyImageView {
            image.image = UIImage.imageWithName(model.babyHeadImage)
        }
        if let weightL = self.weightLabel {
            weightL.text = "\(model.minWeight)~\(model.maxWeight)"
        }
        if let heightL = self.heightLabel {
            heightL.text = "\(model.minHeight)~\(model.maxHeight)"
        }
        if let dueLabel = self.dueDatesLabel {
            dueLabel.text = "\(model.minHead)~\(model.maxHeight)"
        }
        if let circleV = self.cirleView {
            circleV.updateCircleWithPercent(self.resultDay(model).1)
        }
    }

    
    func switchBabyClick() -> Void {
        if  let handle = self.switchHandler {
            handle()
        }
    }
    
    func recordDiaryClick() -> Void {
        if let handle = self.recordHandler {
            handle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func resultDay(babyInfo:BabyBaseInfo) ->(String, CGFloat){
        var resultDay = babyInfo.day
        var modeDay:CGFloat = 80
        switch babyInfo.infoType {
        case "1":
            if let day = Int.init(babyInfo.day) {
                resultDay = "\(day % 365)"
                modeDay = CGFloat.init(ceil(fabs(remainderf(365, Float(day)) / 365 * 100)))
            }
            resultDay = "怀孕 " + resultDay + " 天"
        case "2":
            if let day = Int.init(babyInfo.day) {
                resultDay = "\(day % 300)"
                modeDay = CGFloat.init(ceil(fabs(remainderf(300, Float(day)) / 300 * 100)))
            }
            resultDay = "宝宝 " + resultDay + " 天"
        default:
            break
        }
        return (resultDay, modeDay)
    }
    
}


private let pregMainImageWidth:CGFloat = upRateWidth(20)
private let pregMainImageHeight:CGFloat = upRateWidth(40)
private let pregInfoTableViewCellId = "PregStatusCellId"

class PregTableView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private var pregTable:UITableView!
    private var pregInfoData:[PregInfoStatus]!
    private var selectHandler:((model:Article, indexPath:NSIndexPath)->())?
    private var menuHandler:((model:Article)->())?
    private var shareHandler:((model:Article)->())?
    
    init(frame: CGRect, style: UITableViewStyle, dataSource:[PregInfoStatus], dataCompletionHandler:((model:Article, indexPath:NSIndexPath)->())?, moreMenuCompletionHandler:((model:Article)->())?, shareCompletionHandler:((model:Article)->())?) {
        super.init(frame: frame)
        self.pregInfoData = dataSource
        self.pregTable = UITableView.init(frame: self.bounds, style: style)
        self.pregTable.delegate = self
        self.pregTable.dataSource = self
        self.pregTable.separatorInset = UIEdgeInsetsZero
        self.pregTable.layoutMargins = UIEdgeInsetsZero
        self.pregTable.registerClass(PregStatusCell.self, forCellReuseIdentifier: pregInfoTableViewCellId)
        self.addSubview(self.pregTable)
        
        self.selectHandler = dataCompletionHandler
        self.menuHandler = moreMenuCompletionHandler
        self.shareHandler = shareCompletionHandler
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.pregInfoData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.pregInfoData[section]
        return model.pregInfoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pregInfoTableViewCellId) as? PregStatusCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            let model = self.pregInfoData[indexPath.section]
            let subModel = model.pregInfoData[indexPath.row]
            resultCell.refreshCell(subModel, menuCompletionHandler: { [weak self] in
                if let weakSelf = self{
                    if let handle = weakSelf.menuHandler{
                        handle(model: subModel)
                    }
                }
                }, shareCompletionHandler: { [weak self] in
                    if let weakSelf = self{
                        if let handle = weakSelf.shareHandler{
                            handle(model: subModel)
                        }
                    }
                })
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mainModel = self.pregInfoData[indexPath.section]
        print(CGFloat(mainModel.pregInfoData[indexPath.row].contentTotalHeight))
        return CGFloat(mainModel.pregInfoData[indexPath.row].contentTotalHeight) < 80 ? 80 : CGFloat(mainModel.pregInfoData[indexPath.row].contentTotalHeight)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), 10))
        footerView.backgroundColor = UIColor.colorFromRGB(225, g: 104, b: 108)
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.pregInfoData[section]
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.frame), CGRectGetHeight(self.frame) / 3))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let imageView = UIImageView.init(frame: CGRectMake(10, (CGRectGetHeight(headerView.frame) - CGRectGetHeight(headerView.frame) * (1 / 2)) / 2, CGRectGetHeight(headerView.frame) * (1 / 4), CGRectGetHeight(headerView.frame) * (1 / 2)))
        imageView.image = UIImage.imageWithName(model.pregStatusImage)
        headerView.addSubview(imageView)
        
        let desc = model.pregStatusDesc
        let descSize = desc.size(UIFont.systemFontOfSize(upRateWidth(15)))
        let descLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(imageView.frame) + upRateWidth(5), (CGRectGetHeight(headerView.frame) - descSize.height) / 2, descSize.width, descSize.height))
        descLabel.text = desc
        descLabel.textColor = UIColor.hexStringToColor("#5f4957")
        descLabel.font = UIFont.boldSystemFontOfSize(upRateWidth(15))
        headerView.addSubview(descLabel)
        
        let moreImageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(headerView.frame) - 2 * CGRectGetHeight(headerView.frame) * (1 / 3), (CGRectGetHeight(headerView.frame) - CGRectGetHeight(headerView.frame) * (1 / 3)) / 2, CGRectGetHeight(headerView.frame) * (1 / 3), CGRectGetHeight(headerView.frame) * (1 / 3)))
        moreImageView.image = UIImage.imageWithName(model.pregMoreImage)
        headerView.addSubview(moreImageView)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGRectGetHeight(self.frame) / 3
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handle = self.selectHandler {
            let mainModel = self.pregInfoData[indexPath.section]
            let subModel = mainModel.pregInfoData[indexPath.row]
            handle(model: subModel, indexPath: indexPath)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PregStatusCell: UITableViewCell {
    
    private var moreMenuHandler:(()->())?
    private var shareHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func refreshCell(model:Article, menuCompletionHandler:(()->())?, shareCompletionHandler:(()->())?) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        self.contentView.frame.size.height = CGFloat(model.contentTotalHeight)
        self.contentView.frame.size.width = ScreenWidth - 2 * viewOriginX
        
        var mainLabelHeight:CGFloat = 0
        var subItemLabelHeight:CGFloat = 0
        var imageViewHeight:CGFloat = 0
        let shareViewHeight:CGFloat = 30
        if model.imageUrl == "" {
            mainLabelHeight = (CGRectGetHeight(self.contentView.frame) - shareViewHeight - 10) * (2 / 3) * (1 / 4)
            subItemLabelHeight = (CGRectGetHeight(self.contentView.frame) - shareViewHeight - 10) * (2 / 3) * (3 / 4)
            imageViewHeight = 0
        }else{
            mainLabelHeight = (CGRectGetHeight(self.contentView.frame) - shareViewHeight - 10 - 10) * (2 / 7) * (1 / 3)
            subItemLabelHeight = (CGRectGetHeight(self.contentView.frame) - shareViewHeight - 10 - 10) * (2 / 7) * (2 / 3)
            imageViewHeight = (CGRectGetHeight(self.contentView.frame) - shareViewHeight - 10 - 10) * (5 / 7)
        }
        
        let mainLabel = UILabel.init(frame: CGRectMake(10, 10, CGRectGetWidth(self.contentView.frame) - 20, mainLabelHeight))
        mainLabel.text = model.title
        mainLabel.textColor = UIColor.darkGrayColor()
        mainLabel.font = UIFont.systemFontOfSize(upRateWidth(14))
        self.contentView.addSubview(mainLabel)
        
        let subItemLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(mainLabel.frame), CGRectGetMaxY(mainLabel.frame) + 5, CGRectGetWidth(mainLabel.frame), subItemLabelHeight))
        subItemLabel.font = UIFont.systemFontOfSize(upRateHeight(12))
        subItemLabel.textColor = UIColor.lightGrayColor()
        subItemLabel.text = model.content
        subItemLabel.numberOfLines = 0
        subItemLabel.adjustsFontSizeToFitWidth = true
        subItemLabel.minimumScaleFactor = 0.8
        self.contentView.addSubview(subItemLabel)
        
        for i in 0 ..< model.images.count {
            let imageView = UIImageView.init(frame: CGRect.init(x: mainLabel.frame.minX, y: CGFloat(i) * subItemLabel.frame.maxY, width: mainLabel.frame.width, height: imageViewHeight))
            imageView.setImageURL(model.images[i])
            self.contentView.addSubview(imageView)
        }
        
        var button = DiaryListButton(type: .Custom)
        button.frame = CGRectMake(0, CGRectGetHeight(self.contentView.frame) - shareViewHeight, CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), shareViewHeight)
        button.setImageRect(CGSizeMake(15, 10), normaImage: "gray_menu.png")
        button.addCustomTarget(self, sel: #selector(PregStatusCell.cellMoreMenuClick))
        self.contentView.addSubview(button)
        
        button = DiaryListButton(type: .Custom)
        button.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), CGRectGetHeight(self.contentView.frame) - shareViewHeight, CGRectGetWidth(self.contentView.frame) * (2 / 5), shareViewHeight)
        button.setImageRect(CGSizeMake(15, 10), normaImage: "share.png")
        button.addCustomTarget(self, sel: #selector(PregStatusCell.cellShareClick))
        self.contentView.addSubview(button)
        
        let dateLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame), CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), CGRectGetHeight(button.frame)))
        dateLabel.textAlignment = .Center
        dateLabel.text = model.createTime
        dateLabel.textColor = UIColor.lightGrayColor()
        dateLabel.font = UIFont.systemFontOfSize(12)
        self.contentView.addSubview(dateLabel)
        
        
        var line = UIView.init(frame: CGRectMake(0, CGRectGetHeight(self.contentView.frame) - shareViewHeight, CGRectGetWidth(self.contentView.frame), 0.5))
        line.backgroundColor = UIColor.colorFromRGB(199, g: 194, b: 198, a: 0.5)
        self.contentView.addSubview(line)
        
        line = UIView.init(frame: CGRectMake(CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), CGRectGetMinY(button.frame), 0.5, CGRectGetHeight(button.frame)))
        line.backgroundColor = UIColor.colorFromRGB(199, g: 194, b: 198, a: 0.5)
        self.contentView.addSubview(line)
        
        line = UIView.init(frame: CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame), 0.5, CGRectGetHeight(button.frame)))
        line.backgroundColor = UIColor.colorFromRGB(199, g: 194, b: 198, a: 0.5)
        self.contentView.addSubview(line)
        
        self.moreMenuHandler = menuCompletionHandler
        self.shareHandler = shareCompletionHandler
    }
    
    
    func cellMoreMenuClick() -> Void {
        if let handle = self.moreMenuHandler {
            handle()
        }
    }
    
    func cellShareClick() -> Void {
        if let handle = self.shareHandler {
            handle()
        }
    }
    
    
}

