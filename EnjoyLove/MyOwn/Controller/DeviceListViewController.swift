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

    private var devicesListView:DeviceListView!
    private var deviceListTable:UITableView!
    private var contacts:[Contact]!
    private var selectedContact:Contact!
    
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
        
        self.contacts = self.contactData
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
            for contact in self.contacts{
                contactIds.append(contact.contactId)
                P2PClient.sharedClient().checkDeviceUpdateWithId(contact.contactId, password: contact.contactPassword)
            }
            P2PClient.sharedClient().getContactsStates(contactIds)
            FListManager.sharedFList().getDefenceStates()
            NSNotificationCenter.defaultCenter().postNotificationName("refreshLocalDevices", object: nil)
        }
        backgroudView.addSubview(self.deviceListTable)
        
        let addNewDevice = UIButton.init(frame: CGRect(x: 10, y: backgroudView.frame.height - 50, width: backgroudView.frame.width - 20, height: 40))
        addNewDevice.layer.cornerRadius = addNewDevice.frame.height / 2 - 3
        addNewDevice.layer.masksToBounds = true
        addNewDevice.backgroundColor = UIColor.hexStringToColor("#bb5360")
        addNewDevice.setTitle("添加新的设备", forState: .Normal)
        addNewDevice.addTarget(self, action: #selector(self.addNewDeviceClick), forControlEvents: .TouchUpInside)
        backgroudView.addSubview(addNewDevice)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
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
            let contact = self.contacts[indexPath.row]
            resultCell.textLabel?.font = UIFont.systemFontOfSize(15)
            resultCell.textLabel?.text = contact.contactName
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: resultCell.contentView.frame.width - 60 - 30, y: (resultCell.contentView.frame.height - resultCell.contentView.frame.height * (2 / 3)) / 2, width: 60, height: resultCell.contentView.frame.height * (2 / 3)))
            onSwitch.on = false
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
            
            
            if contact.onLineState == Int(STATE_ONLINE) && contact.contactType == Int(CONTACT_TYPE_DOORBELL) {
                self.willBindUserIDByContactWithContactId(contact.contactId, contactPassword: contact.contactPassword)
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let contact = self.contacts[indexPath.row]
            if let aView = cell.viewWithTag(deviceListSwitchTag + indexPath.row) as? HMSwitch{
                if aView.on == true {
                    self.selectedContact = contact
                    let video = BabyVideoViewController()
                    video.deviceContact = contact
                    self.navigationController?.pushViewController(video, animated: true)
                }
            }
        }
    }
    
    
    override func refreshContact() {
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            self.contacts = contacts
            if let table = self.deviceListTable {
                table.reloadData()
            }
        }
    }
    
    override func stopAnimating() {
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            self.contacts = contacts
            if let table = self.deviceListTable {
                table.pullToRefreshView.stopAnimating()
                table.reloadData()
            }
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
