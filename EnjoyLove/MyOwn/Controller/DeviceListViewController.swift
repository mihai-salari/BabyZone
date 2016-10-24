//
//  DeviceListViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/10/9.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let deviceListSwitchTag = 1000
class DeviceListViewController: BaseVideoViewController,UITableViewDelegate,UITableViewDataSource {

    var isDelete:Bool = false
    private var deviceListTable:UITableView!
//    private var contacts:[Contact]!
    private var devices:[Equipments]!
    private var selectedContact:Equipments!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "设备列表", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        self.contacts = self.contactData
        self.devices = []
        if EquipmentsBL.findAll().count > 0 {
            self.devices.appendContentsOf(EquipmentsBL.findAll())
        }
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    private func initialize() ->Void{
        let backgroudView = UIView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight))
        backgroudView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backgroudView)
        
        self.deviceListTable = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: backgroudView.frame.width, height: backgroudView.frame.height - 60), style: .Plain)
        self.deviceListTable.separatorInset = UIEdgeInsetsZero
        self.deviceListTable.layoutMargins = UIEdgeInsetsZero
        self.deviceListTable.delegate = self
        self.deviceListTable.dataSource = self
        self.deviceListTable.tableFooterView = UIView.init()
        self.deviceListTable.addPullToRefreshWithActionHandler { 
            var contactIds:[String] = []
            for contact in self.devices{
                contactIds.append(contact.eqmDid)
                P2PClient.sharedClient().checkDeviceUpdateWithId(contact.eqmDid, password: contact.eqmPwd)
            }
            P2PClient.sharedClient().getContactsStates(contactIds)
            FListManager.sharedFList().getDefenceStates()
            NSNotificationCenter.defaultCenter().postNotificationName("refreshLocalDevices", object: nil)
        }
        backgroudView.addSubview(self.deviceListTable)
        
        if isDelete == false {
            let addNewDevice = UIButton.init(frame: CGRect(x: 10, y: backgroudView.frame.height - 50, width: backgroudView.frame.width - 20, height: 40))
            addNewDevice.layer.cornerRadius = addNewDevice.frame.height / 2 - 3
            addNewDevice.layer.masksToBounds = true
            addNewDevice.backgroundColor = UIColor.hexStringToColor("#bb5360")
            addNewDevice.setTitle("添加新的设备", forState: .Normal)
            addNewDevice.addTarget(self, action: #selector(self.addNewDeviceClick), forControlEvents: .TouchUpInside)
            backgroudView.addSubview(addNewDevice)
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "deviceListTableViewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            for subview in resultCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            let device = self.devices[indexPath.row]
            resultCell.textLabel?.font = UIFont.systemFontOfSize(15)
            resultCell.textLabel?.text = device.eqmName
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: tableView.frame.width - 60 - 10, y: (resultCell.contentView.frame.height - resultCell.contentView.frame.height * (2 / 3)) / 2, width: 60, height: resultCell.contentView.frame.height * (2 / 3)))
            onSwitch.onLabel.text = "连接"
            onSwitch.offLabel.text = "解除"
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.tag = deviceListSwitchTag + indexPath.row
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            onSwitch.addTarget(self, action: #selector(self.onSwichtOnOff(_:)), forControlEvents: .ValueChanged)
            resultCell.contentView.addSubview(onSwitch)
            
            let contact = EquipmentsBL.contactFromEquipment(device)
            if isDelete == true {
                onSwitch.userInteractionEnabled = false
                onSwitch.on = false
            }else{
                onSwitch.on = contact.onLineState == 0 ? false : true
            }
            if contact.onLineState == Int(STATE_ONLINE) && contact.contactType == Int(CONTACT_TYPE_DOORBELL) {
                self.willBindUserIDByContactWithContactId(contact.contactId, contactPassword: contact.contactPassword)
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let contact = self.devices[indexPath.row]
            if let aView = cell.viewWithTag(deviceListSwitchTag + indexPath.row) as? HMSwitch{
                if aView.on == true {
                    self.selectedContact = contact
                    let video = BabyVideoViewController()
                    video.deviceContact = EquipmentsBL.contactFromEquipment(contact)
                    self.navigationController?.pushViewController(video, animated: true)
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if isDelete == true {
            return true
        }
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if isDelete == true {
            dispatch_queue_create("removeDataQueue", nil).queue({ 
                let device = self.devices[indexPath.row]
                Equipments.sendAsyncDeleteEquipment(device.idEqmInfo, eqmUserName: device.eqmName, eqmUserPwd: device.eqmPwd, completionHandler: { [weak self](errorCode, msg) in
                    if let weakSelf = self{
                        if let err = errorCode{
                            if err == BabyZoneConfig.shared.passCode{
                                let contact = EquipmentsBL.contactFromEquipment(device)
                                let loginResult = UDManager.getLoginInfo()
                                let key = "KEY\(loginResult.contactId)_\(contact.contactId)"
                                key.setDefaultsForFlag(false)
                                FListManager.sharedFList().delete(contact)
                                if let index = weakSelf.devices.indexOf(device) {
                                    weakSelf.devices.removeAtIndex(index)
                                }
                                dispatch_get_main_queue().queue({
                                    if let table = weakSelf.deviceListTable{
                                        table.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                                    }
                                })
                            }else{
                                HUD.showText("删除失败\(msg!)", onView: weakSelf.view)
                            }
                        }else{
                            HUD.showText("删除失败\(msg!)", onView: weakSelf.view)
                        }
                    }
                })
            })
        }
    }
    /*
     
     */
    
    override func refreshContact() {
        self.devices = EquipmentsBL.findAll().count > 0 ? EquipmentsBL.findAll() : []
        if let table = self.deviceListTable {
            table.reloadData()
        }
    }
    
    override func stopAnimating() {
        self.devices = EquipmentsBL.findAll().count > 0 ? EquipmentsBL.findAll() : []
        if let table = self.deviceListTable {
            table.pullToRefreshView.stopAnimating()
            table.reloadData()
        }
    }
    
    override func refreshLocalDevices() {
        
    }
    
    override func receiveRemoteMessage(note: NSNotification) {
        if let parameter = note.userInfo {
            if let keyStr = parameter["key"] as? String {
                if let key = Int32(keyStr) {
                    switch key {
                    case RET_DO_DEVICE_UPDATE:
                        if let resultStr = parameter["result"] as? String, let valueStr = parameter["value"] as? String {
                            if let result = Int(resultStr), let value = Int(valueStr) {
                                if result == 1 {
                                    print("value is \(value)")
                                }else if result == 65{
                                    /*
                                    if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
                                        for contact in contacts {
                                            if let selectOne = self.selectedContact {
                                                if selectOne.contactId == contact.contactId {
                                                    contact.isNewVersionDevice = false
                                                }
                                            }
                                        }
                                    }
                                    */
                                }else{
                                    
                                }
                            }
                        }
                    case RET_CHECK_DEVICE_UPDATE:
                        break
                    case RET_GET_BIND_ACCOUNT:
                        if let maxCountStr = parameter["maxCount"] as? String, let datas = parameter["datas"] as? [NSNumber] {
                            var bindIds:[NSNumber] = []
                            bindIds.appendContentsOf(datas)
                            if let maxCount = Int(maxCountStr) {
                                if bindIds.count < maxCount {
                                    let loginResult = UDManager.getLoginInfo()
                                    if bindIds.count > 0 {
                                        if let contactId = Int32(loginResult.contactId) {
                                            if bindIds.contains(NSNumber.init(int: contactId)) {
                                                bindIds.append(NSNumber.init(int: contactId))
                                            }
                                        }
                                    }else{
                                        if let contactId = Int32(loginResult.contactId) {
                                            bindIds.append(NSNumber.init(int: contactId))
                                        }
                                    }
                                }
                                if let contactId = parameter["contactId"] as? String {
                                    let contactDao = ContactDAO()
                                    let contact  = contactDao.isContact(contactId)
                                    let datas = NSMutableArray.init(array: bindIds)
                                    P2PClient.sharedClient().setBindAccountWithId(contactId, password: contact.contactPassword, datas: datas)
                                }
                            }else{
                                if let contactId = parameter["contactId"] as? String {
                                    let loginResult = UDManager.getLoginInfo()
                                    let key = "KEY\(loginResult.contactId)_\(contactId)"
                                    key.setDefaultsForFlag(true)
                                }
                            }
                        }
                    case RET_SET_BIND_ACCOUNT:
                        if let resultStr = parameter["result"] as? String, let contactId = parameter["contactId"] as? String {
                            if let result = Int(resultStr) {
                                if result == 0 {
                                    let loginResult = UDManager.getLoginInfo()
                                    let key = "KEY\(loginResult.contactId)_\(contactId)"
                                    key.setDefaultsForFlag(true)
                                }
                            }
                        }
                    default:
                        break
                    }
                }
            }
        }
    }
    

    //MARK:___事件处理___
    func addNewDeviceClick() -> Void {
        
    }
    
    func onSwichtOnOff(on:HMSwitch) -> Void {
        let index = on.tag - deviceListSwitchTag
        let contact = self.devices[index]
        var eqmId = ""
        
        
        if on.on == true {
//            HUD.showHud("正在修改...", onView: self.view)
//            Equipments.sendAsyncAddEquitment(contact.contactName, eqmType: "1", eqmDid: contact.contactId, eqmAccount: contact.contactId, eqmPwd: contact.contactPassword, eqmStatus: contact.onLineState == 0 ? false : true) { [weak self](errorCode, msg) in
//                if let weakSelf = self{
//                    HUD.hideHud(weakSelf.view)
//                    if let err = errorCode{
//                        if err == BabyZoneConfig.shared.passCode{
//                            
//                        }else{
//                            HUD.showText("修改失败\(msg!)", onView: weakSelf.view)
//                            on.on = !on.on
//                        }
//                    }else{
//                        HUD.showText("修改失败\(msg!)", onView: weakSelf.view)
//                        on.on = !on.on
//                    }
//                }
//            }
        }else{
            
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
