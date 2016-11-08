//
//  BabySettingViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let BabySettingSwitchTag = 1000
private let settingTableCellId = "settingTableCellId"

class BabySettingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
        
    private var settingTable:UITableView!
    private var settingData:[BabySetting]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "设置", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.initializeData()
        
        self.settingTable = UITableView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), style: .Plain)
        self.settingTable.delegate = self
        self.settingTable.dataSource = self
        self.settingTable.tableFooterView = UIView.init()
        self.settingTable.separatorInset = UIEdgeInsetsZero
        self.settingTable.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(self.settingTable)
        
        //        self.settingView = BabySettingView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), selectionHandler: { [weak self](indexPath, data) in
        //            if let weakSelf = self{
        //                if indexPath.section == 1 {
        //                    switch indexPath.row {
        //                    case data.count - 1:
//                                let handleChildAccount = HandleChildAccountViewController()
//                                handleChildAccount.settingRefreshHandler = {
//                                    weakSelf.settingView.refreshData()
//                                }
//                                handleChildAccount.settingDeleteHandler = {
//                                    weakSelf.settingView.refreshData()
//                                }
//                                weakSelf.navigationController?.pushViewController(handleChildAccount, animated: true)
        //                    default:
//                                let accountDetail = ChildDetailViewController()
//                                accountDetail.childAccount = data[indexPath.row]
//                                accountDetail.reloadHandler = { (isDelete)in
//                                    weakSelf.settingView.refreshData()
//                                }
        //                        weakSelf.navigationController?.pushViewController(accountDetail, animated: true)
        //                    }
        //                }
        //            }
        //        })
        //        self.view.addSubview(self.settingView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeData() ->Void{
        self.settingData = []
        self.settingData.removeAll()
        var settingDetailData:[ChildAccount] = []
        
        
        var model = ChildAccount()
        model.childName = "异常提醒"
        model.childMobile = ""
        model.onTitle = "打开提醒"
        model.offTitle = "关闭提醒"
        model.onOffStatus = PersonDetailBL.remind()
        settingDetailData.append(model)
        
        model = ChildAccount()
        model.childName = "提醒方式"
        model.childMobile = ""
        model.onTitle = "消息提醒"
        model.offTitle = "震动提醒"
        model.onOffStatus = PersonDetailBL.remindMethod()
        settingDetailData.append(model)
        
        var settingModel = BabySetting.init(title: "提醒设置", data: settingDetailData)
        self.settingData.append(settingModel)
        
        HUD.showHud("正在加载...", onView: self.view)
        ChildAccount.sendAsyncChildAccountList { [weak self](errorCode, msg) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf.view)
                dispatch_queue_create("childAccountListQueue", nil).queue({
                    var subCountData:[ChildAccount] = []
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            let childAccounts = ChildAccountBL.findAll()
                            if childAccounts.count > 0{
                                for account in childAccounts{
                                    subCountData.append(account)
                                }
                                model = ChildAccount()
                                model.childName = "添加/删除子账号"
                                model.childMobile = "添加/删除设备"
                                subCountData.append(model)
                                
                            }else{
                                model = ChildAccount()
                                model.childName = "添加/删除子账号"
                                model.childMobile = "添加/删除设备"
                                subCountData.append(model)
                            }
                        }else{
                            model = ChildAccount()
                            model.childName = "添加/删除子账号"
                            model.childMobile = "添加/删除设备"
                            subCountData.append(model)
                        }
                    }else{
                        model = ChildAccount()
                        model.childName = "添加/删除子账号"
                        model.childMobile = "添加/删除设备"
                        subCountData.append(model)
                    }
                    settingModel = BabySetting.init(title: "子账号设置", data: subCountData)
                    weakSelf.settingData.append(settingModel)
                    dispatch_get_main_queue().queue({
                        if let table = weakSelf.settingTable{
                            table.reloadData()
                        }
                    })
                })
            }
        }
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
            
            resultCell.contentView.frame = CGRect.init(x: resultCell.contentView.frame.minX, y: resultCell.contentView.frame.minY, width: tableView.frame.width, height: 50)
            
            let model = self.settingData[indexPath.section].setting[indexPath.row]
            resultCell.textLabel?.text = model.childName
            resultCell.textLabel?.font = UIFont.systemFontOfSize(14)
            
            switch indexPath.section {
            case 0:
                resultCell.accessoryType = .None
                let onSwitch = HMSwitch.init(frame: CGRectMake(tableView.frame.width - 80, (CGRectGetHeight(resultCell.contentView.frame) - resultCell.contentView.frame.height * (1 / 2)) / 2, 60, resultCell.contentView.frame.height * (1 / 2)))
                onSwitch.onLabel.textColor = UIColor.whiteColor()
                onSwitch.offLabel.textColor = UIColor.whiteColor()
                onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
                onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
                onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
                onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
                onSwitch.inactiveColor = UIColor.lightGrayColor()
                onSwitch.tag = BabySettingSwitchTag + indexPath.row
                onSwitch.on = model.onOffStatus
                onSwitch.onLabel.text = model.onTitle
                onSwitch.offLabel.text = model.offTitle
                resultCell.contentView.addSubview(onSwitch)
                
                if PersonDetailBL.remind() == false && indexPath.row == 1 {
                    resultCell.backgroundColor = UIColor.hexStringToColor("#cccccc")
                    onSwitch.userInteractionEnabled = false
                }else{
                    onSwitch.addTarget(self, action: #selector(self.switchOnOff(_:)), forControlEvents: UIControlEvents.ValueChanged)
                    resultCell.backgroundColor = UIColor.whiteColor()
                    onSwitch.userInteractionEnabled = true
                }

            case 1:
                resultCell.accessoryType = .DisclosureIndicator
                resultCell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
                resultCell.detailTextLabel?.text =  model.childMobile
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
        switch indexPath.section {
        case 0:
            break
        case 1:
            let data = self.settingData[indexPath.section].setting
            
            switch indexPath.row {
            case data.count - 1:
                let handleChildAccount = HandleChildAccountViewController()
                handleChildAccount.settingRefreshHandler = {
                    self.initializeData()
                }
                handleChildAccount.settingDeleteHandler = {
                    self.initializeData()
                }
                self.navigationController?.pushViewController(handleChildAccount, animated: true)

            default:
                let accountDetail = ChildDetailViewController()
                accountDetail.childAccount = data[indexPath.row]
                accountDetail.reloadHandler = { (isDelete)in
                    self.initializeData()
                }
                self.navigationController?.pushViewController(accountDetail, animated: true)
            }

        default:
            break
        }
    }
    
    
    func switchOnOff(on:HMSwitch) -> Void {
        if on.tag == BabySettingSwitchTag {
            PersonDetailBL.saveRemind(on.on)
            if let table = self.settingTable{
                table.reloadRowsAtIndexPaths([NSIndexPath.init(forRow: 1, inSection: 0)], withRowAnimation: .None)
            }
        }else if on.tag == BabySettingSwitchTag + 1{
            PersonDetailBL.saveRemindMethod(on.on)
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
