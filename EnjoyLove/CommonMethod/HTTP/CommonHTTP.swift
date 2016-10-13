//
//  QiNiu.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/4.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let baseEnjoyLoveUrl = "http://123.56.133.212:8080/xiangai-api"


/// 七牛请求接口
private let QiNiuUrl = baseEnjoyLoveUrl + "/api/getQiniuToken"
//MARK:________________________通用接口___________________________
/// 七牛接口数据
class QiNiu: NSObject {
    var errorCode = ""
    var msg = ""
    var dataToken = ""
    var dataQiNiuDomainName = ""
    
    class func sendAsyncQiNiu(completionHandler:((qiniu:QiNiu!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(QiNiuUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let qiniu = QiNiu()
                qiniu.errorCode = format(response["token"])
                qiniu.msg = format(response["qiNiuDomainName"])
                if let data = response["data"] as? [String:NSObject]{
                    qiniu.dataToken = format(data["token"])
                    qiniu.dataQiNiuDomainName = format(data["qiNiuDomainName"])
                }
                if let handle = completionHandler{
                    handle(qiniu: qiniu)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(qiniu: nil)
                }
        }
    }
}

/**
 *  3.3.	获取手机应用appToken
 */
private let AppTokenUrl = baseEnjoyLoveUrl + "/api/getAppToken"
class AppToken: NSObject {
    var appToken = ""
    var errorCode = ""
    var msg = ""
    
    class func sendAsyncAppToken(appChannel:String, completionHandler:((token:AppToken!)->())?) {
        let osVersion = UIDevice.currentDevice().systemVersion
        let phoneModel = UIDevice.currentDevice().model
        let info = NSBundle.mainBundle().infoDictionary
        var appVersion = ""
        if let appInfo = info {
            appVersion = format(appInfo["CFBundleShortVersionString"])
        }
        
        let size = UIScreen.mainScreen().bounds.size
        let scale = UIScreen.mainScreen().scale
        let wResolution = Int(size.width * scale)
        let hResolution = Int(size.height * scale)
        let resolution = "\(wResolution) * \(hResolution)"
        
        /*
        print("AppTokenUrl \(AppTokenUrl)?os=ios&osVersion=\(osVersion)&phoneModel=\(phoneModel)&phoneDpi=\(resolution)&appVersion=\(appVersion)&appChannel=\(resolution)")
        
         http://123.56.133.212:8080/xiangai-api/api/getAppToken?os=ios&osVersion=9.3.2&phoneModel=iPod touch&phoneDpi=640.0 * 1136.0&appVersion=1.0&appChannel=640 * 1136&sign=xiangai&sessionId=0
         */
        HTTPEngine.sharedEngine().postAsyncWith(AppTokenUrl, parameters: ["os":"ios", "osVersion":osVersion, "phoneModel":phoneModel, "phoneDpi":resolution, "appVersion":appVersion, "appChannel":appChannel], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let token = AppToken()
                token.errorCode = format(response["errorCode"])
                token.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    token.appToken = format(data["appToken"])
                }
                if let handle = completionHandler{
                    handle(token: token)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(token: nil)
                }
        }
    }
}

/// 上传pushToken
private let PushTokenUrl = baseEnjoyLoveUrl + "/api/getAppToken"

class PushToken: NSObject {
    var errorCode = ""
    var msg = ""
    
    class func sendAsyncPushToken(token:String, completionHandler:((pushToken:PushToken!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(PushTokenUrl, parameters: ["os":"ios","pushToken":token], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let push = PushToken()
                push.errorCode = format(response["errorCode"])
                push.msg = format(response["msg"])
                if let handle = completionHandler{
                    handle(pushToken: push)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(pushToken: nil)
                }
        }
    }
}

/// 查询最新版本
private let CheckVersionUrl = baseEnjoyLoveUrl + ""
class CheckVersion: NSObject {
    var appVersionName = ""
    var appVersion = ""
    var appUrl = ""
    var errorCode = ""
    var msg = ""
    
    class func sendAsyncCheckVersion(appChannel:String, completionHandler:((version:CheckVersion!)->( ))?){
        HTTPEngine.sharedEngine().postAsyncWith(CheckVersionUrl, parameters: ["os":"ios","appChannel":appChannel], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let version = CheckVersion()
                version.errorCode = format(response["errorCode"])
                version.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    version.appVersionName = format(data["appVersionName"])
                    version.appUrl = format(data["appUrl"])
                    version.appVersion = format(data["appVersion"])
                }
                if let handle = completionHandler{
                    handle(version: version)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(version: nil)
                }
        }
    }
}




