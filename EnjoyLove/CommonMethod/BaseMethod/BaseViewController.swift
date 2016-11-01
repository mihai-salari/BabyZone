//
//  BaseViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/10.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController,UIGestureRecognizerDelegate {

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.loginAndRegistSuccessRefresh), name: LoginAndRegisterSuccessNotification, object: nil)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        var image = UIImage.imageFromColor(UIColor.clearColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 64))
        self.navigationController?.navigationBar.setBackgroundImage(image, forBarPosition: .Any, barMetrics: .Default)
        image = UIImage.imageFromColor(UIColor.clearColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 1))
        self.navigationController?.navigationBar.shadowImage = image
        
        image = UIImage.imageFromColor(UIColor.clearColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 49))
        self.tabBarController?.tabBar.backgroundImage = image
        image = UIImage.imageFromColor(UIColor.clearColor(), size: CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 1))
        self.tabBarController?.tabBar.shadowImage = image
    
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height)
        gradientLayer.colors = [UIColor.hexStringToColor("#da5a7b").CGColor ,UIColor.hexStringToColor("#e27360").CGColor]
        gradientLayer.locations = [NSNumber.init(float: 0.1),NSNumber.init(float: 0.9)]
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        
        self.navigationController?.interactivePopGestureRecognizer?.enabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.navigationController?.viewControllers.count == 1 {
            self.navigationController?.interactivePopGestureRecognizer?.enabled = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.navigationController?.viewControllers.count == 0 {
            return false
        }
        return true
    }
    
    func loginAndRegistSuccessRefresh() -> Void {
        
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
