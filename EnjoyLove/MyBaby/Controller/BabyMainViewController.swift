//
//  BabyMainViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/26.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

//private let babyViewHeight:CGFloat = upRateHeight(110)
private let faceWidth:CGFloat = upRateWidth(55)
private let faceHeight:CGFloat = upRateWidth(55)
private let faceNumberWidth:CGFloat = upRateWidth(15)
private let lineBeginX:CGFloat = upRateWidth(15)

class BabyMainViewController: BaseViewController {

            /// 宝宝数据
    private var babyData:[Baby]!
    private var babyView:BabyView!
    
    private var testLabel:UILabel!
    let availableLanguages = Localize.availableLanguages()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        if isLogin() == false {
            let login = LoginViewController()
            self.presentViewController(login, animated: true, completion: nil)
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
            self.tabBarController?.tabBar.hidden = false
            self.navigationController?.navigationBarHidden = false
            self.navigationBarItem(title: "我的宝宝", leftSel: nil, rightSel: #selector(BabyMainViewController.rightConfigClick), rightItemSize: CGSizeMake(20, 20), rightImage: "myOwnConfig.png")
            self.videoLogin()
            self.initialize()
        }
    }
    
    
    private func videoLogin() -> Void {
        if UDManager.isLogin() == true {
            return
        }
        if let phone = NSUserDefaults.standardUserDefaults().objectForKey(UserPhoneKey) as? String {
            if let base = LoginBL.find(nil, key: phone) {
                if let token = NSUserDefaults.standardUserDefaults().objectForKey(HMTokenKey) as? String {
                    var countryCode = "86"
                    let language = NSLocale.preferredLanguages()[0]
                    if language.hasPrefix("zh") {
                        countryCode = "86"
                    }else{
                        countryCode = "1"
                    }
                    let videoPhone = "+\(countryCode)-\(phone)"
                    NetManager.sharedManager().loginWithUserName(videoPhone, password: base.password, token: token, callBack: { [weak self](result) in
                        if let weakSelf = self{
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
                                
                                if let baseInfo = LoginBL.find(nil, key: phone){
                                    baseInfo.userPhone = phone
                                    baseInfo.userName = phone
                                    baseInfo.isRegist = registNumer
                                    baseInfo.contactId = contact
                                    LoginBL.modify(baseInfo)
                                }
                                
                                
                                NSUserDefaults.standardUserDefaults().setObject(phone, forKey: UserPhoneKey)
                                weakSelf.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                        })
                }
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setnkznkup after loading the view.
//        self.performSelector(#selector(self.remoteNotification), withObject: nil, afterDelay: 1)
    }
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        self.babyData = []
        var baby = Baby(babyImage: "babySleep.png", babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0")
        self.babyData.append(baby)
        baby = Baby(babyImage: "babySleep.png", babyRemindCount: "2", babyTemperature: "25", babyHumidity: "77")
        self.babyData.append(baby)
        baby = Baby(babyImage: "babySleep.png", babyRemindCount: "4", babyTemperature: "23", babyHumidity: "80")
        self.babyData.append(baby)
        
        if self.babyView != nil {
            self.babyView.removeFromSuperview()
            self.babyView = nil
        }
        self.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.babyView = BabyView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: self.view.frame.height - navAndTabHeight), data: self.babyData, playCompletionHandler: { [weak self](baby) in
            if let weakSelf = self{
                let babyVideo = BabyVideoViewController()
                weakSelf.navigationController?.pushViewController(babyVideo, animated: true)
            }
        }) { [weak self](baby) in
            if let weakSelf = self{
                let music = PlayMusicViewController()
                weakSelf.navigationController?.pushViewController(music, animated: true)
            }
        }
        self.view.addSubview(self.babyView)
                
    }
    
    
    func remoteNotification() -> Void {
        let push = BabyPushViewController()
        let nav = UINavigationController.init(rootViewController: push)
        self.presentViewController(nav, animated: true, completion: nil)
    }
        
    func rightConfigClick() -> Void {
        print("config click")
        let setting = BabySettingViewController()
        self.navigationController?.pushViewController(setting, animated: true)
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
        if let p2p = P2PClient.sharedClient() as? P2PClient{
            p2p.callId = result.contactId
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
