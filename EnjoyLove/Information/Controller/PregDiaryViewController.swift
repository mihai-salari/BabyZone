//
//  PregDairyViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/30.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
private let pregdiaryTableViewCellId = "pregdiaryTableViewCellId"

class PregDiaryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    private var diaryTable:UITableView!
    private var diaryData:[Diary]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self, isImage: true, title: "孕育日记", leftSel: #selector(PregDiaryViewController.menuClick), leftImage: "baby_menu.png", leftItemSize: CGSize(width: 20, height: 15), rightSel: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(PregDiaryViewController.createDiaryClick))
        
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
    
    private func initialize() -> Void{
        
        self.diaryData = DiaryBL.findAll()
        
        let diaryNavView = DiaryListHeaderView.init(frame: CGRectMake(0, navigationBarHeight, CGRectGetWidth(self.view.frame), upRateHeight(40))) { (month, year,day) in
            print("year \(year) month \(month), day \(day)")
        }
        self.view.addSubview(diaryNavView)
        
        self.diaryTable = UITableView.init(frame: CGRectMake(viewOriginX, CGRectGetMaxY(diaryNavView.frame) + viewOriginY, pregDiaryViewWidth, ScreenHeight - 3 * viewOriginY - tabBarHeight - CGRectGetHeight(diaryNavView.frame)), style: .Plain)
        self.diaryTable.delegate = self
        self.diaryTable.dataSource = self
        self.diaryTable.separatorColor = UIColor.hexStringToColor("#de7a85")
        self.diaryTable.separatorInset = UIEdgeInsetsZero
        self.diaryTable.layoutMargins = UIEdgeInsetsZero
        self.diaryTable.showsVerticalScrollIndicator = false
        self.diaryTable.registerClass(DiaryListCell.self, forCellReuseIdentifier: pregdiaryTableViewCellId)
        self.diaryTable.separatorStyle = .None
        self.view.addSubview(self.diaryTable)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diaryData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pregdiaryTableViewCellId) as? DiaryListCell
        cell?.selectionStyle = .None
        cell?.refreshCell(self.diaryData[indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return pregDiaryRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.diaryData[indexPath.row]
        let diaryVC = DiaryDetailViewController()
//        diaryVC.model = model
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    
    func createDiaryClick() -> Void {
        let diaryRecord = DiaryRecordViewController()
        self.navigationController?.pushViewController(diaryRecord, animated: true)
        
    }
    
    func menuClick() -> Void {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
