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


private let sexStatusTableViewCellId = "sexStatusTableViewCellId"
class EditSexView: UIView ,UITableViewDataSource,UITableViewDelegate{
    
    private var sexHandler:((sex:String, sexId:String)->())?
    private var sexStatusTable:UITableView!
    private var selectedIndexPath:NSIndexPath!
    private var sexStatusData:[String]!
    private var sexIndex:[Int]!
    private var currentStatus:Int = 0
    
    
    init(frame: CGRect, isMale:Int, completionHandler:((sex:String, sexId:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        self.sexStatusData = ["男", "女"]
        self.sexIndex = [1, 2]
        self.currentStatus = isMale
        self.selectedIndexPath = NSIndexPath.init(forRow: -1, inSection: -1)
        self.sexStatusTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat(self.sexStatusData.count) * 44), style: .Plain)
        self.sexStatusTable.separatorInset = UIEdgeInsetsZero
        self.sexStatusTable.layoutMargins = UIEdgeInsetsZero
        self.sexStatusTable.rowHeight = 44
        self.sexStatusTable.delegate = self
        self.sexStatusTable.dataSource = self
        self.sexStatusTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: sexStatusTableViewCellId)
        self.addSubview(self.sexStatusTable)
        
        self.sexHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sexStatusData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(sexStatusTableViewCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            let item = self.sexStatusData[indexPath.row]
            resultCell.textLabel?.text = item
            if self.sexIndex[indexPath.row] == self.currentStatus {
                self.selectedIndexPath = indexPath
                resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
                resultCell.accessoryType = .Checkmark
            }else{
                resultCell.accessoryType = .None
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == self.selectedIndexPath {
            return
        }
        let everSelectedCell = tableView.cellForRowAtIndexPath(self.selectedIndexPath)
        if let resultCell = everSelectedCell {
            resultCell.accessoryType = .None
        }
        let newSelectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let resultCell = newSelectedCell {
            resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
            resultCell.accessoryType = .Checkmark
            if let handle = self.sexHandler {
                var status:Int = 1
                switch self.sexStatusData[indexPath.row] {
                case "男":
                    status = 1
                case "女":
                    status = 2
                default:
                    status = -1
                }
                handle(sex: self.sexStatusData[indexPath.row], sexId: "\(status)")
            }
        }
        self.selectedIndexPath = indexPath
    }
    
}
private let pregStatusTableViewCellId = "pregStatusTableViewCellId"
class EditPregStatusView: UIView,UITableViewDelegate,UITableViewDataSource {
    private var statusHandler:((status:String, statusId:String)->())?
    private var pregStatusTable:UITableView!
    private var selectedIndexPath:NSIndexPath!
    private var pregStatusData:[String]!
    private var pregStatusIndex:[Int]!
    private var currentStatus:Int = 0
    init(frame: CGRect, status:Int, completionHandler:((status:String, statusId:String)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.pregStatusData = ["正常","备孕","怀孕","有宝宝"]
        self.pregStatusIndex = [1, 2, 3, 4]
        self.currentStatus = status
        
        self.pregStatusTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: CGFloat(self.pregStatusData.count) * 44), style: .Plain)
        self.pregStatusTable.separatorInset = UIEdgeInsetsZero
        self.pregStatusTable.layoutMargins = UIEdgeInsetsZero
        self.pregStatusTable.rowHeight = 44
        self.pregStatusTable.delegate = self
        self.pregStatusTable.dataSource = self
        self.pregStatusTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: pregStatusTableViewCellId)
        self.addSubview(self.pregStatusTable)
        
        self.statusHandler = completionHandler
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pregStatusData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(pregStatusTableViewCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            let item = self.pregStatusData[indexPath.row]
            resultCell.textLabel?.text = item
            if self.pregStatusIndex[indexPath.row] == self.currentStatus {
                self.selectedIndexPath = indexPath
                resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
                resultCell.accessoryType = .Checkmark
            }else{
                resultCell.accessoryType = .None
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == self.selectedIndexPath {
            return
        }
        let everSelectedCell = tableView.cellForRowAtIndexPath(self.selectedIndexPath)
        if let resultCell = everSelectedCell {
            resultCell.accessoryType = .None
        }
        let newSelectedCell = tableView.cellForRowAtIndexPath(indexPath)
        if let resultCell = newSelectedCell {
            resultCell.tintColor = UIColor.hexStringToColor("#dc7190")
            resultCell.accessoryType = .Checkmark
            if let handle = self.statusHandler {
                var status:Int = 1
                switch self.pregStatusData[indexPath.row] {
                case "备孕":
                    status = 2
                case "怀孕":
                    status = 3
                case "已有宝宝":
                    status = 4
                default:
                    break
                }
                handle(status: self.pregStatusData[indexPath.row], statusId: "\(status)")
            }
        }
        self.selectedIndexPath = indexPath
    }
}

private let EditBabyTableViewCellId = "EditBabyTableViewCellId"
class EditBabyView: UIView ,UITableViewDelegate, UITableViewDataSource{
    private var babyTable:UITableView!
    private var babyData:[BabyInfo]!
    private var addBaby:AddBaby!
    private var selectedHandler:((baby:BabyInfo, indexPath:NSIndexPath)->())?
    
    init(frame: CGRect, baby:[BabyInfo], completionHandler:((baby:BabyInfo, indexPath:NSIndexPath)->())?) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.addBaby = AddBaby()
        self.babyData = baby
        self.babyTable = UITableView.init(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 44 * CGFloat(baby.count)), style: .Plain)
        self.babyTable.rowHeight = 44
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
            if model.subItem == "1" {
                subLabel.text = "男"
            }else if model.subItem == "2"{
                subLabel.text = "女"
            }else{
                subLabel.text = model.subItem
            }
            subLabel.textColor = UIColor.lightGrayColor()
            resultCell.contentView.addSubview(subLabel)
            
        }
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let model = self.babyData[indexPath.row]
        if let handle = self.selectedHandler {
            handle(baby: model, indexPath: indexPath)
        }
    }
    
    func reloadTableViewCell(indexPath:NSIndexPath, baby:BabyInfo) -> Void {
        switch baby.infoType {
        case 0:
            self.addBaby.nickName = baby.subItem
        case 1:
            if baby.subItem == "男" {
                self.addBaby.sex = "1"
            }else if baby.subItem == "女"{
                self.addBaby.sex = "2"
            }
        case 2:
            self.addBaby.birthday = baby.subItem
        default:
            break
        }
        if let tableView = self.babyTable {
            self.babyData[indexPath.row] = baby
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func fetchAddBabyResult() -> AddBaby? {
        if let baby = self.addBaby {
            if baby.sex != "1" || baby.sex != "2" {
                HUD.showText("请选择孩子的性别", onView: self)
            }
            if baby.birthday == "" {
                HUD.showText("请填写孩子的生日", onView: self)
            }
            if (baby.sex == "1" || baby.sex == "2") && baby.birthday != "" {
                return baby
            }
        }
        return nil
    }
}


