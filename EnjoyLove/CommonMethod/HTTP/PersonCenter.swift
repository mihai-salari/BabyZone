//
//  PersonCenter.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/4.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit


//MARK:___________个人中心______________

//MARK:____发送验证码____
private let VerifyCodeUrl = BabyZoneConfig.shared.baseUrl + "/api/user/getValidCode"
class VerifyCode: NSObject {
    var errorCode = ""
    var msg = ""
    
    class func sendAsyncVerifyCode(mobile:String, type:String, completionHandler:((code:VerifyCode!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(VerifyCodeUrl, parameters: ["mobile":mobile,"type":type], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let code = VerifyCode()
                code.errorCode = format(response["errorCode"])
                code.msg = format(response["msg"])
                if let handle = completionHandler{
                    handle(code: code)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(code: nil)
            }
        }
    }
}

/**
 *  注册
 */
//MARK:___注册___
private let RegisterUrl = BabyZoneConfig.shared.baseUrl + "/api/user/register"
class Register: NSObject {
    var errorCode = ""
    var msg = ""
    var userId = ""
    var sessionId = ""
    /*
     userName		string	是	手机号码
     userPwd		string	是	密码（MD5）
     validCode		String	是	验证码
     breedStatus		int	是	孕育状态（1：未知 2：备孕 3：怀孕 4：己有宝宝）
     当前状态为3时，性别和出生日期不能为空
     babySex		int		性别(1:男 2：女)
     breedStatusDate		String		出生日期(yyyy-MM-dd)

     */
    class func sendAsyncRegist(userName:String, userPwd:String, validCode:String, breedStatus:String, babySex:String, breedStatusDate:String, completionHandler:((regist:Register!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(RegisterUrl, parameters: ["userName":userName,"userPwd":userPwd.md5,"validCode":validCode, "breedStatus":breedStatus, "babySex":babySex, "breedStatusDate":breedStatusDate], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let regist = Register()
                regist.errorCode = format(response["errorCode"])
                regist.msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    regist.userId = format(data["userId"])
                    regist.sessionId = format(data["sessionId"])
                }
                if let handle = completionHandler{
                    handle(regist: regist)
                }
            }else{
                if let handle = completionHandler{
                    handle(regist: nil)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(regist: nil)
                print("error \(error?.localizedDescription)")
            }
        }
    }
}

//MARK: 登陆
private let LoginUrl = BabyZoneConfig.shared.baseUrl + "/api/user/login"
extension Login {
    
    class func sendAsyncLogin(userName:String,userPwd:String, completionHandler:((errorCode:String?, msg:String?, dataDict:[String:NSObject]?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(LoginUrl, parameters: ["userName":userName,"userPwd":userPwd.md5], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode{
                    if let data = response["data"] as? [String:NSObject]{
                        if let handle = completionHandler{
                            handle(errorCode: errorCode, msg: msg, dataDict: data)
                        }
                    }
                }else{
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, dataDict: nil)
                    }
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(errorCode: nil, msg: error?.localizedDescription, dataDict: nil)
                }
        }
    }
}
//MARK: 退出
private let LogoutUrl = BabyZoneConfig.shared.baseUrl + "/api/user/loginOut"
class Logout: NSObject {
    var errorCode = ""
    var msg = ""
    
    class func sendAsyncLogout(completionHandler:((logout:Logout!)->())?){
        if let phone = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String {
            if let info = LoginBL.find(nil, key: phone) {
                if info.sessionId != nil && info.sessionId != "" && info.sessionId != "0"{
                    HTTPEngine.sharedEngine().postAsyncWith(LogoutUrl, parameters: nil, success: { (dataTask, responseObject) in
                        if let response = responseObject{
                            let logout = Logout()
                            logout.errorCode = format(response["errorCode"])
                            logout.msg = format(response["msg"])
                            if let handle = completionHandler{
                                handle(logout: logout)
                            }
                        }
                    }) { (dataTask, error) in
                        if let handle = completionHandler{
                            let logout = Logout()
                            logout.errorCode = "9999"
                            logout.msg = "系统错误"
                            handle(logout: logout)
                        }
                    }
                }
            }else{
                if let handle = completionHandler {
                    let logout = Logout()
                    logout.errorCode = "9999"
                    logout.msg = "系统错误"
                    handle(logout: logout)
                }
            }
        }else{
            if let handle = completionHandler {
                let logout = Logout()
                logout.errorCode = "9999"
                logout.msg = "系统错误"
                handle(logout: logout)
            }
        }
    }
}
//MARK: 个人详情
private let PersonDetailUrl = BabyZoneConfig.shared.baseUrl + "/api/user/details"
private let ModifyPersonInfoUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateUserInfo"
extension PersonDetail {
    /*
     userId		int	是	用户id
     userName		string	是	用户名
     nickName		string		昵称
     sex		int	是	性别
     headImg		string		头像
     mobile		string	是	手机号码
     breedStatus		int		孕育状态(1：正常2：备孕 3：怀孕 4：育儿)
     breedStatusDate		string		孕育状态时间(yyyy-MM-dd)
     breedBirthDate		string		孕育预产时间(yyyy-MM-dd)
     province		string		省份
     provinceCode		string		省份code
     city		string		城市
     cityCode		string		城市code
     userSign		string		个性签名
     lastLoginTime		string		最后登陆时间
     (yyyy-MM-dd HH:mm)

     */
    class func sendAsyncPersonDetail(completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(PersonDetailUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                
                if errorCode == BabyZoneConfig.shared.passCode{
                    if let data = response["data"] as? [String:NSObject]{
                        let detail = PersonDetail()
                        detail.userId = format(data["userId"])
                        detail.userName = format(data["userName"])
                        detail.nickName = format(data["nickName"])
                        detail.sex = format(data["sex"])
                        detail.headImg = format(data["headImg"])
                        let imageUrl = foldType(BabyZoneConfig.shared.scopeType, fileName: detail.headImg)
                        detail.headImage = UIImage.setImageURL(imageUrl)
                        detail.mobile = format(data["mobile"])
                        detail.breedStatus = format(data["breedStatus"])
                        detail.breedStatusDate = format(data["breedStatusDate"])
                        detail.breedBirthDate = format(data["breedBirthDate"])
                        detail.province = format(data["province"])
                        detail.provinceCode = format(data["provinceCode"])
                        detail.city = format(data["city"])
                        detail.cityCode = format(data["cityCode"])
                        detail.userSign = format(data["userSign"])
                        detail.lastLoginTime = format(data["lastLoginTime"])
                        PersonDetailBL.insert(detail)
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
    
    /*
     nickName		string		昵称
     sex		int		性别
     headImg		string		头像
     breedStatus		int		孕育状态(1：正常2：备孕 3：怀孕 4：育儿)
     breedStatusDate		string		孕育状态时间(yyyy-MM-dd)
     breedBirthDate		string		孕育预产时间(yyyy-MM-dd)
     provinceCode		string		省份code
     cityCode		string		城市code
     userSign		string		个性签名

     */
    class func sendAsyncChangePersonInfo(nickName:String,sex:String,headImg:String,breedStatus:String,breedStatusDate:String,breedBirthDate:String,province:String,provinceCode:String,city:String,cityCode:String, userSign:String,completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ModifyPersonInfoUrl, parameters: ["nickName":nickName,"sex":sex,"headImg":headImg,"breedStatus":breedStatus,"breedStatusDate":breedStatusDate,"breedBirthDate":breedBirthDate,"provinceCode":provinceCode, "province":province,"cityCode":cityCode, "city":city, "userSign":userSign], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == "0000"{
                    if let phone = NSUserDefaults.standardUserDefaults().objectForKey(BabyZoneConfig.shared.currentUserId) as? String{
                        if let login = LoginBL.find(nil, key: phone){
                            if let person = PersonDetailBL.find(nil, key: login.userId){
                                setPersonInformationChange(true)
                                person.nickName = nickName
                                person.sex = sex
                                person.headImg = headImg
                                person.breedStatus = breedStatus
                                person.breedStatusDate = breedStatusDate
                                person.breedBirthDate = breedBirthDate
                                person.province = province
                                person.provinceCode = provinceCode
                                person.city = city
                                person.cityCode = cityCode
                                person.userSign = userSign
                                PersonDetailBL.modify(person)
                            }
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

//MARK:____密码____


//MARK: 修改密码
private let ModifyPasswordUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updatePwd"
class ModifyPassword: NSObject {
    var errorCode = ""
    var msg = ""
    /*
     http://123.56.133.212:8080/xiangai-api/api/user/updatePwd?newUserPwd=fcea920f7412b5da7be0cf42b8c93759&sign=xiangai&appToken=3c9af50b-b7d3-44bc-ab23-36c892d9f4aa&sessionId=sessionid_4298ac02-a56a-4436-8245-510b633f1c33&oldUserPwd=e10adc3949ba59abbe56e057f20f883e
     */
    class func sendAsyncChangePassword(oldUserPwd:String,newUserPwd:String,completionHandler:((pwd:ModifyPassword!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ModifyPasswordUrl, parameters: ["oldUserPwd":oldUserPwd,"newUserPwd":newUserPwd.md5], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let psd = ModifyPassword()
                psd.errorCode = format(response["errorCode"])
                psd.msg = format(response["msg"])
                if let handle = completionHandler{
                    handle(pwd: psd)
                }
            }
            }) { (dataTask, error) in
                if let handle = completionHandler{
                    handle(pwd: nil)
                }
        }
    }
}
//MARK: 重设密码
private let ResetPasswordUrl = BabyZoneConfig.shared.baseUrl + ""
class ResetPassword: NSObject {
    var errorCode = ""
    var msg = ""
    class func sendAsyncChangePassword(userPwd:String,validCode:String,completionHandler:((pwd:ResetPassword!)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ResetPasswordUrl, parameters: ["userPwd":userPwd.md5,"validCode":validCode], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let psd = ResetPassword()
                psd.errorCode = format(response["errorCode"])
                psd.msg = format(response["msg"])
                if let handle = completionHandler{
                    handle(pwd: psd)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(pwd: nil)
            }
        }
    }
}

//MARK___宝宝___
private let babyListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/babyList"
private let addBabyUrl = BabyZoneConfig.shared.baseUrl + "/api/user/addBaby"
private let modifyBabyUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateBaby"
private let deleteBabyUrl = BabyZoneConfig.shared.baseUrl + "/api/user/deleteBaby"
extension BabyList{
    
    /*
      "http://123.56.133.212:8080/xiangai-api/api/user/babyList?sign=xiangai&appToken=0bd4e3f9-6c02-40f8-99c5-399fbea541bf&sessionId=sessionid_3af240a6-8930-4a8f-b60a-8fe4beed834a"
     */
    class func sendAsyncBabyList(completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(babyListUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject] {
                    if let dataList = data["list"] as? [[String:NSObject]]{
                        for dataDict in dataList{
                            let list = BabyList()
                            list.idUserBabyInfo = format(dataDict["idUserBabyInfo"])
                            list.babyName = format(dataDict["babyName"])
                            list.sex = format(dataDict["sex"])
                            list.birthday = format(dataDict["birthday"])
                            list.isCurr = format(dataDict["isCurr"])
                            BabyListBL.insert(list)
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
    
    class func sendAsyncAddBaby(babyName:String, sex:String, birthday:String, isCurr:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(addBabyUrl, parameters: ["babyName":babyName, "sex":sex, "birthday":birthday, "isCurr":isCurr], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject] {
                    let list = BabyList()
                    list.idUserBabyInfo = format(data["idUserBabyInfo"])
                    list.babyName = babyName
                    list.sex = sex
                    list.birthday = birthday
                    list.isCurr = isCurr
                    BabyListBL.insert(list)
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
    
    class func sendAsyncModifyBaby(idUserBabyInfo:String, babyName:String, sex:String, birthday:String, isCurr:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(modifyBabyUrl, parameters: ["idUserBabyInfo":idUserBabyInfo, "babyName":babyName, "sex":sex, "birthday":birthday, "isCurr":isCurr], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    let list = BabyList()
                    list.idUserBabyInfo = idUserBabyInfo
                    list.babyName = babyName
                    list.sex = sex
                    list.birthday = birthday
                    list.isCurr = isCurr
                    BabyListBL.modify(list)
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
    
    class func sendAsyncDeleteBaby(idUserBabyInfo:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(deleteBabyUrl, parameters: ["idUserBabyInfo":idUserBabyInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    if let babyInfo = BabyListBL.find(nil, key: idUserBabyInfo){
                        BabyListBL.delete(babyInfo)
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
/**
 *  添加设备
 */
//MARK: 添加设备
private let EquitementListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/eqmList"
private let AddEquipmentUrl = BabyZoneConfig.shared.baseUrl + "/api/user/addEqm"
private let UpdateEquitmentUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateEqm"
private let DeleteEquipmentUrl = BabyZoneConfig.shared.baseUrl + "/api/user/deleteEqm"
extension Equipments {
    
    /*
     idEqmInfo	int	是	设备id
     eqmName	string	是	设备名称
     eqmType	int	是	设备类型（1：摄像头）
     eqmDid	string	是	设备DID

     */
    
    class func sendAsyncEqutementList(completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(EquitementListUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    if let dataList = data["list"] as? [[String:NSObject]]{
                        for dataDict in dataList{
                            let eqm = Equipments()
                            eqm.idEqmInfo = format(dataDict["idEqmInfo"])
                            eqm.eqmName = format(dataDict["eqmName"])
                            eqm.eqmType = format(dataDict["eqmType"])
                            eqm.eqmDid = format(dataDict["eqmDid"])
                            EquipmentsBL.insert(eqm)
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
    
    /*
     eqmName		string	是	设备名称
     eqmType		int	是	设备类型（1：摄像头）
     eqmDid		string	是	设备DID
     eqmAccount		string	是	设备帐号
     eqmPwd		string	是	设备密码


     */
    class func sendAsyncAddEquitment(eqmName:String,eqmType:String,eqmDid:String,eqmAccount:String,eqmPwd:String, eqmStatus:Int32, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(AddEquipmentUrl, parameters: ["eqmName":eqmName,"eqmType":eqmType,"eqmDid":eqmDid,"eqmAccount":eqmAccount,"eqmPwd":eqmPwd], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    let addEqm = Equipments()
                    addEqm.idEqmInfo = format(data["idEqmInfo"])
                    addEqm.eqmName = eqmName
                    addEqm.eqmType = eqmType
                    addEqm.eqmDid = eqmDid
                    addEqm.eqmAccount = eqmAccount
                    addEqm.eqmPwd = eqmPwd
                    addEqm.eqmStatus = eqmStatus
                    EquipmentsBL.insert(addEqm)
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
    
    /*
     idEqmInfo		int	是	设备id
     eqmName		string		设备名称
     eqmType		int		设备类型（1：摄像头）
     eqmDid		string		设备DID
     eqmAccountName		string		设备用户名
     eqmPwd		string		设备密码

     */
    class func sendAsyncModifyEquipment(idEqmInfo:String, eqmName:String, eqmType:String, eqmDid:String, eqmAccountName:String, eqmPwd:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(UpdateEquitmentUrl, parameters: ["idEqmInfo": idEqmInfo, "eqmName":eqmName,"eqmType":eqmType,"eqmDid":eqmDid,"eqmAccountName":eqmAccountName,"eqmPwd":eqmPwd], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let handle = completionHandler{
                    handle(errorCode: errorCode, msg: msg)
                }
                
                if errorCode == BabyZoneConfig.shared.passCode {
                    let updateEqm = Equipments()
                    updateEqm.idEqmInfo = idEqmInfo
                    updateEqm.eqmName = eqmName
                    updateEqm.eqmType = eqmType
                    updateEqm.eqmDid = eqmDid
                    EquipmentsBL.modify(updateEqm)
                }
                
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription)
            }
        }
    }
    
    /*
     idEqmInfo		int	是	设备id
     eqmAccount		string	是	设备帐号
     eqmPwd		string	是	设备密码

     */
    class func sendAsyncDeleteEquipment(idEqmInfo:String, eqmUserName:String, eqmUserPwd:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(DeleteEquipmentUrl, parameters: ["idEqmInfo": idEqmInfo, "eqmAccount":eqmUserName,"eqmPwd":eqmUserPwd], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let handle = completionHandler{
                    handle(errorCode: errorCode, msg: msg)
                }
                if errorCode == BabyZoneConfig.shared.passCode{
                    EquipmentsBL.delete(nil, key: idEqmInfo)
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription)
            }
        }
    }
}


private let ChildAccountListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/childAccountList"
private let AddChildAccountUrl = BabyZoneConfig.shared.baseUrl + "/api/user/addChildAccount"
private let ModifyChildAccountUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateChildAccount"
private let DeleteChildAccountUrl = BabyZoneConfig.shared.baseUrl + "/api/user/deleteChildAccount"
extension ChildAccount{
    /*
     idUserChildInfo	int	是	用户子帐号id
     idChild	int	是	子帐号id(userId)
     childName	string	是	子帐号用户名

     */
    
    class func sendAsyncChildAccountList(completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ChildAccountListUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    if let dataList = data["childAccountList"] as? [[String:NSObject]]{
                        for dataDict in dataList{
                            let eqm = ChildAccount()
                            eqm.idUserChildInfo = format(dataDict["idUserChildInfo"])
                            eqm.idChild = format(dataDict["idChild"])
                            eqm.childName = format(dataDict["childName"])
                            eqm.childMobile = format(dataDict["childMobile"])
                            ChildAccountBL.insert(eqm)
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
    
    /*
     mobile		string		绑定用户手机(根据注册手机号绑定用户id)
     childName		string		子帐号用户名
     */
    class func sendAsyncAddChildAccount(mobile:String, childName:String, completionHandler:((errorCode:String?, msg:String?, idUserChildInfo:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(AddChildAccountUrl, parameters: ["mobile":mobile, "childName":childName], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String:NSObject]{
                    let eqm = ChildAccount()
                    eqm.idUserChildInfo = format(data["idUserChildInfo"])
                    eqm.childName = childName
                    eqm.childMobile = mobile
                    ChildAccountBL.insert(eqm)
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, idUserChildInfo: eqm.idUserChildInfo)
                    }
                }else{
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, idUserChildInfo: nil)
                    }
                }
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription, idUserChildInfo: nil)
            }
        }
    }
    
    /*
     idUserChildInfo		int	是	用户子帐号id
     childName		string	是	子帐号用户名
     */
    class func sendAsyncModifyChildAccount(idUserChildInfo: String, childName:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ModifyChildAccountUrl, parameters: ["idUserChildInfo":idUserChildInfo, "childName":childName], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    let eqm = ChildAccountBL.find(nil, key: idUserChildInfo)
                    eqm.idUserChildInfo = idUserChildInfo
                    eqm.childName = childName
                    ChildAccountBL.modify(eqm)
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
    
    
    class func sendAsyncDeleteChildAccount(idUserChildInfo:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(DeleteChildAccountUrl, parameters: ["idUserChildInfo":idUserChildInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    ChildAccountBL.delete(nil, key: idUserChildInfo)
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

//MARK:___4.21.	子帐号设备列表___
private let ChildEquipmentsListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/childAccountEqmList"
private let ModifyChildEquipmentsStatusUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateChildAccountEqmStatus"
private let ChildEquipmentsPermissonDetailUrl = BabyZoneConfig.shared.baseUrl + "/api/user/childAccountEqmPermissionDetails"
private let ModifyChildEquipmentsPermissionUrl = BabyZoneConfig.shared.baseUrl + "/api/user/updateChildAccountEqmPermission"
extension ChildEquipments{
    /*
        idUserChildInfo		int	是	用户子帐号id
     */
    class func sendAsyncChildEquipmentsList(idUserChildInfo:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ChildEquipmentsListUrl, parameters: ["idUserChildInfo":idUserChildInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    if let data = response["data"] as? [String:NSObject]{
                        if let dataList = data["list"] as? [[String:NSObject]]{
                            for dataDict in dataList{
                                let eqms = ChildEquipments()
                                eqms.idEqmInfo = format(dataDict["idEqmInfo"])
                                eqms.eqmName = format(dataDict["eqmName"])
                                eqms.eqmStatus = format(dataDict["eqmStatus"])
                                eqms.idUserChildEqmInfo = format(dataDict["idUserChildEqmInfo"])
                                ChildEquipmentsBL.insert(eqms)
                            }
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
    
    /*
     idUserChildInfo		int	是	用户子帐号id
     idEqmInfo		int	是	设备id
     eqmStatus		int	是	设备状态(1：开 2：关)
     
     */
    class func sendAsyncModifyChildEquipmentsStatus(idUserChildInfo:String, idEqmInfo:String, eqmStatus:String, completionHandler:((errorCode:String?, msg:String?, idUserChildEqmInfo:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ModifyChildEquipmentsStatusUrl, parameters: ["idUserChildInfo":idUserChildInfo, "idEqmInfo":idEqmInfo, "eqmStatus":eqmStatus], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    if let data = response["data"] as? [String:NSObject]{
                        let eqms = ChildEquipments()
                        eqms.eqmStatus = eqmStatus
                        eqms.idUserChildEqmInfo = format(data["idUserChildEqmInfo"])
                        ChildEquipmentsBL.modify(eqms)
                        if let handle = completionHandler{
                            handle(errorCode: errorCode, msg: msg, idUserChildEqmInfo: eqms.idUserChildEqmInfo)
                        }
                    }
                }else{
                    if let handle = completionHandler{
                        handle(errorCode: errorCode, msg: msg, idUserChildEqmInfo: nil)
                    }
                }
                
            }
        }) { (dataTask, error) in
            if let handle = completionHandler{
                handle(errorCode: nil, msg: error?.localizedDescription, idUserChildEqmInfo: nil)
            }
        }
    }
    
    class func sendAsyncChildEquipmentsPermissionDetail(idUserChildEqmInfo:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ChildEquipmentsPermissonDetailUrl, parameters: ["idUserChildEqmInfo":idUserChildEqmInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    if let data = response["data"] as? [String:NSObject]{
                        let eqms = ChildEquipments()
//                        eqms.idUserChildEqmPermission = format(data["idUserChildEqmPermission"])
//                        eqms.idUserEqmInfo = format(data["idUserEqmInfo"])
//                        eqms.voicePermission = format(data["voicePermission"])
//                        eqms.imagePermission = format(data["imagePermission"])
                        ChildEquipmentsBL.insert(eqms)
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
    
    
    class func sendAsyncModifyChildEquipmentsPermission(idUserChildEqmPermission:String, idUserChildEqmInfo:String, voicePermission:String, imagePermission:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(ModifyChildEquipmentsPermissionUrl, parameters: ["idUserChildEqmPermission":idUserChildEqmPermission, "idUserChildEqmInfo":idUserChildEqmInfo, "voicePermission":voicePermission, "imagePermission":imagePermission], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    let eqms = ChildEquipments()
//                    eqms.idUserChildEqmPermission = idUserChildEqmPermission
//                    eqms.idUserChildEqmInfo = idUserChildEqmInfo //idUserChildEqmInfo
//                    eqms.voicePermission = voicePermission
//                    eqms.imagePermission = imagePermission
                    ChildEquipmentsBL.modify(eqms)
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

//MARK:___4.26.	获取心情日记标签___
private let UserNoteLabelUrl = BabyZoneConfig.shared.baseUrl + "/api/user/getUserNoteLabel"
extension NoteLabel{
    class func sendAsyncUserNoteLabel(completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(UserNoteLabelUrl, parameters: nil, success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String: NSObject] {
                    if let list = data["list"] as? [[String : NSObject]]{
                        for listDict in list{
                            let noteLabel = NoteLabel()
                            noteLabel.labelName = format(listDict["labelName"])
                            NoteLabelBL.insert(noteLabel)
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

//MARK:___Diary___
private let UserNoteListUrl = BabyZoneConfig.shared.baseUrl + "/api/user/getUserNoteList"
private let AddUserNoteUrl = BabyZoneConfig.shared.baseUrl + "/api/user/addUserNote"
private let DeleteUserNoteUrl = BabyZoneConfig.shared.baseUrl + "/api/user/deleteUserNote"
extension Diary{
    class func sendAsyncUserNoteList(pageIndex: String, year:String, month:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(UserNoteListUrl, parameters: ["pageIndex":"1", "pageSize":pageIndex, "year":year, "month":month,], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                print("response === \(response)")
                if let data = response["data"] as? [String: NSObject] {
                    if let list = data["list"] as? [[String : NSObject]]{
                        for listDict in list{
                            let diary = Diary()
                            diary.idUserNoteInfo = format(listDict["idUserNoteInfo"])
                            diary.noteType = format(listDict["noteType"])
                            diary.moodStatus = format(listDict["moodStatus"])
                            diary.noteLabel = format(listDict["noteLabel"])
                            diary.content = format(listDict["content"])
                            diary.imgUrls = format(listDict["imgUrls"])
                            diary.idUserBabyInfo = format(listDict["idUserBabyInfo"])
                            diary.breedStatusDate = format(listDict["breedStatusDate"])
                            diary.createTime = format(listDict["createTime"])
                            DiaryBL.insert(diary)
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
    
    class func sendAsyncAddUserNote(moodStatus: String, noteLabel:String, content:String, imgUrls:String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(AddUserNoteUrl, parameters: ["moodStatus":moodStatus, "noteLabel":noteLabel, "content":content, "imgUrls":imgUrls,], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if let data = response["data"] as? [String: NSObject] {
                    let diary = Diary()
                    diary.idUserNoteInfo = format(data["idUserNoteInfo"])
                    diary.moodStatus = moodStatus
                    diary.content = content
                    diary.imgUrls = imgUrls
                    DiaryBL.insert(diary)
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
    
    class func sendAsyncDeleteUserNote(idUserNoteInfo: String, completionHandler:((errorCode:String?, msg:String?)->())?){
        HTTPEngine.sharedEngine().postAsyncWith(DeleteUserNoteUrl, parameters: ["idUserNoteInfo":idUserNoteInfo], success: { (dataTask, responseObject) in
            if let response = responseObject{
                let errorCode = format(response["errorCode"])
                let msg = format(response["msg"])
                if errorCode == BabyZoneConfig.shared.passCode {
                    let diary = DiaryBL.find(nil, key: idUserNoteInfo)
                    DiaryBL.delete(diary)
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


