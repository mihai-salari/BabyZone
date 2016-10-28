//
//  ProblemView.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/13.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let ProblemTableViewStartIndex = 100
class ProblemView: UIView ,UITableViewDataSource,UITableViewDelegate {

    private var problemHandler:((model:Problem, indexPath:NSIndexPath)->())?
    private var problemBar:HMSegment!
    private var problemScrollView:UIScrollView!
    private var problemArray:[ProblemAge]!
    private var selectedIndex:Int!
    
    init(frame: CGRect, modelArray:[ProblemAge], completionHandler:((model:Problem, indexPath:NSIndexPath)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        self.problemArray = modelArray
        self.selectedIndex = 0
        self.initializeSubviews()
        self.problemHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func initializeSubviews(){
        var items:[String] = []
        for model in self.problemArray {
            items.append(model.ageRange)
        }
        self.problemBar = HMSegment.init(frame: CGRectMake(0, 0, self.frame.width, upRateHeight(40)), items: items, completionHandler: nil)
        self.problemBar.normalTitleColor = UIColor.whiteColor()
        self.problemBar.selectedTitleColor = UIColor.hexStringToColor("#d77276")
        self.problemBar.indicatorColor = UIColor.whiteColor()
        self.problemBar.selectedSegmentIndex = 1
 //       self.problemBar.backgroundColor = UIColor.hexStringToColor("#d77276")
        self.addSubview(self.problemBar)
        
        
        self.problemScrollView = UIScrollView.init(frame: CGRectMake(10, self.problemBar.bottom + 10, self.frame.width - 2 * 10, self.frame.height - self.problemBar.frame.height - 2 * 10))
        self.problemScrollView.contentSize = CGSizeMake(self.problemScrollView.frame.width * CGFloat(self.problemArray.count), self.problemScrollView.frame.height)
        self.problemScrollView.directionalLockEnabled = true
        self.problemScrollView.showsHorizontalScrollIndicator = false
        self.problemScrollView.pagingEnabled = true
        self.problemScrollView.delegate = self
        self.addSubview(self.problemScrollView)
        
        
        for i in 0 ..< self.problemArray.count {
            let tableView = UITableView.init(frame: CGRectMake(CGFloat(i) * self.problemScrollView.frame.width, 0, self.problemScrollView.frame.width, self.problemScrollView.frame.height), style: .Plain)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tag = i + ProblemTableViewStartIndex
            tableView.separatorInset = UIEdgeInsetsZero
            tableView.layoutMargins = UIEdgeInsetsZero
            self.problemScrollView.addSubview(tableView)
        }
        
        self.problemBar.fetchSegmentIndex { [weak self](index) in
            if let weakSelf = self{
                if weakSelf.selectedIndex == index{
                    return
                }
                
                if let scrollView = weakSelf.problemScrollView{
                    scrollView.contentOffset.x = CGFloat(index) * scrollView.frame.width
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.problemArray[tableView.tag - ProblemTableViewStartIndex].problemList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "problemCellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId) as? ProblemCell
        if cell == nil {
            cell = ProblemCell.init(style: .Default, reuseIdentifier: cellId)
        }
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            let model = self.problemArray[tableView.tag - ProblemTableViewStartIndex].problemList[indexPath.row]
            resultCell.refreshCell(model, hasCount: true)
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.problemArray[tableView.tag - ProblemTableViewStartIndex].problemList[indexPath.row]
        if let handle = self.problemHandler {
            handle(model: model, indexPath: indexPath)
        }
    }
 
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        if let segment = self.problemBar {
            self.selectedIndex = page
            segment.selectedSegmentIndex = page
        }
    }
    
}

class ProblemCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:Problem,hasCount:Bool = false) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 20, height: self.contentView.frame.height)
        let itemLabel = UILabel.init(frame: CGRectMake(10, 0, self.contentView.width * (3 / 4), self.contentView.height))
        itemLabel.text = model.mainItem
        itemLabel.textColor = UIColor.hexStringToColor("#5d4957")
        itemLabel.font = UIFont.systemFontOfSize(upRateWidth(15))
        itemLabel.adjustsFontSizeToFitWidth = true
        self.contentView.addSubview(itemLabel)
        
        if hasCount == true {
            let countLabelHeight = self.contentView.frame.height * (1 / 3)
            let countLabelSize = model.itemCount.size(UIFont.systemFontOfSize(20))
            let countLabel = UILabel.init(frame: CGRectMake(self.contentView.frame.width * (4 / 5), (self.contentView.height - countLabelHeight) / 2, countLabelSize.width, countLabelHeight))
            countLabel.backgroundColor = UIColor.hexStringToColor("#d2cdd1")
            countLabel.textColor = UIColor.whiteColor()
            countLabel.textAlignment = .Center
            countLabel.text = model.itemCount
            countLabel.adjustsFontSizeToFitWidth = true
            countLabel.font = UIFont.systemFontOfSize(upRateWidth(10))
            countLabel.layer.cornerRadius = countLabelHeight / 2
            countLabel.layer.masksToBounds = true
            self.contentView.addSubview(countLabel)
            
        }
    }
}

