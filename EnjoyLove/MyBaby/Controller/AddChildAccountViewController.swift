//
//  AddChildAccountViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/6.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
let addChildTableViewCellHeight = upRateWidth(40)
private let addFinishButtonViewHeight = upRateHeight(80)
class AddChildAccountViewController: BaseViewController ,UITableViewDelegate,UITableViewDataSource{

    private var addAccountData:[AddChildAccount]!
    private var addAccountTable:UITableView!
    private var tableRowHeight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(title: "添加新的子账号", leftSel: nil, rightSel: nil)
        self.navigationBarItem(false, title: "添加新的子账号", leftSel: nil, rightSel: #selector(self.addConfirmClick), rightTitle: "添加")
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
    
    func addConfirmClick() -> Void {
        
    }
    
    private func initialize(){
        self.addAccountData = []
        
        var detail:[AccountDetail] = []
        var subModel = AccountDetail()
        subModel.mainItem = "输入对方手机号"
        subModel.subItem = "输入对方手机号"
        detail.append(subModel)
        
        subModel = AccountDetail()
        subModel.mainItem = "名字"
        subModel.subItem = "更名"
        detail.append(subModel)
        
        var mainModel = AddChildAccount(title: "子账号设置", detail: detail)
        self.addAccountData.append(mainModel)
        
        detail = []
        subModel = AccountDetail()
        subModel.mainItem = "设备1"
        subModel.devicePermisson = 0
        subModel.deviceId = 1
        detail.append(subModel)
        
        subModel = AccountDetail()
        subModel.mainItem = "设备2"
        subModel.devicePermisson = 1
        subModel.deviceId = 2
        detail.append(subModel)
        
        mainModel = AddChildAccount(title: "设备权限", detail: detail)
        self.addAccountData.append(mainModel)
        
        self.tableRowHeight = (ScreenHeight - navigationBarHeight - 60) * (1 / 12) > 44 ? (ScreenHeight - navigationBarHeight - 60) * (1 / 12) : 44
        self.addAccountTable = UITableView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: ScreenWidth - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight), style: .Plain)
        self.addAccountTable.backgroundColor = UIColor.whiteColor()
        self.addAccountTable.separatorInset = UIEdgeInsetsZero
        self.addAccountTable.layoutMargins = UIEdgeInsetsZero
        self.addAccountTable.rowHeight = self.tableRowHeight
        self.addAccountTable.delegate = self
        self.addAccountTable.dataSource = self
        self.addAccountTable.registerClass(AddAccountCell.self, forCellReuseIdentifier: NSStringFromClass(AddAccountCell))
        self.view.addSubview(self.addAccountTable)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.addAccountData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.addAccountData[section].detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(AddAccountCell)) as? AddAccountCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            switch indexPath.section {
            case 0:
                resultCell.accessoryType = .DisclosureIndicator
            default:
                break
            }
            if let modelData = self.addAccountData[indexPath.section].detail {
                if modelData.count > 0 {
                    let model = modelData[indexPath.row]
                    resultCell.refreshCell(model, row: indexPath.row)
                }
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
        if indexPath.section == 1 {
            if let modelData = self.addAccountData[indexPath.section].detail {
                if modelData.count > 0 {
                    let model = modelData[indexPath.row]
                    let permission = ChildPermissionViewController()
                    permission.detail = model
                    self.navigationController?.pushViewController(permission, animated: true)
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
