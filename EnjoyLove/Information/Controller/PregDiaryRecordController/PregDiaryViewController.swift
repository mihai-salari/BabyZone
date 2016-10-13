//
//  PregDairyViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/8/30.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
private let pregdiaryTableViewCellId = "pregdiaryTableViewCellId"

class PregDiaryViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    private var diaryTable:UITableView!
    private var diaryData:[PregDiary]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(true, title: "育婴日记", leftSel: #selector(PregDiaryViewController.menuClick), leftImage: "baby_menu.png", leftItemSize: CGSize(width: 20, height: 15), rightSel: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Add, target: self, action: #selector(PregDiaryViewController.createDiaryClick))
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initializeData()
        self.initializeSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeData(){
        self.diaryData = []
        for _ in 0 ..< 5 {
            let model = PregDiary()
            model.date1 = "2016.6.08 THU"
            model.date2 = "宝宝第46周+5天"
            model.image = "yunfumama.png"
            model.imageEdge = "45"
            model.face = "record_face.png"
            model.desc = "每天早上第一件事就是不想起床，一刷牙就吐。那时候刚好公司隔壁搬来一间新公司。老公刚毕业，费电弄得我们转折了好几个城市，只能待在学校那个城市。"
            model.weight = "第36周+28天"
            model.tips = ["胎动","乳涨","腹胀","失眠","便秘","背痛"]
            self.diaryData.append(model)
        }
    }

    private func initializeSubviews(){
        
        let diaryNavView = DiaryListHeaderView.init(frame: CGRectMake(0, navigationBarHeight, CGRectGetWidth(self.view.frame), upRateHeight(40))) { (month, year,day) in
            print("year \(year) month \(month), day \(day)")
        }
        self.view.addSubview(diaryNavView)
        
        
        self.diaryTable = UITableView.init(frame: CGRectMake(viewOriginX, CGRectGetMaxY(diaryNavView.frame) + viewOriginY, pregDiaryViewWidth, ScreenHeight - 3 * viewOriginY - tabBarHeight - CGRectGetHeight(diaryNavView.frame)), style: .Plain)
        self.diaryTable.delegate = self
        self.diaryTable.dataSource = self
        self.diaryTable.showsVerticalScrollIndicator = false
        self.diaryTable.registerClass(DiaryListCell.self, forCellReuseIdentifier: pregdiaryTableViewCellId)
        self.diaryTable.separatorStyle = .None
        self.view.addSubview(self.diaryTable)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.diaryData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pregdiaryTableViewCellId) as? DiaryListCell
        cell?.selectionStyle = .None
        cell?.refreshCell(self.diaryData[indexPath.row])
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return pregDiaryRowHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.diaryData[indexPath.row]
        let diaryVC = DiaryDetailViewController()
        diaryVC.model = model
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    
    func createDiaryClick() -> Void {
        let diaryRecord = DiaryRecordViewController()
        self.navigationController?.pushViewController(diaryRecord, animated: true)
        
    }
    
    func menuClick() -> Void {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
