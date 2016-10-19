//
//  BaBy.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/24.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

struct Baby {
        /// 宝宝图片
    var babyImage = ""
        /// 异常提醒个数
    var babyRemindCount = ""
        /// 异常状态
    var babyTemperature = ""
    
    var babyHumidity = ""
    
    
}


struct BabySetting {
    var title = ""
    var setting:[SettingDetail]!
    
}

struct SettingDetail {
    var mainItem = ""
    var subItem = ""
    var videoPermission:Int = -1//0:没权限，1：有权限 其它不管
    var voicePermission:Int = -1//0:没权限，1：有权限 其它不管
    
}



struct Permission {
    var mainItem = ""
    var onTitle = ""
    var offTitle = ""
}

struct AddChildAccount {
    var title = ""
    var detail:[AccountDetail]!
    
}

struct AccountDetail {
    var mainItem = ""
    var subItem = ""
    var devicePermisson:Int = -1//0:关闭 1:打开
    var deviceId:Int = -1//设备绑定id
    
}

struct AccountInfo {
    var title = ""
    var detail:[AccountDetail]!
    
}


struct AddDevice {
    var mainItem = ""
    var itemId = ""
    var onOff:Bool = false
}

struct PlayMusic {
    var title = ""
    var detail:[PlayDetail]!
    
}

struct PlayDetail {
    var mainItem = ""
    var subItem = ""
}

struct ChildEquipmentList {
    var userRemark = ""
    var eqmDesc = ""
    
}

struct ChildEquipment {
    var title = ""
    var eqmChildList:[ChildEquipmentList]!
}



