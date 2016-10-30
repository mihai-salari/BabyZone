//
//  BabyStatusViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/8.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyStatusViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    private var statusData:[BabyStatus]!
    private var babyStatusTable:UITableView!
    private var openStr:String!
    private var openArray:[String]!
    private var isOpen:Bool!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self, title: "育儿资讯", leftSel:nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.initializeData()
        self.initializeSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    private func initializeData(){
        
        
        self.openStr = ""
        self.openArray = []
        self.statusData = []
        self.isOpen = false
        var detailData = [StatusDetail]()
        for _ in 0 ..< 5 {
            let detail = StatusDetail(detailImage: "babyStatus.png", detailMainItem: "宝宝开始具备抓取物体的能力", detailOutline: "抓握是一项重要的宝宝发育里程碑，只有学会抓握，他才能开始玩耍。抓握也是宝宝自己吃饭、看书、写字、画画和照顾自己的第一步。")
            detailData.append(detail)
        }
        
        for i in 0 ..< 11 {
            
            let status = BabyStatus(statusTime: "2岁\(i + 1)个月", statusId: "\(i + 1)", statusDetial: detailData)
            self.statusData.append(status)
        }
    }
    
    
    private func initializeSubviews(){
        self.babyStatusTable = UITableView.init(frame: CGRectMake(viewOriginX, navigationBarHeight + viewOriginY, CGRectGetWidth(self.view.frame) - 2 * viewOriginX, ScreenHeight - navigationBarHeight - 2 * viewOriginY), style: .Grouped)
        self.babyStatusTable.layer.cornerRadius = 2
        self.babyStatusTable.layer.masksToBounds = true
        self.babyStatusTable.separatorColor = UIColor.colorFromRGB(225, g: 104, b: 108)
        self.babyStatusTable.separatorInset = UIEdgeInsetsZero
        self.babyStatusTable.layoutMargins = UIEdgeInsetsZero
        self.babyStatusTable.dataSource = self
        self.babyStatusTable.delegate = self
        self.babyStatusTable.tableHeaderView = UIView.init(frame: CGRectMake(0, 0, 0, 0.0001))
        self.babyStatusTable.rowHeight = upRateHeight(100)
        self.babyStatusTable.registerClass(BabyStatusCell.self, forCellReuseIdentifier: NSStringFromClass(BabyStatusCell))
        self.view.addSubview(self.babyStatusTable)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.statusData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.openArray.contains("\(section)") {
            let mainModel = self.statusData[section]
            return mainModel.statusDetial.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(BabyStatusCell)) as! BabyStatusCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.accessoryType = .DisclosureIndicator
        let mainModel = self.statusData[indexPath.section]
        cell.refreshCell(mainModel.statusDetial[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainModel = self.statusData[section]
        let selectButton = BabyStatusButton(type: .Custom)
        selectButton.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44)
        selectButton.setImageRect(CGSizeMake(20, 20), normaImage: "button_triangle_down.png", selectedImage: "button_triangle_up.png", normalTitle: mainModel.statusTime, fontSize: upRateWidth(16))
        selectButton.setCustomTitleColor(UIColor.hexStringToColor("#400a33"))
        selectButton.backgroundColor = UIColor.whiteColor()
        if self.isOpen == true {
            selectButton.selected = true
        }else{
            selectButton.selected = false
        }
        selectButton.tag = section
        selectButton.addCustomTarget(self, sel: #selector(BabyStatusViewController.toggleListClick(_:)))
        let line = UIView.init(frame: CGRectMake(0, CGRectGetHeight(selectButton.frame) - lineWH, CGRectGetWidth(selectButton.frame), lineWH))
        line.backgroundColor = UIColor.hexStringToColor("#dc6574")
        selectButton.addSubview(line)
        
        return selectButton
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let mainModel = self.statusData[indexPath.section]
//        let subModel = mainModel.statusDetial[indexPath.row]
        let detail = StatusDetailViewController()
        self.navigationController?.pushViewController(detail, animated: true)
    }

    func toggleListClick(btn:BabyStatusButton) -> Void {
        btn.selected = !btn.selected
        self.isOpen = btn.selected == true ? true : false
        self.openStr = "\(btn.tag)"
        if self.openArray.contains(self.openStr) {
            if let index = self.openArray.indexOf(self.openStr) {
                self.openArray.removeAtIndex(index)
            }
        }else{
            self.openArray.append(self.openStr)
        }
        self.babyStatusTable.reloadSections(NSIndexSet.init(index: btn.tag), withRowAnimation: .Fade)
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
