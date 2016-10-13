//
//  ChildAccountView.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/6.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class ChildAccountCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:ChildEquipmentList) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRectMake(CGRectGetMinX(self.contentView.frame), CGRectGetMinY(self.contentView.frame), ScreenWidth, self.contentView.frame.height)
        let mainItemLabel = UILabel.init(frame: CGRectMake(2 * viewOriginX, 0, CGRectGetWidth(self.contentView.frame) / 2 - 4 * viewOriginX, CGRectGetHeight(self.contentView.frame)))
        mainItemLabel.adjustsFontSizeToFitWidth = true
        mainItemLabel.font = UIFont.systemFontOfSize(upRateWidth(15))
        mainItemLabel.textColor = UIColor.darkGrayColor()
        mainItemLabel.text = model.userRemark
        self.contentView.addSubview(mainItemLabel)
        
        let subItemLabel = UILabel.init(frame: CGRectMake(CGRectGetWidth(self.contentView.frame) / 2 , 0, CGRectGetWidth(self.contentView.frame) / 2 - upRateWidth(30), CGRectGetHeight(self.contentView.frame)))
        subItemLabel.text = model.eqmDesc
        subItemLabel.font = UIFont.systemFontOfSize(upRateWidth(10))
        subItemLabel.textColor = UIColor.lightGrayColor()
        subItemLabel.textAlignment = .Right
        self.contentView.addSubview(subItemLabel)
        
    }
}

class ChildDetailCell: UITableViewCell,UITextFieldDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    func refreshCell(model:AccountDetail, row:Int) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(origin: self.contentView.frame.origin, size: CGSize(width: ScreenWidth - 2 * viewOriginX, height: self.contentView.frame.height))
        if model.devicePermisson == -1 {
            let rightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width * (2 / 5), height: self.contentView.frame.height))
            rightLabel.textColor = UIColor.lightGrayColor()
            rightLabel.text = model.subItem
            rightLabel.textAlignment = .Right
            rightLabel.font = UIFont.systemFontOfSize(12)
            let inputTF = UITextField.textField(CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width - 20 - 2 * viewOriginX, height: self.contentView.frame.height), title: nil, holder: model.mainItem, right: true, rightView: rightLabel)
            inputTF.delegate = self
            inputTF.tag = inputTFStartIndex + row
            self.contentView.addSubview(inputTF)
        }else{
            let mainLabel = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width / 2, height: self.contentView.frame.height))
            mainLabel.text = model.mainItem
            mainLabel.font = UIFont.boldSystemFontOfSize(14)
            mainLabel.textColor = UIColor.hexStringToColor("#330429")
            self.contentView.addSubview(mainLabel)
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: self.contentView.frame.width - AddAccountSwitchWidth - 15, y: (self.contentView.frame.height - AddAccountSwitchHeight) / 2, width: AddAccountSwitchWidth, height: AddAccountSwitchHeight))
            onSwitch.on = model.devicePermisson == 0 ? false : true
            onSwitch.onLabel.text = "打开"
            onSwitch.offLabel.text = "关闭"
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            self.contentView.addSubview(onSwitch)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

private let inputTFStartIndex = 100
private let AddAccountSwitchWidth:CGFloat = 50
private let AddAccountSwitchHeight:CGFloat = 20
class AddAccountCell: UITableViewCell,UITextFieldDelegate {
    
    private var phoneString:String!
    private var userName:String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func refreshCell(model:AccountDetail, row:Int) -> Void {
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.contentView.frame = CGRect(origin: self.contentView.frame.origin, size: CGSize(width: ScreenWidth - 2 * viewOriginX, height: self.contentView.frame.height))
        if model.devicePermisson == -1 {
            let rightLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.contentView.frame.width * (2 / 5), height: self.contentView.frame.height))
            rightLabel.textColor = UIColor.lightGrayColor()
            rightLabel.text = model.subItem
            rightLabel.textAlignment = .Right
            rightLabel.font = UIFont.systemFontOfSize(12)
            let inputTF = UITextField.textField(CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width - 30 - 2 * viewOriginX, height: self.contentView.frame.height), title: nil, holder: model.mainItem, right: true, rightView: rightLabel)
            inputTF.delegate = self
            inputTF.tag = inputTFStartIndex + row
            self.contentView.addSubview(inputTF)
        }else{
            let mainLabel = UILabel.init(frame: CGRect(x: 2 * viewOriginX, y: 0, width: self.contentView.frame.width / 2, height: self.contentView.frame.height))
            mainLabel.text = model.mainItem
            mainLabel.font = UIFont.boldSystemFontOfSize(14)
            mainLabel.textColor = UIColor.hexStringToColor("#330429")
            self.contentView.addSubview(mainLabel)
            
            let onSwitch = HMSwitch.init(frame: CGRect(x: self.contentView.frame.width - AddAccountSwitchWidth - 15, y: (self.contentView.frame.height - AddAccountSwitchHeight) / 2, width: AddAccountSwitchWidth, height: AddAccountSwitchHeight))
            onSwitch.on = model.devicePermisson == 0 ? false : true
            onSwitch.onLabel.text = "打开"
            onSwitch.offLabel.text = "关闭"
            onSwitch.onLabel.textColor = UIColor.whiteColor()
            onSwitch.offLabel.textColor = UIColor.whiteColor()
            onSwitch.onLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.offLabel.font = UIFont.systemFontOfSize(8)
            onSwitch.activeColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.onTintColor = UIColor.hexStringToColor("#d85a7b")
            onSwitch.inactiveColor = UIColor.lightGrayColor()
            self.contentView.addSubview(onSwitch)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func finishAddAccount() -> Void {
        
    }
    
}



class AddCompletedView: UIView {
    
    private var helpHandler:(()->())?
    private var finishHandler:(()->())?
    
    init(frame: CGRect, helpParentHandler:(()->())?, AddCompletionHandler:(()->())?) {
        super.init(frame: frame)
        let editButton = AddChildAccountButton(type: .Custom)//edit_pencil.png
        editButton.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) / 2)
        editButton.setImageRect(CGRectMake(0, 0, upRateWidth(15), upRateWidth(15)), image: "edit_pencil.png", title: "爸妈不会操作手机，帮爸妈注册账号?", fontSize: upRateWidth(12))
        editButton.setCustomTitleColor(UIColor.colorFromRGB(219, g: 128, b: 130)!)
        editButton.addCustomTarget(self, sel: #selector(AddCompletedView.helpParentClick))
        self.addSubview(editButton)
        
        let finishButton = UIButton.init(type: .Custom)
        finishButton.frame = CGRectMake(0, CGRectGetMaxY(editButton.frame), CGRectGetWidth(editButton.frame), CGRectGetHeight(editButton.frame))
        finishButton.backgroundColor = UIColor.colorFromRGB(219, g: 128, b: 130)
        finishButton.setTitle("完成", forState: .Normal)
        finishButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        finishButton.addTarget(self, action: #selector(AddCompletedView.finishClick), forControlEvents: .TouchUpInside)
        self.addSubview(finishButton)
        
        self.helpHandler = helpParentHandler
        self.finishHandler = AddCompletionHandler
        
    }
    
    func helpParentClick() -> Void {
        if let handle = self.helpHandler {
            handle()
        }
    }
    
    func finishClick() -> Void {
        if let handle = self.finishHandler {
            handle()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

