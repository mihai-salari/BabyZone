//
//  BabyVideoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let BabyCancelClickNotification = "BabyCancelClickNotification"

class BabyVideoViewController: BaseViewController {

    var deviceContact:Contact!
    var baby:Baby!
    private var babyVideoView:BabyVideoView!
    private var isReject:Bool = false
    private var isPlaying:Bool = false
    private var isOkRenderVideoFrame:Bool = false
    private var isOkFirstRenderVideoFrame:Bool = false
    private var netType:Int32 = 0
    private var lastNetType:Int32 = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: .None)
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: AllowOrientationKey)
        self.initializeNotification()
        
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
            if AppDelegate.sharedDefault().isMonitoring {
                AppDelegate.sharedDefault().isMonitoring = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if self.deviceContact != nil {
            self.initialize()
        }else{
            self.view.backgroundColor = UIColor.whiteColor()
            let label = UILabel.init(frame: self.view.bounds)
            label.text = "正在开发..."
            label.textAlignment = .Center
            self.view.addSubview(label)
            
        }
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.isReject = true
        
        
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
        if AppDelegate.sharedDefault().isMonitoring {
            AppDelegate.sharedDefault().isMonitoring = false
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBarHidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: AllowOrientationKey)
        
    }

    private func initializeNotification(){
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onDeviceOrientationChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appWillResignActive(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appDidEnterBackground(_:)), name: UIApplicationDidEnterBackgroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appWillEnterForeground(_:)), name: UIApplicationWillEnterForegroundNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.appBecomeActive(_:)), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.receiveRemoteMessage(_:)), name: RECEIVE_REMOTE_MESSAGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.ack_receiveRemoteMessage(_:)), name: ACK_RECEIVE_REMOTE_MESSAGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.monitorStartRender(_:)), name: MONITOR_START_RENDER_MESSAGE, object: nil)
    }

    private func initialize(){
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let babyModel = self.baby == nil ? Baby(babyImage: "babySleep.png", babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0") : self.baby
        self.babyVideoView = BabyVideoView.init(frame: self.view.bounds, baby: babyModel, cancelCompletionHandler: { [weak self] in
            if let weakSelf = self{
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
    
    func receiveRemoteMessage(note:NSNotification) -> Void {
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
    
    func ack_receiveRemoteMessage(note:NSNotification) -> Void {
        if let userInfo = note.userInfo {
            if let keyValue = userInfo["key"] as? String {
                if let key = Int32(keyValue) {
                    var result:Int32 = 0
                    if let resultValue = userInfo["result"] as? String {
                        if let rt = Int32(resultValue) {
                            result = rt
                        }
                    }
                    switch key {
                    case ACK_RET_SET_GPIO_CTL:
                        dispatch_async(dispatch_get_main_queue(), { 
                            if result == 1{
                                
                            }else if result == 2{
                                
                            }
                        })
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
