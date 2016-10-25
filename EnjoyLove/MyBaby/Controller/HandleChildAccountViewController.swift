//
//  HandleChildAccountViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/5.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
class HandleChildAccountViewController: BaseViewController {
    
    private var handleView:HandleChildAccountView!
    var settingRefreshHandler:(()->())?
    var settingDeleteHandler:(()->())?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "添加/删除 子账号", leftSel: nil, rightSel: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Done, target: nil, action: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.handleView = HandleChildAccountView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), addNewHandler: {  [weak self] in
            if let weakSelf = self{
                let addNew = AddChildAccountViewController()
                addNew.addResultRefreshHandler = { [weak self] in
                    if let weakSelf = self{
                        weakSelf.handleView.refreshHandleAccountCell()
                        if let handle = weakSelf.settingRefreshHandler{
                            handle()
                        }
                    }
                }
                weakSelf.navigationController?.pushViewController(addNew, animated: true)
            }
            }, deleteRefreshHandler: { [weak self] in
                if let weakSelf = self{
                    if let handle = weakSelf.settingDeleteHandler {
                        handle()
                    }
                }
        })
        
        self.view.addSubview(self.handleView)
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
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
