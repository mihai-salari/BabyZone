//
//  PlayMusicViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/26.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let musicTableViewCellId = "musicTableViewCellId"
class PlayMusicViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate{
    
    private var musicData:[PlayMusic]!
    private var musicTable:UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(title: "音乐播放", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        self.musicData = []
        var noiseData:[PlayDetail] = []
        var babyMusicData:[PlayDetail] = []
        
        var nosie = PlayDetail(mainItem: "子宫声音", subItem: "")
        noiseData.append(nosie)
        nosie = PlayDetail(mainItem: "洗衣机滚筒", subItem: "")
        noiseData.append(nosie)
        
        var musicModel = PlayMusic(title: "白噪声(催眠安抚)", detail: noiseData)
        self.musicData.append(musicModel)
        
        var babyMusic = PlayDetail(mainItem: "Holiday(achordion)", subItem: "")
        babyMusicData.append(babyMusic)
        babyMusic = PlayDetail(mainItem: "heart", subItem: "")
        babyMusicData.append(babyMusic)
        
        musicModel = PlayMusic(title: "宝宝音乐", detail: babyMusicData)
        self.musicData.append(musicModel)
        
        self.musicTable = UITableView.init(frame: CGRect(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), style: .Grouped)
        self.musicTable.separatorInset = UIEdgeInsetsZero
        self.musicTable.layoutMargins = UIEdgeInsetsZero
        self.musicTable.delegate = self
        self.musicTable.dataSource = self
        self.musicTable.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.001))
        self.musicTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: musicTableViewCellId)
        self.view.addSubview(self.musicTable)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.musicData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.musicData[section].detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(musicTableViewCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.textLabel?.text = self.musicData[indexPath.section].detail[indexPath.row].mainItem
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        headerView.backgroundColor = UIColor.hexStringToColor("#5f545a")
        let titleLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: headerView.frame.width - 20, height: headerView.frame.height))
        titleLabel.font = UIFont.systemFontOfSize(13)
        titleLabel.text = self.musicData[section].title
        titleLabel.textColor = UIColor.whiteColor()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
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
