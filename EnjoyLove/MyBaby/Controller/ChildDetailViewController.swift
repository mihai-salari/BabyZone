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
    var reloadHandler:((isDelete:Bool)->())?
    
    
    private var childTable:UITableView!
    private var tableRowHeight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: self.childAccount.mainItem, leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if self.childAccount != nil {
            self.initialize()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        
        
        
        HUD.showHud("正在加载...", onView: self.view)
        ChildEquipments.sendAsyncChildEquipmentsList(self.childAccount.itemId) { [weak self](errorCode, msg) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf.view)
                if let err = errorCode {
                    if err == BabyZoneConfig.shared.passCode{
                        dispatch_queue_create("equipmentListQueue", nil).queue({
                            weakSelf.initializeData()
                            dispatch_get_main_queue().queue({
                                if let table = weakSelf.childTable{
                                    table.reloadData()
                                }
                            })
                        })
                    }else{
                        HUD.showText("加载设备失败", onView: weakSelf.view)
                    }
                }else{
                    HUD.showText("加载设备失败", onView: weakSelf.view)
                }
            }
        }
        
        self.initializeData()

        self.tableRowHeight = (ScreenHeight - navigationBarHeight - 60) * (1 / 12) > 44 ? (ScreenHeight - navigationBarHeight - 60) * (1 / 12) : 44
        self.childTable = UITableView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, ScreenHeight - navigationBarHeight), style: .Plain)
        self.childTable.backgroundColor = UIColor.whiteColor()
        self.childTable.tableFooterView = UIView.init()
        self.childTable.dataSource = self
        self.childTable.delegate = self
        self.childTable.rowHeight = self.tableRowHeight
        self.childTable.separatorInset = UIEdgeInsetsZero
        self.childTable.layoutMargins = UIEdgeInsetsZero
        self.view.addSubview(self.childTable)
        
    }
    
    private func initializeData() ->Void{
        if self.childList != nil {
            self.childList.removeAll()
            self.childList = nil
        }
        self.childList = []
        var modelData:[ChildEquipments] = []
        var subModel = ChildEquipments()
        subModel.eqmName = self.childAccount.mainItem
        subModel.eqmSubItem = "更名"
        subModel.eqmStatus = "-1"
        modelData.append(subModel)
        
        subModel = ChildEquipments()
        subModel.eqmName = self.childAccount.subItem
        subModel.eqmSubItem = "手机号"
        subModel.eqmStatus = "-1"
        modelData.append(subModel)
        
        var mainModel = AccountInfo(title: "子账号信息", detail: modelData)
        self.childList.append(mainModel)
        
        modelData = []
        if ChildEquipmentsBL.findAll().count > 0 {
            if let device = ChildEquipmentsBL.find(nil, key: self.childAccount.itemId) {
                subModel = ChildEquipments()
                subModel.eqmName = device.eqmName
                subModel.eqmSubItem = ""
                subModel.eqmStatus = device.eqmStatus
                subModel.idUserChildEqmInfo = device.idUserChildEqmInfo
                modelData.append(subModel)
            }
        }else{
            subModel = ChildEquipments()
            subModel.eqmName = "设备1"
            subModel.eqmSubItem = ""
            subModel.eqmStatus = "1"
            modelData.append(subModel)
        }
        mainModel = AccountInfo(title: "设备权限", detail: modelData)
        self.childList.append(mainModel)
        
        mainModel = AccountInfo()
        mainModel.title = "- 删除子账号"
        self.childList.append(mainModel)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.childList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.childList[section].detail == nil ? 0 : self.childList[section].detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "ChildAccountTableViewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            for subview in resultCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.selectionStyle = .None
            resultCell.textLabel?.font = UIFont.systemFontOfSize(14)
            resultCell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
            let model = self.childList[indexPath.section].detail[indexPath.row]
            resultCell.textLabel?.text = model.eqmName
            if indexPath.section == 0 {
                resultCell.detailTextLabel?.text = model.eqmSubItem
            }else if indexPath.section == 1{
                if model.eqmStatus != "-1" {
                    resultCell.accessoryType = .DisclosureIndicator
                    let onSwitch = HMSwitch.init(frame: CGRect(x: resultCell.contentView.frame.width - 55, y: (resultCell.contentView.frame.height - resultCell.contentView.frame.height * (2 / 3)) / 2, width: 60, height: resultCell.contentView.frame.height * (2 / 3)))
                    onSwitch.on = model.eqmStatus == "0" ? false : true
                    onSwitch.onLabel.text = "打开"
                    onSwitch.offLabel.text = "关闭"
                    onSwitch.onLabel.textColor = UIColor.whiteColor()
                    onSwitch.offLabel.textColor = UIColor.whiteColor()
                    onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
                    onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
                    onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
                    onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
                    onSwitch.inactiveColor = UIColor.lightGrayColor()
                    onSwitch.tag = indexPath.row
                    onSwitch.addTarget(self, action: #selector(self.equipmentOnOff(_:)), forControlEvents: .ValueChanged)
                    resultCell.contentView.addSubview(onSwitch)
                }else{
                    resultCell.accessoryType = .None
                }
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
        if let modelData = self.childList[indexPath.section].detail {
            if modelData.count > 0 {
                if (indexPath.section == 0 && indexPath.row == 0) || (indexPath.section == 1 && modelData[indexPath.row].eqmStatus == "1"){
                    let model = modelData[indexPath.row]
                    let permission = ChildPermissionViewController()
                    permission.changeResultHandler = { [weak self](indexPath, result1, result2) in
                        if let weakSelf = self {
                            HUD.showHud("正在提交", onView: weakSelf.view)
                            dispatch_queue_create("changeResultQueue", nil).queue({
                                if let result = result1{
                                    ChildAccount.sendAsyncModifyChildAccount(weakSelf.childAccount.itemId, childName: result, completionHandler: { [weak self](errorCode, msg) in
                                        dispatch_get_main_queue().queue({ 
                                            HUD.hideHud(weakSelf.view)
                                        })
                                        if let weakSelf = self{
                                            if let err = errorCode{
                                                if err == BabyZoneConfig.shared.passCode{
                                                    weakSelf.childList[indexPath.section].detail[indexPath.row].eqmName = result
                                                    dispatch_get_main_queue().queue({ 
                                                        if let table = self?.childTable{
                                                            table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                                                        }
                                                        if let handle = weakSelf.reloadHandler{
                                                            handle(isDelete: false)
                                                        }
                                                    })
                                                }else{
                                                    dispatch_get_main_queue().queue({
                                                        HUD.showText("修改失败", onView: weakSelf.view)
                                                    })
                                                }
                                            }else{
                                                dispatch_get_main_queue().queue({
                                                    HUD.showText("修改失败", onView: weakSelf.view)
                                                })
                                            }
                                        }
                                    })
                                }
                            })
                        }
                    }
                    permission.childEquipment = model
                    permission.isDetail = true
                    permission.indexPath = indexPath
                    if indexPath.section == 0 && indexPath.row == 0 {
                        permission.isName = true
                    }
                    self.navigationController?.pushViewController(permission, animated: true)
                }
            }
        }
    }
    
    func deleteAccountClick() -> Void {
        HUD.showHud("正在提交...", onView: self.view)
        ChildAccount.sendAsyncDeleteChildAccount(self.childAccount.itemId) { [weak self](errorCode, msg) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf.view)
                if let err = errorCode{
                    if err == BabyZoneConfig.shared.passCode{
                        if let handle = weakSelf.reloadHandler{
                            handle(isDelete: true)
                        }
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }else{
                        HUD.showText("删除失败", onView: weakSelf.view)
                    }
                }else{
                    HUD.showText("删除失败", onView: weakSelf.view)
                }
            }
        }
    }
    
    func equipmentOnOff(onSwicth:HMSwitch) -> Void {
        if self.childList.count > 1 {
            let detail = self.childList[1].detail[onSwicth.tag]
            ChildEquipments.sendAsyncModifyChildEquipmentsStatus(detail.idUserChildEqmInfo, idEqmInfo: detail.idEqmInfo, eqmStatus: detail.eqmStatus, completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    HUD.hideHud(weakSelf.view)
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            
                        }else{
                            onSwicth.on = !onSwicth.on
                            HUD.showText("修改失败", onView: weakSelf.view)
                        }
                    }else{
                        onSwicth.on = !onSwicth.on
                        HUD.showText("修改失败", onView: weakSelf.view)
                    }
                }
            })
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
