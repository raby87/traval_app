//
//  BaseViewController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/27.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class BaseViewController: UITableViewController,VisitorLoginViewDelegate {
    
    var isLogin:Bool = userAccount.isLogin
    var visitorView:VisitorLoginView?
    
    /// 加载根控制器
    override func loadView() {
        
        isLogin ? super.loadView() : setupVisitorView()
        
    }
    
    /// 加载访客视图,并且设置nav控制器的左右按钮
    private func setupVisitorView() {
        
        visitorView = VisitorLoginView()
        view = visitorView
        
        visitorView?.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillRegisitor")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: "visitorLoginViewWillLogin")
        
    }
    
    // MARK: - 注册和登录按钮的点击事件
    func visitorLoginViewWillRegisitor() {
        
        
    }
    
    func visitorLoginViewWillLogin() {
        
        let nav = UINavigationController(rootViewController: OAuthViewController())

        presentViewController(nav, animated: true, completion: nil)
    }
}
