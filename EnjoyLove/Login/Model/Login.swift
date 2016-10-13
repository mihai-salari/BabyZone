//
//  Login.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/16.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

struct ThirdLogin {
    var thirdTitle:String = ""
    var loginThird:[ThirdLoginDetail]!
}

struct ThirdLoginDetail {
    var thirdNormalImage:String = ""
    var thirdSelectedImage:String = ""
    var thirdName:String = ""
    var thirdDetailId = "1"
}

struct RegisterInfo {
    var phoneNum = ""
    var password = ""
    var validCode = ""
    
    var breedStatus = "1"
    var babySex = "1"
    var breedStatusDate = "2000-10-10"
}



