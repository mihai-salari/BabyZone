//
//  BabyToolView.swift
//  EnjoyLove
//
//  Created by 黄漫 on 2016/11/7.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let BabyToolCollectionViewCellId = "BabyToolCollectionViewCellId"
private let BabyToolHeaderViewId = "BabyToolHeaderViewId"
private let BabyToolFooterViewId = "BabyToolFooterViewId"
class BabyToolView: UIView,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    private var toolCollectionView:UICollectionView!
    private var toolData:[BabyTool]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initializeData()
        self.initializeViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initializeData() ->Void{
        self.toolData = []
        self.toolData.removeAll()
        
        var listData:[toolList] = []
        var list = toolList.init(title: "产后护理", image: "postnatal_care.png", imageWidth: 40, imageHeight: 40, index: 0)
        listData.append(list)
        
        list = toolList.init(title: "瘦身", image: "slimming.png", imageWidth: 30, imageHeight: 40, index: 1)
        listData.append(list)
        
        list = toolList.init(title: "育婴日记", image: "baby_diary.png", imageWidth: 40, imageHeight: 45, index: 2)
        listData.append(list)
        
        var babyTool = BabyTool.init(title: "针对妈妈", image: "mama.png", imageWidth: 40, imageHeight: 50, list: listData)
        self.toolData.append(babyTool)
        
        listData = []
        listData.removeAll()
        list = toolList.init(title: "疫苗时间表", image: "vaccine_schedule.png", imageWidth: 50, imageHeight: 40, index: 0)
        listData.append(list)
        
        list = toolList.init(title: "体检时间表", image: "examination_schedule.png",  imageWidth: 40, imageHeight: 50, index: 1)
        listData.append(list)
        
        list = toolList.init(title: "情绪安抚", image: "emotional.png", imageWidth: 40, imageHeight: 40, index: 2)
        listData.append(list)
        
        list = toolList.init(title: "喂养记录", image: "feeding_record.png", imageWidth: 20, imageHeight: 40, index: 3)
        listData.append(list)
        
        list = toolList.init(title: "身高体重记录", image: "hw_record.png", imageWidth: 40, imageHeight: 40, index: 4)
        listData.append(list)
        
        list = toolList.init(title: "亲子游戏", image: "game.png", imageWidth: 30, imageHeight: 40, index: 5)
        listData.append(list)
        
        
        babyTool = BabyTool.init(title: "针对宝宝", image: "baby.png", imageWidth: 50, imageHeight: 40, list: listData)
        self.toolData.append(babyTool)
    }

    private func initializeViews() ->Void{
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.frame.width / 3, height: self.frame.width / 3.5)
        flowLayout.sectionInset = UIEdgeInsetsZero
        flowLayout.minimumInteritemSpacing = 0
        
        self.toolCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height), collectionViewLayout: flowLayout)
        self.toolCollectionView.backgroundColor = UIColor.whiteColor()
        self.toolCollectionView.delegate = self
        self.toolCollectionView.dataSource = self
        self.toolCollectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: BabyToolCollectionViewCellId)
        self.toolCollectionView.registerClass(BabyToolHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: BabyToolHeaderViewId)
        self.addSubview(self.toolCollectionView)
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.toolData.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.toolData[section].list.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(BabyToolCollectionViewCellId, forIndexPath: indexPath)
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.hexStringToColor("#DD6571").CGColor
        self.initializeItemView(cell, model: self.toolData[indexPath.section].list[indexPath.item])
        
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: BabyToolHeaderViewId, forIndexPath: indexPath)
        for subview in headView.subviews {
            subview.removeFromSuperview()
        }
        let model = self.toolData[indexPath.section]
        let headImageView = UIImageView.init(frame: CGRect.init(x: (headView.frame.width - model.imageWidth) / 2, y: (headView.frame.height * (2 / 3) - model.imageHeight) / 2 - 5, width: model.imageWidth, height: model.imageHeight))
        headImageView.image = UIImage.imageWithName(model.image)
        headView.addSubview(headImageView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: headView.frame.height * (2 / 3) + 2, width: headView.frame.width, height: 15))
        label.textAlignment = .Center
        label.text = model.title
        label.textColor = UIColor.hexStringToColor("#DD6571")
        label.font = UIFont.systemFontOfSize(13)
        headView.addSubview(label)
        
        return headView
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: 60)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: 10)
    }
    
    private func initializeItemView(cell:UICollectionViewCell, model:toolList) ->Void{
        let imageView = UIImageView.init(frame: CGRect.init(x: (cell.contentView.frame.width - model.imageWidth) / 2, y: cell.contentView.frame.height * (2 / 3) - model.imageHeight - 2, width: model.imageWidth, height: model.imageHeight))
        imageView.image = UIImage.imageWithName(model.image)
        cell.contentView.addSubview(imageView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: cell.contentView.frame.height * (2 / 3) + 3, width: cell.contentView.frame.width, height: 15))
        label.text = model.title
        label.textAlignment = .Center
        label.textColor = UIColor.darkGrayColor()
        label.font = UIFont.systemFontOfSize(15)
        cell.contentView.addSubview(label)
        
    }
    
}

class BabyToolHeaderView: UICollectionReusableView {
    var title:String = ""{
        didSet{
            if let label = self.viewWithTag(2) as? UILabel {
                label.text = title
            }
        }
    }
    
    var image:String = ""{
        didSet{
            if let imageView = self.viewWithTag(1) as? UIImageView {
                imageView.image = UIImage.imageWithName(image)
            }
        }
    }
    
    var imageSize:CGSize = CGSizeZero{
        didSet{
            if let imageView = self.viewWithTag(1) as? UIImageView {
                imageView.frame = CGRect.init(x: imageView.frame.minX, y: imageView.frame.minY, width: imageSize.width, height: imageSize.height)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let headImageView = UIImageView.init(frame: CGRect.init(x: (frame.width - 55) / 2, y: (frame.height * (2 / 3) - 64) / 2, width: 55, height: 64))
        headImageView.tag = 1
        self.addSubview(headImageView)
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: headImageView.frame.maxY + 2, width: frame.width, height: 15))
        label.textAlignment = .Center
        label.tag = 2
        label.textColor = UIColor.hexStringToColor("#DD6571")
        label.font = UIFont.systemFontOfSize(13)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
