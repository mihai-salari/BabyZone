//
//  PregInfoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class PregInfoViewController: BaseViewController {

    private var infoType:String = "1"
    private var currentBabyId = "-1"
    private var pregView:PregInfoView!
    private var pregTableView:PregTableView!
    private var containView:UIScrollView!
    private var pregBabyData:[BabyBaseInfo]!
    private var pregInfoStatusData:[PregInfoStatus]!
    private var isHasNote:Bool = false
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, isImage: true, title: self.infoType == "1" ? "孕育资讯" : "育儿资讯", leftSel: #selector(self.exchangeBaby), leftImage: "babyExchange.png", leftItemSize: CGSize.init(width: 25, height: 20), rightSel: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loginAndRegistSuccessRefresh), name: LoginBabyListNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkChangeNotification(_:)), name: kReachabilityChangedNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initialize() -> Void{
        
        dispatch_queue_create("loadDiaryQueue", nil).queue { 
            Diary.sendAsyncUserNoteList("1", pageIndex: "1", year: "", month: "", store: false, completionHandler: { [weak self](errorCode, msg, hasNote) in
                if let weakSelf = self{
                    weakSelf.isHasNote = hasNote
                }
            })
        }
        
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        if self.pregBabyData != nil {
            self.pregBabyData = nil
        }
        self.pregBabyData = []
        
        if self.pregInfoStatusData != nil {
            self.pregInfoStatusData = nil
        }
        self.pregInfoStatusData = []
        
        NoteLabel.sendAsyncUserNoteLabel(nil)
        
        var idUserBabyInfo = ""
        let babyList = BabyListBL.findAll()
        if babyList.count > 0{
            idUserBabyInfo = babyList[0].idUserBabyInfo
        }
        self.currentBabyId = idUserBabyInfo
        HUD.showText("正在加载....", onView: UIApplication.sharedApplication().keyWindow!, delay: 3.0)
        BabyBaseInfo.sendAsyncBabyBaseInfo(idUserBabyInfo, completionHandler: { [weak self](errorCode, msg, baseInfo) in
            if let weakSelf = self{
                var infoType = "1"
                var babyId = "-1"
                var babyErrorTip = ""
                if let base  = baseInfo {
                    infoType = base.infoType
                    babyId = base.idComBabyBaseInfo
                    weakSelf.pregBabyData.append(base)
                }else{
                    let babyModel = BabyBaseInfo()
                    babyModel.idComBabyBaseInfo = ""
                    babyModel.infoType = infoType
                    babyModel.day = "0"
                    babyModel.idUserBabyInfo = ""
                    babyModel.minWeight = "0"
                    babyModel.maxWeight = "0"
                    babyModel.minHeight = "0"
                    babyModel.maxHeight = "0"
                    babyModel.minHead = "0"
                    babyModel.maxHead = "0"
                    weakSelf.pregBabyData.append(babyModel)
                    babyErrorTip = "暂无宝宝成长基本数据"
                    babyId = "-1"
                }
                
                Article.sendAsyncRecomment(infoType, completionHandler: { (errorCode, msg, info) in
                    var recoments:[Article] = []
                    var articleId = "-1"
                    var articleErrorTip = ""
                    var contentHeight:CGFloat = 0
                    if let ifo = info{
                        articleId = ifo.idBbsNewsInfo
                        contentHeight += (ifo.contentHeight + ifo.totalImageHeight + ifo.titleHeight + 10 + 45 + weakSelf.view.frame.height * (3 / 4))
                        recoments.append(ifo)
                    }else{
                        let recoment = Article()
                        recoment.title = "暂无数据"
                        recoment.content = "暂无数据"
                        recoment.idBbsNewsInfo = ""
                        recoment.createTime = "2016.10.10"
                        recoment.titleHeight = 15
                        recoment.contentHeight = 20
                        recoment.imageHeight = 45
                        recoments.append(recoment)
                        articleId = "-1"
                        articleErrorTip = "暂无推荐数据"
                        contentHeight += (recoment.contentHeight + recoment.totalImageHeight + recoment.titleHeight + 10 + 80 + 45 + weakSelf.view.frame.height * (2 / 3))
                    }
                    let pregInfoStatus = PregInfoStatus(pregStatusImage: "preStatus.png", pregStatusDesc: weakSelf.infoType == "1" ? "本周孕育状态" : "本周宝宝状态", pregInfoData: recoments, pregBabyId: "0", pregMoreImage: "pregMore.png")
                    weakSelf.pregInfoStatusData.append(pregInfoStatus)
                    
                    if weakSelf.containView != nil{
                        weakSelf.containView.removeFromSuperview()
                        weakSelf.containView = nil
                    }
                    
                    weakSelf.containView = UIScrollView.init(frame: CGRect.init(x: 0, y: navigationBarHeight, width: weakSelf.view.frame.width, height: weakSelf.view.frame.height - navAndTabHeight))
                    weakSelf.containView.showsVerticalScrollIndicator = false
                    weakSelf.containView.contentSize = CGSize.init(width: weakSelf.view.frame.width, height: contentHeight)
                    weakSelf.view.addSubview(weakSelf.containView)
                    
                    
                    if babyId == "-1"{
                        HUD.showText(babyErrorTip, onView: weakSelf.view.window == nil ? weakSelf.view : weakSelf.view.window)
                    }
                    if articleId == "-1"{
                        HUD.showText(articleErrorTip, onView: weakSelf.view.window == nil ? weakSelf.view : weakSelf.view.window)
                    }
                    
                    if weakSelf.pregView != nil{
                        weakSelf.pregView.removeFromSuperview()
                        weakSelf.pregView = nil
                    }
                    
                    
                    weakSelf.pregView = PregInfoView.init(frame: CGRect.init(x: 0, y: 0, width: weakSelf.containView.frame.width, height: weakSelf.view.frame.height * (2 / 3)), babyModel: weakSelf.pregBabyData[0], switchCompletionHandler: nil, recordCompletionHandler: { [weak self] in
                            if let weakSelf = self{
                                if let _ = LoginBL.find(){
                                    if babyId != "-1"{
                                        if weakSelf.isHasNote == true{
                                            let diaryListVC = PregDiaryViewController()
                                            weakSelf.navigationController?.pushViewController(diaryListVC, animated: true)
                                        }else{
                                            let diary = DiaryRecordViewController()
                                            weakSelf.navigationController?.pushViewController(diary, animated: true)
                                        }
                                    }else{
                                        HUD.showText(babyErrorTip, onView: weakSelf.view.window!)
                                    }
                                }
                            }
                        })
                    weakSelf.containView.addSubview(weakSelf.pregView)
                    
                    
                    weakSelf.pregTableView = PregTableView.init(frame: CGRect.init(x: viewOriginX, y: weakSelf.pregView.frame.maxY, width: weakSelf.containView.frame.width - 2 * viewOriginX, height: weakSelf.view.frame.height * (2 / 3)), dataSource: weakSelf.pregInfoStatusData, dataCompletionHandler: { (model, indexPath) in
                        let detailStatus = StatusDetailViewController()
                        detailStatus.detailModel = model
                        weakSelf.navigationController?.pushViewController(detailStatus, animated: true)
                        }, moreMenuCompletionHandler: { (model, selected) in
                            print("selected \(selected)")
                            HUD.showHud(selected == true ? "正在收藏..." : "正在取消...", onView: weakSelf.view)
                            CollectionList.sendAsyncArticleCollection(model.idBbsNewsInfo, operateType: selected == true ? "2" : "1", completionHandler: { (errorCode, msg) in
                                HUD.hideHud(weakSelf.view)
                                if let err = errorCode{
                                    if err == BabyZoneConfig.shared.passCode{
                                        NSNotificationCenter.defaultCenter().postNotificationName(BabyZoneConfig.shared.CollectionChangeNotification, object: nil)
                                        HUD.showText("提交完成", onView: weakSelf.view)
                                    }
                                }
                            })
                        }, shareCompletionHandler: { (model) in
                            
                        }, listCompletionHandler: { 
                            let babyStatus = BabyStatusViewController()
                            babyStatus.infoType = infoType
                            weakSelf.navigationController?.pushViewController(babyStatus, animated: true)
                    })
                    
                   weakSelf.containView.addSubview(weakSelf.pregTableView)
                })
            }
            })
    }
    
    func networkChangeNotification(note:NSNotification) -> Void {
        if let obj = note.object as? Reachability {
            if AppDelegate.sharedDefault().networkStatus == NotReachable && obj.currentReachabilityStatus() != NotReachable {
                self.refreshDataNetworkData()
            }
        }
    }
    
    private func refreshDataNetworkData() ->Void{
        HUD.showHud("重新加载中...", onView: self.view)
        dispatch_queue_create("reloadNetworkDataQueue", nil).queue {
            var infoType = ""
            BabyBaseInfo.sendAsyncBabyBaseInfo(self.currentBabyId, completionHandler: { [weak self](errorCode, msg, baseInfo) in
                if let weakSelf = self{
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode, let base = baseInfo, let preg = self?.pregView{
                            infoType = base.infoType
                            Article.sendAsyncRecomment(infoType, completionHandler: { (errorCode, msg, info) in
                                if let err = errorCode{
                                    if err == BabyZoneConfig.shared.passCode, let ifo = info, let pregTable = weakSelf.pregTableView{
                                        var statusData:[PregInfoStatus] = []
                                        let pregInfoStatus = PregInfoStatus(pregStatusImage: "preStatus.png", pregStatusDesc: weakSelf.infoType == "1" ? "本周孕育状态" : "本周宝宝状态", pregInfoData: [ifo], pregBabyId: "0", pregMoreImage: "pregMore.png")
                                        statusData.append(pregInfoStatus)
                                        
                                        dispatch_get_main_queue().queue({
                                            HUD.hideHud(weakSelf.view)
                                            preg.refreshViews(base)
                                            pregTable.reloadData(statusData)
                                        })
                                    }
                                }
                            })
                        }
                    }
                }
            })
        }
    }
    
    private func reloadDataVia(babyId:String){
        HUD.showHud("正在切换...", onView: self.view)
        dispatch_queue_create("reloadDataQeueu", nil).queue { 
            BabyBaseInfo.sendAsyncBabyBaseInfo(babyId) { [weak self](errorCode, msg, baseInfo) in
                if let weakSelf = self{
                    dispatch_get_main_queue().queue({
                        HUD.hideHud(weakSelf.view)
                        if let err = errorCode{
                            if err == BabyZoneConfig.shared.passCode{
                                if let preg = weakSelf.pregView, let base = baseInfo{
                                    preg.refreshViews(base)
                                    weakSelf.currentBabyId = babyId
                                }
                            }else{
                                HUD.showText("数据切换失败:\(msg!)", onView: weakSelf.view.window == nil ? weakSelf.view : weakSelf.view.window)
                            }
                        }else{
                            HUD.showText("数据切换失败:\(msg!)", onView: weakSelf.view.window == nil ? weakSelf.view : weakSelf.view.window)
                        }
                    })
                }
            }
        }
    }
    
    func loginAndRegistSuccessRefresh() {
        self.initialize()
    }

    func exchangeBaby() -> Void {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        let babyList = BabyListBL.findAll()
        if babyList.count > 0{
            for itemModel in BabyListBL.findAll(){
                let action = UIAlertAction.init(title: itemModel.babyName, style: .Default, handler: { (action:UIAlertAction) in
                    if itemModel.idUserBabyInfo == self.currentBabyId{
                        return
                    }
                    self.reloadDataVia(itemModel.idUserBabyInfo)
                })
                if action.valueForKey("titleTextColor") == nil{
                    action.setValue(alertTextColor, forKey: "titleTextColor")
                }
                actionSheet.addAction(action)
            }
            
            let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (action:UIAlertAction) in
                
            })
            if cancelAction.valueForKey("titleTextColor") == nil{
                cancelAction.setValue(UIColor.darkGrayColor(), forKey: "titleTextColor")
            }
            actionSheet.addAction(cancelAction)
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
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
