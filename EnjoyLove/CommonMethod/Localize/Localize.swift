//
//  Localize.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/20.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let HMCurrentLanguageKey = "HMCurrentLanguageKey"
let HMDefaultLanguage = "en"
let HMBaseBundle = "Base"
let HMLanguageChangeNotification = "HMLanguageChangeNotification"

func Localied(string:String) -> String {
    return string.localized()
}

func Localized(string:String, arguments:CVarArgType...) -> String {
    return String.init(format: string.localized(), arguments: arguments)
}

func LocalizedPlural(string:String, argument:CVarArgType) -> String {
    return string.localizedPlural(argument)
}

extension String{
    func localized() -> String {
        if let path = NSBundle.mainBundle().pathForResource(Localize.currentLanguage(), ofType: "lproj"), let bundle = NSBundle.init(path: path) {
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }else if let path = NSBundle.mainBundle().pathForResource(HMBaseBundle, ofType: "lproj"), let bundle = NSBundle.init(path: path){
            return bundle.localizedStringForKey(self, value: nil, table: nil)
        }
        return self
    }
    
    func localizedFormat(arguments:CVarArgType...) ->String{
        return String.init(format: localized(), arguments: arguments)
    }
    
    func localizedPlural(argument:CVarArgType) -> String {
        return NSString.localizedStringWithFormat(localized() as NSString, argument) as String
    }
}

class Localize: NSObject {
    class func availableLanguages(exludeBase:Bool = false) ->[String]{
        var availableLanguages = NSBundle.mainBundle().localizations
        if let indexOfBase = availableLanguages.indexOf("Base") where exludeBase == true {
            availableLanguages.removeAtIndex(indexOfBase)
        }
        return availableLanguages
    }
    
    
    class func currentLanguage() ->String{
        if let currentLanguage = NSUserDefaults.standardUserDefaults().objectForKey(HMCurrentLanguageKey) as? String{
            return currentLanguage
        }
        return defaultLanguage()
    }
    
    class func setCurrentLanguage(language:String){
        let selectedLanguage = availableLanguages().contains(language) ? language : defaultLanguage()
        if selectedLanguage != currentLanguage() {
            NSUserDefaults.standardUserDefaults().setObject(selectedLanguage, forKey: HMCurrentLanguageKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            NSNotificationCenter.defaultCenter().postNotificationName(HMLanguageChangeNotification, object: nil)
        }
    }
    
    class func defaultLanguage() ->String{
        var defaultLanguage = String()
        guard let preferredLanguage = NSBundle.mainBundle().preferredLocalizations.first else {
            return HMDefaultLanguage
        }
        let availableLanguages:[String] = self.availableLanguages()
        if availableLanguages.contains(preferredLanguage) {
            defaultLanguage = preferredLanguage
        }else{
            defaultLanguage = HMDefaultLanguage
        }
        return defaultLanguage
    }
    
    class func resetCurrentLanguageToDefault(){
        setCurrentLanguage(self.defaultLanguage())
    }
    
    class func displayNameForLanguage(language:String) ->String{
        print("current \(currentLanguage())")
        let locale = NSLocale(localeIdentifier: currentLanguage())
        if #available(iOS 10.0, *) {
            if let displayName = locale.displayNameForKey(locale.languageCode, value: language) {
                return displayName
            }
        } else {
            // Fallback on earlier versions
        }
        return String()
    }
}
