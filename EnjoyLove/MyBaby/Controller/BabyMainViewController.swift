//
//  BabyMainViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/26.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

//private let babyViewHeight:CGFloat = upRateHeight(110)
private let faceWidth:CGFloat = upRateWidth(55)
private let faceHeight:CGFloat = upRateWidth(55)
private let faceNumberWidth:CGFloat = upRateWidth(15)
private let lineBeginX:CGFloat = upRateWidth(15)

class BabyMainViewController: BaseVideoViewController {

            /// 宝宝数据
    private var babyData:[Baby]!
    private var babyView:BabyView!
    private var devices:[Equipments]!
    
    private var testLabel:UILabel!
    let availableLanguages = Localize.availableLanguages()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if LoginBL.isLogin() == false {
            let login = LoginViewController()
            self.presentViewController(login, animated: true, completion: nil)
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
            self.tabBarController?.tabBar.hidden = false
            self.navigationController?.navigationBarHidden = false
            self.navigationBarItem(self, title: "我的宝宝", leftSel: nil, rightSel: #selector(BabyMainViewController.rightConfigClick), rightItemSize: CGSizeMake(20, 20), rightImage: "myOwnConfig.png")
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loginAndRegistSuccessRefresh), name: LoginEqutementListNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(addNewDevice), name: BabyZoneConfig.shared.AddDeviceNotification, object: nil)
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(deleteDevice), name: BabyZoneConfig.shared.DeleteDeviceNotificaiton, object: nil)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setnkznkup after loading the view.
        self.initialize()
    }
        
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        self.babyData = []
        self.babyData.removeAll()
        let devices = EquipmentsBL.findAll()
        if devices.count > 0 {
            for eqm in devices {
                let baby = Baby(babyImage: Utils.getHeaderFilePathWithId(eqm.eqmDid), babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0", babyEquipment: eqm)
                self.babyData.append(baby)
            }
        }else{
            let baby = Baby(babyImage: "babySleep.png", babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0", babyEquipment: nil)
            self.babyData.append(baby)
        }
        
        self.babyView = BabyView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: self.view.frame.height - navAndTabHeight), data: self.babyData, playCompletionHandler: { [weak self](baby, index) in
            if let weakSelf = self{
                if let babyEqm = baby.babyEquipment{
                    let currentEqm = EquipmentsBL.contactFromEquipment(babyEqm)
                    if currentEqm.onLineState == 1{
                        AppBrowseCount.shared.modelTypeMonitor()
                        let monitor = P2PMonitorController()
                        monitor.deviceContact = currentEqm
                        monitor.monitorRefreshHandler = { (image) in
                            weakSelf.babyView.refreshAtCurrent(currentEqm, index: index, img: image)
                        };
                        weakSelf.navigationController?.pushViewController(monitor, animated: true)
                    }else{
                        HUD.showText("此设备处于离线状态,请检查...", onView: weakSelf.view.window!)
                    }
                }else{
                    HUD.showText("您未绑定设备", onView: weakSelf.view.window!)
                }
            }
        }) { [weak self](baby, index) in
            if let weakSelf = self{
                let music = PlayMusicViewController()
                weakSelf.navigationController?.pushViewController(music, animated: true)
            }
        }
        self.view.addSubview(self.babyView)
        
    }
    
    
    func remoteNotification() -> Void {
        let push = BabyPushViewController()
        let nav = UINavigationController.init(rootViewController: push)
        self.presentViewController(nav, animated: true, completion: nil)
    }
        
    func rightConfigClick() -> Void {
        print("config click")
        let setting = BabySettingViewController()
        self.navigationController?.pushViewController(setting, animated: true)
    }
    
    override func refreshContact() {
        super.refreshContact()
    }
    
 
    func addNewDevice() -> Void {
        self.initialize()
    }
    
    func deleteDevice() -> Void {
        self.initialize()
    }
    
    func loginAndRegistSuccessRefresh() {
        self.initialize()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
