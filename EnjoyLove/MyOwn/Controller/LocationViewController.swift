//
//  LocationViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/18.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class LocationViewController: BaseViewController {

    private var locationView:LocationView!
    var locationInfoHandler:((provinceCode:CityCode, cityCode:CityCode)->())?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(title: "地区", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationView = LocationView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), completionHandler: { [weak self](location, section) in
            if let weakSelf = self{
                if section == 0{
                    if let locationInfo = weakSelf.locationInfoHandler{
                        locationInfo(provinceCode: location.provinceCode, cityCode: location.cityCode)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }else if section == 1{
                    let cityViewController = LocationCityViewController()
                    cityViewController.provincial = location.provincial
                    cityViewController.codeHandler = {(province, city) in
                        if let locationInfo = weakSelf.locationInfoHandler{
                            locationInfo(provinceCode: province, cityCode: city)
                        }
                    }
                    weakSelf.navigationController?.pushViewController(cityViewController, animated: true)
                }
            }
        })
        self.view.addSubview(self.locationView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
