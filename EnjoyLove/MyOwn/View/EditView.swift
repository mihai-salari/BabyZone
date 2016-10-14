//
//  EditView.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/17.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class EditView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}


class EditHeaderView: UIView {
    
    var headImage:UIImage!{
        didSet{
            if let imgView = self.headerImageView {
                imgView.image = headImage
            }
        }
    }
    
    private var headerImageView:UIImageView!
    private var loadView:UIView!
    private var tipView:UIView!
    
    init(frame: CGRect,image:String) {
        super.init(frame: frame)
        self.headerImageView = UIImageView.init(frame: CGRect(x: 10, y: 0, width: frame.width - 20, height: frame.height / 2))
        self.headerImageView.image = UIImage.imageWithName(image)
        self.addSubview(self.headerImageView)
        
    }
    
    
    func refreshWithMask(loaded:Bool) -> Void {
        if self.loadView != nil {
            self.loadView.removeFromSuperview()
            self.loadView = nil
        }
        if self.tipView != nil {
            self.tipView.removeFromSuperview()
            self.tipView = nil
        }
        
        self.loadView = UIView.init(frame: self.bounds)
        self.loadView.backgroundColor = UIColor.colorFromRGB(0, g: 0, b: 0, a: 0.4)
        self.addSubview(self.loadView)
        
        let tipViewWidth = self.frame.width * (1 / 4)
        self.tipView = UIView.init(frame: CGRect(x: (self.frame.width - tipViewWidth) / 2, y: (self.frame.height - tipViewWidth) / 2 - 64, width: tipViewWidth, height: tipViewWidth))
        self.addSubview(self.tipView)
        let imageViewWidth = self.tipView.frame.width * (2 / 3)
        let tipLabelHeight = self.tipView.frame.width * (1 / 3)
        let imageView = UIImageView.init(frame: CGRect(x: (self.tipView.frame.width - imageViewWidth) / 2, y: 0, width: imageViewWidth, height: imageViewWidth))
        let tipLabel = UILabel.init(frame: CGRect(x: 0, y: imageView.frame.maxY, width: self.tipView.frame.width, height: tipLabelHeight))
        tipLabel.font = UIFont.systemFontOfSize(10)
        tipLabel.textColor = UIColor.hexStringToColor("#db6773")
        tipLabel.textAlignment = .Center
        if loaded == true {
            imageView.image = UIImage.imageWithName("myOwnSuccess.png")
            tipLabel.text = "上传完成"
        }else{
            imageView.image = UIImage.imageWithName("myOwnLoading.png")
            tipLabel.text = "上传中"
        }
        self.tipView.addSubview(imageView)
        self.tipView.addSubview(tipLabel)
    }
    
    func removeMask() -> Void {
        if let tip = self.tipView {
            tip.removeFromSuperview()
            self.tipView = nil
        }
        if let load = self.loadView {
            load.removeFromSuperview()
            self.loadView = nil
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class EditSignView: UIView ,UITextViewDelegate{
    //private var keyboard:Keyboard!
    private let maxTextNum = 40
    private var inputLabel:UILabel!
    private var exsitNum:Int = 0{
        didSet{
            if let label = self.inputLabel {
                label.text = "\(self.maxTextNum - exsitNum)"
            }
        }
    }
    init(frame: CGRect, completionHandler:((txt:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let textView = UITextView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * (1 / 5)))
        self.addSubview(textView)
        textView.delegate = self
        //self.keyboard = Keyboard.init(targetView: textView, container: self, hasNav: true, show: nil, hide: nil)
        let toolbar = HMToolbar.init(frame: CGRectMake(0, 0, ScreenWidth, 30)) {[weak self] in
            if let weakSelf = self{
                weakSelf.endEditing(true)
                print("text view text \(textView.text)")
                if let handle = completionHandler, let text = textView.text{
                    handle(txt: text)
                }
            }
        }
        textView.inputAccessoryView = toolbar
        
        self.inputLabel = UILabel.init(frame: CGRect(x: textView.frame.maxX - 30, y: textView.frame.maxY - 30, width: 30, height: 30))
        inputLabel.font = UIFont.systemFontOfSize(12)
        inputLabel.textColor = UIColor.lightGrayColor()
        inputLabel.textAlignment = .Center
        inputLabel.text = "\(self.maxTextNum)"
        self.addSubview(inputLabel)
        
        
        let line = UIView.init(frame: CGRect(x: 0, y: textView.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.lightGrayColor()
        self.addSubview(line)
        
    }
    
    deinit {
       // self.keyboard = nil
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func textViewDidChange(textView: UITextView) {
        let inputNum = textView.text.characters.count
        self.exsitNum = inputNum
        if inputNum > maxTextNum {
            self.exsitNum = maxTextNum
            let str = NSString.init(string: textView.text).substringToIndex(maxTextNum)
            textView.text = str
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        let comcatStr = NSString.init(string: textView.text).stringByReplacingCharactersInRange(range, withString: text)
        let canInputLen = self.maxTextNum - comcatStr.characters.count
        if canInputLen >= 0 {
            return true
        }else{
            let len = text.characters.count + canInputLen
            let rg = NSMakeRange(0, max(len, 0))
            if rg.length > 0 {
                let str = NSString.init(string: text).substringWithRange(rg)
                textView.text = NSString.init(string: textView.text).stringByReplacingCharactersInRange(range, withString: str)
            }
            return false
        }
    }
}

class EditNameView: UIView ,UITextFieldDelegate{
    private var nameHandler:((txt:String)->())?
    private var nameTF:UITextField!
    
    init(frame: CGRect, completionHandler:((txt:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.nameTF = UITextField.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 50))
        self.nameTF.delegate = self
        self.nameTF.returnKeyType = .Done
        self.nameTF.clearButtonMode = .WhileEditing
        self.addSubview(self.nameTF)
        
        
        let line = UIView.init(frame: CGRect(x: 0, y: self.nameTF.frame.maxY, width: self.frame.width, height: 1))
        line.backgroundColor = UIColor.hexStringToColor("#f5f0f1")
        self.addSubview(line)
        
        self.nameHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearText() -> Void {
        self.nameTF.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let handle = self.nameHandler,let text = textField.text {
            handle(txt: text)
        }
        return true
    }
}

class EditSexView: UIView {
    
    private var sexHandler:((sex:String, sexId:String)->())?
    
    init(frame: CGRect, isMale:Bool, completionHandler:((sex:String, sexId:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let maleButton = SexButton(type: .Custom)
        maleButton.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        maleButton.tag = 200
        maleButton.setImageSize(CGSize(width: 25, height: 20), normaImage: "", selectedImage: "myOwnSelected.png", normalTitle: "男", selectedTitle: "男", fontSize: 14)
        maleButton.addCustomTarget(self, sel: #selector(EditSexView.selectedForSex(_:)))
        maleButton.setCustomTitleColor(UIColor.darkGrayColor())
        self.addSubview(maleButton)
        
        var line = UIView.init(frame: CGRect(x: 0, y: maleButton.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f5f0f1")
        self.addSubview(line)
        
        
        let femaleButton = SexButton(type: .Custom)
        femaleButton.frame = CGRect(x: 0, y: line.frame.maxY, width: self.frame.width, height: 40)
        femaleButton.tag = 201
        femaleButton.setImageSize(CGSize(width: 25, height: 20), normaImage: "", selectedImage: "myOwnSelected.png", normalTitle: "女", selectedTitle: "女", fontSize: 14)
        femaleButton.addCustomTarget(self, sel: #selector(EditSexView.selectedForSex(_:)))
        femaleButton.setCustomTitleColor(UIColor.darkGrayColor())
        self.addSubview(femaleButton)
        
        line = UIView.init(frame: CGRect(x: 0, y: femaleButton.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f5f0f1")
        self.addSubview(line)
        
        if isMale == true {
            maleButton.selected = true
        }else{
            femaleButton.selected = true
        }
        self.sexHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedForSex(btn:SexButton) -> Void {
        btn.selected = !btn.selected
        var sex = ""
        var sexId = ""
        if btn.tag == 200 {
            sex = "男"
            sexId = "0"
            if let anotherView = self.viewWithTag(201) {
                let female = anotherView as! SexButton
                female.selected = !btn.selected
            }
        }else if btn.tag == 201{
            sex = "女"
            sexId = "1"
            if let anotherView = self.viewWithTag(200) {
                let male = anotherView as! SexButton
                male.selected = !btn.selected
            }
        }
        if let handle = self.sexHandler {
            handle(sex: sex, sexId: sexId)
        }
    }
}

class EditPregStatusView: UIView {
    private var statusHandler:((status:String, statusId:String)->())?
    
    init(frame: CGRect, hasBaby:Bool, completionHandler:((status:String, statusId:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let maleButton = PregStatusButton(type: .Custom)
        maleButton.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 40)
        maleButton.tag = 200
        maleButton.setImageSize(CGSize(width: 25, height: 20), normaImage: "", selectedImage: "myOwnSelected.png", normalTitle: "已有宝宝", selectedTitle: "已有宝宝", fontSize: 14)
        maleButton.addCustomTarget(self, sel: #selector(EditSexView.selectedForSex(_:)))
        maleButton.setCustomTitleColor(UIColor.darkGrayColor())
        self.addSubview(maleButton)
        
        var line = UIView.init(frame: CGRect(x: 0, y: maleButton.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f5f0f1")
        self.addSubview(line)
        
        
        let femaleButton = PregStatusButton(type: .Custom)
        femaleButton.frame = CGRect(x: 0, y: line.frame.maxY, width: self.frame.width, height: 40)
        femaleButton.tag = 201
        femaleButton.setImageSize(CGSize(width: 25, height: 20), normaImage: "", selectedImage: "myOwnSelected.png", normalTitle: "备孕/怀孕", selectedTitle: "备孕/怀孕", fontSize: 14)
        femaleButton.addCustomTarget(self, sel: #selector(EditSexView.selectedForSex(_:)))
        femaleButton.setCustomTitleColor(UIColor.darkGrayColor())
        self.addSubview(femaleButton)
        
        line = UIView.init(frame: CGRect(x: 0, y: femaleButton.frame.maxY, width: self.frame.width, height: 0.5))
        line.backgroundColor = UIColor.hexStringToColor("#f5f0f1")
        self.addSubview(line)
        
        if hasBaby == true {
            maleButton.selected = true
        }else{
            femaleButton.selected = true
        }
        self.statusHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectedForSex(btn:SexButton) -> Void {
        btn.selected = !btn.selected
        var status = ""
        var statusId = ""
        
        if btn.tag == 200 {
            status = "已有宝宝"
            statusId = "0"
            if let anotherView = self.viewWithTag(201) {
                let female = anotherView as! PregStatusButton
                female.selected = !btn.selected
            }
        }else if btn.tag == 201{
            status = "备孕/怀孕"
            statusId = "1"
            if let anotherView = self.viewWithTag(200) {
                let female = anotherView as! PregStatusButton
                female.selected = !btn.selected
            }
        }
        if let handle = self.statusHandler {
            handle(status: status, statusId: statusId)
        }
    }
}

private let EditBabyTableViewCellId = "EditBabyTableViewCellId"
class EditBabyView: UIView ,UITableViewDelegate, UITableViewDataSource{
    private var babyTable:UITableView!
    private var babyData:[BabyInfo]!
    private var selectedHandler:((baby:BabyInfo, indexPath:NSIndexPath)->())?
    
    init(frame: CGRect, baby:[BabyInfo], completionHandler:((baby:BabyInfo, indexPath:NSIndexPath)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.babyData = baby
        self.babyTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: upRateHeight(44) * CGFloat(baby.count)), style: .Plain)
        self.babyTable.scrollEnabled = false
        self.babyTable.delegate = self
        self.babyTable.dataSource = self
        self.babyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: EditBabyTableViewCellId)
        self.babyTable.separatorInset = UIEdgeInsetsZero
        self.babyTable.layoutMargins = UIEdgeInsetsZero
        self.addSubview(self.babyTable)
        self.selectedHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.babyData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EditBabyTableViewCellId)
        if let resultCell = cell {
            for subview in resultCell.contentView.subviews {
                subview.removeFromSuperview()
            }
            resultCell.contentView.frame = CGRect(x: resultCell.contentView.frame.minX, y: resultCell.contentView.frame.minY, width: self.frame.width, height: resultCell.contentView.frame.height)
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.accessoryType = .DisclosureIndicator
            resultCell.selectionStyle = .None
            let model = self.babyData[indexPath.row]
            resultCell.textLabel?.text = model.mainItem
            
            let subLabel = UILabel.init(frame: CGRect(x: resultCell.contentView.frame.width / 2, y: 0, width: resultCell.contentView.frame.width / 2 - 25, height: resultCell.contentView.frame.height))
            subLabel.font = UIFont.systemFontOfSize(12)
            subLabel.textAlignment = .Right
            subLabel.text = model.subItem
            subLabel.textColor = UIColor.lightGrayColor()
            resultCell.contentView.addSubview(subLabel)
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return upRateWidth(44)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.babyData[indexPath.row]
        if let handle = self.selectedHandler {
            handle(baby: model, indexPath: indexPath)
        }
    }
    
    func reloadTableViewCell(indexPath:NSIndexPath, baby:BabyInfo) -> Void {
        if let tableView = self.babyTable {
            self.babyData[indexPath.row] = baby
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
}


