//
//  SecurityView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/20.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
private let securityTableViewCellId = "securityTableViewCellId"

class SecurityView: UIView ,UITableViewDataSource, UITableViewDelegate{

    private var securityTable:UITableView!
    private var securityHandler:((model:Security,indexPath:NSIndexPath)->())?
    private var models:[Security]!
    init(frame: CGRect, data:[Security], completionHandler:((model:Security,indexPath:NSIndexPath)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.models = data
        self.securityTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat(data.count) * 44), style: .Plain)
        self.securityTable.scrollEnabled = false
        self.securityTable.layoutMargins = UIEdgeInsetsZero
        self.securityTable.separatorInset = UIEdgeInsetsZero
        self.securityTable.dataSource = self
        self.securityTable.delegate = self
        self.securityTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: securityTableViewCellId)
        self.addSubview(self.securityTable)
        self.securityHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(securityTableViewCellId)
        if let resultCell = cell {
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            let model = self.models[indexPath.row]
            resultCell.textLabel?.text = model.mainItem
            resultCell.textLabel?.textColor = UIColor.hexStringToColor("#60555b")
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.models[indexPath.row]
        if let handle = self.securityHandler {
            handle(model: model, indexPath: indexPath)
        }
    }

}

class SecurityCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:Security) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 20, height: self.contentView.frame.height)
        
        let mainLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: self.contentView.frame.width * (1 / 4), height: self.contentView.frame.height))
        mainLabel.text = model.mainItem
        mainLabel.textColor = UIColor.hexStringToColor("#5f545a")
        mainLabel.font = UIFont.systemFontOfSize(14)
        self.contentView.addSubview(mainLabel)
        
        let subLabel = UILabel.init(frame: CGRect(x: self.contentView.frame.width * (1 / 2), y: 0, width: self.contentView.frame.width * (1 / 2) - 30, height: self.contentView.frame.height))
        subLabel.text = model.subItem
        subLabel.textAlignment = .Right
        subLabel.textColor = UIColor.lightGrayColor()
        subLabel.font =  UIFont.systemFontOfSize(12)
        self.contentView.addSubview(subLabel)
        
    }
}

class BandingPhoneView: UIView,UITextFieldDelegate {
    
    private var phoneModel:BandingPhone!
    private var phoneTF:UITextField!
    private var codeTF:UITextField!
    private var countDown:CountDownButton!
    private var addressBookHandler:(()->())?
    init(frame: CGRect, model:BandingPhone, addresBookCompletionHandler:(()->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.phoneModel = model
        let phoneImageViewWith = frame.width * (1 / 7)
        let phoneImageViewHeight = frame.height * (1 / 4) * (2 / 3)
        if model.status == true {
            let phoneImageView = UIImageView.init(frame: CGRect(x: (frame.width - phoneImageViewWith) / 2 + 5, y: (frame.height * (1 / 4) - phoneImageViewHeight) / 2, width: phoneImageViewWith, height: phoneImageViewHeight))
            phoneImageView.image = UIImage.imageWithName("myOwnPhone.png")
            self.addSubview(phoneImageView)
            
            var line = UIView.init(frame: CGRect(x: 0, y: phoneImageView.frame.midY + phoneImageView.frame.height, width: self.frame.width, height: 1))
            line.backgroundColor = UIColor.hexStringToColor("#f8f4f4")
            self.addSubview(line)
            
            let rightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            rightLabel.font = UIFont.systemFontOfSize(10)
            rightLabel.text = "已绑定"
            rightLabel.textAlignment = .Center
            rightLabel.textColor = UIColor.lightGrayColor()
            
            self.phoneTF = UITextField.textField(CGRect(x: 20, y: line.frame.maxY, width: self.frame.width - 30, height: 40), title: "手机号", titleColor: UIColor.blackColor(), seperatorColor: UIColor.clearColor(), holder: model.phoneNum, left: true, right: true, rightView: rightLabel)
            self.phoneTF.userInteractionEnabled = false
            self.addSubview(self.phoneTF)
            
            line = UIView.init(frame: CGRect(x: 0, y: self.phoneTF.frame.maxY, width: self.frame.width, height: 1))
            line.backgroundColor = UIColor.hexStringToColor("#f8f4f4")
            self.addSubview(line)
            
            let addressBookButton = UIButton.init(frame: CGRect(x: 20, y: self.phoneTF.frame.maxY + 40, width: self.frame.width - 40, height: 40))
            addressBookButton.layer.cornerRadius = 20
            addressBookButton.layer.masksToBounds = true
            addressBookButton.backgroundColor = UIColor.hexStringToColor("#b95360")
            addressBookButton.setTitle("查看通讯录", forState: .Normal)
            addressBookButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            addressBookButton.addTarget(self, action: #selector(BandingPhoneView.checkAddressBookClick), forControlEvents: .TouchUpInside)
            self.addSubview(addressBookButton)
            
            self.addressBookHandler = addresBookCompletionHandler
            
        }else{
            self.phoneTF = UITextField.textField(CGRect(x: 20, y: 0, width: self.frame.width - 30, height: 40), title: nil, seperatorColor: UIColor.clearColor(), holder: "请输入手机号", clear: true)
            self.phoneTF.delegate = self
            self.addSubview(self.phoneTF)
            
            var line = UIView.init(frame: CGRect(x: 0, y: self.phoneTF.frame.maxY, width: self.frame.width, height: 1))
            line.backgroundColor = UIColor.hexStringToColor("#f8f4f4")
            self.addSubview(line)
            
            self.countDown = CountDownButton(type: .Custom)
            self.countDown.backgroundColor = UIColor.hexStringToColor("#d26465")
            self.countDown.setupBase(CGRect(x: 0, y: 0, width: 80, height: 20), completionHandler: {[weak self] in
                if let weakSelf = self{
                    weakSelf.phoneTF.resignFirstResponder()
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
            
            self.codeTF = UITextField.textField(CGRect(x: self.phoneTF.frame.minX, y: line.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: nil, seperatorColor: UIColor.hexStringToColor("#f6f0f1"), holder: "请输入验证码", left: false, right: true, rightView: self.countDown)
            self.codeTF.delegate = self
            self.addSubview(self.codeTF)
            
            line = UIView.init(frame: CGRect(x: 0, y: self.codeTF.frame.maxY, width: self.frame.width, height: 1))
            line.backgroundColor = UIColor.hexStringToColor("#f8f4f4")
            self.addSubview(line)
            
            let tipLabel = UILabel.init(frame: CGRect(x: 0, y: line.frame.maxY + 20, width: self.frame.width, height: self.phoneTF.frame.height))
            tipLabel.font = UIFont.systemFontOfSize(13)
            tipLabel.text = "绑定手机后，下次登录可直接使用手机号登录"
            tipLabel.textAlignment = .Center
            tipLabel.textColor = UIColor.lightGrayColor()
            self.addSubview(tipLabel)
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func fetchPhoneNumerShow(phoneNum:String) -> Void {
        if let phoneTextField = self.phoneTF {
            phoneTextField.text = phoneNum
        }
    }
    
    func fetchBandingPhone() -> Void {
        BandingPhone.bandingPhone(true)
    }
    
    func fetchUnBandingPhone() -> Void {
        BandingPhone.bandingPhone(false)
    }
    
    func checkAddressBookClick() -> Void {
        if let handle = self.addressBookHandler {
            handle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BandingWeChatView: UIView {
    private var wechatTF:UITextField!
    private var countDown:CountDownButton!
    
    init(frame: CGRect,model:BandingWeChat) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let phoneImageViewWith = frame.width * (1 / 6)
        let phoneImageViewHeight = frame.height * (1 / 4) * (1 / 2)
        if model.status == false {
            let phoneImageView = UIImageView.init(frame: CGRect(x: (frame.width - phoneImageViewWith) / 2 + 5, y: (frame.height * (1 / 4) - phoneImageViewHeight) / 2, width: phoneImageViewWith, height: phoneImageViewHeight))
            phoneImageView.image = UIImage.imageWithName("myOwnWeChat.png")
            self.addSubview(phoneImageView)
            
            var line = UIView.init(frame: CGRect(x: 0, y: phoneImageView.frame.midY + phoneImageView.frame.height, width: self.frame.width, height: 1))
            line.backgroundColor = UIColor.hexStringToColor("#f8f4f4")
            self.addSubview(line)
            
            let rightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
            rightLabel.font = UIFont.systemFontOfSize(10)
            rightLabel.text = "已绑定"
            rightLabel.textAlignment = .Center
            rightLabel.textColor = UIColor.lightGrayColor()
            
            self.wechatTF = UITextField.textField(CGRect(x: 20, y: line.frame.maxY, width: self.frame.width - 30, height: 40), title: "微信号", titleColor: UIColor.blackColor(), seperatorColor: UIColor.clearColor(), holder: model.wechatNum, left: true, right: true, rightView: rightLabel)
            self.wechatTF.userInteractionEnabled = false
            self.addSubview(self.wechatTF)
            
            line = UIView.init(frame: CGRect(x: 0, y: self.wechatTF.frame.maxY, width: self.frame.width, height: 1))
            line.backgroundColor = UIColor.hexStringToColor("#f8f4f4")
            self.addSubview(line)

            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ModifyPasswordView: UIView ,UITextFieldDelegate{
    
    private var newPswTF:UITextField!
    private var confirmTF:UITextField!
    private var isRealModify:Bool = false

    init(frame: CGRect, cancelHandler:((modify:Bool)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        let alertController = UIAlertController.init(title: "验证原密码", message: "为保障你的数据安全，修改密码前请填写原密码", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.secureTextEntry = true
        }
        let cancelAction = UIAlertAction.init(title: "取消", style: .Default) { (action) in
            if let handle = cancelHandler {
                handle(modify: false)
            }
        }
        alertController.addAction(cancelAction)
        
        let confirmAction = UIAlertAction.init(title: "确认", style: .Default) { (action) in
            
            if let passwordTF = alertController.textFields?.last{
                if passwordTF.text == "" {
                    let alertController1 = UIAlertController.init(title: "密码不能为空", message: nil, preferredStyle: .Alert)
                    let sureAction = UIAlertAction.init(title: "确定", style: .Cancel, handler: { (action) in
                        HMTablBarController.presentViewController(alertController, animated: true, completion: nil)
                    })
                    alertController1.addAction(sureAction)
                    HMTablBarController.presentViewController(alertController1, animated: true, completion: nil)
                }else{
                    if let phone = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String{
                        if let info = LoginBL.find(phone){
                            if let password = info.md5Password, let psdText = passwordTF.text{
                                if psdText.md5 != password{
                                    passwordTF.text = ""
                                    HMTablBarController.presentViewController(alertController, animated: true, completion: nil)
                                }
                            }
                        }
                    }
                }
                
            }
        }
        alertController.addAction(confirmAction)
        HMTablBarController.presentViewController(alertController, animated: true, completion: nil)
        
        
        self.newPswTF = UITextField.textField(CGRect(x: 10, y: 0, width: self.frame.width - 20, height: 40), title: "  新密码:", titleColor: UIColor.darkGrayColor(), seperatorColor: UIColor.hexStringToColor("#f6f0f1"), holder: "请输入新密码", clear: true)
        self.newPswTF.delegate = self
        self.newPswTF.secureTextEntry = true
        self.addSubview(self.newPswTF)
        
        self.confirmTF = UITextField.textField(CGRect(x: 10, y: newPswTF.frame.maxY, width: self.newPswTF.frame.width, height: self.newPswTF.frame.height), title: "  确认密码:", titleColor: UIColor.darkGrayColor(), seperatorColor: UIColor.hexStringToColor("#f6f0f1"), holder: "请输入确认密码", clear: true)
        self.confirmTF.delegate = self
        self.confirmTF.secureTextEntry = true
        self.addSubview(self.confirmTF)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func confirmModify(completionHandler:((modify:Bool)->())?) -> Void {
        if let newText = self.newPswTF.text, let confirmText = self.confirmTF.text {
            if newText == "" {
                HUD.showText("请输入新密码", onView: self)
                return
            }
            if confirmText == "" {
                HUD.showText("请输入确认密码", onView: self)
                return
            }
            
            if newText != confirmText {
                HUD.showText("新密码与确认密码不一致", onView: self)
                return
            }
            
            if let phone = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String{
                if let login = LoginBL.find(phone) {
                    HUD.showHud("正在发送...", onView: self)
                    ModifyPassword.sendAsyncChangePassword(login.md5Password == nil ? "" : login.md5Password, newUserPwd: newText, completionHandler: { [weak self](pwd) in
                        if let weakSelf = self{
                            if let password = pwd{
                                if password.errorCode == BabyZoneConfig.shared.passCode{
                                    if let loginResult = UDManager.getLoginInfo(){
                                        NetManager.sharedManager().modifyLoginPasswordWithUserName(loginResult.contactId, sessionId: loginResult.sessionId, oldPwd: login.password == nil ? "" : login.password, newPwd: newText, rePwd: confirmText, callBack: { (JSON) in
                                            HUD.hideHud(weakSelf)
                                            if let modifyLoginPasswordResult = JSON as? ModifyLoginPasswordResult{
                                                switch modifyLoginPasswordResult.error_code{
                                                case NET_RET_MODIFY_LOGIN_PASSWORD_SUCCESS:
                                                    HUD.showText("修改密码成功，请重新登陆", onView: weakSelf)
                                                    UDManager.setIsLogin(false)
                                                    GlobalThread.sharedThread(false).kill()
                                                    if let manager = FListManager.sharedFList() as? FListManager{
                                                        manager.isReloadData = true
                                                    }
                                                    UIApplication.sharedApplication().unregisterForRemoteNotifications()
                                                    
                                                    LoginBL.clear(phone)
                                                    if let handle = completionHandler{
                                                        handle(modify: true)
                                                    }
                                                    AppDelegate.sharedDefault().reRegisterForRemoteNotifications()
                                                    let queue = dispatch_queue_create(nil, nil)
                                                    dispatch_async(queue, {
                                                        P2PClient.sharedClient().p2pDisconnect()
                                                    })
                                                    
                                                case NET_RET_MODIFY_LOGIN_PASSWORD_NOT_MATCH:
                                                    HUD.showText("两次输入的密码不一致", onView: weakSelf)
                                                case NET_RET_MODIFY_LOGIN_PASSWORD_ORIGINAL_PASSWORD_ERROR:
                                                    HUD.showText("原始密码错误", onView: weakSelf)
                                                case NET_RET_SYSTEM_MAINTENANCE_ERROR:
                                                    HUD.showText("系统正在维护，请稍后再试", onView: weakSelf)
                                                default:
                                                    HUD.showText("发生错误:\(modifyLoginPasswordResult.error_code)", onView: weakSelf)
                                                }
                                            }
                                        })
                                    }
                                }else{
                                    HUD.hideHud(weakSelf)
                                    HUD.showText("修改密码失败:\(password.errorCode)\(password.msg)", onView: weakSelf)
                                }
                            }else{
                                HUD.hideHud(weakSelf)
                                HUD.showText("网络异常", onView: weakSelf)
                            }
                        }
                        })
                    
                }
            }
        }
    }
}

class PrivacyView: UIView, UITableViewDelegate,UITableViewDataSource {
    private var privacyData:[Privacy]!
    private var privacyTable:UITableView!
    private var permission:[CheckPermission]!
    init(frame: CGRect, data:[Privacy]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.privacyData = data
        self.permission = []
        var model = CheckPermission(item: "所有人", itemId: "2")
        self.permission.append(model)
        model = CheckPermission(item: "好友", itemId: "1")
        self.permission.append(model)
        model = CheckPermission(item: "设为个人私密", itemId: "0")
        self.permission.append(model)
        
        var rowHeight:CGFloat = 0
        for i in 0 ..< data.count {
            for j in 0 ..< data[i].detail.count {
                rowHeight += CGFloat(data.count * j) * 44
            }
        }
        self.privacyTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: frame.width, height: rowHeight + 60), style: .Grouped)
        self.privacyTable.scrollEnabled = false
        self.privacyTable.layoutMargins = UIEdgeInsetsZero
        self.privacyTable.separatorInset = UIEdgeInsetsZero
        self.privacyTable.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        self.privacyTable.dataSource = self
        self.privacyTable.delegate = self
        self.privacyTable.registerClass(PrivacyCell.self, forCellReuseIdentifier: NSStringFromClass(PrivacyCell))
        self.addSubview(self.privacyTable)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.privacyData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.privacyData[section].detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(PrivacyCell)) as? PrivacyCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            let model = self.privacyData[indexPath.section].detail[indexPath.row]
            if model.subItem.characters.count > 1 {
                resultCell.accessoryType = .DisclosureIndicator
            }else{
                resultCell.selectionStyle = .None
            }
            resultCell.refreshCell(model)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.hexStringToColor("#60555b")
        let headLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 40, height: headerView.frame.height))
        let model = self.privacyData[section]
        headLabel.text = model.title
        headLabel.textColor = UIColor.whiteColor()
        headLabel.font = UIFont.systemFontOfSize(upRateWidth(14))
        headerView.addSubview(headLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
            for permiss in self.permission {
                let actionSheet = UIAlertAction.init(title: permiss.item, style: .Default, handler: { (action:UIAlertAction) in
                    var model = self.privacyData[indexPath.section].detail[indexPath.row]
                    model.subItem = permiss.item
                    self.privacyData[indexPath.section].detail[indexPath.row]  = model
                    self.privacyTable.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                })
                if actionSheet.valueForKey("titleTextColor") == nil{
                    actionSheet.setValue(alertTextColor, forKey: "titleTextColor")
                }
                alertController.addAction(actionSheet)
            }
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (action) in
                
            })
            if cancelAction.valueForKey("titleTextColor") == nil{
                cancelAction.setValue(UIColor.darkGrayColor(), forKey: "titleTextColor")
            }
            alertController.addAction(cancelAction)
            HMTablBarController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}

private let PrivacySwitchWidth:CGFloat = 50
private let PrivacySwitchHeight:CGFloat = 20
class PrivacyCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:PrivacyDetail) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 20, height: self.contentView.frame.height)
        let mainLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: self.contentView.frame.width  * (2 / 3), height: self.contentView.frame.height))
        mainLabel.font = UIFont.systemFontOfSize(14)
        mainLabel.text = model.mainItem
        mainLabel.textColor = UIColor.hexStringToColor("#60555b")
        self.contentView.addSubview(mainLabel)
        
        if model.subItem.characters.count > 1 {
            let subLabel = UILabel.init(frame: CGRect(x: self.contentView.frame.width * (2 / 3), y: 0, width: self.contentView.frame.width * (1 / 3) - 30, height: self.contentView.frame.height))
            subLabel.font = UIFont.systemFontOfSize(11)
            subLabel.textColor = UIColor.lightGrayColor()
            subLabel.textAlignment = .Right
            subLabel.text = model.subItem
            self.contentView.addSubview(subLabel)
        }else{
            let onSwitch = HMSwitch.init(frame: CGRect(x: self.contentView.frame.width - PrivacySwitchWidth - 15, y: (self.contentView.frame.height - PrivacySwitchHeight) / 2, width: PrivacySwitchWidth, height: PrivacySwitchHeight))
            onSwitch.on = model.subItem == "0" ? false : true
            onSwitch.onLabel.text = "打开"
            onSwitch.offLabel.text = "关闭"
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            self.contentView.addSubview(onSwitch)
        }
        
    }
}

class AddressBookTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:HMPersonModel, isAdd:Bool = false, addCompletionHandler:((model:HMPersonModel)->())?) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 20, height: self.contentView.frame.height)
        self.textLabel?.text = model.name
    }
}
