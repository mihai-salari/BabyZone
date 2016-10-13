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
    var pregInfoData:[InfoStatus]!
    var pregBabyId = ""
    var pregMoreImage = ""
    
}

struct InfoStatus {
    var pregMainImage = ""
    var pregItem = ""
    var pregSubItem = ""
    var pregItemId = ""
    var pregItemDate = ""
    var pregCellHeight:CGFloat = 0
}

struct PregBabyInfo {
    var pregBabyDate = ""
    var pregDate = ""
    var pregProgress:CGFloat = 0
    var pregWeight = ""
    var pregHeight = ""
    var pregOutDay = ""
    var pregBabyImage = ""
}

class PregDiary: NSObject {
    var image:String = ""
    var imageEdge:String = ""
    var date1:String = ""
    var tips:[String]!
    var face:String = ""
    var weight:String = ""
    var desc:String = ""
    var date2:String = ""
    
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



