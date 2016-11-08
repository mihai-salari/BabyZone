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
    private var devices:[Equipments]!
    
    private var babyScrollView:UIScrollView!
    private var babyPageControl:FilledPageControl!
    private var temperatureLabel:UILabel!
    private var humidityLabel:UILabel!
    private var remindLabel:UILabel!
    private var currentBaby:Int = 0{
        didSet{
            if self.devices.count > 0 {
                let model = self.devices[self.currentBaby]
                if let label = self.temperatureLabel {
                    label.text = model.temperature
                }
                if let label = self.humidityLabel {
                    label.text = model.humidity
                }
                if let label = self.remindLabel {
                    label.text = model.remind
                }
            }
        }
    }
    
    private var testLabel:UILabel!
    let availableLanguages = Localize.availableLanguages()
    
    private var animationButton:LoadingButton!
    
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
        
        let floorView = UIImageView.init(frame: CGRect.init(x: 0, y: navigationBarHeight, width: ScreenWidth, height: 10))
        floorView.image = UIImage.imageWithName("floorLayer.png")
        self.view.addSubview(floorView)
        
        self.babyScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: floorView.frame.maxY, width: ScreenWidth, height: ScreenHeight - navAndTabHeight - 10))
        self.babyScrollView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.babyScrollView.showsHorizontalScrollIndicator = false
        self.babyScrollView.pagingEnabled = true
        self.babyScrollView.delegate = self
        self.babyScrollView.backgroundColor = UIColor.blackColor()
        self.view.addSubview(self.babyScrollView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: (self.babyScrollView.frame.height - 15) / 2, width: self.babyScrollView.frame.width, height: 80))
        label.text = "正在加载..."
        label.numberOfLines = 0
        label.textColor = UIColor.hexStringToColor("#DD656F")
        label.textAlignment = .Center
        self.babyScrollView.addSubview(label)
        
        Equipments.sendAsyncEqutementList { [weak self](errorCode, msg) in
            if let weakSelf = self{
                label.removeFromSuperview()
                if let err = errorCode{
                    if err == BabyZoneConfig.shared.passCode{
                        weakSelf.devices = []
                        weakSelf.devices.removeAll()
                        let eqms = EquipmentsBL.findAll()
                        if eqms.count > 0 {
                            weakSelf.devices.appendContentsOf(eqms)
                            weakSelf.babyScrollView.contentSize = CGSize.init(width: weakSelf.babyScrollView.frame.width * CGFloat.init(eqms.count), height: weakSelf.babyScrollView.frame.height)
                            for i in 0 ..< weakSelf.devices.count {
                                let babyImageView  = UIImageView.init(frame: CGRect(x: CGFloat(i) * weakSelf.babyScrollView.frame.width, y: 0, width: weakSelf.babyScrollView.frame.width, height: weakSelf.babyScrollView.frame.height))
                                babyImageView.userInteractionEnabled = true
                                if let fileImage = UIImage.init(contentsOfFile: Utils.getHeaderFilePathWithId(weakSelf.devices[i].eqmDid)) {
                                    if let cgImg = fileImage.CGImage {
                                        babyImageView.image = UIImage.init(CGImage: cgImg, scale: 1, orientation: UIImageOrientation.Right)
                                    }
                                }
                                let backgroundImage = EquipmentsBL.getHeadVideoImage(weakSelf.devices[i].eqmDid)
                                if let cgImg = backgroundImage.CGImage {
                                    babyImageView.image = UIImage.init(CGImage: cgImg, scale: 1, orientation: UIImageOrientation.Right)
                                }
                                
                                babyImageView.tag = babyBackgroundImageViewTag + i
                                weakSelf.babyScrollView.addSubview(babyImageView)
                            }
                            
                            weakSelf.temperatureLabel = UILabel.init(frame: CGRect(x: 0, y: weakSelf.babyScrollView.frame.maxY - 60, width: weakSelf.babyScrollView.frame.width * (1 / 3), height: 15))
                            weakSelf.temperatureLabel.text = weakSelf.devices[0].temperature
                            weakSelf.temperatureLabel.textAlignment = .Center
                            weakSelf.temperatureLabel.textColor = UIColor.hexStringToColor("#DD656F")
                            weakSelf.temperatureLabel.font = UIFont.boldSystemFontOfSize(10)
                            weakSelf.view.addSubview(weakSelf.temperatureLabel)
                            
                            let tempDescLabel = UILabel.init(frame: CGRect(x: weakSelf.temperatureLabel.frame.minX, y: weakSelf.temperatureLabel.frame.maxY, width: weakSelf.temperatureLabel.frame.width, height: weakSelf.temperatureLabel.frame.height))
                            tempDescLabel.text = "温度(°)"
                            tempDescLabel.textAlignment = .Center
                            tempDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
                            tempDescLabel.font = UIFont.boldSystemFontOfSize(10)
                            weakSelf.view.addSubview(tempDescLabel)
                            
                            weakSelf.humidityLabel = UILabel.init(frame: CGRect(x: weakSelf.temperatureLabel.frame.maxX, y: weakSelf.temperatureLabel.frame.minY, width: weakSelf.temperatureLabel.frame.width, height: weakSelf.temperatureLabel.frame.height))
                            weakSelf.humidityLabel.text = weakSelf.devices[0].humidity
                            weakSelf.humidityLabel.textAlignment = .Center
                            weakSelf.humidityLabel.textColor = UIColor.hexStringToColor("#DD656F")
                            weakSelf.humidityLabel.font = UIFont.boldSystemFontOfSize(10)
                            weakSelf.view.addSubview(weakSelf.humidityLabel)
                            
                            let humidityDescLabel = UILabel.init(frame: CGRect(x: weakSelf.humidityLabel.frame.minX, y: weakSelf.humidityLabel.frame.maxY, width: weakSelf.temperatureLabel.frame.width, height: weakSelf.temperatureLabel.frame.height))
                            humidityDescLabel.text = "湿度(%)"
                            humidityDescLabel.textAlignment = .Center
                            humidityDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
                            humidityDescLabel.font = UIFont.boldSystemFontOfSize(10)
                            weakSelf.view.addSubview(humidityDescLabel)
                            
                            weakSelf.remindLabel = UILabel.init(frame: CGRect(x: weakSelf.humidityLabel.frame.maxX, y: weakSelf.temperatureLabel.frame.minY, width: weakSelf.temperatureLabel.frame.width, height: weakSelf.temperatureLabel.frame.height))
                            weakSelf.remindLabel.text = weakSelf.devices[0].remind
                            weakSelf.remindLabel.textAlignment = .Center
                            weakSelf.remindLabel.textColor = UIColor.hexStringToColor("#DD656F")
                            weakSelf.remindLabel.font = UIFont.boldSystemFontOfSize(10)
                            weakSelf.view.addSubview(weakSelf.remindLabel)
                            
                            let remindDescLabel = UILabel.init(frame: CGRect(x: weakSelf.remindLabel.frame.minX, y: weakSelf.temperatureLabel.frame.maxY, width: weakSelf.temperatureLabel.frame.width, height: weakSelf.temperatureLabel.frame.height))
                            remindDescLabel.text = "异常"
                            remindDescLabel.textAlignment = .Center
                            remindDescLabel.textColor = UIColor.hexStringToColor("#DD656F")
                            remindDescLabel.font = UIFont.boldSystemFontOfSize(10)
                            weakSelf.view.addSubview(remindDescLabel)
                            
                            let musicButtonWidth:CGFloat = 50
                            let musicButton = UIButton.init(type: .Custom)
                            musicButton.frame = CGRect(x: (ScreenWidth - musicButtonWidth - 15), y: navigationBarHeight + 15 + 10, width: musicButtonWidth, height: musicButtonWidth)
                            musicButton.setImage(UIImage.imageWithName("music_play.png"), forState: .Normal)
                            musicButton.setImage(UIImage.imageWithName("music_stop.png"), forState: .Selected)
                            musicButton.addTarget(self, action: #selector(weakSelf.babyMusicClick(_:)), forControlEvents: .TouchUpInside)
                            weakSelf.view.addSubview(musicButton)
                            
                            let babyButton = BabyButton(type: .Custom)
                            babyButton.frame = CGRect.init(x: (weakSelf.view.frame.width - (weakSelf.view.frame.width * (1 / 6))) / 2, y: (weakSelf.view.frame.height - (weakSelf.view.frame.width * (1 / 6))) / 2, width: (weakSelf.view.frame.width * (1 / 6)), height: (weakSelf.view.frame.width * (1 / 6)))
                            babyButton.setImageSize(CGSize(width: weakSelf.view.frame.width * (1 / 6),height: ScreenWidth * (1 / 6)), normaImage: "babyPlay.png", title: "观看视频", fontSize: 12)
                            babyButton.addCustomTarget(self, sel: #selector(weakSelf.babyPlayClick(_:)))
                            weakSelf.view.addSubview(babyButton)
                            
                            let pageControlWidth = CGFloat(weakSelf.devices.count) * 13.5
                            weakSelf.babyPageControl = FilledPageControl(frame: CGRect(x: (weakSelf.view.frame.width - pageControlWidth) / 2, y: weakSelf.babyScrollView.frame.maxY - 20, width: pageControlWidth, height: 10))
                            weakSelf.babyPageControl.pageCount = weakSelf.devices.count
                            weakSelf.babyPageControl.indicatorPadding = 5
                            weakSelf.babyPageControl.tintColor = UIColor.hexStringToColor("#DD656F")
                            weakSelf.babyPageControl.borderColor = UIColor.hexStringToColor("#DD656F")
                            weakSelf.view.addSubview(weakSelf.babyPageControl)

                            
                        }else{
                            let label = UILabel.init(frame: CGRect.init(x: 0, y: (weakSelf.babyScrollView.frame.height - 15) / 2, width: weakSelf.babyScrollView.frame.width, height: 80))
                            label.text = "暂无设备，\n请到我的->设备设置->添加设备"
                            label.numberOfLines = 0
                            label.textColor = UIColor.hexStringToColor("#DD656F")
                            label.textAlignment = .Center
                            weakSelf.babyScrollView.addSubview(label)
                        }
                    }else{
                        let label = UILabel.init(frame: CGRect.init(x: 0, y: (weakSelf.babyScrollView.frame.height - 15) / 2, width: weakSelf.babyScrollView.frame.width, height: 80))
                        label.text = "出错啦:\(msg!)"
                        label.numberOfLines = 0
                        label.textColor = UIColor.hexStringToColor("#DD656F")
                        label.textAlignment = .Center
                        weakSelf.babyScrollView.addSubview(label)
                    }
                }else{
                    let label = UILabel.init(frame: CGRect.init(x: 0, y: (weakSelf.babyScrollView.frame.height - 15) / 2, width: weakSelf.babyScrollView.frame.width, height: 80))
                    label.text = "网络出错了:\(msg!)"
                    label.numberOfLines = 0
                    label.textColor = UIColor.hexStringToColor("#DD656F")
                    label.textAlignment = .Center
                    weakSelf.babyScrollView.addSubview(label)
                }
            }
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
    
    
    func babyPlayClick(btn:UIButton) -> Void {
        let device = self.devices[self.currentBaby]
        if device.eqmOnOff == false {
            HUD.showText("请到我的->设备设置->连接设备", onView: self.view)
            return
        }
        let monitor = P2PMonitorController()
        monitor.deviceContact = EquipmentsBL.contactFromEquipment(device)
        monitor.monitorRefreshHandler = { (image) in
            EquipmentsBL.saveHeadVideoImage(image, eqmDid: device.eqmDid)
        }
        self.navigationController?.pushViewController(monitor, animated: true)
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
