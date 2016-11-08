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
    private var permissionData:[ChildEquipmentsPermission]!
    private var permissionTable:UITableView!
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
            self.initializePermissonData()
            
            self.permissionTable = UITableView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight), style: .Plain)
            self.permissionTable.backgroundColor = UIColor.whiteColor()
            self.permissionTable.separatorInset = UIEdgeInsetsZero
            self.permissionTable.layoutMargins = UIEdgeInsetsZero
            self.permissionTable.tableFooterView = UIView.init()
            self.permissionTable.scrollEnabled = false
            self.permissionTable.delegate = self
            self.permissionTable.dataSource = self
            self.permissionTable.rowHeight = 50
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
            
            for subview in resultCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            
            let model = self.permissionData[indexPath.row]
            
            resultCell.textLabel?.text = model.mainItem
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: tableView.frame.width - 80, y: (resultCell.contentView.frame.height - resultCell.contentView.frame.height * (1 / 2)) / 2, width: 70, height: resultCell.contentView.frame.height * (1 / 2)))
            
            onSwitch.on = model.eqmPermission
            onSwitch.onLabel.text = model.onTitle
            onSwitch.offLabel.text = model.offTitle
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
        let model = self.permissionData[onSwitch.tag - ChildPermissionSwitchTag]
        if onSwitch.tag == ChildPermissionSwitchTag {
            
            HUD.showHud("正在修改...", onView: self.view)
            ChildEquipmentsPermission.sendAsyncModifyChildEquipmentsPermission(model.idUserChildEqmPermission, idUserChildEqmInfo: self.childEquipment.idUserChildEqmInfo, voicePermission: model.eqmPermission == true ? "1" : "2", imagePermission: onSwitch.on == true ? "1" : "2", completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    HUD.hideHud(weakSelf.view)
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            HUD.showText("修改成功", onView: weakSelf.view)
                        }else{
                            onSwitch.on = !onSwitch.on
                            HUD.showText("修改失败:\(msg!)", onView: weakSelf.view)
                        }
                    }else{
                        onSwitch.on = !onSwitch.on
                        HUD.showText("网络错误:\(msg!)", onView: weakSelf.view)
                    }
                }
            })
            
        }else if onSwitch.tag == ChildPermissionSwitchTag + 1{
            HUD.showHud("正在修改...", onView: self.view)
            ChildEquipmentsPermission.sendAsyncModifyChildEquipmentsPermission(model.idUserChildEqmPermission, idUserChildEqmInfo: self.childEquipment.idUserChildEqmInfo, voicePermission: onSwitch.on == true ? "1" : "2", imagePermission: model.eqmPermission == true ? "1" : "2", completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    HUD.hideHud(weakSelf.view)
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            HUD.showText("修改成功", onView: weakSelf.view)
                        }else{
                            onSwitch.on = !onSwitch.on
                            HUD.showText("修改失败:\(msg!)", onView: weakSelf.view)
                        }
                    }else{
                        onSwitch.on = !onSwitch.on
                        HUD.showText("网络错误:\(msg!)", onView: weakSelf.view)
                    }
                }
                })
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
    
    private func initializePermissonData() ->Void{
        self.permissionData = []
        var model = ChildEquipmentsPermission()
        model.mainItem = "观看权限"
        model.onTitle = "能看宝宝"
        model.offTitle = "不能看宝宝"
        self.permissionData.append(model)
        
        model = ChildEquipmentsPermission()
        model.mainItem = "声音权限"
        model.onTitle = "能听声音"
        model.offTitle = "不能听声音"
        self.permissionData.append(model)
        
        HUD.showHud("正在加载...", onView: self.view)
        dispatch_queue_create("loadPermissionQueue", nil).queue { 
            ChildEquipmentsPermission.sendAsyncChildEquipmentsPermissionDetail(self.childEquipment.idUserChildEqmInfo) { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    dispatch_get_main_queue().queue({
                        HUD.hideHud(weakSelf.view)
                    })
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            weakSelf.permissionData.removeAll()
                            if let permission = ChildEquipmentsPermissionBL.findAll(weakSelf.childEquipment.idUserChildEqmInfo).first{
                                model = ChildEquipmentsPermission()
                                model.idUserChildEqmPermission = permission.idUserChildEqmPermission
                                model.mainItem = "观看权限"
                                model.onTitle = "能看宝宝"
                                model.offTitle = "不能看宝宝"
                                model.eqmPermission = permission.imagePermission == "1" ? true : false
                                weakSelf.permissionData.append(model)
                                model = ChildEquipmentsPermission()
                                model.idUserChildEqmPermission = permission.idUserChildEqmPermission
                                model.mainItem = "声音权限"
                                model.onTitle = "能听声音"
                                model.offTitle = "不能听声音"
                                model.eqmPermission = permission.voicePermission == "1" ? true : false
                                weakSelf.permissionData.append(model)
                                dispatch_get_main_queue().queue({
                                    if let table = weakSelf.permissionTable{
                                        table.reloadData()
                                    }
                                })
                            }
                        }
                    }
                }
            }
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
