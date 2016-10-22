//
//  AddressBookViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 16/9/23.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

private let AddressBookTableViewCellId = "AddressBookTableViewCellId"

class AddressBookViewController: BaseViewController,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource {

    private var sortModelData:[String : [AnyObject]]!
    private var indexData:[String]!
    private var searchResultData:[HMPersonModel]!
    var selectCompletionHandler:((model:HMPersonModel)->())?
    
    
    private lazy var searchTable:UITableView = {
        let tableView = UITableView.init(frame: CGRect(x: 0, y: navigationBarHeight, width: ScreenWidth, height: ScreenHeight - navigationBarHeight), style: .Plain)
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(AddressBookTableViewCell.self, forCellReuseIdentifier: AddressBookTableViewCellId)
        return tableView
    }()
    
    private lazy var searchController:UISearchController = {
        let controller = UISearchController.init(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "搜索"
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.automaticallyAdjustsScrollViewInsets = false
        self.navigationBarItem(self, title: "查看通讯录", leftSel: nil, rightSel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchResultData = []
        self.view.addSubview(self.searchTable)
        self.searchTable.tableHeaderView = self.searchController.searchBar
        
        HMAddressBook.requestAddressBookAuthorization {[weak self] (success:Bool, addressbookDict:[String : [AnyObject]]!, indexs:[AnyObject]!) in
            if let weakSelf = self{
                weakSelf.sortModelData = addressbookDict
                weakSelf.indexData = indexs as! [String]
                weakSelf.searchTable.reloadData()
            }
        }
        
        HMAddressBook.getOrderAddressBook({ [weak self](addressBookDict:[String : [AnyObject]]!, peopleNameKey:[AnyObject]!) in
            if let weakSelf = self{
                weakSelf.sortModelData = addressBookDict
                weakSelf.indexData = peopleNameKey as! [String]
                weakSelf.searchTable.reloadData()
            }
            }) {}
        
    }
    
    deinit {
        self.searchResultData = nil
        self.sortModelData = nil
        self.indexData = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.searchController.active == false {
            return self.indexData != nil ? self.indexData.count : 0
        }
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchController.active == false {
            if let sortData = self.sortModelData{
                let addressbook = sortData[self.indexData[section]] as! [HMPersonModel]
                return addressbook.count
            }
        }
        return self.searchResultData != nil ? self.searchResultData.count : 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.searchController.active == false {
            let view = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
            view.backgroundColor = UIColor.hexStringToColor("#60555b")
            let indexTitle = self.indexData != nil ? self.indexData[section] : ""
            let label = UILabel.init(frame: CGRect(x: 20, y: 0, width: view.frame.width - 20, height: view.frame.height))
            label.font = UIFont.systemFontOfSize(15)
            label.text = indexTitle
            label.textColor = UIColor.whiteColor()
            view.addSubview(label)
            return view
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.searchController.active == false {
            return 30
        }
        return 0.001
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        if self.searchController.active == false {
            return self.indexData != nil ? self.indexData : nil
        }
        return nil
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(AddressBookTableViewCellId) as? AddressBookTableViewCell
        if let resultCell = cell {
            resultCell.separatorInset = UIEdgeInsetsZero
            resultCell.layoutMargins = UIEdgeInsetsZero
            resultCell.selectionStyle = .None
            if self.searchController.active == false {
                if let sortData = self.sortModelData {
                    let models = sortData[self.indexData[indexPath.section]] as! [HMPersonModel]
                    resultCell.refreshCell(models[indexPath.row], addCompletionHandler: { (model) in
                        
                    })
                }
            }else{
                if let searchData = self.searchResultData {
                    let model = searchData[indexPath.row]
                    resultCell.refreshCell(model, addCompletionHandler: { (model) in
                        
                    })
                }
            }
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        tableView.scrollToRowAtIndexPath(NSIndexPath.init(forRow: 0, inSection: index), atScrollPosition: .Top, animated: true)
        return index
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.searchController.active == false {
            let values = self.sortModelData[self.indexData[indexPath.section]]
            if let handler = self.selectCompletionHandler , let value = values as? [HMPersonModel] {
                handler(model: value[indexPath.row])
            }
        }else{
            if let handler = self.selectCompletionHandler , let value = self.searchResultData {
                handler(model: value[indexPath.row])
            }
        }
        self.searchController.active = false
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let sortData = self.sortModelData , var searchData = self.searchResultData {
            searchData.removeAll()
            var arr = HMSortString.getAllValuesFromDict(sortData) as! [HMPersonModel]
            if searchController.searchBar.text?.characters.count == 0 {
                searchData.appendContentsOf(arr)
            }else{
                arr = ZYPinYinSearch.searchWithOriginalArray(arr, andSearchText: searchController.searchBar.text, andSearchByPropertyName: "name") as! [HMPersonModel]
                searchData.appendContentsOf(arr)
            }
            self.searchResultData = searchData
            self.searchTable.reloadData()
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
