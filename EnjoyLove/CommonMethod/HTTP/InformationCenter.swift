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
        HTTPEngine.sharedEngine().postAsyncWith(PregnancyBaseDataUrl, parameters: nil, success: { (dataTask, responseObject) in
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

/**
 *  获取孕期基础数据(根据怀孕天数获取)
 */
private let PregnancyBaseDataUrl = baseEnjoyLoveUrl + ""
class PregnancyBaseData: NSObject {
    var errorCode = ""
    var msg = ""
    
    /*
     idComBabyBaseInfo		int	是	主键
     day		int	是	天数 （根据当info_type 1=怀孕天数  2=出生天数）
     minWeight		int	是	最小体重（g）
     MaxWeight		int	是	最大体重（g）
     minHeight		int	是	最小身高（cm）
     maxHeight		int	是	最大身高（cm）
     lastDay		int	是	剩余天数（根据当infoType 1=距离预产  2=剩余母乳）

     */
    var idComBabyBaseInfo = ""
    var day = ""
    var minWeight = ""
    var MaxWeight = ""
    var minHeight = ""
    var maxHeight = ""
    var lastDay = ""
    
    /*
     infoType		int	是	数据类型（1：怀孕 2：育儿）
     */
    class func sendAsyncPregnancyBaseData(infoType:String = "", completionHandler:((data:PregnancyBaseData!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(PregnancyBaseDataUrl, parameters: ["infoType":infoType], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let baseData = PregnancyBaseData()
                baseData.errorCode = format(response["errorCode"])
                baseData.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    baseData.idComBabyBaseInfo = format(data["idComBabyBaseInfo"])
                    baseData.day = format(data["day"])
                    baseData.minWeight = format(data["minWeight"])
                    baseData.MaxWeight = format(data["MaxWeight"])
                    baseData.minHeight = format(data["minHeight"])
                    baseData.maxHeight = format(data["maxHeight"])
                    baseData.lastDay = format(data["lastDay"])
                    
                }
                if let handle = completionHandler{
                    handle(data: baseData)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(data: nil)
                }
        }
    }
}

/**
 *  获取咨讯推荐文章，分模块，每个模块一条数据，根据怀孕 、育儿天数推荐最新的
 */

private let ArticleRecomandUrl = baseEnjoyLoveUrl + ""
class ArticleRecomand: NSObject {
    /*
     idBbsNewsInfo		int		咨讯id
     newsType		int		资讯类型（1：本周宝宝状态 2：常见问题）
     idComLabelDetailsInfo		int		标签详情主键
     labelDetailsName		string		标签详情名称
     title		string		标题
     imageUrl		string		图片,多个用英文逗号隔开
     */
    
    var idBbsNewsInfo = ""
    var newsType = ""
    var idComLabelDetailsInfo = ""
    var labelDetailsName = ""
    var title = ""
    var imageUrl = ""
    var images:[String]!
    
    var errorCode = ""
    var msg = ""
    /*
     newsType		int		资讯类型（1：本周宝宝状态 2：常见问题）

     */
    class func sendAsyncArticleRecomand(newsType:String, completionHandler:((article:ArticleRecomand!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ArticleRecomandUrl, parameters: ["newsType":newsType], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let article = ArticleRecomand()
                article.errorCode = format(response["errorCode"])
                article.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    
                    article.idBbsNewsInfo = format(data["idBbsNewsInfo"])
                    article.newsType = format(data["newsType"])
                    article.idComLabelDetailsInfo = format(data["idComLabelDetailsInfo"])
                    article.title = format(data["title"])
                    article.imageUrl = format(data["imageUrl"])
                    if article.imageUrl != ""{
                       article.images = article.imageUrl.componentsSeparatedByString(",")
                    }
                }
                if let handle = completionHandler{
                    handle(article: article)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(article: nil)
                }
        }
    }
}

/**
 *  获取咨讯分类列表
 */

private let InfomationListUrl = baseEnjoyLoveUrl + ""
class InfomationList: NSObject {
    var errorCode = ""
    var msg = ""
    
    /*
     labelCode		string		标签CODE
     idComLabelDetailsInfo		int		标签详情主键
     labelDetailsName		string		标签详情名称
     count		int		文章数量


     */
    var labelCode = ""
    var idComLabelDetailsInfo = ""
    var labelDetailsName = ""
    var count = ""
    
    
    /*
     labelCode		string		标签CODE
     */
    class func sendAsyncInfomationList(labelCode:String, completionHandler:((list:InfomationList!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(InfomationListUrl, parameters: ["labelCode":labelCode], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let list = InfomationList()
                list.errorCode = format(response["errorCode"])
                list.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    list.labelCode = format(data["labelCode"])
                    list.idComLabelDetailsInfo = format(data["idComLabelDetailsInfo"])
                    list.labelDetailsName = format(data["labelDetailsName"])
                    list.count = format(data["count"])
                }
                if let handle = completionHandler{
                    handle(list: list)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(list: nil)
                }
        }
    }
}

/**
 *  获取咨讯列表
 */

private let InfoSortListUrl = baseEnjoyLoveUrl + ""
class InfoSortList: NSObject {
    /*
     labelCode		string		标签CODE
     labelDetailsName		string		标签详情名称
     labelDetailsCode		string		标签详情CODE
     count		int		文章数量

     */
    var labelCode = ""
    var labelDetailsName = ""
    var labelDetailsCode = ""
    var count = ""
    
    var errorCode = ""
    var msg = ""
    
    /*
     pageIndex		int	是	当前页
     pageSize		int	是	每页页数（最多30条）
     labelCode		string		标签CODE
     idComLabelDetailsInfo		int		标签详情主键
     */
    
    class func sendAsyncInfoSortList(pageIndex:String, pageSize:String, labelCode:String, idComLabelDetailsInfo:String, completionHandler:((sort:InfoSortList!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(InfoSortListUrl, parameters: ["pageIndex":pageIndex, "pageSize":pageSize,"labelCode":labelCode,"labelDetailsCode":idComLabelDetailsInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let sort = InfoSortList()
                sort.errorCode = format(response["errorCode"])
                sort.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    sort.labelCode = format(data["labelCode"])
                    sort.labelDetailsName = format(data["labelDetailsName"])
                    sort.labelDetailsCode = format(data["labelDetailsCode"])
                    sort.count = format(data["count"])
                }
                if let handle = completionHandler{
                    handle(sort: sort)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(sort: nil)
                }
        }
    }
}

/// 获取咨讯详情
private let InfomationDetailUrl = baseEnjoyLoveUrl + ""
class InfomationDetail: NSObject {
    
    /*
     idBbsNewsInfo		int		咨讯id
     userRangeId		int		用户范围主键（标签详情主键）
     userRangeName		string		用户范围名称（标签详情名称）
     title		string		标题
     content		string		内容
     imgList		string		图片
     imgReplaceormat		string		内容图片占位格式 【图片X】 X=第几张，替换X,然后替换content里的位置作为图片显示
     videoUrl		string		视频地址
     browseCount		int		浏览量
     create_time		string		创建时间（yyyy-MM-dd HH:mm:ss）

     */
    
    var idBbsNewsInfo = ""
    var userRangeId = ""
    var userRangeName = ""
    var title = ""
    var content = ""
    var imgList = ""
    var imgReplaceormat = ""
    var videoUrl = ""
    var browseCount = ""
    var create_time = ""
    
    var errorCode = ""
    var msg = ""
    /*
     idBbsNewsInfo		int		咨讯id
     */
    class func sendAsycInfomationDetail(idBbsNewsInfo:String, completionHandler:((detail:InfomationDetail!)->())?) ->Void{
        HTTPEngine.sharedEngine().postAsyncWith(InfomationDetailUrl, parameters: ["idBbsNewsInfo":idBbsNewsInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let detail = InfomationDetail()
                detail.errorCode = format(response["errorCode"])
                detail.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    detail.idBbsNewsInfo = format(data["idBbsNewsInfo"])
                    detail.userRangeId = format(data["userRangeId"])
                    detail.userRangeName = format(data["userRangeName"])
                    detail.title = format(data["title"])
                    detail.content = format(data["content"])
                    detail.imgList = format(data["imgList"])
                    detail.imgReplaceormat = format(data["imgReplaceormat"])
                    detail.videoUrl = format(data["videoUrl"])
                    detail.browseCount = format(data["browseCount"])
                    detail.create_time = format(data["create_time"])
                    
                }
                if let handle = completionHandler{
                    handle(detail: detail)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(detail: nil)
            }
        }
    }
}


