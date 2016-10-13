//
//  LoginSecondViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/16.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let secondView = RegisterView.init(frame: self.view.bounds, nextStepHandler: { [weak self](phone, isPhone, code, password) in
            if let weakSelf = self{
                if isPhone == true{
                    let third = LoginBaseInfoViewController()
                    third.phoneNum = phone
                    third.password = password
                    third.validCode = code
                    weakSelf.presentViewController(third, animated: true, completion: nil)
                }else{
                    HUD.showText("请输入正确的手机号", onView: weakSelf.view)
                }
//                if isPhone == true{
//                    HUD.showHud("正在校验...", onView: weakSelf.view)
//                    Register.sendAsyncRegist(phone, userPwd: password, validCode: code, completionHandler: { (regist) in
//                        HUD.hideHud(weakSelf.view)
//                        if let rgst = regist{
//                            if rgst.userId != "" && rgst.sessionId != "" && rgst.errorCode == PASSCODE{
//                                HUD.showText("校验成功", onView: weakSelf.view)
//                                weakSelf.performSelector(#selector(RegisterViewController.nextController), withObject: nil, afterDelay: 1.0)
//                            }else{
//                                HUD.showText("校验失败:\(rgst.msg)", onView: weakSelf.view)
//                            }
//                        }else{
//                            HUD.showText("校验失败:网络异常", onView: weakSelf.view)
//                        }
//                    })
//                }
            }
            }, alreadyRegisterHandler: { [weak self] in
                if let weakSelf = self{
                    HUD.hideHud(weakSelf.view)
                    weakSelf.dismissViewControllerAnimated(true, completion: nil)
                }
        }) {[weak self] in
            if let weakSelf = self{
                let agreemnet = LoginAgreementViewController()
                let nav = UINavigationController.init(rootViewController: agreemnet)
                weakSelf.presentViewController(nav, animated: true, completion: nil)
            }
        }
        self.view.addSubview(secondView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func nextController() -> Void {
        let third = LoginBaseInfoViewController()
        self.presentViewController(third, animated: true, completion: nil)
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
