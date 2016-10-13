//
//  ChildPermissionViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/28.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let ChildPermissionSwitchWidth:CGFloat = 70
private let ChildPermissionSwitchHeight:CGFloat = 20
private let PermissionCellId = "PermissionCellId"
class ChildPermissionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    private var lookSwitch:HMSwitch!
    private var voiceSwitch:HMSwitch!
    var detail:AccountDetail!
    
    private var permissionData:[Permission]!
    private var permissionTable:UITableView!
    private var tableRowheight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(title: "设备权限", leftSel: nil, rightSel: nil)
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
        self.permissionData = []
        var model = Permission(mainItem: "观看权限", onTitle: "能看宝宝", offTitle: "不能看宝宝")
        self.permissionData.append(model)
        
        model = Permission(mainItem: "声音权限", onTitle: "能听声音", offTitle: "不能听声音")
        self.permissionData.append(model)
        
        self.tableRowheight = (ScreenHeight - navigationBarHeight) * (1 / 12)
        self.permissionTable = UITableView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: ScreenHeight - navigationBarHeight), style: .Grouped)
        self.permissionTable.backgroundColor = UIColor.whiteColor()
        self.permissionTable.separatorInset = UIEdgeInsetsZero
        self.permissionTable.layoutMargins = UIEdgeInsetsZero
        self.permissionTable.scrollEnabled = false
        self.permissionTable.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        self.permissionTable.delegate = self
        self.permissionTable.dataSource = self
        self.permissionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: PermissionCellId)
        self.view.addSubview(self.permissionTable)
        
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
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: tableView.frame.width - 15 - ChildPermissionSwitchWidth, y: (resultCell.contentView.frame.height - ChildPermissionSwitchHeight) / 2, width: ChildPermissionSwitchWidth, height: ChildPermissionSwitchHeight))
            onSwitch.on = false
            onSwitch.onLabel.text = self.permissionData[indexPath.row].onTitle
            onSwitch.offLabel.text = self.permissionData[indexPath.row].offTitle
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            resultCell.contentView.addSubview(onSwitch)
        }
        
        return cell!
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
