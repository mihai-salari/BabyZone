//
//  BabyToolViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 2016/11/7.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyToolViewController: BaseViewController {

    private var babyToolView:BabyToolView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.babyToolView = BabyToolView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: ScreenWidth - 2 * viewOriginX, height: ScreenHeight - navAndTabHeight))
        self.view.addSubview(self.babyToolView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, title: "育婴工具", leftSel: nil, rightSel: nil)
        self.automaticallyAdjustsScrollViewInsets = false
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
