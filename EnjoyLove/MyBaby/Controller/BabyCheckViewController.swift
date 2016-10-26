//
//  BabyCheckViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyCheckViewController: BaseViewController {

    private var babyCheckView:LookBabyVerifyView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self, title: "安全验证", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.babyCheckView = LookBabyVerifyView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight), completionHandler: { [weak self] in
            if let weakSelf = self{

            }
        })
        self.view.addSubview(self.babyCheckView)
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
    
    func popNotification(notification:NSNotification) -> Void {
        self.navigationController?.popViewControllerAnimated(false)
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
