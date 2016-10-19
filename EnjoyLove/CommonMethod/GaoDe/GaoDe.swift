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

typealias LocationHandler = (String?,Double,Double) ->()

class GaoDe: NSObject,AMapLocationManagerDelegate {

    private var locationManager:AMapLocationManager!
    private var locationBlock:LocationHandler!
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
    }
    
    func startLocation() -> Void {
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager = AMapLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.locationTimeout = DefaultLocationTimeout
            self.locationManager.reGeocodeTimeout = DefaultReGeocodeTimeout
        }
    }
    
    func stopLocation() -> Void {
        self.locationManager.stopUpdatingLocation()
        self.locationManager.delegate = nil
        self.locationManager = nil
    }
    
    func getCityInformation(completiomHandler:((String?,Double,Double)->())) -> Void {
        self.startLocation()
        self.locationBlock = completiomHandler
    }
    
    private func handleLocation(city:String?,lat:CLLocationDegrees,lon:CLLocationDegrees){
        if NSOperationQueue.currentQueue() == NSOperationQueue.mainQueue() {
            if let handler = self.locationBlock {
                handler(city, lat, lon)
            }
        }else{
            dispatch_async(dispatch_get_main_queue(), { 
                if let handler = self.locationBlock {
                    handler(city, lat, lon)
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
                    let zipCode = place.postalCode
                    self.handleLocation(currentCity, lat: lat, lon: lon)
                    self.locationManager.stopUpdatingLocation()
                    return
                }
                self.handleLocation(nil, lat: 0, lon: 0)
            }
            self.handleLocation(nil, lat: 0, lon: 0)
        }
    }
    
}
