//
//  ChildAccountView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/6.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class HandleChildAccountView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private var deleteHandler:(()->())?
    private var childTable:UITableView!
    private var accountList:[ChildAccountList]!
    private var tableRowHeight:CGFloat = 0
    private var addNewCompletionHandler:(()->())?
    
    init(frame: CGRect, addNewHandler:(()->())?, deleteRefreshHandler:(()->())?) {
        super.init(frame: frame)
        
        self.initializeData()
        
        self.tableRowHeight = (ScreenHeight - navigationBarHeight - 30) * (1 / 12)
        self.childTable = UITableView.init(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), style: .Plain)
        self.childTable.backgroundColor = UIColor.whiteColor()
        self.childTable.dataSource = self
        self.childTable.delegate = self
        self.childTable.rowHeight = self.tableRowHeight
        self.childTable.tableFooterView = UIView.init()
        self.childTable.separatorInset = UIEdgeInsetsZero
        self.childTable.layoutMargins = UIEdgeInsetsZero
        self.addSubview(self.childTable)
        
        self.addNewCompletionHandler = addNewHandler
        self.deleteHandler = deleteRefreshHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeData() -> Void{
        if self.accountList != nil {
            self.accountList.removeAll()
            self.accountList = nil
        }
        
        self.accountList = []
        var accountData:[ChildAccount] = []
        if ChildAccountBL.findAll().count > 0 {
            accountData.appendContentsOf(ChildAccountBL.findAll())
        }else{
            let accountModel = ChildAccount()
            accountModel.childName = "暂时没有绑定子账号"
            accountData.append(accountModel)
        }
        var model = ChildAccountList(title: "子账号列表", account: accountData)
        self.accountList.append(model)
        
        model = ChildAccountList(title: "+ 添加新的子账号", account: nil)
        self.accountList.append(model)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.accountList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.accountList[section].account == nil ? 0 : self.accountList[section].account.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "childAccountListCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.textLabel?.text = self.accountList[indexPath.section].account == nil ? "" : self.accountList[indexPath.section].account[indexPath.row].childName
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        default:
            return self.tableRowHeight
        }
    }
    
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            headView.backgroundColor = UIColor.hexStringToColor("#60555b")
            let label = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: headView.frame.width - 2 * viewOriginX, height: headView.frame.height))
            label.text = self.accountList[section].title
            label.font = UIFont.systemFontOfSize(13)
            label.textColor = UIColor.whiteColor()
            headView.addSubview(label)
            return headView
        case 1:
            let headButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableRowHeight))
            headButton.backgroundColor = UIColor.hexStringToColor("#f9f4f7")
            headButton.setTitle(self.accountList[section].title, forState: .Normal)
            headButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            headButton.addTarget(self, action: #selector(self.addNewAccountClick), forControlEvents: .TouchUpInside)
            return headButton
        default:
            return nil
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            if var data = self.accountList[indexPath.section].account {
                dispatch_queue_create("deleteChildAccountQueue", nil).queue({
                    HUD.showHud("正在提交...", onView: self)
                    ChildAccount.sendAsyncDeleteChildAccount(data[indexPath.row].idUserChildInfo, completionHandler: { [weak self](errorCode, msg) in
                        if let weakSelf = self{
                            HUD.hideHud(weakSelf)
                            if let err = errorCode{
                                if err == BabyZoneConfig.shared.passCode{
                                    data.removeAtIndex(indexPath.row)
                                    weakSelf.accountList[indexPath.section].account = data
                                    dispatch_get_main_queue().queue({ 
                                        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                                        if let deleteHandle = weakSelf.deleteHandler{
                                            deleteHandle()
                                        }
                                    })
                                }else{
                                    HUD.showText("删除失败", onView: weakSelf)
                                }
                            }else{
                                HUD.showText("删除失败", onView: weakSelf)
                            }
                        }
                    })
                })
            }
        }
    }
    
    func addNewAccountClick() -> Void {
        if let handle = self.addNewCompletionHandler {
            handle()
        }
    }
    
    func refreshHandleAccountCell() -> Void {
        if let listTable = self.childTable {
            self.initializeData()
            listTable.reloadData()
        }
    }
    
}


class AddChildAccountView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private var addAccountData:[AddChildAccount]!
    private var addAccountTable:UITableView!
    private var tableRowHeight:CGFloat = 0
    private var phone = ""
    private var name = ""
    private var idUserChildInfo = ""
    private var selectionHandler:((indexPath:NSIndexPath, model:ChildEquipments)->())?
    
    init(frame: CGRect, selectHandler:((indexPath:NSIndexPath, model:ChildEquipments)->())?) {
        super.init(frame: frame)
        
        self.addAccountData = []
        var detail:[ChildEquipments] = []
        var subModel = ChildEquipments()
        subModel.eqmName = "手机号"
        subModel.eqmSubItem = "输入手机号"
        detail.append(subModel)
        
        subModel = ChildEquipments()
        subModel.eqmName = "名字"
        subModel.eqmSubItem = "更名"
        detail.append(subModel)
        
        var mainModel = AddChildAccount(title: "子账号设置", detail: detail)
        self.addAccountData.append(mainModel)
        /*
        var detail:[ChildEquipments] = []
        subModel = ChildEquipments()
        subModel.eqmName = "设备1"
        subModel.eqmStatus = "0"
        subModel.idEqmInfo = "1"
        detail.append(subModel)
        
        subModel = ChildEquipments()
        subModel.eqmName = "设备2"
        subModel.eqmStatus = "0"
        subModel.idEqmInfo = "2"
        detail.append(subModel)
        
        mainModel = AddChildAccount(title: "设备权限", detail: detail)
        self.addAccountData.append(mainModel)
        */
        /*
        detail = []
        if EquipmentsBL.findAll().count > 0 {
            for eqm in EquipmentsBL.findAll() {
                let childEqm = ChildEquipments()
                childEqm.eqmName = eqm.eqmName
                childEqm.idEqmInfo = eqm.idEqmInfo
                childEqm.eqmStatus = "0"
                detail.append(childEqm)
            }
        }else{
            let eqm = ChildEquipments()
            eqm.eqmName = "您未绑定设备"
            detail.append(eqm)
        }
        mainModel = AddChildAccount(title: "设备权限", detail: detail)
        self.addAccountData.append(mainModel)
 */
        
        self.addAccountTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: ScreenHeight - navigationBarHeight), style: .Plain)
        self.addAccountTable.backgroundColor = UIColor.whiteColor()
        self.addAccountTable.separatorInset = UIEdgeInsetsZero
        self.addAccountTable.layoutMargins = UIEdgeInsetsZero
        self.addAccountTable.tableFooterView = UIView.init()
        self.addAccountTable.delegate = self
        self.addAccountTable.dataSource = self
        self.addSubview(self.addAccountTable)
        
        self.selectionHandler = selectHandler
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.addAccountData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addAccountData[section].detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let AddChildAccountTableViewCellId = "AddChildAccountTableViewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(AddChildAccountTableViewCellId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Value1, reuseIdentifier: AddChildAccountTableViewCellId)
        }
        if let resultCell = cell {
            for subview in resultCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.textLabel?.font = UIFont.systemFontOfSize(14)
            resultCell.detailTextLabel?.font = UIFont.systemFontOfSize(14)
            let modelData = self.addAccountData[indexPath.section].detail[indexPath.row]
            resultCell.textLabel?.text = modelData.eqmName
            if indexPath.section == 0 {
                resultCell.detailTextLabel?.text = modelData.eqmSubItem
            }
            
            if indexPath.section == 1 {
                let onSwitch = HMSwitch.init(frame: CGRect(x: resultCell.contentView.frame.width - 50, y: (resultCell.contentView.frame.height - resultCell.contentView.frame.height * (2 / 3)) / 2, width: 60, height: resultCell.contentView.frame.height * (2 / 3)))
                onSwitch.on = modelData.eqmStatus == "0" ? false : true
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
            }
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = self.addAccountData[section]
        let headView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headView.backgroundColor = UIColor.hexStringToColor("#60555b")
        let label = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: headView.frame.width - 2 * viewOriginX, height: headView.frame.height))
        label.text = model.title
        label.font = UIFont.systemFontOfSize(13)
        label.textColor = UIColor.whiteColor()
        headView.addSubview(label)
        return headView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handle = self.selectionHandler {
            if let modelData = self.addAccountData[indexPath.section].detail {
                if modelData.count > 0 {
                    handle(indexPath: indexPath, model: self.addAccountData[indexPath.section].detail[indexPath.row])
                }
            }
        }
    }
    
    
    func equipmentOnOff(onSwicth:HMSwitch) -> Void {
        
        if self.addAccountData.count > 1 {
            let detail = self.addAccountData[1].detail[onSwicth.tag]
//            ChildEquipments.sendAsyncModifyChildEquipmentsStatus(<#T##idUserChildInfo: String##String#>, idEqmInfo: <#T##String#>, eqmStatus: <#T##String#>, completionHandler: <#T##((errorCode: String?, msg: String?) -> ())?##((errorCode: String?, msg: String?) -> ())?##(errorCode: String?, msg: String?) -> ()#>)
        }
    }
    
    func refreshCell(indexPath:NSIndexPath, result1:String, result2:String) -> Void {
        if let table = self.addAccountTable {
            dispatch_queue_create("addAccountQueue", nil).queue({ 
                self.addAccountData[indexPath.section].detail[indexPath.row].eqmName = result1
                if indexPath.section == 0 {
                    switch indexPath.row{
                    case 0:
                        self.phone = result1
                    case 1:
                        self.name = result1
                    default:
                        break
                    }
                }
                dispatch_get_main_queue().queue({ 
                    table.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                })
            })
        }
    }
    
    func fetchData(completionHandler:(()->())?) -> Void {
        if self.phone == "" {
            HUD.showText("请输入手机号", onView: self)
            return
        }
        if self.phone.isTelNumber() == false {
            HUD.showText("请输入正确的手机号", onView: self)
            return
        }
        if self.name == ""{
            HUD.showText("请输入名字", onView: self)
            return
        }
        HUD.showHud("正在提交...", onView: self)
        ChildAccount.sendAsyncAddChildAccount(self.phone, childName: self.name) { [weak self](errorCode, msg) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf)
                if let err = errorCode {
                    if err == BabyZoneConfig.shared.passCode{
                        dispatch_queue_create("refreshDataQeueu", nil).queue({ 
                            weakSelf.refreshData()
                            dispatch_get_main_queue().queue({ 
                                if let table = weakSelf.addAccountTable{
                                    table.reloadData()
                                }
                            })
                        })
                        if let handle = completionHandler{
                            handle()
                        }
                    }else{
                        HUD.showText("添加失败:\(msg)", onView: weakSelf)
                    }
                }else{
                    HUD.showText("添加失败:\(msg)", onView: weakSelf)
                }
            }
        }
    }
    
    
    private func refreshData() ->Void{
        var detail:[ChildEquipments] = []
        var subModel = ChildEquipments()
        subModel.eqmName = "设备1"
        subModel.eqmStatus = "0"
        subModel.idEqmInfo = "1"
        detail.append(subModel)
        
        subModel = ChildEquipments()
        subModel.eqmName = "设备2"
        subModel.eqmStatus = "0"
        subModel.idEqmInfo = "2"
        detail.append(subModel)
        
        let mainModel = AddChildAccount(title: "设备权限", detail: detail)
        self.addAccountData.append(mainModel)
    }
}





class AddCompletedView: UIView {
    
    private var helpHandler:(()->())?
    private var finishHandler:(()->())?
    
    init(frame: CGRect, helpParentHandler:(()->())?, AddCompletionHandler:(()->())?) {
        super.init(frame: frame)
        let editButton = AddChildAccountButton(type: .Custom)//edit_pencil.png
        editButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2)
        editButton.setImageRect(CGRectMake(0, 0, upRateWidth(15), upRateWidth(15)), image: "edit_pencil.png", title: "爸妈不会操作手机，帮爸妈注册账号?", fontSize: upRateWidth(12))
        editButton.setCustomTitleColor(UIColor.colorFromRGB(219, g: 128, b: 130)!)
        editButton.addCustomTarget(self, sel: #selector(AddCompletedView.helpParentClick))
        self.addSubview(editButton)
        
        let finishButton = UIButton.init(type: .Custom)
        finishButton.frame = CGRectMake(0, CGRectGetMaxY(editButton.frame), CGRectGetWidth(editButton.frame), CGRectGetHeight(editButton.frame))
        finishButton.backgroundColor = UIColor.colorFromRGB(219, g: 128, b: 130)
        finishButton.setTitle("完成", forState: .Normal)
        finishButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        finishButton.addTarget(self, action: #selector(AddCompletedView.finishClick), forControlEvents: .TouchUpInside)
        self.addSubview(finishButton)
        
        self.helpHandler = helpParentHandler
        self.finishHandler = AddCompletionHandler
        
    }
    
    func helpParentClick() -> Void {
        if let handle = self.helpHandler {
            handle()
        }
    }
    
    func finishClick() -> Void {
        if let handle = self.finishHandler {
            handle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

