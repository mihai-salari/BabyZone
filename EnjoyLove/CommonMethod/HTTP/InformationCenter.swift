//
//  InformationCenter.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/5.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit


//MARK:_____咨讯中心接口_____
private let BabyBaseInfoUrl = BabyZoneConfig.shared.baseUrl + "/api/user/getBabyBaseInfo"
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
    class func sendAsyncBabyBaseInfo(idUserBabyInfo: String = "", completionHandler:((errorCode:String?, msg:String?, baseInfo:BabyBaseInfo?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(BabyBaseInfoUrl, parameters: ["idUserBabyInfo":idUserBabyInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    let info = BabyBaseInfo()
                    info.idComBabyBaseInfo = format(data["idComBabyBaseInfo"])
                    info.day = format(data["day"])
                    info.infoType = format(data["infoType"])
                    info.idUserBabyInfo = format(data["idUserBabyInfo"])
                    info.minWeight = format(data["minWeight"])
                    info.maxWeight = format(data["maxWeight"])
                    info.minHeight = format(data["minHeight"])
                    info.maxHeight = format(data["maxHeight"])
                    info.minHead = format(data["minHead"])
                    info.maxHead = format(data["maxHead"])
                    BabyBaseInfoBL.insert(info)
                    BabyZoneConfig.shared.BabyBaseInfoKey.setDefaultString(format(data["idComBabyBaseInfo"]))
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, baseInfo: info)
                    }
                }else{
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, baseInfo: nil)
                    }
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription, baseInfo: nil)
            }
        }
    }
}

private let ArticleRecomment = BabyZoneConfig.shared.baseUrl + "/api/user/getBbsRecomment"
extension Article{
    /*
     newsType		int		资讯类型（1：怀孕 2：育儿）
     */
    class func sendAsyncRecomment(newsType: String, completionHandler:((errorCode:String?, msg:String?, info:Article?)->())?){
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
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, info: info)
                    }
                }else{
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, info: nil)
                    }
                }
                
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription, info: nil)
            }
        }
    }
}

private let ArticleTypeListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/getBbsTypeList"

extension ArticleTypeList{
    /*
     languageSign		string		语言
     */
    /*
     pageIndex		int	是	当前页
     pageSize		int	是	每页页数（最多30条）
     newsType		int		资讯类型（1：怀孕 2：育儿）
     year		int		年
     month		int		月
     languageSign		string		语言
     
     */
    class func sendAsyncArticleList(languageSign: String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ArticleTypeListUrl, parameters: ["languageSign":languageSign], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    if let list = data["list"] as? [[String:NSObject]]{
                        for listDict in list {
                            let info = ArticleTypeList()
                            info.typeName = format(listDict["typeName"])
                            info.year = format(listDict["year"])
                            info.month = format(listDict["month"])
                            ArticleTypeListBL.insert(info)
                        }
                    }
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

private let ArticleListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/getBbsList"
private let updateBbsCollectionUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateBbsCollection"
extension ArticleList{
    
    /*
     pageIndex		int	是	当前页
     pageSize		int	是	每页页数（最多30条）
     newsType		int		资讯类型（1：怀孕 2：育儿）
     year		int		年
     month		int		月
     languageSign		string		语言

     */
    class func sendAsyncArticleList(pageSize: String,newsType: String,year: String,month: String,languageSign: String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ArticleListUrl, parameters: ["newsType":newsType, "pageIndex":"1", "pageSize":pageSize, "year":year, "month":month, "languageSign":languageSign], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    if let list = data["list"] as? [[String:NSObject]]{
                        for listDict in list {
                            let info = ArticleList()
                            info.idBbsNewsInfo = format(listDict["idBbsNewsInfo"])
                            info.newsType = format(listDict["newsType"])
                            info.babyAgeYear = format(listDict["babyAgeYear"])
                            info.babyAgeMon = format(listDict["babyAgeMon"])
                            info.title = format(listDict["title"])
                            info.content = format(listDict["content"])
                            info.imgList = format(listDict["imgList"])
                            info.imgReplaceormat = format(listDict["imgReplaceormat"])
                            info.videoUrl = format(listDict["videoUrl"])
                            info.browseCount = format(listDict["browseCount"])
                            info.createTime = format(listDict["createTime"])
                            info.operateType = "2"
                            ArticleListBL.insert(info)
                        }
                    }
                    
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
    
    class func sendAsyncArticleCollection(idBbsNewsInfo: String,operateType: String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ArticleListUrl, parameters: ["idBbsNewsInfo":idBbsNewsInfo, "operateType":operateType], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    if let articleList = ArticleListBL.find(idBbsNewsInfo) {
                        articleList.operateType = operateType
                        ArticleListBL.modify(articleList)
                    }
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






