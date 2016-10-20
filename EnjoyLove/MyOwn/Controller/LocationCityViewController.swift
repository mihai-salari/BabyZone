//
//  LocationCityViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/20.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let LocationCityTableViewCellId = "LocationCityTableViewCellId"
class LocationCityViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var provincial:Provincial!
    var codeHandler:((provinceCode:CityCode, cityCode:CityCode)->())?
    
    private var cityTable:UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(title: "地区", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.cityTable = UITableView.init(frame: CGRect.init(x: viewOriginX, y: navigationBarHeight, width: self.view.frame.width - 2 * viewOriginX, height: self.view.frame.height - navigationBarHeight), style: .Plain)
        self.cityTable.delegate = self
        self.cityTable.dataSource = self
        self.cityTable.separatorInset = UIEdgeInsetsZero
        self.cityTable.layoutMargins = UIEdgeInsetsZero
        self.cityTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: LocationCityTableViewCellId)
        self.view.addSubview(self.cityTable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.provincial.city.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(LocationCityTableViewCellId)
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            resultCell.textLabel?.text = self.provincial.city[indexPath.row].codeAreaName
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let handle = self.codeHandler {
            handle(provinceCode: self.provincial.province, cityCode: self.provincial.city[indexPath.row])
            if let viewControllers = self.navigationController?.viewControllers {
                self.navigationController?.popToViewController(viewControllers[1], animated: true)
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
