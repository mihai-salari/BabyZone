//
//  BabyTool.swift
//  EnjoyLove
//
//  Created by 黄漫 on 2016/11/7.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

struct BabyTool {
    var title:String!
    var image:String!
    var imageWidth:CGFloat!
    var imageHeight:CGFloat!
    var list:[toolList]!
    init(title:String, image:String, imageWidth:CGFloat, imageHeight:CGFloat, list:[toolList]) {
        self.title = title
        self.image = image
        self.list = list
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
}

struct toolList {
    var title:String!
    var image:String!
    var listIndex:Int!
    var imageWidth:CGFloat!
    var imageHeight:CGFloat!
    
    
    init(title:String, image:String, imageWidth:CGFloat, imageHeight:CGFloat, index:Int) {
        self.title = title
        self.image = image
        self.listIndex = index
        self.imageWidth = imageWidth
        self.imageHeight = imageHeight
    }
}



