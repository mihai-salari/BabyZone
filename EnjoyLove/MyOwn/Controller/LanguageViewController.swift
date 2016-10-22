//
//  LanguageViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/23.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let languageTableViewCellId = "languageTableViewCellId"
class LanguageViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    private var languageTable:UITableView!
    private var languageData:[Language]!
    private var selectedIndexPath:NSIndexPath!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "语言", leftSel: nil, rightSel: nil)
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
        self.languageData = []
        var model = Language(languageType: "中文", languageId: 0, languageUsed: true)
        self.languageData.append(model)
        model = Language(languageType: "EN", languageId: 1, languageUsed: false)
        self.languageData.append(model)
        model = Language(languageType: "日語", languageId: 2, languageUsed: false)
        self.languageData.append(model)
        model = Language(languageType: "Arabic", languageId: 3, languageUsed: false)
        self.languageData.append(model)
        
        let backgroudView = UIView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight))
        backgroudView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(backgroudView)
        
        self.languageTable = UITableView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: ScreenWidth - 2 * viewOriginX, height: CGFloat(self.languageData.count) * 44), style: .Plain)
        self.languageTable.separatorInset = UIEdgeInsetsZero
        self.languageTable.layoutMargins = UIEdgeInsetsZero
        self.languageTable.delegate = self
        self.languageTable.dataSource = self
        self.languageTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: languageTableViewCellId)
        self.view.addSubview(self.languageTable)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.languageData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(languageTableViewCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            let model = self.languageData[indexPath.row]
            resultCell.textLabel?.text = model.languageType
            if model.languageUsed == true {
                self.selectedIndexPath = indexPath
                resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
                resultCell.accessoryType = .Checkmark
            }else{
                resultCell.accessoryType = .None
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == self.selectedIndexPath {
            return
        }
        let everSelectedCell = tableView.cellForRowAtIndexPath(self.selectedIndexPath)
        if let resultCell = everSelectedCell {
            resultCell.accessoryType = .None
        }
        let newSelectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let resultCell = newSelectedCell {
            resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
            resultCell.accessoryType = .Checkmark
        }
        self.selectedIndexPath = indexPath
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
