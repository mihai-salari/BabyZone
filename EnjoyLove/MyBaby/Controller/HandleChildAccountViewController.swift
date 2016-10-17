//
//  HandleChildAccountViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/5.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
class HandleChildAccountViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    private var childList:[ChildEquipment]!
    var childAccountList:[SettingDetail]!
    
    private var childTable:UITableView!
    private var tableRowHeight:CGFloat = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(title: "添加/删除 子账号", leftSel: nil, rightSel: nil)
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
        var mainModel = ChildEquipment()
        mainModel.title = "子账号列表"
        var modelData:[ChildEquipmentList]! = []
        
        for i in 0 ..< self.childAccountList.count - 1 {
            var model = ChildEquipmentList()
            model.userRemark = self.childAccountList[i].mainItem
            modelData.append(model)
        }
        mainModel.eqmChildList = modelData
        modelData = nil
        self.childList.append(mainModel)
        
        mainModel = ChildEquipment()
        mainModel.title = "+ 添加新的子账号"
        self.childList.append(mainModel)
        
        self.tableRowHeight = (ScreenHeight - navigationBarHeight - 30) * (1 / 13)
        self.childTable = UITableView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, ScreenHeight - navigationBarHeight), style: .Grouped)
        self.childTable.backgroundColor = UIColor.whiteColor()
        self.childTable.dataSource = self
        self.childTable.delegate = self
        self.childTable.rowHeight = self.tableRowHeight
        self.childTable.separatorInset = UIEdgeInsetsZero
        self.childTable.layoutMargins = UIEdgeInsetsZero
        self.childTable.registerClass(ChildAccountCell.self, forCellReuseIdentifier: NSStringFromClass(ChildAccountCell))
        self.view.addSubview(self.childTable)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.childList.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.childList[section].eqmChildList == nil ? 0 : self.childList[section].eqmChildList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ChildAccountCell)) as? ChildAccountCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            if let data = self.childList[indexPath.section].eqmChildList {
                let model = data[indexPath.row]
                resultCell.refreshCell(model)
            }
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
            label.text = self.childList[section].title
            label.font = UIFont.systemFontOfSize(13)
            label.textColor = UIColor.whiteColor()
            headView.addSubview(label)
            return headView
        case 1:
            let headButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableRowHeight))
            headButton.backgroundColor = UIColor.hexStringToColor("#f9f4f7")
            headButton.setTitle(self.childList[section].title, forState: .Normal)
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
            if var data = self.childList[indexPath.section].eqmChildList {
                data.removeAtIndex(indexPath.row)
                self.childList[indexPath.section].eqmChildList = data
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
        }
    }
    
    func addNewAccountClick() -> Void {
        let addAccount = AddChildAccountViewController()
        self.navigationController?.pushViewController(addAccount, animated: true)
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
