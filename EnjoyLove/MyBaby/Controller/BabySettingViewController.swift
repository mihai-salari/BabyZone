//
//  BabySettingViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let settingTableRowHeight:CGFloat = upRateHeight(40)
private let settingTableCellId = "settingTableCellId"

class BabySettingViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    private var settingTable:UITableView!
    private var settingData:[BabySetting]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(title: "设置", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeData()
        self.initializeSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initializeSubviews(){
        self.automaticallyAdjustsScrollViewInsets = false
        self.settingTable = UITableView.init(frame: CGRectMake(10, navigationBarHeight, ScreenWidth - 20, ScreenHeight - navigationBarHeight - 10), style: .Grouped)
        self.settingTable.delegate = self
        self.settingTable.dataSource = self
        self.settingTable.scrollEnabled = false
        self.settingTable.registerClass(BabySettingCell.self, forCellReuseIdentifier: settingTableCellId)
        self.settingTable.separatorInset = UIEdgeInsetsZero
        self.settingTable.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(self.settingTable)
    }
    
    private func initializeData(){
        self.settingData = []
        var remindData:[SettingDetail] = []
        
        
        var model = SettingDetail()
        model.mainItem = "异常提醒"
        model.subItem = "0"
        remindData.append(model)
        
        model = SettingDetail()
        model.mainItem = "提醒方式"
        model.subItem = "1"
        remindData.append(model)
        var settingModel = BabySetting(title: "提醒设置", setting: remindData)
        self.settingData.append(settingModel)
        
        var subCountData:[SettingDetail] = []
        model = SettingDetail()
        model.mainItem = "爸妈"
        model.subItem = "13760433884"
        model.videoPermission = 1
        model.voicePermission = 0
        subCountData.append(model)
        
        model = SettingDetail()
        model.mainItem = "老公"
        model.subItem = "13567717113"
        model.voicePermission = 1
        model.videoPermission = 1
        subCountData.append(model)
        
        model = SettingDetail()
        model.mainItem = "添加/删除子账号"
        model.subItem = "添加/删除设备"
        subCountData.append(model)
        settingModel = BabySetting(title: "子账号设置", setting: subCountData)
        self.settingData.append(settingModel)
        

        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.settingData.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingData[section].setting.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(settingTableCellId) as! BabySettingCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = .None
        let settingModel = self.settingData[indexPath.section].setting[indexPath.row]
        cell.refreshCellWithModel(settingModel)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 2:
                cell.accessoryType = .DisclosureIndicator
            default:
                cell.accessoryType = .None
            }
        case 1,2:
            cell.accessoryType = .DisclosureIndicator
        default:
            cell.accessoryType = .None
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.hexStringToColor("#5f545a")
        let titleLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: headerView.frame.width - 20, height: headerView.frame.height))
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.text = self.settingData[section].title
        titleLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return settingTableRowHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            let data = self.settingData[indexPath.section].setting
            switch indexPath.row {
            case data.count - 1:
                let handleChildAccount = HandleChildAccountViewController()
                handleChildAccount.childAccountList = data
                self.navigationController?.pushViewController(handleChildAccount, animated: true)
            default:
                let accountDetail = ChildDetailViewController()
                accountDetail.childAccount = data[indexPath.row]
                self.navigationController?.pushViewController(accountDetail, animated: true)
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
