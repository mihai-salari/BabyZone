//
//  AddChildAccountViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/6.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class AddChildAccountViewController: BaseViewController {

    
    var addResultRefreshHandler:(()->())?
    
    private var addAccountData:[AddChildAccount]!
    private var addAccountTable:UITableView!
    private var tableRowHeight:CGFloat = 0
    
    private var addAccountView:AddChildAccountView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        //#selector(self.addConfirmClick)
        self.navigationBarItem(self, isImage: false, title: "添加子账号", leftSel: nil, rightSel: #selector(self.addConfirmClick), rightTitle: "添加")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addAccountView = AddChildAccountView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), selectHandler: { [weak self](indexPath, model) in
            if let weakSelf = self{
                let permission = ChildPermissionViewController()
                permission.equipment = model
                permission.indexPath = indexPath
                permission.changeResultHandler = { [weak self] (indexPath, result1, result2) in
                    if let weakSelf = self{
                        if indexPath.section == 0{
                            if let result = result1{
                                weakSelf.addAccountView.refreshCell(indexPath, result1: result, result2: "")
                            }
                        }else if indexPath.section == 1{
                            if let rst1 = result1, let rst2 = result2{
                                weakSelf.addAccountView.refreshCell(indexPath, result1: rst1, result2: rst2)
                            }
                        }
                    }
                }
                weakSelf.navigationController?.pushViewController(permission, animated: true)
            }
            })
        self.view.addSubview(self.addAccountView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if let handle = self.addResultRefreshHandler{
            handle()
        }
    }
    
    func addConfirmClick() -> Void {
        if let add = self.addAccountView {
            add.fetchData({ [weak self] in
                if let weakSelf = self{
                    if let handle = weakSelf.addResultRefreshHandler{
                        handle()
                    }
                    weakSelf.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(weakSelf.confirmBack))
                }
            })
        }
    }
    
    func confirmBack() -> Void {
        self.navigationController?.popViewControllerAnimated(true)
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
