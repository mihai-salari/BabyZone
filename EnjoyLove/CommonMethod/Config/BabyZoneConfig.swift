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
    var UserPhoneKey:String!
    var AllOrientation:String!
    var signKey:String!
    var appTokenKey:String!
    var pushTokenKey:String!
    var sessionId:String!
    var appToken:String!
    var passCode:String!
    var scope:String!
    var QiNiuXiangAiDomain:String!
    var QiNiuBabyDomain:String!
    
    
    static var shared:BabyZoneConfig{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:BabyZoneConfig? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = BabyZoneConfig()
        }
        return DAO.dao!
    }
    private func readPlist() ->Void{
        if let plistPath = NSBundle.mainBundle().pathForResource("BabyZoneConfig", ofType: "plist") {
            if let config = Configuration.init(plistPath: plistPath) {
                
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
    static let QiNiuDomain              = Key<String>("QiNiuDomain")
    static let xiangaiScope             = Key<String>("xiangaiScope")
    static let babyScope                = Key<String>("babyScope")
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
