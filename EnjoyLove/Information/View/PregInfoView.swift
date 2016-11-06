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
        
        self.cirleView = HMCirclePercentView.init(frame: CGRect.init(x: (self.frame.width - (self.frame.width * (1 / 2))) / 2, y: 40, width: (self.frame.width * (1 / 2)), height: (self.frame.width * (1 / 2))), showText: false)
        
        self.cirleView.drawCircleWithPercent(self.resultDay(babyModel).percent, duration: 2, trackWidth: 5, progressWidth: 5, clockwise: true, lineCap: kCALineCapRound, trackFillColor: UIColor.clearColor(), trackStrokeColor: UIColor.hexStringToColor("#e37580"), progressFillColor: UIColor.clearColor(), progressStrokeColor: UIColor.hexStringToColor("#ffffff"), animatedColors: nil)
        
        self.cirleView.startAnimation()
        self.addSubview(self.cirleView)
        
        
        self.pregDaysLabel = UILabel.init(frame: CGRectMake(0, 0, ScreenWidth, CGRectGetMinY(self.cirleView.frame)))
        self.pregDaysLabel.font = UIFont.boldSystemFontOfSize(upRateHeight(22))
        self.pregDaysLabel.text = self.resultDay(babyModel).day
        self.pregDaysLabel.textAlignment = .Center
        self.pregDaysLabel.textColor = UIColor.whiteColor()
        self.addSubview(self.pregDaysLabel)
        
        self.babyImageView = UIImageView.init(frame: CGRect.init(x: (self.cirleView.frame.width - (self.cirleView.frame.width * (1 / 2))) / 2, y: (self.cirleView.frame.height - (self.cirleView.frame.height * (1 / 2))) / 2 + 5, width: self.cirleView.frame.width * (1 / 2), height: self.cirleView.frame.width * (1 / 2) - 10))
        self.babyImageView.image = UIImage.imageWithName(babyModel.babyHeadImage)
        self.babyImageView.layer.cornerRadius = 10
        self.babyImageView.layer.masksToBounds = true
        self.cirleView.addSubview(self.babyImageView)
        
        let babyButton = UIButton.init(type: .Custom)
        babyButton.frame = self.cirleView.bounds
        babyButton.addTarget(self, action: #selector(self.switchBabyClick), forControlEvents: .TouchUpInside)
        self.cirleView.addSubview(babyButton)
        
        self.weightLabel = UILabel.init(frame: CGRectMake(0, CGRectGetHeight(self.frame) * (3 / 4.3), CGRectGetWidth(self.frame) / 3, 15))
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
            daysLabel.text = self.resultDay(model).day
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
            circleV.updateCircleWithPercent(self.resultDay(model).percent)
            circleV.startAnimation()
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
    
    
    
    private func resultDay(babyInfo:BabyBaseInfo) ->(day:String, percent:CGFloat){
        var resultDay = babyInfo.day
        var modeDay:CGFloat = 80
        switch babyInfo.infoType {
        case "2":
            if let day = Int.init(babyInfo.day) {
                resultDay = "\(day % 365)"
                resultDay = "第\(self.weakAndDayFromNumber(resultDay).0)周+\(self.weakAndDayFromNumber(resultDay).1)天"
                modeDay = CGFloat.init(ceil(fabs(remainderf(365, Float(day)) / 365 * 100)))
            }
        case "1":
            if let day = Int.init(babyInfo.day) {
                resultDay = "\(day % 300)"
                resultDay = "第\(self.weakAndDayFromNumber(resultDay).0)周\(self.weakAndDayFromNumber(resultDay).1)天"
                modeDay = CGFloat.init(ceil(fabs(remainderf(300, Float(day)) / 300 * 100)))
            }
        default:
            break
        }
        return (resultDay, modeDay)
    }
    
}


private let pregMainImageWidth:CGFloat = upRateWidth(20)
private let pregMainImageHeight:CGFloat = upRateWidth(40)

class PregTableView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private var pregTable:UITableView!
    private var pregInfoData:[PregInfoStatus]!
    private var selectHandler:((model:Article, indexPath:NSIndexPath)->())?
    private var menuHandler:((model:Article, selected:Bool)->())?
    private var shareHandler:((model:Article)->())?
    private var listHandler:(()->())?
    
    init(frame: CGRect, dataSource:[PregInfoStatus], dataCompletionHandler:((model:Article, indexPath:NSIndexPath)->())?, moreMenuCompletionHandler:((model:Article, selected:Bool)->())?, shareCompletionHandler:((model:Article)->())?, listCompletionHandler:(()->())?) {
        super.init(frame: frame)
        self.pregInfoData = dataSource
        self.pregTable = UITableView.init(frame: self.bounds, style: .Grouped)
        self.pregTable.delegate = self
        self.pregTable.dataSource = self
        self.pregTable.tableFooterView = UIView.init()
        self.pregTable.separatorInset = UIEdgeInsetsZero
        self.pregTable.layoutMargins = UIEdgeInsetsZero
        self.addSubview(self.pregTable)
        
        
        self.selectHandler = dataCompletionHandler
        self.menuHandler = moreMenuCompletionHandler
        self.shareHandler = shareCompletionHandler
        self.listHandler = listCompletionHandler
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.pregInfoData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pregInfoData[section].pregInfoData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "pregInfoTableViewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? PregStatusCell
        if cell == nil {
            cell = PregStatusCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            let model = self.pregInfoData[indexPath.section]
            let subModel = model.pregInfoData[indexPath.row]
            resultCell.refreshCell(subModel, menuCompletionHandler: { [weak self] (selected)in
                if let weakSelf = self{
                    if let handle = weakSelf.menuHandler{
                        handle(model: subModel, selected: selected)
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
        var mainModel = self.pregInfoData[indexPath.section]
        return mainModel.pregInfoData[indexPath.row].titleHeight + mainModel.pregInfoData[indexPath.row].contentHeight + mainModel.pregInfoData[indexPath.row].imageHeight  + 40
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
        
        let headerView = UIView.init(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 45))
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
        
        let moreButton = UIButton.init(type: .Custom)
        moreButton.frame = CGRect.init(x: headerView.frame.width - 2 * headerView.frame.height * (1 / 3), y: (headerView.frame.height - headerView.frame.height * (1 / 3)) / 2, width: headerView.frame.height * (1 / 3), height: headerView.frame.height * (1 / 3))
        moreButton.setImage(UIImage.imageWithName(model.pregMoreImage), forState: UIControlState.Normal)
        moreButton.addTarget(self, action: #selector(self.listClick), forControlEvents: UIControlEvents.TouchUpInside)
        headerView.addSubview(moreButton)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
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
    
    func reloadData(data:[PregInfoStatus]) -> Void {
        self.pregInfoData = data
        if let table = self.pregTable {
            table.reloadData()
        }
    }
    
    func listClick() -> Void {
        if let handle = self.listHandler {
            handle()
        }
    }
}

class PregStatusCell: UITableViewCell {
    
    private var moreMenuHandler:((selected:Bool)->())?
    private var shareHandler:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func refreshCell(model:Article, menuCompletionHandler:((selected:Bool)->())?, shareCompletionHandler:(()->())?) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        let shareViewHeight:CGFloat = 40
        self.contentView.frame.size.height = model.titleHeight + model.contentHeight + model.imageHeight + shareViewHeight
        self.contentView.frame.size.width = ScreenWidth - 2 * viewOriginX
        
        let mainLabel = UILabel.init(frame: CGRectMake(10, 0, self.contentView.frame.width - 20, model.titleHeight))
        mainLabel.text = model.title
        mainLabel.textColor = UIColor.darkGrayColor()
        mainLabel.font = UIFont.systemFontOfSize(14)
        self.contentView.addSubview(mainLabel)
        
        let subItemLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(mainLabel.frame), CGRectGetMaxY(mainLabel.frame), CGRectGetWidth(mainLabel.frame), model.contentHeight))
        subItemLabel.font = UIFont.systemFontOfSize(12)
        subItemLabel.textColor = UIColor.lightGrayColor()
        subItemLabel.text = model.content
        subItemLabel.numberOfLines = 0
        subItemLabel.adjustsFontSizeToFitWidth = true
        subItemLabel.minimumScaleFactor = 0.8
        self.contentView.addSubview(subItemLabel)
        if model.images.count > 0 {
            let imageView = UIImageView.init(frame: CGRect.init(x: mainLabel.frame.minX, y: subItemLabel.frame.maxY, width: self.contentView.frame.width - 20, height: model.imageHeight))
            if let url = NSURL.init(string: model.images[0]) {
                imageView.setImageWithURL(url)
            }
            self.contentView.addSubview(imageView)
        }
        
        var button = DiaryListButton(type: .Custom)
        button.frame = CGRectMake(0, self.contentView.frame.height - shareViewHeight, CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), shareViewHeight)
        button.setImageRect(CGSizeMake(15, 12), normaImage: "infoCollection.png")
        button.addCustomTarget(self, sel: #selector(self.cellMoreMenuClick(_:)))
        self.contentView.addSubview(button)
        
        button = DiaryListButton(type: .Custom)
        button.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), CGRectGetHeight(self.contentView.frame) - shareViewHeight, CGRectGetWidth(self.contentView.frame) * (2 / 5), shareViewHeight)
        button.setImageRect(CGSizeMake(15, 10), normaImage: "share.png")
        button.addCustomTarget(self, sel: #selector(PregStatusCell.cellShareClick))
        self.contentView.addSubview(button)
        
        let dateLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(button.frame), CGRectGetMinY(button.frame), CGRectGetWidth(self.contentView.frame) * (3 / 5) * (1 / 2), CGRectGetHeight(button.frame)))
        dateLabel.textAlignment = .Center
        dateLabel.text = model.createDate
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
    
    
    func cellMoreMenuClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.moreMenuHandler {
            handle(selected: btn.selected)
        }
    }
    
    func cellShareClick() -> Void {
        if let handle = self.shareHandler {
            handle()
        }
    }
    
    
}

