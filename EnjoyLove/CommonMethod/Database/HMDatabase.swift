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

