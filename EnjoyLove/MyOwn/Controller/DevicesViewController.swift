//
//  DevicesViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/10/9.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class DevicesViewController: BaseViewController {

    private var devicesView:DevicesView!
    private var contact:Contact!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self, isImage: false, title: "选择设备", leftSel: nil, rightSel: #selector(self.confirmDevice), rightTitle: "确定")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        self.devicesView = DevicesView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight)) { [weak self](resultContact) in
            if let weakSelf = self{
                weakSelf.contact = resultContact
            }
        }
        self.view.addSubview(self.devicesView)
    }
    
    func confirmDevice() -> Void {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
