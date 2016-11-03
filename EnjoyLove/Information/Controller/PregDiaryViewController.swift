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
    private var pageIndex:Int = 1
    private var pageSize:Int = 5
    private var year:String = ""
    private var month:String = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self, isImage: true, title: "孕育日记", leftSel: #selector(self.menuClick), leftImage: "baby_menu.png", leftItemSize: CGSize(width: 20, height: 15), rightSel: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(self.createDiaryClick))
        
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
        
        dispatch_queue_create("refreshDataQueue", nil).queue({
            Diary.sendAsyncUserNoteList("\(self.pageSize)", pageIndex: "\(self.pageIndex)", year: self.year, month: self.month, completionHandler: { [weak self](errorCode, msg, hasNote) in
                if let weakSelf = self{
                    if let table = weakSelf.diaryTable{
                        weakSelf.diaryData.removeAll()
                        weakSelf.diaryData = DiaryBL.findAll()
                        dispatch_get_main_queue().queue({
                            table.reloadData()
                            table.pullToRefreshView.stopAnimating()
                        })
                    }
                }
            })
        })
        
        self.diaryData = DiaryBL.findAll()
        
        let diaryNavView = DiaryListHeaderView.init(frame: CGRectMake(0, navigationBarHeight, CGRectGetWidth(self.view.frame), upRateHeight(40))) { (month, year,day) in
        }
        self.view.addSubview(diaryNavView)
        
        self.diaryTable = UITableView.init(frame: CGRect.init(x: viewOriginX, y: diaryNavView.frame.maxY, width: ScreenWidth - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight - diaryNavView.frame.height - 50), style: .Plain)
        self.diaryTable.delegate = self
        self.diaryTable.dataSource = self
        self.diaryTable.separatorColor = UIColor.hexStringToColor("#de7a85")
        self.diaryTable.tableFooterView = UIView.init()
        self.diaryTable.separatorInset = UIEdgeInsetsZero
        self.diaryTable.layoutMargins = UIEdgeInsetsZero
        self.diaryTable.showsVerticalScrollIndicator = false
        self.diaryTable.registerClass(DiaryListCell.self, forCellReuseIdentifier: pregdiaryTableViewCellId)
        self.view.addSubview(self.diaryTable)
        
        self.diaryTable.addPullToRefreshWithActionHandler({
            self.pageIndex += 1
            if self.pageIndex == 30{
                self.pageIndex = 30
            }
            dispatch_queue_create("refreshDataQueue", nil).queue({ 
                Diary.sendAsyncUserNoteList("\(self.pageSize)", pageIndex: "\(self.pageIndex)", year: self.year, month: self.month, completionHandler: { [weak self](errorCode, msg, note) in
                    if let weakSelf = self{
                        if let table = weakSelf.diaryTable{
                            weakSelf.diaryData.removeAll()
                            weakSelf.diaryData = DiaryBL.findAll()
                            dispatch_get_main_queue().queue({
                                table.reloadData()
                                table.pullToRefreshView.stopAnimating()
                            })
                        }
                    }
                })
            })
        })
        
        let commemorateButton = DiaryRecordButton.init(frame: CGRect.init(x: 0, y: ScreenHeight - 50 + (50 - 35) / 2, width: self.view.frame.width, height: 35))
        commemorateButton.setImageRect(CGRectMake(0, 0, 10, 16), image: "arrow_right.png", title: "印刷成纪念画册", fontSize: upRateWidth(16))
        commemorateButton.setCustomTitleColor(UIColor.whiteColor())
        commemorateButton.addCustomTarget(self, sel: #selector(self.commemorateClick))
        self.view.addSubview(commemorateButton)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func triggerTableView() -> Void {
        if let table = self.diaryTable {
            table.triggerPullToRefresh()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diaryData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pregdiaryTableViewCellId) as? DiaryListCell
        if let resultCell = cell {
            resultCell.selectionStyle = .None
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.refreshCell(self.diaryData[indexPath.row])
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return pregDiaryRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let diaryVC = DiaryDetailViewController()
        diaryVC.model = self.diaryData[indexPath.row]
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            HUD.showHud("正在提交...", onView: self.view)
            dispatch_queue_create("deleteDataQueue", nil).queue({
                Diary.sendAsyncDeleteUserNote(self.diaryData[indexPath.row].idUserNoteInfo, completionHandler: { [weak self](errorCode, msg) in
                    if let weakSelf = self{
                        dispatch_get_main_queue().queue({ 
                            HUD.hideHud(weakSelf.view)
                        })
                        if let err = errorCode{
                            if err == BabyZoneConfig.shared.passCode{
                                if let index = weakSelf.diaryData.indexOf(weakSelf.diaryData[indexPath.row]){
                                    weakSelf.diaryData.removeAtIndex(index)
                                    dispatch_get_main_queue().queue({
                                        weakSelf.diaryTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                                    })
                                }
                            }
                        }
                    }
                })
            })
        }
    }
    
    func commemorateClick() -> Void {
        HUD.showText("待开发", onView: self.view)
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
