//
//  InfoManagerViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 2016/10/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class InfoManagerViewController: BaseViewController {
    
    private var pregInfoVC:PregInfoViewController!
    private var diaryRecordVC:DiaryRecordViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        if BabyListBL.findAll().count > 0 {
            if DiaryBL.findAll().count == 0 {
                self.diaryRecordVC = DiaryRecordViewController()
                self.view.addSubview(self.diaryRecordVC.view)
                self.addChildViewController(self.diaryRecordVC)
                if self.pregInfoVC != nil {
                    self.pregInfoVC.removeFromParentViewController()
                    self.pregInfoVC = nil
                }
            }else{
                self.pregInfoVC = PregInfoViewController()
                self.view.addSubview(self.pregInfoVC.view)
                self.addChildViewController(self.pregInfoVC)
                if self.diaryRecordVC != nil {
                    self.diaryRecordVC.removeFromParentViewController()
                    self.diaryRecordVC = nil
                }
            }
        }else{
            
        }
        if BabyListBL.findAll().count > 0 {
            
        }else{
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
