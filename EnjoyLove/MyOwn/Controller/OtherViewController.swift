//
//  OtherViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/23.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let otherTableViewCellId = "otherTableViewCellId"
class OtherViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {

    private var otherTable:UITableView!
    private var otherData:[OtherItem]!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(title: "其他", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialze()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialze(){
        self.otherData = []
        var model = OtherItem(item: "功能介绍", itemId: 0)
        self.otherData.append(model)
        model = OtherItem(item: "投诉及建议", itemId: 1)
        self.otherData.append(model)
        model = OtherItem(item: "关于享爱", itemId: 2)
        self.otherData.append(model)
        
        let backgroudView = UIView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight))
        backgroudView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backgroudView)
        
        self.otherTable = UITableView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: CGFloat(self.otherData.count) * 44), style: .Plain)
        self.otherTable.separatorInset = UIEdgeInsetsZero
        self.otherTable.layoutMargins = UIEdgeInsetsZero
        self.otherTable.scrollEnabled = false
        self.otherTable.delegate = self
        self.otherTable.dataSource = self
        self.otherTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: otherTableViewCellId)
        self.view.addSubview(self.otherTable)
        
        let scoreButton = UIButton.init(type: .Custom)
        scoreButton.frame = CGRect(x: 15, y: ScreenHeight - 60, width: self.view.frame.width - 30, height: 40)
        scoreButton.setTitle("去评分", forState: .Normal)
        scoreButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        scoreButton.layer.cornerRadius = 20
        scoreButton.layer.masksToBounds = true
        scoreButton.backgroundColor = UIColor.hexStringToColor("#b95360")
        self.view.addSubview(scoreButton)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.otherData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(otherTableViewCellId)
        if let resultCell = cell {
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            let model = self.otherData[indexPath.row]
            resultCell.textLabel?.text = model.item
            resultCell.textLabel?.textColor = UIColor.hexStringToColor("#2a101d")
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let model = self.otherData[indexPath.row]
        
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
