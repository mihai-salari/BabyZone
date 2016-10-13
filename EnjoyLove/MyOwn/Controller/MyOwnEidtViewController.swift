//
//  MyOwnEidtViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/17.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let PersionInfoTableViewCellId = "PersionInfoTableViewCellId"

class MyOwnEidtViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource,PersonInfoEditDelegate,ChooseCityDelegate {
    
    var infoModel:MyOwnHeader!
    private var personInfoTable:UITableView!
    private var personInfoData:[PersonEditInfo]!
    private var personIndexPath:NSIndexPath!
    private var editPerson:EditPersonInfo!

    
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
        self.initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func initialize(){
        
        self.personInfoData = []
        
        var detailData:[PersonEidtDetail] = []
        var detailModel = PersonEidtDetail(mainTitle: "头像", subItem: self.infoModel.header, isHeader: true, eidtType: 0)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "名字", subItem: self.infoModel.nickName, isHeader: false, eidtType: 1)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "个性签名", subItem: self.infoModel.desc, isHeader: false, eidtType: 2)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "性别", subItem: "女", isHeader: false, eidtType: 3)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "地区", subItem: "广东深圳市", isHeader: false, eidtType: 4)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "孕育状态", subItem: "有宝宝", isHeader: false, eidtType: 5)
        detailData.append(detailModel)
        
        var model = PersonEditInfo(title: "", detail: detailData)
        self.personInfoData.append(model)
        
        detailData = []
        detailModel = PersonEidtDetail(mainTitle: "宝宝1", subItem: "姓名/性别/年龄", isHeader: false, eidtType: 6)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "宝宝2", subItem: "姓名/性别/年龄", isHeader: false, eidtType: 6)
        detailData.append(detailModel)
        
        detailModel = PersonEidtDetail(mainTitle: "添加宝宝", subItem: "更多宝宝", isHeader: false, eidtType: 7)
        detailData.append(detailModel)
        
        model = PersonEditInfo(title: "宝宝", detail: detailData)
        self.personInfoData.append(model)
        
        self.personInfoTable = UITableView.init(frame: CGRect(x: 10, y: navigationBarHeight, width: self.view.frame.width - 20, height: self.view.frame.height - navigationBarHeight - 10), style: .Grouped)
        self.personInfoTable.dataSource = self
        self.personInfoTable.delegate = self
        self.personInfoTable.separatorInset = UIEdgeInsetsZero
        self.personInfoTable.layoutMargins = UIEdgeInsetsZero
        self.personInfoTable.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0.01))
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
        var cell:PersonInfoCell!
        if let resultCell = tableView.dequeueReusableCellWithIdentifier(PersionInfoTableViewCellId) {
            cell = resultCell as! PersonInfoCell
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            cell.selectionStyle = .None
            cell.accessoryType = .DisclosureIndicator
            let model = self.personInfoData[indexPath.section]
            let detailModel = model.detail[indexPath.row]
            cell.refreshCell(detailModel)
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return upRateHeight(50)
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header:UIView?
        
        if section == 1 {
            header = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 20))
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
            let cityPicker = ChooseCityController()
            cityPicker.delegate = self
            cityPicker.chooseType = ChooseType.init(1)
            let nav = UINavigationController.init(rootViewController: cityPicker)
            self.presentViewController(nav, animated: true, completion: nil)
        }else{
            let editDetail = EditDetailViewController()
            editDetail.editDelegate = self
            editDetail.editModel = detailModel
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
    
    
    func areaPicker(picker: ChooseCityController!, didSelectAddress provinceValue: String!, andCityValue cityValue: String!, andAreaValue areaValue: String!) {
        print("\(provinceValue)")
        print("\(cityValue)")
        print("\(areaValue)")
        picker.dismissViewControllerAnimated(true, completion: nil)
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
