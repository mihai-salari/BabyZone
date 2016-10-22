//
//  DeviceListViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/10/9.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class DeviceListViewController: BaseVideoViewController {

    private var devicesListView:DeviceListView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBarHidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "设备列表", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.devicesListView = DeviceListView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), contacts: self.contactsData, exchageHandler: { (onSwitch, device) in
            
            }, enterHandler: { (device) in
                let video = BabyVideoViewController()
                video.deviceContact = device
                self.navigationController?.pushViewController(video, animated: true)
            }, addNewDeviceHandler: { 
                
        })
        
        self.view.addSubview(self.devicesListView)
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
