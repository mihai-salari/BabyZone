//
//  ChildDetailViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/28.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class ChildDetailViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource {
    
    private var childList:[AccountInfo]!
    var childAccount:SettingDetail!
    
    private var childTable:UITableView!
    private var tableRowHeight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: childAccount.mainItem, leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        
        self.childList = []
        
        var modelData:[AccountDetail] = []
        var subModel = AccountDetail(mainItem: childAccount.mainItem, subItem: "更名", devicePermisson: -1, deviceId: -1)
        modelData.append(subModel)
        subModel = AccountDetail(mainItem: childAccount.subItem, subItem: "手机号", devicePermisson: -1, deviceId: -1)
        modelData.append(subModel)
        var mainModel = AccountInfo(title: "子账号信息", detail: modelData)
        self.childList.append(mainModel)

        modelData = []
        subModel = AccountDetail(mainItem: "设备1", subItem: "", devicePermisson: 0, deviceId: 1)
        modelData.append(subModel)
        subModel = AccountDetail(mainItem: "设备2", subItem: "", devicePermisson: 1, deviceId: 2)
        modelData.append(subModel)
        mainModel = AccountInfo(title: "设备权限", detail: modelData)
        self.childList.append(mainModel)
        
        mainModel = AccountInfo()
        mainModel.title = "- 删除子账号"
        self.childList.append(mainModel)
        
        self.tableRowHeight = (ScreenHeight - navigationBarHeight - 60) * (1 / 12) > 44 ? (ScreenHeight - navigationBarHeight - 60) * (1 / 12) : 44
        self.childTable = UITableView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, ScreenHeight - navigationBarHeight), style: .Grouped)
        self.childTable.backgroundColor = UIColor.whiteColor()
        self.childTable.dataSource = self
        self.childTable.delegate = self
        self.childTable.rowHeight = self.tableRowHeight
        self.childTable.separatorInset = UIEdgeInsetsZero
        self.childTable.layoutMargins = UIEdgeInsetsZero
        self.childTable.registerClass(ChildDetailCell.self, forCellReuseIdentifier: NSStringFromClass(ChildDetailCell))
        self.view.addSubview(self.childTable)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.childList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.childList[section].detail == nil ? 0 : self.childList[section].detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ChildDetailCell)) as? ChildDetailCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            if let data = self.childList[indexPath.section].detail {
                let model = data[indexPath.row]
                resultCell.refreshCell(model, row: indexPath.row)
            }
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case self.childList.count - 1:
            return self.tableRowHeight
        default:
            return 30
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case self.childList.count - 1:
            let headButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableRowHeight))
            headButton.backgroundColor = UIColor.hexStringToColor("#f9f4f7")
            headButton.setTitle(self.childList[section].title, forState: .Normal)
            headButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            headButton.addTarget(self, action: #selector(self.deleteAccountClick), forControlEvents: .TouchUpInside)
            return headButton
        default:
            let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            headView.backgroundColor = UIColor.hexStringToColor("#60555b")
            let label = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: headView.frame.width - 2 * viewOriginX, height: headView.frame.height))
            label.text = self.childList[section].title
            label.font = UIFont.systemFontOfSize(13)
            label.textColor = UIColor.whiteColor()
            headView.addSubview(label)
            return headView
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if let modelData = self.childList[indexPath.section].detail {
                if modelData.count > 0 {
                    let model = modelData[indexPath.row]
                    let permission = ChildPermissionViewController()
                    permission.detail = model
                    self.navigationController?.pushViewController(permission, animated: true)
                }
            }
        }
    }
    
    func deleteAccountClick() -> Void {
        
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
