//
//  ImagePickerView.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/11.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
import Photos

private let photoImageStartTag = 100
private let photoButtonStartTag = 150
private let imagePickerCollectionCellId = "imagePickerCollectionCellId"
class ImagePickerView: UIView,DXPhotoPickerControllerDelegate ,UICollectionViewDataSource, UICollectionViewDelegate{

    private var imageHandler:((imageArray:[PHAsset])->())?
    private var collectionView:UICollectionView!
    private var addButton:UIButton!
    private var selectedNumber:Int = 0
    private let selectMaxNumber:Int = 5
    private var itemViewWidth:CGFloat!
    private var duplicateRemove:Bool!
    
    private var imageArray:[PHAsset]!{
        didSet{
            self.selectedNumber = self.imageArray.count
            if self.selectedNumber > 4{
                self.addButton.hidden = true
            }else{
                self.addButton.hidden = false
            }
        }
    }
    
    
    
    init(frame: CGRect, duplicateRemove:Bool = false,completionHandler:((imageArray:[PHAsset])->())?) {
        super.init(frame: frame)
        self.imageArray = []
        self.itemViewWidth = CGRectGetWidth(self.frame) / 7
        self.duplicateRemove = duplicateRemove
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(CGRectGetHeight(frame), CGRectGetHeight(frame))
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0
        
        self.collectionView = UICollectionView.init(frame: CGRectZero, collectionViewLayout: layout)
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: imagePickerCollectionCellId)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.scrollEnabled = false
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.addSubview(self.collectionView)
        
        
        
        self.addButton = UIButton.init(type: .Custom)
        self.addButton.frame = CGRectMake(0, (CGRectGetHeight(self.frame) - self.itemViewWidth) / 2, self.itemViewWidth, self.itemViewWidth)
        self.addButton.setImage(UIImage.imageWithName("image_add.png"), forState: .Normal)
        self.addButton.addTarget(self, action: #selector(ImagePickerView.addImageClick), forControlEvents: .TouchUpInside)
        self.addSubview(self.addButton)

        
        self.imageHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(imagePickerCollectionCellId, forIndexPath: indexPath)
        self.refreshCell(cell, indexPath: indexPath)
        return cell
    }
    
    func refreshCell(cell:UICollectionViewCell, indexPath:NSIndexPath) -> Void {
        let photo = self.imageArray[indexPath.item]
        DXPickerHelper.hm_fetchImageWithAsset(photo, targetSize: CGSizeMake(200, 200), needHighQuality: true) { [weak self](image, info) in
            if let weakSelf = self{
                if let showImage = image{
                    let imageView = UIImageView.init(frame: CGRectMake((CGRectGetWidth(cell.contentView.frame) - weakSelf.itemViewWidth) / 2, (CGRectGetWidth(cell.contentView.frame) - weakSelf.itemViewWidth) / 2, weakSelf.itemViewWidth, weakSelf.itemViewWidth))
                    imageView.tag = photoImageStartTag + indexPath.item
                    imageView.image = showImage
                    cell.contentView.addSubview(imageView)
                    
                    let deleteButton = DeleteButton.init(type: .Custom)
                    let buttonWidth = CGRectGetWidth(imageView.frame) * (2 / 3)
                    deleteButton.setImageRect(CGSizeMake(CGRectGetWidth(imageView.frame) / 4, CGRectGetWidth(imageView.frame) / 4), normaImage: "delete.png")
                    deleteButton.frame = CGRectMake(CGRectGetMaxX(imageView.frame) - buttonWidth / 2, CGRectGetMinY(imageView.frame) - buttonWidth / 2, buttonWidth, buttonWidth)
                    deleteButton.addCustomTarget(weakSelf, sel: #selector(ImagePickerView.deleteImage(_:)))
                    deleteButton.tag = photoButtonStartTag + indexPath.item
                    cell.contentView.addSubview(deleteButton)
                }

            }
        }
    }
    
    func addImageClick() -> Void {
        
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let photoLibAction = UIAlertAction.init(title: "从手机相册选择", style: .Default) { (action:UIAlertAction) in
            let picker = DXPhotoPickerController()
            DXPhotoPickerController.DXPhotoPickerConfig.maxSeletedNumber = (self.selectMaxNumber - self.selectedNumber)
            picker.photoPickerDelegate = self
            HMTablBarController.presentViewController(picker, animated: true, completion: nil)
        }
        if photoLibAction.valueForKey("titleTextColor") == nil{
            photoLibAction.setValue(alertTextColor, forKey: "titleTextColor")
        }
        actionSheet.addAction(photoLibAction)
        
        let cameraAction = UIAlertAction.init(title: "拍照", style: .Default) { (action:UIAlertAction) in
            let camera = CameraViewController(croppingEnabled: false, completion: { [weak self](image:UIImage?, asset:PHAsset?) in
                if let weakSelf = self{
                    HMTablBarController.dismissViewControllerAnimated(true, completion: { 
                        if let photo = asset{
                            weakSelf.imageArray.append(photo)
                            weakSelf.reloadCollectionView()
                        }
                    })
                }
            })
            HMTablBarController.presentViewController(camera, animated: true, completion: nil)
            
        }
        if cameraAction.valueForKey("titleTextColor") == nil{
            cameraAction.setValue(alertTextColor, forKey: "titleTextColor")
        }
        actionSheet.addAction(cameraAction)
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (action:UIAlertAction) in
            
        })
        if cancelAction.valueForKey("titleTextColor") == nil{
            cancelAction.setValue(UIColor.darkGrayColor(), forKey: "titleTextColor")
        }
        actionSheet.addAction(cancelAction)
        
        HMAppDelegate.rootTabBarController.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func deleteImage(btn:UIButton) -> Void {
        let item = btn.tag - photoButtonStartTag
        let photo = self.imageArray[item]
        if let indexPhoto = self.imageArray.indexOf(photo) {
            self.imageArray.removeAtIndex(indexPhoto)
            self.reloadCollectionView()
        }
    }
    
   
    
    
    // MARK: DXPhototPickerControllerDelegate
    
    func photoPickerDidCancel(photoPicker: DXPhotoPickerController) {
        photoPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func photoPickerController(photoPicker: DXPhotoPickerController?, sendImages: [PHAsset]?, isFullImage: Bool) {
        photoPicker?.dismissViewControllerAnimated(true, completion: {
            
            if let images = sendImages {
                
                for photo in images{
                    self.imageArray.append(photo)
                }
                
                if self.duplicateRemove == true{
                    self.imageArray = NSMutableArray.init(array: self.imageArray).orderDuplicateRemove() as! [PHAsset]
                }
                self.reloadCollectionView()
            }
        })
        
    }
    
    private func reloadCollectionView(){
        
        if let handle = self.imageHandler{
            handle(imageArray: self.imageArray)
        }
        
        self.collectionView.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame) * CGFloat(self.imageArray.count), CGRectGetHeight(self.frame))
        self.addButton.frame = CGRectMake(CGRectGetMaxX(self.collectionView.frame) + upRateWidth(5), (CGRectGetHeight(self.frame) - self.itemViewWidth) / 2, self.itemViewWidth, self.itemViewWidth)
        self.collectionView.reloadData()
    }

}
