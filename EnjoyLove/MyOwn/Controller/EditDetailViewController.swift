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
    func reloadBabySection()
}

class EditDetailViewController: BaseViewController,DXPhotoPickerControllerDelegate, BabyEditDelegate,DatePickerDelegate , UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var editModel:PersonEidtDetail!
    var editDelegate:PersonInfoEditDelegate!
    var personDetail:PersonDetail!
    private var headerEditView:EditHeaderView!
    private var babyEditView:EditBabyView!
    private var babyIndexPath:NSIndexPath!
    private var babyInfo:BabyInfo!
    private var babyBrithdayPicker:PickerControllView!
    private var addBabyStatus = -1
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch self.editModel.eidtType {
        case 0:
            self.navigationBarItem(self, isImage: false, title: "头像", leftSel: nil, rightSel: #selector(EditDetailViewController.exchangeHeader), rightTitle: "更换", rightItemSize: CGSize(width: 30, height: 40))
            self.headerEditView = EditHeaderView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: ScreenHeight - navigationBarHeight), image: self.editModel.subItem)
            self.view.addSubview(self.headerEditView)
        case 1:
            self.navigationBarItem(self, isImage: false, title: "名字", leftSel: nil, rightSel: nil)
            let editNameView = EditNameView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: ScreenHeight - navigationBarHeight - 10), completionHandler: { [weak self](txt) in
                if let weakSelf = self{
                    if let person = PersonDetailBL.find(){
                        HUD.showHud("正在提交...", onView: weakSelf.view)
                        PersonDetail.sendAsyncChangePersonInfo(txt, sex: person.sex, headImg: person.headImg, breedStatus: person.breedStatus, breedStatusDate: person.breedStatusDate, breedBirthDate: person.breedBirthDate, province: person.province, provinceCode: person.provinceCode, city: person.city, cityCode: person.cityCode, userSign: person.userSign, completionHandler: { (errorCode, msg) in
                            HUD.hideHud(weakSelf.view)
                            if let error = errorCode{
                                if error == BabyZoneConfig.shared.passCode{
                                    if let delegate = weakSelf.editDelegate{
                                        weakSelf.editModel.subItem = txt
                                        delegate.fetchPersonInfo(weakSelf.editModel)
                                        weakSelf.navigationController?.popViewControllerAnimated(true)
                                    }
                                }else{
                                    HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                }
                            }else{
                                HUD.showText("网络异常:\(msg)", onView: weakSelf.view)
                            }
                        })
                    }
                }
            })
            self.view.addSubview(editNameView)
        case 2:
            self.navigationBarItem(self, isImage: false, title: "个性签名", leftSel: nil, rightSel: nil)
            let editSignView = EditSignView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), completionHandler: {[weak self] (txt) in
                if let weakSelf = self{
                    if let person = PersonDetailBL.find(){
                        HUD.showHud("正在提交...", onView: weakSelf.view)
                        PersonDetail.sendAsyncChangePersonInfo(person.nickName, sex: person.sex, headImg: person.headImg, breedStatus: person.breedStatus, breedStatusDate: person.breedStatusDate, breedBirthDate: person.breedBirthDate, province: person.province, provinceCode: person.provinceCode, city: person.city, cityCode: person.cityCode, userSign: txt, completionHandler: { (errorCode, msg) in
                            HUD.hideHud(weakSelf.view)
                            if let error = errorCode{
                                if error == BabyZoneConfig.shared.passCode{
                                    if let delegate = weakSelf.editDelegate{
                                        weakSelf.editModel.subItem = txt
                                        delegate.fetchPersonInfo(weakSelf.editModel)
                                        weakSelf.navigationController?.popViewControllerAnimated(true)
                                    }
                                }else{
                                    HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                }
                            }else{
                                HUD.showText("网络异常:\(msg)", onView: weakSelf.view)
                            }
                        })
                    }
                }
            })
            self.view.addSubview(editSignView)
        case 3:
            self.navigationBarItem(self, isImage: false, title: "性别", leftSel: nil, rightSel: nil)
            let editSexView = EditSexView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), isMale: Int(self.personDetail.sex)!, completionHandler: { [weak self](sex, sexId) in
                if let weakSelf = self{
                    
                    if let person = PersonDetailBL.find(){
                        HUD.showHud("正在提交...", onView: weakSelf.view)
                        PersonDetail.sendAsyncChangePersonInfo(person.nickName, sex: sexId, headImg: person.headImg, breedStatus: person.breedStatus, breedStatusDate: person.breedStatusDate, breedBirthDate: person.breedBirthDate, province: person.province, provinceCode: person.provinceCode, city: person.city, cityCode: person.cityCode, userSign: person.userSign, completionHandler: { (errorCode, msg) in
                            HUD.hideHud(weakSelf.view)
                            if let error = errorCode{
                                if error == BabyZoneConfig.shared.passCode{
                                    if let delegate = weakSelf.editDelegate{
                                        weakSelf.editModel.subItem = sex
                                        delegate.fetchPersonInfo(weakSelf.editModel)
                                        weakSelf.navigationController?.popViewControllerAnimated(true)
                                    }
                                }else{
                                    HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                }
                            }else{
                                HUD.showText("网络异常:\(msg)", onView: weakSelf.view)
                            }
                        })
                    }
                }
                })
            self.view.addSubview(editSexView)
        case 4:
            self.navigationBarItem(self, isImage: false, title: "地区", leftSel: nil, rightSel: nil)
        case 5:
            self.navigationBarItem(self, isImage: false, title: "孕育状态", leftSel: nil, rightSel: nil)
            let editStatusView = EditPregStatusView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), status: Int(self.personDetail.breedStatus) == nil ? 1 : Int(self.personDetail.breedStatus)!, completionHandler: {[weak self] (status, statusId) in
                if let weakSelf = self{
                    if let person = PersonDetailBL.find(){
                        HUD.showHud("正在提交...", onView: weakSelf.view)
                        PersonDetail.sendAsyncChangePersonInfo(person.nickName, sex: person.sex, headImg: person.headImg, breedStatus: statusId, breedStatusDate: person.breedStatusDate, breedBirthDate: person.breedBirthDate, province: person.province, provinceCode: person.provinceCode, city: person.city, cityCode: person.cityCode, userSign: person.userSign, completionHandler: { (errorCode, msg) in
                            HUD.hideHud(weakSelf.view)
                            if let error = errorCode{
                                if error == BabyZoneConfig.shared.passCode{
                                    if let delegate = weakSelf.editDelegate{
                                        weakSelf.editModel.subItem = status
                                        delegate.fetchPersonInfo(weakSelf.editModel)
                                        weakSelf.navigationController?.popViewControllerAnimated(true)
                                    }
                                }else{
                                    HUD.showText("修改失败:\(msg)", onView: weakSelf.view)
                                }
                            }else{
                                HUD.showText("网络异常:\(msg)", onView: weakSelf.view)
                            }
                        })
                    }
                }
            })
            self.view.addSubview(editStatusView)
        case 6:
            self.navigationBarItem(self, isImage: false, title: self.editModel.mainTitle, leftSel: nil, rightSel: nil)
            let babyId = self.editModel.babyId
            var babyModel = BabyList()
            if let obj = BabyListBL.find(babyId) {
                babyModel = obj
            }
            var babyData:[BabyInfo] = []
            var baby:BabyInfo = BabyInfo(mainItem: "姓名", subItem: babyModel.babyName == "" ? "宝宝" : babyModel.babyName, infoType: 0, babyId: babyId)
            babyData.append(baby)
            baby = BabyInfo(mainItem: "性别", subItem: babyModel.sex, infoType: 1, babyId: babyId)
            babyData.append(baby)
            baby = BabyInfo(mainItem: "年龄", subItem: babyModel.birthday, infoType: 2, babyId: babyId)
            babyData.append(baby)
            
            self.babyEditView = EditBabyView.init(frame:  CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), baby: babyData, babyId: babyId, completionHandler: { [weak self] (baby, indexPath) in
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
                }, deleteCompletionHandler: { [weak self] in
                    if let weakSelf = self{
                        if weakSelf.editDelegate != nil{
                            weakSelf.editDelegate.reloadBabySection()
                        }
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
            })
            self.view.addSubview(self.babyEditView)
        case 7:
            self.navigationBarItem(self, isImage: false, title: "添加宝宝", leftSel: nil, rightSel: #selector(self.confirmAddBaby), rightTitle: "保存")
            var babyData:[BabyInfo] = []
            var baby:BabyInfo = BabyInfo(mainItem: "姓名", subItem: "请输入姓名", infoType: 0, babyId: "")
            babyData.append(baby)
            baby = BabyInfo(mainItem: "性别", subItem: "请选择性别", infoType: 1, babyId: "")
            babyData.append(baby)
            baby = BabyInfo(mainItem: "年龄", subItem: "请选择年龄", infoType: 2, babyId: "")
            babyData.append(baby)
            self.babyEditView = EditBabyView.init(frame: CGRect(x: 10, y: navigationBarHeight, width:  self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight), baby: babyData, completionHandler: { [weak self] (baby, indexPath) in
                if let weakSelf = self{
                    weakSelf.babyIndexPath = indexPath
                    weakSelf.babyInfo = baby
                    if indexPath.row != 2{
                        let editBabyInfo = BabyInfoEditViewController()
                        editBabyInfo.babyModel = baby
                        editBabyInfo.sexStatus = weakSelf.addBabyStatus
                        editBabyInfo.editDelegate = self
                        weakSelf.navigationController?.pushViewController(editBabyInfo, animated: true)
                    }else{
                        weakSelf.setupDatePicker()
                    }
                }
                }, deleteCompletionHandler: nil)
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
    
    func sexStatus(status: Int) {
        self.addBabyStatus = status
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
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage, let headerView = self.headerEditView {
            //baby : http://oco9loo2g.bkt.clouddn.com/2016-10-15+14:56:55_pic.png
            //xiangai : http://of0k04nl6.bkt.clouddn.com/image
            headerView.refreshWithMask(false)
            QiNiu.uploadImage("baby",image: image, progressHandler: { (key:String!, progress:Float) in
                headerView.uploadProgress = progress
                if Int(progress) == 1{
                    headerView.headImage = image
                }
                }, successHandler: { (url, fileName) in
                    if let person = PersonDetailBL.find(){
                        if let imageUrl = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet()){
                            person.headImg = imageUrl
                        }
                        if let modifyResult = PersonDetailBL.modify(person) {
                            if modifyResult.headImg != ""{
                                let uploadQueue = dispatch_queue_create("uploadImageQueue", nil)
                                uploadQueue.queue({
                                    PersonDetail.sendAsyncChangePersonInfo(person.nickName, sex: person.sex, headImg: modifyResult.headImg, breedStatus: person.breedStatus, breedStatusDate: person.breedStatusDate, breedBirthDate: person.breedBirthDate,  province: person.province, provinceCode: person.provinceCode, city: person.city, cityCode: person.cityCode, userSign: person.userSign, completionHandler: { [weak self](errorCode, msg) in
                                        if let error = errorCode{
                                            if error == BabyZoneConfig.shared.passCode{
                                                dispatch_get_main_queue().queue({
                                                    headerView.removeMask()
                                                    if let weakSelf = self{
                                                        if weakSelf.editDelegate != nil{
                                                            weakSelf.editModel.subItem = modifyResult.headImg
                                                            weakSelf.editDelegate.fetchPersonInfo(weakSelf.editModel)
                                                        }
                                                    }
                                                })
                                            }
                                        }
                                        })
                                })
                            }
                        }
                    }

                }, failureHandler: { (error) in
                    headerView.removeMask()
            })
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
        self.babyInfo.subItem = dateString
        if let babyView = self.babyEditView {
            if let baby = BabyListBL.find(self.editModel.babyId) {
                HUD.showHud("正在提交...", onView: self.view)
                BabyList.sendAsyncModifyBaby(baby.idUserBabyInfo, babyName: baby.babyName, sex: baby.sex, birthday: dateString, isCurr: baby.isCurr, completionHandler: { (errorCode, msg) in
                    HUD.hideHud(self.view)
                    if let error = errorCode{
                        if error == BabyZoneConfig.shared.passCode{
                            babyView.reloadTableViewCell(self.babyIndexPath, baby: self.babyInfo)
                        }else{
                            HUD.showText("修改失败:\(msg)", onView: self.view)
                        }
                    }else{
                        HUD.showText("网络异常:\(msg)", onView: self.view)
                    }
                })
            }
        }
    }
    
    func confirmAddBaby() -> Void {
        if let babyEdit = self.babyEditView {
            if let baby = babyEdit.fetchAddBabyResult() {
                BabyList.sendAsyncAddBaby(baby.nickName, sex: baby.sex, birthday: baby.birthday, isCurr: "1", completionHandler: { [weak self](errorCode, msg) in
                    if let weakSelf = self{
                        if let error = errorCode{
                            if error == BabyZoneConfig.shared.passCode{
                                if weakSelf.editDelegate != nil{
                                    weakSelf.editDelegate.reloadBabySection()
                                }
                                weakSelf.navigationController?.popViewControllerAnimated(true)
                            }else{
                                HUD.showText("添加失败:\(msg)", onView: weakSelf.view)
                            }
                        }else{
                            HUD.showText("网络异常:\(msg)", onView: weakSelf.view)
                        }
                    }
                })
            }else{
                HUD.showText("请先编辑孩子信息", onView: self.view)
            }
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
