//
//  QiNiu.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/4.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private class QiNiuUploadHelper:NSObject{
    var singleSuccessHandler:((url:String, fileName:String)->())?
    var singleFailureBlock:((error:String)->())?
    static var shared:QiNiuUploadHelper{
        struct Helper{
            static var pred:dispatch_once_t = 0
            static var dao:QiNiuUploadHelper? = nil
        }
        
        dispatch_once(&Helper.pred) {
            Helper.dao = QiNiuUploadHelper()
        }
        return Helper.dao!
    }
    
}


/// 七牛请求接口
private let QiNiuUrl = BabyZoneConfig.shared.baseUrl + "/api/getQiniuToken"
//MARK:________________________通用接口___________________________
/// 七牛接口数据
class QiNiu: NSObject {
    
    private class func sendAsyncQiNiu(completionHandler:((token:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(QiNiuUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                if let data = response["data"] as? [String:NSObject]{
                    BabyZoneConfig.shared.QiNiuDomainName.setDefaultObject(format(data["qiNiuDomainName"]))
                    
                    if let handle = completionHandler{
                        handle(token: format(data["token"]))
                    }
                }else{
                    if let handle = completionHandler{
                        handle(token: nil)
                    }
                }
                
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(token: nil)
                }
        }
    }
    
    class func qiNiuDomain()->String{
        if let obj = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.QiNiuDomainName) as? String {
            return obj
        }
        return ""
    }
    
    //图片命名
    private class func dateTimeString()->String{
        let formatter = NSDateFormatter.init()
        formatter.dateFormat = "yyyy-MM-dd+HH:mm:ss"
        return formatter.stringFromDate(NSDate.init())
    }
    //单图片上传
    class func uploadImage(scope:String = "", image:UIImage, progressHandler:QNUpProgressHandler?, successHandler:((url:String,fileName:String)->())?, failureHandler:((error:String)->())?){
        QiNiu.sendAsyncQiNiu { (token) in
            if let tk = token{
                
                if let imageData = UIImageJPEGRepresentation(image, 0.01){
                    let fileName = "\(QiNiu.dateTimeString())_pic.png"
                    let opt = QNUploadOption.init(mime: nil, progressHandler: progressHandler, params: nil, checkCrc: false, cancellationSignal: nil)
                    
                    let uploadManager = QNUploadManager.init()
                    uploadManager.putData(imageData, key: fileName, token: tk, complete: { (responseInfo:QNResponseInfo!, key:String!, resp:[NSObject : AnyObject]!) in
                        if responseInfo.statusCode == 200 && resp != nil{
                            if let respKey = resp["key"] as? String{
                                let url = "\(QiNiu.qiNiuDomain())\(respKey)"
                                if let success = successHandler{
                                    success(url: url, fileName: respKey)
                                }
                            }else{
                                if let failuer = failureHandler{
                                    failuer(error: "获取图片失败")
                                }
                            }
                        }else{
                            if scope != ""{
                                let qnToken = QNUpToken.parse(tk)
                                if qnToken.bucket == "baby"{
                                    NSUserDefaults.standardUserDefaults().setInteger(1, forKey: BabyZoneConfig.shared.scopeType)
                                }else if qnToken.bucket == "xiangai"{
                                    NSUserDefaults.standardUserDefaults().setInteger(2, forKey: BabyZoneConfig.shared.scopeType)
                                }
                                let uploadToken = QiNiuExtensionToken.shared().makeTokenWithScope(scope)
                                uploadManager.putData(imageData, key: fileName, token: uploadToken, complete: { (responseInfo:QNResponseInfo!, key:String!, resp:[NSObject : AnyObject]!) in
                                    if responseInfo.statusCode == 200 && resp != nil{
                                        if scope == "baby"{
                                            setFoldType(BabyZoneConfig.shared.scopeType, type: 1)
                                        }else if scope == "xiangai"{
                                            setFoldType(BabyZoneConfig.shared.scopeType, type: 2)
                                        }
                                        if let respKey = resp["key"] as? String{
                                            var url = "\(BabyZoneConfig.shared.QiNiuBabyDomain)\(respKey)"
                                            if scope == BabyZoneConfig.shared.xiangaiScope{
                                                url = "\(BabyZoneConfig.shared.QiNiuXiangAiDomain)\(respKey)"
                                            }else if scope == BabyZoneConfig.shared.babyScope{
                                                url = "\(BabyZoneConfig.shared.QiNiuBabyDomain)\(respKey)"
                                            }
                                            if let success = successHandler{
                                                success(url: url, fileName: respKey)
                                            }
                                        }else{
                                            if let failuer = failureHandler{
                                                failuer(error: "获取图片失败")
                                            }
                                        }
                                    }
                                    }, option: opt)
                            }
                        }
                        }, option: opt)
                }else{
                    if let failuer = failureHandler{
                        failuer(error: "压缩图片出错")
                    }
                }
            }else{
                if let failuer = failureHandler{
                    failuer(error: "上传token出错")
                }
            }
        }
    }
    
    class func uploadImages(scope:String = "", images:[UIImage], progress:((progress:CGFloat)->())?, successHandler:((urls:[String], fileNames:[String])->())?, failureHandler:((error:String)->())?){
        var urlArray:[String] = []
        var fileNameArray:[String] = []
        
        var totalProgress:CGFloat = 0
        let partProgress:CGFloat = 1.0 / CGFloat(images.count)
        var currentIndex = 0
        QiNiuUploadHelper.shared.singleFailureBlock = { (error) in
            if let failure = failureHandler {
                failure(error: "上传失败")
            }
            return
        }
        
        QiNiuUploadHelper.shared.singleSuccessHandler = { (url, fileName) in
            urlArray.append(url)
            fileNameArray.append(fileName)
            totalProgress += partProgress
            if let pro = progress {
                pro(progress: totalProgress)
            }
            currentIndex += 1
            if urlArray.count == images.count {
                if let success = successHandler {
                    success(urls: urlArray, fileNames: fileNameArray)
                }
                return
            }else{
                if currentIndex < images.count {
                    QiNiu.uploadImage(scope, image: images[currentIndex], progressHandler: nil, successHandler: QiNiuUploadHelper.shared.singleSuccessHandler, failureHandler: QiNiuUploadHelper.shared.singleFailureBlock)
                }
            }
        }
        if images.count > 0 {
            QiNiu.uploadImage(scope, image: images[0], progressHandler: nil, successHandler: QiNiuUploadHelper.shared.singleSuccessHandler, failureHandler: QiNiuUploadHelper.shared.singleFailureBlock)
        }
    }
}

/**
 *  3.3.	获取手机应用appToken
 */
private let AppTokenUrl = BabyZoneConfig.shared.baseUrl + "/api/getAppToken"
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
private let PushTokenUrl = BabyZoneConfig.shared.baseUrl + "/api/getAppToken"

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
private let CheckVersionUrl = BabyZoneConfig.shared.baseUrl + ""
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




