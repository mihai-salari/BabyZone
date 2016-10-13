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
}

class BabyInfoEditViewController: BaseViewController{

    var babyModel:BabyInfo!
    var editDelegate:BabyEditDelegate!
    private var birthdayButton:UIButton!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBarItem(false, title: babyModel.mainItem, leftSel: nil, rightSel: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch self.babyModel.infoType {
        case 0:
            let editNameView = EditNameView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), completionHandler: { [weak self](txt) in
                if let weakSelf = self{
                    if weakSelf.editDelegate != nil {
                        if txt != ""{
                            weakSelf.babyModel.subItem = txt
                        }
                        weakSelf.editDelegate.fetchBabyInfo(weakSelf.babyModel)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }
                })
            self.view.addSubview(editNameView)
        case 1:
            self.navigationBarItem(false, title: "性别", leftSel: nil, rightSel: nil)
            
            let editSexView = EditSexView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), isMale: self.babyModel.subItem == "男" ? true : false, completionHandler: { [weak self](sex, sexId) in
                if let weakSelf = self{
                    if weakSelf.editDelegate != nil {
                        weakSelf.babyModel.subItem = sex
                        weakSelf.editDelegate.fetchBabyInfo(weakSelf.babyModel)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
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
        let dates = dateString.componentsSeparatedByString("-")
        self.babyModel.subItem = dates.joinWithSeparator(".")
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
