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
    var baseInfo:BabyBaseInfo!
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let today =  "\(NSDate.today().year)." + "\(NSDate.today().month)." + "\(NSDate.today().day) " + week("\(NSDate.today().weekday)")
        self.navigationBarItem(self, isImage: false, title: today, leftSel: nil, rightSel: #selector(DiaryRecordViewController.comfireClick), rightTitle: "OK")
        if DiaryBL.findAll().count == 0 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            self.tabBarController?.tabBar.hidden = false
        }else{
            self.tabBarController?.tabBar.hidden = true
        }
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
                detailConfirm.baseInfo = self.baseInfo
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
