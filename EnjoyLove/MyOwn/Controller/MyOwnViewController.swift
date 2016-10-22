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
    private var section1Data:[MyOwnHeader]!
    private var sectionTitleData:[MyOwnSectionTitle]!
    private var rowHeight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, title: "我的", leftSel: nil, rightSel: nil)
        self.tabBarController?.tabBar.hidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        let personChange = personInformationChange()
        if personChange == true {
            if let table = self.myOwnTable {
                table.reloadSections(NSIndexSet.init(index: 0), withRowAnimation: .None)
                setPersonInformationChange(false)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeDataSource()
        self.initializeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func initializeTableView(){
        
        self.rowHeight = (ScreenHeight - navAndTabHeight - 2 * upRateHeight(20)) * (1 / 10)
        self.myOwnTable = UITableView.init(frame: CGRectMake(viewOriginX, navigationBarHeight + viewOriginY, ScreenWidth - 2 * viewOriginX, ScreenHeight - navAndTabHeight - viewOriginY), style: .Grouped)
        self.myOwnTable.scrollEnabled = false
        self.myOwnTable.registerClass(MyOwnCell.self, forCellReuseIdentifier: myOwnCellId)
        self.myOwnTable.delegate = self
        self.myOwnTable.dataSource = self
        self.myOwnTable.separatorInset = UIEdgeInsetsZero
        self.myOwnTable.layoutMargins = UIEdgeInsetsZero
        self.myOwnTable.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.myOwnTable)
    }
    
    private func initializeDataSource(){
        
        self.section1Data = []
        self.sectionTitleData = []
        
        let headerModel = MyOwnHeader()
        self.section1Data.append(headerModel)
                
        var rowData:[MyOwnNormalRowData] = []
        var model = MyOwnNormalRowData(mainItem: "账号与安全", subItem: "号码绑定、修改密码等")
        rowData.append(model)
        
        model = MyOwnNormalRowData(mainItem: "语言", subItem: "各国语言设置")
        rowData.append(model)
        
        model = MyOwnNormalRowData(mainItem: "其他", subItem: "功能介绍、投诉建议、关于享爱")
        rowData.append(model)
        
        var sectionData = MyOwnSectionTitle(title: "账号设置", rowData: rowData)
        self.sectionTitleData.append(sectionData)
        
        rowData = []
        model = MyOwnNormalRowData(mainItem: "连接设备", subItem: "添加/连接设备")
        rowData.append(model)
        
        model = MyOwnNormalRowData(mainItem: "解除设备", subItem: "解除/删除设备")
        rowData.append(model)
        
        sectionData = MyOwnSectionTitle(title: "硬件设置", rowData: rowData)
        self.sectionTitleData.append(sectionData)
        
        
        
    }
    
    //MARK:____Table view delegate and data source____
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionTitleData.count + 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRows = 0
        if section == 0 {
            numberRows = 1
        }else{
            let model = self.sectionTitleData[section - 1]
            numberRows = model.rowData.count
        }
        return numberRows
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(myOwnCellId, forIndexPath: indexPath) as! MyOwnCell
        
        cell.selectionStyle = .None
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        if indexPath.section == 0 {
            let model = section1Data[indexPath.row]
            cell.refreshHeaderCell(model, completionHandler: { [weak self] in
                if let weakSelf = self{
                    if let phone = NSUserDefaults.standardUserDefaults().objectForKey(UserPhoneKey) as? String{
                        if let login = LoginBL.find(nil, key: phone){
                            if let person = PersonDetailBL.find(nil, key: login.userId){
                                let personInfoEdit = MyOwnEidtViewController()
                                personInfoEdit.infoModel = model
                                personInfoEdit.personDetailModel = person
                                weakSelf.navigationController?.pushViewController(personInfoEdit, animated: true)
                            }
                        }
                    }
                }
            })
        }else{
            let model = self.sectionTitleData[indexPath.section - 1]
            let detailModel = model.rowData[indexPath.row]
            cell.refreshNormalCell(detailModel)
            cell.accessoryType = .DisclosureIndicator
        }
        
        return cell
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
            let model = self.sectionTitleData[section - 1]
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
                if UDManager.isLogin() {
                    if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
                        if contacts.count > 0 {
                            let devices = DeviceListViewController()
                            self.navigationController?.pushViewController(devices, animated: true)
                        }else{
                            let next = QRCodeNextController()
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                    }
                    
                }else{
                    let addDevice = AddDeviceViewController()
                    self.navigationController?.pushViewController(addDevice, animated: true)
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
                if let log = logout{
                    if log.errorCode == BabyZoneConfig.shared.passCode{
                        if let phone = NSUserDefaults.standardUserDefaults().objectForKey(UserPhoneKey) as? String{
                            LoginBL.clear(nil, key: phone)
                        }
                        
                        if let loginResult = UDManager.getLoginInfo() {
                            NetManager.sharedManager().logoutWithUserName(loginResult.contactId, sessionId: loginResult.sessionId, callBack: { (JSON) in
                                HUD.hideHud(weakSelf.view)
                                if let logoutString = JSON as? String{
                                    let error_code = Int32(logoutString)!
                                    print("code \(error_code)")
                                    switch error_code{
                                    case NET_RET_LOGIN_SUCCESS:
                                        
                                        UDManager.setIsLogin(false)
                                        GlobalThread.sharedThread(false).kill()
                                        if let manager = FListManager.sharedFList(){
                                            manager.isReloadData = true
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
                                            if let manager = FListManager.sharedFList() as? FListManager{
                                                manager.isReloadData = true
                                            }
                                            HMTablBarController.selectedIndex = 0
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
                        
                    }else{
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("退出登录失败:\n\(log.errorCode)\(log.msg)", onView: weakSelf.view)
                    }
                }

            }
        }
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
