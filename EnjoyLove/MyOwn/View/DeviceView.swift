//
//  DeviceView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/26.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit


class AddDeviceView: UIView, UITextFieldDelegate{
    private var countDown:CountDownButton!
    private var keyboard:Keyboard!
    private var phoneTF:UITextField!
    private var codeTF:UITextField!
    private var countryCode:String!
    private var isRegisted:Bool = false
    private var nextHandler:((isRegisted:Bool, phoneNum:String, validCode:String, countryCode:String)->())?
    init(frame: CGRect, completionHandler:((isRegisted:Bool, phoneNum:String, validCode:String, countryCode:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let firstStepButton = DeviceButton(type: .Custom)
        firstStepButton.frame = CGRect(x: 30, y: 20, width: self.frame.width * (2 / 3), height: 50)
        firstStepButton.setImageSize(CGSize(width: 15,height: 15), titleS:CGSize(width: firstStepButton.frame.width, height: firstStepButton.frame.height), normaImage: "One_Number.png", normalTitle: "为了保障您的个人隐私\n请先进行安全验证!", fontSize: 15)
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
        
        self.phoneTF = UITextField.textField(CGRect(x: firstStepButton.frame.minX, y: line.frame.maxY, width: self.frame.width - 50, height: 40), title: nil, holder: nil, clear: true)
        self.phoneTF.delegate = self
        self.phoneTF.userInteractionEnabled = false
        if let userName = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.UserPhoneKey) as? String {
            self.phoneTF.text = userName
        }
        self.phoneTF.textColor = UIColor.darkGrayColor()
        self.addSubview(self.phoneTF)
        
        line = UIView.init(frame: CGRect(x: 0, y: self.phoneTF.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f7f1f2")
        self.addSubview(line)
        
        self.countryCode = "86"
        let language = NSLocale.preferredLanguages()[0]
        if language.hasPrefix("zh") {
            self.countryCode = "86"
        }else{
            self.countryCode = "1"
        }
        
        self.countDown = CountDownButton(type: .Custom)
        self.countDown.backgroundColor = UIColor.hexStringToColor("#b85562")
        self.countDown.setupBase(CGRect(x: 0, y: 0, width: 80, height: 20), completionHandler: {[weak self] in
            if let weakSelf = self{
                weakSelf.phoneTF.resignFirstResponder()
                weakSelf.codeTF.resignFirstResponder()
                HUD.showHud("正在发送", onView: weakSelf)
                NetManager.sharedManager().getPhoneCodeWithPhone(weakSelf.phoneTF.text, countryCode: weakSelf.countryCode, callBack: { [weak self](errorNumber) in
                    if let weakSelf = self{
                        HUD.hideHud(weakSelf)
                        if let num = errorNumber as? NSNumber{
                            let errorCode = num.intValue
                            switch errorCode {
                            case NET_RET_GET_PHONE_CODE_SUCCESS:
                                HUD.showText("验证码已发送，请及时查收", onView: weakSelf)
                            case NET_RET_GET_PHONE_CODE_PHONE_USED:
                                HUD.showText("该手机号已注册，点击下一步", onView: weakSelf)
                                weakSelf.isRegisted = true
                            case NET_RET_GET_PHONE_CODE_FORMAT_ERROR:
                                HUD.showText("手机号码格式错误", onView: weakSelf)
                            case NET_RET_GET_PHONE_CODE_TOO_TIMES:
                                HUD.showText("获取手机验证码太频繁，请稍后再试", onView: weakSelf)
                            case NET_RET_SYSTEM_MAINTENANCE_ERROR:
                                HUD.showText("系统正在维护，请稍后再试", onView: weakSelf)
                            default:
                                HUD.showText("发生错误: \(errorCode)", onView: weakSelf)
                            }
                        }
                    }
                })
            }
            })
        
        self.codeTF = UITextField.textField(CGRect(x: self.phoneTF.frame.minX, y: self.phoneTF.frame.maxY, width: self.phoneTF.frame.width, height: self.phoneTF.frame.height), title: nil, holder: "请输入手机验证码", left: false, right: true, rightView: countDown)
        self.codeTF.delegate = self
        self.codeTF.textColor = UIColor.whiteColor()
        self.addSubview(self.codeTF)
        
        self.keyboard = Keyboard.init(targetView: self.codeTF, container: self, hasNav: true, show: nil, hide: nil)
        
        line = UIView.init(frame: CGRect(x: 0, y: self.codeTF.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f7f1f2")
        self.addSubview(line)
        
        let loginButton = UIButton.init(type: .Custom)
        loginButton.frame = CGRect(x: 20, y: self.frame.height  - 60, width: self.frame.width - 40, height: 40)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        loginButton.backgroundColor = UIColor.hexStringToColor("#b85562")
        loginButton.setTitle("下一步", forState: .Normal)
        loginButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.addTarget(self, action: #selector(self.nextStepClick), forControlEvents: .TouchUpInside)
        self.addSubview(loginButton)
        
        self.nextHandler = completionHandler
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func nextStepClick() -> Void {
        self.phoneTF.resignFirstResponder()
        self.codeTF.resignFirstResponder()
        if self.isRegisted == false {
            if let phone = self.phoneTF.text {
                if phone == "" {
                    HUD.showText("请输入手机号", onView: self)
                    return
                }
            }
            
            if let code = self.codeTF.text {
                if code == "" {
                    HUD.showText("请输入验证码", onView: self)
                    return
                }
            }
        }
        
        if let handle = self.nextHandler {
            handle(isRegisted: self.isRegisted, phoneNum: self.phoneTF.text!, validCode: self.codeTF.text == nil ? "": self.codeTF.text!, countryCode: self.countryCode)
        }
    }
    
}

private let contactTableViewCellId = "contactTableViewCellId"
class DevicesView: UIView,UITableViewDelegate,UITableViewDataSource {
    private var selectContactHandler:((contact:Contact)->())?
    private var contactArr:[Contact]!
    private var contactTable:UITableView!
    private var contactTableViewRowHeight:CGFloat = 0
    private var selectedIndexPath:NSIndexPath!
    
    init(frame: CGRect, completionHandler:((contact:Contact)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            self.contactArr = contacts
        }
        self.selectedIndexPath = NSIndexPath(forRow: -1, inSection: -1)
        
        let firstStepButton = DeviceButton(type: .Custom)
        firstStepButton.frame = CGRect(x: 30, y: 20, width: self.frame.width * (2 / 3), height: 50)
        firstStepButton.setImageSize(CGSize(width: 15,height: 15), titleS:CGSize(width: firstStepButton.frame.width, height: firstStepButton.frame.height), normaImage: "Three_Number.png", normalTitle: "监测出您附近能连接的设备\n选择您要连接的设备", fontSize: 15)
        firstStepButton.setCustomTitleColor(UIColor.hexStringToColor("#ba5460"))
        firstStepButton.userInteractionEnabled = false
        self.addSubview(firstStepButton)
        
        let phoneImageWidth = self.frame.width * (1 / 4)
        let phoneImageHeight = phoneImageWidth
        let phoneImageView = UIImageView.init(frame: CGRect(x: (self.frame.width - phoneImageWidth) / 2, y: self.frame.height / 2 - phoneImageHeight * (3 / 2), width: phoneImageWidth, height: phoneImageHeight))
        phoneImageView.image = UIImage.imageWithName("myOwnChecked.png")
        self.addSubview(phoneImageView)
        
        let line = UIView.init(frame: CGRect(x: 0, y: self.frame.height / 2, width: self.frame.width, height: 1))
        line.backgroundColor = UIColor.hexStringToColor("#e3e3e5")
        self.addSubview(line)
        
        self.contactTableViewRowHeight = self.frame.height * (1 / 12)
        self.contactTable = UITableView.init(frame: CGRect(x: 0, y: line.frame.maxY, width: self.frame.width, height: 3 * self.contactTableViewRowHeight), style: .Plain)
        self.contactTable.delegate = self
        self.contactTable.dataSource = self
        self.contactTable.separatorInset = UIEdgeInsetsZero
        self.contactTable.layoutMargins = UIEdgeInsetsZero
        self.contactTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: contactTableViewCellId)
        self.addSubview(self.contactTable)
        
        self.selectContactHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contactArr == nil ? 0 : self.contactArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(contactTableViewCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
            resultCell.accessoryType = .None
            resultCell.selectionStyle = .None
            resultCell.textLabel?.text = self.contactArr[indexPath.row].contactName
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == self.selectedIndexPath {
            return
        }
        let everSelectedCell = tableView.cellForRowAtIndexPath(self.selectedIndexPath)
        if let resultCell = everSelectedCell {
            resultCell.accessoryType = .None
        }
        let newSelectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let resultCell = newSelectedCell {
            resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
            resultCell.accessoryType = .Checkmark
            if let handle = self.selectContactHandler {
                handle(contact: self.contactArr[indexPath.row])
            }
        }
        self.selectedIndexPath = indexPath
    }
}

class DeviceListView: UIView,UITableViewDelegate,UITableViewDataSource {
    private var listData:[Contact]!
    private var listTable:UITableView!
    private var listTableViewRowHeight:CGFloat = 0
    private var deviceHandler:((on:HMSwitch, device:Contact)->())?
    private var selectHandler:((device:Contact)->())?
    private var onOffData:[NSIndexPath:HMSwitch]!
    private var addNewDevice:UIButton!
    private var addNewHandler:(()->())?
    
    init(frame: CGRect, contacts:[Contact], exchageHandler:((onSwitch:HMSwitch, device:Contact)->())?, enterHandler:((device:Contact)->())?, addNewDeviceHandler:(()->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.listTableViewRowHeight = frame.height * (1 / 11)
        self.listData = contacts
        for contact in contacts {
            contact.isGettingOnLineState = true
        }
        
        self.onOffData = [:]
        
        self.listTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height - 60), style: .Plain)
        self.listTable.rowHeight = self.listTableViewRowHeight
        self.listTable.dataSource = self
        self.listTable.delegate = self
        self.listTable.separatorInset = UIEdgeInsetsZero
        self.listTable.layoutMargins = UIEdgeInsetsZero
        self.addSubview(self.listTable)
        
        self.addNewDevice = UIButton.init(frame: CGRect(x: 10, y: self.frame.height - 60, width: self.frame.width - 20, height: 35))
        self.addNewDevice.layer.cornerRadius = self.addNewDevice.frame.height / 2 - 3
        self.addNewDevice.layer.masksToBounds = true
        self.addNewDevice.backgroundColor = UIColor.hexStringToColor("#bb5360")
        self.addNewDevice.setTitle("添加新的设备", forState: .Normal)
        self.addNewDevice.addTarget(self, action: #selector(self.addNewDeviceClick), forControlEvents: .TouchUpInside)
        self.addSubview(self.addNewDevice)
        
        self.deviceHandler = exchageHandler
        self.addNewHandler = addNewDeviceHandler
        self.selectHandler = enterHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.listData == nil ? 0 : self.listData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cellId = "deviceListTableViewCellId"
//        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
//        if cell == nil {
//            cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellId)
//        }
//        if let resultCell = cell {
//            for subview in resultCell.contentView.subviews {
//                subview.removeFromSuperview()
//            }
//            resultCell.separatorInset = UIEdgeInsetsZero
//            resultCell.layoutMargins = UIEdgeInsetsZero
//            resultCell.selectionStyle = .None
//            
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(DevicesListCell)) as? DevicesListCell
        if let resultCell = cell {
            let contact = self.listData[indexPath.row]
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            resultCell.refreshCell(contact, completionHandler: { [weak self](onOff, editModel) in
                if let weakSelf = self{
                    weakSelf.onOffData[indexPath] = onOff
                    if let handle = weakSelf.deviceHandler{
                        handle(on: onOff, device: editModel)
                    }
                }
            })
            if contact.onLineState == Int(STATE_ONLINE) && contact.contactType == Int(CONTACT_TYPE_DOORBELL) {
                
            }
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let onSwitch = self.onOffData[indexPath] {
            if onSwitch.on == true {
                if let handler = self.selectHandler {
                    handler(device: self.listData[indexPath.row])
                }
            }else{
                HUD.showText("请先连接设备", onView: self)
            }
        }
    }
    
    func addNewDeviceClick() -> Void {
        if let handle = self.addNewHandler {
            handle()
        }
    }
    
    private func willBindUserIDByContactWithContactId(contactId: String, contactPassword:String){
        let loginResult = UDManager.getLoginInfo()
        let key = "KEY\(loginResult.contactId)_\(contactId)"
        let isDeviceBindedUserID = NSUserDefaults.standardUserDefaults().boolForKey(key)
        if isDeviceBindedUserID == true {
            return
        }
        P2PClient.sharedClient().getBindAccountWithId(contactId, password: contactPassword)
        
    }
    
}



class DevicesListCell: UITableViewCell {
    
    private var onOffHandler:((onOff:HMSwitch, editModel:Contact)->())?
    private var device:Contact!
    private var devicesListSwitchHeight:CGFloat = 0
    private var devicesListSwitchWidth:CGFloat = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:Contact, completionHandler:((onOff:HMSwitch, editModel:Contact)->())?) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 2 * self.contentView.frame.minX, height: self.contentView.frame.height)
        self.devicesListSwitchHeight = self.contentView.frame.height * (2 / 3)
        self.devicesListSwitchWidth = self.devicesListSwitchHeight * 2
        
        let itemLabel = UILabel.init(frame: CGRect(x: 10, y: 0, width: self.contentView.frame.width / 2 - 10, height: self.contentView.frame.height))
        itemLabel.text = model.contactName
        itemLabel.adjustsFontSizeToFitWidth = true
        itemLabel.textColor = UIColor.lightGrayColor()
        itemLabel.font = UIFont.systemFontOfSize(15)
        self.contentView.addSubview(itemLabel)
        
        let onSwitch = HMSwitch.init(frame: CGRect(x: self.contentView.frame.width - devicesListSwitchWidth - 30, y: (self.contentView.frame.height - devicesListSwitchHeight) / 2, width: devicesListSwitchWidth, height: devicesListSwitchHeight))
        onSwitch.on = true
        onSwitch.onLabel.text = "连接"
        onSwitch.offLabel.text = "解除"
        onSwitch.onLabel.textColor = UIColor.whiteColor()
        onSwitch.offLabel.textColor = UIColor.whiteColor()
        onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
        onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
        onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
        onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
        onSwitch.inactiveColor = UIColor.lightGrayColor()
        onSwitch.addTarget(self, action: #selector(self.onSwichtOnOff(_:)), forControlEvents: .ValueChanged)
        self.contentView.addSubview(onSwitch)
        
        self.device = model
        self.onOffHandler = completionHandler
        if let handle = completionHandler {
            handle(onOff: onSwitch, editModel: model)
        }
    }
    
    func onSwichtOnOff(onSwicth:HMSwitch) -> Void {
        if let onOff = self.onOffHandler {
            onOff(onOff: onSwicth, editModel: self.device)
        }
    }
}
