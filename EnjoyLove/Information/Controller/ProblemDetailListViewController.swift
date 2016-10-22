//
//  ProblemDetailListViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/19.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class ProblemDetailListViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    var detailListModel:Problem!
    private var detailListTable:UITableView!
    private var detailListData:[Problem]!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self,title: self.detailListModel == nil ? "问题" : self.detailListModel.mainItem, leftSel: nil, rightSel: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.initialize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func initialize(){
        self.detailListData = []
        for i in 0 ..< 9 {
            let model = Problem(mainItem: "警惕玩具带来的潜在危害\(i)", itemCount: "", itemId: "\(i)")
            self.detailListData.append(model)
        }
        
        self.detailListTable = UITableView.init(frame: CGRect(x: 10, y: navigationBarHeight + viewOriginY, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight - 20), style: .Plain)
        self.detailListTable.separatorInset = UIEdgeInsetsZero
        self.detailListTable.layoutMargins = UIEdgeInsetsZero
        self.detailListTable.dataSource = self
        self.detailListTable.delegate = self
        self.view.addSubview(self.detailListTable)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.detailListData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "ProblemListCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ProblemCell
        if cell == nil {
            cell = ProblemCell.init(style: .Default, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            let model = self.detailListData[indexPath.row]
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.refreshCell(model)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let model = self.detailListData[indexPath.row]
        let detail = ProblemDetailViewController()
        self.navigationController?.pushViewController(detail, animated: true)
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
