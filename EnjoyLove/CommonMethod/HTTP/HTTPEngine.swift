//
//  HMHTTP.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/4.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

/*
 OperationCode 操作码
 
 0000	操作成功	操作成功
 4001	参数不全	参数不全
 4002	参数格式错误	参数格式错误
 4003	签名验证失败	签名验证失败
 4004	资源不存在	资源不存在
 4006	方法错误	方法错误
 4007	操作不可执行	操作不可执行
 9999	系统错误	系统错误

 
 */



class HTTPEngine: NSObject {
    
    private lazy var manager:AFHTTPSessionManager = {
        let httpManager = AFHTTPSessionManager()
        httpManager.requestSerializer = AFHTTPRequestSerializer()
        httpManager.requestSerializer.timeoutInterval = 10
        httpManager.responseSerializer = AFHTTPResponseSerializer()
        return httpManager
    }()
    
    class func sharedEngine() ->HTTPEngine{
        struct Engine{
            static var pred:dispatch_once_t = 0
            static var shared:HTTPEngine? = nil
        }
        dispatch_once(&Engine.pred) { 
            Engine.shared = HTTPEngine()
        }
        return Engine.shared!
    }
    
    func postAsyncWith(url:String, parameters:[String:NSObject]?, success:((dataTask:NSURLSessionDataTask, responseObject:NSDictionary?)->())?, failer:((dataTask:NSURLSessionDataTask?, error:NSError?)->())?) -> NSURLSessionDataTask? {
        
        var phone = ""
        if let phoneKey = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String {
            phone = phoneKey
        }
        let info = LoginBL.find(phone)
        var resultParams:[String:NSObject] = [:]
        if let params = parameters {
            for (key, value) in params {
                resultParams[key] = value
            }
        }
        resultParams[BabyZoneConfig.shared.signKey] = BabyZoneConfig.shared.sign
        if let token = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.appTokenKey) as? String{
            resultParams[BabyZoneConfig.shared.appToken] = token
        }
        
        if let sessionId = info == nil ? "0" : info!.sessionId {
            if sessionId == "" {
                resultParams[BabyZoneConfig.shared.sessionId] = "0"
            }else{
                resultParams[BabyZoneConfig.shared.sessionId] = sessionId
            }
        }
        
        
        print("url--->\(url) params\(resultParams)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return self.manager.POST(url, parameters: resultParams, progress: { (progress:NSProgress) in
            
            }, success: { (dataTask:NSURLSessionDataTask, responseObject:AnyObject?) in
                if let response = responseObject{
                    if response.isKindOfClass(NSData){
                        let responseData = response as! NSData
                        var jsonDict:NSDictionary?
                        do{
                            jsonDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            if jsonDict == nil{
                                jsonDict = NSDictionary.init(XMLData: responseData)
                            }
                        }catch{
                            jsonDict = NSDictionary.init(XMLData: responseData)
                        }
                        
                        if let successHandle = success{
                            successHandle(dataTask: dataTask, responseObject: jsonDict)
                        }
                    }
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, failure: { (dataTask:NSURLSessionDataTask?, error:NSError) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let failHandle = failer{
                    failHandle(dataTask: dataTask, error: error)
                }
        })

        return nil
    }
    
    func postAsyncVideoWith(url:String, parameters:[String:NSObject]?, success:((dataTask:NSURLSessionDataTask, responseObject:NSDictionary?)->())?, failer:((dataTask:NSURLSessionDataTask?, error:NSError?)->())?) -> NSURLSessionDataTask? {
        
        print("url--->\(url) params\(parameters)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        return self.manager.POST(url, parameters: parameters, progress: { (progress:NSProgress) in
            
            }, success: { (dataTask:NSURLSessionDataTask, responseObject:AnyObject?) in
                if let response = responseObject{
                    if response.isKindOfClass(NSData){
                        let responseData = response as! NSData
                        var jsonDict:NSDictionary?
                        do{
                            jsonDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                            if jsonDict == nil{
                                jsonDict = NSDictionary.init(XMLData: responseData)
                            }
                        }catch{
                            jsonDict = NSDictionary.init(XMLData: responseData)
                        }
                        
                        if let successHandle = success{
                            successHandle(dataTask: dataTask, responseObject: jsonDict)
                        }
                    }
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, failure: { (dataTask:NSURLSessionDataTask?, error:NSError) in
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                if let failHandle = failer{
                    failHandle(dataTask: dataTask, error: error)
                }
        })
    }
}


