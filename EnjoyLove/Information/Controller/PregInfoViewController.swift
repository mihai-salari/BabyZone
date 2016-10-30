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
    private var pregBabyData:[BabyBaseInfo]!
    private var pregInfoStatusData:[PregInfoStatus]!
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationBarItem(self, title: self.infoType == "1" ? "育儿资讯" : "孕育资讯", leftSel:nil, rightSel: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkChangeNotification(_:)), name: kReachabilityChangedNotification, object: nil)
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
        self.pregBabyData = []
        self.pregInfoStatusData = []
        HUD.showHud("正在加载...", onView: self.view)
        dispatch_queue_create("babyListQueue", nil).queue {
            
            Diary.sendAsyncUserNoteList("1", year: "", month: "", completionHandler: nil)
            NoteLabel.sendAsyncUserNoteLabel(nil)
            
            var idUserBabyInfo = ""
            let babyList = BabyListBL.findAll()
            if babyList.count > 0{
                idUserBabyInfo = babyList[0].idUserBabyInfo
            }
            self.currentBabyId = idUserBabyInfo
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
                        if let ifo = info{
                            articleId = ifo.idBbsNewsInfo
                            recoments.append(ifo)
                        }else{
                            let recoment = Article()
                            recoment.title = "暂无数据"
                            recoment.content = "暂无数据"
                            recoment.idBbsNewsInfo = ""
                            recoment.createTime = "0000.00.00"
                            recoment.contentTotalHeight = 80
                            recoments.append(recoment)
                            articleId = "-1"
                            articleErrorTip = "暂无咨询数据"
                        }
                        let pregInfoStatus = PregInfoStatus(pregStatusImage: "preStatus.png", pregStatusDesc: weakSelf.infoType == "1" ? "本周孕育状态" : "本周宝宝状态", pregInfoData: recoments, pregBabyId: "0", pregMoreImage: "pregMore.png")
                        weakSelf.pregInfoStatusData.append(pregInfoStatus)
                        
                        dispatch_get_main_queue().queue({
                            HUD.hideHud(weakSelf.view)
                            if babyId == "-1"{
                                HUD.showText(babyErrorTip, onView: weakSelf.view.window!)
                            }
                            if articleId == "-1"{
                                HUD.showText(articleErrorTip, onView: weakSelf.view.window!)
                            }
                            
                            weakSelf.pregView = PregInfoView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, (ScreenHeight - navAndTabHeight) * (2 / 3)), babyModel: weakSelf.pregBabyData[0], switchCompletionHandler: {
                                let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
                                let babyList = BabyListBL.findAll()
                                if babyList.count > 0{
                                    for itemModel in BabyListBL.findAll(){
                                        let action = UIAlertAction.init(title: itemModel.babyName, style: .Default, handler: { (action:UIAlertAction) in
                                            if itemModel.idUserBabyInfo == weakSelf.pregBabyData[0].idUserBabyInfo{
                                                return
                                            }
                                            weakSelf.currentBabyId = itemModel.idUserBabyInfo
                                            weakSelf.reloadDataVia(itemModel.idUserBabyInfo)
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
                                    
                                    weakSelf.presentViewController(actionSheet, animated: true, completion: nil)
                                }
                                }, recordCompletionHandler: { [weak self] in
                                    if let weakSelf = self{
                                        let recordList = DiaryBL.findAll()
                                        if recordList.count > 0{
                                            let diaryListVC = PregDiaryViewController()
                                            weakSelf.navigationController?.pushViewController(diaryListVC, animated: true)
                                        }else{
                                            let diary = DiaryRecordViewController()
                                            weakSelf.navigationController?.pushViewController(diary, animated: true)
                                        }
                                    }
                                })
                            weakSelf.view.addSubview(weakSelf.pregView)
                            
                            weakSelf.pregTableView = PregTableView.init(frame: CGRect.init(x: viewOriginX, y: weakSelf.pregView.frame.maxY, width: ScreenWidth - 2 * viewOriginX, height: (ScreenHeight - tabBarHeight) * (1 / 3) - 20), style: .Grouped, dataSource: weakSelf.pregInfoStatusData, dataCompletionHandler: { (model, indexPath) in
                                if let weakSelf = self{
                                    switch indexPath.section{
                                    case 0:
                                        let babyStatus = BabyStatusViewController()
                                        babyStatus.infoType = infoType
                                        weakSelf.navigationController?.pushViewController(babyStatus, animated: true)
                                    case 1:
                                        break
//                                        let babyProblem = ProblemViewController()
//                                        weakSelf.navigationController?.pushViewController(babyProblem, animated: true)
                                    default:
                                        break
                                    }
                                }

                                }, moreMenuCompletionHandler: { (model) in
                                    
                                }, shareCompletionHandler: { (model) in
                                    
                            })
                            weakSelf.view.addSubview(weakSelf.pregTableView)
                        })
                                                
                    })
                }
                })
        }
        
        
        
//        
//        let pregTableView = PregTableView.init(frame: CGRectMake(viewOriginX, CGRectGetMaxY(self.pregView.frame), ScreenWidth - 2 * viewOriginX, (ScreenHeight - tabBarHeight) * (1 / 3) - 20), style: .Grouped, dataSource: self.pregInfoStatusData, dataCompletionHandler: { [weak self](model, indexPath) in
//            if let weakSelf = self{
//                switch indexPath.section{
//                case 0:
//                    let babyStatus = BabyStatusViewController()
//                    weakSelf.navigationController?.pushViewController(babyStatus, animated: true)
//                case 1:
//                    let babyProblem = ProblemViewController()
//                    weakSelf.navigationController?.pushViewController(babyProblem, animated: true)
//                default:
//                    break
//                }
//            }
//            }, moreMenuCompletionHandler: { (model) in
//                print("date \(model.creatTime)")
//        }) { (model) in
//            print("date \(model.creatTime)")
//        }
        
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
                                        let pregInfoStatus = PregInfoStatus(pregStatusImage: "preStatus.png", pregStatusDesc: weakSelf.infoType == "2" ? "本周孕育状态" : "本周宝宝状态", pregInfoData: [ifo], pregBabyId: "0", pregMoreImage: "pregMore.png")
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
                                }
                            }else{
                                HUD.showText("数据切换失败:\(msg!)", onView: weakSelf.view)
                            }
                        }else{
                            HUD.showText("数据切换失败:\(msg!)", onView: weakSelf.view)
                        }
                    })
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
