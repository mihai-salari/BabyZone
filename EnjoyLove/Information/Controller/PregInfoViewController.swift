//
//  PregInfoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class PregInfoViewController: BaseViewController {

    private var pregView:PregInfoView!
    private var pregBabyData:[BabyBaseInfo]!
    private var pregInfoStatusData:[PregInfoStatus]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, title: "育儿资讯", leftSel:nil, rightSel: nil)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeData()
        self.initializeSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeData(){
        dispatch_queue_create("diaryListQueue", nil).queue {
            
            BabyBaseInfo.sendAsyncBabyBaseInfo({ [weak self](errorCode, msg) in
                if let weakSelf = self{
                    if let pregInfo = weakSelf.pregView{
                        if BabyBaseInfoBL.findAll().count > 0{
                            pregInfo.refreshViews(<#T##model: PregBabyInfo##PregBabyInfo#>)
                        }
                    }
                }
            })
            
            Diary.sendAsyncUserNoteList("1", year: "", month: "", completionHandler: nil)
            NoteLabel.sendAsyncUserNoteLabel(nil)
        }
        
        
        self.pregBabyData = []
        self.pregInfoStatusData = []
        
//        var babyModel = PregBabyInfo(pregBabyDate: "36周宝宝", pregDate: "孕期46周+5天", pregProgress: 80, pregWeight: "4.1~7.7", pregHeight: "55.8~66.4", pregOutDay: "20", pregBabyImage: "pregBaby.png")
        var babyModel = BabyBaseInfo()
        babyModel.idComBabyBaseInfo = ""
        babyModel.infoType = "1"
        babyModel.day = "100"
        babyModel.idUserBabyInfo = ""
        babyModel.minWeight = "0"
        babyModel.maxWeight = "0"
        babyModel.minHeight = "0"
        babyModel.maxHeight = "0"
        babyModel.minHead = "0"
        babyModel.maxHead = "0"
        self.pregBabyData.append(babyModel)
        
        var infoData:[InfoStatus] = []
        
        var statusCellModel = InfoStatus(pregMainImage: "", pregItem: "宝宝开始具备抓取物体能力", pregSubItem: "玩具上松动的零件，毛绒玩具未粘牢的眼睛，鼻子，玩具上掉落的纽扣，这些小零件玩具上松动的零件，毛绒玩具未粘牢的眼睛，鼻子，玩具上掉落的纽扣", pregItemId: "1", pregItemDate: "2016.10.15", pregCellHeight: 80)
        infoData.append(statusCellModel)
        
        var pregInfoStatus = PregInfoStatus(pregStatusImage: "preStatus.png", pregStatusDesc: "本周宝宝状态", pregInfoData: infoData, pregBabyId: "0", pregMoreImage: "pregMore.png")
        self.pregInfoStatusData.append(pregInfoStatus)
        
    }
    
    private func initializeSubviews(){
        self.pregView = PregInfoView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, (ScreenHeight - navAndTabHeight) * (2 / 3)), babyModel: self.pregBabyData[0], switchCompletionHandler: {
            let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
            
            for itemModel in self.pregBabyData{
                
                let action = UIAlertAction.init(title: itemModel.pregBabyDate, style: .Default, handler: { (action:UIAlertAction) in
                    
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
            }, recordCompletionHandler: { [weak self] in
                if let weakSelf = self{
                    let diary = DiaryRecordViewController()
                    weakSelf.navigationController?.pushViewController(diary, animated: true)
                }
        })
        self.view.addSubview(self.pregView)
        
        let pregTableView = PregTableView.init(frame: CGRectMake(viewOriginX, CGRectGetMaxY(self.pregView.frame), ScreenWidth - 2 * viewOriginX, (ScreenHeight - tabBarHeight) * (1 / 3) - 20), style: .Grouped, dataSource: self.pregInfoStatusData, dataCompletionHandler: { [weak self](model, indexPath) in
            if let weakSelf = self{
                switch indexPath.section{
                case 0:
                    let babyStatus = BabyStatusViewController()
                    weakSelf.navigationController?.pushViewController(babyStatus, animated: true)
                case 1:
                    let babyProblem = ProblemViewController()
                    weakSelf.navigationController?.pushViewController(babyProblem, animated: true)
                default:
                    break
                }
            }
            }, moreMenuCompletionHandler: { (model) in
                print("date \(model.pregItemDate)")
        }) { (model) in
            print("date \(model.pregItemDate)")
        }
        
        self.view.addSubview(pregTableView)
        
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
