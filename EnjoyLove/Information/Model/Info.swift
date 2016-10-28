//
//  Info.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/28.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class Info: NSObject {

}

class Symptom: NSObject {
    var mainItem = ""
    var subItem = ""
}


struct PregInfoStatus {
    var pregStatusImage = ""
    var pregStatusDesc = ""
    var pregInfoData:[Article]!
    var pregBabyId = ""
    var pregMoreImage = ""
    
}


struct DiaryDoubleSelect {
    var item = ""
    var Id = ""
    
}

struct DiaryRecord {
    var emotion:[String]!
    var emotionId:[String]!
    var emotionNormalImages:[String]!
    var emotionHighlightImages:[String]!
    var grownStatus:[String]!
    var grownStatusId:[String]!
    var grownStatusNormalImages:String!
    var grownStatusHighligheImages:String!
}

struct DiaryRecordResult {
    var emotionId = ""
    var emotion = ""
    var recordDetail = ""
    var images = ""
    var statusIdArray:[String]!
    var statusArray:[String]!
}

struct BabyStatus {
    var statusTime = ""
    var statusId = ""
    var statusDetial:[StatusDetail]!
}

struct StatusDetail {
    var detailImage = ""
    var detailMainItem = ""
    var detailOutline = ""
}

struct ProblemAge {
    var ageRange = ""
    var problemList:[Problem]!
}

struct Problem {
    var mainItem = ""
    var itemCount = ""
    var itemId = ""
}



