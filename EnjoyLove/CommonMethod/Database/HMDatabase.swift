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
    var userId:String!
    var sessionId:String!
    var userName:String!
    var userPhone:String!
    var contactId:String!
    var password:String!
    var md5Password:String!
    var isRegist:NSNumber!
    var nickName:String!
    var userSign:String!
    
    
    
    override init() {
        self.userId = ""
        self.sessionId = ""
        self.userName = ""
        self.userPhone = ""
        self.contactId = ""
        self.password = ""
        self.md5Password = ""
        self.nickName = ""
        self.userSign = ""
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
        if let obj = aDecoder.decodeObjectForKey("password") as? String {
            self.password = obj
        }
        if let obj = aDecoder.decodeObjectForKey("md5Password") as? String {
            self.md5Password = obj
        }
        if let obj = aDecoder.decodeObjectForKey("isRegist") as? NSNumber {
            self.isRegist = obj
        }
        if let obj = aDecoder.decodeObjectForKey("nickName") as? NSNumber {
            self.isRegist = obj
        }
        if let obj = aDecoder.decodeObjectForKey("userSign") as? NSNumber {
            self.isRegist = obj
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.userId, forKey: "userId")
        aCoder.encodeObject(self.userName, forKey: "userName")
        aCoder.encodeObject(self.sessionId, forKey: "sessionId")
        aCoder.encodeObject(self.userPhone, forKey: "userPhone")
        aCoder.encodeObject(self.password, forKey: "password")
        aCoder.encodeObject(self.md5Password, forKey: "md5Password")
        aCoder.encodeObject(self.isRegist, forKey: "isRegist")
        aCoder.encodeObject(self.isRegist, forKey: "nickName")
        aCoder.encodeObject(self.isRegist, forKey: "userSign")
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
                    listData = arr
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
    
    func delete(detail:Login?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var userId = ""
            if let person = detail {
                userId = person.userId
            }
            let baseKey = key == "" ? userId : key
            if note.userId == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: LoginArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(LoginArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:Login, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.userId : key
        for note in array {
            if note.userId == baseKey {
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
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: LoginArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(LoginArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func clear(detail:Login?, key:String = "") ->Bool{
        let array = self.findAll()
        for note in array {
            let phoneKey = detail == nil ? "" : note.userPhone
            let baseKey = key == "" ? phoneKey : key
            if note.userPhone == baseKey {
                note.userName = ""
                note.sessionId = ""
                note.contactId = ""
                note.password = ""
                note.md5Password = ""
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
    
    func find(detail:Login?, key:String = "") -> Login? {
        let array = self.findAll()
        var result:Login?
        for note in array {
            let phoneKey = detail == nil ? "" : note.userPhone
            let baseKey = key == "" ? phoneKey : key
            if note.userPhone == baseKey {
                result = note
            }
        }
        return result
    }
    
}

class LoginBL: NSObject {
    class func insert(detail:Login) -> [Login]{
        let result = LoginDAO.shared.insert(detail)
        print("person detail result \(result)")
        return LoginDAO.shared.findAll()
    }
    
    class func delete(detail:Login, key:String = "") ->[Login]{
        LoginDAO.shared.delete(detail, key: key)
        return LoginDAO.shared.findAll()
    }
    
    class func modify(detail:Login, key:String = "") ->[Login]{
        LoginDAO.shared.modify(detail, key: key)
        return LoginDAO.shared.findAll()
    }
    
    class func clear(detail:Login?, key:String = "") ->Bool{
        return LoginDAO.shared.clear(detail, key: key)
    }
    
    class func find(detail:Login?, key:String = "") ->Login?{
        return LoginDAO.shared.find(detail, key: key)
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
        aCoder.encodeObject(self.headImg, forKey: "localHeadImg")
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
    
    func findAll() -> [PersonDetail] {
        var listData = [PersonDetail]()
        if let theData = NSData.init(contentsOfFile: PersonDetailArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(PersonDetailArchiveKey) as? [PersonDetail]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:PersonDetail) -> Bool {
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
        archiver.encodeObject(array, forKey: PersonDetailArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(PersonDetailArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:PersonDetail?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var userId = ""
            if let person = detail {
                userId = person.userId
            }
            let baseKey = key == "" ? userId : key
            if note.userId == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: PersonDetailArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(PersonDetailArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:PersonDetail, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.userId : key
        for note in array {
            
            if note.userId == baseKey {
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
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: PersonDetailArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(PersonDetailArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:PersonDetail?, key:String = "") -> PersonDetail? {
        let array = self.findAll()
        var result:PersonDetail?
        for note in array {
            let userId = detail == nil ? "" : note.userId
            let baseKey = key == "" ? userId : key
            if note.userId == baseKey {
                result = note
            }
        }
        return result
    }
}

class PersonDetailBL: NSObject {
    class func insert(detail:PersonDetail) -> [PersonDetail]{
        let result = PersonDetailDAO.shared.insert(detail)
        print("person detail result \(result)")
        return PersonDetailDAO.shared.findAll()
    }
    
    class func delete(detail:PersonDetail, key:String = "") ->[PersonDetail]{
        PersonDetailDAO.shared.delete(detail, key: key)
        return PersonDetailDAO.shared.findAll()
    }
    
    class func modify(detail:PersonDetail, key:String = "") ->PersonDetail?{
        PersonDetailDAO.shared.modify(detail, key: key)
        return PersonDetailDAO.shared.find(detail)
    }
    
    class func find(detail:PersonDetail?, key:String = "") ->PersonDetail?{
        return PersonDetailDAO.shared.find(detail, key: key)
    }
    
    class func findAll() ->[PersonDetail]{
        return PersonDetailDAO.shared.findAll()
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
    
    func findAll() -> [BabyList] {
        var listData = [BabyList]()
        if let theData = NSData.init(contentsOfFile: BabyListArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(BabyListArchiveKey) as? [BabyList]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:BabyList) -> Bool {
        var array = self.findAll()
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
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: BabyListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:BabyList?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var babyId = ""
            if let list = detail {
                babyId = list.idUserBabyInfo
            }
            let baseKey = key == "" ? babyId : key
            if note.idUserBabyInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: BabyListArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func deleteAll() -> Bool {
        var array = self.findAll()
        array.removeAll()
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: BabyListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
    }
    
    func modify(detail:BabyList, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idUserBabyInfo : key
        for note in array {
            
            if note.idUserBabyInfo == baseKey {
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
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: BabyListArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(BabyListArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:BabyList?, key:String = "") -> BabyList? {
        let array = self.findAll()
        var result:BabyList?
        for note in array {
            let userId = detail == nil ? "" : note.idUserBabyInfo
            let baseKey = key == "" ? userId : key
            if note.idUserBabyInfo == baseKey {
                result = note
            }
        }
        return result
    }
}

class BabyListBL: NSObject {
    
    class func insert(detail:BabyList) -> [BabyList]{
        let result = BabyListDAO.shared.insert(detail)
        print("baby list result \(result)")
        return BabyListDAO.shared.findAll()
    }
    
    class func delete(detail:BabyList, key:String = "") ->[BabyList]{
        BabyListDAO.shared.delete(detail, key: key)
        return BabyListDAO.shared.findAll()
    }
    
    class func modify(detail:BabyList, key:String = "") ->[BabyList]{
        BabyListDAO.shared.modify(detail, key: key)
        return BabyListDAO.shared.findAll()
    }
    
    class func find(detail:BabyList?, key:String = "") ->BabyList?{
        return BabyListDAO.shared.find(detail, key: key)
    }
    
    class func findAll() ->[BabyList]{
        return BabyListDAO.shared.findAll()
    }
}

private let BabyBaseInfoArchiveKey = "BabyBaseInfoArchiveKey"
private let BabyBaseInfoArchiveName = "BabyBaseInfoArchiveName.archive"
class BabyBaseInfo: NSObject,NSCoding {
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

    var idComBabyBaseInfo:String!
    var infoType:String!
    var day:String!
    var minWeight:String!
    var maxWeight:String!
    var minHeight:String!
    var maxHeight:String!
    var minHead:String!
    var maxHead:String!
    
    override init() {
        self.idComBabyBaseInfo = ""
        self.infoType = ""
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
    
    
    func findAll() -> [BabyBaseInfo] {
        var listData = [BabyBaseInfo]()
        if let theData = NSData.init(contentsOfFile: BabyBaseInfoArchiveName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(BabyBaseInfoArchiveKey) as? [BabyBaseInfo]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:BabyBaseInfo) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idComBabyBaseInfo == detail.idComBabyBaseInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: BabyBaseInfoArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(BabyBaseInfoArchiveName.filePath(), atomically: true)
        
    }
    
    func delete(detail:BabyBaseInfo?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var babyId = ""
            if let list = detail {
                babyId = list.idComBabyBaseInfo
            }
            let baseKey = key == "" ? babyId : key
            if note.idComBabyBaseInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: BabyBaseInfoArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(BabyBaseInfoArchiveName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:BabyBaseInfo, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idComBabyBaseInfo : key
        for note in array {
            
            if note.idComBabyBaseInfo == baseKey {
                if note.infoType != detail.infoType {
                    note.infoType = detail.infoType
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
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: BabyBaseInfoArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(BabyBaseInfoArchiveName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:BabyBaseInfo?, key:String = "") -> BabyBaseInfo? {
        let array = self.findAll()
        var result:BabyBaseInfo?
        for note in array {
            let userId = detail == nil ? "" : note.idComBabyBaseInfo
            let baseKey = key == "" ? userId : key
            if note.idComBabyBaseInfo == baseKey {
                result = note
            }
        }
        return result
    }

}

class BabyBaseInfoBL: NSObject {
    class func insert(detail:BabyBaseInfo) -> [BabyBaseInfo]{
        let result = BabyBaseInfoDAO.shared.insert(detail)
        print("baby list result \(result)")
        return BabyBaseInfoDAO.shared.findAll()
    }
    
    class func delete(detail:BabyBaseInfo, key:String = "") ->[BabyBaseInfo]{
        BabyBaseInfoDAO.shared.delete(detail, key: key)
        return BabyBaseInfoDAO.shared.findAll()
    }
    
    class func modify(detail:BabyBaseInfo, key:String = "") ->[BabyBaseInfo]{
        BabyBaseInfoDAO.shared.modify(detail, key: key)
        return BabyBaseInfoDAO.shared.findAll()
    }
    
    class func find(detail:BabyBaseInfo?, key:String = "") ->BabyBaseInfo?{
        return BabyBaseInfoDAO.shared.find(detail, key: key)
    }
    
}

//MARK:____Equipments____
private let EquipmentsArchiveKey = "EquipmentsArchive"
private let EquipmentsArchiveFileName = "EquipmentsArchive.archive"
class Equipments: NSObject,NSCoding {
    var idEqmInfo:String!
    var eqmName:String!
    var eqmType:String!
    var eqmDid:String!
    var eqmAccount:String!
    var eqmPwd:String!
    
    override init() {
        self.idEqmInfo = ""
        self.eqmName = ""
        self.eqmType = ""
        self.eqmDid = ""
        self.eqmAccount = ""
        self.eqmPwd = ""
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
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idEqmInfo, forKey: "idEqmInfo")
        aCoder.encodeObject(self.eqmName, forKey: "eqmName")
        aCoder.encodeObject(self.eqmType, forKey: "eqmType")
        aCoder.encodeObject(self.eqmDid, forKey: "eqmDid")
        aCoder.encodeObject(self.eqmAccount, forKey: "eqmAccount")
        aCoder.encodeObject(self.eqmPwd, forKey: "eqmPwd")
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
    
    func findAll() -> [Equipments] {
        var listData = [Equipments]()
        if let theData = NSData.init(contentsOfFile: EquipmentsArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(EquipmentsArchiveKey) as? [Equipments]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:Equipments) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idEqmInfo == detail.idEqmInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: EquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:Equipments?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var idEqmInfo = ""
            if let eqm = detail {
                idEqmInfo = eqm.idEqmInfo
            }
            
            let baseKey = key == "" ? idEqmInfo : key
            if note.idEqmInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: EquipmentsArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:Equipments, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idEqmInfo : key
        for note in array {
            if note.idEqmInfo == baseKey {
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
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: EquipmentsArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(EquipmentsArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:Equipments?, key:String = "") -> Equipments {
        let array = self.findAll()
        var result = Equipments()
        for note in array {
            let userId = detail == nil ? "" : note.idEqmInfo
            let baseKey = key == "" ? userId : key
            if note.idEqmInfo == baseKey {
                result = note
            }
        }
        return result
    }
}

class EquipmentsBL: NSObject {
    class func insert(detail:Equipments) -> [Equipments]{
        let result = EquipmentsDAO.shared.insert(detail)
        print("baby list result \(result)")
        return EquipmentsDAO.shared.findAll()
    }
    
    class func delete(detail:Equipments?, key:String = "") ->[Equipments]{
        EquipmentsDAO.shared.delete(detail, key: key)
        return EquipmentsDAO.shared.findAll()
    }
    
    class func modify(detail:Equipments, key:String = "") ->[Equipments]{
        EquipmentsDAO.shared.modify(detail, key: key)
        return EquipmentsDAO.shared.findAll()
    }
    
    class func find(detail:Equipments?, key:String = "") ->Equipments{
        return EquipmentsDAO.shared.find(detail, key: key)
    }
}

//MARK:____ChildAccount____
private let ChildAccountArchiveKey = "ChildAccountArchiveKey"
private let ChildAccountArchiveFileName = "ChildAccountArchive.archive"
class ChildAccount: NSObject {
    var idUserChildInfo:String!
    var idChild:String!
    var childName:String!
    
    override init() {
        self.idUserChildInfo = ""
        self.idChild = ""
        self.childName = ""
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
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idUserChildInfo, forKey: "idUserChildInfo")
        aCoder.encodeObject(self.idChild, forKey: "idChild")
        aCoder.encodeObject(self.childName, forKey: "childName")
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
    
    func findAll() -> [ChildAccount] {
        var listData = [ChildAccount]()
        if let theData = NSData.init(contentsOfFile: ChildAccountArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(ChildAccountArchiveKey) as? [ChildAccount]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:ChildAccount) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idUserChildInfo == detail.idUserChildInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: ChildAccountArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildAccountArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:ChildAccount?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var idEqmInfo = ""
            if let eqm = detail {
                idEqmInfo = eqm.idUserChildInfo
            }
            
            let baseKey = key == "" ? idEqmInfo : key
            if note.idUserChildInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ChildAccountArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ChildAccountArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:ChildAccount, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idUserChildInfo : key
        for note in array {
            
            if note.idUserChildInfo == baseKey {
                if note.childName != detail.childName {
                    note.childName = detail.childName
                }
                if note.idChild != detail.idChild {
                    note.idChild = detail.idChild
                }
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ChildAccountArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ChildAccountArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:ChildAccount?, key:String = "") -> ChildAccount {
        let array = self.findAll()
        var result = ChildAccount()
        for note in array {
            let userId = detail == nil ? "" : note.idUserChildInfo
            let baseKey = key == "" ? userId : key
            if note.idUserChildInfo == baseKey {
                result = note
            }
        }
        return result
    }
}

class ChildAccountBL: NSObject {
    class func insert(detail:ChildAccount) -> [ChildAccount]{
        let result = ChildAccountDAO.shared.insert(detail)
        print("baby list result \(result)")
        return ChildAccountDAO.shared.findAll()
    }
    
    class func delete(detail:ChildAccount?, key:String = "") ->[ChildAccount]{
        ChildAccountDAO.shared.delete(detail, key: key)
        return ChildAccountDAO.shared.findAll()
    }
    
    class func modify(detail:ChildAccount, key:String = "") ->[ChildAccount]{
        ChildAccountDAO.shared.modify(detail, key: key)
        return ChildAccountDAO.shared.findAll()
    }
    
    class func find(detail:ChildAccount?, key:String = "") ->ChildAccount{
        return ChildAccountDAO.shared.find(detail, key: key)
    }
}

//MARK:____ChildEquipments____
private let ChildEquipmentsArchiveKey = "ChildEquipmentsArchiveKey"
private let ChildEquipmentsArchiveFileName = "ChildEquipmentsArchive.archive"

class ChildEquipments: NSObject,NSCoding {
    /*
     idEqmInfo	int	是	设备id
     eqmName	string	是	设备名称
     eqmStatus	string	是	设备状态(1：开 2：关)
     idUserChildEqmInfo	int	是	用户子帐号设备id（0表示未新增，需要更新后才生成）

     */
    var idEqmInfo = ""
    var eqmName = ""
    var eqmStatus = ""
    var idUserChildEqmInfo = ""
    var idUserChildEqmPermission = ""
    var idUserEqmInfo = ""
    var voicePermission = ""
    var imagePermission = ""
    
    
    
    override init() {
        self.idEqmInfo = ""
        self.eqmName = ""
        self.eqmStatus = ""
        self.idUserChildEqmInfo = ""
        self.idUserChildEqmPermission = ""
        self.idUserEqmInfo = ""
        self.voicePermission = ""
        self.imagePermission = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        if let obj = aDecoder.decodeObjectForKey("idEqmInfo") as? String {
            self.idEqmInfo = obj
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
        aCoder.encodeObject(self.idEqmInfo, forKey: "idEqmInfo")
        aCoder.encodeObject(self.eqmName, forKey: "eqmName")
        aCoder.encodeObject(self.eqmStatus, forKey: "eqmStatus")
        aCoder.encodeObject(self.idUserChildEqmInfo, forKey: "idUserChildEqmInfo")
        aCoder.encodeObject(self.idUserChildEqmPermission, forKey: "idUserChildEqmPermission")
        aCoder.encodeObject(self.idUserEqmInfo, forKey: "idUserEqmInfo")
        aCoder.encodeObject(self.voicePermission, forKey: "voicePermission")
        aCoder.encodeObject(self.imagePermission, forKey: "imagePermission")
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
    
    func findAll() -> [ChildEquipments] {
        var listData = [ChildEquipments]()
        if let theData = NSData.init(contentsOfFile: ChildEquipmentsArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(ChildEquipmentsArchiveKey) as? [ChildEquipments]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:ChildEquipments) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idUserChildEqmInfo == detail.idUserChildEqmInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: ChildEquipmentsArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ChildEquipmentsArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:ChildEquipments?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var idEqmInfo = ""
            if let eqm = detail {
                idEqmInfo = eqm.idUserChildEqmInfo
            }
            
            let baseKey = key == "" ? idEqmInfo : key
            if note.idUserChildEqmInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ChildEquipmentsArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ChildEquipmentsArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:ChildEquipments, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idUserChildEqmInfo : key
        for note in array {
            
            if note.idUserChildEqmInfo == baseKey {
                if note.idEqmInfo != detail.idEqmInfo {
                    note.idEqmInfo = detail.idEqmInfo
                }
                if note.eqmName != detail.eqmName {
                    note.eqmName = detail.eqmName
                }
                
                if note.eqmStatus != detail.eqmStatus {
                    note.eqmStatus = detail.eqmStatus
                }
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ChildEquipmentsArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ChildEquipmentsArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:ChildEquipments?, key:String = "") -> ChildEquipments {
        let array = self.findAll()
        var result = ChildEquipments()
        for note in array {
            let userId = detail == nil ? "" : note.idUserChildEqmInfo
            let baseKey = key == "" ? userId : key
            if note.idUserChildEqmInfo == baseKey {
                result = note
            }
        }
        return result
    }

}

class ChildEquipmentsBL: NSObject {
    class func insert(detail:ChildEquipments) -> [ChildEquipments]{
        let result = ChildEquipmentsDAO.shared.insert(detail)
        print("baby list result \(result)")
        return ChildEquipmentsDAO.shared.findAll()
    }
    
    class func delete(detail:ChildEquipments?, key:String = "") ->[ChildEquipments]{
        ChildEquipmentsDAO.shared.delete(detail, key: key)
        return ChildEquipmentsDAO.shared.findAll()
    }
    
    class func modify(detail:ChildEquipments, key:String = "") ->[ChildEquipments]{
        ChildEquipmentsDAO.shared.modify(detail, key: key)
        return ChildEquipmentsDAO.shared.findAll()
    }
    
    class func find(detail:ChildEquipments?, key:String = "") ->ChildEquipments{
        return ChildEquipmentsDAO.shared.find(detail, key: key)
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
    var content:String!
    var imgUrls:String!
    var idUserBabyInfo:String!
    var breedStatusDate:String!
    var createTime:String!
    
    override init() {
        self.idUserNoteInfo = ""
        self.noteType = ""
        self.moodStatus = ""
        self.noteLabel = ""
        self.content = ""
        self.imgUrls = ""
        self.idUserBabyInfo = ""
        self.breedStatusDate = ""
        self.createTime = ""
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
        if let obj = aDecoder.decodeObjectForKey("content") as? String {
            self.content = obj
        }
        if let obj = aDecoder.decodeObjectForKey("imgUrls") as? String {
            self.imgUrls = obj
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
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idUserNoteInfo, forKey: "idUserNoteInfo")
        aCoder.encodeObject(self.noteType, forKey: "noteType")
        aCoder.encodeObject(self.moodStatus, forKey: "moodStatus")
        aCoder.encodeObject(self.noteLabel, forKey: "noteLabel")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.imgUrls, forKey: "imgUrls")
        aCoder.encodeObject(self.idUserBabyInfo, forKey: "idUserBabyInfo")
        aCoder.encodeObject(self.breedStatusDate, forKey: "breedStatusDate")
        aCoder.encodeObject(self.createTime, forKey: "createTime")
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
    
    func findAll() -> [Diary] {
        var listData = [Diary]()
        if let theData = NSData.init(contentsOfFile: DiaryArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(DiaryArchiveKey) as? [Diary]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:Diary) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idUserNoteInfo == detail.idUserNoteInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: DiaryArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(DiaryArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:Diary?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var idEqmInfo = ""
            if let eqm = detail {
                idEqmInfo = eqm.idUserNoteInfo
            }
            
            let baseKey = key == "" ? idEqmInfo : key
            if note.idUserNoteInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: DiaryArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(DiaryArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:Diary, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idUserNoteInfo : key
        for note in array {
            
            if note.idUserNoteInfo == baseKey {
                if note.noteType != detail.noteType {
                    note.noteType = detail.noteType
                }
                if note.moodStatus != detail.moodStatus {
                    note.moodStatus = detail.moodStatus
                }
                
                if note.noteLabel != detail.noteLabel {
                    note.noteLabel = detail.noteLabel
                }
                
                if note.content != detail.content {
                    note.content = detail.content
                }
                if note.imgUrls != detail.imgUrls {
                    note.imgUrls = detail.imgUrls
                }
                if note.idUserBabyInfo != detail.idUserBabyInfo {
                    note.idUserBabyInfo = detail.idUserBabyInfo
                }
                if note.breedStatusDate != detail.breedStatusDate {
                    note.breedStatusDate = detail.breedStatusDate
                }
                if note.createTime != detail.createTime {
                    note.createTime = detail.createTime
                }
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: DiaryArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(DiaryArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:Diary?, key:String = "") -> Diary {
        let array = self.findAll()
        var result = Diary()
        for note in array {
            let userId = detail == nil ? "" : note.idUserNoteInfo
            let baseKey = key == "" ? userId : key
            if note.idUserNoteInfo == baseKey {
                result = note
            }
        }
        return result
    }

}

class DiaryBL: NSObject {
    class func insert(detail:Diary) -> [Diary]{
        let result = DiaryDAO.shared.insert(detail)
        print("baby list result \(result)")
        return DiaryDAO.shared.findAll()
    }
    
    class func delete(detail:Diary?, key:String = "") ->[Diary]{
        DiaryDAO.shared.delete(detail, key: key)
        return DiaryDAO.shared.findAll()
    }
    
    class func modify(detail:Diary, key:String = "") ->[Diary]{
        DiaryDAO.shared.modify(detail, key: key)
        return DiaryDAO.shared.findAll()
    }
    
    class func find(detail:Diary?, key:String = "") ->Diary{
        return DiaryDAO.shared.find(detail, key: key)
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
    var imageUrl:String!
    var content:String!
    var createTime:String!
    
    override init() {
        self.idBbsNewsInfo = ""
        self.newsType = ""
        self.title = ""
        self.imageUrl = ""
        self.content = ""
        self.createTime = ""
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
        if let obj = aDecoder.decodeObjectForKey("content") as? String {
            self.content = obj
        }
        if let obj = aDecoder.decodeObjectForKey("createTime") as? String {
            self.createTime = obj
        }
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.idBbsNewsInfo, forKey: "idBbsNewsInfo")
        aCoder.encodeObject(self.newsType, forKey: "newsType")
        aCoder.encodeObject(self.title, forKey: "title")
        aCoder.encodeObject(self.imageUrl, forKey: "imageUrl")
        aCoder.encodeObject(self.content, forKey: "content")
        aCoder.encodeObject(self.createTime, forKey: "createTime")
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
    
    
    func findAll() -> [Article] {
        var listData = [Article]()
        if let theData = NSData.init(contentsOfFile: ArticleArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(ArticleArchiveKey) as? [Article]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:Article) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idBbsNewsInfo == detail.idBbsNewsInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: ArticleArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ArticleArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:Article?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var babyId = ""
            if let list = detail {
                babyId = list.idBbsNewsInfo
            }
            let baseKey = key == "" ? babyId : key
            if note.idBbsNewsInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ArticleArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ArticleArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:Article, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idBbsNewsInfo : key
        for note in array {
            
            if note.idBbsNewsInfo == baseKey {
                if note.newsType != detail.newsType {
                    note.newsType = detail.newsType
                }
                if note.title != detail.title {
                    note.title = detail.title
                }
                if note.imageUrl != detail.imageUrl {
                    note.imageUrl = detail.imageUrl
                }
                if note.content != detail.content {
                    note.content = detail.content
                }
                if note.createTime != detail.createTime {
                    note.createTime = detail.createTime
                }
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ArticleArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ArticleArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:Article?, key:String = "") -> Article? {
        let array = self.findAll()
        var result:Article?
        for note in array {
            let userId = detail == nil ? "" : note.idBbsNewsInfo
            let baseKey = key == "" ? userId : key
            if note.idBbsNewsInfo == baseKey {
                result = note
            }
        }
        return result
    }

}

class ArticleBL: NSObject {
    class func insert(detail:Article) -> [Article]{
        let result = ArticleDAO.shared.insert(detail)
        print("baby list result \(result)")
        return ArticleDAO.shared.findAll()
    }
    
    class func delete(detail:Article, key:String = "") ->[Article]{
        ArticleDAO.shared.delete(detail, key: key)
        return ArticleDAO.shared.findAll()
    }
    
    class func modify(detail:Article, key:String = "") ->[Article]{
        ArticleDAO.shared.modify(detail, key: key)
        return ArticleDAO.shared.findAll()
    }
    
    class func find(detail:Article?, key:String = "") ->Article?{
        return ArticleDAO.shared.find(detail, key: key)
    }

}


//MARK:____ArticleList____
private let ArticleListArchiveKey = "ArticleListArchiveKey"
private let ArticleListArchiveFileName = "ArticleListArchive.archive"
class ArticleList: NSObject {
    /*
     
     idBbsNewsInfo		int		咨讯id
     newsType		int		资讯类型（1：怀孕 2：育儿）
     babyAgeYear		int		年
     babyAgeMon		int		月
     title		string		标题
     content		string		内容
     imgList		string		图片
     imgReplaceormat		string		内容图片占位格式 【图片X】 X=第几张，替换X,然后替换content里的位置作为图片显示
     videoUrl		string		视频地址
     browseCount		int		浏览量
     create_time		string		创建时间（yyyy-MM-dd HH:mm:ss）

     
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
    var create_time:String!
    
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
        self.create_time = ""
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
        if let obj = aDecoder.decodeObjectForKey("create_time") as? String {
            self.create_time = obj
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
        aCoder.encodeObject(self.create_time, forKey: "create_time")
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
    
    
    func findAll() -> [ArticleList] {
        var listData = [ArticleList]()
        if let theData = NSData.init(contentsOfFile: ArticleListArchiveFileName.filePath()) {
            if theData.length > 0 {
                let unArchive = NSKeyedUnarchiver.init(forReadingWithData: theData)
                if let arr = unArchive.decodeObjectForKey(ArticleListArchiveKey) as? [ArticleList]{
                    listData = arr
                }
            }
        }
        return listData
    }
    
    func insert(detail:ArticleList) -> Bool {
        var array = self.findAll()
        for base in array {
            if base.idBbsNewsInfo == detail.idBbsNewsInfo {
                if let currentIndex = array.indexOf(base) {
                    array.removeAtIndex(currentIndex)
                }
            }
        }
        array.append(detail)
        
        let theData = NSMutableData.init()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
        archiver.encodeObject(array, forKey: ArticleListArchiveKey)
        archiver.finishEncoding()
        return theData.writeToFile(ArticleListArchiveFileName.filePath(), atomically: true)
        
    }
    
    func delete(detail:ArticleList?, key:String = "") -> Bool {
        var array = self.findAll()
        for note in array {
            var babyId = ""
            if let list = detail {
                babyId = list.idBbsNewsInfo
            }
            let baseKey = key == "" ? babyId : key
            if note.idBbsNewsInfo == baseKey {
                if let currentIndex = array.indexOf(note) {
                    array.removeAtIndex(currentIndex)
                }
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ArticleListArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ArticleListArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func modify(detail:ArticleList, key:String = "") -> Bool {
        let array = self.findAll()
        let baseKey = key == "" ? detail.idBbsNewsInfo : key
        for note in array {
            
            if note.idBbsNewsInfo == baseKey {
                if note.newsType != detail.newsType {
                    note.newsType = detail.newsType
                }
                if note.babyAgeYear != detail.babyAgeYear {
                    note.babyAgeYear = detail.babyAgeYear
                }
                if note.babyAgeMon != detail.babyAgeMon {
                    note.babyAgeMon = detail.babyAgeMon
                }
                if note.title != detail.title {
                    note.title = detail.title
                }
                if note.content != detail.content {
                    note.content = detail.content
                }
                if note.imgList != detail.imgList {
                    note.imgList = detail.imgList
                }
                if note.imgReplaceormat != detail.imgReplaceormat {
                    note.imgReplaceormat = detail.imgReplaceormat
                }
                if note.videoUrl != detail.videoUrl {
                    note.videoUrl = detail.videoUrl
                }
                if note.browseCount != detail.browseCount {
                    note.browseCount = detail.browseCount
                }
                if note.create_time != detail.create_time {
                    note.create_time = detail.create_time
                }
                
                let theData = NSMutableData.init()
                let archiver = NSKeyedArchiver.init(forWritingWithMutableData: theData)
                archiver.encodeObject(array, forKey: ArticleArchiveKey)
                archiver.finishEncoding()
                return theData.writeToFile(ArticleArchiveFileName.filePath(), atomically: true)
            }
        }
        return false
    }
    
    func find(detail:ArticleList?, key:String = "") -> ArticleList? {
        let array = self.findAll()
        var result:ArticleList?
        for note in array {
            let userId = detail == nil ? "" : note.idBbsNewsInfo
            let baseKey = key == "" ? userId : key
            if note.idBbsNewsInfo == baseKey {
                result = note
            }
        }
        return result
    }
    
}

class ArticleListBL: NSObject {
    class func insert(detail:ArticleList) -> [ArticleList]{
        let result = ArticleListDAO.shared.insert(detail)
        print("baby list result \(result)")
        return ArticleListDAO.shared.findAll()
    }
    
    class func delete(detail:ArticleList, key:String = "") ->[ArticleList]{
        ArticleListDAO.shared.delete(detail, key: key)
        return ArticleListDAO.shared.findAll()
    }
    
    class func modify(detail:ArticleList, key:String = "") ->[ArticleList]{
        ArticleListDAO.shared.modify(detail, key: key)
        return ArticleListDAO.shared.findAll()
    }
    
    class func find(detail:ArticleList?, key:String = "") ->ArticleList?{
        return ArticleListDAO.shared.find(detail, key: key)
    }
    
    class func findAll() ->[ArticleList]{
        return ArticleListDAO.shared.findAll()
    }
}





