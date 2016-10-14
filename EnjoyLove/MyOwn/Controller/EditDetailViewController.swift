//
//  EidtDetailViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/17.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit
import Photos
/*
 Edit type
 0:头像
 1:名字
 2:个性签名
 3:性别
 4:地区
 5:孕育状态
 6:宝宝
 7:添加宝宝
 */

protocol PersonInfoEditDelegate{
    func fetchPersonInfo(editModel:PersonEidtDetail)
}

class EditDetailViewController: BaseViewController,DXPhotoPickerControllerDelegate, BabyEditDelegate,DatePickerDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var editModel:PersonEidtDetail!
    var editDelegate:PersonInfoEditDelegate!
    private var headerEditView:EditHeaderView!
    private var babyEditView:EditBabyView!
    private var babyIndexPath:NSIndexPath!
    private var babyInfo:BabyInfo!
    private var babyBrithdayPicker:PickerControllView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        switch self.editModel.eidtType {
        case 0:
            self.navigationBarItem(false, title: "头像", leftSel: nil, rightSel: #selector(EditDetailViewController.exchangeHeader), rightTitle: "更换", rightItemSize: CGSize(width: 30, height: 40))
            self.headerEditView = EditHeaderView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: ScreenHeight - navigationBarHeight), image: self.editModel.subItem)
            self.view.addSubview(self.headerEditView)
        case 1:
            self.navigationBarItem(false, title: "名字", leftSel: nil, rightSel: nil)
            let editNameView = EditNameView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: ScreenHeight - navigationBarHeight - 10), completionHandler: { [weak self](txt) in
                if let weakSelf = self{
                    if let delegate = weakSelf.editDelegate{
                        weakSelf.editModel.subItem = txt
                        delegate.fetchPersonInfo(weakSelf.editModel)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }
            })
            self.view.addSubview(editNameView)
        case 2:
            self.navigationBarItem(false, title: "个性签名", leftSel: nil, rightSel: nil)
            let editSignView = EditSignView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), completionHandler: {[weak self] (txt) in
                if let weakSelf = self{
                    if let delegate = weakSelf.editDelegate{
                        weakSelf.editModel.subItem = txt
                        delegate.fetchPersonInfo(weakSelf.editModel)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }
            })
            self.view.addSubview(editSignView)
        case 3:
            self.navigationBarItem(false, title: "性别", leftSel: nil, rightSel: nil)
            let editSexView = EditSexView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), isMale: false, completionHandler: { [weak self](sex, sexId) in
                if let weakSelf = self{
                    if let delegate = weakSelf.editDelegate{
                        weakSelf.editModel.subItem = sex
                        delegate.fetchPersonInfo(weakSelf.editModel)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }
                })
            self.view.addSubview(editSexView)
        case 4:
            self.navigationBarItem(false, title: "地区", leftSel: nil, rightSel: nil)
        case 5:
            self.navigationBarItem(false, title: "孕育状态", leftSel: nil, rightSel: nil)
            let editStatusView = EditPregStatusView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), hasBaby: true, completionHandler: {[weak self] (status, statusId) in
                if let weakSelf = self{
                    if let delegate = weakSelf.editDelegate{
                        weakSelf.editModel.subItem = status
                        delegate.fetchPersonInfo(weakSelf.editModel)
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }
            })
            self.view.addSubview(editStatusView)
        case 6:
            self.navigationBarItem(false, title: self.editModel.mainTitle, leftSel: nil, rightSel: nil)
            var babyData:[BabyInfo] = []
            var baby:BabyInfo = BabyInfo(mainItem: "姓名", subItem: "宝宝1", infoType: 0)
            babyData.append(baby)
            baby = BabyInfo(mainItem: "性别", subItem: "女", infoType: 1)
            babyData.append(baby)
            baby = BabyInfo(mainItem: "年龄", subItem: "1998.07.12", infoType: 2)
            babyData.append(baby)
            self.babyEditView = EditBabyView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), baby: babyData, completionHandler: { [weak self] (baby, indexPath) in
                if let weakSelf = self{
                    weakSelf.babyInfo = baby
                    weakSelf.babyIndexPath = indexPath
                    if indexPath.row != 2{
                        let editBabyInfo = BabyInfoEditViewController()
                        editBabyInfo.babyModel = baby
                        editBabyInfo.editDelegate = self
                        weakSelf.navigationController?.pushViewController(editBabyInfo, animated: true)
                    }else{
                        weakSelf.setupDatePicker()
                    }
                }
            })
            self.view.addSubview(self.babyEditView)
        case 7:
            self.navigationBarItem(false, title: "添加宝宝", leftSel: nil, rightSel: nil)
            var babyData:[BabyInfo] = []
            var baby:BabyInfo = BabyInfo(mainItem: "姓名", subItem: "请输入姓名", infoType: 0)
            babyData.append(baby)
            baby = BabyInfo(mainItem: "性别", subItem: "请选择性别", infoType: 1)
            babyData.append(baby)
            baby = BabyInfo(mainItem: "年龄", subItem: "请选择年龄", infoType: 2)
            babyData.append(baby)
            self.babyEditView = EditBabyView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), baby: babyData, completionHandler: { [weak self] (baby, indexPath) in
                if let weakSelf = self{
                    weakSelf.babyIndexPath = indexPath
                    weakSelf.babyInfo = baby
                    if indexPath.row != 2{
                        let editBabyInfo = BabyInfoEditViewController()
                        editBabyInfo.babyModel = baby
                        editBabyInfo.editDelegate = self
                        weakSelf.navigationController?.pushViewController(editBabyInfo, animated: true)
                    }else{
                        weakSelf.setupDatePicker()
                    }
                }
                })
            self.view.addSubview(self.babyEditView)
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func exchangeHeader() -> Void {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let photoLibAction = UIAlertAction.init(title: "从手机相册选择", style: .Default) { [weak self](action:UIAlertAction) in
            if let weakSelf = self{
                weakSelf.photoWithSourceType(.PhotoLibrary)
            }
        }
        if photoLibAction.valueForKey("titleTextColor") == nil{
            photoLibAction.setValue(alertTextColor, forKey: "titleTextColor")
        }
        actionSheet.addAction(photoLibAction)
        
        let cameraAction = UIAlertAction.init(title: "拍照", style: .Default) { [weak self](action:UIAlertAction) in
            if let weakSelf = self{
                weakSelf.photoWithSourceType(.Camera)
            }
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
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }

    func fetchBabyInfo(baby: BabyInfo) {
        if let babyView = self.babyEditView {
            babyView.reloadTableViewCell(self.babyIndexPath, baby: baby)
        }
    }
    
    private func photoWithSourceType(type:UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = type
        imagePicker.modalTransitionStyle = .CrossDissolve;
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage], let headerView = self.headerEditView {
            
            headerView.refreshImageView(image as! UIImage)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupDatePicker() -> Void {
        if let pickerView = NSBundle.mainBundle().loadNibNamed("PickerControllView", owner: self, options: nil)?.last {
            self.babyBrithdayPicker = pickerView as! PickerControllView
            self.babyBrithdayPicker.pickerDelegate = self
            self.view.addSubview(self.babyBrithdayPicker)
        }
    }
    
    func datePickerRemove() {
        self.babyBrithdayPicker.removeFromSuperview()
    }
    
    func datePickerReturn(dateString: String!) {
        let dates = dateString.componentsSeparatedByString("-")
        self.babyInfo.subItem = dates.joinWithSeparator(".")
        if let babyView = self.babyEditView {
            babyView.reloadTableViewCell(self.babyIndexPath, baby: self.babyInfo)
        }
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
