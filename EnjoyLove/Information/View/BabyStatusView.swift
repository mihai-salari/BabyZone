//
//  BabyStatusView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/8.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BabyStatusView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}

class BabyStatusCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:ArticleList) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame.size.height = 100
        let imageView = UIImageView.init(frame: CGRectMake(10, (CGRectGetHeight(self.contentView.frame) - CGRectGetHeight(self.contentView.frame) * (2 / 3)) / 2, CGRectGetHeight(self.contentView.frame) * (2 / 3), CGRectGetHeight(self.contentView.frame) * (2 / 3)))
        imageView.image = UIImage.imageWithName("pregnantMama.png")
        self.contentView.addSubview(imageView)
        
        let mainItemLabel = UILabel.init(frame: CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMinY(imageView.frame), upRateWidth(185), CGRectGetHeight(imageView.frame) / 3))
        mainItemLabel.text = model.title
        mainItemLabel.font = UIFont.systemFontOfSize(17)
        mainItemLabel.textColor = UIColor.hexStringToColor("#400a33")
        mainItemLabel.adjustsFontSizeToFitWidth = true
        mainItemLabel.minimumScaleFactor = 0.8
        self.contentView.addSubview(mainItemLabel)
        
        
        let contentLabel = UILabel.init(frame: CGRectMake(CGRectGetMinX(mainItemLabel.frame), CGRectGetMaxY(mainItemLabel.frame), CGRectGetWidth(mainItemLabel.frame), CGRectGetHeight(imageView.frame) * (2 / 3)))
        contentLabel.font = UIFont.systemFontOfSize(12)
        contentLabel.text = model.content
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.lightGrayColor()
        self.contentView.addSubview(contentLabel)
        
    }
    
}
