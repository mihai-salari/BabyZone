//
//  ExtensionMethod.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/1.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class ExtensionMethod: NSObject {

}

extension NSObject{
    
    func currentViewController() ->UIViewController?{
        var result:UIViewController? = nil
        
        var currentWindow = UIApplication.sharedApplication().keyWindow
        if let window = currentWindow {
            if window.windowLevel != UIWindowLevelNormal {
                let windows = UIApplication.sharedApplication().windows
                for tmpWin in windows {
                    if tmpWin.windowLevel == UIWindowLevelNormal {
                        currentWindow = tmpWin
                        break
                    }
                }
            }
        }
        if let currentWin = currentWindow {
            let frontView = currentWin.subviews[0]
            let nextResponder = frontView.nextResponder()
            if let next = nextResponder {
                if next.isKindOfClass(UIViewController) == true {
                    result = next as? UIViewController
                }else{
                    result = currentWin.rootViewController
                }
            }
        }
        
        return result
    }
    
    func actionQueue(label: UnsafePointer<Int8>, subQueueBlock: dispatch_block_t?, mainQueueBlock:dispatch_block_t?) -> Void {
        let subQueue = dispatch_queue_create(label, nil)
        subQueue.queue { 
            if let subBlock = subQueueBlock{
                subBlock()
            }
            if let mainQueue = mainQueueBlock{
                dispatch_get_main_queue().queue({
                    mainQueue()
                })
            }
        }
        
    }
}


extension NSMutableAttributedString{

    
    /**
     部分字符串偏移
     
     - parameter offset:    偏移量
     - parameter subString: 被分割字符串
     */
    func addOffset(offset:Float, subString:String) -> Void {
        let range = self.string.rangeOfStringNoCase(subString)
        if range.location != NSNotFound {
            self.addAttribute(NSBaselineOffsetAttributeName, value: NSNumber.init(float: offset), range: range)
        }
    }
    /**
     设置字号
     
     - parameter fontSize:  字号大小
     - parameter subString: 被分割字符串
     */
    func addFont(font:UIFont, subString:String) -> Void {
        let range = self.string.rangeOfStringNoCase(subString)
        if range.location != NSNotFound {
            self.addAttribute(NSFontAttributeName, value: font, range: range)
        }
    }
    /**
     设置颜色
     
     - parameter color:     颜色
     - parameter subString: 字符串
     */
    func addColor(color:UIColor, subString:String) -> Void {
        let range = self.string.rangeOfStringNoCase(subString)
        if range.location != NSNotFound {
            self.addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
    
}

extension String{

    /**
     分割字符串
     
     - parameter str: 字符串
     
     - returns: NSRange
     */
    func rangeOfStringNoCase(str:String) -> NSRange {
        return NSString.init(string: self).rangeOfString(str, options: .CaseInsensitiveSearch)
    }
    /**
     切割字符串后的结果
     
     - parameter str: 被切割的字符串
     
     - returns: 余下的字符串，被切割的字符串
     */
    func seperatorString(str:String) -> (String, String) {
        let range = self.rangeOfString(str, options: .CaseInsensitiveSearch, range: nil, locale: nil)
        if let range = range {
            let frontStr = self.substringToIndex(range.startIndex)
            let afterStr = self.substringFromIndex(range.startIndex)
            return (frontStr, afterStr)
        }
        return (self, str)
    }
    
    /**
     摄氏温度字符串
     
     - parameter fontSize: 字号大小
     - parameter color:    颜色
     
     */
    func customAttributeString(fontSize:CGFloat, subFontSize:CGFloat, offSet:Float, color:UIColor,subString:String) -> NSMutableAttributedString{
        let attributeStr = NSMutableAttributedString.init(string: self)
        attributeStr.addAttributes([NSForegroundColorAttributeName:color, NSFontAttributeName:UIFont.systemFontOfSize(fontSize)], range: NSMakeRange(0, self.characters.count))
        attributeStr.addFont(UIFont.systemFontOfSize(subFontSize), subString: subString)
        attributeStr.addOffset(offSet, subString: subString)
        
        return attributeStr
    }
    
    
    /**
     字体大小
     
     - parameter font: 字号大小
     
     - returns: 字体大小
     */
    func size(font:UIFont) -> CGSize {
        return NSString.init(string: self).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil).size
    }
    
    func pinyin() -> String {
        if self.characters.count > 0 {
            let ms = NSMutableString.init(string: self)
            if CFStringTransform(ms as CFMutableStringRef, nil, kCFStringTransformMandarinLatin, false) {
                //带音调
                if CFStringTransform(ms as CFMutableStringRef, nil, kCFStringTransformStripDiacritics, false) {
                    return ms.uppercaseString
                }
            }
        }
        return String()
    }
    
    func filePath() -> String {
        if let docPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first {
            return NSString.init(string: docPath).stringByAppendingPathComponent(self)
        }
        return String()
    }
    
    func setDefaultsForFlag(flag:Bool) -> Void {
        NSUserDefaults.standardUserDefaults().setBool(flag, forKey: self)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func defaultsForFlag() -> Bool {
        return NSUserDefaults.standardUserDefaults().boolForKey(self)
    }
    
    func setDefaultObject(val:AnyObject?) -> Void {
        NSUserDefaults.standardUserDefaults().setObject(val, forKey: self)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func defaultObject() -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(self)
    }
    
}



//MARK:_____加密算法_______

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:      result = kCCHmacAlgMD5
        case .SHA1:     result = kCCHmacAlgSHA1
        case .SHA224:   result = kCCHmacAlgSHA224
        case .SHA256:   result = kCCHmacAlgSHA256
        case .SHA384:   result = kCCHmacAlgSHA384
        case .SHA512:   result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:      result = CC_MD5_DIGEST_LENGTH
        case .SHA1:     result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:   result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:   result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:   result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:   result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String  {
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        return stringFromBytes(result, length: digestLen)
    }
    
    var sha1: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_SHA1_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_SHA1(str!, strLen, result)
        return stringFromBytes(result, length: digestLen)
    }
    
    var sha256String: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_SHA256(str!, strLen, result)
        return stringFromBytes(result, length: digestLen)
    }
    
    var sha512String: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_SHA512_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_SHA512(str!, strLen, result)
        return stringFromBytes(result, length: digestLen)
    }
    
    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        bytes.dealloc(length)
        return String(format: hash as String)
    }
    
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = Int(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        let keyStr = key.cStringUsingEncoding(NSUTF8StringEncoding)
        let keyLen = Int(key.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        
        let digest = stringFromResult(result, length: digestLen)
        
        result.dealloc(digestLen)
        
        return digest
    }
    
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", result[i])
        }
        return String(hash)
    }
}

extension String{
    func isTelNumber()->Bool
        
    {
        
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        
        let regextestcm = NSPredicate(format: "SELF MATCHES %@",CM )
        
        let regextestcu = NSPredicate(format: "SELF MATCHES %@" ,CU)
        
        let regextestct = NSPredicate(format: "SELF MATCHES %@" ,CT)
        
        if ((regextestmobile.evaluateWithObject(self) == true)
            
            || (regextestcm.evaluateWithObject(self)  == true)
            
            || (regextestct.evaluateWithObject(self) == true)
            
            || (regextestcu.evaluateWithObject(self) == true))
            
        {
            return true
        }
            
        else
            
        {
            return false
        }
    }
}

extension UIColor{
    
    class func colorFromRGB(r:CGFloat,g:CGFloat,b:CGFloat)->UIColor?{
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func colorFromRGB(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor?{
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class func hexStringToColor(hexString: String) -> UIColor{
        var cString: String = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if cString.characters.count < 6 {return UIColor.blackColor()}
        if cString.hasPrefix("0X") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(2))}
        if cString.hasPrefix("#") {cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))}
        if cString.characters.count != 6 {return UIColor.blackColor()}
        
        var range: NSRange = NSMakeRange(0, 2)
        
        let rString = (cString as NSString).substringWithRange(range)
        range.location = 2
        let gString = (cString as NSString).substringWithRange(range)
        range.location = 4
        let bString = (cString as NSString).substringWithRange(range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        NSScanner.init(string: rString).scanHexInt(&r)
        NSScanner.init(string: gString).scanHexInt(&g)
        NSScanner.init(string: bString).scanHexInt(&b)
        
        return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: CGFloat(1))
        
    }
    
}

//MARK:____UIVIEW____

enum GradientType {
    case TopBottom
    case LeftRight
    case LeftTopToRightBottom
    case LeftBottomToRightTop
}

extension UIView{
    class func gradientView(frame:CGRect, colors:[UIColor]?, gradientType:GradientType) ->UIView{
        let view = UIView.init(frame: frame)
        let gradientLayer = CAGradientLayer()
        var cgColors:[CGColor] = []
        if let uiColors = colors {
            for color in uiColors {
                cgColors.append(color.CGColor)
            }
        }
        gradientLayer.frame = view.bounds
        gradientLayer.colors = cgColors
        gradientLayer.locations = [NSNumber.init(float: 0.0), NSNumber.init(float: 1.0)]
        switch gradientType {
        case .TopBottom:
            gradientLayer.startPoint = CGPointMake(0, 0)
            gradientLayer.endPoint = CGPointMake(0, 1)
        case .LeftRight:
            gradientLayer.startPoint = CGPointMake(0, 0)
            gradientLayer.endPoint = CGPointMake(0, 1)
        case .LeftTopToRightBottom:
            gradientLayer.startPoint = CGPointMake(0, 0)
            gradientLayer.endPoint = CGPointMake(1, 1)
        case .LeftBottomToRightTop:
            gradientLayer.startPoint = CGPointMake(0, -1)
            gradientLayer.endPoint = CGPointMake(1, 0)
        }
        view.layer.insertSublayer(gradientLayer, atIndex: 0)
        return view
    }
}

//MARK:___UIIMAGE___

extension UIImage{
    class func gradientImageFromColors(colors:[UIColor]?,  gradientType:Int, size:CGSize) ->UIImage{
        var cgColors:[CGColor] = []
        if let uiColors = colors {
            for color in uiColors {
                cgColors.append(color.CGColor)
            }
        }
        
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context!)
        let colorSpace = CGColorGetColorSpace(cgColors.last!)
        let gradient = CGGradientCreateWithColors(colorSpace, cgColors, nil)
        var start = CGPointZero
        var end = CGPointZero
        switch gradientType {
        case 0:
            start = CGPointMake(0, 0)
            end = CGPointMake(0, 1)
        case 1:
            start = CGPointMake(0, 0)
            end = CGPointMake(0, 1)
        case 2:
            start = CGPointMake(0, 0)
            end = CGPointMake(1, 1)
        case 3:
            start = CGPointMake(0, -1)
            end = CGPointMake(1, 0)
        default:
            break
        }
        
        CGContextDrawLinearGradient(context!, gradient!, start, end, [.DrawsAfterEndLocation, .DrawsBeforeStartLocation])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        CGContextRestoreGState(context!)
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func imageFromColor(color:UIColor = UIColor.clearColor(), size:CGSize) ->UIImage{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ctx!, color.CGColor)
        CGContextFillRect(ctx!, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func imageWithName(name:String = ".") -> UIImage? {
        var image:UIImage?
        let pointRange = name.rangeOfString(".")
        if pointRange != nil {
            let preName = name.substringToIndex(pointRange!.startIndex)
            let type = name.substringFromIndex(pointRange!.startIndex.advancedBy(1))
            let path = NSBundle.mainBundle().pathForResource(preName, ofType: type)
            if let imagePath = path {
                let imageData = NSData.init(contentsOfFile: imagePath)
                if let data = imageData {
                    image = UIImage.init(data: data)
                }
            }
            
        }else{
            if name != "" {
                image = UIImage.init(named: name)
            }
        }
        return image
    }
    
    func imageCompressScaleToSize(size:CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    class func setImageURL(url:String) -> UIImage {
        dispatch_async(dispatch_queue_create("imageDownloadQueue", nil)) {
            do{
                if let imageUrl = NSURL.init(string: url){
                    let imageData = try NSData.init(contentsOfURL: imageUrl, options: .DataReadingMappedIfSafe)
                    if let resultImage = UIImage.init(data: imageData){
                        dispatch_async(dispatch_get_main_queue(), {
                            return resultImage
                        })
                    }
                }
            }catch{
                
            }
        }
        return UIImage.init()
    }
    
}

//MARK:___UIIMAGEVIEW___
extension UIImageView{
    func setImageURL(url:String) -> Void {
        dispatch_async(dispatch_queue_create("imageDownloadQueue", nil)) { 
            do{
                if let imageUrl = NSURL.init(string: url){
                    let imageData = try NSData.init(contentsOfURL: imageUrl, options: .DataReadingMappedIfSafe)
                    if let resultImage = UIImage.init(data: imageData){
                        dispatch_async(dispatch_get_main_queue(), { 
                            self.image = resultImage
                        })
                    }
                }
            }catch{
                
            }
        }
    }
}

extension UIButton{
    func setImageURL(url:String, state:UIControlState) -> Void {
        dispatch_async(dispatch_queue_create("imageDownloadQueue", nil)) {
            do{
                if let imageUrl = NSURL.init(string: url){
                    let imageData = try NSData.init(contentsOfURL: imageUrl, options: .DataReadingMappedIfSafe)
                    if let resultImage = UIImage.init(data: imageData){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.setImage(resultImage, forState: state)
                        })
                    }
                }
            }catch{
                
            }
        }
    }
    
    func setBackgroundImageURL(url:String, state:UIControlState) -> Void {
        dispatch_async(dispatch_queue_create("imageDownloadQueue", nil)) {
            do{
                if let imageUrl = NSURL.init(string: url){
                    let imageData = try NSData.init(contentsOfURL: imageUrl, options: .DataReadingMappedIfSafe)
                    if let resultImage = UIImage.init(data: imageData){
                        dispatch_async(dispatch_get_main_queue(), {
                            self.setBackgroundImage(resultImage, forState: state)
                        })
                    }
                }
            }catch{
                
            }
        }
    }
}

extension NSData{
    
    class func dataWithUrl(url:String) -> NSData {
        var resultData:NSData!
        dispatch_async(dispatch_queue_create("ImageToDataQueue", nil)) { 
            do{
                if let imageUrl = NSURL.init(string: url){
                    let imageData = try NSData.init(contentsOfURL: imageUrl, options: .DataReadingMappedIfSafe)
                    resultData = imageData
                }
            }catch{
                
            }
        }
        return resultData == nil ? NSData.init() : resultData
    }
}

extension dispatch_queue_t{
    func queue(block:dispatch_block_t) -> Void{
        dispatch_async(self, block)
    }
}




extension NSMutableArray{
    
    /**
     *  数组去重,原序
     */
    
    func orderDuplicateRemove() -> NSArray {
        let nameArray = NSMutableArray.init(capacity: 3)
        for i in 0 ..< self.count {
            if nameArray.containsObject(self.objectAtIndex(i)) == false {
                nameArray.addObject(self.objectAtIndex(i))
            }
        }
        self.removeAllObjects()
        self.addObjectsFromArray(nameArray as [AnyObject])
        return self
    }
    
    /**
     *  去重，无序NSSet
     */
    
    func disorderSetDuplicateRemove() -> NSArray {
        let set = NSSet.init(array: self as [AnyObject])
        self.removeAllObjects()
        for obj in set {
            self.addObject(obj)
        }
        return self
    }
    
    /**
     *  去重，无序NSDictionary
     */
    
    func disorderDictionaryDuplicateRemove() -> NSArray {
        let dict = NSMutableDictionary()
        for obj in self {
            dict.setObject(obj, forKey: "\(obj)")
        }
        self.removeAllObjects()
        for obj in dict.allValues {
            self.addObject(obj)
        }
        return self
    }
    
}

extension UIView{
    var left:CGFloat{
        set{
            self.frame.origin.x = newValue
        }
        get{
            return self.frame.origin.x
        }
    }
    
    var right:CGFloat{
        set{
            self.frame.origin.x = newValue - self.frame.size.width
        }
        get{
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    var top:CGFloat{
        set{
            self.frame.origin.y = newValue
        }
        get{
            return self.frame.origin.y
        }
    }
    
    var bottom:CGFloat{
        set{
            self.frame.origin.y = newValue - self.frame.size.height
        }
        get{
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    var centerX:CGFloat{
        set{
            self.center = CGPointMake(newValue, self.center.y)
        }
        get{
            return self.center.x
        }
    }
    
    var centerY:CGFloat{
        set{
            self.center = CGPointMake(self.center.y, newValue)
        }
        get{
            return self.center.y
        }
    }
    
    var width:CGFloat{
        set{
            self.frame.size.width = newValue
        }
        get{
            return self.frame.size.width
        }
    }
    
    var height:CGFloat{
        set{
            self.frame.size.height = newValue
        }
        get{
            return self.frame.size.height
        }
    }
    
    var size:CGSize{
        set{
            self.frame.size = newValue
        }
        get{
            return self.frame.size
        }
    }
    
    var orientationWidth:CGFloat{
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? self.height : self.width
    }
    
    var orientationHeight:CGFloat{
        return UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) ? self.width : self.height
    }
    
    func removeAllSubviews() -> Void {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
}


//MARK:___TEXTFIELD___

extension UITextField{
    class func textField(frame:CGRect, title:String?, titleColor:UIColor = UIColor.whiteColor(), seperatorColor:UIColor = UIColor.colorFromRGB(255, g: 255, b: 255, a: 0.6)!, holder:String?, left:Bool = false, right:Bool = false, rightView:UIView?) ->UITextField{
        let tf = UITextField.init(frame: frame)
        tf.placeholder = holder
        tf.font = UIFont.systemFontOfSize(14)
        if left == true {
            tf.leftViewMode = .Always
            let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: tf.frame.width * (2 / 7), height: tf.frame.height))
            titleLabel.text = title
            titleLabel.textColor = titleColor
            titleLabel.font = UIFont.systemFontOfSize(14)
            tf.leftView = titleLabel
        }
        if right == true {
            tf.rightViewMode = .Always
            tf.rightView = rightView
            
        }
        let line = UIView.init(frame: CGRect(x: 0, y: tf.frame.height - 0.5, width: tf.frame.width, height: 0.5))
        line.backgroundColor = seperatorColor
        tf.addSubview(line)
        return tf
    }
    
    class func textField(frame:CGRect, title:String?, titleColor:UIColor = UIColor.whiteColor(), seperatorColor:UIColor = UIColor.colorFromRGB(255, g: 255, b: 255, a: 0.6)!, holder:String?, clear:Bool = false) ->UITextField{
        let tf = UITextField.init(frame: frame)
        tf.placeholder = holder
        tf.font = UIFont.systemFontOfSize(14)
        tf.leftViewMode = .Always
        if clear == true {
            tf.clearButtonMode = .WhileEditing
        }
        if let item = title {
            let titleLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: tf.frame.width * (2 / 7), height: tf.frame.height))
            titleLabel.text = item
            titleLabel.textColor = titleColor
            titleLabel.font = UIFont.systemFontOfSize(14)
            tf.leftView = titleLabel
        }
        let line = UIView.init(frame: CGRect(x: 0, y: tf.frame.height - 0.5, width: tf.frame.width, height: 0.5))
        line.backgroundColor = seperatorColor
        tf.addSubview(line)
        return tf
    }
    
}

extension UIViewController{
    func dismissToRoot() -> Void {
        var controller = self
        while controller.presentingViewController != nil {
            controller = controller.presentingViewController!
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func navigationBarItem(vc:UIViewController,isImage:Bool = true, title:String ,leftSel:Selector?, leftImage:String = "", leftTitle:String = "", leftItemSize:CGSize = CGSizeZero, rightSel:Selector? ,rightItemSize:CGSize = CGSizeZero, rightImage:String = "", rightTitle:String = "") -> Void {
        
        vc.title = title
        if let action = leftSel {
            if isImage == true {
                let button = UIButton.init(type: .Custom)
                button.frame = CGRectMake(0, 0, leftItemSize.width, leftItemSize.height)
                button.setImage(UIImage.imageWithName(leftImage), forState: .Normal)
                button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
                vc.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
            }else{
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: leftTitle, style: .Plain, target: self, action: action)
            }
            
        }
        if let action = rightSel {
            if isImage == true {
                let button = UIButton.init(type: .Custom)
                button.frame = CGRectMake(0, 0, rightItemSize.width, rightItemSize.height)
                button.setImage(UIImage.imageWithName(rightImage), forState: .Normal)
                button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: button)
            }else{
                vc.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: rightTitle, style: .Plain, target: self, action: action)
            }
            
        }
    }
    
}

extension Bool{
    func setUserDefaults(key:String) -> Void {
        
    }
}



