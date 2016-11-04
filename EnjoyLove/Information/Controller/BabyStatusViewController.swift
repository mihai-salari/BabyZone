//
//  BabyStatusViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/8.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyStatusViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

//    private var statusData:[BabyStatus]!
    var infoType:String = ""
    private var articleTypeListData:[ArticleTypeList]!
    private var babyStatusTable:UITableView!
    private var openStr:String!
    private var openArray:[String]!
    private var isOpen:Bool!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "育儿资讯", leftSel:nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    private func initialize() -> Void{
        
        self.articleTypeListData = []
        self.openStr = ""
        self.openArray = []
        self.isOpen = false
        HUD.showHud("正在加载...", onView: self.view)
        dispatch_queue_create("loadTypeListQueue", nil).queue { 
            ArticleTypeList.sendAsyncArticleList(Localize.currentLanguage()) { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    dispatch_get_main_queue().queue({
                        HUD.hideHud(weakSelf.view)
                    })
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            let typeList = ArticleTypeListBL.findAll()
                            if typeList.count > 0{
                                weakSelf.articleTypeListData.appendContentsOf(typeList)
                                dispatch_get_main_queue().queue({ 
                                    if let table = weakSelf.babyStatusTable{
                                        table.reloadData()
                                    }
                                })
                            }else{
                                dispatch_get_main_queue().queue({ 
                                    HUD.showText("暂无数据", onView: weakSelf.view)
                                })
                            }
                        }else{
                            dispatch_get_main_queue().queue({ 
                                HUD.showText("网络出错:\(msg!)", onView: weakSelf.view)
                            })
                        }
                    }else{
                        dispatch_get_main_queue().queue({ 
                            HUD.showText("网络出错:\(msg!)", onView: weakSelf.view)
                        })
                    }
                }
            }
        }
        
        self.babyStatusTable = UITableView.init(frame: CGRectMake(viewOriginX, navigationBarHeight , CGRectGetWidth(self.view.frame) - 2 * viewOriginX, ScreenHeight - navigationBarHeight), style: .Plain)
        self.babyStatusTable.layer.cornerRadius = 2
        self.babyStatusTable.layer.masksToBounds = true
        self.babyStatusTable.separatorColor = UIColor.colorFromRGB(225, g: 104, b: 108)
        self.babyStatusTable.separatorInset = UIEdgeInsetsZero
        self.babyStatusTable.layoutMargins = UIEdgeInsetsZero
        self.babyStatusTable.dataSource = self
        self.babyStatusTable.delegate = self
        self.babyStatusTable.tableFooterView = UIView.init()
        self.babyStatusTable.rowHeight = upRateHeight(100)
        self.babyStatusTable.registerClass(BabyStatusCell.self, forCellReuseIdentifier: NSStringFromClass(BabyStatusCell))
        self.view.addSubview(self.babyStatusTable)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.articleTypeListData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.openArray.contains("\(section)") {
            return self.articleTypeListData[section].articleList == nil ? 0 : self.articleTypeListData[section].articleList.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(BabyStatusCell)) as! BabyStatusCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.accessoryType = .DisclosureIndicator
        cell.refreshCell(self.articleTypeListData[indexPath.section].articleList[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let mainModel = self.articleTypeListData[section]
        let selectButton = BabyStatusButton(type: .Custom)
        selectButton.frame = CGRectMake(0, 0, CGRectGetWidth(tableView.frame), 44)
        selectButton.setImageRect(CGSizeMake(20, 20), normaImage: "button_triangle_down.png", selectedImage: "button_triangle_up.png", normalTitle: mainModel.typeName, fontSize: upRateWidth(16))
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
        
        HUD.showHud("正在加载...", onView: self.view)
        let type = self.articleTypeListData[btn.tag]
        
        ArticleList.sendAsyncArticleList("30", pageIndex: "1", newsType: self.infoType, year: type.year, month: type.month, languageSign: Localize.currentLanguage()) { [weak self](errorCode, msg) in
            if let weakSelf = self{
                dispatch_get_main_queue().queue({
                    HUD.hideHud(weakSelf.view)
                })
                if let err = errorCode{
                    if err == BabyZoneConfig.shared.passCode{
                        let list = ArticleListBL.findAll()
                        if list.count > 0{
                            btn.selected = !btn.selected
                            weakSelf.isOpen = btn.selected == true ? true : false
                            weakSelf.openStr = "\(btn.tag)"
                            if weakSelf.openArray.contains(weakSelf.openStr) {
                                if let index = weakSelf.openArray.indexOf(weakSelf.openStr) {
                                    weakSelf.openArray.removeAtIndex(index)
                                }
                            }else{
                                weakSelf.openArray.append(weakSelf.openStr)
                            }
                            
                            weakSelf.articleTypeListData[btn.tag].articleList = list
                            if let table = weakSelf.babyStatusTable{
                                table.reloadSections(NSIndexSet.init(index: btn.tag), withRowAnimation: .Fade)
                            }
                        }else{
                            HUD.showText("暂无数据", onView: weakSelf.view)
                        }
                    }else{
                        HUD.showText("加载数据失败:\(msg!)", onView: weakSelf.view)
                    }
                }else{
                    HUD.showText("加载数据失败:\(msg!)", onView: weakSelf.view)
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
