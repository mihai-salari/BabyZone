//
//  DiaryRecordView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/1.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let emotionImageViewWidth = upRateWidth(50)
private let emotionImageViewTag = 100
private let emotionLabelTag     = 200
private let statusImageViewTag = 300
private let statusLabelTag = 400
private let statusViewWidth = upRateWidth(80)
private let statusViewHeight = upRateWidth(30)
private let statusImageViewWdith = upRateWidth(15)
private let sectionInsetsDicrection = upRateWidth(8)
private let emotionCollectionViewCellId = "emotionCollectionViewCellId"
private let statusCollectionViewCellId = "statusCollectionViewCellId"
class DiaryRecordView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    private var emotionCollection:UICollectionView!
    private var statusCollection:UICollectionView!
    private var weightLabel:UILabel!
    private var textView:UITextView!
    private var keyboard:Keyboard!
    private var resultDiary:Diary!
    
    private var recordModel:DiaryRecord!
    private var images:[String]!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit{
        self.emotionCollection = nil
        self.statusCollection = nil
        self.weightLabel = nil
        self.textView = nil
        self.keyboard = nil
        self.recordModel = nil
        self.keyboard = nil
    }
    
    func fetchDiary() -> Diary? {
        self.endEditing(true)
        
        if self.resultDiary.moodStatus == nil || self.resultDiary.moodStatus == "" {
            HUD.showText("请选择心情状态", onView: self)
            return nil
        }
        
        self.resultDiary.content = self.textView.text
        let today =  "\(NSDate.today().year)." + "\(NSDate.today().month)." + "\(NSDate.today().day) " + "\(NSDate.today().weekday)".week()
        self.resultDiary.createDate = today
        if let result = self.resultDiary {
            return result
        }
        return nil
    }
    
    private func initialize() -> Void{
        self.resultDiary = Diary()
        let emotions = ["非常愉快", "愉快", "一般", "不开心", "好难过"]
        let emotionIds = ["1", "2", "3", "4", "5"]
        let emotionNormalImages = ["normal_face_1.png", "normal_face_2.png", "normal_face_3.png", "normal_face_4.png", "normal_face_5.png"]
        let emotionHighlightImages = ["selected_face_1.png", "selected_face_2.png", "selected_face_3.png", "selected_face_4.png", "selected_face_5.png"]
        
        
        var grownStatus:[String] = []
        let noteLabels = NoteLabelBL.findAll()
        if noteLabels.count > 0 {
            for note in noteLabels {
                grownStatus.append(note.labelName)
            }
        }else{
            grownStatus.appendContentsOf(["会眨眼啦", "会眨眼了", "会叫妈妈", "能握拳了", "经常微笑", "学会走路"])
        }
        
        let grownStatusId = ["1", "1", "1", "1", "1"]
        let grownStatusNormalImages = "uncheck.png"
        let grownStatusHighligheImages = "check.png"
        
        self.recordModel = DiaryRecord(emotion: emotions, emotionId: emotionIds, emotionNormalImages: emotionNormalImages, emotionHighlightImages: emotionHighlightImages, grownStatus: grownStatus, grownStatusId: grownStatusId, grownStatusNormalImages: grownStatusNormalImages, grownStatusHighligheImages: grownStatusHighligheImages)
        
        let emotionLabelHeight = CGRectGetHeight(self.frame) * (6 / 11) * (1 / 2) * (1 / 5)
        let emotionCollectionViewHeight = CGRectGetHeight(self.frame) * (6 / 11) * (1 / 2) * (4 / 5)
        let textViewHeight = CGRectGetHeight(self.frame) * (6 / 11) * (1 / 2)
        let cornerImageViewWidth:CGFloat = 20
        
        
        let emotionLabel = UILabel.init(frame: CGRectMake(0, 0, CGRectGetWidth(self.frame), emotionLabelHeight))
        emotionLabel.text = "心情如何?"
        emotionLabel.textAlignment = .Center
        emotionLabel.textColor = UIColor.whiteColor()
        emotionLabel.font = UIFont.systemFontOfSize(upRateWidth(16))
        self.addSubview(emotionLabel)
        
        let emotionLayout = UICollectionViewFlowLayout()
        emotionLayout.itemSize = CGSizeMake(CGRectGetWidth(self.frame) / 5, emotionCollectionViewHeight)
        emotionLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        emotionLayout.minimumInteritemSpacing = 0
        self.emotionCollection = UICollectionView.init(frame: CGRectMake(0, CGRectGetMaxY(emotionLabel.frame), CGRectGetWidth(self.frame), emotionCollectionViewHeight), collectionViewLayout: emotionLayout)
        self.emotionCollection.backgroundColor = UIColor.clearColor()
        self.emotionCollection.scrollEnabled = false
        self.emotionCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: emotionCollectionViewCellId)
        self.emotionCollection.delegate = self
        self.emotionCollection.dataSource = self
        self.addSubview(self.emotionCollection)
        
        self.textView = UITextView.init(frame: CGRectMake(10, CGRectGetMaxY(self.emotionCollection.frame), CGRectGetWidth(self.frame) - 20, textViewHeight))
        let toolbar = HMToolbar.init(frame: CGRectMake(0, 0, ScreenWidth, 30)) {[weak self] in
            if let weakSelf = self{
                weakSelf.endEditing(true)
            }
        }
        self.textView.inputAccessoryView = toolbar
        self.addSubview(self.textView)
        
        self.keyboard = Keyboard.init(targetView: self.textView, container: self, hasNav: true, show: nil, hide: nil)
        
        let cornerImageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(textView.frame) - cornerImageViewWidth, CGRectGetHeight(textView.frame) - cornerImageViewWidth, cornerImageViewWidth, cornerImageViewWidth))
        cornerImageView.image = UIImage.imageWithSize(CGSizeMake(cornerImageViewWidth, cornerImageViewWidth), fillColor: UIColor.colorFromRGB(197, g: 107, b: 93, a: 1.0)!, alphaColor: UIColor.colorFromRGB(197, g: 107, b: 93, a: 0.1)!)
        self.textView.addSubview(cornerImageView)
        
        
        let imagePicker = ImagePickerView.init(frame: CGRectMake(10, CGRectGetHeight(self.frame) * (6 / 11) + 10, CGRectGetWidth(self.frame) - 20, CGRectGetWidth(self.frame) / 6)) { [weak self](imageArray) in
            if let weakSelf = self{
                weakSelf.images = []
                for photo in imageArray{
                    DXPickerHelper.hm_fetchImageWithAsset(photo, targetSize: CGSizeMake(200, 200), needHighQuality: true, imageResultHandler: { (image, info) in
                        if let imageInfo = info, let img = image{
                            if let imagePath = imageInfo["PHImageFileURLKey"]{
                                let paths = "\(imagePath)".componentsSeparatedByString("/")
                                if let path = paths.last{
                                    weakSelf.images.append(path)
                                    weakSelf.resultDiary.imageArr.append(img)
                                    
                                }
                            }
                        }
                    })
                }
                if imageArray.count == 0{
                    weakSelf.images.removeAll()
                    weakSelf.resultDiary.imageArr.removeAll()
                }
            }
        }
        self.addSubview(imagePicker)
        
        
        let statusLayout = UICollectionViewFlowLayout()
        statusLayout.itemSize = CGSizeMake((CGRectGetWidth(self.frame) - 40) / 3, CGRectGetHeight(self.frame) * (1 / 12))
        statusLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        statusLayout.minimumInteritemSpacing = 0
        statusLayout.minimumLineSpacing = upRateHeight(10)
        
        self.statusCollection = UICollectionView.init(frame: CGRectMake(5, CGRectGetMaxY(imagePicker.frame) + 15, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) * (1 / 12) * 2.5), collectionViewLayout: statusLayout)
        self.statusCollection.backgroundColor = UIColor.clearColor()
        self.statusCollection.allowsMultipleSelection = true
        self.statusCollection.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: statusCollectionViewCellId)
        self.statusCollection.delegate = self
        self.statusCollection.dataSource = self
        self.addSubview(self.statusCollection)
        
    }
    
    

    //MARK:___DELETEATE_AND_DATA_SOURCE__
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView == self.emotionCollection {
            return 1
        }else if collectionView == self.statusCollection{
            return 1
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.emotionCollection {
            return self.recordModel.emotion.count
        }else if collectionView == self.statusCollection{
            return self.recordModel.grownStatus.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell?
        if collectionView == self.emotionCollection {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(emotionCollectionViewCellId, forIndexPath: indexPath)
            for subview in cell!.contentView.subviews {
                subview.removeFromSuperview()
            }
            self.refreshCell(collectionView, cell: cell!, indexPath: indexPath)
        }else if collectionView == self.statusCollection{
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusCollectionViewCellId, forIndexPath: indexPath)
            for subview in cell!.contentView.subviews {
                subview.removeFromSuperview()
            }
            cell?.contentView.backgroundColor = UIColor.hexStringToColor("#df7781")
            self.refreshCell(collectionView, cell: cell!, indexPath: indexPath)
        }
        
        return cell!
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        if collectionView == self.emotionCollection {
            self.handleEmotionCellSelect(collectionView, indexPath: indexPath, selected: false)
        }else if collectionView == self.statusCollection{
            self.handleStatusCellSelect(collectionView, indexPath: indexPath, selected: false)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == self.emotionCollection {
            self.handleEmotionCellSelect(collectionView, indexPath: indexPath, selected: true)
        }else if collectionView == self.statusCollection{
            self.handleStatusCellSelect(collectionView, indexPath: indexPath, selected: true)
        }
    }
    
    
    //MARK:__PRIVATE_METHOD__
    
    private func refreshCell(view: UICollectionView, cell:UICollectionViewCell, indexPath:NSIndexPath){
        if view == self.emotionCollection {
            let normalImage = self.recordModel.emotionNormalImages[indexPath.item]
            let imageViewWidth = CGRectGetWidth(cell.contentView.frame) * (4 / 5)
            let emotionImageView = UIImageView.init(frame: CGRectMake((CGRectGetWidth(cell.contentView.frame) - imageViewWidth) / 2, (CGRectGetHeight(cell.contentView.frame) - imageViewWidth * (3 / 2)) / 2, imageViewWidth, imageViewWidth))
            emotionImageView.layer.cornerRadius = imageViewWidth / 2
            emotionImageView.layer.masksToBounds = true
            emotionImageView.image = UIImage.imageWithName(normalImage)
            emotionImageView.tag = emotionImageViewTag + indexPath.item
            cell.contentView.addSubview(emotionImageView)
            
            let item = self.recordModel.emotion[indexPath.item]
            let emotionLabel = UILabel.init(frame: CGRectMake(0, CGRectGetMaxY(emotionImageView.frame), CGRectGetWidth(cell.contentView.frame), upRateHeight(20)))
            emotionLabel.text = item
            emotionLabel.textAlignment = .Center
            emotionLabel.tag = emotionLabelTag + indexPath.row
            emotionLabel.textColor = UIColor.whiteColor()
            emotionLabel.font = UIFont.systemFontOfSize(upRateWidth(12))
            emotionLabel.adjustsFontSizeToFitWidth = true
            cell.contentView.addSubview(emotionLabel)
            
        }else if view == self.statusCollection{
            let imageView = UIImageView.init(frame: CGRectMake(CGRectGetWidth(cell.contentView.frame) * (2 / 7) - statusImageViewWdith, (CGRectGetHeight(cell.contentView.frame) - statusImageViewWdith) / 2, statusImageViewWdith, statusImageViewWdith))
            imageView.image = UIImage.imageWithName("uncheck.png")
            imageView.tag = statusImageViewTag + indexPath.row
            cell.contentView.addSubview(imageView)
            
            let statusLabel = UILabel.init(frame: CGRectMake(CGRectGetWidth(cell.contentView.frame) * (2 / 7) + 5, CGRectGetMinY(imageView.frame), CGRectGetWidth(cell.contentView.frame) * (5 / 7), CGRectGetHeight(imageView.frame)))
            let status = self.recordModel.grownStatus[indexPath.row]
            statusLabel.text = status
            statusLabel.textColor = UIColor.whiteColor()
            statusLabel.font = UIFont.systemFontOfSize(upRateWidth(13))
            statusLabel.tag = statusLabelTag + indexPath.row
            cell.contentView.addSubview(statusLabel)
        }
    }
    
    private func handleEmotionCellSelect(collectionView:UICollectionView, indexPath:NSIndexPath, selected:Bool){
        self.endEditing(true)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if selected {
            let selectedImage = self.recordModel.emotionHighlightImages[indexPath.item]
            let imageView = cell?.contentView.viewWithTag(emotionImageViewTag + indexPath.item) as! UIImageView
            imageView.backgroundColor = UIColor.whiteColor()
            imageView.image = UIImage.imageWithName(selectedImage)
            
            let label = cell?.contentView.viewWithTag(emotionLabelTag + indexPath.item) as! UILabel
            label.font = UIFont.boldSystemFontOfSize(upRateWidth(12))
            
            self.resultDiary.moodStatus = self.recordModel.emotionId[indexPath.item]
            
        }else{
            let normalImage = self.recordModel.emotionNormalImages[indexPath.item]
            let imageView = cell?.contentView.viewWithTag(emotionImageViewTag + indexPath.item) as! UIImageView
            imageView.backgroundColor = UIColor.clearColor()
            imageView.image = UIImage.imageWithName(normalImage)
            
            let label = cell?.contentView.viewWithTag(emotionLabelTag + indexPath.item) as! UILabel
            label.font = UIFont.systemFontOfSize(upRateWidth(12))
        }
    }
    
    private func handleStatusCellSelect(collectionView:UICollectionView, indexPath:NSIndexPath, selected:Bool){
        self.endEditing(true)
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        if selected {
            cell?.contentView.backgroundColor = UIColor.hexStringToColor("#ffffff")
            let imageView = cell?.contentView.viewWithTag(statusImageViewTag + indexPath.row) as! UIImageView
            imageView.image = UIImage.imageWithName("check.png")
            let statusLabel = cell?.contentView.viewWithTag(statusLabelTag + indexPath.row) as! UILabel
            statusLabel.textColor = UIColor.darkGrayColor()
            if self.resultDiary.noteLabels.contains(self.recordModel.grownStatus[indexPath.item]) == false {
                self.resultDiary.noteLabels.append(self.recordModel.grownStatus[indexPath.item])
            }
        }else{
            cell?.contentView.backgroundColor = UIColor.hexStringToColor("#df7781")
            let imageView = cell?.contentView.viewWithTag(statusImageViewTag + indexPath.row) as! UIImageView
            imageView.image = UIImage.imageWithName("uncheck.png")
            let statusLabel = cell?.contentView.viewWithTag(statusLabelTag + indexPath.row) as! UILabel
            statusLabel.textColor = UIColor.whiteColor()
            
            if let index = self.resultDiary.noteLabels.indexOf(self.recordModel.grownStatus[indexPath.item]) {
                self.resultDiary.noteLabels.removeAtIndex(index)
            }
        }
    }
}


