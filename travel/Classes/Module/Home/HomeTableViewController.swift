//
//  HomeTableViewController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/27.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class HomeTableViewController: BaseViewController {
    
    var status:[WeiboStatus]? {
        didSet {
            
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !userAccount.isLogin {
        
            visitorView?.setupInfo(true, imageName: "visitordiscover_feed_image_smallicon", desString: "关注一些人，回这里看看有什么惊喜")
            
            return
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "photoBrowser:", name: StatusCellSelectedPictureNotification, object: nil)
        
        prepareTableView()
        
        loadData()

    }
    
    deinit {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func photoBrowser(noti:NSNotification) {
        
        guard let urls = noti.userInfo![StatusCellSelectedPictureURLs] as? [NSURL] else {
            return
        }
        
        guard let indexPath = noti.userInfo![StatusCellSelectedPictureIndexPath] as? NSIndexPath else {
            return
        }
        
        let photoBrowser = PhotoBrowserController(imageURLs: urls, index: indexPath.item)
        
        presentViewController(photoBrowser, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// 准备tableView的UI和属性
    private func prepareTableView() {
        
        refreshControl = StatusRefreshControl()
        
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.registerClass(StatusNormalCell.self, forCellReuseIdentifier: WeiboStatusCellID.StatusNormalCell.rawValue)
        tableView.registerClass(StatusRetweetedCell.self, forCellReuseIdentifier: WeiboStatusCellID.StatusRetweetedCell.rawValue)
        
        tableView.estimatedRowHeight = 300
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
    }
    
    /// 判断是否是上拉刷新
    private var pullupRefresh = false
    
    /// 刷新微博数据
    func loadData() {
        
        refreshControl?.beginRefreshing()
        
        var since_id = status?.first?.id ?? 0
        var max_id = 0
        
        if pullupRefresh == true {
            
            since_id = 0
            max_id = status?.last?.id ?? 0
        }

        WeiboStatus.getWeiboStatus(since_id, max_id: max_id) { (weiboStatus, error) -> () in
            
            self.refreshControl?.endRefreshing()
            
            if error != nil {
                print(error)
                return
            }
            
            let count = weiboStatus?.count
            
            if since_id > 0 {
                self.showNewStatusTip(count!)
            }
            
            if count == 0 {
                return
            }

            if since_id > 0 {
                
                self.status = weiboStatus! + self.status!
                
            } else if max_id > 0 {
                
                self.status = self.status! + weiboStatus!
                
                self.pullupRefresh = false
                
            } else {
                
                self.status = weiboStatus
            }
        }

    }
    
    /// 显示刷新到几条新微博数据的tip
    ///
    /// :param: count 最新的微博条数
    private func showNewStatusTip(count:Int) {

        tipLabel.text = count == 0 ? "没有最新的微博哦" : "刷新了\(count)条新微博"
        
        let rect = tipLabel.frame
        
        UIView.animateWithDuration(1, animations: { () -> Void in
            
            UIView.setAnimationRepeatAutoreverses(true)
            
            self.tipLabel.frame.origin.y = 44

        }) { (_) -> Void in
                
            self.tipLabel.frame = rect
        }
    }

    // MARK: - TableView 数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return status?.count ?? 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let weiboStatus = status![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(WeiboStatusCellID.cellID(weiboStatus), forIndexPath: indexPath) as! WeiboStatusCell
        
        if status!.count - 1 == indexPath.row {
            
            pullupRefresh = true
            
            loadData()
        }

        cell.weiboStatus = weiboStatus
  
        return cell
    }
    
    /// 计算cell的行高,并缓存
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let weiboStatus = status![indexPath.row]
        
        if let rowHeight = weiboStatus.rowHeight {
            return rowHeight
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(WeiboStatusCellID.cellID(weiboStatus)) as! WeiboStatusCell
        
        weiboStatus.rowHeight = cell.rowHeight(weiboStatus)

        return weiboStatus.rowHeight!
     
    }
    
    // MARK: - 懒加载
    private lazy var tipLabel:UILabel = {
        
        let h:CGFloat = 44
        
        let tipLabel = UILabel(fontSize: 14 , fontColor: UIColor.whiteColor())

        tipLabel.frame = CGRect(x: 0, y: -2 * h, width: UIScreen.mainScreen().bounds.width, height: h)
        tipLabel.backgroundColor = UIColor.orangeColor()
        tipLabel.textAlignment = NSTextAlignment.Center
        
        self.navigationController?.navigationBar.insertSubview(tipLabel, atIndex: 0)
        
        return tipLabel
    }()
}
