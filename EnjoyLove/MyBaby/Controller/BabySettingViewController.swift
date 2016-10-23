//
//  BabySettingViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/27.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

let settingTableRowHeight:CGFloat = upRateHeight(40)
private let settingTableCellId = "settingTableCellId"

class BabySettingViewController: BaseViewController {
    
    private var settingView:BabySettingView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "设置", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.settingView = BabySettingView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), selectionHandler: { [weak self](indexPath, data) in
            if let weakSelf = self{
                if indexPath.section == 1 {
                    switch indexPath.row {
                    case data.count - 1:
                        let handleChildAccount = HandleChildAccountViewController()
                        handleChildAccount.settingRefreshHandler = {
                            weakSelf.settingView.refreshData()
                        }
                        handleChildAccount.settingDeleteHandler = {
                            weakSelf.settingView.refreshData()
                        }
                        weakSelf.navigationController?.pushViewController(handleChildAccount, animated: true)
                    default:
                        let accountDetail = ChildDetailViewController()
                        accountDetail.childAccount = data[indexPath.row]
                        accountDetail.reloadHandler = { (isDelete)in
                            weakSelf.settingView.refreshData()
                        }
                        weakSelf.navigationController?.pushViewController(accountDetail, animated: true)
                    }
                }
            }
        })
        self.view.addSubview(self.settingView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
