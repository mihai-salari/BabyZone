//
//  SecurityViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/20.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class SecurityViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var personDetail:PersonDetail!
    private var securityData:[SecurityAndAccount]!
    private var securityTable:UITableView!
    var finishedModifyHandler:(()->())?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(title: "账号与安全", leftSel: nil, rightSel: nil)
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize() -> Void{
        
        self.securityData = []
        var security:[Security] = []
        
        var securityModel = Security(mainItem: "手机号", subItem: "13688888888", itemType: 0)
        security.append(securityModel)
        securityModel = Security(mainItem: "微信号", subItem: "未绑定 ", itemType: 1)
        security.append(securityModel)
        var securityAndAccount = SecurityAndAccount(title: "账号", security: security)
        self.securityData.append(securityAndAccount)
        
        security = []
        securityModel = Security(mainItem: "密码", subItem: "修改密码", itemType: 2)
        security.append(securityModel)
        securityModel = Security(mainItem: "隐私", subItem: "已保护 ", itemType: 3)
        security.append(securityModel)
        securityAndAccount = SecurityAndAccount(title: "安全", security: security)
        self.securityData.append(securityAndAccount)
        
        self.securityTable = UITableView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: ScreenWidth - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight), style: .Grouped)
        self.securityTable.backgroundColor = UIColor.hexStringToColor("#feffff")
        self.securityTable.separatorInset = UIEdgeInsetsZero
        self.securityTable.layoutMargins = UIEdgeInsetsZero
        self.securityTable.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        self.securityTable.scrollEnabled = false
        self.securityTable.dataSource = self
        self.securityTable.delegate = self
        self.securityTable.registerClass(SecurityCell.self, forCellReuseIdentifier: NSStringFromClass(SecurityCell))
        self.view.addSubview(self.securityTable)
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.securityData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.securityData[section].security.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(SecurityCell)) as? SecurityCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            let model = self.securityData[indexPath.section].security[indexPath.row]
            resultCell.refreshCell(model)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.hexStringToColor("#60555b")
        let headLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: tableView.frame.width - 40, height: headerView.frame.height))
        let model = self.securityData[section]
        headLabel.text = model.title
        headLabel.textColor = UIColor.whiteColor()
        headLabel.font = UIFont.systemFontOfSize(upRateWidth(14))
        headerView.addSubview(headLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.securityData[indexPath.section].security[indexPath.row]
        let detail = SecurityEditViewController()
        detail.editModel = model
        self.navigationController?.pushViewController(detail, animated: true)
    }

}
