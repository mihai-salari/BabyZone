//
//  PregInfoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class PregInfoViewController: BaseViewController {

//    var babyInfo:BabyBaseInfo!
//    var recoment:Article!
    private var infoType:String = "1"
    private var pregView:PregInfoView!
    private var pregTableView:PregTableView!
    private var pregBabyData:[BabyBaseInfo]!
    private var pregInfoStatusData:[PregInfoStatus]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationBarItem(self, title: self.infoType == "1" ? "孕育资讯" : "育儿资讯", leftSel:nil, rightSel: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
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
        dispatch_queue_create("babyListQueue", nil).queue {
            
            Diary.sendAsyncUserNoteList("15", year: "", month: "", completionHandler: nil)
            NoteLabel.sendAsyncUserNoteLabel(nil)
            
            var idUserBabyInfo = ""
            let babyList = BabyListBL.findAll()
            if babyList.count > 0{
                idUserBabyInfo = babyList[0].idUserBabyInfo
            }
            BabyBaseInfo.sendAsyncBabyBaseInfo(idUserBabyInfo, completionHandler: { [weak self](errorCode, msg, baseInfo) in
                if let weakSelf = self{
                    var infoType = "1"
                    if let base  = baseInfo {
                        infoType = base.infoType
                        weakSelf.pregBabyData.append(base)
                    }else{
                        let babyModel = BabyBaseInfo()
                        babyModel.idComBabyBaseInfo = ""
                        babyModel.infoType = infoType
                        babyModel.day = "100"
                        babyModel.idUserBabyInfo = ""
                        babyModel.minWeight = "0"
                        babyModel.maxWeight = "0"
                        babyModel.minHeight = "0"
                        babyModel.maxHeight = "0"
                        babyModel.minHead = "0"
                        babyModel.maxHead = "0"
                        weakSelf.pregBabyData.append(babyModel)
                    }
                    
                    dispatch_get_main_queue().queue({
                        weakSelf.pregView = PregInfoView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, (ScreenHeight - navAndTabHeight) * (2 / 3)), babyModel: weakSelf.pregBabyData[0], switchCompletionHandler: {
                            let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
                            let babyList = BabyListBL.findAll()
                            if babyList.count > 0{
                                for itemModel in BabyListBL.findAll(){
                                    let action = UIAlertAction.init(title: itemModel.babyName, style: .Default, handler: { (action:UIAlertAction) in
                                        if itemModel.idUserBabyInfo == weakSelf.pregBabyData[0].idUserBabyInfo{
                                            return
                                        }
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
                    })
                    
                    Article.sendAsyncRecomment(infoType, completionHandler: { (errorCode, msg, info) in
                        var recoments:[Article] = []
                        if let ifo = info{
                            recoments.append(ifo)
                        }else{
                            let recoment = Article()
                            recoment.title = "宝宝的玩具如何选择?"
                            recoment.content = "玩具上松动的零件，毛绒玩具未粘牢的眼睛，鼻子，玩具上掉落的纽扣，这些小零件玩具上松动的零件，毛绒玩具未粘牢的眼睛，鼻子，玩具上掉落的纽扣"
                            recoment.idBbsNewsInfo = "1"
                            recoment.createTime = "2016.10.15"
                            recoment.contentTotalHeight = 80
                            recoments.append(recoment)
                        }
                        let pregInfoStatus = PregInfoStatus(pregStatusImage: "preStatus.png", pregStatusDesc: weakSelf.infoType == "1" ? "本周孕育状态" : "本周宝宝状态", pregInfoData: recoments, pregBabyId: "0", pregMoreImage: "pregMore.png")
                        weakSelf.pregInfoStatusData.append(pregInfoStatus)
                        
                        dispatch_get_main_queue().queue({ 
                            weakSelf.pregTableView = PregTableView.init(frame: CGRect.init(x: viewOriginX, y: weakSelf.pregView.frame.maxY, width: ScreenWidth - 2 * viewOriginX, height: (ScreenHeight - tabBarHeight) * (1 / 3) - 20), style: .Grouped, dataSource: weakSelf.pregInfoStatusData, dataCompletionHandler: { (model, indexPath) in
                                
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
