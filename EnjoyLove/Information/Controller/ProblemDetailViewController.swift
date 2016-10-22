//
//  ProblemDetailViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/19.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class ProblemDetailViewController: BaseViewController {

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, title: "详情", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        let webView = UIWebView.init(frame: CGRectMake(viewOriginX, navigationBarHeight + viewOriginY, CGRectGetWidth(self.view.frame) - 2 * viewOriginX, ScreenHeight - navigationBarHeight - 2 * viewOriginY))
        webView.layer.cornerRadius = 2
        webView.layer.masksToBounds = true
        self.view.addSubview(webView)
        
        let path = NSBundle.mainBundle().pathForResource("ProblemDetail", ofType: "html")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
