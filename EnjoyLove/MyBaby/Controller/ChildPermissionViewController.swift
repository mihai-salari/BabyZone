//
//  ChildPermissionViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/28.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let ChildPermissionSwitchTag = 1000
private let PermissionCellId = "PermissionCellId"
class ChildPermissionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate{

    var childEquipment:ChildEquipments!
    var equipment:Equipments!
    var indexPath:NSIndexPath!
    var flag = 0//0:编辑信息, 1:权限
    var isName:Bool = false
    var isDetail:Bool = false
    
    
    
    var changeResultHandler:((indexPath:NSIndexPath, result1:String?, result2: String?)->())?
    private var videoPermission = "0"
    private var voicePermission = "0"
    private var permissionData:[Permission]!
    private var permissionTable:UITableView!
    private var tableRowheight:CGFloat = 0
    private var editTextField:UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        
        var title = "设备权限"
        let selector = self.flag == 0 ? #selector(self.confirmChange) : nil
        let rightItem = self.flag == 0 ? "确定" : ""
        if isDetail == true {
            title = self.flag == 0 ? self.childEquipment.eqmName : title
        }else{
            title = self.flag == 0 ? self.equipment.eqmName : title
        }
        self.navigationBarItem(self, isImage: false, title: title, leftSel: nil, rightSel: selector, rightTitle: rightItem)
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
        self.flag = self.indexPath == nil ? self.flag : self.indexPath.section
        switch self.flag {
        case 0:
            let backgroundView = UIView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight))
            backgroundView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(backgroundView)
            
            self.editTextField = UITextField.textField(CGRect.init(x: 10, y: 0, width: backgroundView.frame.width - 20, height: 45), title: nil, titleColor: UIColor.lightGrayColor(), seperatorColor: UIColor.clearColor(), holder: self.isDetail == false ? self.equipment.eqmName : self.childEquipment.eqmName, clear: true)
            self.editTextField.delegate = self
            backgroundView.addSubview(self.editTextField)
            let line = UIView.init(frame: CGRect.init(x: 0, y: self.editTextField.frame.maxY, width: backgroundView.frame.width, height: 1))
            line.backgroundColor = UIColor.lightGrayColor()
            backgroundView.addSubview(line)
            
        case 1:
            self.permissionData = []
            var model = Permission(mainItem: "观看权限", onTitle: "能看宝宝", offTitle: "不能看宝宝")
            self.permissionData.append(model)
            
            model = Permission(mainItem: "声音权限", onTitle: "能听声音", offTitle: "不能听声音")
            self.permissionData.append(model)
            
            self.tableRowheight = (ScreenHeight - navigationBarHeight) * (1 / 12)
            self.permissionTable = UITableView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: ScreenHeight - navigationBarHeight), style: .Plain)
            self.permissionTable.backgroundColor = UIColor.whiteColor()
            self.permissionTable.separatorInset = UIEdgeInsetsZero
            self.permissionTable.layoutMargins = UIEdgeInsetsZero
            self.permissionTable.tableFooterView = UIView.init()
            self.permissionTable.scrollEnabled = false
            self.permissionTable.delegate = self
            self.permissionTable.dataSource = self
            self.permissionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: PermissionCellId)
            self.view.addSubview(self.permissionTable)
        default:
            break
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.permissionData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PermissionCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.textLabel?.text = self.permissionData[indexPath.row].mainItem
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: tableView.frame.width - 15 - 80, y: (resultCell.contentView.frame.height - resultCell.contentView.frame.height * (2 / 3)) / 2, width: 80, height: resultCell.contentView.frame.height * (2 / 3)))
            if self.isDetail == false {
                onSwitch.on = false
            }else{
                onSwitch.on = self.childEquipment.eqmStatus == "0" ? false : true
            }
            onSwitch.onLabel.text = self.permissionData[indexPath.row].onTitle
            onSwitch.offLabel.text = self.permissionData[indexPath.row].offTitle
            onSwitch.tag = ChildPermissionSwitchTag + indexPath.row
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            onSwitch.addTarget(self, action: #selector(self.swithchChange(_:)), forControlEvents: .ValueChanged)
            resultCell.contentView.addSubview(onSwitch)
        }
        
        return cell!
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func swithchChange(onSwitch:HMSwitch) -> Void {
        
        if onSwitch.tag == ChildPermissionSwitchTag {
            if onSwitch.on == true {
                self.videoPermission = "1"
            }else{
                self.videoPermission = "0"
            }
        }else if onSwitch.tag == ChildPermissionSwitchTag + 1{
            if onSwitch.on == true {
                self.voicePermission = "1"
            }else{
                self.voicePermission = "0"
            }
        }
    }
    
    func confirmChange() -> Void {
        if let handle = self.changeResultHandler {
            if let tf = self.editTextField {
                tf.resignFirstResponder()
                if let txt = tf.text {
                    var resultText = txt
                    if txt == "" {
                        resultText = tf.placeholder!
                    }
                    if self.indexPath.row == 0 && self.isName == false{
                        if resultText.isTelNumber() == false {
                            HUD.showText("请输入正确的手机号", onView: self.view)
                            return
                        }
                    }
                    handle(indexPath: self.indexPath, result1: txt, result2: nil)
                }
            }else{
                handle(indexPath: self.indexPath, result1: self.videoPermission, result2: self.voicePermission)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
        
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
