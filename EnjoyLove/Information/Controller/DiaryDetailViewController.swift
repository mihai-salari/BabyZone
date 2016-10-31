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
        self.diaryDetailView = DiaryDetailView.init(frame: CGRectMake(viewOriginX, navigationBarHeight + viewOriginY, CGRectGetWidth(self.view.frame) - 2 * upRateWidth(10), CGRectGetHeight(self.view.frame) - 2 * viewOriginY - navigationBarHeight), model: self.model)
        self.view.addSubview(self.diaryDetailView)
    }
    
    
    func comfireClick() -> Void {
        HUD.showHud("正在提交...", onView: self.view)
        QiNiu.uploadImages("", images: self.model.imageArr, progress: { (progress) in
            print("progress \(progress)")
            }, successHandler: { (urls, fileNames) in
                print("urls \(urls) and file names \(fileNames)")
            }) { (error) in
                print("upload error \(error)")
        }
        /*
        Diary.sendAsyncAddUserNote(self.model.moodStatus, noteLabel: self.model.noteLabels.joinWithSeparator(","), content: self.model.content, imgUrls: self.model.imgUrls) { [weak self](errorCode, msg) in
            if let weakSelf = self{
                HUD.hideHud(weakSelf.view)
                if let err = errorCode{
                    if err == BabyZoneConfig.shared.passCode{
                        let pregDiary = PregDiaryViewController()
                        weakSelf.navigationController?.pushViewController(pregDiary, animated: true)
                    }
                }
            }
        }
 */
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
