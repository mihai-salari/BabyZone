//
//  ChildAccountView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/6.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class HandleChildAccountView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    private var childTable:UITableView!
    private var accountList:[ChildAccountList]!
    private var tableRowHeight:CGFloat = 0
    private var addNewCompletionHandler:(()->())?
    
    init(frame: CGRect, addNewHandler:(()->())?) {
        super.init(frame: frame)
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
        
        self.tableRowHeight = (ScreenHeight - navigationBarHeight - 30) * (1 / 12)
        self.childTable = UITableView.init(frame: CGRectMake(0, 0, self.frame.width, self.frame.height), style: .Grouped)
        self.childTable.backgroundColor = UIColor.whiteColor()
        self.childTable.dataSource = self
        self.childTable.delegate = self
        self.childTable.rowHeight = self.tableRowHeight
        self.childTable.separatorInset = UIEdgeInsetsZero
        self.childTable.layoutMargins = UIEdgeInsetsZero
        self.addSubview(self.childTable)
        
        self.addNewCompletionHandler = addNewHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
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
                data.removeAtIndex(indexPath.row)
                self.accountList[indexPath.section].account = data
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }
    }
    
    func addNewAccountClick() -> Void {
        if let handle = self.addNewCompletionHandler {
            handle()
        }
    }
    
}



class ChildDetailCell: UITableViewCell,UITextFieldDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func refreshCell(model:AccountDetail, row:Int) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(origin: self.contentView.frame.origin, size: CGSize(width: ScreenWidth - 2 * viewOriginX, height: self.contentView.frame.height))
        if model.devicePermisson == -1 {
            let rightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width * (2 / 5), height: self.contentView.frame.height))
            rightLabel.textColor = UIColor.lightGrayColor()
            rightLabel.text = model.subItem
            rightLabel.textAlignment = .Right
            rightLabel.font = UIFont.systemFontOfSize(12)
            let inputTF = UITextField.textField(CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width - 20 - 2 * viewOriginX, height: self.contentView.frame.height), title: nil, holder: model.mainItem, right: true, rightView: rightLabel)
            inputTF.delegate = self
            inputTF.tag = inputTFStartIndex + row
            self.contentView.addSubview(inputTF)
        }else{
            let mainLabel = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width / 2, height: self.contentView.frame.height))
            mainLabel.text = model.mainItem
            mainLabel.font = UIFont.boldSystemFontOfSize(14)
            mainLabel.textColor = UIColor.hexStringToColor("#330429")
            self.contentView.addSubview(mainLabel)
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: self.contentView.frame.width - AddAccountSwitchWidth - 15, y: (self.contentView.frame.height - AddAccountSwitchHeight) / 2, width: AddAccountSwitchWidth, height: AddAccountSwitchHeight))
            onSwitch.on = model.devicePermisson == 0 ? false : true
            onSwitch.onLabel.text = "打开"
            onSwitch.offLabel.text = "关闭"
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            self.contentView.addSubview(onSwitch)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

private let inputTFStartIndex = 100
private let AddAccountSwitchWidth:CGFloat = 50
private let AddAccountSwitchHeight:CGFloat = 20
class AddAccountCell: UITableViewCell,UITextFieldDelegate {
    
    private var phoneString:String!
    private var userName:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:AccountDetail, row:Int) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(origin: self.contentView.frame.origin, size: CGSize(width: ScreenWidth - 2 * viewOriginX, height: self.contentView.frame.height))
        if model.devicePermisson == -1 {
            let rightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width * (2 / 5), height: self.contentView.frame.height))
            rightLabel.textColor = UIColor.lightGrayColor()
            rightLabel.text = model.subItem
            rightLabel.textAlignment = .Right
            rightLabel.font = UIFont.systemFontOfSize(12)
            let inputTF = UITextField.textField(CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width - 30 - 2 * viewOriginX, height: self.contentView.frame.height), title: nil, holder: model.mainItem, right: true, rightView: rightLabel)
            inputTF.delegate = self
            inputTF.tag = inputTFStartIndex + row
            self.contentView.addSubview(inputTF)
        }else{
            let mainLabel = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width / 2, height: self.contentView.frame.height))
            mainLabel.text = model.mainItem
            mainLabel.font = UIFont.boldSystemFontOfSize(14)
            mainLabel.textColor = UIColor.hexStringToColor("#330429")
            self.contentView.addSubview(mainLabel)
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: self.contentView.frame.width - AddAccountSwitchWidth - 15, y: (self.contentView.frame.height - AddAccountSwitchHeight) / 2, width: AddAccountSwitchWidth, height: AddAccountSwitchHeight))
            onSwitch.on = model.devicePermisson == 0 ? false : true
            onSwitch.onLabel.text = "打开"
            onSwitch.offLabel.text = "关闭"
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            self.contentView.addSubview(onSwitch)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func finishAddAccount() -> Void {
        
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

