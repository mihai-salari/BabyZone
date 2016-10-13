//
//  WIFI.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/26.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
import SystemConfiguration
import SystemConfiguration.CaptiveNetwork

class WIFI: NSObject {
    
    class func getMAC()->(success:Bool,ssid:String,mac:String){
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    let ssid = dict["SSID"]!
                    let mac  = dict["BSSID"]!
                    return (true,ssid as! String,mac as! String)
                }
            }
        }
        return (false,"","")
    }
    
    class func getSSID() -> String{
        if let cfa:NSArray = CNCopySupportedInterfaces() {
            for x in cfa {
                if let dict = CFBridgingRetain(CNCopyCurrentNetworkInfo(x as! CFString)) {
                    if let ssid = dict["SSID"] as? String {
                        return ssid
                    }
                    return ""
                }
            }
        }
        return ""
    }
}
