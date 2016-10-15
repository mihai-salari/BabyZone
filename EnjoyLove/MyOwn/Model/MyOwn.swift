//
//  MyOwn.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class MyOwn: NSObject {
    
}

class MyOwnHeader: NSObject {
    var header = "mamaHeader.png"
    var nickName = "KLKLIHDS"
    var desc = "待签名"
    var postNum = "0"
    var careNum = "0"
    var fansNum = "0"
    var collectionNum = "0"
}



struct MyOwnNormalRowData {
    var mainItem = ""
    var subItem = ""
}

struct MyOwnSectionTitle {
    var title = ""
    var rowData:[MyOwnNormalRowData]!
    
}

struct PersonEditInfo {
    var title = ""
    var detail:[PersonEidtDetail]!
}

struct PersonEidtDetail {
    var mainTitle = ""
    var subItem = ""
    var isHeader:Bool!
    var eidtType:Int!
    var babyId:String = ""
    
}

struct EditPersonInfo {
    
    /*
     headImg		string		头像
     breedStatus		int		孕育状态(1：正常2：备孕 3：怀孕 4：育儿)
     breedStatusDate		string		孕育状态时间(yyyy-MM-dd)
     breedBirthDate		string		孕育预产时间(yyyy-MM-dd)
     provinceCode		string		省份code
     cityCode		string		城市code
     userSign		string		个性签名

     */
    var headImage = ""
    var breedStatus = ""
    var breedStatusDate = ""
    var breedBirthDate = ""
    var provinceCode = ""
    var cityCode = ""
    var userSign = ""
}

struct BabyInfo {
    var mainItem = ""
    var subItem = ""
    var infoType:Int!//0:姓名,1性别,2年龄
}

struct AddBaby {
    var nickName = ""
    var sex = ""
    var birthday = ""
}

struct SecurityAndAccount {
    var title = ""
    var security:[Security]!
}

struct Security {
    var mainItem = ""
    var subItem = ""
    var itemType:Int = 0
}

private let bandingPhoneKey = "bandingPhoneKey"
struct BandingPhone {
    var phoneNum = ""
    var status:Bool = false
    static func bandingPhone(banding:Bool){
        NSUserDefaults.standardUserDefaults().setBool(banding, forKey: bandingPhoneKey)
    }
    static func isBanding() -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(bandingPhoneKey)
    }
}

private let bandingWeChatKey = "bandingWeChatKey"
struct BandingWeChat {
    var wechatNum = ""
    var status:Bool = false
    static func bandingWeChat(banding:Bool){
        NSUserDefaults.standardUserDefaults().setBool(banding, forKey: bandingWeChatKey)
    }
    
    static func isBanding() -> Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(bandingWeChatKey)
    }
}

struct Privacy {
    var title = ""
    var detail:[PrivacyDetail]!
    
}

struct PrivacyDetail {
    var mainItem = ""
    var subItem = ""//0 关闭 1 打开
    
}

struct CheckPermission {
    var item:String = ""
    var itemId:String = ""
}

struct OtherItem {
    var item = ""
    var itemId:Int = 0
}

struct Language {
    var languageType = ""
    var languageId:Int = 0
    var languageUsed:Bool = false
    
}

