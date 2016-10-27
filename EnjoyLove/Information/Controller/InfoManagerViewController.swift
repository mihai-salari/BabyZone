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
        dispatch_queue_create("babyListQueue", nil).queue {
            BabyList.sendAsyncBabyList({ [weak self](errorCode, msg) in
                dispatch_get_main_queue().queue({
                    if let weakSelf = self, let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            if BabyListBL.findAll().count > 0 {
                                weakSelf.pregInfoVC = PregInfoViewController()
                                weakSelf.navigationController?.pushViewController(weakSelf.pregInfoVC, animated: false)
                            }else{
                                
                            }
                        }
                    }
                })
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
