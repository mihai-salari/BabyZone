//
//  BaByView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let babyBackgroundImageViewTag = 1000
class BabyView: UIView,UIScrollViewDelegate{

    private var babyScrollView:UIScrollView!
    private var babyPageControl:FilledPageControl!
    private var temperatureLabel:UILabel!
    private var humidityLabel:UILabel!
    private var remindLabel:UILabel!
    private var babyData:[Baby]!
    private var playHandler:((baby:Baby!, current:Int)->())?
    private var musicHandler:((baby:Baby!, current:Int)->())?
    private var currentBaby:Int = 0{
        didSet{
            if let data = self.babyData {
                if data.count > 0 {
                    if let tLabel = self.temperatureLabel {
                        tLabel.text = data[currentBaby].babyTemperature
                    }
                    if let hLabel = self.humidityLabel {
                        hLabel.text = data[currentBaby].babyHumidity
                    }
                    if let rLabel = self.remindLabel {
                        rLabel.text = data[currentBaby].babyRemindCount
                    }
                }
            }
        }
    }
    
    init(frame: CGRect,data:[Baby],playCompletionHandler:((baby:Baby!, current:Int)->())?, musicCompletionHandler:((baby:Baby!, current:Int)->())?) {
        super.init(frame: frame)
        self.babyData = data
        self.babyScrollView = UIScrollView.init(frame: self.bounds)
        self.babyScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.babyScrollView.contentSize = CGSize(width: CGFloat(data.count) * self.babyScrollView.frame.width, height: self.babyScrollView.frame.height)
        self.babyScrollView.showsHorizontalScrollIndicator = false
        self.babyScrollView.pagingEnabled = true
        self.babyScrollView.delegate = self
        self.babyScrollView.backgroundColor = UIColor.blackColor()
        self.addSubview(self.babyScrollView)
        
        for i in 0 ..< data.count {
            let babyImageView  = UIImageView.init(frame: CGRect(x: CGFloat(i) * self.babyScrollView.frame.width, y: 0, width: self.babyScrollView.frame.width, height: self.babyScrollView.frame.height))
            if let fileImage = UIImage.init(contentsOfFile: data[i].babyImage) {
                if let cgImg = fileImage.CGImage {
                    babyImageView.image = UIImage.init(CGImage: cgImg, scale: 1, orientation: UIImageOrientation.Right)
                }
            }
            babyImageView.tag = babyBackgroundImageViewTag + i
            self.babyScrollView.addSubview(babyImageView)
        }
        
        
        
        let babyButtonWidth = self.babyScrollView.frame.width * (1 / 3)
        let babyButton = BabyButton(type: .Custom)
        babyButton.frame = CGRect(x: (self.frame.width - babyButtonWidth) / 2, y: (self.frame.height - babyButtonWidth) / 2, width: babyButtonWidth, height: babyButtonWidth)
        babyButton.setImageSize(CGSize(width: ScreenWidth * (1 / 6),height: ScreenWidth * (1 / 6)), normaImage: "babyPlay.png", title: "观看视频", fontSize: 12)
        babyButton.addCustomTarget(self, sel: #selector(self.babyPlayClick))
        self.addSubview(babyButton)

        let musicButtonWidth:CGFloat = 50
        let musicButton = UIButton.init(type: .Custom)
        musicButton.frame = CGRect(x: self.frame.width - musicButtonWidth - 15, y: 15, width: musicButtonWidth, height: musicButtonWidth)
        musicButton.setImage(UIImage.imageWithName("music_play.png"), forState: .Selected)
        musicButton.setImage(UIImage.imageWithName("music_stop.png"), forState: .Normal)
        musicButton.addTarget(self, action: #selector(self.babyMusicClick(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(musicButton)
        
        self.temperatureLabel = UILabel.init(frame: CGRect(x: 0, y: self.frame.height - 60, width: self.frame.width * (1 / 3), height: 15))
        self.temperatureLabel.text = data[0].babyTemperature
        self.temperatureLabel.textAlignment = .Center
        self.temperatureLabel.textColor = UIColor.hexStringToColor("#DD656F")
        self.temperatureLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(self.temperatureLabel)
        
        let tempDescLabel = UILabel.init(frame: CGRect(x: temperatureLabel.frame.minX, y: temperatureLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        tempDescLabel.text = "温度(°)"
        tempDescLabel.textAlignment = .Center
        tempDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
        tempDescLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(tempDescLabel)
        
        
        self.humidityLabel = UILabel.init(frame: CGRect(x: temperatureLabel.frame.maxX, y: temperatureLabel.frame.minY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        self.humidityLabel.text = data[0].babyHumidity
        self.humidityLabel.textAlignment = .Center
        self.humidityLabel.textColor = UIColor.hexStringToColor("#DD656F")
        self.humidityLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(self.humidityLabel)
        
        let humidityDescLabel = UILabel.init(frame: CGRect(x: humidityLabel.frame.minX, y: humidityLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        humidityDescLabel.text = "湿度(%)"
        humidityDescLabel.textAlignment = .Center
        humidityDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
        humidityDescLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(humidityDescLabel)
        
        self.remindLabel = UILabel.init(frame: CGRect(x: humidityLabel.frame.maxX, y: temperatureLabel.frame.minY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        self.remindLabel.text = data[0].babyRemindCount
        self.remindLabel.textAlignment = .Center
        self.remindLabel.textColor = UIColor.hexStringToColor("#DD656F")
        self.remindLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(self.remindLabel)
        
        let remindDescLabel = UILabel.init(frame: CGRect(x: remindLabel.frame.minX, y: temperatureLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        remindDescLabel.text = "异常"
        remindDescLabel.textAlignment = .Center
        remindDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
        remindDescLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(remindDescLabel)
        
        let pageControlWidth = CGFloat(data.count) * 13.5
        self.babyPageControl = FilledPageControl(frame: CGRect(x: (self.frame.width - pageControlWidth) / 2, y: tempDescLabel.frame.maxY + 8, width: pageControlWidth, height: 10))
        self.babyPageControl.pageCount = data.count
        self.babyPageControl.indicatorPadding = 5
        self.babyPageControl.tintColor = UIColor.hexStringToColor("#DD656F")
        self.babyPageControl.borderColor = UIColor.hexStringToColor("#DD656F")
        self.addSubview(self.babyPageControl)
        
        
        self.playHandler = playCompletionHandler
        self.musicHandler = musicCompletionHandler
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.frame.width)
        self.babyPageControl.progress = page + progressInPage
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.currentBaby = Int(scrollView.contentOffset.x / scrollView.frame.width)
    }
    
    
    func babyPlayClick() -> Void {
        if let handle = self.playHandler {
            if let data = self.babyData {
                if data.count > 0 {
                    handle(baby: data[self.currentBaby], current: self.currentBaby)
                }
            }
        }
    }

    func babyMusicClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.musicHandler {
            if let data = self.babyData {
                if data.count > 0 {
                    handle(baby: data[self.currentBaby], current: self.currentBaby)
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshAtCurrent(conact:Contact, index:Int, img:UIImage) -> Void {
        if let cgImg = img.CGImage {
            if let babyImageView = self.babyScrollView.viewWithTag(index + BabySettingSwitchTag) as? UIImageView{
                 babyImageView.image = UIImage.init(CGImage: cgImg, scale: 1, orientation: UIImageOrientation.Right)
            }
         }
        self.temperatureLabel.text = "0"
        self.humidityLabel.text = "0"
        self.remindLabel.text = "0"
    }

}

private let BabySettingSwitchTag = 1000
private let BabySettingTableViewCellId = "BabySettingTableViewCellId"
class BabySettingView: UIView ,UITableViewDelegate,UITableViewDataSource{
    
    private var settingData:[BabySetting]!
    private var settingTable:UITableView!
    private var selectionHandler:((indexPath:NSIndexPath, data:[SettingDetail])->())?
    
    init(frame: CGRect, selectionHandler:((indexPath:NSIndexPath, data:[SettingDetail])->())?) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.settingData = []
        var settingDetailData:[SettingDetail] = []
        
        var model = SettingDetail(mainItem: "异常提醒", subItem: "0", itemId: "", tipPermission: 0, modePermission: 1)
        settingDetailData.append(model)
        
        model = SettingDetail(mainItem: "提醒方式", subItem: "1", itemId: "", tipPermission: 0, modePermission: 1)
        settingDetailData.append(model)
        
        var settingModel = BabySetting(title: "提醒设置", setting: settingDetailData)
        self.settingData.append(settingModel)
        
        HUD.showHud("正在加载...", onView: self)
        ChildAccount.sendAsyncChildAccountList { [weak self](errorCode, msg) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf)
                dispatch_queue_create("childAccountListQueue", nil).queue({
                    var subCountData:[SettingDetail] = []
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            let childAccounts = ChildAccountBL.findAll()
                            if childAccounts.count > 0{
                                for account in childAccounts{
                                    model = SettingDetail()
                                    model.mainItem = account.childName
                                    model.subItem = account.childMobile
                                    model.itemId = account.idUserChildInfo
                                    subCountData.append(model)
                                }
                                model = SettingDetail(mainItem: "添加/删除子账号", subItem: "添加/删除设备", itemId: "", tipPermission: -1, modePermission: -1)
                                subCountData.append(model)
                            }else{
                                model = SettingDetail(mainItem: "添加/删除子账号", subItem: "添加/删除设备", itemId: "", tipPermission: -1, modePermission: -1)
                                subCountData.append(model)
                            }
                        }else{
                            model = SettingDetail(mainItem: "添加/删除子账号", subItem: "添加/删除设备", itemId: "", tipPermission: -1, modePermission: -1)
                            subCountData.append(model)
                        }
                    }else{
                        model = SettingDetail(mainItem: "添加/删除子账号", subItem: "添加/删除设备", itemId: "", tipPermission: -1, modePermission: -1)
                        subCountData.append(model)
                    }
                    settingModel = BabySetting(title: "子账号设置", setting: subCountData)
                    weakSelf.settingData.append(settingModel)
                    dispatch_get_main_queue().queue({
                        if let table = weakSelf.settingTable{
                            table.reloadData()
                        }
                    })
                })
            }
        }
        
        self.settingTable = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height), style: .Plain)
        self.settingTable.delegate = self
        self.settingTable.dataSource = self
        self.settingTable.tableFooterView = UIView.init()
        self.settingTable.separatorInset = UIEdgeInsetsZero
        self.settingTable.layoutMargins = UIEdgeInsetsZero
        self.settingTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: BabySettingTableViewCellId)
        self.addSubview(self.settingTable)
        
        self.selectionHandler = selectionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.settingData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingData[section].setting.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "SettingTableViewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            for subview in resultCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            let model = self.settingData[indexPath.section].setting[indexPath.row]
            resultCell.textLabel?.text = model.mainItem
            resultCell.textLabel?.font = UIFont.systemFontOfSize(14)
            
            switch indexPath.section {
            case 0:
                resultCell.accessoryType = .None
                if model.subItem == "0" || model.subItem == "1" {
                    let onSwitch = HMSwitch.init(frame: CGRectMake(self.frame.width - 80, (CGRectGetHeight(resultCell.contentView.frame) - resultCell.contentView.frame.height * (2 / 3)) / 2, 70, resultCell.contentView.frame.height * (2 / 3)))
                    onSwitch.onLabel.textColor = UIColor.whiteColor()
                    onSwitch.offLabel.textColor = UIColor.whiteColor()
                    onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
                    onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
                    onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
                    onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
                    onSwitch.inactiveColor = UIColor.lightGrayColor()
                    onSwitch.tag = BabySettingSwitchTag + indexPath.row
                    onSwitch.addTarget(self, action: #selector(self.switchOnOff(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    if model.subItem == "0" {
                        onSwitch.onLabel.text = "打开提醒"
                        onSwitch.offLabel.text = "关闭提醒"
                        if model.tipPermission == 1 {
                            onSwitch.on = true
                        }else{
                            onSwitch.on = false
                        }
                    }else{
                        onSwitch.onLabel.text = "消息提醒"
                        onSwitch.offLabel.text = "震动提醒"
                        if model.modePermission == 1 {
                            onSwitch.on = true
                        }else{
                            onSwitch.on = false
                        }
                    }
                    
                    resultCell.contentView.addSubview(onSwitch)
                }
            case 1:
                resultCell.accessoryType = .DisclosureIndicator
                resultCell.detailTextLabel?.font = UIFont.systemFontOfSize(12)
                resultCell.detailTextLabel?.text =  model.subItem
            default:
                break
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.hexStringToColor("#5f545a")
        let titleLabel = UILabel.init(frame: CGRect(x: 12, y: 0, width: headerView.frame.width - 20, height: headerView.frame.height))
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.text = self.settingData[section].title
        titleLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handle = self.selectionHandler {
            handle(indexPath: indexPath, data: self.settingData[indexPath.section].setting)
        }
    }
    
    func switchOnOff(on:HMSwitch) -> Void {
        if on.tag == BabySettingSwitchTag {
            print("tag \(on.tag) on off \(on.on)")
        }else if on.tag == BabySettingSwitchTag + 1{
            print("tag \(on.tag) on off \(on.on)")
        }
    }
    
    func refreshData() -> Void {
        dispatch_queue_create("refreshSettingDataQueue", nil).queue { 
            if self.settingData != nil {
                self.settingData = nil
            }
            self.settingData = []
            var settingDetailData:[SettingDetail] = []
            
            var model = SettingDetail(mainItem: "异常提醒", subItem: "0", itemId: "", tipPermission: 0, modePermission: 1)
            settingDetailData.append(model)
            
            model = SettingDetail(mainItem: "提醒方式", subItem: "1", itemId: "", tipPermission: 0, modePermission: 1)
            settingDetailData.append(model)
            
            var settingModel = BabySetting(title: "提醒设置", setting: settingDetailData)
            self.settingData.append(settingModel)
            
            var subCountData:[SettingDetail] = []
            let childAccounts = ChildAccountBL.findAll()
            if childAccounts.count > 0{
                for account in childAccounts{
                    model = SettingDetail()
                    model.mainItem = account.childName
                    model.subItem = account.childMobile
                    model.itemId = account.idUserChildInfo
                    subCountData.append(model)
                }
                model = SettingDetail(mainItem: "添加/删除子账号", subItem: "添加/删除设备", itemId: "", tipPermission: -1, modePermission: -1)
                subCountData.append(model)
                settingModel = BabySetting(title: "子账号设置", setting: subCountData)
                self.settingData.append(settingModel)
            }else{
                model = SettingDetail(mainItem: "添加/删除子账号", subItem: "添加/删除设备", itemId: "", tipPermission: -1, modePermission: -1)
                subCountData.append(model)
                settingModel = BabySetting(title: "子账号设置", setting: subCountData)
                self.settingData.append(settingModel)
            }
            
            dispatch_get_main_queue().queue({ 
                if let table = self.settingTable{
                    table.reloadData()
                }
            })
        }
    }
    
}



class BabyPushView: UIView {
    private var verifyHandle:(()->())?
    private var cancelHandle:(()->())?
    init(frame: CGRect, verifyHandler:(()->())?, cancelHandler:(()->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let buttonHeight = self.frame.height * (1 / 12)
        let cancelButton = UIButton.init(frame: CGRect(x: 15, y: self.frame.height / 2 + buttonHeight, width: self.frame.width - 2 * 15, height: buttonHeight))
        cancelButton.backgroundColor = UIColor.hexStringToColor("#9a9b9d")
        cancelButton.setTitle("取消", forState: .Normal)
        cancelButton.layer.cornerRadius = buttonHeight / 2 - 3
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(self.cancelClick), forControlEvents: .TouchUpInside)
        self.addSubview(cancelButton)
        
        let confirmButton = UIButton.init(frame: CGRect(x: cancelButton.frame.minX, y: cancelButton.frame.minY - 10 - buttonHeight, width: cancelButton.frame.width, height: cancelButton.frame.height))
        confirmButton.backgroundColor = UIColor.hexStringToColor("#b95360")
        confirmButton.setTitle("进入安全验证", forState: .Normal)
        confirmButton.layer.cornerRadius = buttonHeight / 2 - 3
        confirmButton.layer.masksToBounds = true
        confirmButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        confirmButton.addTarget(self, action: #selector(self.confirmClick), forControlEvents: .TouchUpInside)
        self.addSubview(confirmButton)
        
        let descLabel = UILabel.init(frame: CGRect(x: confirmButton.frame.minX, y: confirmButton.frame.minY - 70, width: cancelButton.frame.width, height: 50))
        descLabel.font = UIFont.systemFontOfSize(13)
        descLabel.text = "您的家人发出了与您一起观看宝宝的请求，您只需要点击下方按钮，完成安全验证环节后即可看到您可爱的宝宝!"
        descLabel.textColor = UIColor.lightGrayColor()
        descLabel.numberOfLines = 0
        self.addSubview(descLabel)
        
        let enviteLabel = UILabel.init(frame: CGRect(x: cancelButton.frame.minX, y: descLabel.frame.minY - 40, width: cancelButton.frame.width, height: 30))
        enviteLabel.font = UIFont.systemFontOfSize(20)
        enviteLabel.textColor = UIColor.hexStringToColor("#d65c78")
        enviteLabel.textAlignment = .Center
        enviteLabel.text = "您的家人邀请您一起看宝宝"
        self.addSubview(enviteLabel)

        let enviteImageViewWidth = self.frame.width * (1 / 6)
        let enviteImageViewHeight = enviteImageViewWidth * (6 / 7)
        
        let enviteImageView = UIImageView.init(frame: CGRect(x: (self.frame.width - enviteImageViewWidth) / 2, y: enviteLabel.frame.minY - 15 - enviteImageViewHeight, width: enviteImageViewWidth, height: enviteImageViewHeight))
        enviteImageView.image = UIImage.imageWithName("baby_enjoy.png")
        self.addSubview(enviteImageView)
        
        self.verifyHandle = verifyHandler
        self.cancelHandle = cancelHandler
    }
    
    func cancelClick() -> Void {
        if let handle = self.cancelHandle {
            handle()
        }
    }
    
    func confirmClick() -> Void {
        if let handle = self.verifyHandle {
            handle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class LookBabyVerifyView: UIView, UITextFieldDelegate{
    private var countDown:CountDownButton!
    private var phoneTFKeyboard:Keyboard!
    private var codeTFKeyboard:Keyboard!
    private var phoneTF:UITextField!
    private var codeTF:UITextField!
    private var nextHandler:(()->())?
    init(frame: CGRect, completionHandler:(()->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let firstStepButton = DeviceButton(type: .Custom)
        firstStepButton.frame = CGRect(x: 30, y: 20, width: self.frame.width * (2 / 3), height: 50)
        firstStepButton.setImageSize(CGSize(width: 15,height: 15), titleS:CGSize(width: firstStepButton.frame.width, height: firstStepButton.frame.height), normaImage: "alertAtension.png", normalTitle: "输入您的手机号后发送验证码!\n验证完后即可开始观看宝宝", fontSize: 15)
        firstStepButton.setCustomTitleColor(UIColor.hexStringToColor("#ba5460"))
        firstStepButton.userInteractionEnabled = false
        self.addSubview(firstStepButton)
        
        let phoneImageWidth = self.frame.width * (1 / 5)
        let phoneImageHeight = self.frame.height * (1 / 2) * (1 / 3)
        let phoneImageView = UIImageView.init(frame: CGRect(x: (self.frame.width - phoneImageWidth) / 2, y: self.frame.height / 2 - phoneImageHeight * (3 / 2), width: phoneImageWidth, height: phoneImageHeight))
        phoneImageView.image = UIImage.imageWithName("myOwnPhoneChecked.png")
        self.addSubview(phoneImageView)
        
        var line = UIView.init(frame: CGRect(x: 0, y: self.frame.height * (3 / 5), width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f7f1f2")
        self.addSubview(line)
        
        self.phoneTF = UITextField.textField(CGRect(x: firstStepButton.frame.minX, y: line.frame.maxY, width: self.frame.width - 50, height: 40), title: nil, holder: "输入您的手机号")
        self.phoneTF.delegate = self
        self.phoneTF.textColor = UIColor.whiteColor()
        self.addSubview(self.phoneTF)
        self.phoneTFKeyboard = Keyboard.init(targetView: self.phoneTF, container: self, hasNav: true, show: nil, hide: nil)
        
        line = UIView.init(frame: CGRect(x: 0, y: self.phoneTF.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f7f1f2")
        self.addSubview(line)
        
        self.countDown = CountDownButton(type: .Custom)
        self.countDown.backgroundColor = UIColor.hexStringToColor("#b85562")
        self.countDown.setupBase(CGRect(x: 0, y: 0, width: 80, height: 20), completionHandler: {[weak self] in
            if let weakSelf = self{
                weakSelf.phoneTF.resignFirstResponder()
                weakSelf.codeTF.resignFirstResponder()
                
                /*
                 if let phone = weakSelf.phoneTF.text{
                 if phone.characters.count == 11{
                 if let code = weakSelf.codeTF.text{
                 if code == ""{
                 HUD.showText("请输入手机号", onView: weakSelf)
                 }
                 }
                 weakSelf.countDown.shouldStartAction = true
                 HUD.showHud("正在发送...", onView: weakSelf)
                 VerifyCode.sendAsyncVerifyCode(phone, type: "1", completionHandler: { (code) in
                 HUD.hideHud(weakSelf)
                 if code == nil{
                 HUD.showText("发送验证码失败", onView: weakSelf)
                 }else{
                 if code.errorCode == PASSCODE{
                 HUD.showText("发送验证码成功，请及时查看", onView: weakSelf)
                 }else{
                 HUD.showText("发送验证码失败", onView: weakSelf)
                 }
                 }
                 })
                 }else{
                 HUD.hideHud(weakSelf)
                 if phone == ""{
                 HUD.showText("请输入手机号", onView: weakSelf)
                 }else{
                 HUD.showText("手机号不正确", onView: weakSelf)
                 }
                 }
                 }
                 */
            }
            })
        
        self.codeTF = UITextField.textField(CGRect(x: self.phoneTF.frame.minX, y: self.phoneTF.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: nil, holder: "请输入手机验证码", left: false, right: true, rightView: countDown)
        self.codeTF.delegate = self
        self.codeTF.textColor = UIColor.whiteColor()
        self.addSubview(self.codeTF)
        
        self.codeTFKeyboard = Keyboard.init(targetView: self.codeTF, container: self, hasNav: true, show: nil, hide: nil)
        
        line = UIView.init(frame: CGRect(x: 0, y: self.codeTF.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f7f1f2")
        self.addSubview(line)
        
        let startButtion = UIButton.init(frame: CGRect(x: 20, y: self.frame.height - 50, width: self.frame.width - 40, height: 40))
        startButtion.backgroundColor = UIColor.hexStringToColor("#b85562")
        startButtion.layer.cornerRadius = 20
        startButtion.layer.masksToBounds = true
        startButtion.setTitle("开始看宝宝", forState: .Normal)
        startButtion.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startButtion.addTarget(self, action: #selector(self.checkBabyClick), forControlEvents: .TouchUpInside)
        self.addSubview(startButtion)
        
        self.nextHandler = completionHandler
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.codeTF = nil
        self.codeTFKeyboard = nil
        self.phoneTF = nil
        self.countDown = nil
        self.phoneTFKeyboard = nil
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    func checkBabyClick() -> Void {
        if let handle = self.nextHandler {
            handle()
        }
    }
}




