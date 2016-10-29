//
//  DiaryDetailViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/1.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class DiaryDetailViewController: BaseViewController {

    private var diaryDetailView:DiaryDetailView!
    var model:Diary!
    var baseInfo:BabyBaseInfo!
    var isConfirm:Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, isImage: false, title: model.createDate, leftSel: nil, rightSel: self.isConfirm == true ? #selector(DiaryRecordViewController.comfireClick) : nil, rightTitle: self.isConfirm == true ? "OK" : "")
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
    
//    private func initializeData(){
//        
//    }
    
    private func initializeSubviews(){
        self.diaryDetailView = DiaryDetailView.init(frame: CGRectMake(viewOriginX, navigationBarHeight + viewOriginY, CGRectGetWidth(self.view.frame) - 2 * upRateWidth(10), CGRectGetHeight(self.view.frame) - 2 * viewOriginY - navigationBarHeight), model: self.model, baseInfo: self.baseInfo)
        self.view.addSubview(self.diaryDetailView)
    }
    
    
    func comfireClick() -> Void {
        let pregDiary = PregDiaryViewController()
        self.navigationController?.pushViewController(pregDiary, animated: true)
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
