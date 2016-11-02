//
//  HMDatabase.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/11.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

//MARK:____Login____
private let LoginArchiveKey = "LoginArchiveKey"
private let LoginArchiveFileName = "LoginArchive.archive"

class Login: NSObject,NSCoding {
    /*
     userId		int	是	用户id
     nickName		string		昵称
     userSign		string		用户个性签名
     userName		string	是	用户名
     
     headImg		string		头像
     sessionId		string	是	登陆会话
     isHasNote		int	是	是否有日记（1：有 2：没有）
     bbsCollNum		int	是	资讯收藏数

     */
    var userId:String!
    var sessionId:String!
    var userName:String!
    var userPhone:String!
    var userAccount:String!
    var contactId:String!
    var password:String!
    var md5Password:String!
    var isRegist:NSNumber!
    var nickName:String!
    var userSign:String!
    var headImage:String!
    var isHasNote:String!
    var bbsCollNum:String!
    
    override init() {
        self.userId = ""
        self.sessionId = ""
        self.userName = ""
        self.userPhone = ""
        self.userAccount = ""
        self.contactId = ""
        self.password = ""
        self.md5Password = ""
        self.nickName = ""
        self.userSign = ""
        self.headImage = ""
        self.isHasNote = ""
        self.bbsCollNum = ""
        self.isRegist = NSNumber.init(bool: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let obj = aDecoder.decodeObjectForKey("userId") as? String {
            self.userId = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userName") as? String {
            self.userName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("sessionId") as? String {
            self.sessionId = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userPhone") as? String {
            self.userPhone = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userAccount") as? String {
            self.userAccount = obj
        }
        if let obj = aDecoder.decodeObjectForKey("password") as? String {
            self.password = obj
        }
        if let obj = aDecoder.decodeObjectForKey("md5Password") as? String {
            self.md5Password = obj
        }
        if let obj = aDecoder.decodeObjectForKey("isRegist") as? NSNumber {
            self.isRegist = obj
        }
        if let obj = aDecoder.decodeObjectForKey("nickName") as? String {
            self.nickName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userSign") as? String {
            self.userSign = obj
        }
        if let obj = aDecoder.decodeObjectForKey("headImage") as? String {
            self.headImage = obj
        }
        if let obj = aDecoder.decodeObjectForKey("isHasNote") as? String {
            self.isHasNote = obj
        }
        if let obj = aDecoder.decodeObjectForKey("bbsCollNum") as? String {
            self.bbsCollNum = obj
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userId, forKey: "userId")
        aCoder.encodeObject(self.userName, forKey: "userName")
        aCoder.encodeObject(self.sessionId, forKey: "sessionId")
        aCoder.encodeObject(self.userPhone, forKey: "userPhone")
        aCoder.encodeObject(self.userAccount, forKey: "userAccount")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeObject(self.md5Password, forKey: "md5Password")
        aCoder.encodeObject(self.isRegist, forKey: "isRegist")
        aCoder.encodeObject(self.nickName, forKey: "nickName")
        aCoder.encodeObject(self.userSign, forKey: "userSign")
        aCoder.encodeObject(self.headImage, forKey: "headImage")
        aCoder.encodeObject(self.isHasNote, forKey: "isHasNote")
        aCoder.encodeObject(self.bbsCollNum, forKey: "bbsCollNum")
    }
    
}

private class LoginDAO:NSObject{
    static var shared:LoginDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var shared:LoginDAO? = nil
        }
        dispatch_once(&DAO.pred) {
            DAO.shared = LoginDAO()
        }
        return DAO.shared!
    }
    func findAll() -> [Login] {
        var listData = [Login]()
        if let theData = NSData.init(contentsOfFile: LoginArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(LoginArchiveKey) as? [Login]{
                    listData.appendContentsOf(arr)
                }
            }
        }
        return listData
    }
    
    func insert(detail:Login) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.userId == detail.userId {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: LoginArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(LoginArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(userId:String) -> Bool {
        var array = self.findAll()
        for note in array {
            if note.userId == userId {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: LoginArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(LoginArchiveFileName.filePath(), atomically: true)
    }
    
    func modify(detail:Login) -> Bool {
        let array = self.findAll()
        for note in array {
            if note.userId == detail.userId {
                if note.userName != detail.userName {
                    note.userName = detail.userName
                }
                if note.sessionId != detail.sessionId {
                    note.sessionId = detail.sessionId
                }
                if note.userPhone != detail.userPhone {
                    note.userPhone = detail.userPhone
                }
                if note.password != detail.password {
                    note.password = detail.password
                }
                if note.md5Password != detail.md5Password {
                    note.md5Password = detail.md5Password
                }
                if note.isRegist != detail.isRegist {
                    note.isRegist = detail.isRegist
                }
                if note.nickName != detail.nickName {
                    note.nickName = detail.nickName
                }
                if note.userSign != detail.userSign {
                    note.userSign = detail.userSign
                }
                if note.headImage != detail.headImage {
                    note.headImage = detail.headImage
                }
                if note.isHasNote != detail.isHasNote {
                    note.isHasNote = detail.isHasNote
                }
                if note.bbsCollNum != detail.bbsCollNum {
                    note.bbsCollNum = detail.bbsCollNum
                }
            }
        }
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: LoginArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(LoginArchiveFileName.filePath(), atomically: true)
    }
    
    func clear(userId:String) ->Bool{
        let array = self.findAll()
        for note in array {
            if note.userId == userId {
                note.userName = ""
                note.sessionId = ""
                note.contactId = ""
                note.password = ""
                note.md5Password = ""
                note.headImage = ""
                note.isHasNote = ""
                note.bbsCollNum = ""
                note.isRegist = NSNumber.init(bool: false)
                break
            }
        }
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: LoginArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(LoginArchiveFileName.filePath(), atomically: true)
    }
    
    func find(userId:String) -> Login? {
        let array = self.findAll()
        for note in array {
            if note.userId == userId {
                return note
            }
        }
        return nil
    }
}

class LoginBL: NSObject {
    
    class func isLogin(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Bool{
        if let user = LoginDAO.shared.find(userId) {
            return user.sessionId != "" && user.sessionId != nil && user.sessionId != "0"
        }
        return false
    }
    
    class func insert(detail:Login) -> [Login]{
        LoginDAO.shared.insert(detail)
        return LoginDAO.shared.findAll()
    }
    
    class func modify(detail:Login) ->[Login]{
        LoginDAO.shared.modify(detail)
        return LoginDAO.shared.findAll()
    }
    
    class func clear(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Bool{
        return LoginDAO.shared.clear(userId)
    }
    
    class func find(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Login?{
        return LoginDAO.shared.find(userId)
    }
    
    class func findAll() ->[Login]{
        return LoginDAO.shared.findAll()
    }
}

//MARK:____PersonDetail____
class PersonDetail : NSObject ,NSCoding{
    
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
    
    var userId:String!
    var userName:String!
    var nickName:String!
    var sex:String!
    var headImg:String!
    var headImage:UIImage!
    var mobile:String!
    var breedStatus:String!//妈妈状态(1：正常2：备孕 3：怀孕 4：育儿)
    var breedStatusDate:String!//妈妈状态时间(yyyy-MM-dd)
    var breedBirthDate:String!//妈妈预产时间(yyyy-MM-dd)
    var province:String!//省份
    var provinceCode:String!//省份code
    var city:String!//城市
    var cityCode:String!//城市code
    var userSign:String!
    var lastLoginTime:String!//最后登陆时间(yyyy-MM-dd HH:mm)
    
    override init() {
        self.userId = ""
        self.userName = ""
        self.nickName = ""
        self.sex = ""//1：男 2：女
        self.headImg = ""
        self.headImage = UIImage.init()
        self.mobile = ""
        self.breedStatus = ""
        self.breedStatusDate = ""
        self.breedBirthDate = ""
        self.province = ""
        self.provinceCode = ""
        self.city = ""
        self.cityCode = ""
        self.userSign = ""
        self.lastLoginTime = ""
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("userId") as? String {
            self.userId = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userName") as? String {
            self.userName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("nickName") as? String {
            self.nickName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("sex") as? String {
            self.sex = obj
        }
        if let obj = aDecoder.decodeObjectForKey("headImg") as? String {
            self.headImg = obj
        }
        if let obj = aDecoder.decodeObjectForKey("headImage") as? UIImage {
            self.headImage = obj
        }
        if let obj = aDecoder.decodeObjectForKey("mobile") as? String {
            self.mobile = obj
        }
        if let obj = aDecoder.decodeObjectForKey("breedStatus") as? String {
            self.breedStatus = obj
        }
        if let obj = aDecoder.decodeObjectForKey("breedStatusDate") as? String {
            self.breedStatusDate = obj
        }
        if let obj = aDecoder.decodeObjectForKey("breedBirthDate") as? String {
            self.breedBirthDate = obj
        }
        if let obj = aDecoder.decodeObjectForKey("province") as? String {
            self.province = obj
        }
        if let obj = aDecoder.decodeObjectForKey("provinceCode") as? String {
            self.provinceCode = obj
        }
        if let obj = aDecoder.decodeObjectForKey("city") as? String {
            self.city = obj
        }
        if let obj = aDecoder.decodeObjectForKey("cityCode") as? String {
            self.cityCode = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userSign") as? String {
            self.userSign = obj
        }
        if let obj = aDecoder.decodeObjectForKey("lastLoginTime") as? String {
            self.lastLoginTime = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userId, forKey: "userId")
        aCoder.encodeObject(self.userName, forKey: "userName")
        aCoder.encodeObject(self.nickName, forKey: "nickName")
        aCoder.encodeObject(self.sex, forKey: "sex")
        aCoder.encodeObject(self.headImg, forKey: "headImg")
        aCoder.encodeObject(self.headImage, forKey: "headImage")
        aCoder.encodeObject(self.mobile, forKey: "mobile")
        aCoder.encodeObject(self.breedStatus, forKey: "breedStatus")
        aCoder.encodeObject(self.breedStatusDate, forKey: "breedStatusDate")
        aCoder.encodeObject(self.breedBirthDate, forKey: "breedBirthDate")
        aCoder.encodeObject(self.province, forKey: "province")
        aCoder.encodeObject(self.provinceCode, forKey: "provinceCode")
        aCoder.encodeObject(self.city, forKey: "city")
        aCoder.encodeObject(self.cityCode, forKey: "cityCode")
        aCoder.encodeObject(self.userSign, forKey: "userSign")
        aCoder.encodeObject(self.lastLoginTime, forKey: "lastLoginTime")
        
    }
}


private let PersonDetailArchiveKey = "PersonDetailArchive"
private let PersonDetailArchiveFileName = "PersonDetailArchive.archive"
private class PersonDetailDAO: NSObject{
    
    static var shared:PersonDetailDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var shared:PersonDetailDAO? = nil
        }
        dispatch_once(&DAO.pred) { 
            DAO.shared = PersonDetailDAO()
        }
        return DAO.shared!
    }
    
    func findAll(userId:String) -> [PersonDetail] {
        var listData = [PersonDetail]()
        if let theData = NSData.init(contentsOfFile: PersonDetailArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let detailDict = unArchive.decodeObjectForKey(PersonDetailArchiveKey) as? [String:NSObject]{
                    if let details = detailDict[userId] as? [PersonDetail]{
                        listData.appendContentsOf(details)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(userId:String, detail:PersonDetail) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.userId == detail.userId {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: PersonDetailArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(PersonDetailArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(accountUserId:String, detailUserId:String) -> Bool {
        var array = self.findAll(accountUserId)
        for note in array {
            if note.userId == detailUserId {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[accountUserId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: PersonDetailArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(PersonDetailArchiveFileName.filePath(), atomically: true)
    }
    
    func modify(detail:PersonDetail, accountUserId:String) -> Bool {
        let array = self.findAll(accountUserId)
        for note in array {
            if note.userId == detail.userId {
                if note.mobile != detail.mobile {
                    note.mobile = detail.mobile
                }
                if note.userName != detail.userName {
                    note.userName = detail.userName
                }
                if note.nickName != detail.nickName {
                    note.nickName = detail.nickName
                }
                if note.sex != detail.sex {
                    note.sex = detail.sex
                }
                if note.headImg != detail.headImg {
                    note.headImg = detail.headImg
                }
                if note.headImage != detail.headImage {
                    note.headImage = detail.headImage
                }
                if note.breedStatus != detail.breedStatus {
                    note.breedStatus = detail.breedStatus
                }
                if note.breedStatusDate != detail.breedStatusDate {
                    note.breedStatusDate = detail.breedStatusDate
                }
                if note.breedBirthDate != detail.breedBirthDate {
                    note.breedBirthDate = detail.breedBirthDate
                }
                if note.province != detail.province {
                    note.province = detail.province
                }
                if note.provinceCode != detail.provinceCode {
                    note.provinceCode = detail.provinceCode
                }
                if note.city != detail.city {
                    note.city = detail.city
                }
                if note.cityCode != detail.cityCode {
                    note.cityCode = detail.cityCode
                }
                if note.userSign != detail.userSign {
                    note.userSign = detail.userSign
                }
                if note.lastLoginTime != detail.lastLoginTime {
                    note.lastLoginTime = detail.lastLoginTime
                }
            }
        }
        
        var arrDict:[String:NSObject] = [:]
        arrDict[accountUserId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: PersonDetailArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(PersonDetailArchiveFileName.filePath(), atomically: true)
    }
    
    func find(detailUserId:String, accountUserId:String) -> PersonDetail? {
        let array = self.findAll(accountUserId)
        for note in array {
            if note.userId == detailUserId {
                return note
            }
        }
        return nil
    }
}

class PersonDetailBL: NSObject {
    class func insert(detail:PersonDetail,userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [PersonDetail]{
        PersonDetailDAO.shared.insert(userId, detail: detail)
        return PersonDetailDAO.shared.findAll(userId)
    }
    
    class func delete(detailUserId:String = BabyZoneConfig.shared.currentUserId.defaultString(), userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[PersonDetail]{
        PersonDetailDAO.shared.delete(userId, detailUserId: detailUserId)
        return PersonDetailDAO.shared.findAll(userId)
    }
    
    class func modify(detail:PersonDetail, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->PersonDetail?{
        PersonDetailDAO.shared.modify(detail, accountUserId: userId)
        return PersonDetailDAO.shared.find(detail.userId, accountUserId: userId)
    }
    
    class func find(detailUserId:String = BabyZoneConfig.shared.currentUserId.defaultString(), userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->PersonDetail?{
        return PersonDetailDAO.shared.find(detailUserId, accountUserId: userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[PersonDetail]{
        return PersonDetailDAO.shared.findAll(userId)
    }
    
}


//MARK:____BabyList____
private let BabyListArchiveKey = "BabyListArchive"
private let BabyListArchiveFileName = "BabyListArchive.archive"

class BabyList: NSObject, NSCoding {
    
    /*
     
     list(列表)	
     
     idUserBabyInfo	int	是	宝宝id
     babyName	string	是	宝宝名称
     sex	int	是	宝宝性别（1：男 2：女）
     birthday	string	是	出生日期（yyyy-MM-dd）
     isCurr	int	是	是否当前宝宝（1：是 2：否）

     */
    var idUserBabyInfo:String!
    var babyName:String!
    var sex:String!
    var birthday:String!
    var isCurr:String!
    
    override init() {
        self.idUserBabyInfo = ""
        self.babyName = ""
        self.sex = ""
        self.birthday = ""
        self.isCurr = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idUserBabyInfo") as? String {
            self.idUserBabyInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("babyName") as? String {
            self.babyName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("sex") as? String {
            self.sex = obj
        }
        if let obj = aDecoder.decodeObjectForKey("birthday") as? String {
            self.birthday = obj
        }
        if let obj = aDecoder.decodeObjectForKey("isCurr") as? String {
            self.isCurr = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idUserBabyInfo, forKey: "idUserBabyInfo")
        aCoder.encodeObject(self.babyName, forKey: "babyName")
        aCoder.encodeObject(self.sex, forKey: "sex")
        aCoder.encodeObject(self.birthday, forKey: "birthday")
        aCoder.encodeObject(self.isCurr, forKey: "isCurr")
    }
    
}

private class BabyListDAO:NSObject{
    static var shared:BabyListDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:BabyListDAO? = nil
        }
        
        dispatch_once(&DAO.pred) { 
            DAO.dao = BabyListDAO()
        }
        return DAO.dao!
    }
    
    func findAll(userId:String) -> [BabyList] {
        var listData = [BabyList]()
        if let theData = NSData.init(contentsOfFile: BabyListArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(BabyListArchiveKey) as? [String:NSObject]{
                    if let list = arrDict[userId] as? [BabyList] {
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:BabyList, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idUserBabyInfo == detail.idUserBabyInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }else{
                base.isCurr = "2"
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: BabyListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(idUserBabyInfo:String, userId:String) -> Bool {
        var array = self.findAll(userId)
        for note in array {
            if note.idUserBabyInfo == idUserBabyInfo {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: BabyListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
    }
    
    
    func modify(detail:BabyList, userId:String) -> Bool {
        let array = self.findAll(userId)
        for note in array {
            if note.idUserBabyInfo == detail.idUserBabyInfo {
                if note.babyName != detail.babyName {
                    note.babyName = detail.babyName
                }
                if note.birthday != detail.birthday {
                    note.birthday = detail.birthday
                }
                if note.isCurr != detail.isCurr {
                    note.isCurr = detail.isCurr
                }
                if note.sex != detail.sex {
                    note.sex = detail.sex
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: BabyListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
    }
    
    func find(userId:String, idUserBabyInfo:String) -> BabyList? {
        let array = self.findAll(userId)
        for note in array {
            if note.idUserBabyInfo == idUserBabyInfo {
                return note
            }
        }
        return nil
    }
}

class BabyListBL: NSObject {
    
    class func insert(detail:BabyList, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [BabyList]{
        BabyListDAO.shared.insert(detail, userId: userId)
        return BabyListDAO.shared.findAll(userId)
    }
    
    class func delete(idUserBabyInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[BabyList]{
        BabyListDAO.shared.delete(idUserBabyInfo, userId: userId)
        return BabyListDAO.shared.findAll(userId)
    }
    
    class func modify(detail:BabyList, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[BabyList]{
        BabyListDAO.shared.modify(detail, userId: userId)
        return BabyListDAO.shared.findAll(userId)
    }
    
    class func find(idUserBabyInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->BabyList?{
        return BabyListDAO.shared.find(userId, idUserBabyInfo: idUserBabyInfo)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[BabyList]{
        return BabyListDAO.shared.findAll(userId)
    }
}

private let UserNoteLabelArchiveKey = "UserNoteLabelArchiveKey"
private let UserNoteLabelArchiveName = "UserNoteLabelArchive.archive"
class NoteLabel: NSObject,NSCoding {
    /*
        labelName	string	是	标签名称
     */
    var labelName = ""
    
    override init() {
        self.labelName = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("labelName") as? String {
            self.labelName = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.labelName, forKey: "labelName")
    }
}

class NoteLabelDAO: NSObject {
    static var shared:NoteLabelDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:NoteLabelDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = NoteLabelDAO()
        }
        return DAO.dao!
    }
    
    func findViaLabels(labels:[String], userId:String) -> [String] {
        var resultLabels:[String] = []
        let labelCount = labels.count
        let noteNames = self.findAll(userId)
        let noteNameCount = noteNames.count
        let loopCount = noteNameCount < labelCount ? noteNameCount : labelCount
        for i in 0 ..< loopCount {
            let label = labels[i]
            if label == "1" {
                resultLabels.append(noteNames[i].labelName)
            }
        }
        return resultLabels
    }
    
    func findAll(userId:String) -> [NoteLabel] {
        var listData = [NoteLabel]()
        if let theData = NSData.init(contentsOfFile: UserNoteLabelArchiveName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(UserNoteLabelArchiveKey) as? [String:NSObject]{
                    if let notes = arrDict[userId] as? [NoteLabel] {
                        listData.appendContentsOf(notes)
                    }
                }
            }
        }
        return listData
    }
    
    
    func insert(detail:NoteLabel, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.labelName == detail.labelName {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: UserNoteLabelArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(UserNoteLabelArchiveName.filePath(), atomically: true)
    }
}

class NoteLabelBL: NSObject {
    class func insert(detail:NoteLabel, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [NoteLabel]{
        NoteLabelDAO.shared.insert(detail, userId: userId)
        return NoteLabelDAO.shared.findAll(userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[NoteLabel]{
        return NoteLabelDAO.shared.findAll(userId)
    }
    
    class func findVia(labels:[String], userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[String]{
        return NoteLabelDAO.shared.findViaLabels(labels, userId: userId)
    }
}

private let BabyBaseInfoArchiveKey = "BabyBaseInfoArchiveKey"
private let BabyBaseInfoArchiveName = "BabyBaseInfoArchiveName.archive"
class BabyBaseInfo: NSObject,NSCoding {
    /*
     
     idUserBabyInfo		int	否	宝宝id(如果为空，则获取当前用户孕育状态;如果不为空，则取当前宝宝id对应数据)
     
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
    var idComBabyBaseInfo:String!
    var infoType:String!
    var idUserBabyInfo:String!
    var day:String!
    var minWeight:String!
    var maxWeight:String!
    var minHeight:String!
    var maxHeight:String!
    var minHead:String!
    var maxHead:String!
    let babyHeadImage:String = "pregBaby.png"
    
    
    override init() {
        self.idComBabyBaseInfo = ""
        self.infoType = ""
        self.idUserBabyInfo = ""
        self.day = ""
        self.minWeight = ""
        self.maxWeight = ""
        self.minHeight = ""
        self.maxHeight = ""
        self.minHead = ""
        self.maxHead = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idComBabyBaseInfo") as? String {
            self.idComBabyBaseInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("idUserBabyInfo") as? String {
            self.idUserBabyInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("infoType") as? String {
            self.infoType = obj
        }
        if let obj = aDecoder.decodeObjectForKey("day") as? String {
            self.day = obj
        }
        if let obj = aDecoder.decodeObjectForKey("minWeight") as? String {
            self.minWeight = obj
        }
        if let obj = aDecoder.decodeObjectForKey("maxWeight") as? String {
            self.maxWeight = obj
        }
        if let obj = aDecoder.decodeObjectForKey("minHeight") as? String {
            self.minHeight = obj
        }
        if let obj = aDecoder.decodeObjectForKey("maxHeight") as? String {
            self.maxHeight = obj
        }
        if let obj = aDecoder.decodeObjectForKey("minHead") as? String {
            self.minHead = obj
        }
        if let obj = aDecoder.decodeObjectForKey("maxHead") as? String {
            self.maxHead = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idComBabyBaseInfo, forKey: "idComBabyBaseInfo")
        aCoder.encodeObject(self.idUserBabyInfo, forKey: "idUserBabyInfo")
        aCoder.encodeObject(self.infoType, forKey: "infoType")
        aCoder.encodeObject(self.day, forKey: "day")
        aCoder.encodeObject(self.minWeight, forKey: "minWeight")
        aCoder.encodeObject(self.maxWeight, forKey: "maxWeight")
        aCoder.encodeObject(self.minHeight, forKey: "minHeight")
        aCoder.encodeObject(self.maxHeight, forKey: "maxHeight")
        aCoder.encodeObject(self.minHead, forKey: "minHead")
        aCoder.encodeObject(self.maxHead, forKey: "maxHead")
    }
}

private class BabyBaseInfoDAO: NSObject {
    static var shared:BabyBaseInfoDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:BabyBaseInfoDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = BabyBaseInfoDAO()
        }
        return DAO.dao!
    }
    
    
    func findAll(userId:String) -> [BabyBaseInfo] {
        var listData = [BabyBaseInfo]()
        if let theData = NSData.init(contentsOfFile: BabyBaseInfoArchiveName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(BabyBaseInfoArchiveKey) as? [String:NSObject]{
                    if let infos = arrDict[userId] as? [BabyBaseInfo] {
                        listData.appendContentsOf(infos)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:BabyBaseInfo, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idComBabyBaseInfo == detail.idComBabyBaseInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: BabyBaseInfoArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyBaseInfoArchiveName.filePath(), atomically: true)
        
    }
    
    func delete(idComBabyBaseInfo:String, userId:String) -> Bool {
        var array = self.findAll(userId)
        for note in array {
            if note.idComBabyBaseInfo == idComBabyBaseInfo {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: BabyBaseInfoArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyBaseInfoArchiveName.filePath(), atomically: true)
    }
    
    func modify(detail:BabyBaseInfo, userId:String) -> Bool {
        let array = self.findAll(userId)
        for note in array {
            if note.idComBabyBaseInfo == detail.idComBabyBaseInfo {
                if note.infoType != detail.infoType {
                    note.infoType = detail.infoType
                }
                if note.idUserBabyInfo != detail.idUserBabyInfo {
                    note.idUserBabyInfo = detail.idUserBabyInfo
                }
                if note.day != detail.day {
                    note.day = detail.day
                }
                if note.minWeight != detail.minWeight {
                    note.minWeight = detail.minWeight
                }
                if note.maxWeight != detail.maxWeight {
                    note.maxWeight = detail.maxWeight
                }
                if note.minHeight != detail.minHeight {
                    note.minHeight = detail.minHeight
                }
                if note.maxHeight != detail.maxHeight {
                    note.maxHeight = detail.maxHeight
                }
                if note.minHead != detail.minHead {
                    note.minHead = detail.minHead
                }
                if note.maxHead != detail.maxHead {
                    note.maxHead = detail.maxHead
                }
            }
        }
        
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: BabyBaseInfoArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyBaseInfoArchiveName.filePath(), atomically: true)
    }
    
    func find(idComBabyBaseInfo:String, userId:String) -> BabyBaseInfo? {
        let array = self.findAll(userId)
        for note in array {
            if note.idComBabyBaseInfo == idComBabyBaseInfo {
                return note
            }
        }
        return nil
    }

}

class BabyBaseInfoBL: NSObject {
    class func insert(detail:BabyBaseInfo, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [BabyBaseInfo]{
        BabyBaseInfoDAO.shared.insert(detail, userId: userId)
        return BabyBaseInfoDAO.shared.findAll(userId)
    }
    
    class func delete(idComBabyBaseInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[BabyBaseInfo]{
        BabyBaseInfoDAO.shared.delete(idComBabyBaseInfo, userId: userId)
        return BabyBaseInfoDAO.shared.findAll(userId)
    }
    
    class func modify(detail:BabyBaseInfo, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[BabyBaseInfo]{
        BabyBaseInfoDAO.shared.modify(detail, userId: userId)
        return BabyBaseInfoDAO.shared.findAll(userId)
    }
    
    class func find(idComBabyBaseInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->BabyBaseInfo?{
        return BabyBaseInfoDAO.shared.find(idComBabyBaseInfo, userId: userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[BabyBaseInfo]{
        return BabyBaseInfoDAO.shared.findAll(userId)
    }
    
}

//MARK:____Equipments____
private let EquipmentsArchiveKey = "EquipmentsArchive"
private let EquipmentsArchiveFileName = "EquipmentsArchive.archive"
class Equipments: NSObject,NSCoding {
    /*
     idEqmInfo	int	是	设备id
     eqmName	string	是	设备名称
     eqmType	int	是	设备类型（1：摄像头）
     eqmDid	string	是	设备DID
     eqmAccount	string	是	设备帐号
     eqmPwd	string	是	设备密码
     eqmLevel	int	是	设备级别（1：主设备 2：子帐号设备（无权修改设备信息））

     */
    var idEqmInfo:String!
    var eqmName:String!
    var eqmType:String!
    var eqmDid:String!
    var eqmAccount:String!
    var eqmPwd:String!
    var eqmLevel:String!
    
    var eqmStatus:Int32!
    var eqmMessageCount:Int32!
    var defenceState:Int32!
    var isClickDefenceStateBtn:Bool!
    var isGettingOnLineState:Bool!
    
    
    
    override init() {
        self.idEqmInfo = ""
        self.eqmName = ""
        self.eqmType = ""
        self.eqmDid = ""
        self.eqmAccount = ""
        self.eqmPwd = ""
        self.eqmLevel = ""
        self.eqmStatus = 0
        self.eqmMessageCount = 0
        self.defenceState = 0
        self.isClickDefenceStateBtn = false
        self.isGettingOnLineState = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idEqmInfo") as? String {
            self.idEqmInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmName") as? String {
            self.eqmName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmType") as? String {
            self.eqmType = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmDid") as? String {
            self.eqmDid = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmAccount") as? String {
            self.eqmAccount = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmPwd") as? String {
            self.eqmPwd = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmLevel") as? String {
            self.eqmLevel = obj
        }
        
        self.eqmStatus = aDecoder.decodeIntForKey("eqmStatus")
        self.eqmMessageCount = aDecoder.decodeIntForKey("eqmMessageCount")
        self.defenceState = aDecoder.decodeIntForKey("defenceState")
        self.isClickDefenceStateBtn = aDecoder.decodeBoolForKey("isClickDefenceStateBtn")
        self.isGettingOnLineState = aDecoder.decodeBoolForKey("isGettingOnLineState")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idEqmInfo, forKey: "idEqmInfo")
        aCoder.encodeObject(self.eqmName, forKey: "eqmName")
        aCoder.encodeObject(self.eqmType, forKey: "eqmType")
        aCoder.encodeObject(self.eqmDid, forKey: "eqmDid")
        aCoder.encodeObject(self.eqmAccount, forKey: "eqmAccount")
        aCoder.encodeObject(self.eqmPwd, forKey: "eqmPwd")
        aCoder.encodeObject(self.eqmLevel, forKey: "eqmLevel")
        aCoder.encodeInt(self.eqmStatus, forKey: "eqmStatus")
        aCoder.encodeInt(self.eqmMessageCount, forKey: "eqmMessageCount")
        aCoder.encodeInt(self.defenceState, forKey: "defenceState")
        aCoder.encodeBool(self.isClickDefenceStateBtn, forKey: "isClickDefenceStateBtn")
        aCoder.encodeBool(self.isGettingOnLineState, forKey: "isGettingOnLineState")
    }
    
}

private class EquipmentsDAO:NSObject{
    static var shared:EquipmentsDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:EquipmentsDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = EquipmentsDAO()
        }
        return DAO.dao!
    }
    
    func findAll(userId: String) -> [Equipments] {
        var listData = [Equipments]()
        if let theData = NSData.init(contentsOfFile: EquipmentsArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(EquipmentsArchiveKey) as? [String:NSObject]{
                    if let eqms = arrDict[userId] as? [Equipments] {
                        listData.appendContentsOf(eqms)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:Equipments, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idEqmInfo == detail.idEqmInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        let contact = Contact()
        contact.contactId = detail.eqmDid
        contact.contactName = detail.eqmName
        contact.contactPassword = detail.eqmPwd
        if detail.eqmDid.characters.first != "0" {
            contact.contactType = Int.init(CONTACT_TYPE_UNKNOWN)
        }else{
            contact.contactType = Int.init(CONTACT_TYPE_PHONE)
        }
        FListManager.sharedFList().insert(contact)
        P2PClient.sharedClient().getContactsStates([contact.contactId])
        P2PClient.sharedClient().getDefenceState(contact.contactId, password: contact.contactPassword)
        
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: EquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(idEqmInfo:String, userId:String) -> Bool {
        var array = self.findAll(userId)
        for note in array {
            if note.idEqmInfo == idEqmInfo {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                    FListManager.sharedFList().delete(EquipmentsBL.contactFromEquipment(note))
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: EquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
    }
    
    func modify(detail:Equipments, userId:String) -> Bool {
        let array = self.findAll(userId)
        for note in array {
            if note.idEqmInfo == detail.idEqmInfo {
                if note.eqmName != detail.eqmName {
                    note.eqmName = detail.eqmName
                }
                if note.eqmType != detail.eqmType {
                    note.eqmType = detail.eqmType
                }
                if note.eqmDid != detail.eqmDid {
                    note.eqmDid = detail.eqmDid
                }
                
                if note.eqmAccount != detail.eqmAccount {
                    note.eqmAccount = detail.eqmAccount
                }
                
                if note.eqmPwd != detail.eqmPwd {
                    note.eqmPwd = detail.eqmPwd
                }
                if note.eqmLevel != detail.eqmLevel {
                    note.eqmLevel = detail.eqmLevel
                }
                
                
                if note.eqmStatus != detail.eqmStatus {
                    note.eqmStatus = detail.eqmStatus
                }
                if note.eqmMessageCount != detail.eqmMessageCount {
                    note.eqmMessageCount = detail.eqmMessageCount
                }
                if note.defenceState != detail.defenceState {
                    note.defenceState = detail.defenceState
                }
                if note.isClickDefenceStateBtn != detail.isClickDefenceStateBtn {
                    note.isClickDefenceStateBtn = detail.isClickDefenceStateBtn
                }
                if note.isGettingOnLineState != detail.isGettingOnLineState {
                    note.isGettingOnLineState = detail.isGettingOnLineState
                }
                FListManager.sharedFList().update(EquipmentsBL.contactFromEquipment(note))
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: EquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
    }
    
    func find(idEqmInfo:String, userId:String) -> Equipments? {
        let array = self.findAll(userId)
        for note in array {
            if note.idEqmInfo == idEqmInfo {
                return note
            }
        }
        return nil
    }
    
    func deleteAll(userId:String) -> Bool {
        var array = self.findAll(userId)
        array.removeAll()
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: EquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
    }
    
}

class EquipmentsBL: NSObject {
    class func insert(detail:Equipments, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [Equipments]{
        EquipmentsDAO.shared.insert(detail, userId: userId)
        return EquipmentsDAO.shared.findAll(userId)
    }
    
    class func delete(idEqmInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[Equipments]{
        EquipmentsDAO.shared.delete(idEqmInfo, userId: userId)
        return EquipmentsDAO.shared.findAll(userId)
    }
    
    class func modify(detail:Equipments, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[Equipments]{
        EquipmentsDAO.shared.modify(detail, userId: userId)
        return EquipmentsDAO.shared.findAll(userId)
    }
    
    class func find(idEqmInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Equipments?{
        return EquipmentsDAO.shared.find(idEqmInfo, userId: userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[Equipments]{
        return EquipmentsDAO.shared.findAll(userId)
    }
    
    class func deleteAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> Void{
        EquipmentsDAO.shared.deleteAll(userId)
    }
    
    class func contactsFromEquipments(eqms:[Equipments]) -> [Contact]{
        var contacts:[Contact] = []
        for eqm in eqms {
            contacts.append(self.contactFromEquipment(eqm))
        }
        return contacts
    }
    
    class func contactFromEquipment(eqm:Equipments) -> Contact{
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            for contact in contacts {
                if contact.contactId == eqm.eqmDid {
                    return contact
                }
            }
        }
        return Contact()
    }
    
    class func equipmentFromContact(contact:Contact) ->Equipments{
        let eqms = EquipmentsBL.findAll()
        if eqms.count > 0 {
            for eqm in eqms {
                if eqm.eqmDid == contact.contactId {
                    return eqm
                }
            }
        }
        return Equipments()
    }
    
    class func equipmentsFromContacts(contacts:[Contact]) -> [Equipments]{
        var eqms:[Equipments] = []
        for contact in contacts {
            eqms.append(self.equipmentFromContact(contact))
        }
        return eqms
    }
}

//MARK:____ChildAccount____
private let ChildAccountArchiveKey = "ChildAccountArchiveKey"
private let ChildAccountArchiveFileName = "ChildAccountArchive.archive"
class ChildAccount: NSObject {
    var idUserChildInfo:String!
    var idChild:String!
    var childName:String!
    var childMobile:String!
    
    
    override init() {
        self.idUserChildInfo = ""
        self.idChild = ""
        self.childName = ""
        self.childMobile = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idUserChildInfo") as? String {
            self.idUserChildInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("idChild") as? String {
            self.idChild = obj
        }
        if let obj = aDecoder.decodeObjectForKey("childName") as? String {
            self.childName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("childMobile") as? String {
            self.childMobile = obj
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idUserChildInfo, forKey: "idUserChildInfo")
        aCoder.encodeObject(self.idChild, forKey: "idChild")
        aCoder.encodeObject(self.childName, forKey: "childName")
        aCoder.encodeObject(self.childMobile, forKey: "childMobile")
    }
}

private class ChildAccountDAO: NSObject {
    static var shared:ChildAccountDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:ChildAccountDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = ChildAccountDAO()
        }
        return DAO.dao!
    }
    
    func findAll(userId:String) -> [ChildAccount] {
        var listData = [ChildAccount]()
        if let theData = NSData.init(contentsOfFile: ChildAccountArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(ChildAccountArchiveKey) as? [String:NSObject]{
                    if let list = arrDict[userId] as? [ChildAccount]  {
                       listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:ChildAccount, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idUserChildInfo == detail.idUserChildInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildAccountArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildAccountArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(idUserChildInfo:String, userId:String) -> Bool {
        var array = self.findAll(userId)
        for note in array {
            if note.idUserChildInfo == idUserChildInfo {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: ChildAccountArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildAccountArchiveFileName.filePath(), atomically: true)
    }
    
    func modify(detail:ChildAccount, userId:String) -> Bool {
        let array = self.findAll(userId)
        for note in array {
            if note.idUserChildInfo == detail.idUserChildInfo {
                if note.childName != detail.childName {
                    note.childName = detail.childName
                }
                if note.idChild != detail.idChild {
                    note.idChild = detail.idChild
                }
                if note.childMobile != detail.childMobile {
                    note.childMobile = detail.childMobile
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildAccountArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildAccountArchiveFileName.filePath(), atomically: true)
    }
    
    func find(idUserChildInfo:String, userId:String) -> ChildAccount? {
        let array = self.findAll(userId)
        for note in array {
            if note.idUserChildInfo == idUserChildInfo {
                return note
            }
        }
        return nil
    }
}

class ChildAccountBL: NSObject {
    class func insert(detail:ChildAccount, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [ChildAccount]{
        ChildAccountDAO.shared.insert(detail, userId: userId)
        return ChildAccountDAO.shared.findAll(userId)
    }
    
    class func delete(idUserChildInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[ChildAccount]{
        ChildAccountDAO.shared.delete(idUserChildInfo, userId: userId)
        return ChildAccountDAO.shared.findAll(userId)
    }
    
    class func modify(detail:ChildAccount, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[ChildAccount]{
        ChildAccountDAO.shared.modify(detail, userId: userId)
        return ChildAccountDAO.shared.findAll(userId)
    }
    
    class func find(idUserChildInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->ChildAccount?{
        return ChildAccountDAO.shared.find(idUserChildInfo, userId: userId)
    }
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[ChildAccount]{
        return ChildAccountDAO.shared.findAll(userId)
    }
}

//MARK:____ChildEquipments____
private let ChildEquipmentsArchiveKey = "ChildEquipmentsArchiveKey"
private let ChildEquipmentsArchiveFileName = "ChildEquipmentsArchive.archive"

class ChildEquipments: NSObject,NSCoding {
    /*
     idEqmInfo	int	是	设备id
     eqmDid	string	是	设备DID
     eqmName	string	是	设备名称
     eqmStatus	int	是	设备状态(1：开 2：关)
     idUserChildEqmInfo	int	是	用户子帐号设备id（0表示未新增，需要更新后才生成）
     eqmAccount	string	是	设备帐号
     eqmPwd	string	是	设备密码

     */
    var idEqmInfo:String!
    var eqmDid:String!
    var eqmName:String!
    var eqmStatus:String!
    var idUserChildEqmInfo:String!
    var eqmAccount:String!
    var eqmPwd:String!
    
    var eqmSubItem = ""
    
    
    override init() {
        self.idEqmInfo = ""
        self.eqmDid = ""
        self.eqmName = ""
        self.eqmStatus = ""
        self.idUserChildEqmInfo = ""
        self.eqmAccount = ""
        self.eqmPwd = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idEqmInfo") as? String {
            self.idEqmInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmDid") as? String {
            self.eqmDid = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmName") as? String {
            self.eqmName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmStatus") as? String {
            self.eqmStatus = obj
        }
        if let obj = aDecoder.decodeObjectForKey("idUserChildEqmInfo") as? String {
            self.idUserChildEqmInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmAccount") as? String {
            self.eqmStatus = obj
        }
        if let obj = aDecoder.decodeObjectForKey("eqmPwd") as? String {
            self.idUserChildEqmInfo = obj
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idEqmInfo, forKey: "idEqmInfo")
        aCoder.encodeObject(self.eqmDid, forKey: "eqmDid")
        aCoder.encodeObject(self.eqmName, forKey: "eqmName")
        aCoder.encodeObject(self.eqmStatus, forKey: "eqmStatus")
        aCoder.encodeObject(self.idUserChildEqmInfo, forKey: "idUserChildEqmInfo")
        aCoder.encodeObject(self.eqmAccount, forKey: "eqmAccount")
        aCoder.encodeObject(self.eqmPwd, forKey: "eqmPwd")
        
    }
    
}

private class ChildEquipmentsDAO: NSObject {
    static var shared:ChildEquipmentsDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:ChildEquipmentsDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = ChildEquipmentsDAO()
        }
        return DAO.dao!
    }
    
    func findAll(idUserChildInfo:String) -> [ChildEquipments] {
        var listData = [ChildEquipments]()
        if let theData = NSData.init(contentsOfFile: ChildEquipmentsArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(ChildEquipmentsArchiveKey) as? [String:NSObject]{
                    if let list = arrDict[idUserChildInfo] as? [ChildEquipments]{
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:ChildEquipments, idUserChildInfo:String) -> Bool {
        var array = self.findAll(idUserChildInfo)
        for base in array {
            if base.idEqmInfo == detail.idEqmInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[idUserChildInfo] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildEquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildEquipmentsArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(idUserChildEqmInfo:String, idUserChildInfo:String) -> Bool {
        var array = self.findAll(idUserChildInfo)
        for note in array {
            if note.idUserChildEqmInfo == idUserChildEqmInfo {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[idUserChildInfo] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildEquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildEquipmentsArchiveFileName.filePath(), atomically: true)
    }
    
    func modify(detail:ChildEquipments, idUserChildInfo:String) -> Bool {
        let array = self.findAll(idUserChildInfo)
        for note in array {
            if note.idEqmInfo == detail.idEqmInfo {
                if note.idUserChildEqmInfo != detail.idUserChildEqmInfo {
                    note.idUserChildEqmInfo = detail.idUserChildEqmInfo
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[idUserChildInfo] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildEquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildEquipmentsArchiveFileName.filePath(), atomically: true)
    }
    
    func find(idUserChildEqmInfo:String, idUserChildInfo:String) -> ChildEquipments? {
        let array = self.findAll(idUserChildInfo)
        for note in array {
            if note.idUserChildEqmInfo == idUserChildEqmInfo {
                return note
            }
        }
        return nil
    }

}

class ChildEquipmentsBL: NSObject {
    class func insert(detail:ChildEquipments, idUserChildInfo:String) -> [ChildEquipments]{
        ChildEquipmentsDAO.shared.insert(detail, idUserChildInfo: idUserChildInfo)
        return ChildEquipmentsDAO.shared.findAll(idUserChildInfo)
    }
    
    class func delete(idUserChildEqmInfo: String, idUserChildInfo: String) ->[ChildEquipments]{
        ChildEquipmentsDAO.shared.delete(idUserChildEqmInfo, idUserChildInfo: idUserChildInfo)
        return ChildEquipmentsDAO.shared.findAll(idUserChildInfo)
    }
    
    class func modify(detail:ChildEquipments, idUserChildInfo: String) ->[ChildEquipments]{
        ChildEquipmentsDAO.shared.modify(detail, idUserChildInfo: idUserChildInfo)
        return ChildEquipmentsDAO.shared.findAll(idUserChildInfo)
    }
    
    class func find(idUserChildEqmInfo: String, idUserChildInfo: String) ->ChildEquipments?{
        return ChildEquipmentsDAO.shared.find(idUserChildEqmInfo, idUserChildInfo: idUserChildInfo)
    }
    
    class func findAll(idUserChildInfo: String) -> [ChildEquipments]{
        return ChildEquipmentsDAO.shared.findAll(idUserChildInfo)
    }
}



private let ChildEquipmentsPermissionKey = "ChildEquipmentsPermissionKey"
private let ChildEquipmentsPermissionName = "ChildEquipmentsPermission.archive"
class ChildEquipmentsPermission: NSObject,NSCoding {
    /*
     idUserChildEqmPermission		int	是	设备子帐号权限id
     idUserEqmInfo		int	是	用户设备id
     voicePermission		int	是	声音权限（1：有 2：无）
     imagePermission		int	是	图像权限（1：有 2：无）
     
     */
    var idUserChildEqmPermission:String!
    var idUserEqmInfo:String!
    var voicePermission:String!
    var imagePermission:String!
    
    
    override init() {
        self.idUserChildEqmPermission = ""
        self.idUserEqmInfo = ""
        self.voicePermission = ""
        self.imagePermission = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        if let obj = aDecoder.decodeObjectForKey("idUserChildEqmPermission") as? String {
            self.idUserChildEqmPermission = obj
        }
        if let obj = aDecoder.decodeObjectForKey("idUserEqmInfo") as? String {
            self.idUserEqmInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("voicePermission") as? String {
            self.voicePermission = obj
        }
        if let obj = aDecoder.decodeObjectForKey("imagePermission") as? String {
            self.imagePermission = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idUserChildEqmPermission, forKey: "idUserChildEqmPermission")
        aCoder.encodeObject(self.idUserEqmInfo, forKey: "idUserEqmInfo")
        aCoder.encodeObject(self.voicePermission, forKey: "voicePermission")
        aCoder.encodeObject(self.imagePermission, forKey: "imagePermission")
    }
    
}

private class ChildEquipmentsPermissionDAO: NSObject {
    static var shared:ChildEquipmentsPermissionDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:ChildEquipmentsPermissionDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = ChildEquipmentsPermissionDAO()
        }
        return DAO.dao!
    }
    
    func findAll(idUserChildEqmInfo:String) -> [ChildEquipmentsPermission] {
        var listData = [ChildEquipmentsPermission]()
        if let theData = NSData.init(contentsOfFile: ChildEquipmentsPermissionName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(ChildEquipmentsPermissionKey) as? [String:NSObject]{
                    if let list = arrDict[idUserChildEqmInfo] as? [ChildEquipmentsPermission] {
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:ChildEquipmentsPermission, idUserChildEqmInfo:String) -> Bool {
        var array = self.findAll(idUserChildEqmInfo)
        for base in array {
            if base.idUserChildEqmPermission == detail.idUserChildEqmPermission {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[idUserChildEqmInfo] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildEquipmentsPermissionKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildEquipmentsPermissionName.filePath(), atomically: true)
        
    }
    
    
    func modify(detail:ChildEquipmentsPermission, idUserChildEqmInfo:String) -> Bool {
        let array = self.findAll(idUserChildEqmInfo)
        for note in array {
            if note.idUserChildEqmPermission == detail.idUserChildEqmPermission {
                if note.voicePermission != detail.voicePermission {
                    note.voicePermission = detail.voicePermission
                }
                if note.imagePermission != detail.imagePermission {
                    note.imagePermission = detail.imagePermission
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[idUserChildEqmInfo] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ChildEquipmentsPermissionKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildEquipmentsPermissionName.filePath(), atomically: true)
    }
    
    func find(idUserChildEqmPermission:String, idUserChildEqmInfo:String) -> ChildEquipmentsPermission? {
        let array = self.findAll(idUserChildEqmInfo)
        for note in array {
            if note.idUserChildEqmPermission == idUserChildEqmPermission {
                return note
            }
        }
        return nil
    }
    
}

class ChildEquipmentsPermissionBL: NSObject {
    class func insert(detail:ChildEquipmentsPermission, idUserChildEqmInfo:String) -> [ChildEquipmentsPermission]{
        ChildEquipmentsPermissionDAO.shared.insert(detail, idUserChildEqmInfo: idUserChildEqmInfo)
        return ChildEquipmentsPermissionDAO.shared.findAll(idUserChildEqmInfo)
    }
    
    class func modify(detail:ChildEquipmentsPermission, idUserChildEqmInfo:String) ->[ChildEquipmentsPermission]{
        ChildEquipmentsPermissionDAO.shared.modify(detail, idUserChildEqmInfo: idUserChildEqmInfo)
        return ChildEquipmentsPermissionDAO.shared.findAll(idUserChildEqmInfo)
    }
    
    class func find(idUserChildEqmPermission:String, idUserChildEqmInfo:String) ->ChildEquipmentsPermission?{
        return ChildEquipmentsPermissionDAO.shared.find(idUserChildEqmPermission, idUserChildEqmInfo: idUserChildEqmInfo)
    }
    
    class func findAll(idUserChildEqmInfo:String) -> [ChildEquipmentsPermission]{
        return ChildEquipmentsPermissionDAO.shared.findAll(idUserChildEqmInfo)
    }

}


//MARK:____Diary____
private let DiaryArchiveKey = "DiaryArchiveKey"
private let DiaryArchiveFileName = "DiaryArchive.archive"

class Diary: NSObject,NSCoding {
    /*
     idUserNoteInfo	int	是	日记id
     noteType	int	是	日记类型（1：备孕 2：怀孕3：育儿）
     moodStatus	int	是	心情（1：非常愉快 2：愉快 3：一般 4：不开心 5：好难过）
     noteLabel	string	是	（多个用、号隔开）
     content	string		内容
     imgUrls	string		图片（多个用分号隔开）
     idUserBabyInfo	int		宝宝id
     breedStatusDate	int		孕育状态天数
     createTime	string	是	创建时间(yyyy-MM-dd HH:mm)

     */
    
    var idUserNoteInfo:String!
    var noteType:String!
    var moodStatus:String!
    var noteLabel:String!
    var noteLabels:[String]!
    var content:String!
    var imgUrls:String!
    var images:[String]!
    var imageArr:[UIImage]!
    var idUserBabyInfo:String!
    var breedStatusDate:String!
    var createTime:String!
    var createDate:String!
    
    
    override init() {
        self.idUserNoteInfo = ""
        self.noteType = ""
        self.moodStatus = ""
        self.noteLabel = ""
        self.noteLabels = []
        self.content = ""
        self.imgUrls = ""
        self.images = []
        self.imageArr = []
        self.idUserBabyInfo = ""
        self.breedStatusDate = ""
        self.createTime = ""
        self.createDate = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idUserNoteInfo") as? String {
            self.idUserNoteInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("noteType") as? String {
            self.noteType = obj
        }
        if let obj = aDecoder.decodeObjectForKey("moodStatus") as? String {
            self.moodStatus = obj
        }
        if let obj = aDecoder.decodeObjectForKey("noteLabel") as? String {
            self.noteLabel = obj
        }
        if let obj = aDecoder.decodeObjectForKey("noteLabels") as? [String] {
            self.noteLabels = obj
        }
        if let obj = aDecoder.decodeObjectForKey("content") as? String {
            self.content = obj
        }
        if let obj = aDecoder.decodeObjectForKey("imgUrls") as? String {
            self.imgUrls = obj
        }
        if let obj = aDecoder.decodeObjectForKey("images") as? [String] {
            self.images = obj
        }
        if let obj = aDecoder.decodeObjectForKey("idUserBabyInfo") as? String {
            self.idUserBabyInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("breedStatusDate") as? String {
            self.breedStatusDate = obj
        }
        if let obj = aDecoder.decodeObjectForKey("createTime") as? String {
            self.createTime = obj
        }
        if let obj = aDecoder.decodeObjectForKey("createDate") as? String {
            self.createDate = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idUserNoteInfo, forKey: "idUserNoteInfo")
        aCoder.encodeObject(self.noteType, forKey: "noteType")
        aCoder.encodeObject(self.moodStatus, forKey: "moodStatus")
        aCoder.encodeObject(self.noteLabel, forKey: "noteLabel")
        aCoder.encodeObject(self.noteLabels, forKey: "noteLabels")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.imgUrls, forKey: "imgUrls")
        aCoder.encodeObject(self.images, forKey: "images")
        aCoder.encodeObject(self.idUserBabyInfo, forKey: "idUserBabyInfo")
        aCoder.encodeObject(self.breedStatusDate, forKey: "breedStatusDate")
        aCoder.encodeObject(self.createTime, forKey: "createTime")
        aCoder.encodeObject(self.createDate, forKey: "createDate")
    }
}

private class DiaryDAO: NSObject {
    static var shared:DiaryDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:DiaryDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = DiaryDAO()
        }
        return DAO.dao!
    }
    
    func findAll(userId:String) -> [Diary] {
        var listData = [Diary]()
        if let theData = NSData.init(contentsOfFile: DiaryArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(DiaryArchiveKey) as? [String:NSObject]{
                    if let list = arrDict[userId] as? [Diary] {
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:Diary, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idUserNoteInfo == detail.idUserNoteInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        let front = detail.createTime.componentsSeparatedByString(" ")
        if let firstDate = front.first {
            detail.createDate = "\(firstDate) " + firstDate.toWeekday("-")
        }else{
            detail.createDate = detail.createTime
        }
        
        let imageArr = detail.imgUrls.componentsSeparatedByString(",")
        for image in imageArr {
            detail.images.append(image)
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: DiaryArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(DiaryArchiveFileName.filePath(), atomically: true)
    }
    
    func delete(idUserNoteInfo:String, userId:String) -> Bool {
        var array = self.findAll(userId)
        for note in array {
            if note.idUserNoteInfo == idUserNoteInfo {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: DiaryArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(DiaryArchiveFileName.filePath(), atomically: true)
    }
    
    
    
    func find(idUserNoteInfo:String, userId:String) -> Diary? {
        let array = self.findAll(userId)
        for note in array {
            if note.idUserNoteInfo == idUserNoteInfo {
                return note
            }
        }
        return nil
    }

}

class DiaryBL: NSObject {
    class func insert(detail:Diary, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [Diary]{
        DiaryDAO.shared.insert(detail, userId: userId)
        return DiaryDAO.shared.findAll(userId)
    }
    
    class func delete(idUserNoteInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[Diary]{
        DiaryDAO.shared.delete(idUserNoteInfo, userId: userId)
        return DiaryDAO.shared.findAll(userId)
    }
    
    class func find(idUserNoteInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Diary?{
        return DiaryDAO.shared.find(idUserNoteInfo, userId: userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [Diary]{
        return DiaryDAO.shared.findAll(userId)
    }
    
}

//MARK:____Article____
private let ArticleArchiveKey = "ArticleArchiveKey"
private let ArticleArchiveFileName = "ArticleArchive.archive"
class Article: NSObject {
    /*
     
     一级参数	二级参数	类型	必填	描述
     idBbsNewsInfo		int		咨讯id
     newsType		int		资讯类型（1：怀孕 2：育儿）
     title		string		标题
     imageUrl		string		图片,多个用英文逗号隔开
     content		string		内容
     createTime		string		创建时间(yyyy-MM-dd HH:mm)

     
     */
    
    var idBbsNewsInfo:String!
    var newsType:String!
    var title:String!
    var titleHeight:CGFloat!
    var imageUrl:String!
    var images:[String]!
    var imageHeight:CGFloat!
    var totalImageHeight:CGFloat!
    var content:String!
    var contentHeight:CGFloat!
    var createTime:String!
    var createDate:String!
    
    
    override init() {
        self.idBbsNewsInfo = ""
        self.newsType = ""
        self.title = ""
        self.imageUrl = ""
        self.content = ""
        self.createTime = ""
        self.createDate = ""
        self.images = []
        self.titleHeight = 0
        self.contentHeight = 0
        self.imageHeight = 0
        self.totalImageHeight = 0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idBbsNewsInfo") as? String {
            self.idBbsNewsInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("newsType") as? String {
            self.newsType = obj
        }
        if let obj = aDecoder.decodeObjectForKey("title") as? String {
            self.title = obj
        }
        if let obj = aDecoder.decodeObjectForKey("imageUrl") as? String {
            self.imageUrl = obj
        }
        if let obj = aDecoder.decodeObjectForKey("images") as? [String] {
            self.images = obj
        }
        if let obj = aDecoder.decodeObjectForKey("content") as? String {
            self.content = obj
        }
        if let obj = aDecoder.decodeObjectForKey("createTime") as? String {
            self.createTime = obj
        }
        if let obj = aDecoder.decodeObjectForKey("createDate") as? String {
            self.createDate = obj
        }
        self.titleHeight = CGFloat.init(aDecoder.decodeFloatForKey("titleHeight"))
        self.contentHeight = CGFloat.init(aDecoder.decodeFloatForKey("contentHeight"))
        self.imageHeight = CGFloat.init(aDecoder.decodeFloatForKey("imageHeight"))
        self.totalImageHeight = CGFloat.init(aDecoder.decodeFloatForKey("totalImageHeight"))
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idBbsNewsInfo, forKey: "idBbsNewsInfo")
        aCoder.encodeObject(self.newsType, forKey: "newsType")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.imageUrl, forKey: "imageUrl")
        aCoder.encodeObject(self.images, forKey: "images")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.createTime, forKey: "createTime")
        aCoder.encodeObject(self.createDate, forKey: "createDate")
        aCoder.encodeFloat(Float.init(self.titleHeight), forKey: "titleHeight")
        aCoder.encodeFloat(Float.init(self.contentHeight), forKey: "contentHeight")
        aCoder.encodeFloat(Float.init(self.imageHeight), forKey: "imageHeight")
        aCoder.encodeFloat(Float.init(self.totalImageHeight), forKey: "totalImageHeight")
    }
}

private class ArticleDAO: NSObject {
    static var shared:ArticleDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:ArticleDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = ArticleDAO()
        }
        return DAO.dao!
    }
    
    
    func findAll(userId:String) -> [Article] {
        var listData = [Article]()
        if let theData = NSData.init(contentsOfFile: ArticleArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(ArticleArchiveKey) as? [String:NSObject]{
                    if let list = arrDict[userId] as? [Article] {
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:Article, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idBbsNewsInfo == detail.idBbsNewsInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        detail.contentHeight = detail.content.size(UIFont.systemFontOfSize(16)).height
        detail.titleHeight = detail.title.size(UIFont.systemFontOfSize(14)).height
        do {
            if let imageData = detail.imageUrl.dataUsingEncoding(NSUTF8StringEncoding) {
                if let dict = try NSJSONSerialization.JSONObjectWithData(imageData, options: NSJSONReadingOptions.MutableContainers) as? [String:String] {
                    for img in dict.values {
                        detail.images.append(img)
                    }
                }
            }
        } catch  {
            
        }
        
        if detail.images.count > 0 {
            detail.imageHeight = ScreenWidth
            detail.totalImageHeight = CGFloat.init(detail.images.count) * ScreenWidth
        }
        
        let date = detail.createTime.componentsSeparatedByString(" ")
        if let dateStr = date.first {
            detail.createDate = dateStr
        }
        
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ArticleArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ArticleArchiveFileName.filePath(), atomically: true)
        
    }
    
    
    func find(idBbsNewsInfo:String, userId:String) -> Article? {
        let array = self.findAll(userId)
        for note in array {
            if note.idBbsNewsInfo == idBbsNewsInfo {
                return note
            }
        }
        return nil
    }

}

class ArticleBL: NSObject {
    class func insert(detail:Article, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [Article]{
        ArticleDAO.shared.insert(detail, userId: userId)
        return ArticleDAO.shared.findAll(userId)
    }
    
    class func find(idBbsNewsInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Article?{
        return ArticleDAO.shared.find(idBbsNewsInfo, userId: userId)
    }

}

//MARK:____ArticleTypeList_____
private let ArticleTypeListKey = "ArticleTypeListKey"
private let ArticleTypeListKeyName = "ArticleTypeListKeyName.archive"
class ArticleTypeList: NSObject,NSCoding {
    /*
     typeName	String		分类名称
     year	int		年
     month	int		月
     */
    var typeName:String!
    var year:String!
    var month:String!
    var articleList:[ArticleList]!
    
    
    override init() {
        self.typeName = ""
        self.year = ""
        self.month = ""
        self.articleList = []
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("typeName") as? String {
            self.typeName = obj
        }
        if let obj = aDecoder.decodeObjectForKey("year") as? String {
            self.year = obj
        }
        if let obj = aDecoder.decodeObjectForKey("month") as? String {
            self.month = obj
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.typeName, forKey: "typeName")
        aCoder.encodeObject(self.year, forKey: "year")
        aCoder.encodeObject(self.month, forKey: "month")
    }
}


private class ArticleTypeListDAO: NSObject {
    static var shared:ArticleTypeListDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:ArticleTypeListDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = ArticleTypeListDAO()
        }
        return DAO.dao!
    }
    
    
    func findAll(userId:String) -> [ArticleTypeList] {
        var listData = [ArticleTypeList]()
        if let theData = NSData.init(contentsOfFile: ArticleTypeListKeyName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(ArticleTypeListKey) as? [String:NSObject]{
                    if let list = arrDict[userId] as? [ArticleTypeList] {
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:ArticleTypeList, userId:String) -> Bool {
        var array = self.findAll(userId)
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ArticleTypeListKey)
        archiver.finishEncoding()
        return theData.writeToFile(ArticleTypeListKeyName.filePath(), atomically: true)
        
    }
}


class ArticleTypeListBL: NSObject {
    class func insert(detail:ArticleTypeList, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [ArticleTypeList]{
        ArticleTypeListDAO.shared.insert(detail, userId: userId)
        return ArticleTypeListDAO.shared.findAll(userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[ArticleTypeList]{
        return ArticleTypeListDAO.shared.findAll(userId)
    }
}


//MARK:____ArticleList____
private let ArticleListArchiveKey = "ArticleListArchiveKey"
private let ArticleListArchiveFileName = "ArticleListArchive.archive"
class ArticleList: NSObject {
    /*
     
     idBbsNewsInfo	int		咨讯id
     newsType	int		资讯类型（1：怀孕 2：育儿）
     babyAgeYear	int		年
     babyAgeMon	int		月
     title	string		标题
     content	string		内容
     imgList	string		图片
     imgReplaceormat	string		内容图片占位格式 【图片X】 X=第几张，替换X,然后替换content里的位置作为图片显示
     videoUrl	string		视频地址
     browseCount	int		浏览量
     createTime	string		创建时间（yyyy-MM-dd HH:mm:ss）
     
     operateType		int	是	操作类型  1：收藏  2：取消收藏
     
     */
    
    var idBbsNewsInfo:String!
    var newsType:String!
    var babyAgeYear:String!
    var babyAgeMon:String!
    var title:String!
    var content:String!
    var imgList:String!
    var imgReplaceormat:String!
    var videoUrl:String!
    var browseCount:String!
    var createTime:String!
    
    var operateType:String!
    
    
    override init() {
        self.idBbsNewsInfo = ""
        self.newsType = ""
        self.babyAgeYear = ""
        self.babyAgeMon = ""
        self.title = ""
        self.content = ""
        self.imgList = ""
        self.imgReplaceormat = ""
        self.videoUrl = ""
        self.browseCount = ""
        self.createTime = ""
        
        self.operateType = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idBbsNewsInfo") as? String {
            self.idBbsNewsInfo = obj
        }
        if let obj = aDecoder.decodeObjectForKey("newsType") as? String {
            self.newsType = obj
        }
        if let obj = aDecoder.decodeObjectForKey("babyAgeYear") as? String {
            self.babyAgeYear = obj
        }
        if let obj = aDecoder.decodeObjectForKey("babyAgeMon") as? String {
            self.babyAgeMon = obj
        }
        if let obj = aDecoder.decodeObjectForKey("title") as? String {
            self.title = obj
        }
        if let obj = aDecoder.decodeObjectForKey("content") as? String {
            self.content = obj
        }
        if let obj = aDecoder.decodeObjectForKey("imgList") as? String {
            self.imgList = obj
        }
        if let obj = aDecoder.decodeObjectForKey("imgReplaceormat") as? String {
            self.imgReplaceormat = obj
        }
        if let obj = aDecoder.decodeObjectForKey("videoUrl") as? String {
            self.videoUrl = obj
        }
        if let obj = aDecoder.decodeObjectForKey("browseCount") as? String {
            self.browseCount = obj
        }
        if let obj = aDecoder.decodeObjectForKey("createTime") as? String {
            self.createTime = obj
        }
        if let obj = aDecoder.decodeObjectForKey("operateType") as? String {
            self.operateType = obj
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idBbsNewsInfo, forKey: "idBbsNewsInfo")
        aCoder.encodeObject(self.newsType, forKey: "newsType")
        aCoder.encodeObject(self.babyAgeYear, forKey: "babyAgeYear")
        aCoder.encodeObject(self.babyAgeMon, forKey: "babyAgeMon")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.imgReplaceormat, forKey: "imgReplaceormat")
        aCoder.encodeObject(self.videoUrl, forKey: "videoUrl")
        aCoder.encodeObject(self.browseCount, forKey: "browseCount")
        aCoder.encodeObject(self.imgList, forKey: "imgList")
        aCoder.encodeObject(self.createTime, forKey: "createTime")
        aCoder.encodeObject(self.operateType, forKey: "operateType")
    }
}

private class ArticleListDAO: NSObject {
    static var shared:ArticleListDAO{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:ArticleListDAO? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = ArticleListDAO()
        }
        return DAO.dao!
    }
    
    
    func findAll(userId:String) -> [ArticleList] {
        var listData = [ArticleList]()
        if let theData = NSData.init(contentsOfFile: ArticleListArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arrDict = unArchive.decodeObjectForKey(ArticleListArchiveKey) as? [String:NSObject]{
                    if let list = arrDict[userId] as? [ArticleList] {
                        listData.appendContentsOf(list)
                    }
                }
            }
        }
        return listData
    }
    
    func insert(detail:ArticleList, userId:String) -> Bool {
        var array = self.findAll(userId)
        for base in array {
            if base.idBbsNewsInfo == detail.idBbsNewsInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ArticleListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ArticleListArchiveFileName.filePath(), atomically: true)
        
    }
    
    
    func find(idBbsNewsInfo:String, userId:String) -> ArticleList? {
        let array = self.findAll(userId)
        for note in array {
            if note.idBbsNewsInfo == idBbsNewsInfo {
                return note
            }
        }
        return nil
    }
    
    func modify(detail:ArticleList, userId:String) -> Bool {
        let array = self.findAll(userId)
        for base in array {
            if base.idBbsNewsInfo == detail.idBbsNewsInfo {
                if base.operateType != detail.operateType {
                    base.operateType = detail.operateType
                }
            }
        }
        var arrDict:[String:NSObject] = [:]
        arrDict[userId] = array
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(arrDict, forKey: ArticleListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ArticleListArchiveFileName.filePath(), atomically: true)
    }
    
}

class ArticleListBL: NSObject {
    class func insert(detail:ArticleList, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) -> [ArticleList]{
        ArticleListDAO.shared.insert(detail, userId: userId)
        return ArticleListDAO.shared.findAll(userId)
    }
    
    class func find(idBbsNewsInfo:String, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->ArticleList?{
        return ArticleListDAO.shared.find(idBbsNewsInfo, userId: userId)
    }
    
    class func modify(detail:ArticleList, userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->Bool{
        return ArticleListDAO.shared.modify(detail, userId: userId)
    }
    
    class func findAll(userId:String = BabyZoneConfig.shared.currentUserId.defaultString()) ->[ArticleList]{
        return ArticleListDAO.shared.findAll(userId)
    }
}


class AppBrowseCount: NSObject {
    
    
    
    /*
     modelType		int	是	模块类型 （1：我的宝宝（监控） 2：异常提醒开关  3：本周宝宝状态4：育婴记录 ）
     count		int	是	浏览次数

     */
    private var monitor = 0
    private var remind = 0
    private var babyStatus = 0
    private var babyRecord = 0
    
    private var maxCount = 3
    
    private var monitorCount:Int64 = 0
    private var remindCount:Int64 = 0
    private var babyStatusCount:Int64 = 0
    private var babyRecordCount:Int64 = 0
    
    static var shared:AppBrowseCount{
        struct DAO{
            static var pred:dispatch_once_t = 0
            static var dao:AppBrowseCount? = nil
        }
        
        dispatch_once(&DAO.pred) {
            DAO.dao = AppBrowseCount()
        }
        return DAO.dao!
    }
    
    func modelTypeMonitor() -> Void {
        "modelTypeMonitor".setDefaultString("\(self.monitorCount += 1)")
        self.monitor += 1
        if self.monitor == 5 {
            self.sendAsyncupdateBbsCollection("1", count: "modelTypeMonitor".defaultString(), completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            weakSelf.monitor = 0
                        }
                    }
                }
            })
        }
    }
    
    func modelTypeRemind() -> Void {
        "modelTypeRemind".setDefaultString("\(self.remindCount += 1)")
        self.remind += 1
        if self.remind == 5 {
            self.sendAsyncupdateBbsCollection("2", count: "modelTypeRemind".defaultString(), completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            weakSelf.remind = 0
                        }
                    }
                }
                })
        }
    }
    
    func modelTypeBabyStatus() -> Void {
        "modelTypeBabyStatus".setDefaultString("\(self.babyStatusCount += 1)")
        self.babyStatus += 1
        if self.babyStatus == 5 {
            self.sendAsyncupdateBbsCollection("3", count: "modelTypeBabyStatus".defaultString(), completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            weakSelf.babyStatus = 0
                        }
                    }
                }
                })
        }
    }
    
    func modelTypeBabyRecord() -> Void {
        "modelTypeBabyRecord".setDefaultString("\(self.babyRecordCount += 1)")
        self.babyRecord += 1
        if self.babyRecord == 5 {
            self.sendAsyncupdateBbsCollection("4", count: "modelTypeBabyRecord".defaultString(), completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            weakSelf.babyRecord = 0
                        }
                    }
                }
                })
        }
    }
    
}


class CityCode: NSObject {
    var codeId = ""
    var codeAreaCode = ""
    var codeAreaName = ""
    var codeParentCode = ""
    var codeLevel = ""
    var codeAreaTelCode = ""
    var codeCenter = ""
}





