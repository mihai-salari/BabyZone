//
//  LoginThirdViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/16.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class LoginBaseInfoViewController: BaseViewController {

    var phoneNum = ""
    var password = ""
    var validCode = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let third = LoginBaseInfoView.init(frame: self.view.bounds, phone: self.phoneNum, password: self.password, validCode: self.validCode) {[weak self] (model) in
            if let weakSelf = self{
                Register.sendAsyncRegist(model.phoneNum, userPwd: model.password, validCode: model.validCode, breedStatus: model.breedStatus, babySex: model.babySex, breedStatusDate: model.breedStatusDate, completionHandler: { (regist) in
                    if let rgst = regist{
                        if rgst.errorCode == BabyZoneConfig.shared.passCode{
                            weakSelf.dismissToRoot()
                        }
                    }
                })
            }
        }
        self.view.addSubview(third)
        
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
