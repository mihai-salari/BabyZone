//
//  GaoDe.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/29.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let GaoDeKey = "5525276dc4688afe0598bb9deba57dda"
private let DefaultLocationTimeout = 6
private let DefaultReGeocodeTimeout = 3



class GaoDe: NSObject,AMapLocationManagerDelegate {
    
    var location:Location!
    private var locationManager:AMapLocationManager!
    private var locationBlock:((location:Location)->())?
    private var locationError:Bool = false
    
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
        if CLLocationManager.locationServicesEnabled() {
            
        }
    }
    
    func startLocation(completionHandler:((location:Location)->())?) -> Void {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = AMapLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.locationTimeout = DefaultLocationTimeout
            self.locationManager.reGeocodeTimeout = DefaultReGeocodeTimeout
        }
        self.locationBlock = completionHandler
    }
    
    func stopLocation() -> Void {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.locationManager = nil
    }
    
    func getCityInformation(completiomHandler:((location:Location)->())) -> Void {
        self.startLocation(completiomHandler)
        self.locationBlock = completiomHandler
    }
    
    private func handleLocation(province: String?, city:String?, lat:CLLocationDegrees,lon:CLLocationDegrees){
        if NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue() {
            if let handler = self.locationBlock {
                self.location = Location(provinceName: province == nil ? "" : province!, provinceCode: "", cityName: city == nil ? "" : city!, cityCode: "", lat: lat, lon: lon)
                handler(location: self.location)
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), { 
                if let handler = self.locationBlock {
                    self.location = Location(provinceName: province == nil ? "" : province!, provinceCode: "", cityName: city == nil ? "" : city!, cityCode: "", lat: lat, lon: lon)
                    handler(location: self.location)
                }
            })
        }
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didFailWithError error: NSError!) {
        if error != nil {
            self.locationError = true
        }
    }
    
    func amapLocationManager(manager: AMapLocationManager!, didUpdateLocation location: CLLocation!) {
        let geocoder = CLGeocoder()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        
        geocoder.reverseGeocodeLocation(location) { (placemarks:[CLPlacemark]?, error:NSError?) in
            if let marks = placemarks{
                if marks.count > 0{
                    let place = marks[0]
                    let province = place.subAdministrativeArea
                    let currentCity = place.locality
                    self.handleLocation(province, city: currentCity, lat: lat, lon: lon)
                    self.locationManager.stopUpdatingLocation()
                    return
                }
                self.handleLocation(nil, city: nil, lat: 0, lon: 0)
            }
            self.handleLocation(nil, city: nil, lat: 0, lon: 0)
        }
    }
    
}
