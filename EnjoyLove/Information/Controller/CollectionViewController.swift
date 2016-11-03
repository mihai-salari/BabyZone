//
//  CollectionViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 2016/11/3.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class CollectionViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    private var collectionData:[ArticleList]!
    private var pageIndex = 1
    private var pageSize = 5
    private lazy var collectionTable:UITableView =  {
        let table = UITableView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: ScreenWidth - 2 * viewOriginX, height: ScreenHeight - navigationBarHeight))
        table.delegate = self
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorInset = UIEdgeInsetsZero
        table.layoutMargins = UIEdgeInsetsZero
        return table
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "收藏", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionTable.triggerPullToRefresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionData = []
        
        self.view.addSubview(self.collectionTable)
        
        self.collectionTable.addPullToRefreshWithActionHandler {
            self.pageSize += 1
            self.pageIndex = self.pageSize / 30 == 0 ? 1 : self.pageSize / 30
            ArticleList.sendAsyncArticleListOrCollectionList("\(self.pageSize)", pageIndex: "\(self.pageIndex)", newsType: "", year: "", month: "", languageSign: "", isCollection: true, completionHandler: { [weak self](errorCode, msg) in
                if let weakSelf = self{
                    if let err = errorCode{
                        if err == BabyZoneConfig.shared.passCode{
                            weakSelf.collectionData.removeAll()
                            weakSelf.collectionData.appendContentsOf(ArticleListBL.findAll())
                            weakSelf.collectionTable.reloadData()
                            weakSelf.collectionTable.pullToRefreshView.stopAnimating()
                            if weakSelf.collectionData.count == 0{
                                HUD.showText("暂无数据", onView: weakSelf.view)
                            }
                        }
                    }
                }
                })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.collectionData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "collectionTableViewCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            let model = self.collectionData[indexPath.row]
            if model.images.count > 0 , let imageUrl = NSURL.init(string: model.images[0]) {
                resultCell.imageView?.setImageWithURL(imageUrl)
            }
            resultCell.textLabel?.text = model.title
            resultCell.detailTextLabel?.text = model.content
            return resultCell
        }
        
        return UITableViewCell.init()
    }
    
    private func triggerTableView() -> Void{
        
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
