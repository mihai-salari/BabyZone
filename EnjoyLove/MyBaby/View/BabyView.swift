//
//  BaByView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit


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




