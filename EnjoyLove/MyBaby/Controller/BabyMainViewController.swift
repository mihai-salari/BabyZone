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
    
    private var testLabel:UILabel!
    let availableLanguages = Localize.availableLanguages()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        for subview in self.view.subviews {
            subview.removeFromSuperview()
        }
        if isLogin() == false {
            let login = LoginViewController()
            self.presentViewController(login, animated: true, completion: nil)
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
            self.tabBarController?.tabBar.hidden = false
            self.navigationController?.navigationBarHidden = false
            self.navigationBarItem(self, title: "我的宝宝", leftSel: nil, rightSel: #selector(BabyMainViewController.rightConfigClick), rightItemSize: CGSizeMake(20, 20), rightImage: "myOwnConfig.png")
            self.initialize()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setnkznkup after loading the view.
//        self.performSelector(#selector(self.remoteNotification), withObject: nil, afterDelay: 1)
        let personDetailQueue = dispatch_queue_create("personDetailQueue", nil)
        personDetailQueue.queue { 
            PersonDetail.sendAsyncPersonDetail(nil)
        }
        
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
        if self.babyData != nil {
            self.babyData = nil
        }
        self.babyData = []
        
        if EquipmentsBL.findAll().count > 0 {
            for eqm in EquipmentsBL.findAll() {
                let baby = Baby(babyImage: Utils.getHeaderFilePathWithId(eqm.eqmDid), babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0")
                self.babyData.append(baby)
            }
        }else{
            let baby = Baby(babyImage: "babySleep.png", babyRemindCount: "0", babyTemperature: "0", babyHumidity: "0")
            self.babyData.append(baby)
        }
        
        if self.babyView != nil {
            self.babyView.removeFromSuperview()
            self.babyView = nil
        }
        
        
        
        self.babyView = BabyView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: self.view.frame.height - navAndTabHeight), data: self.babyData, playCompletionHandler: { [weak self](baby) in
            if let weakSelf = self{
                
            }
        }) { [weak self](baby) in
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
