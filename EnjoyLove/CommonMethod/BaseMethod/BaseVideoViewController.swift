//
//  BaseVideoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/19.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BaseVideoViewController: BaseViewController,P2PClientDelegate {

    private var isInitPull:Bool = false
    var contactData:[Contact]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        dispatch_queue_create("devicesLoadQueue", nil).queue { 
            Equipments.sendAsyncEqutementList(nil)
        }
        
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
        
        self.contactData = []
        self.contactData.removeAll()
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            for contact in contacts  {
                contact.isGettingOnLineState = true
            }
            self.contactData.appendContentsOf(contacts)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        P2PClient.sharedClient().delegate = nil
        P2PClient.sharedClient().delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: NET_WORK_CHANGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.updateContactState), name: "updateContactState", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshContact), name: "refreshMessage", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.refreshLocalDevices), name: "refreshLocalDevices", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receiveRemoteMessage(_:)), name: RECEIVE_REMOTE_MESSAGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.ack_receiveRemoteMessage(_:)), name: ACK_RECEIVE_REMOTE_MESSAGE, object: nil)
        
        
        
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
        P2PClient.sharedClient().p2pCallState = P2PCALL_STATUS_READY_P2P
        if P2PClient.sharedClient().p2pCallType == P2PCALL_TYPE_MONITOR {
            NSNotificationCenter.defaultCenter().postNotificationName(MONITOR_START_RENDER_MESSAGE, object: nil)
        }
    }
    
    func P2PClientAccept(info: [NSObject : AnyObject]!) {
        print("Accept info \(info)")
    }
    
    func P2PClientReject(info: [NSObject : AnyObject]!) {
        print("reject info \(info)")
        NSNotificationCenter.defaultCenter().postNotificationName(BabyZoneConfig.shared.videoRejectNotification, object: nil, userInfo: info)
        
    }

    
    //MARK:___通知___
    
    func onNetWorkChange(note:NSNotification) -> Void {
        
    }
    
    func updateContactState() -> Void {
    }
    
    func refreshContact() -> Void {
        let devices = EquipmentsBL.findAll().count > 0 ? EquipmentsBL.findAll() : []
        for device in devices {
            let contact = EquipmentsBL.contactFromEquipment(device)
            device.eqmStatus = Int32.init(contact.onLineState)
            EquipmentsBL.modify(device)
        }
        
    }
    
    func refreshLocalDevices() -> Void {
    }
    
    func receiveRemoteMessage(note:NSNotification) -> Void {
    }
    
    func ack_receiveRemoteMessage(note:NSNotification) -> Void {
    }
    
    
    private func videoLogin() -> Void {
        if UDManager.isLogin() == true {
            return
        }else{
            if let userId = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String {
                if let base = LoginBL.find(userId) {
                    if let token = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.pushTokenKey) as? String {
                        var countryCode = "86"
                        let language = NSLocale.preferredLanguages()[0]
                        if language.hasPrefix("zh") {
                            countryCode = "86"
                        }else{
                            countryCode = "1"
                        }
                        let videoPhone = "+\(countryCode)-\(base.userPhone)"
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
                                    
                                    if let baseInfo = LoginBL.find(userId){
                                        baseInfo.isRegist = registNumer
                                        baseInfo.contactId = contact
                                        LoginBL.modify(baseInfo)
                                    }
                                    BabyZoneConfig.shared.currentUserId.setDefaultObject(userId)
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
