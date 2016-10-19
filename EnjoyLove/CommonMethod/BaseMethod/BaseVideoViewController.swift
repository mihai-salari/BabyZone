//
//  BaseVideoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/19.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BaseVideoViewController: BaseViewController,P2PClientDelegate {

    var contactsData:[Contact]!
    private var isInitPull:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        var result = false
        if AppDelegate.sharedDefault().dwApContactID == 0 {
            if let loginResult = UDManager.getLoginInfo() {
                result = P2PClient.sharedClient().p2pConnectWithId(loginResult.contactId, codeStr1: loginResult.rCode1, codeStr2: loginResult.rCode2)
            }
        }else{
            result = P2PClient.sharedClient().p2pConnectWithId("0517401", codeStr1: "0", codeStr2: "0")
        }
        if result == true {
            print("p2p connect success")
        }
        
        P2PClient.sharedClient().delegate = self
        
        self.contactsData = []
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            for contact in contacts  {
                contact.isGettingOnLineState = true
            }
            self.contactsData.appendContentsOf(contacts)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: NET_WORK_CHANGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: "updateContactState", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: "refreshMessage", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: "refreshLocalDevices", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: RECEIVE_REMOTE_MESSAGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: ACK_RECEIVE_REMOTE_MESSAGE, object: nil)
        
        if self.isInitPull == false {
            GlobalThread.sharedThread(false).start()
            self.isInitPull = !self.isInitPull
        }
        GlobalThread.sharedThread(false).isPause = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        GlobalThread.sharedThread(false).isPause = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:___P2PClientDelegate____
    func P2PClientCalling(info: [NSObject : AnyObject]!) {
        print("Calling info \(info)")
    }
    
    func P2PClientReady(info: [NSObject : AnyObject]!) {
        print("Ready info \(info)")
    }
    
    func P2PClientAccept(info: [NSObject : AnyObject]!) {
        print("Accept info \(info)")
    }
    
    func P2PClientReject(info: [NSObject : AnyObject]!) {
        print("reject info \(info)")
    }

    
    //MARK:___通知___
    
    func onNetWorkChange(note:NSNotification) -> Void {
        if let parameter = note.userInfo {
            if let statusStr = parameter["status"] as? String {
                if let status = Int(statusStr) {
                    if NetworkStatus.init(status) == NotReachable {
                        
                    }else{
                        var contactIds:[String] = []
                        for contact in self.contactsData {
                            contactIds.append(contact.contactId)
                        }
                        P2PClient.sharedClient().getContactsStates(contactIds)
                    }
                }
            }
        }
    }
    
    func stopAnimating(note:NSNotification) -> Void {
        
    }
    
    func refreshContact(note:NSNotification) -> Void {
        
    }
    
    func refreshLocalDevices(note:NSNotification) -> Void {
        
    }
    
    func receiveRemoteMessage(note:NSNotification) -> Void {
        if let parameter = note.userInfo {
            if let keyStr = parameter["key"] as? String{
                if let key = Int32(keyStr) {
                    switch key {
                    case RET_DO_DEVICE_UPDATE:
                        break
                    case RET_CHECK_DEVICE_UPDATE:
                        break
                    case RET_GET_BIND_ACCOUNT:
                        break
                    case RET_SET_BIND_ACCOUNT:
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func ack_receiveRemoteMessage(note:NSNotification) -> Void {
        if let parameter = note.userInfo {
            if let keyStr = parameter["key"] as? String, let resultStr = parameter["result"] as? String{
                if let key = Int32(keyStr), let result = Int32(resultStr) {
                    if key != ACK_RET_GET_NPC_SETTINGS {
                        return
                    }
                    switch result {
                    case 0:
                        break
                    case 1:
                        break
                    case 2:
                        break
                    case 4:
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
    
    
    private func videoLogin() -> Void {
        if UDManager.isLogin() == true {
            return
        }else{
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
                                }
                            }
                            })
                    }
                }
                
            }
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
