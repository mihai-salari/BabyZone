//
//  MyOwnViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let myOwnCellId = "myOwnCellId"

//private let rowHeight:CGFloat = upRateHeight(32)
let headerRowHeight:CGFloat = upRateHeight(100)
private let headerHeight:CGFloat = upRateHeight(20)


class MyOwnViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    private var myOwnTable:UITableView!
    private var myOwnData:[MyOwn]!
    private var rowHeight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, title: "我的", leftSel: nil, rightSel: nil)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loginAndRegistSuccessRefresh), name: LoginPersonDetailNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshHeader(_:)), name: BabyZoneConfig.shared.CollectionChangeNotification, object: nil)
        
        if  MyHeadGroup.update() == true, let table = self.myOwnTable {
            table.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .None)
            MyHeadGroup.updateInformation(false)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initialize() {
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        
        if self.myOwnData != nil{
            self.myOwnData.removeAll()
            self.myOwnData = nil
        }
        self.myOwnData = []
        
        
        var detailModel = MyOwnDetail()
        var myOwnModel = MyOwn(title: "", myOwnData: [detailModel])
        
        self.myOwnData.append(myOwnModel)
        
        var detailData:[MyOwnDetail] = []
        detailModel = MyOwnDetail()
        detailModel.mainItem = "账号与安全"
        detailModel.subItem = "号码绑定、修改密码等"
        detailData.append(detailModel)
        
        detailModel = MyOwnDetail()
        detailModel.mainItem = "语言"
        detailModel.subItem = "各国语言设置"
        detailData.append(detailModel)
        
        detailModel = MyOwnDetail()
        detailModel.mainItem = "其他"
        detailModel.subItem = "功能介绍、投诉建议、关于享爱"
        detailData.append(detailModel)
        
        myOwnModel = MyOwn(title: "账号设置", myOwnData: detailData)
        self.myOwnData.append(myOwnModel)
        
        
        detailData = []
        detailModel = MyOwnDetail()
        detailModel.mainItem = "连接设备"
        detailModel.subItem = "添加/连接设备"
        detailData.append(detailModel)
        
        detailModel = MyOwnDetail()
        detailModel.mainItem = "解除设备"
        detailModel.subItem = "解除/删除设备"
        detailData.append(detailModel)
        
        
        myOwnModel = MyOwn(title: "硬件设置", myOwnData: detailData)
        self.myOwnData.append(myOwnModel)
        
        
        self.rowHeight = (ScreenHeight - navAndTabHeight - 2 * 20) * (1 / 9)
        self.myOwnTable = UITableView.init(frame: CGRectMake(viewOriginX, navigationBarHeight, ScreenWidth - 2 * viewOriginX, ScreenHeight - navAndTabHeight), style: .Grouped)
        self.myOwnTable.scrollEnabled = false
        self.myOwnTable.delegate = self
        self.myOwnTable.dataSource = self
        self.myOwnTable.tableFooterView = UIView.init()
        self.myOwnTable.separatorInset = UIEdgeInsetsZero
        self.myOwnTable.layoutMargins = UIEdgeInsetsZero
        self.myOwnTable.backgroundColor = UIColor.whiteColor()
         self.myOwnTable.registerClass(MyOwnCell.self, forCellReuseIdentifier: myOwnCellId)
        self.view.addSubview(self.myOwnTable)
    }
    
    
    
    //MARK:____Table view delegate and data source____
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.myOwnData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myOwnData[section].myOwnData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myOwnCellId, forIndexPath: indexPath) as? MyOwnCell
        if let resultCell = cell {
            resultCell.selectionStyle = .None
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            if indexPath.section == 0 {
                resultCell.accessoryType = .None
            }else{
                resultCell.accessoryType = .DisclosureIndicator
            }
            resultCell.refreshCell(self.myOwnData[indexPath.section].myOwnData[indexPath.row], indexPath: indexPath)
            resultCell.headClickHandler = { [weak self] (index, model)in
                if let weakSelf = self {
                    switch index {
                    case 10:
                        break
                    case 20:
                        break
                    case 30:
                        break
                    case 40:
                        if MyHeadGroup.bbsCollNum() == "0" {
                            return
                        }
                        let collection = CollectionViewController()
                        weakSelf.navigationController?.pushViewController(collection, animated: true)
                    case 50:
                        if let person = PersonDetailBL.find(){
                            let personInfoEdit = MyOwnEidtViewController()
                            personInfoEdit.infoModel = model
                            personInfoEdit.personDetailModel = person
                            weakSelf.navigationController?.pushViewController(personInfoEdit, animated: true)
                        }

                    default:
                        break
                    }
                }
            }
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView:UIView? = nil
        switch section {
        case 0:
            headerView = nil
        default:
            headerView = UIView.init(frame: CGRectMake(0, 0, tableView.frame.width, headerHeight))
            headerView?.backgroundColor = UIColor.hexStringToColor("#60555b")
            let headLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 40, height: headerView!.frame.height))
            let model = self.myOwnData[section]
            headLabel.text = model.title
            headLabel.textColor = UIColor.whiteColor()
            headLabel.font = UIFont.systemFontOfSize(upRateWidth(11))
            headerView?.addSubview(headLabel)
        }
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height:CGFloat = 0
        
        switch section {
        case 0:
            height = 0.001
        case 1, 2:
            height = headerHeight
        default:
            height = 0.001
        }
        return height
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        var height:CGFloat = 0
        
        switch section {
        case 2:
            height = self.rowHeight
        default:
            height = 0.001
        }
        return height
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var footerView:HMButton? = nil
        if section == 2 {
            footerView = HMButton.init(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.frame), rowHeight))
            footerView?.titleLabel?.font = UIFont.systemFontOfSize(16)
            footerView?.setTitleColor(UIColor.blackColor(), forState: .Normal)
            footerView?.backgroundColor = UIColor.hexStringToColor("#efeff4")
            footerView?.addTarget(self, action: #selector(MyOwnViewController.logoutClick(_:)), forControlEvents: .TouchUpInside)
            footerView?.setTitle("退出登录", forState: .Normal)
        }
        return footerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var height:CGFloat = 0
        switch indexPath.section {
        case 0:
            height = self.rowHeight * 3
        default:
            height = self.rowHeight
        }
        return height
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 1:
            switch indexPath.row {
            case 0:
                let security = SecurityViewController()
                security.finishedModifyHandler = {
                    HMTablBarController.selectedIndex = 0
                }
                self.navigationController?.pushViewController(security, animated: true)
            case 1:
                let language = LanguageViewController()
                self.navigationController?.pushViewController(language, animated: true)
            case 2:
                let other = OtherViewController()
                self.navigationController?.pushViewController(other, animated: true)
            default:
                return
            }
        case 2:
            switch indexPath.row {
            case 0:
                let devices = EquipmentsBL.findAll()
                if devices.count > 0 {
                    for device in devices {
                        let contact = Contact()
                        contact.contactId = device.eqmDid
                        contact.contactPassword = device.eqmPwd
                        contact.contactName = device.eqmName
                        if device.eqmDid.characters.first != "0" {
                            contact.contactType = Int.init(CONTACT_TYPE_UNKNOWN)
                        }else{
                            contact.contactType = Int.init(CONTACT_TYPE_PHONE)
                        }
                        FListManager.sharedFList().insert(contact)
                    }
                }
                if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
                    if contacts.count > 0 {
                        let devices = DeviceListViewController()
                        self.navigationController?.pushViewController(devices, animated: true)
                    }else{
                        let next = QRCodeNextController()
                        self.navigationController?.pushViewController(next, animated: true)
                    }
                }else{
                    let addDevice = AddDeviceViewController()
                    self.navigationController?.pushViewController(addDevice, animated: true)
                }
            case 1:
                if EquipmentsBL.findAll().count > 0 {
                    let deleteDevice = DeviceListViewController()
                    deleteDevice.isDelete = true
                    self.navigationController?.pushViewController(deleteDevice, animated: true)
                }
            default:
                return
            }
        default:
            return
        }
    }

    func logoutClick(btn:UIButton) -> Void {
        HUD.showHud("正在退出...", onView: self.view)
        Logout.sendAsyncLogout { [weak self](logout) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf.view)
                if let log = logout{
                    if log.errorCode == BabyZoneConfig.shared.passCode{
                        LoginBL.clear(BabyZoneConfig.shared.currentUserId.defaultString())
                        BabyZoneConfig.shared.currentUserId.setDefaultObject("")
                        if UDManager.isLogin() == true, let loginResult = UDManager.getLoginInfo() {
                            NetManager.sharedManager().logoutWithUserName(loginResult.contactId, sessionId: loginResult.sessionId, callBack: { (JSON) in
                                if let logoutString = JSON as? String{
                                    let error_code = Int32(logoutString)!
                                    print("code \(error_code)")
                                    switch error_code{
                                    case NET_RET_LOGOUT_SUCCESS:
                                        
                                        UDManager.setIsLogin(false)
                                        GlobalThread.sharedThread(false).kill()
                                        if let manager = FListManager.sharedFList(){
                                            manager.isReloadData = true
                                        }
                                        for contact in FListManager.sharedFList().getContacts() as! [Contact]{
                                            FListManager.sharedFList().delete(contact)
                                        }
                                        HMTablBarController.selectedIndex = 0
                                        AppDelegate.sharedDefault().reRegisterForRemoteNotifications()
                                        let queue = dispatch_queue_create(nil, nil)
                                        dispatch_async(queue, {
                                            P2PClient.sharedClient().p2pDisconnect()
                                        })
                                        
                                    case NET_RET_SYSTEM_MAINTENANCE_ERROR:
                                        HUD.showText("系统正在维护，请稍后再试", onView: weakSelf.view)
                                    default:
                                        if AppDelegate.sharedDefault().networkStatus == NotReachable{
                                            UDManager.setIsLogin(false)
                                            GlobalThread.sharedThread(false).kill()
                                            if let manager = FListManager.sharedFList(){
                                                manager.isReloadData = true
                                            }
                                            
                                            AppDelegate.sharedDefault().reRegisterForRemoteNotifications()
                                            let queue = dispatch_queue_create(nil, nil)
                                            dispatch_async(queue, {
                                                P2PClient.sharedClient().p2pDisconnect()
                                            })
                                        }else{
                                            HUD.showText("退出失败,错误原因:\(error_code)", onView: weakSelf.view)
                                        }
                                    }
                                }
                            })
                        }
                        HMTablBarController.selectedIndex = 0
                    }else{
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("退出失败:\n\(log.errorCode)\(log.msg)", onView: weakSelf.view)
                    }
                }

            }
        }
    }
    
    func loginAndRegistSuccessRefresh() {
        self.initialize()
    }
    
    func refreshHeader(note:NSNotification) -> Void {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
