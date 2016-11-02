//
//  DiaryRecordViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/1.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class DiaryRecordViewController: BaseViewController {

    private var recordView:DiaryRecordView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let today =  "\(NSDate.today().year)-" + "\(NSDate.today().month)-" + "\(NSDate.today().day) " + "\(NSDate.today().weekday)".week()
        self.navigationBarItem(self, isImage: false, title: today, leftSel: nil, rightSel: #selector(self.comfireClick), rightTitle: "OK")
        self.tabBarController?.tabBar.hidden = true
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func initializeSubviews(){
        self.recordView = DiaryRecordView.init(frame: CGRectMake(0, navigationBarHeight, ScreenWidth, ScreenHeight - navigationBarHeight))
        self.view.addSubview(self.recordView)
    }
    
    
    func cancelClick() -> Void {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func comfireClick() -> Void {
        /*
         moodStatus
         content
         imgUrls
         imageArr
         noteLabels
         */
        if let record = self.recordView {
            if let recordData = record.fetchDiary() {
                let detailConfirm = DiaryDetailViewController()
                detailConfirm.model = recordData
                detailConfirm.isConfirm = true
                self.navigationController?.pushViewController(detailConfirm, animated: true)
            }
        }
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
