//
//  LoginViewController.swift
//  Login
//
//  Created by 黄漫 on 16/9/16.
//  Copyright © 2016年 黄漫. All rights reserved.
//


import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loginView = LoginView.init(frame: self.view.bounds, commonLogin: { [weak self](phone, isPhone, password) in
            if let weakSelf = self{
                HUD.showHud("正在登录...", onView: weakSelf.view)
                NSUserDefaults.standardUserDefaults().setObject(phone, forKey: UserPhoneKey)
                Login.sendAsyncLogin(phone, userPwd: password, completionHandler: { (errorCode, msg, dataDict) in
                    if errorCode != nil && errorCode == PASSCODE{
                        if let data = dataDict {
                            if let token = NSUserDefaults.standardUserDefaults().objectForKey(HMTokenKey) as? String{
                                var countryCode = "86"
                                let language = NSLocale.preferredLanguages()[0]
                                if language.hasPrefix("zh") {
                                    countryCode = "86"
                                }else{
                                    countryCode = "1"
                                }
                                let videoPhone = "+\(countryCode)-\(phone)"
                                NetManager.sharedManager().loginWithUserName(videoPhone, password: password, token: token, callBack: { [weak self](result) in
                                    if let weakSelf = self{
                                        HUD.hideHud(weakSelf.view)
                                        var contact = ""
                                        if let callback = result as? LoginResult{
                                            var registNumer:NSNumber!
                                            switch callback.error_code{
                                            case NET_RET_LOGIN_SUCCESS:
                                                contact = callback.contactId
                                                weakSelf.loginSuccess(callback)
                                                registNumer = NSNumber.init(bool: true)
                                            default:
                                                registNumer = NSNumber.init(bool: false)
                                                UDManager.setIsLogin(false)
                                            }
                                            
                                            let login = Login()
                                            login.userId = format(data["userId"])
                                            login.sessionId = format(data["sessionId"])
                                            login.nickName = format(data["nickName"])
                                            login.userSign = format(data["userSign"])
                                            login.userName = phone
                                            login.userPhone = phone
                                            login.password = password
                                            login.isRegist = registNumer
                                            login.contactId = contact
                                            login.md5Password = password.md5
                                            LoginBL.insert(login)
                                            
                                            NSUserDefaults.standardUserDefaults().setObject(phone, forKey: UserPhoneKey)
                                            weakSelf.dismissViewControllerAnimated(true, completion: nil)
                                        }
                                    }
                                    })
                            }else{
                                HUD.hideHud(weakSelf.view)
                                HUD.showText("登录失败:无法获取token", onView: weakSelf.view)
                            }
                        }else{
                            HUD.hideHud(weakSelf.view)
                            HUD.showText("登录失败:\(msg)", onView: weakSelf.view)
                        }
                    }else{
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("登录失败:\(errorCode)", onView: weakSelf.view)
                    }
                })

            }
            }, wechatLogin: {
                
            }) { [weak self](phone) in
                if let weakSelf = self{
                    let loginSecond = RegisterViewController()
                    weakSelf.presentViewController(loginSecond, animated: true, completion: nil)
                }
        }
        self.view.addSubview(loginView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loginSuccess(result:LoginResult){
        let settings = UIUserNotificationSettings.init(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        UDManager.setIsLogin(true)
        UDManager.setLoginInfo(result)
        NetManager.sharedManager().getAccountInfo(result.contactId, sessionId: result.sessionId) { (JSON) in
            if let accounntResult = JSON as? AccountResult{
                result.email = accounntResult.email
                result.phone = accounntResult.phone
                result.countryCode = accounntResult.countryCode
                UDManager.setLoginInfo(result)
            }
        }
        if let p2p = P2PClient.sharedClient(){
            p2p.callId = result.contactId
        }
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
