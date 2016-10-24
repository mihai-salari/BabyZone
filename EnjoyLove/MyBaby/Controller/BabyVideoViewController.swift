//
//  BabyVideoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let BabyCancelClickNotification = "BabyCancelClickNotification"

class BabyVideoViewController: BaseVideoViewController {

    var deviceContact:Contact!
    var baby:Baby!
    private var babyVideoView:BabyVideoView!
    private var isReject:Bool = false
    private var isPlaying:Bool = false
    private var isOkRenderVideoFrame:Bool = false
    private var isOkFirstRenderVideoFrame:Bool = false
    private var netType:Int32 = 0
    private var lastNetType:Int32 = 0
    
    private var lastGroup:Int32 = 0
    private var lastPin:Int32 = 0
    private var lastValue:Int32 = 0
    private var lastTime:Int32 = 0
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
        if self.deviceContact != nil {
            P2PClient.sharedClient().isBCalled = false
            P2PClient.sharedClient().callId = deviceContact.contactId
            P2PClient.sharedClient().callPassword = deviceContact.contactPassword
            P2PClient.sharedClient().p2pCallType = P2PCALL_TYPE_MONITOR
            P2PClient.sharedClient().p2pCallState = P2PCALL_STATUS_CALLING
            
            let isBCalled = P2PClient.sharedClient().isBCalled
            let type = P2PClient.sharedClient().p2pCallType
            let callId = P2PClient.sharedClient().callId
            let callPassword = P2PClient.sharedClient().callPassword
            
            if isBCalled == false {
                let isApMode = (AppDelegate.sharedDefault().dwApContactID != 0)
                if isApMode == false {
                    P2PClient.sharedClient().p2pCallWithId(callId, password: callPassword, callType: type)
                }else{
                    P2PClient.sharedClient().p2pCallWithId("1", password: callPassword, callType: type)
                }
            }
            
        }else{
            self.view.backgroundColor = UIColor.whiteColor()
            let label = UILabel.init(frame: self.view.bounds)
            label.text = "正在开发..."
            label.textAlignment = .Center
            self.view.addSubview(label)
            self.performSelector(#selector(self.popViewController), withObject: nil, afterDelay: 2)
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: AllowOrientationKey)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onDeviceOrientationChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.monitorStartRender(_:)), name: MONITOR_START_RENDER_MESSAGE, object: nil)
        
        if let contact = deviceContact {
            if let p2p = P2PClient.sharedClient() {
                p2p.isBCalled = false
                p2p.callId = contact.contactId
                p2p.callPassword = contact.contactPassword
                p2p.p2pCallType = P2PCALL_TYPE_MONITOR
                if let contactId = p2p.callId, let contactPassword = p2p.callPassword {
                    p2p.sendCustomCmdWithId(contactId, password: contactPassword, cmd: "IPC1anerfa:connect")
                }
            }
            
            AppDelegate.sharedDefault().monitoredContactId = contact.contactId
            AppDelegate.sharedDefault().isMonitoring = true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        self.isReject = true
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: AllowOrientationKey)
        
        if let babyView = self.babyVideoView {
            babyView.captureFinishScreen(true)
        }
        
        if let contact = deviceContact {
            if AppDelegate.sharedDefault().isDoorBellAlarm {
                if let p2p = P2PClient.sharedClient() {
                    p2p.isBCalled = false
                    p2p.callId = contact.contactId
                    p2p.callPassword = contact.contactPassword
                    p2p.p2pCallType = P2PCALL_TYPE_MONITOR
                    if let contactId = p2p.callId, let contactPassword = p2p.callPassword {
                        p2p.sendCustomCmdWithId(contactId, password: contactPassword, cmd: "IPC1anerfa:disconnect")
                    }
                }
            }
        }
        
        AppDelegate.sharedDefault().monitoredContactId = nil
        AppDelegate.sharedDefault().isMonitoring = false
        NSNotificationCenter.defaultCenter().removeObserver(self)
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    func popViewController() -> Void {
        self.navigationController?.popViewControllerAnimated(true)
    }

    

    private func initialize(){
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        let babyModel = self.baby == nil ? Baby(babyImage: "babySleep.png", babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0") : self.baby
        self.babyVideoView = BabyVideoView.init(frame: self.view.bounds, baby: babyModel, cancelCompletionHandler: { [weak self] in
            if let weakSelf = self{
                if weakSelf.isReject == false{
                    weakSelf.isReject = !weakSelf.isReject
                    while weakSelf.isPlaying{
                        usleep(50 * 1000)
                    }
                    P2PClient.sharedClient().p2pHungUp()
                }
                weakSelf.navigationController?.popViewControllerAnimated(true)
            }
        })
        self.babyVideoView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight, .FlexibleLeftMargin, .FlexibleRightMargin]
        self.view.addSubview(self.babyVideoView)
        
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
    
    //MARK:___ROTATE____
    func onDeviceOrientationChange(notification:NSNotification) -> Void {
        let orientation = UIDevice.currentDevice().orientation
        switch orientation {
        case .LandscapeLeft, .LandscapeRight:
            self.babyVideoView.frame = self.view.bounds
        case .Portrait:
            break
        default:
            return
        }
        self.babyVideoView.rotateSubviews(orientation)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if self.isOkFirstRenderVideoFrame == false {
            return [.Portrait]
        }
        return [.LandscapeLeft, .Portrait, .LandscapeRight]
    }
    
    //MARK:___NOTIFICATION___
    func appWillResignActive(note:NSNotification) -> Void {
        
    }
    
    func appBecomeActive(note:NSNotification) -> Void {
        
    }
    
    func appDidEnterBackground(note:NSNotification) -> Void {
        
    }
    
    func appWillEnterForeground(note:NSNotification) -> Void {
        
    }
    
    
    func cancelButtonClick() -> Void {
        NSNotificationCenter.defaultCenter().postNotificationName(BabyCancelClickNotification, object: nil)
        
    }
    
    override func receiveRemoteMessage(note:NSNotification) -> Void {
        if let userInfo = note.userInfo {
            if let keyValue = userInfo["key"] as? String {
                if let key = Int32(keyValue) {
                    switch key {
                    case RET_GET_FOCUS_ZOOM:
                        break
                    case RET_SET_GPIO_CTL:
                        break
                    case RET_GET_LIGHT_SWITCH_STATE:
                        break
                    case RET_SET_LIGHT_SWITCH_STATE:
                        break
                    case RET_DEVICE_NOT_SUPPORT:
                        break
                    case RET_GET_NPCSETTINGS_REMOTE_DEFENCE:
                        break
                    case RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
                        break
                        
                    default:
                        break
                    }
                }
                
            }
        }
    }
    
    override func ack_receiveRemoteMessage(note:NSNotification) -> Void {
        if let userInfo = note.userInfo {
            if let keyValue = userInfo["key"] as? String, let resultValue  = userInfo["result"] as? String {
                if let key = Int32(keyValue), let result = Int32(resultValue) {
                    switch key {
                    case ACK_RET_SET_GPIO_CTL:
                        dispatch_async(dispatch_get_main_queue(), { 
                            if result == 1{
                                
                            }else if result == 2{
                                P2PClient.sharedClient().setGpioCtrlWithId(P2PClient.sharedClient().callId, password: P2PClient.sharedClient().callPassword, group: VideoTime.shared().lastGroup, pin: VideoTime.shared().lastPin, value: VideoTime.shared().lastValue, time: VideoTime.shared().lastTime)
                            }
                        })
                    case ACK_RET_GET_LIGHT_STATE:
                        dispatch_get_main_queue().queue({
                            if result == 1 {
                                
                            }else if result == 2{
                                 P2PClient.sharedClient().getLightStateWithDeviceId(P2PClient.sharedClient().callId, password: P2PClient.sharedClient().callPassword)
                            }
                        })
                        
                    case ACK_RET_SET_LIGHT_STATE:
                        dispatch_get_main_queue().queue({ 
                            if result == 1{
                                
                            }else if result == 2{
                                
                            }
                        })
                    case ACK_RET_GET_DEFENCE_STATE:
                        break
                    case RET_DEVICE_NOT_SUPPORT:
                        
                        P2PClient.sharedClient().getDefenceState(P2PClient.sharedClient().callId, password: P2PClient.sharedClient().callPassword)
                        
                    case ACK_RET_SET_NPCSETTINGS_REMOTE_DEFENCE:
                        if result == 2 {
                            
                        }
                        
                    default:
                        break
                    }
                }
                
            }
        }
    }
    
    func monitorStartRender(note:NSNotification) -> Void {
        if let p2p = P2PClient.sharedClient() {
            let is16B9 = p2p.is16B9
            let is960P = p2p.is960P
            if is16B9 || is960P {
                
            }else{
                
            }
            self.isReject = false
            NSThread.detachNewThreadSelector(#selector(self.renderView), toTarget: self, withObject: nil)
        }
        self.operationAfterRender()
    }
    
    func renderView() -> Void {
        self.isPlaying = true
        
        var m_pAVFrame:UnsafeMutablePointer<GAVFrame> = nil
        while self.isReject == false {
            if fgGetVideoFrameToDisplay(&m_pAVFrame) != 0{
                if self.isOkRenderVideoFrame == false {
                    self.isOkRenderVideoFrame = true
                    self.isOkFirstRenderVideoFrame = true
                }
                if let videoView = self.babyVideoView {
                    videoView.renderFrame(m_pAVFrame)
                }
            }
            usleep(10000)
        }
        self.isPlaying = false
    }
    
    private func operationAfterRender(){
        PAIOUnit.sharedUnit().muteAudio = false
        PAIOUnit.sharedUnit().setSpeckState(true)
        if AppDelegate.sharedDefault().isDoorBellAlarm == true {
            PAIOUnit.sharedUnit().setSpeckState(false)
        }else{
            PAIOUnit.sharedUnit().setSpeckState(true)
        }
        
        P2PClient.sharedClient().getDefenceState(P2PClient.sharedClient().callId, password: P2PClient.sharedClient().callPassword)
        P2PClient.sharedClient().getNpcSettingsWithId(P2PClient.sharedClient().callId, password: P2PClient.sharedClient().callPassword)
        
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
