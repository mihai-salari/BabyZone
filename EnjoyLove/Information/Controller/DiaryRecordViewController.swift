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
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = true
        let today =  "\(NSDate.today().year)." + "\(NSDate.today().month)." + "\(NSDate.today().day) " + week("\(NSDate.today().weekday)")
        self.navigationBarItem(self, isImage: false, title: today, leftSel: nil, rightSel: #selector(DiaryRecordViewController.comfireClick), rightTitle: "OK")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeSubviews()
        let navBar = UINavigationBar.appearance()
        navBar.backgroundColor = UIColor.greenColor()
        
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
        let detailConfirm = DiaryDetailViewController()
        let model = PregDiary()
        model.date1 = "2016.6.08 THU"
        model.date2 = "宝宝第46周+5天"
        model.image = "yunfumama.png"
        model.imageEdge = "45"
        model.face = "record_face.png"
        model.desc = "每天早上第一件事就是不想起床，一刷牙就吐。那时候刚好公司隔壁搬来一间新公司。老公刚毕业，费电弄得我们转折了好几个城市，只能待在学校那个城市。"
        model.weight = "第36周+28天"
        model.tips = ["胎动","乳涨","腹胀","失眠","便秘","背痛"]
        detailConfirm.model = model
        self.navigationController?.pushViewController(detailConfirm, animated: true)
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
