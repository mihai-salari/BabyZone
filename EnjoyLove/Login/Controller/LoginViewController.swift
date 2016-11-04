//
//  LoginViewController.swift
//  Login
//
//  Created by 黄漫 on 16/9/16.
//  Copyright © 2016年 黄漫. All rights reserved.
//


import UIKit

let LoginPersonDetailNotification = "LoginPersonDetailNotification"
let LoginBabyListNotification = "LoginBabyListNotification"

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let loginView = LoginView.init(frame: self.view.bounds, commonLogin: { [weak self](phone, isPhone, password) in
            if let weakSelf = self{
                HUD.showHud("正在登录...", onView: weakSelf.view)
                BabyZoneConfig.shared.UserPhoneKey.setDefaultObject(phone)
                Login.sendAsyncLogin(phone, userPwd: password, completionHandler: { (errorCode, msg, dataDict) in
                    if errorCode != nil && errorCode == BabyZoneConfig.shared.passCode{
                        HUD.hideHud(weakSelf.view)
                        if UDManager.isLogin() == false , let token = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.pushTokenKey) as? String  {
                            var countryCode = "86"
                            let language = Localize.currentLanguage()
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
                                    dispatch_queue_create("loginQueue", nil).queue({
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
                                            
                                            if let login = LoginBL.find() {
                                                login.contactId = contact
                                                login.isRegist = registNumer
                                                LoginBL.modify(login)
                                            }
                                        }
                                    })
                                }
                                })

                        }
                        if dataDict != nil {
                            dispatch_get_main_queue().queue({
                                weakSelf.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }else{
                            HUD.hideHud(weakSelf.view)
                            HUD.showText("登录失败:\(msg!)", onView: weakSelf.view)
                        }
                    }else{
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("登录失败:\(msg!)", onView: weakSelf.view)
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
