//
//  InfoManagerViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 2016/10/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class InfoManagerViewController: BaseViewController {
    
    private var pregInfoVC:PregInfoViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        dispatch_queue_create("babyListQueue", nil).queue {
            var idUserBabyInfo = ""
            let babyList = BabyListBL.findAll()
            if babyList.count > 0{
                idUserBabyInfo = babyList[0].idUserBabyInfo
            }
            BabyBaseInfo.sendAsyncBabyBaseInfo(idUserBabyInfo, completionHandler: { [weak self](errorCode, msg, baseInfo) in
                if let weakSelf = self{
                    weakSelf.pregInfoVC = PregInfoViewController()
                    if let base  = baseInfo{
                        weakSelf.pregInfoVC.babyInfo = base
                        Article.sendAsyncRecomment(base.infoType, completionHandler: { (errorCode, msg, info) in
                            if let recoment = info{
                                weakSelf.pregInfoVC.recoment = recoment
                            }
                            dispatch_get_main_queue().queue({
                                weakSelf.navigationController?.pushViewController(weakSelf.pregInfoVC, animated: false)
                            })
                        })

                    }
                }
            })
        }
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
