//
//  BabyZoneConfig.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/15.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyZoneConfig: NSObject {
    /*
     static let UserPhoneKey             = Key<String>("UserPhoneKey")
     static let AllOrientation           = Key<String>("AllOrientation")
     static let signKey                  = Key<String>("signKey")
     static let appTokenKey              = Key<String>("appTokenKey")
     static let pushTokenKey             = Key<String>("pushTokenKey")
     static let sessionId                = Key<String>("sessionId")
     static let appToken                 = Key<String>("appToken")
     static let passCode                 = Key<String>("passCode")
     static let scope                    = Key<String>("scope")
     static let QiNiuXiangAiDomain       = Key<String>("QiNiuXiangAiDomain")
     static let QiNiuBabyDomain          = Key<String>("QiNiuBabyDomain")
     */
    var QiNiuDomain:String!
    var xiangaiScope:String!
    var babyScope:String!
    var QiNiuScope:String!
    var QiNiuXiangAiDomain:String!
    var QiNiuBabyDomain:String!
    var UserPhoneKey:String!
    var AllOrientation:String!
    var signKey:String!
    var appTokenKey:String!
    var pushTokenKey:String!
    var sessionId:String!
    var sign:String!
    var appToken:String!
    var passCode:String!
    var scopeType:String!
    
    
    static var shared:BabyZoneConfig{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:BabyZoneConfig? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = BabyZoneConfig.init()
        }
        return DAO.dao!
    }
    
    private override init() {
        super.init()
        self.readPlist()
    }
    
    private func readPlist() ->Void{
        if let plistPath = NSBundle.mainBundle().pathForResource("BabyZoneConfig", ofType: "plist") {
            if let config = Configuration.init(plistPath: plistPath) {
                self.QiNiuDomain = config.get(.QiNiuDomain)
                self.xiangaiScope = config.get(.xiangaiScope)
                self.babyScope = config.get(.babyScope)
                self.UserPhoneKey = config.get(.UserPhoneKey)
                self.AllOrientation = config.get(.AllOrientation)
                self.signKey = config.get(.signKey)
                self.appTokenKey = config.get(.appTokenKey)
                self.pushTokenKey = config.get(.pushTokenKey)
                self.sessionId = config.get(.sessionId)
                self.sign = config.get(.sign)
                self.appToken = config.get(.appToken)
                self.passCode = config.get(.passCode)
                self.QiNiuScope = config.get(.QiNiuScope)
                self.QiNiuXiangAiDomain = config.get(.QiNiuXiangAiDomain)
                self.QiNiuBabyDomain = config.get(.QiNiuBabyDomain)
                self.scopeType = config.get(.scopeType)
            }
            
        }
        
        
    }
}

public protocol PlistValueType {}

extension String: PlistValueType {}
extension NSURL: PlistValueType {}
extension NSNumber: PlistValueType {}
extension Int: PlistValueType {}
extension Float: PlistValueType {}
extension Double: PlistValueType {}
extension Bool: PlistValueType {}
extension NSDate: PlistValueType {}
extension NSData: PlistValueType {}
extension Array: PlistValueType {}
extension Dictionary: PlistValueType {}

/// Extend this class and add your plist keys as static constants
/// so you can use the shortcut dot notation (e.g. ` configuration.get(.yourKey)`)

public class Keys {}

public final class Key<ValueType: PlistValueType>: Keys {
    
    public let key: String
    
    internal var separatedKeys: [String] {
        return key.componentsSeparatedByString(".")
    }
    
    public init(_ key: String) {
        self.key = key
    }
    
}

extension Keys{
    static let QiNiuDomain                      = Key<String>("QiNiuDomain")
    static let xiangaiScope                     = Key<String>("xiangaiScope")
    static let babyScope                        = Key<String>("babyScope")
    static let UserPhoneKey                     = Key<String>("UserPhoneKey")
    static let AllOrientation                   = Key<String>("AllOrientation")
    static let signKey                          = Key<String>("signKey")
    static let appTokenKey                      = Key<String>("appTokenKey")
    static let pushTokenKey                     = Key<String>("pushTokenKey")
    static let sessionId                        = Key<String>("sessionId")
    static let sign                             = Key<String>("sign")
    static let appToken                         = Key<String>("appToken")
    static let passCode                         = Key<String>("passCode")
    static let QiNiuScope                       = Key<String>("QiNiuScope")
    static let QiNiuXiangAiDomain               = Key<String>("QiNiuXiangAiDomain")
    static let QiNiuBabyDomain                  = Key<String>("QiNiuBabyDomain")
    static let scopeType                        = Key<String>("scopeType")
}


public struct Configuration {
    
    private let dictionary: NSDictionary
    
    public init?(plistPath: String) {
        guard let plist = NSDictionary(contentsOfFile: plistPath) else {
            assertionFailure("could not read plist file.")
            return nil
        }
        dictionary = plist
    }
    
    public func get<T>(key: Key<T>) -> T? {
        var object: AnyObject = dictionary
        
        key.separatedKeys.enumerate().forEach { (idx: Int, separatedKey: String) in
            if let index = Int(separatedKey) {
                let array = object as! Array<AnyObject>
                object = array[index]
            } else {
                let dictionary = object as! NSDictionary
                object = dictionary[separatedKey]! as AnyObject
            }
        }
        
        let optionalValue: T?
        
        switch T.self {
        case is Int.Type:    optionalValue = object as? T
        case is Float.Type:  optionalValue = object.floatValue as? T
        case is Double.Type: optionalValue = object.doubleValue as? T
        case is NSURL.Type:  optionalValue = NSURL(string: (object as? String) ?? "") as? T
        default:             optionalValue = object as? T
        }
        
        guard let value = optionalValue else {
            return nil
        }
        
        return value
    }
    
}
