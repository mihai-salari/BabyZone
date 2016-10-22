//
//  SecurityEditViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/20.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class SecurityEditViewController: BaseViewController {

    var editModel:Security!
    private var bandingView:BandingPhoneView!
    private var wechatView:BandingWeChatView!
    private var privacyView:PrivacyView!
    private var modifyView:ModifyPasswordView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        switch self.editModel.itemType {
        case 0:
            let isBanding = BandingPhone.isBanding()
            self.navigationBarItem(self, isImage: false, title: isBanding ? "手机号" : "绑定手机号", leftSel: nil, rightSel: isBanding ? #selector(SecurityEditViewController.unBandingPhone) : #selector(SecurityEditViewController.bandingPhone), rightTitle: isBanding ? "解除绑定" : "绑定")
        case 1:
            self.navigationBarItem(self, isImage: false, title: "微信号", leftSel: nil, rightSel: #selector(SecurityEditViewController.unBandingWeChat), rightTitle: "解除绑定")
        case 2:
            self.navigationBarItem(self, isImage: false, title: "修改密码", leftSel: nil, rightSel: #selector(SecurityEditViewController.confirmModifyPassword), rightTitle: "确定")
        case 3:
            self.automaticallyAdjustsScrollViewInsets = false
            self.navigationBarItem(self, isImage: false, title: "隐私", leftSel: nil, rightSel: nil)
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch self.editModel.itemType {
        case 0:
            let isBanding = BandingPhone.isBanding()
            let model = BandingPhone(phoneNum: isBanding ? "13688888888" : "", status: isBanding)
            self.bandingView = BandingPhoneView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: ScreenHeight - navigationBarHeight), model: model, addresBookCompletionHandler: { [weak self] in
                if let weakSelf = self{
                    let addressBook = AddressBookViewController()
                    addressBook.selectCompletionHandler = { (model:HMPersonModel) in
                        if let phones = model.mobile{
                            if phones.count > 0{
                                weakSelf.bandingView.fetchPhoneNumerShow(phones[0] as! String)
                            }
                        }
                    }
                    weakSelf.navigationController?.pushViewController(addressBook, animated: true)
                }
            })
            self.view.addSubview(self.bandingView)
            
        case 1:
            let model = BandingWeChat(wechatNum: "wechat account", status: false)
            self.wechatView = BandingWeChatView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: ScreenHeight - navigationBarHeight), model: model)
            self.view.addSubview(self.wechatView)
        case 2:
            self.modifyView = ModifyPasswordView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: ScreenHeight - navigationBarHeight), cancelHandler: { [weak self] (modify) in
                if let weakSelf = self{
                    if modify == true{
                        weakSelf.navigationController?.popToRootViewControllerAnimated(false)
                        HMTablBarController.selectedIndex = 0
                    }else{
                        weakSelf.navigationController?.popViewControllerAnimated(true)
                    }
                }
            })
            self.view.addSubview(self.modifyView)
        case 3:
            var modelArray:[Privacy] = []
            var detail:[PrivacyDetail] = []
            var detailModel = PrivacyDetail(mainItem: "谁可以查看我的个人资料", subItem: "所有人")
            detail.append(detailModel)
            detailModel = PrivacyDetail(mainItem: "谁可以查看我的育婴日记", subItem: "好友")
            detail.append(detailModel)
            var model = Privacy(title: "查看权限", detail: detail)
            modelArray.append(model)
            
            detail = []
            detailModel = PrivacyDetail(mainItem: "通过手机号搜索到我", subItem: "0")
            detail.append(detailModel)
            detailModel = PrivacyDetail(mainItem: "通过微信号搜索到我", subItem: "1")
            detail.append(detailModel)
            model = Privacy(title: "通讯权限", detail: detail)
            modelArray.append(model)
            self.privacyView = PrivacyView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: ScreenHeight - navigationBarHeight), data: modelArray)
            self.view.addSubview(self.privacyView)
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancelSecurityEdit() -> Void {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func bandingPhone() -> Void {
        self.bandingView.fetchBandingPhone()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func unBandingPhone() -> Void {
        self.bandingView.fetchUnBandingPhone()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func unBandingWeChat() -> Void {
        let actionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        let unbandingAction = UIAlertAction.init(title: "解除绑定", style: .Default) { (action:UIAlertAction) in
            
        }
        if unbandingAction.valueForKey("titleTextColor") == nil{
            unbandingAction.setValue(alertTextColor, forKey: "titleTextColor")
        }
        actionSheet.addAction(unbandingAction)
        
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: { (action:UIAlertAction) in
            
        })
        if cancelAction.valueForKey("titleTextColor") == nil{
            cancelAction.setValue(UIColor.darkGrayColor(), forKey: "titleTextColor")
        }
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)

    }
    
    func confirmModifyPassword() -> Void {
        self.modifyView.confirmModify { [weak self] (modify)in
            if let weakSelf = self{
                if modify == true{
                    weakSelf.navigationController?.popToRootViewControllerAnimated(false)
                    HMTablBarController.selectedIndex = 0
                }else{
                    weakSelf.navigationController?.popViewControllerAnimated(true)
                }
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
