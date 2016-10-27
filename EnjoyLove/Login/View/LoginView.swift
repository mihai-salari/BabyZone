//
//  LoginView.swift
//  Login
//
//  Created by 黄漫 on 16/9/16.
//  Copyright © 2016年 黄漫. All rights reserved.
//

import UIKit

class LoginView: UIView,UITextFieldDelegate {

    private var phoneTF:UITextField!
    private var passwordTF:UITextField!
    private var loginHandler:((phone:String, isPhone:Bool, password:String)->())?
    private var wechatHandler:(()->())?
    private var registerHandler:((phone:String)->())?
    
    init(frame: CGRect,commonLogin:((phone:String, isPhone:Bool, password:String)->())?, wechatLogin:(()->())?,register:((phone:String)->())?) {
        super.init(frame: frame)
        self.initializeSubviews()
        self.loginHandler = commonLogin
        self.wechatHandler = wechatLogin
        self.registerHandler = register
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeSubviews(){
        
        let loginButton = UIButton.init(type: .Custom)
        loginButton.frame = CGRect(x: 20, y: self.frame.midY, width: self.frame.width - 40, height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        loginButton.backgroundColor = UIColor.hexStringToColor("#b85562")
        loginButton.setTitle("登录", forState: .Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.addTarget(self, action: #selector(LoginView.loginClick), forControlEvents: .TouchUpInside)
        self.addSubview(loginButton)
        
        self.phoneTF = self.textField(CGRect(x: loginButton.frame.minX, y: loginButton.frame.minY - 100, width: loginButton.frame.width, height: loginButton.frame.height), title: "手机号:", holder: "输入您的手机号")
        self.phoneTF.textColor = UIColor.whiteColor()
        if let userName = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.UserPhoneKey) as? String {
            self.phoneTF.text = userName
        }
        self.addSubview(self.phoneTF)
        
        self.passwordTF = self.textField(CGRect(x: self.phoneTF.frame.minX, y: self.phoneTF.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: "密码:", holder: "填写密码(8-16位)")
        self.passwordTF.secureTextEntry = true
        self.passwordTF.textColor = UIColor.whiteColor()
        self.addSubview(self.passwordTF)
        
        let logoLabel = UILabel.init(frame: CGRect(x: 0, y: self.phoneTF.frame.minY - upRateHeight(80), width: self.frame.width, height: 25))
        logoLabel.text = "L o g o"
        logoLabel.textAlignment = .Center
        logoLabel.textColor = UIColor.whiteColor()
        logoLabel.font = UIFont.systemFontOfSize(20)
        self.addSubview(logoLabel)
        
        let logoSubLabel = UILabel.init(frame: CGRect(x: 0, y: logoLabel.frame.maxY, width: logoLabel.frame.width, height: 15))
        logoSubLabel.textColor = UIColor.whiteColor()
        logoSubLabel.text = "让 妈 妈 也 能 睡 个 好 觉"
        logoSubLabel.font = UIFont.systemFontOfSize(12)
        logoSubLabel.textAlignment = .Center
        self.addSubview(logoSubLabel)
        
        /*
        let wechatButton = UserLoginButton(type: .Custom)
        wechatButton.frame = CGRect(x: loginButton.frame.minX, y: loginButton.frame.maxY + 10, width: loginButton.frame.width * (1 / 3), height: 30)
        wechatButton.setImageRect(CGSize(width: 18, height: 15), normaImage: "login_wechat.png", normalTitle: "微信号登录", fontSize: 11)
        wechatButton.setCustomTitleColor(UIColor.whiteColor())
        wechatButton.addTarget(self, action: #selector(LoginView.wechatLoginClick), forControlEvents: .TouchUpInside)
        self.addSubview(wechatButton)
        */
        
        let registerButton = UserLoginButton(type: .Custom)
        registerButton.frame = CGRect(x: loginButton.frame.midX , y: loginButton.frame.maxY + 10, width: loginButton.frame.width / 2, height: 30)
        registerButton.setImageRect(CGSize(width: 10, height: 5), normaImage: "login_register.png", normalTitle: "还没有账号？注册一个吧", fontSize: 11)
        registerButton.setCustomTitleColor(UIColor.whiteColor())
        registerButton.addTarget(self, action: #selector(LoginView.registerClick), forControlEvents: .TouchUpInside)
        self.addSubview(registerButton)
        
    }
    
    private func textField(frame:CGRect,title:String,holder:String) ->UITextField{
        let tf = UITextField.init(frame: frame)
        tf.placeholder = holder
        tf.delegate = self
        tf.font = UIFont.systemFontOfSize(15)
        tf.leftViewMode = .Always
        let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: tf.frame.width * (1 / 4), height: tf.frame.height))
        titleLabel.text = title
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.systemFontOfSize(15)
        tf.leftView = titleLabel
        let line = UIView.init(frame: CGRect(x: 0, y: tf.frame.height - 0.5, width: tf.frame.width, height: 0.5))
        line.backgroundColor = UIColor.colorFromRGB(255, g: 255, b: 255, a: 0.6)
        tf.addSubview(line)
        return tf
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneTF , let txt = textField.text {
            let text = NSMutableString.init(string: txt)
            text.replaceCharactersInRange(range, withString: string)
            return text.length <= 11
        }
        return true
    }
    
    func loginClick() -> Void {
        self.phoneTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
        if let handle = self.loginHandler, let phone = self.phoneTF.text, let password = self.passwordTF.text{
            handle(phone: phone, isPhone: phone.isTelNumber(), password: password)
        }
    }
    
    func wechatLoginClick() -> Void {
        if let handle = self.wechatHandler {
            handle()
        }
    }
    
    func registerClick() -> Void {
        if let handle = self.registerHandler, let phone = self.passwordTF.text {
            handle(phone: phone)
        }
    }
}

class RegisterView: UIView,UITextFieldDelegate {
    private var phoneTF:UITextField!
    private var codeTF:UITextField!
    private var passwordTF:UITextField!
    private var confirmTF:UITextField!
    private var countDown:CountDownButton!
    private var nextHandler:((phone:String, isPhone:Bool, code:String, password:String)->())?
    private var registedHandler:(()->())?
    private var agreementHandler:(()->())?
    
    init(frame: CGRect,nextStepHandler:((phone:String, isPhone:Bool, code:String, password:String)->())?, alreadyRegisterHandler:(()->())?, agreeHandler:(()->())?) {
        super.init(frame: frame)
        self.initializeSubviews()
        self.nextHandler = nextStepHandler
        self.registedHandler = alreadyRegisterHandler
        self.agreementHandler = agreeHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeSubviews(){
        
        let loginButton = UIButton.init(type: .Custom)
        loginButton.frame = CGRect(x: 20, y: self.frame.height * (3 / 5), width: self.frame.width - 40, height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        loginButton.backgroundColor = UIColor.hexStringToColor("#b85562")
        loginButton.setTitle("下一步", forState: .Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.addTarget(self, action: #selector(RegisterView.nextStepClick), forControlEvents: .TouchUpInside)
        self.addSubview(loginButton)
        
        
        self.phoneTF = UITextField.textField(CGRect(x: loginButton.frame.minX, y: loginButton.frame.minY - 180, width: loginButton.frame.width, height: loginButton.frame.height), title: "手机号:", holder: "输入您的手机号")
        self.phoneTF.delegate = self
        self.phoneTF.textColor = UIColor.whiteColor()
        self.addSubview(self.phoneTF)
        
        
        self.countDown = CountDownButton(type: .Custom)
        self.countDown.backgroundColor = UIColor.hexStringToColor("#b85562")
        self.countDown.setupBase(CGRect(x: 0, y: 0, width: 80, height: 20), completionHandler: {[weak self] in
            if let weakSelf = self{
                weakSelf.phoneTF.resignFirstResponder()
                weakSelf.passwordTF.resignFirstResponder()
                weakSelf.codeTF.resignFirstResponder()

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
                                if code.errorCode == BabyZoneConfig.shared.passCode{
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
            }
        })
        
        self.codeTF = UITextField.textField(CGRect(x: self.phoneTF.frame.minX, y: self.phoneTF.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: "验证码", holder: "请输入验证码", left: true, right: true, rightView: countDown)
        self.codeTF.delegate = self
        self.codeTF.textColor = UIColor.whiteColor()
        self.addSubview(self.codeTF)
        
        self.passwordTF = UITextField.textField(CGRect(x: self.phoneTF.frame.minX, y: self.codeTF.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: "密码:", holder: "填写密码(8-16位)")
        self.passwordTF.secureTextEntry = true
        self.passwordTF.delegate = self
        self.passwordTF.textColor = UIColor.whiteColor()
        self.addSubview(self.passwordTF)
        
        self.confirmTF = UITextField.textField(CGRect(x: self.phoneTF.frame.minX, y: self.passwordTF.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: "确认密码:", holder: "请输入确认密码")
        self.confirmTF.secureTextEntry = true
        self.confirmTF.delegate = self
        self.confirmTF.textColor = UIColor.whiteColor()
        self.addSubview(self.confirmTF)
        
        let logoLabel = UILabel.init(frame: CGRect(x: 0, y: self.phoneTF.frame.minY - upRateHeight(60), width: self.frame.width, height: 25))
        logoLabel.text = "L o g o"
        logoLabel.textAlignment = .Center
        logoLabel.textColor = UIColor.whiteColor()
        logoLabel.font = UIFont.systemFontOfSize(20)
        self.addSubview(logoLabel)
        
        let logoSubLabel = UILabel.init(frame: CGRect(x: 0, y: logoLabel.frame.maxY, width: logoLabel.frame.width, height: 15))
        logoSubLabel.textColor = UIColor.whiteColor()
        logoSubLabel.text = "让 妈 妈 也 能 睡 个 好 觉"
        logoSubLabel.font = UIFont.systemFontOfSize(12)
        logoSubLabel.textAlignment = .Center
        self.addSubview(logoSubLabel)
        
        
        let registerButton = UserLoginButton(type: .Custom)
        registerButton.frame = CGRect(x: loginButton.frame.minX + loginButton.frame.width * (3 / 4) , y: loginButton.frame.maxY + 10, width: loginButton.frame.width / 2, height: 30)
        registerButton.setImageRect(CGSize(width: 10, height: 5), normaImage: "login_register.png", normalTitle: "已有账号", fontSize: 11)
        registerButton.setCustomTitleColor(UIColor.whiteColor())
        registerButton.addTarget(self, action: #selector(RegisterView.alreadyRegisterClick), forControlEvents: .TouchUpInside)
        self.addSubview(registerButton)
        
        
        let agreementTipLabel = UILabel.init(frame: CGRect(x: 0, y: self.frame.height - 60, width: self.frame.width, height: 10))
        agreementTipLabel.font = UIFont.systemFontOfSize(10)
        agreementTipLabel.text = "点击\"下一步\"按钮，即表示你同意"
        agreementTipLabel.textAlignment = .Center
        agreementTipLabel.textColor = UIColor.whiteColor()
        self.addSubview(agreementTipLabel)
        
        let agreementButton = UIButton.init(type: .Custom)
        agreementButton.frame = CGRect(x: (self.frame.width - 150) / 2, y: agreementTipLabel.frame.maxY, width: 150, height: 20)
        agreementButton.titleLabel?.font = UIFont.systemFontOfSize(10)
        agreementButton.setTitle("《享爱软件许可及服务协议》", forState: .Normal)
        agreementButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        agreementButton.addTarget(self, action: #selector(RegisterView.agreementClick), forControlEvents: .TouchUpInside)
        self.addSubview(agreementButton)
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.phoneTF , let txt = textField.text {
            let text = NSMutableString.init(string: txt)
            text.replaceCharactersInRange(range, withString: string)
            return text.length <= 11
        }
        return true
    }
    
    
    func nextStepClick() -> Void {
        if let handle = self.nextHandler, let phone = self.phoneTF.text, let password = self.passwordTF.text, let code = self.codeTF.text{
            handle(phone: phone, isPhone: phone.isTelNumber(), code: code, password: password)
        }
    }
        
    func alreadyRegisterClick() -> Void {
        if let handle = self.registedHandler {
            handle()
        }
    }
    
    func agreementClick() -> Void {
        if let agree = self.agreementHandler {
            agree()
        }
    }
}

private let LoginStatusCollectionViewCellId = "LoginStatusCollectionViewCellId"
private let LoginSexCollectionViewCellId = "LoginSexCollectionViewCellId"
private let LoginThirdCollectionViewHeaderId = "LoginThirdCollectionViewHeaderId"
private let StatusImageViewStartIndex = 100
private let SexImageViewStartIndex = 150
private let StatusItemLabelStartIndex = 200
private let SexItemLabelStartIndex = 250
class LoginBaseInfoView: UIView ,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,DatePickerDelegate{
    
    private var statusCollectionView:UICollectionView!
    private var statusModel:ThirdLogin!
    private var sexCollectionView:UICollectionView!
    private var sexModel:ThirdLogin!
    private var yearButton:DateButton!
    private var monthButton:DateButton!
    private var dayButton:DateButton!
    private var datePicker:PickerControllView!
    private var registModel:RegisterInfo!
    private var finishHandler:((model:RegisterInfo)->())?
    
    init(frame: CGRect, phone:String, password:String, validCode:String, completionHandler:((model:RegisterInfo)->())?) {
        super.init(frame: frame)
        self.registModel = RegisterInfo()
        self.registModel.phoneNum = phone
        self.registModel.password = password
        self.registModel.validCode = validCode
        self.initialize()
        self.finishHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initialize(){
        var detail:[ThirdLoginDetail] = []
        var detailModel = ThirdLoginDetail(thirdNormalImage: "login_pregnancy_normal.png", thirdSelectedImage: "login_pregnancy_selected.png", thirdName: "备孕", thirdDetailId: "2")
        detail.append(detailModel)
        
        detailModel = ThirdLoginDetail(thirdNormalImage: "login_pregnancy_normal.png", thirdSelectedImage: "login_pregnancy_selected.png", thirdName: "怀孕", thirdDetailId: "3")
        detail.append(detailModel)
        
        detailModel = ThirdLoginDetail(thirdNormalImage: "login_baby_normal.png", thirdSelectedImage: "login_baby_selected.png", thirdName: "已有宝宝", thirdDetailId: "4")
        detail.append(detailModel)
        self.statusModel = ThirdLogin(thirdTitle: "您目前的状态", loginThird: detail)
        
        detail = []
        detailModel = ThirdLoginDetail(thirdNormalImage: "login_male_normal.png", thirdSelectedImage: "login_male_selected.png", thirdName: "男", thirdDetailId: "1")
        detail.append(detailModel)
        
        detailModel = ThirdLoginDetail(thirdNormalImage: "login_female_normal.png", thirdSelectedImage: "login_female_selected.png", thirdName: "女", thirdDetailId: "2")
        detail.append(detailModel)
        self.sexModel = ThirdLogin(thirdTitle: "宝宝的性别?", loginThird: detail)
        
        
        var flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.frame.width / 3.5, height: self.frame.width / 3.5)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        flowLayout.minimumInteritemSpacing = 5
        
        self.statusCollectionView = UICollectionView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.frame.width, height: ((self.frame.height) / 2) / 2), collectionViewLayout: flowLayout)
        self.statusCollectionView.backgroundColor = UIColor.clearColor()
        self.statusCollectionView.delegate = self
        self.statusCollectionView.dataSource = self
        self.statusCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: LoginStatusCollectionViewCellId)
        self.statusCollectionView.registerClass(ThirdHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LoginThirdCollectionViewHeaderId)
        self.addSubview(self.statusCollectionView)
        
        
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.frame.width / 3.5, height: self.frame.width / 3.5)
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
        flowLayout.minimumInteritemSpacing = 5
        
        self.sexCollectionView = UICollectionView.init(frame: CGRect(x: self.frame.width / 5.5, y: self.statusCollectionView.frame.maxY, width: self.frame.width - 2 * self.frame.width / 5.5, height: ((self.frame.height) / 2) / 2), collectionViewLayout: flowLayout)
        self.sexCollectionView.backgroundColor = UIColor.clearColor()
        self.sexCollectionView.delegate = self
        self.sexCollectionView.dataSource = self
        self.sexCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: LoginSexCollectionViewCellId)
        self.sexCollectionView.registerClass(ThirdHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: LoginThirdCollectionViewHeaderId)
        self.addSubview(self.sexCollectionView)
        
        let babyBirthLabel = UILabel.init(frame: CGRect(x: 0, y: self.frame.height * (2 / 3), width: self.frame.width, height: 15))
        babyBirthLabel.text = "宝宝的生日是?"
        babyBirthLabel.textAlignment = .Center
        babyBirthLabel.textColor = UIColor.whiteColor()
        babyBirthLabel.font = UIFont.systemFontOfSize(12)
        self.addSubview(babyBirthLabel)
        
        let width = self.frame.width * (1 / 5)
        var x = (self.frame.width * (1 / 2) - width) / 2
        let y = babyBirthLabel.frame.maxY + 10
        let height:CGFloat = 60
        let frame = CGRect(x: x, y: y, width: width, height: height)
        self.yearButton = self.dateButton(frame, title: "1998", view: babyBirthLabel, dateItem: "年")
        
        self.monthButton = self.dateButton(CGRect(x: (self.frame.width - self.frame.width * (1 / 5)) * (1 / 2), y: babyBirthLabel.frame.maxY + 10, width: self.frame.width * (1 / 5), height: 60), title: "02", view: babyBirthLabel, dateItem: "月")
        
        
        x = self.frame.width * (3 / 4) - width * (1 / 2)
        self.dayButton = self.dateButton(CGRect(x: x, y: babyBirthLabel.frame.maxY + 10, width: self.frame.width * (1 / 5), height: 60), title: "15", view: babyBirthLabel, dateItem: "日")
        
        let finishButton = UIButton.init(type: .Custom)
        finishButton.frame = CGRect(x: 30, y: y + height + 20, width: self.frame.width - 60, height: 40)
        finishButton.backgroundColor = UIColor.hexStringToColor("#b85562")
        finishButton.layer.cornerRadius = 20
        finishButton.layer.masksToBounds = true
        finishButton.setTitle("完成注册", forState: .Normal)
        finishButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        finishButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        finishButton.addTarget(self, action: #selector(LoginBaseInfoView.finishRegisterClick), forControlEvents: .TouchUpInside)
        self.addSubview(finishButton)
    }
    

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.statusCollectionView {
            return self.statusModel.loginThird.count
        }else if collectionView == self.sexCollectionView{
            return self.sexModel.loginThird.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        if collectionView == self.statusCollectionView {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(LoginStatusCollectionViewCellId, forIndexPath: indexPath)
            let detaiModel = self.statusModel.loginThird[indexPath.item]
            self.refreshCell(collectionView, cell: cell, indexPath: indexPath, model: detaiModel)
        }else if collectionView == self.sexCollectionView{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(LoginSexCollectionViewCellId, forIndexPath: indexPath)
            let detaiModel = self.sexModel.loginThird[indexPath.item]
            self.refreshCell(collectionView, cell: cell, indexPath: indexPath, model: detaiModel)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var header:ThirdHeaderView!
        if collectionView == self.statusCollectionView {
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: LoginThirdCollectionViewHeaderId, forIndexPath: indexPath) as! ThirdHeaderView
            header.title = self.statusModel.thirdTitle
        }else if collectionView == self.sexCollectionView{
            header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: LoginThirdCollectionViewHeaderId, forIndexPath: indexPath) as! ThirdHeaderView
            header.title = self.sexModel.thirdTitle
        }
        return header
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell  = collectionView.cellForItemAtIndexPath(indexPath)
        if collectionView == self.statusCollectionView {
            if let view = cell?.contentView.viewWithTag(StatusImageViewStartIndex + indexPath.item) {
                let imageView = view as! UIImageView
                let detailModel = self.statusModel.loginThird[indexPath.item]
                imageView.image = UIImage.imageWithName(detailModel.thirdSelectedImage)
            }
            self.registModel.breedStatus = "\(indexPath.item + 1)"
        }else if collectionView == self.sexCollectionView{
            if let view = cell?.contentView.viewWithTag(SexImageViewStartIndex + indexPath.item) {
                let imageView = view as! UIImageView
                let detailModel = self.sexModel.loginThird[indexPath.item]
                imageView.image = UIImage.imageWithName(detailModel.thirdSelectedImage)
            }
            self.registModel.babySex = "\(indexPath.item + 1)"
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if collectionView == self.statusCollectionView {
            if let view = cell?.contentView.viewWithTag(StatusImageViewStartIndex + indexPath.item) {
                let imageView = view as! UIImageView
                let detailModel = self.statusModel.loginThird[indexPath.item]
                imageView.image = UIImage.imageWithName(detailModel.thirdNormalImage)
            }
        }else if collectionView == self.sexCollectionView{
            if let view = cell?.contentView.viewWithTag(SexImageViewStartIndex + indexPath.item) {
                let imageView = view as! UIImageView
                let detailModel = self.sexModel.loginThird[indexPath.item]
                imageView.image = UIImage.imageWithName(detailModel.thirdNormalImage)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 30)
    }
    
    private func refreshCell(view: UICollectionView,cell:UICollectionViewCell, indexPath:NSIndexPath, model:ThirdLoginDetail){
        
        if view == self.statusCollectionView {
            let imageView = UIImageView.init(frame: CGRect(x: (cell.contentView.width - cell.frame.height * (2 / 3)) / 2, y: 5, width: cell.frame.height * (2 / 3), height: cell.frame.height * (2 / 3)))
            imageView.tag = StatusImageViewStartIndex + indexPath.item
            imageView.image = UIImage.imageWithName(model.thirdNormalImage)
            cell.contentView.addSubview(imageView)
            
            let itemLabel = UILabel.init(frame: CGRect(x: 0, y: cell.frame.height * (2 / 3), width: cell.contentView.frame.width, height: cell.frame.height * (1 / 3)))
            itemLabel.font = UIFont.systemFontOfSize(10)
            itemLabel.text = model.thirdName
            itemLabel.tag = StatusItemLabelStartIndex + indexPath.item
            itemLabel.textColor = UIColor.whiteColor()
            itemLabel.adjustsFontSizeToFitWidth = true
            itemLabel.textAlignment = .Center
            cell.contentView.addSubview(itemLabel)
        }else{
            let imageView = UIImageView.init(frame: CGRect(x: (cell.contentView.width - cell.frame.height * (2 / 3)) / 2, y: 5, width: cell.frame.height * (2 / 3), height: cell.frame.height * (2 / 3)))
            imageView.tag = SexImageViewStartIndex + indexPath.item
            imageView.image = UIImage.imageWithName(model.thirdNormalImage)
            cell.contentView.addSubview(imageView)
            
            let itemLabel = UILabel.init(frame: CGRect(x: 0, y: cell.frame.height * (2 / 3), width: cell.contentView.frame.width, height: cell.frame.height * (1 / 3)))
            itemLabel.font = UIFont.systemFontOfSize(10)
            itemLabel.text = model.thirdName
            itemLabel.tag = SexItemLabelStartIndex + indexPath.item
            itemLabel.textColor = UIColor.whiteColor()
            itemLabel.adjustsFontSizeToFitWidth = true
            itemLabel.textAlignment = .Center
            cell.contentView.addSubview(itemLabel)
        }
        
        
    }
    
    private func dateButton(frame:CGRect, title:String,view:UIView,dateItem:String) ->DateButton{
        let baseView = UIView.init(frame: frame)
        self.addSubview(baseView)
        
        let btn = DateButton(type: .Custom)
        btn.frame = CGRect(x: 0, y: 0, width: baseView.frame.size.width, height: baseView.frame.size.height / 2)
        btn.setImageRect(CGSize(width: 4, height: 5), normaImage: "down_triangle.png", normalTitle: title, fontSize: 15)
        btn.setCustomTitleColor(UIColor.whiteColor())
        btn.addCustomTarget(self, sel: #selector(LoginBaseInfoView.datePickerClick))
        baseView.addSubview(btn)
        
        
        
        let dateItemLabel = UILabel.init(frame: CGRect(x: 0, y: baseView.frame.height / 2, width: baseView.frame.width, height: baseView.frame.height / 2))
        dateItemLabel.text = dateItem
        dateItemLabel.textAlignment = .Center
        dateItemLabel.textColor = UIColor.whiteColor()
        dateItemLabel.font = UIFont.systemFontOfSize(10)
        baseView.addSubview(dateItemLabel)
        
        let line = UIView.init(frame: CGRect(x: 0, y: baseView.frame.height / 2, width: baseView.frame.width, height: 0.8))
        line.backgroundColor = UIColor.whiteColor()
        line.alpha = 0.5
        baseView.addSubview(line)
        
        return btn
    }
    
    func datePickerClick() -> Void {
        if let pickerView = NSBundle.mainBundle().loadNibNamed("PickerControllView", owner: self, options: nil)?.last {
            self.datePicker = pickerView as! PickerControllView
            self.datePicker.pickerDelegate = self
            self.addSubview(self.datePicker)
        }
    }
    
    func datePickerRemove() {
        self.datePicker.removeFromSuperview()
    }
    
    func datePickerReturn(dateString: String!) {
        self.registModel.breedStatusDate = dateString
        let dates = dateString.componentsSeparatedByString("-")
        self.yearButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.monthButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.dayButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        switch dates.count {
        case 1:
            self.yearButton.setTitle(dates[0], forState: .Normal)
        case 2:
            self.yearButton.setTitle(dates[0], forState: .Normal)
            self.monthButton.setTitle(dates[1], forState: .Normal)
        case 3:
            self.yearButton.setTitle(dates[0], forState: .Normal)
            self.monthButton.setTitle(dates[1], forState: .Normal)
            self.dayButton.setTitle(dates[2], forState: .Normal)
        default:
            break
        }
    }
    
    func finishRegisterClick() -> Void {
        if let finish = self.finishHandler {
            finish(model: self.registModel)
        }
    }
    
}

class ThirdHeaderView: UICollectionReusableView {
    var title:String = ""{
        didSet{
            if let view = self.viewWithTag(2) {
                let label = view as! UILabel
                label.text = title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let label = UILabel.init(frame: self.bounds)
        label.textAlignment = .Center
        label.tag = 2
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(13)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



