//
//  BabyInfoEditViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/18.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

protocol BabyEditDelegate{
    func fetchBabyInfo(baby:BabyInfo)
    func sexStatus(status:Int)
}

class BabyInfoEditViewController: BaseViewController{

    var babyModel:BabyInfo!
    var editDelegate:BabyEditDelegate!
    var sexStatus = -1
    private var birthdayButton:UIButton!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, isImage: false, title: babyModel.mainItem, leftSel: nil, rightSel: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        switch self.babyModel.infoType {
        case 0:
            let editNameView = EditNameView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), completionHandler: { [weak self](txt) in
                if let weakSelf = self{
                    if txt != ""{
                        if let baby = BabyListBL.find(weakSelf.babyModel.babyId){
                            HUD.showHud("正在提交...", onView: weakSelf.view)
                            BabyList.sendAsyncModifyBaby(baby.idUserBabyInfo, babyName: txt, sex: baby.sex, birthday: baby.birthday, isCurr: baby.isCurr, completionHandler: { (errorCode, msg) in
                                HUD.hideHud(weakSelf.view)
                                if let error = errorCode{
                                    if error == BabyZoneConfig.shared.passCode{
                                        weakSelf.babyModel.subItem = txt
                                        if weakSelf.editDelegate != nil {
                                            weakSelf.editDelegate.fetchBabyInfo(weakSelf.babyModel)
                                        }
                                    }else{
                                        HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                    }
                                }
                                weakSelf.navigationController?.popViewControllerAnimated(true)

                            })
                        }
                    }
                }
                })
            self.view.addSubview(editNameView)
        case 1:
            self.navigationBarItem(self, isImage: false, title: "性别", leftSel: nil, rightSel: nil)
            self.sexStatus = Int(self.babyModel.subItem) == nil ? -1 : Int(self.babyModel.subItem)!
            let editSexView = EditSexView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), isMale: self.sexStatus, completionHandler: { [weak self](sex, sexId) in
                if let weakSelf = self{
                    if let sId = Int(sexId){
                        if sId == 1 || sId == 2{
                            if let baby = BabyListBL.find(weakSelf.babyModel.babyId){
                                HUD.showHud("正在提交...", onView: weakSelf.view)
                                BabyList.sendAsyncModifyBaby(baby.idUserBabyInfo, babyName: baby.babyName, sex: "\(sId)", birthday: baby.birthday, isCurr: baby.isCurr, completionHandler: { (errorCode, msg) in
                                    HUD.hideHud(weakSelf.view)
                                    if let error = errorCode{
                                        if error == BabyZoneConfig.shared.passCode{
                                            weakSelf.babyModel.subItem = sex
                                            weakSelf.editDelegate.sexStatus(Int(sexId) == nil ? -1 : Int(sexId)!)
                                            if weakSelf.editDelegate != nil{
                                                weakSelf.editDelegate.fetchBabyInfo(weakSelf.babyModel)
                                            }
                                            weakSelf.navigationController?.popViewControllerAnimated(true)
                                        }else{
                                            HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                            weakSelf.navigationController?.popViewControllerAnimated(true)
                                        }
                                    }else{
                                        HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                        weakSelf.navigationController?.popViewControllerAnimated(true)
                                    }
                                })
                            }
                        }
                    }
                }
            })
            self.view.addSubview(editSexView)
        case 2:
            break
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func datePickerReturn(dateString: String!) {
        self.babyModel.subItem = dateString
        self.birthdayButton.setTitle(self.babyModel.subItem, forState: .Normal)
        if self.editDelegate != nil {
            self.editDelegate.fetchBabyInfo(self.babyModel)
            self.navigationController?.popViewControllerAnimated(true)
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
