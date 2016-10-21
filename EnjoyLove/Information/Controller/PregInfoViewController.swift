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
    private var pregBabyData:[PregBabyInfo]!
    private var pregInfoStatusData:[PregInfoStatus]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationBarItem(title: "育儿资讯", leftSel:nil, rightSel: nil)
        
        
        
        
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
        self.pregBabyData = []
        self.pregInfoStatusData = []
        
        let babyData = BabyListBL.findAll()
        if babyData.count > 0 {
            
        }else{
            
        }
        
        var babyModel = PregBabyInfo(pregBabyDate: "36周宝宝", pregDate: "孕期46周+5天", pregProgress: 80, pregWeight: "4.1~7.7", pregHeight: "55.8~66.4", pregOutDay: "20", pregBabyImage: "pregBaby.png")
        self.pregBabyData.append(babyModel)
        babyModel = PregBabyInfo(pregBabyDate: "56周宝宝", pregDate: "孕期56周+5天", pregProgress: 75, pregWeight: "4.1~7.7", pregHeight: "55.8~66.4", pregOutDay: "16", pregBabyImage: "pregBaby.png")
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
