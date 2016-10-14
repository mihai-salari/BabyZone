//
//  HMethod.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.mainScreen().bounds.size.width
let ScreenHeight = UIScreen.mainScreen().bounds.size.height
let navigationBarHeight:CGFloat = 64
let tabBarHeight:CGFloat = 49
let navAndTabHeight:CGFloat = 113
let viewOriginX:CGFloat = 10
let viewOriginY:CGFloat = 10

let HMAppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let HMTablBarController = HMAppDelegate.rootTabBarController

let requestSign = "sign"
let requestAppToken = "appToken"
let requestSessionId = "sessionId"
let HMTokenKey = "TOKENKEY"
let AppTokenKey = "APPTOKENKEY"
let SignKey = "SIGNKEY"
let AllowOrientationKey = "ALLORIENTATIONS"
let UserPhoneKey = "USERPHONEKEY"
let PASSCODE = "0000"
let QiNiuToken = "QIUNIUTOKEN"
let QiNiuDomainName = "QINIUDOMAINNAME"




//let SessionIdKey  = "SESSIONIDKEY"

//let HMPasswordKey = "HMPASSWORDKEY"
//let HMMD5PasswordKey = "HMMD5PASSWORDKEY"
//let HMUserNameKey = "USERNAME"
//let HMUserIdKey = "userId"




let NetworkStatusNotification = "kNetworkReachabilityChangedNotification"

let alertTextColor = UIColor.hexStringToColor("#e35572")

let devicePassword = "123"

//MARK:___登录判断___
func isLogin() -> Bool {
    if let phone = NSUserDefaults.standardUserDefaults().objectForKey(UserPhoneKey) as? String {
        if let info = LoginBL.find(nil, key: phone) {
            if info.sessionId != nil && info.sessionId != "" && info.sessionId != "0" {
                return true
            }
        }
    }
    return false
}


let lineWH:CGFloat = 0.5
private let lineAlpha:CGFloat = 0.7

let navigationBarColor = UIColor.init(red: 230 / 255.0, green: 135 / 255.0, blue: 135 / 255.0, alpha: 1.0)

func format(obj:AnyObject?) -> String {
    if let object = obj {
        return "\(object)"
    }
    return ""
}
/*
 当前系统语言
 */
func currentLanguage() -> String {
    var language = ""
    if let lang = NSLocale.preferredLanguages().last {
        language = lang
    }
    return language
}

//随机数生成器函数
func createRandomMan(start: Int, end: Int) ->() ->Int! {
    //根据参数初始化可选值数组
    var nums = [Int]();
    for i in start ..< end{
        nums.append(i)
    }
    
    func randomMan() -> Int! {
        if !nums.isEmpty {
            //随机返回一个数，同时从数组里删除
            let index = Int(arc4random_uniform(UInt32(nums.count)))
            return nums.removeAtIndex(index)
        }else {
            //所有值都随机完则返回nil
            return nil
        }
    }
    
    return randomMan
}

/**
 读取图片
 
 - parameter name: 图片名称
 
 - returns:
 */


func setTimeoutInterval(time:NSTimeInterval, continuedHandler:((continued:NSTimeInterval)->())?, endHandler:(()->())?) -> dispatch_source_t {
    var timeout = time
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
    dispatch_source_set_timer(source, dispatch_walltime(nil, 0), UInt64(NSEC_PER_SEC)  * 1, 0)
    dispatch_source_set_event_handler(source) { 
        if timeout <= 0{
            dispatch_source_cancel(source)
            timeout = 0
            dispatch_async(dispatch_get_main_queue(), { 
                if let end = endHandler{
                    end()
                }
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { 
                if let continued = continuedHandler{
                    continued(continued: timeout)
                }
            })
            timeout -= 1
        }
    }
    dispatch_resume(source)
    return source
}

func textRect(txt:NSString, fontSize:CGFloat,size:CGSize) -> CGRect {
    let rect = txt.boundingRectWithSize(size, options: NSStringDrawingOptions.UsesFontLeading, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], context: nil)
    return rect
}

func upRateWidth(num:CGFloat) -> CGFloat {
    return num * ScreenWidth / 320
}

func downRateWidth(num:CGFloat) -> CGFloat {
    return num * 320 / ScreenWidth
}

func upRateHeight(num:CGFloat) -> CGFloat {
    return num * ScreenHeight / 480
}

func downRateHeight(num:CGFloat) -> CGFloat {
    return num * 480 / ScreenHeight
}

func baseNavigationBarSetting(vc:UIViewController) -> Void {
    vc.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    vc.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    vc.navigationController?.navigationBar.translucent = false
    vc.automaticallyAdjustsScrollViewInsets = false
}




func customBackgroundImage(frame: CGRect, image:String) -> UIView {
    let imageView = UIImageView.init(frame: frame)
    imageView.image = UIImage.imageWithName(image)
    return imageView
}


func lineColor() -> UIColor {
    return UIColor.colorFromRGB(207, g: 154, b: 167, a: lineAlpha)!
}




func sourcePath(sourceName:String?) -> String? {
    if let source = sourceName {
        return  NSBundle.mainBundle().resourcePath?.stringByAppendingString(source)
    }
    return nil
}

let weekDict = ["2":"MON","3":"TUES","4":"WED","5":"THUR","6":"FRI","7":"SAT","1":"SUN"]
func week(weekday:String) -> String {
    if let week = weekDict[weekday] {
        return week
    }
    return ""
}

private let hudViewTag = 100000
class HUD: NSObject {
    
    class func showHud(tip:String, onView:UIView) ->Void{
        onMain { 
            let hud = MBProgressHUD.showHUDAddedTo(onView, animated: true)
            hud.label.text = tip
            hud.label.numberOfLines = 0
            hud.tag = hudViewTag
        }
    }
    
    class func hideHud(onView:UIView) ->Void{
        onMain { 
            if let view = onView.viewWithTag(hudViewTag) {
                var hud = view as? MBProgressHUD
                hud!.hideAnimated(true)
                hud = nil
            }
        }
    }
    
    class func showText(tip:String, onView:UIView) ->Void{
        onMain { 
            let hud = MBProgressHUD.showHUDAddedTo(onView, animated: true)
            hud.mode = MBProgressHUDMode.Text
            hud.offset = CGPointMake(0, MBProgressMaxOffset)
            hud.square = true
            hud.label.text = tip
            hud.label.numberOfLines = 0
            hud.hideAnimated(true, afterDelay: 3.0)
        }
    }
        
    
}

func onMain(completionHandler:(()->())?) -> Void {
    if let handle = completionHandler {
        if NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue() {
            handle()
        }else{
            dispatch_async(dispatch_get_main_queue(), { 
                handle()
            })
        }
    }
    
}

class CustomMethod: NSObject {
    
    
}

extension CustomMethod{
    class func gradientForBackgroundView(view:UIView) -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.layer.bounds
        gradientLayer.colors = [UIColor.hexStringToColor("#da5a7b").CGColor ,UIColor.hexStringToColor("#e27360").CGColor]
        gradientLayer.locations = [NSNumber.init(float: 0.1),NSNumber.init(float: 0.9)]
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    class func gradientForNavigationBarView(view:UIView) -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.layer.bounds
        gradientLayer.colors = [UIColor.hexStringToColor("#da5a7b").CGColor ,UIColor.hexStringToColor("#de6570").CGColor]
        gradientLayer.locations = [NSNumber.init(float: 0.1),NSNumber.init(float: 0.9)]
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    class func gradientForTabBarView(view:UIView) -> Void {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(CGRectGetMinX(view.frame), CGRectGetMinY(view.frame), CGRectGetWidth(UIScreen.mainScreen().bounds), CGRectGetHeight(view.frame))
        gradientLayer.colors = [UIColor.hexStringToColor("#de6570").CGColor ,UIColor.hexStringToColor("#e27360").CGColor]
        gradientLayer.locations = [NSNumber.init(float: 0.1),NSNumber.init(float: 0.9)]
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
    }
    
    
    class func findHairlineImageViewUnder(view:UIView) ->UIImageView?{
        if view.isKindOfClass(UIImageView) == true && CGRectGetHeight(view.frame) <= 1.0 {
            return view as? UIImageView
        }
        for subview in view.subviews {
            let imageView = self.findHairlineImageViewUnder(subview)
            if let aView = imageView {
                return aView
            }
        }
        return nil
    }
}

//MARK:____键盘事件____
class Keyboard: NSObject {
    private var targetView:UIView!
    private var containerView:UIView!
    private var targetViewOriginFrame:CGRect!
    private var containerViewOriginFrame:CGRect!
    private var hasNavigationBar:Bool!
    private var keyboardShowHandler:((keyboardFrame:CGRect,notification:NSNotification)->())?
    private var keyboardHideHandler:((keyboardFrame:CGRect,notification:NSNotification)->())?
    
    init(targetView:UIView!, container:UIView!, hasNav:Bool = false, show:((keyboardFrame:CGRect,notification:NSNotification)->())?, hide:((keyboardFrame:CGRect,notification:NSNotification)->())?) {
        super.init()
        if targetView == nil || container == nil {
            return
        }
        self.targetView = targetView
        self.targetViewOriginFrame = self.targetView.frame
        self.containerView = container
        self.containerViewOriginFrame = self.containerView.frame
        self.hasNavigationBar = hasNav
        self.keyboardShowHandler = show
        self.keyboardHideHandler = hide
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Keyboard.keyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Keyboard.keyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    deinit{
        self.keyboardHideHandler = nil
        self.keyboardShowHandler = nil
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardShow(notification:NSNotification) -> Void {
        var keyboardFrame:CGRect!
        if let userInfo = notification.userInfo {
            let userDict = NSDictionary.init(dictionary: userInfo)
            
            if let frame = userDict[UIKeyboardFrameEndUserInfoKey] {
                keyboardFrame = frame.CGRectValue()
            }else{
                keyboardFrame = CGRectZero
            }
            
            let duration = userDict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
            let curve = userDict.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
            
            UIView.animateWithDuration(duration.doubleValue, delay: 0, options: UIViewAnimationOptions.init(rawValue: curve.unsignedIntegerValue), animations: {
                let distance = keyboardFrame.size.height - self.targetView.frame.maxY
                if distance < 0{
                    if self.hasNavigationBar == true{
                        self.containerView.frame.origin.y = distance - 64
                    }else{
                        self.containerView.frame.origin.y = distance
                    }
                }
                    if let handle = self.keyboardShowHandler {
                        handle(keyboardFrame: keyboardFrame, notification: notification)
                    }
                }, completion: nil)
        }
    }
    
    func keyboardHide(notification:NSNotification) -> Void {
        if let userInfo = notification.userInfo {
            let userDict = NSDictionary.init(dictionary: userInfo)
            
            let duration = userDict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSNumber
            let curve = userDict.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as! NSNumber
            
            UIView.animateWithDuration(duration.doubleValue, delay: 0, options: UIViewAnimationOptions.init(rawValue: curve.unsignedIntegerValue), animations: {
                self.containerView.frame = self.containerViewOriginFrame
                self.targetView.frame = self.targetViewOriginFrame
                if let handle = self.keyboardHideHandler {
                    handle(keyboardFrame: CGRectZero, notification: notification)
                }
                }, completion: nil)
        }
    }
}


private class ClosureWrapper{
    var closure:((keyboardFrame:CGRect,notification:NSNotification)->())?
    init(_ closure:((keyboardFrame:CGRect,notification:NSNotification)->())?){
        self.closure = closure
    }
}


//MARK:____网络情况____
class NetworkNotification:NSObject{
    private var statusHandler:((networkStatus:NetworkStatus)->())?
    private var status:NetworkStatus = ReachableViaWiFi
    init(completionHandler:((networkStatus:NetworkStatus)->())?) {
        super.init()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.networkChange(_:)), name: NetworkStatusNotification, object: nil)
        Reachability.init(hostName: "www.baidu.com").startNotifier()
        self.statusHandler = completionHandler
    }
    
    func networkChange(note:NSNotification) -> Void {
        if let reach = note.object as? Reachability {
            let currentStatus = reach.currentReachabilityStatus()
            if currentStatus != self.status {
                if let handle = self.statusHandler {
                    handle(networkStatus: currentStatus)
                }
                self.status = currentStatus
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}






