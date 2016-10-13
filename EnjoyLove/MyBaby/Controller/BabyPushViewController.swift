//
//  BabyPushViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/28.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyPushViewController: BaseViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.self.navigationBarItem(title: "您有新的邀请", leftSel: nil, rightSel: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.dismissNotification(_:)), name: BabyCancelClickNotification, object: nil)
        
        let pushView = BabyPushView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: ScreenWidth - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight), verifyHandler: { [weak self] in
            if let weakSelf = self{
                let babyCheck = BabyCheckViewController()
                weakSelf.navigationController?.pushViewController(babyCheck, animated: true)
            }
            }) { [weak self] in
                if let weakSelf = self{
                    weakSelf.dismissViewControllerAnimated(true, completion: nil)
                }
        }
        self.view.addSubview(pushView)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissNotification(notification:NSNotification) -> Void {
        self.dismissViewControllerAnimated(true, completion: nil)
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
