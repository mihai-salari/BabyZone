//
//  MyOwnEidtViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/17.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let PersionInfoTableViewCellId = "PersionInfoTableViewCellId"

class MyOwnEidtViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,PersonInfoEditDelegate {
    
    var infoModel:MyOwnHeader!
    var personDetailModel:PersonDetail!
    private var personInfoTable:UITableView!
    private var personInfoData:[PersonEditInfo]!
    private var personIndexPath:NSIndexPath!

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(title: "编辑个人信息", leftSel: nil, leftTitle: "返回", rightSel: nil)
    }
    
    func turnBack() -> Void {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        self.initializeData()
        self.initializeSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initializeData(){
        if self.personInfoData != nil {
            self.personInfoData = nil
        }
        self.personInfoData = []
        var detailData:[PersonEidtDetail] = []
        var detailModel = PersonEidtDetail(mainTitle: "头像", subItem: self.personDetailModel.headImg, isHeader: true, eidtType: 0, babyId: "")
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "名字", subItem: self.personDetailModel.nickName == "" ? self.infoModel.nickName : self.personDetailModel.nickName, isHeader: false, eidtType: 1, babyId: "")
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "个性签名", subItem: self.personDetailModel.userSign == "" ? self.infoModel.desc : self.personDetailModel.userSign, isHeader: false, eidtType: 2, babyId: "")
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "性别", subItem: Int(self.personDetailModel.sex) == 1 ? "男":"女", isHeader: false, eidtType: 3, babyId: "")
        detailData.append(detailModel)
        
        var district = "广东省 深圳市"
        if let province = CountryCode.shared().findViaAreaCode(self.personDetailModel.provinceCode), let city = CountryCode.shared().findViaAreaCode(self.personDetailModel.cityCode) {
            district = "\(province.codeAreaName) \(city.codeAreaName)"
        }
        
        detailModel = PersonEidtDetail(mainTitle: "地区", subItem: self.personDetailModel.province == "" ? district : "\(self.personDetailModel.province)\(self.personDetailModel.city)", isHeader: false, eidtType: 4, babyId: "")
        detailData.append(detailModel)
        
        var pregStatus = "有宝宝"
        switch self.personDetailModel.breedStatus {
        case "1":
            pregStatus = "正常"
        case "2":
            pregStatus = "备孕"
        case "3":
            pregStatus = "怀孕"
        case "4":
            pregStatus = "有宝宝"
        default:
            break
        }
        detailModel = PersonEidtDetail(mainTitle: "孕育状态", subItem: pregStatus, isHeader: false, eidtType: 5, babyId: "")
        detailData.append(detailModel)
        
        var model = PersonEditInfo(title: "", detail: detailData)
        self.personInfoData.append(model)
        
        BabyList.sendAsyncBabyList { [weak self](errorCode, msg) in
            if let weakSelf = self{
                dispatch_queue_create("babyListQueue", nil).queue({ 
                    if let code = errorCode {
                        if code == BabyZoneConfig.shared.passCode {
                            let babys = BabyListBL.findAll()
                            if babys.count > 0{
                                detailData = []
                                for baby in babys{
                                    detailModel = PersonEidtDetail(mainTitle: baby.babyName, subItem: "姓名/性别/年龄", isHeader: false, eidtType: 6, babyId: baby.idUserBabyInfo)
                                    detailData.append(detailModel)
                                }
                                detailModel = PersonEidtDetail(mainTitle: "添加宝宝", subItem: "更多宝宝", isHeader: false, eidtType: 7, babyId: "")
                                detailData.append(detailModel)
                                
                                model = PersonEditInfo(title: "宝宝", detail: detailData)
                                weakSelf.personInfoData.append(model)
                            }else{
                                detailData = []
                                detailModel = PersonEidtDetail(mainTitle: "添加宝宝", subItem: "更多宝宝", isHeader: false, eidtType: 7, babyId: "")
                                detailData.append(detailModel)
                                
                                model = PersonEditInfo(title: "宝宝", detail: detailData)
                                weakSelf.personInfoData.append(model)
                            }
                        }else{
                            detailData = []
                            detailModel = PersonEidtDetail(mainTitle: "添加宝宝", subItem: "更多宝宝", isHeader: false, eidtType: 7, babyId: "")
                            detailData.append(detailModel)
                            
                            model = PersonEditInfo(title: "宝宝", detail: detailData)
                            weakSelf.personInfoData.append(model)
                        }
                    }else{
                        detailData = []
                        detailModel = PersonEidtDetail(mainTitle: "添加宝宝", subItem: "更多宝宝", isHeader: false, eidtType: 7, babyId: "")
                        detailData.append(detailModel)
                        
                        model = PersonEditInfo(title: "宝宝", detail: detailData)
                        weakSelf.personInfoData.append(model)
                    }
                    if let personTable = weakSelf.personInfoTable{
                        dispatch_get_main_queue().queue({
                            personTable.reloadData()
                        })
                    }
                })
            }
        }
        
    }
    
    private func initializeSubviews(){
        
        self.personInfoTable = UITableView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight - 10), style: .Grouped)
        self.personInfoTable.dataSource = self
        self.personInfoTable.delegate = self
        self.personInfoTable.rowHeight = 50
        self.personInfoTable.separatorInset = UIEdgeInsetsZero
        self.personInfoTable.layoutMargins = UIEdgeInsetsZero
        self.personInfoTable.registerClass(PersonInfoCell.self, forCellReuseIdentifier: PersionInfoTableViewCellId)
        self.view.addSubview(self.personInfoTable)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.personInfoData.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.personInfoData[section]
        return model.detail.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(PersionInfoTableViewCellId) as? PersonInfoCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            resultCell.accessoryType = .DisclosureIndicator
            let model = self.personInfoData[indexPath.section]
            let detailModel = model.detail[indexPath.row]
            resultCell.refreshCell(detailModel)
        }
        
        return cell!
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 30
        }
        return 0.001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header:UIView?
        if section == 1 {
            header = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            header?.backgroundColor = UIColor.hexStringToColor("#60555b")
            let model = self.personInfoData[section]
            let label = UILabel.init(frame: CGRect(x: 20, y: 0, width: header!.frame.width - 40, height: header!.frame.height))
            label.font = UIFont.systemFontOfSize(11)
            label.text = model.title
            label.textColor = UIColor.whiteColor()
            header?.addSubview(label)
        }
        return header
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.personIndexPath = indexPath
        let model = self.personInfoData[indexPath.section]
        let detailModel = model.detail[indexPath.row]
        
        if detailModel.eidtType == 4 {
            let cityPicker = LocationViewController()
            cityPicker.locationInfoHandler = { [weak self](province, city) in
                if let weakSelf = self {
                    if let phone = NSUserDefaults.standardUserDefaults().objectForKey(UserPhoneKey) as? String{
                        if let login = LoginBL.find(nil, key: phone){
                            if let person = PersonDetailBL.find(nil, key: login.userId){
                                HUD.showHud("正在提交...", onView: weakSelf.view)
                                PersonDetail.sendAsyncChangePersonInfo(person.nickName, sex: person.sex, headImg: person.headImg, breedStatus: person.breedStatus, breedStatusDate: person.breedStatusDate, breedBirthDate: person.breedBirthDate, provinceCode: province.codeAreaCode, cityCode: city.codeAreaCode, userSign: person.userSign, completionHandler: { (errorCode, msg) in
                                    HUD.hideHud(weakSelf.view)
                                    if let error = errorCode{
                                        if error == BabyZoneConfig.shared.passCode{
                                            person.province = province.codeAreaName
                                            person.city = city.codeAreaName
                                            PersonDetailBL.modify(person)
                                            if weakSelf.personInfoData.count > 0 && weakSelf.personInfoData[0].detail.count > 0{
                                                weakSelf.personInfoData[0].detail[4].subItem = "\(province.codeAreaName) \(city.codeAreaName)"
                                                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
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
                    }
                }
            }
            self.navigationController?.pushViewController(cityPicker, animated: true)
        }else{
            let editDetail = EditDetailViewController()
            editDetail.editDelegate = self
            editDetail.editModel = detailModel
            editDetail.personDetail = self.personDetailModel
            self.navigationController?.pushViewController(editDetail, animated: true)
        }
    }
    
    func fetchPersonInfo(editModel: PersonEidtDetail) {
        if let tableView = self.personInfoTable {
            var model = self.personInfoData[self.personIndexPath.section]
            model.detail[self.personIndexPath.row] = editModel
            self.personInfoData[self.personIndexPath.section] = model
            tableView.reloadRowsAtIndexPaths([self.personIndexPath], withRowAnimation: .None)
        }
    }
    
    
    func reloadBabySection() {
        if let personTable = self.personInfoTable {
            self.initializeData()
            personTable.reloadData()
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
