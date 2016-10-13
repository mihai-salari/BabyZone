//
//  BaByView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit


class BabyView: UIView,UIScrollViewDelegate{

    private var babyScrollView:UIScrollView!
    private var babyPageControl:FilledPageControl!
    private var temperatureLabel:UILabel!
    private var humidityLabel:UILabel!
    private var remindLabel:UILabel!
    private var babyData:[Baby]!
    private var playHandler:((baby:Baby!)->())?
    private var musicHandler:((baby:Baby!)->())?
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
    
    init(frame: CGRect,data:[Baby],playCompletionHandler:((baby:Baby!)->())?, musicCompletionHandler:((baby:Baby!)->())?) {
        super.init(frame: frame)
        self.babyData = data
        self.babyScrollView = UIScrollView.init(frame: self.bounds)
        self.babyScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.babyScrollView.contentSize = CGSize(width: CGFloat(data.count) * self.babyScrollView.frame.width, height: self.babyScrollView.frame.height)
        self.babyScrollView.showsHorizontalScrollIndicator = false
        self.babyScrollView.pagingEnabled = true
        self.babyScrollView.delegate = self
        self.addSubview(self.babyScrollView)
        
        for i in 0 ..< data.count {
            let babyImageView  = UIImageView.init(frame: CGRect(x: CGFloat(i) * self.babyScrollView.frame.width, y: 0, width: self.babyScrollView.frame.width, height: self.babyScrollView.frame.height))
            babyImageView.image = UIImage.imageWithName(data[i].babyImage)
            self.babyScrollView.addSubview(babyImageView)
            
            let maskView = UIView.init(frame: babyImageView.frame)
            maskView.backgroundColor = UIColor.colorFromRGB(0, g: 0, b: 0, a: 0.3)
            self.babyScrollView.addSubview(maskView)
            
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
        self.temperatureLabel.textColor = UIColor.hexStringToColor("#ab1619")
        self.temperatureLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(self.temperatureLabel)
        
        let tempDescLabel = UILabel.init(frame: CGRect(x: temperatureLabel.frame.minX, y: temperatureLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        tempDescLabel.text = "温度(°)"
        tempDescLabel.textAlignment = .Center
        tempDescLabel.textColor = UIColor.hexStringToColor("#ab1619")
        tempDescLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(tempDescLabel)
        
        
        self.humidityLabel = UILabel.init(frame: CGRect(x: temperatureLabel.frame.maxX, y: temperatureLabel.frame.minY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        self.humidityLabel.text = data[0].babyHumidity
        self.humidityLabel.textAlignment = .Center
        self.humidityLabel.textColor = UIColor.hexStringToColor("#dd6a6a")
        self.humidityLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(self.humidityLabel)
        
        let humidityDescLabel = UILabel.init(frame: CGRect(x: humidityLabel.frame.minX, y: humidityLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        humidityDescLabel.text = "湿度(%)"
        humidityDescLabel.textAlignment = .Center
        humidityDescLabel.textColor = UIColor.hexStringToColor("#dd6a6a")
        humidityDescLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(humidityDescLabel)
        
        self.remindLabel = UILabel.init(frame: CGRect(x: humidityLabel.frame.maxX, y: temperatureLabel.frame.minY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        self.remindLabel.text = data[0].babyRemindCount
        self.remindLabel.textAlignment = .Center
        self.remindLabel.textColor = UIColor.hexStringToColor("#dd6a6a")
        self.remindLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(self.remindLabel)
        
        let remindDescLabel = UILabel.init(frame: CGRect(x: remindLabel.frame.minX, y: temperatureLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
        remindDescLabel.text = "异常"
        remindDescLabel.textAlignment = .Center
        remindDescLabel.textColor = UIColor.hexStringToColor("#dd6a6a")
        remindDescLabel.font = UIFont.boldSystemFontOfSize(10)
        self.addSubview(remindDescLabel)
        
        let pageControlWidth = CGFloat(data.count) * 13.5
        self.babyPageControl = FilledPageControl(frame: CGRect(x: (self.frame.width - pageControlWidth) / 2, y: tempDescLabel.frame.maxY + 8, width: pageControlWidth, height: 10))
        self.babyPageControl.pageCount = data.count
        self.babyPageControl.indicatorPadding = 5
        self.babyPageControl.tintColor = UIColor.hexStringToColor("#dd6a6a")
        self.babyPageControl.borderColor = UIColor.hexStringToColor("#dd6a6a")
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
                    handle(baby: data[self.currentBaby])
                }
            }
        }
    }

    func babyMusicClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.musicHandler {
            if let data = self.babyData {
                if data.count > 0 {
                    handle(baby: data[self.currentBaby])
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}



private let mainItemLabelWidth:CGFloat = upRateWidth(120)
private let switchHeight:CGFloat = upRateWidth(20)
private let switchWidth:CGFloat = upRateWidth(60)
private let subItemLabelWidth:CGFloat = upRateWidth(100)


class BabySettingCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCellWithModel(model:SettingDetail) -> Void {
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: self.contentView.frame.width - 20, height: self.contentView.frame.height)
        let mainItemLabel = UILabel.init(frame: CGRectMake(20, 0, mainItemLabelWidth, CGRectGetHeight(self.contentView.frame)))
        mainItemLabel.text = model.mainItem
        mainItemLabel.font = UIFont.boldSystemFontOfSize(14)
        self.contentView.addSubview(mainItemLabel)
        
        if model.subItem == "0" || model.subItem == "1"{
            let onSwitch = HMSwitch.init(frame: CGRectMake(self.contentView.frame.width - upRateWidth(70), (CGRectGetHeight(self.contentView.frame) - switchHeight) / 2, switchWidth, switchHeight))
            onSwitch.onLabel.font = UIFont.boldSystemFontOfSize(upRateWidth(8))
            onSwitch.onTintColor = navigationBarColor
            onSwitch.borderColor = navigationBarColor
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.on = true
            if model.subItem == "0" {
                onSwitch.onLabel.text = "打开提醒"
            }else{
                onSwitch.onLabel.text = "消息提醒"
            }
            self.contentView.addSubview(onSwitch)
        }
        
        if model.subItem != "0" && model.subItem != "1" {
            let subItemLabel = UILabel.init(frame: CGRectMake(self.contentView.frame.width - upRateWidth(130), 0, subItemLabelWidth, settingTableRowHeight))
            subItemLabel.text = model.subItem
            subItemLabel.font = UIFont.boldSystemFontOfSize(10)
            subItemLabel.textAlignment = .Right
            subItemLabel.textColor = UIColor.lightGrayColor()
            self.contentView.addSubview(subItemLabel)
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

class BabyVideoView: UIView,OpenGLViewDelegate {
    
    var cameraClick:((selected:Bool)->())?
    var videoClick:((selected:Bool)->())?
    var musicClick:((selected:Bool)->())?
    var voiceClick:((selected:Bool)->())?
    
    private var cancelHandle:(()->())?
    private var babyModel:Baby!
    private var remoteView:OpenGLView!
    private var remoteMaskView:UIView!
    private var cancelButton:UIButton!
    private var cameraButton:UIButton!
    private var videoButton:UIButton!
    private var musicButton:UIButton!
    private var voiceButton:UIButton!
    private var buttonContainerView:UIView!
    
    private let buttonPadding:CGFloat = 5
    private var buttonContainerViewWidth:CGFloat = 0
    private let buttonContainerViewHeight:CGFloat = 55
    private var buttonContainerViewOriginFrame:CGRect = CGRectZero
    
    
    init(frame: CGRect, baby:Baby, cancelCompletionHandler:(()->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blackColor()
        
        if let phone = NSUserDefaults.standardUserDefaults().objectForKey(UserPhoneKey) as? String {
            if let base = LoginBL.find(nil, key: phone){
                if let p2p = P2PClient.sharedClient(){
                    p2p.callId = base.contactId
                    if let filePath = Utils.getHeaderFilePathWithId(p2p.callId) {
                        if let headImg = UIImage.init(contentsOfFile: filePath) {
                            self.layer.contents = headImg.CGImage
                        }else{
                            self.layer.contents = UIImage.imageWithName(baby.babyImage)?.CGImage
                        }
                    }else{
                        self.layer.contents = UIImage.imageWithName(baby.babyImage)?.CGImage
                    }
                }
            }
            
        }
        
        
        self.remoteView = OpenGLView.init(frame: self.bounds)
        self.remoteView.layer.masksToBounds = true
        self.remoteView.delegate = self
        self.addSubview(self.remoteView)
        
        self.cancelButton = UIButton.init(type: .Custom)
        self.cancelButton.frame = CGRect(x: 30, y: 30, width: 50, height: 50)
        self.cancelButton.setImage(UIImage.imageWithName("baby_cancel.png"), forState: .Normal)
        self.cancelButton.addTarget(self, action: #selector(self.cancelButtonClick), forControlEvents: .TouchUpInside)
        self.addSubview(self.cancelButton)
        
        
        self.buttonContainerViewWidth = buttonPadding * 3 + buttonContainerViewHeight * 4
        self.buttonContainerView = UIView.init(frame: CGRect(x: (self.frame.width - buttonContainerViewWidth) / 2, y: self.frame.height - buttonContainerViewHeight - 20, width: buttonContainerViewWidth, height: buttonContainerViewHeight))
        self.buttonContainerViewOriginFrame = self.buttonContainerView.frame
        self.addSubview(self.buttonContainerView)
        
        self.cameraButton = UIButton.init(type: .Custom)
        self.cameraButton.frame = CGRect(x: 0, y: 0, width: buttonContainerViewHeight, height: buttonContainerViewHeight)
        self.cameraButton.setImage(UIImage.imageWithName("baby_camera_normal.png"), forState: .Normal)
        self.cameraButton.setImage(UIImage.imageWithName("baby_camera_selected.png"), forState: .Selected)
        self.cameraButton.addTarget(self, action: #selector(self.cameraButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.buttonContainerView.addSubview(self.cameraButton)
        
        self.videoButton = UIButton.init(type: .Custom)
        self.videoButton.frame = CGRect(x: self.cameraButton.frame.maxX + buttonPadding, y: 0, width: buttonContainerViewHeight, height: buttonContainerViewHeight)
        self.videoButton.setImage(UIImage.imageWithName("baby_video_normal.png"), forState: .Normal)
        self.videoButton.setImage(UIImage.imageWithName("baby_video_selected.png"), forState: .Selected)
        self.videoButton.addTarget(self, action: #selector(self.videoButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.buttonContainerView.addSubview(self.videoButton)
        
        
        self.musicButton = UIButton.init(type: .Custom)
        self.musicButton.frame = CGRect(x: self.videoButton.frame.maxX + buttonPadding, y: 0, width: buttonContainerViewHeight, height: buttonContainerViewHeight)
        self.musicButton.setImage(UIImage.imageWithName("baby_music_normal.png"), forState: .Normal)
        self.musicButton.setImage(UIImage.imageWithName("baby_music_selected.png"), forState: .Selected)
        self.musicButton.addTarget(self, action: #selector(self.musicButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.buttonContainerView.addSubview(self.musicButton)
        
        self.voiceButton = UIButton.init(type: .Custom)
        self.voiceButton.frame = CGRect(x: self.musicButton.frame.maxX + buttonPadding, y: 0, width: buttonContainerViewHeight, height: buttonContainerViewHeight)
        self.voiceButton.setImage(UIImage.imageWithName("baby_voice_normal.png"), forState: .Normal)
        self.voiceButton.setImage(UIImage.imageWithName("baby_voice_selected.png"), forState: .Selected)
        self.voiceButton.addTarget(self, action: #selector(self.voiceButtonClick(_:)), forControlEvents: .TouchUpInside)
        self.buttonContainerView.addSubview(self.voiceButton)
        
        self.cancelHandle = cancelCompletionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonClick() -> Void {
        if let handle = self.cancelHandle {
            NSNotificationCenter.defaultCenter().postNotificationName(BabyCancelClickNotification, object: nil)
            handle()
        }
    }
    
    func rotateSubviews(orientation:UIDeviceOrientation) -> Void {
        switch orientation {
        case .LandscapeLeft, .LandscapeRight:
            self.buttonContainerView.frame = CGRect(x: ScreenHeight - self.buttonContainerViewHeight - 20, y: (ScreenWidth - self.buttonContainerViewWidth) / 2, width: self.buttonContainerViewHeight, height: self.buttonContainerViewWidth)
            self.videoButton.frame = CGRect(origin: CGPoint(x: 0, y: self.cameraButton.frame.maxY + self.buttonPadding), size: self.videoButton.frame.size)
            self.musicButton.frame = CGRect(origin: CGPoint(x: 0, y: self.videoButton.frame.maxY + self.buttonPadding), size: self.musicButton.frame.size)
            self.voiceButton.frame = CGRect(origin: CGPoint(x: 0, y: self.musicButton.frame.maxY + self.buttonPadding), size: self.voiceButton.frame.size)
        default:
            self.buttonContainerView.frame = self.buttonContainerViewOriginFrame
            self.videoButton.frame = CGRect(origin: CGPoint(x: self.cameraButton.frame.maxX + self.buttonPadding, y: 0), size: self.videoButton.frame.size)
            self.musicButton.frame = CGRect(origin: CGPoint(x: self.videoButton.frame.maxX + self.buttonPadding, y: 0), size: self.musicButton.frame.size)
            self.voiceButton.frame = CGRect(origin: CGPoint(x: self.musicButton.frame.maxX + self.buttonPadding, y: 0), size: self.voiceButton.frame.size)
        }
        
    }
    
    func cameraButtonClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.cameraClick {
            handle(selected: btn.selected)
        }
    }
    
    func videoButtonClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.videoClick {
            handle(selected: btn.selected)
        }
    }
    
    func musicButtonClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.musicClick {
            handle(selected: btn.selected)
        }
    }
    
    func voiceButtonClick(btn:UIButton) -> Void {
        btn.selected = !btn.selected
        if let handle = self.voiceClick {
            handle(selected: btn.selected)
        }
    }
    
    func onScreenShotted(image: UIImage!) {
        if let cgImg = image.CGImage {
            let tempImage = UIImage.init(CGImage: cgImg)
            if let imageData = UIImagePNGRepresentation(tempImage) {
                let imgData = NSData.init(data: imageData)
                Utils.saveScreenshotFile(imgData)
            }
        }
    }
    
    func renderFrame(frame:UnsafeMutablePointer<GAVFrame>) -> Void {
        if self.remoteView != nil {
            self.remoteView.render(frame)
            vReleaseVideoFrame()
        }
    }
    
    func captureFinishScreen(finished:Bool) -> Void {
        if let remote = self.remoteView {
            remote.captureFinishScreen = finished
        }
    }
    
}


