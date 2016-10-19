//
//  BaseVideoViewController.swift
//  EnjoyLove
//
//  Created by HuangSam on 2016/10/19.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class BaseVideoViewController: BaseViewController {

    var contactsData:[Contact]!
    private var isInitPull:Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.contactsData = []
        if let contacts = FListManager.sharedFList().getContacts() as? [Contact] {
            for contact in contacts  {
                contact.isGettingOnLineState = true
            }
            self.contactsData.appendContentsOf(contacts)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: NET_WORK_CHANGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: "updateContactState", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: "refreshMessage", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: "refreshLocalDevices", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: RECEIVE_REMOTE_MESSAGE, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.onNetWorkChange(_:)), name: ACK_RECEIVE_REMOTE_MESSAGE, object: nil)
        
        if self.isInitPull == false {
            GlobalThread.sharedThread(false).start()
            self.isInitPull = !self.isInitPull
        }
        GlobalThread.sharedThread(false).isPause = false
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        GlobalThread.sharedThread(false).isPause = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:___通知___
    
    func onNetWorkChange(note:NSNotification) -> Void {
        if let parameter = note.userInfo {
            if let statusStr = parameter["status"] as? String {
                if let status = Int(statusStr) {
                    if NetworkStatus.init(status) == NotReachable {
                        
                    }else{
                        var contactIds:[String] = []
                        for contact in self.contactsData {
                            contactIds.append(contact.contactId)
                        }
                        P2PClient.sharedClient().getContactsStates(contactIds)
                    }
                }
            }
        }
    }
    
    func stopAnimating(note:NSNotification) -> Void {
        
    }
    
    func refreshContact(note:NSNotification) -> Void {
        
    }
    
    func refreshLocalDevices(note:NSNotification) -> Void {
        
    }
    
    func receiveRemoteMessage(note:NSNotification) -> Void {
        
    }
    
    func ack_receiveRemoteMessage(note:NSNotification) -> Void {
        
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
