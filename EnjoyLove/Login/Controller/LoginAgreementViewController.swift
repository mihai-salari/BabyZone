//
//  LoginAgreementViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/17.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class LoginAgreementViewController: BaseViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, isImage: true, title: "享爱软件许可及服务协议", leftSel: #selector(LoginAgreementViewController.controllerDismissClick), leftImage: "arrow_left.png", leftItemSize: CGSize(width: 10, height: 15),rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let webView = UIWebView.init(frame: CGRectMake(viewOriginX, navigationBarHeight, CGRectGetWidth(self.view.frame) - 2 * viewOriginX, ScreenHeight - navigationBarHeight - 2 * viewOriginY))
        webView.layer.cornerRadius = 2
        webView.layer.masksToBounds = true
        self.view.addSubview(webView)
        
        let path = NSBundle.mainBundle().pathForResource("BabyZone", ofType: "html")
        do{
            if let webPath = path {
                let htmlString = try String.init(contentsOfFile: webPath, encoding: NSUTF8StringEncoding)
                webView.loadHTMLString(htmlString, baseURL: NSURL.init(string: webPath))
            }
        }catch{
            print("error")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func controllerDismissClick() -> Void {
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
