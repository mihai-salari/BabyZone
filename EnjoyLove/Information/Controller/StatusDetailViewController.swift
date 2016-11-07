//
//  StatusDetailViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/8.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class StatusDetailViewController: BaseViewController {

    private var detailScrollView:UIScrollView!
    var detailModel:Article!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationBarItem(self, title: "详情", leftSel:nil, rightSel: nil)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        
        self.detailScrollView = UIScrollView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - 60 - navigationBarHeight))
        self.detailScrollView.contentSize = CGSize.init(width: self.detailScrollView.frame.width, height: self.detailModel == nil ? ScreenWidth : self.detailModel.totalImageHeight)
        self.detailScrollView.backgroundColor = UIColor.whiteColor()
        self.detailScrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(self.detailScrollView)
        
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.detailScrollView.frame.width, height: 50))
        titleLabel.text = self.detailModel == nil ? "" : self.detailModel.title
        titleLabel.font = UIFont.systemFontOfSize(15)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.hexStringToColor("#DF5F76")
        self.detailScrollView.addSubview(titleLabel)
        
        let line = UIView.init(frame: CGRect.init(x: 0, y: titleLabel.frame.maxY, width: self.detailScrollView.frame.width, height: 1))
        line.backgroundColor = UIColor.hexStringToColor("#DF5F76")
        self.detailScrollView.addSubview(line)
        
        if let model = self.detailModel {
            for i in 0 ..< model.images.count {
                let imageView = UIImageView.init(frame: CGRect.init(x: 15, y: 60 + CGFloat(i) * (model.imageHeight * (2 / 3) + 5), width: self.detailScrollView.frame.width - 2 * 15, height: model.imageHeight * (2 / 3)))
                if let imageUrl = NSURL.init(string: model.images[i]) {
                    imageView.setImageWithURL(imageUrl)
                }
                self.detailScrollView.addSubview(imageView)
            }
            
            let contentView = UITextView.init(frame: CGRect.init(x: 15, y: line.frame.maxY + model.totalImageHeight * (2 / 3) * CGFloat(model.images.count) + 15, width: self.detailScrollView.frame.width - 2 * 15, height: model.contentHeight))
            contentView.text = model.content
            contentView.textColor = UIColor.lightGrayColor()
            contentView.font = UIFont.systemFontOfSize(14)
            contentView.userInteractionEnabled = false
            self.detailScrollView.addSubview(contentView)
        }
        
        
        
        let moreButton = MoreArctileButton(type: .Custom)
        moreButton.frame = CGRect.init(x: viewOriginX, y: ScreenHeight - upRateHeight(50), width: self.detailScrollView.frame.width, height: 40)
        moreButton.setImageRect(CGSizeMake(10, 15), normaImage: "arrow_right.png", normalTitle: "查看更多文章", fontSize: upRateWidth(16))
        moreButton.backgroundColor = UIColor.hexStringToColor("#f6a495")
        self.view.addSubview(moreButton)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
