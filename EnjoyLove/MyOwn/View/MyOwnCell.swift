//
//  MyOwnCell.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/8/25.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let editButtionWidth:CGFloat = 40
private let leftPadding:CGFloat = 20
private let leftMargin:CGFloat = 10
private let topPadding:CGFloat = upRateWidth(8)
private let textWidth:CGFloat = 120
private let mainItemWidth:CGFloat = upRateWidth(100)
private let subItemWidth:CGFloat = upRateWidth(200)
private let editButtonWidth:CGFloat = upRateWidth(35)

class MyOwnCell: UITableViewCell {

    var headClickHandler:((index:Int, model:MyOwnDetail)->())?
    
    private var headerDescribeLabel:UILabel!
    private var headerButton:UIImageView!
    private var headerNickNameLabel:UILabel!
    private var headerDescLabel:UILabel!
    private var currentModel:MyOwnDetail!
    
    var myAccessoryView:UIImageView?{
        get{
            let imageView = UIImageView.init(frame: CGRectMake(0, 0, 8, 10))
            imageView.image = UIImage.imageWithName("myOwnArrow.png")
            return imageView
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func refreshCell(model:MyOwnDetail, indexPath:NSIndexPath) -> Void {
        self.currentModel = model
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        switch indexPath.section {
        case 0:
            self.contentView.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth - 2 * viewOriginX, height: (ScreenHeight - navAndTabHeight - 2 * 20) * (1 / 9) * 3)
            var person:PersonDetail!
            if let detail = PersonDetailBL.find() {
                person = detail
            }
            self.headerButton = UIImageView.init(frame: CGRectMake(leftPadding, self.contentView.frame.height / 2 - self.contentView.frame.height * (1 / 2.5), self.contentView.frame.height * (1 / 2.5), self.contentView.frame.height * (1 / 2.5)))
            self.headerButton.layer.cornerRadius = self.contentView.frame.height * (1 / 2.5) / 2
            self.headerButton.layer.masksToBounds = true
            if person.headImg == "" {
                self.headerButton.image = UIImage.imageWithName("defaultHeader.png")
            }else{
                if let imageUrl = NSURL.init(string: person.headImg) {
                    self.headerButton.image = UIImage.imageWithName("defaultHeader.png")
                    self.headerButton.setImageWithURL(imageUrl)
                }
            }
            
            self.contentView.addSubview(self.headerButton)
            
            self.headerNickNameLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(self.headerButton.frame) + leftMargin, CGRectGetMidY(self.headerButton.frame) - 15, CGRectGetWidth(textRect(model.nickName, fontSize: 16, size: CGSize(width: textWidth, height: 10))), CGRectGetHeight(self.headerButton.frame) / 2))
            self.headerNickNameLabel.text = person.nickName == "" ? model.nickName : person.nickName
            self.headerNickNameLabel.font = UIFont.boldSystemFontOfSize(15)
            self.contentView.addSubview(self.headerNickNameLabel)
            
            self.headerDescLabel = UILabel.init(frame: CGRect(x: self.headerNickNameLabel.frame.minX, y: self.headerButton.frame.midY, width: textRect(person.userSign == "" ? model.desc : person.userSign, fontSize: 13, size: CGSize(width: textWidth, height: self.headerNickNameLabel.frame.height)).size.width, height: self.headerNickNameLabel.frame.height))
            self.headerDescLabel.font = UIFont.systemFontOfSize(12)
            self.headerDescLabel.text = person.userSign == "" ? model.desc : person.userSign
            self.headerDescLabel.textColor = UIColor.lightGrayColor()
            self.contentView.addSubview(self.headerDescLabel)
            
            let editDescLabel = UILabel.init(frame: CGRect.init(x: self.contentView.frame.width - 2.5 * editButtonWidth, y: self.headerDescLabel.frame.minY, width: 2 * editButtonWidth, height: self.headerDescLabel.height))
            editDescLabel.font = UIFont.systemFontOfSize(8)
            editDescLabel.text = "编辑宝宝/个人信息"
            editDescLabel.textAlignment = .Right
            editDescLabel.textColor = UIColor.lightGrayColor()
            self.contentView.addSubview(editDescLabel)
            
            
            let editButton = HMButton.init(frame: CGRectMake(self.contentView.frame.width - 1.2 * editButtonWidth, self.headerNickNameLabel.frame.maxY - editButtionWidth, editButtionWidth, editButtionWidth))
            editButton.tag = 50
            editButton.setImage(UIImage.imageWithName("myOwnEdit.png"), forState: .Normal)
            editButton.addTarget(self, action: #selector(self.headButtonClick(_:)), forControlEvents: .TouchUpInside)
            self.contentView.addSubview(editButton)
            
            
            let postView = self.numberAndItem(CGRectMake(0, CGRectGetHeight(self.contentView.frame) / 2.5, CGRectGetWidth(self.contentView.frame) / 4, CGRectGetHeight(self.contentView.frame) / 3), num: MyHeadGroup.postNum(), item: "帖子", sel: #selector(self.headButtonClick(_:)), buttonTag: 10)
            self.addSubview(postView)
            
            let careView = self.numberAndItem(CGRectMake(CGRectGetMaxX(postView.frame), CGRectGetMinY(postView.frame), CGRectGetWidth(postView.frame), CGRectGetHeight(postView.frame)), num: MyHeadGroup.careNum(), item: "关注", sel: #selector(self.headButtonClick(_:)), buttonTag: 20)
            self.contentView.addSubview(careView)
            
            let fansView = self.numberAndItem(CGRectMake(CGRectGetMaxX(careView.frame), CGRectGetMinY(postView.frame), CGRectGetWidth(postView.frame), CGRectGetHeight(postView.frame)), num: MyHeadGroup.fansNum(), item: "粉丝", sel: #selector(self.headButtonClick(_:)), buttonTag: 30)
            self.contentView.addSubview(fansView)
            
            let collectionView = self.numberAndItem(CGRectMake(CGRectGetMaxX(fansView.frame), CGRectGetMinY(postView.frame), CGRectGetWidth(postView.frame), CGRectGetHeight(postView.frame)), num: MyHeadGroup.bbsCollNum(), item: "收藏", sel: #selector(self.headButtonClick(_:)), buttonTag: 40)
            self.contentView.addSubview(collectionView)
            
            let tailSeparatorLine = UIView.init(frame: CGRectMake(0, CGRectGetHeight(self.contentView.frame) - 0.5, CGRectGetWidth(self.contentView.frame), 0.5))
            tailSeparatorLine.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview(tailSeparatorLine)

        default:
            self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 20, height: self.contentView.frame.height)
            let mainItemLabel = UILabel.init(frame: CGRectMake(leftPadding, 0, mainItemWidth, CGRectGetHeight(self.contentView.frame) - 0.3))
            mainItemLabel.text = model.mainItem
            mainItemLabel.font = UIFont.boldSystemFontOfSize(14)
            self.contentView.addSubview(mainItemLabel)
            
            let subItemLabel = UILabel.init(frame: CGRectMake(self.contentView.frame.width * (1 / 3), 0, self.contentView.frame.width * (2 / 3) - 30 , CGRectGetHeight(self.contentView.frame)))
            subItemLabel.text = model.subItem
            subItemLabel.font = UIFont.systemFontOfSize(10)
            subItemLabel.textColor = UIColor.lightGrayColor()
            subItemLabel.textAlignment = .Right
            self.contentView.addSubview(subItemLabel)
        }
    }
    
    private func numberAndItem(frame:CGRect, num:String = "1213", item:String = "帖子", sel:Selector, buttonTag:Int) -> UIView{
        let containerView = UIView(frame: frame)
        
        let numLabel = UILabel(frame: CGRect(x: 0, y: 2 * topPadding, width: CGRectGetWidth(containerView.frame), height: frame.height / 2))
        numLabel.adjustsFontSizeToFitWidth = true
        numLabel.text = num
        numLabel.textAlignment = .Center
        numLabel.font = UIFont.systemFontOfSize(upRateWidth(16))
        containerView.addSubview(numLabel)
        
        let itemLabel = UILabel(frame: CGRect(x: 0, y: CGRectGetMaxY(numLabel.frame) + 5, width: CGRectGetWidth(numLabel.frame), height: CGRectGetHeight(numLabel.frame)))
        itemLabel.textAlignment = .Center
        itemLabel.adjustsFontSizeToFitWidth = true
        itemLabel.font = UIFont.systemFontOfSize(12)
        itemLabel.textColor = UIColor.lightGrayColor()
        itemLabel.text = item
        containerView.addSubview(itemLabel)
        
        let button = UIButton.init(type: .Custom)
        button.frame = containerView.bounds
        button.tag = buttonTag
        button.addTarget(self, action: sel, forControlEvents: UIControlEvents.TouchUpInside)
        containerView.addSubview(button)
        
        return containerView
    }

    
    func refreshSubviewsForEdit(model:MyOwnHeader){
        self.headerButton.image = UIImage.imageWithName(model.header)
        self.headerNickNameLabel.text = model.nickName
        self.headerDescLabel.frame = CGRectMake(CGRectGetMinX(self.headerNickNameLabel.frame), CGRectGetMaxY(self.headerNickNameLabel.frame), CGRectGetWidth(textRect(model.desc, fontSize: 14, size: CGSizeMake(textWidth, CGRectGetHeight(self.headerNickNameLabel.frame)))), CGRectGetHeight(self.headerNickNameLabel.frame))
        self.headerDescLabel.text = model.desc
        
    }
    
    func headButtonClick(btn:UIButton) -> Void {
        if let handle = self.headClickHandler {
            handle(index: btn.tag, model: self.currentModel)
        }
    }
    
}

class PersonInfoCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:PersonEidtDetail) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(x: self.contentView.frame.minX, y: self.contentView.frame.minY, width: ScreenWidth - 20, height: 50)
        let mainLabel = UILabel.init(frame: CGRect(x: 20, y: 0, width: self.contentView.frame.width / 2 - 20, height: self.contentView.frame.height))
        mainLabel.text = model.mainTitle
        mainLabel.font = UIFont.boldSystemFontOfSize(14)
        mainLabel.textColor = UIColor.hexStringToColor("#60555b")
        self.contentView.addSubview(mainLabel)
        
        let imageViewWidth = self.contentView.frame.height * (2 / 3)
        if model.isHeader == true{
            let imageView = UIImageView.init(frame: CGRect(x: self.contentView.frame.width - 2 * imageViewWidth, y: (self.contentView.frame.height - imageViewWidth) / 2, width: imageViewWidth, height: imageViewWidth))
            if model.subItem == "" {
                imageView.image = UIImage.imageWithName("defaultHeader.png")
            }else{
                if let imageUrl = NSURL.init(string: model.subItem) {
                    imageView.image = UIImage.imageWithName("defaultHeader.png")
                    imageView.setImageWithURL(imageUrl)
                }
            }
            imageView.layer.cornerRadius = imageViewWidth / 2
            imageView.layer.masksToBounds = true
            self.contentView.addSubview(imageView)
        }else{
            let subLabel = UILabel.init(frame: CGRect(x: self.contentView.frame.width / 2, y: 0, width: self.contentView.frame.width / 2 - 30, height: 50))
            subLabel.textColor = UIColor.lightGrayColor()
            subLabel.text = model.subItem
            subLabel.font = UIFont.systemFontOfSize(10)
            subLabel.textAlignment = .Right
            self.contentView.addSubview(subLabel)
        }
    }
}
