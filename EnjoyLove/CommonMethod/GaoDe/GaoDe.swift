//
//  GaoDe.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let GaoDeKey = "5525276dc4688afe0598bb9deba57dda"
private let DefaultLocationTimeout = 2
private let DefaultReGeocodeTimeout = 2



class GaoDe: NSObject {
    
    private var locationManager:AMapLocationManager!
    
    class func sharedInstance() ->GaoDe{
        struct Shared{
            static var pred:dispatch_once_t = 0
            static var Instance:GaoDe! = nil
        }
        dispatch_once(&Shared.pred) {
            Shared.Instance = GaoDe()
        }
        return Shared.Instance
    }
    
    func uploadKey(){
        AMapServices.sharedServices().apiKey = GaoDeKey
    }
    
    func startLocation(completionHandler:((province:String, city:String)->())?) -> Void {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = AMapLocationManager()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.locationTimeout = DefaultLocationTimeout
            self.locationManager.reGeocodeTimeout = DefaultReGeocodeTimeout
            self.locationManager.requestLocationWithReGeocode(true, completionBlock: { (cllocation:CLLocation!, regeocode:AMapLocationReGeocode!, error:NSError!) in
                if error != nil{
                    return
                }
                if let handle = completionHandler{
                    dispatch_async(dispatch_get_main_queue(), {
                        handle(province: regeocode.province, city: regeocode.city)
                        self.stopLocation()
                    })
                }
            })
        }
    }
    
    func stopLocation() -> Void {
        self.locationManager.stopUpdatingLocation()
        self.locationManager = nil
    }
    
    
    
    
}
