//
//  MainViewController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/27.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildViewControllers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        addcomposedBtn()
        
        
    }
    
    /// 撰写按钮的点击事件
    func clickcomposedBtn() {
        
        let vc = userAccount.isLogin ? ComposeViewController() : OAuthViewController()
        
        let nav = UINavigationController(rootViewController: vc)
        
        presentViewController(nav, animated: true, completion: nil)
    
    }
    
    /// 添加撰写按钮
    private func addcomposedBtn() {
        
        let composedBtnW = tabBar.bounds.width / CGFloat(viewControllers!.count)
        
        composedBtn.frame = CGRect(x:2 * composedBtnW, y: 0, width:composedBtnW , height: tabBar.bounds.height)
        
        
    }
    
    /// 批量添加子控制器
    private func addChildViewControllers() {
        
        addChildViewController(HomeTableViewController(), title: "首页", itemIcon: "tabbar_home")
        addChildViewController(DiscoverTableViewController(), title: "发现", itemIcon: "tabbar_discover")
        addChildViewController(UIViewController())
        addChildViewController(MessageTableViewController(), title: "消息", itemIcon: "tabbar_message_center")
        addChildViewController(ProfileTableViewController(), title: "我", itemIcon: "tabbar_profile")
    }
    
    /// 添加视图控制器
    ///
    /// :param: vc       视图控制器类型
    /// :param: title    控制器名称
    /// :param: itemIcon 控制器图标
    private func addChildViewController(vc:UIViewController,title:String,itemIcon:String) {
        
        vc.title = title
        
        vc.tabBarItem.image = UIImage(named: itemIcon)
        
        let nav = UINavigationController(rootViewController: vc)
        
        addChildViewController(nav)
   
    }
    
    /// 懒加载撰写按钮
    lazy private var composedBtn:UIButton = {
        
        let composedBtn = UIButton()
        
        composedBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        composedBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        
        composedBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        composedBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        
        self.tabBar.addSubview(composedBtn)
        
        composedBtn.addTarget(self, action: "clickcomposedBtn", forControlEvents: UIControlEvents.TouchUpInside)
        
        return composedBtn
    }()

}
