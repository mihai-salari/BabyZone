//
//  AddDeviceViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/23.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class AddDeviceViewController: BaseViewController {

    private var addDeviceView:AddDeviceView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self,title: "安全验证", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addDeviceView = AddDeviceView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: ScreenWidth - 20, height: ScreenHeight - navigationBarHeight), completionHandler: { [weak self] (isRegisted, phoneNum, validCode, country)in
            if let weakSelf = self{
                if isRegisted == true{
                    if let phone = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String{
                        if let info  = LoginBL.find(phone){
                            if let psd = info.password {
                                let userName = "+\(country)-\(phoneNum)"
                                weakSelf.login(userName, password: psd)
                            }
                        }
                    }
                }else{
                    HUD.showHud("正在验证...", onView: weakSelf.view)
                    NetManager.sharedManager().verifyPhoneCodeWithCode(validCode, phone: phoneNum, countryCode: country, callBack: { (codeNumber) in
                        if let code = (codeNumber as? NSNumber)?.intValue {
                            switch code{
                            case NET_RET_VERIFY_PHONE_CODE_SUCCESS:
                                if let phone = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String{
                                    var password = ""
                                    if let info  = LoginBL.find(phone){
                                        if let psd = info.password {
                                            password = psd
                                        }
                                    }
                                    weakSelf.varifyPhoneCodeSuccess(phoneNum, psd: password, countryCode: country, validCode: validCode)
                                }
                            case NET_RET_VERIFY_PHONE_CODE_ERROR:
                                HUD.hideHud(weakSelf.view)
                                HUD.showText("验证码错误", onView: weakSelf.view)
                            case NET_RET_VERIFY_PHONE_CODE_TIME_OUT:
                                HUD.hideHud(weakSelf.view)
                                HUD.showText("验证超时", onView: weakSelf.view)
                            case NET_RET_SYSTEM_MAINTENANCE_ERROR:
                                HUD.hideHud(weakSelf.view)
                                HUD.showText("系统正在维护，请稍后再试", onView: weakSelf.view)
                            default:
                                HUD.hideHud(weakSelf.view)
                                HUD.showText("发生错误:\(code)", onView: weakSelf.view)
                            }
                        }
                    })
                }
            }
        })
        self.view.addSubview(self.addDeviceView)
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func varifyPhoneCodeSuccess(phone:String, psd:String, countryCode:String, validCode:String){
        NetManager.sharedManager().registerWithVersionFlag("1", email: "", countryCode: countryCode, phone: phone, password: psd, repassword: psd, phoneCode: validCode) { [weak self](codeNum) in
            if let weakSelf = self{
                
                if let code = (codeNum as? RegisterResult)?.error_code{
                    switch code{
                    case NET_RET_REGISTER_SUCCESS:
                        if let contactId = (codeNum as? RegisterResult)?.contactId {
                            weakSelf.login(contactId, password: psd)
                        }else{
                            HUD.hideHud(weakSelf.view)
                            HUD.showText("验证失败", onView: weakSelf.view)
                        }
                    case NET_RET_REGISTER_EMAIL_FORMAT_ERROR:
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("邮箱格式错误", onView: weakSelf.view)
                    case NET_RET_REGISTER_EMAIL_USED:
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("邮箱已被使用", onView: weakSelf.view)
                    case NET_RET_SYSTEM_MAINTENANCE_ERROR:
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("系统正在维护，请稍后再试", onView: weakSelf.view)
                    default:
                        HUD.hideHud(weakSelf.view)
                        HUD.showText("发生错误:\(code)", onView: weakSelf.view)
                    }
                }
            }
        }
        
    }
    
    private func login(contacId:String, password:String){
        HUD.hideHud(self.view)
        if let token = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.pushTokenKey) as? String {
            NetManager.sharedManager().loginWithUserName(contacId, password: password, token: token, callBack: { [weak self](result) in
                if let weakSelf = self{
                    HUD.hideHud(weakSelf.view)
                    if let callback = result as? LoginResult{
                        switch callback.error_code{
                        case NET_RET_LOGIN_SUCCESS:
                            weakSelf.loginSuccess(callback)
                        case NET_RET_LOGIN_USER_UNEXIST:
                            HUD.showText("用户已验证过", onView: weakSelf.view)
                        case NET_RET_LOGIN_PWD_ERROR:
                            HUD.showText("验证密码出错", onView: weakSelf.view)
                        case NET_RET_LOGIN_EMAIL_FORMAT_ERROR:
                            HUD.showText("用户验证出错", onView: weakSelf.view)
                        case NET_RET_SYSTEM_MAINTENANCE_ERROR:
                            HUD.showText("系统正在维护，请稍后再试", onView: weakSelf.view)
                        default:
                            HUD.showText("发生错误:\(callback.error_code)", onView: weakSelf.view)
                        }
                    }
                }
            })
        }
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
        let next = QRCodeNextController()
        self.navigationController?.pushViewController(next, animated: true)
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
