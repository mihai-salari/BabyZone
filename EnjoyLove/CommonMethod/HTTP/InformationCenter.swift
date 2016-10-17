//
//  InformationCenter.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/5.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit


//MARK:_____咨讯中心接口_____
private let BabyBaseInfoUrl = baseEnjoyLoveUrl + "/api/user/getBabyBaseInfo"
extension BabyBaseInfo{
    /*
     idComBabyBaseInfo		int	是	主键
     infoType		int	是	数据类型：1：怀孕2育儿
     day		int	是	天数 （根据当info_type 1=怀孕天数  2=育儿天数）
     minWeight		double	是	最小体重（g）
     maxWeight		double	是	最大体重（g）
     minHeight		double	是	最小身高（cm）
     maxHeight		double	是	最大身高（cm）
     minHead		double	是	最小头围（cm）
     maxHead		double	是	最大头围（cm）

     */
    class func sendAsyncBabyBaseInfo(completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(BabyBaseInfoUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    let info = BabyBaseInfo()
                    info.idComBabyBaseInfo = format(data["idComBabyBaseInfo"])
                    info.day = format(data["day"])
                    info.infoType = format(data["infoType"])
                    info.minWeight = format(data["minWeight"])
                    info.maxWeight = format(data["maxWeight"])
                    info.minHeight = format(data["minHeight"])
                    info.maxHeight = format(data["maxHeight"])
                    info.minHead = format(data["minHead"])
                    info.maxHead = format(data["maxHead"])
                    BabyBaseInfoBL.insert(info)
                }
                if let handle = completionHandler{
                    handle(errorCode: errorCode, msg: msg)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription)
            }
        }
    }
}

private let ArticleRecomment = baseEnjoyLoveUrl + "/api/user/getBbsRecomment"
extension Article{
    /*
     newsType		int		资讯类型（1：怀孕 2：育儿）
     */
    class func sendAsyncRecomment(newsType: String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ArticleRecomment, parameters: ["newsType":newsType], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    let info = Article()
                    info.idBbsNewsInfo = format(data["idBbsNewsInfo"])
                    info.newsType = format(data["newsType"])
                    info.title = format(data["title"])
                    info.imageUrl = format(data["imageUrl"])
                    info.content = format(data["content"])
                    info.createTime = format(data["createTime"])
                    ArticleBL.insert(info)
                }
                if let handle = completionHandler{
                    handle(errorCode: errorCode, msg: msg)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription)
            }
        }
    }
}

private let ArticleListUrl = baseEnjoyLoveUrl + "/api/user/getBbsList"
extension ArticleList{
    
    /*
     pageIndex		int	是	当前页
     pageSize		int	是	每页页数（最多30条）
     newsType		int		资讯类型（1：怀孕 2：育儿）
     year		int		年
     month		int		月
     languageSign		string		语言

     */
    class func sendAsyncArticleList(pageIndex: String,pageSize: String,newsType: String,year: String,month: String,languageSign: String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ArticleListUrl, parameters: ["newsType":newsType], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    let info = ArticleList()
                    info.idBbsNewsInfo = format(data["idBbsNewsInfo"])
                    info.newsType = format(data["newsType"])
                    info.babyAgeYear = format(data["babyAgeYear"])
                    info.babyAgeMon = format(data["babyAgeMon"])
                    info.title = format(data["title"])
                    info.content = format(data["content"])
                    info.imgList = format(data["imgList"])
                    info.imgReplaceormat = format(data["imgReplaceormat"])
                    info.videoUrl = format(data["videoUrl"])
                    info.browseCount = format(data["browseCount"])
                    info.create_time = format(data["create_time"])
                    ArticleListBL.insert(info)
                }
                if let handle = completionHandler{
                    handle(errorCode: errorCode, msg: msg)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription)
            }
        }
    }
}






