//
//  ProblemViewController.swift
//  EnjoyLove
//
//  Created by 黄漫 on 16/9/13.
//  Copyright © 2016年 HuangSam. All rights reserved.
//

import UIKit

class ProblemViewController: BaseViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationBarItem(self, title: "该阶段常见问题", leftSel: nil, rightSel: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.automaticallyAdjustsScrollViewInsets = false
        var models:[ProblemAge] = []
        for i in 0 ..< 5 {
            var model = ProblemAge()
            model.ageRange = "\(i)~\(i + 6)岁"
            model.problemList = []
            for j in 0 ..< 10 {
                let problem = Problem(mainItem: "玩耍，学习，习惯的养成和教育\(i)~\(i + 6)岁--\(j)", itemCount: "\(j + 200)", itemId: "\(j + 1)")
                model.problemList.append(problem)
            }
            models.append(model)
        }
        
        let problemView = ProblemView.init(frame: CGRectMake(0, navigationBarHeight, self.view.frame.width, ScreenHeight - navigationBarHeight), modelArray: models) { [weak self] (model, indexPath) in
            if let weakSelf = self{
                let detailList = ProblemDetailListViewController()
                detailList.detailListModel = model
                weakSelf.navigationController?.pushViewController(detailList, animated: true)
            }
        }
        self.view.addSubview(problemView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
