//
//  BabyMainViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/26.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

//private let babyViewHeight:CGFloat = upRateHeight(110)
private let babyBackgroundImageViewTag = 1000
private let babyPlayButtonTag = 2000
private let babyMusicPlayButtonTag = 3000

class BabyMainViewController: BaseVideoViewController ,UIScrollViewDelegate{

            /// 宝宝数据
    private var babyData:[Baby]!
    private var babyView:BabyView!
    private var devices:[Equipments]!
    
    private var babyScrollView:UIScrollView!
    private var babyPageControl:FilledPageControl!
    private var temperatureLabel:UILabel!
    private var humidityLabel:UILabel!
    private var remindLabel:UILabel!
    private var currentBaby:Int = 0
    
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
            self.view.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
            self.initialize()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setnkznkup after loading the view.
        
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
        
        let floorView = UIImageView.init(frame: CGRect.init(x: 0, y: navigationBarHeight, width: ScreenWidth, height: 10))
        floorView.image = UIImage.imageWithName("floorLayer.png")
        self.view.addSubview(floorView)
        
        self.babyScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: floorView.frame.maxY, width: ScreenWidth, height: ScreenHeight - navAndTabHeight - 10))
        self.babyScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.babyScrollView.contentSize = CGSize(width: CGFloat(self.babyData.count) * self.babyScrollView.frame.width, height: self.babyScrollView.frame.height)
        self.babyScrollView.showsHorizontalScrollIndicator = false
        self.babyScrollView.pagingEnabled = true
        self.babyScrollView.delegate = self
        self.babyScrollView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.babyScrollView)
        
        
        if self.babyData.count == 0 {
            let label = UILabel.init(frame: CGRect.init(x: 0, y: (self.babyScrollView.frame.height - 15) / 2, width: self.babyScrollView.frame.width, height: 30))
            label.text = "请先添加设备"
            label.textColor = UIColor.hexStringToColor("#DD656F")
            label.textAlignment = .Center
            self.babyScrollView.addSubview(label)
        }else{
            for i in 0 ..< self.babyData.count {
                let babyImageView  = UIImageView.init(frame: CGRect(x: CGFloat(i) * self.babyScrollView.frame.width, y: 0, width: self.babyScrollView.frame.width, height: self.babyScrollView.frame.height))
                if let fileImage = UIImage.init(contentsOfFile: self.babyData[i].babyImage) {
                    if let cgImg = fileImage.CGImage {
                        babyImageView.image = UIImage.init(CGImage: cgImg, scale: 1, orientation: UIImageOrientation.Right)
                    }
                }
                babyImageView.tag = babyBackgroundImageViewTag + i
                self.babyScrollView.addSubview(babyImageView)
                
                let babyButton = BabyButton(type: .Custom)
                babyButton.frame = CGRect.init(x: (CGFloat.init(i) * self.babyScrollView.frame.width) + (self.babyScrollView.frame.width - (self.babyScrollView.frame.width * (1 / 6))) / 2, y: (self.babyScrollView.frame.height - (self.babyScrollView.frame.width * (1 / 6))) / 2, width: (self.babyScrollView.frame.width * (1 / 6)), height: (self.babyScrollView.frame.width * (1 / 6)))
                babyButton.setImageSize(CGSize(width: self.babyScrollView.frame.width * (1 / 6),height: ScreenWidth * (1 / 6)), normaImage: "babyPlay.png", title: "观看视频", fontSize: 12)
                babyButton.tag = babyPlayButtonTag + i
                babyButton.addCustomTarget(self, sel: #selector(self.babyPlayClick(_:)))
                self.babyScrollView.addSubview(babyButton)
                
                self.temperatureLabel = UILabel.init(frame: CGRect(x: (CGFloat.init(i) * self.babyScrollView.frame.width), y: self.babyScrollView.frame.height - 60, width: self.babyScrollView.frame.width * (1 / 3), height: 15))
                self.temperatureLabel.text = self.babyData[i].babyTemperature
                self.temperatureLabel.textAlignment = .Center
                self.temperatureLabel.textColor = UIColor.hexStringToColor("#DD656F")
                self.temperatureLabel.font = UIFont.boldSystemFontOfSize(10)
                self.babyScrollView.addSubview(self.temperatureLabel)
                
                let tempDescLabel = UILabel.init(frame: CGRect(x: temperatureLabel.frame.minX, y: temperatureLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
                tempDescLabel.text = "温度(°)"
                tempDescLabel.textAlignment = .Center
                tempDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
                tempDescLabel.font = UIFont.boldSystemFontOfSize(10)
                self.babyScrollView.addSubview(tempDescLabel)
                
                self.humidityLabel = UILabel.init(frame: CGRect(x: temperatureLabel.frame.maxX, y: temperatureLabel.frame.minY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
                self.humidityLabel.text = self.babyData[i].babyHumidity
                self.humidityLabel.textAlignment = .Center
                self.humidityLabel.textColor = UIColor.hexStringToColor("#DD656F")
                self.humidityLabel.font = UIFont.boldSystemFontOfSize(10)
                self.babyScrollView.addSubview(self.humidityLabel)
                
                let humidityDescLabel = UILabel.init(frame: CGRect(x: humidityLabel.frame.minX, y: humidityLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
                humidityDescLabel.text = "湿度(%)"
                humidityDescLabel.textAlignment = .Center
                humidityDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
                humidityDescLabel.font = UIFont.boldSystemFontOfSize(10)
                self.babyScrollView.addSubview(humidityDescLabel)
                
                self.remindLabel = UILabel.init(frame: CGRect(x: humidityLabel.frame.maxX, y: temperatureLabel.frame.minY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
                self.remindLabel.text = self.babyData[i].babyRemindCount
                self.remindLabel.textAlignment = .Center
                self.remindLabel.textColor = UIColor.hexStringToColor("#DD656F")
                self.remindLabel.font = UIFont.boldSystemFontOfSize(10)
                self.babyScrollView.addSubview(self.remindLabel)
                
                let remindDescLabel = UILabel.init(frame: CGRect(x: remindLabel.frame.minX, y: temperatureLabel.frame.maxY, width: temperatureLabel.frame.width, height: temperatureLabel.frame.height))
                remindDescLabel.text = "异常"
                remindDescLabel.textAlignment = .Center
                remindDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
                remindDescLabel.font = UIFont.boldSystemFontOfSize(10)
                self.babyScrollView.addSubview(remindDescLabel)
                
                let musicButtonWidth:CGFloat = 50
                let musicButton = UIButton.init(type: .Custom)
                musicButton.frame = CGRect(x: (CGFloat.init(i) * self.babyScrollView.frame.width) + (self.babyScrollView.frame.width - musicButtonWidth - 15), y: 15, width: musicButtonWidth, height: musicButtonWidth)
                musicButton.tag = babyMusicPlayButtonTag + i
                musicButton.setImage(UIImage.imageWithName("music_play.png"), forState: .Selected)
                musicButton.setImage(UIImage.imageWithName("music_stop.png"), forState: .Normal)
                musicButton.addTarget(self, action: #selector(self.babyMusicClick(_:)), forControlEvents: .TouchUpInside)
                self.babyScrollView.addSubview(musicButton)
            }
            
            let pageControlWidth = CGFloat(self.babyData.count) * 13.5
            self.babyPageControl = FilledPageControl(frame: CGRect(x: (self.view.frame.width - pageControlWidth) / 2, y: self.babyScrollView.frame.maxY - 20, width: pageControlWidth, height: 10))
            self.babyPageControl.pageCount = self.babyData.count
            self.babyPageControl.indicatorPadding = 5
            self.babyPageControl.tintColor = UIColor.hexStringToColor("#DD656F")
            self.babyPageControl.borderColor = UIColor.hexStringToColor("#DD656F")
            self.view.addSubview(self.babyPageControl)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.width
        let progressInPage = scrollView.contentOffset.x - (page * scrollView.frame.width)
        self.babyPageControl.progress = page + progressInPage
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.currentBaby = Int(scrollView.contentOffset.x / scrollView.frame.width)
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
    
    func reloadEquipments() -> Void {
        self.initialize()
    }
 
    func addNewDevice() -> Void {
        self.initialize()
        
    }
    
    func deleteDevice() -> Void {
        self.initialize()
    }
    
    
    func babyPlayClick(btn:UIButton) -> Void {
        
    }
    
    func babyMusicClick(btn:UIButton) -> Void {
        let music = PlayMusicViewController()
        self.navigationController?.pushViewController(music, animated: true)
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
