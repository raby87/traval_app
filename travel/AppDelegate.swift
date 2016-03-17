//
//  AppDelegate.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/27.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

let rootViewControllerDisplay = "rootViewControllerDisplay"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var isNewVersion:Bool?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.

        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
        UITabBar.appearance().tintColor = UIColor.orangeColor()
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        window?.rootViewController = displayDefaultRootViewController()
        
        window?.makeKeyAndVisible()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchMainController:", name: rootViewControllerDisplay, object: nil)
        
        return true
    }
    
    /// 根据通知来决定显示访客视图还是欢迎视图
    func switchMainController(noti:NSNotification) {
        
        let mainVc:Bool = noti.object! as! Bool
        
        window?.rootViewController = mainVc ? MainViewController() : WelcomeViewController()
    }
    
    /// 判断用户是否登录
    ///
    /// :returns: 没登录:返回访客界面,登录:返回新特性或者欢迎界面
    func displayDefaultRootViewController() -> UIViewController {
        
        if !userAccount.isLogin {
            
            return MainViewController()
            
        } else {
            
            return judgeNewVersion() ? NewFeatureViewController() : WelcomeViewController()
        } 
    }
    
    /// 判断是不是新版本
    func judgeNewVersion() -> Bool {
        
        let newVersion = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]?.doubleValue
        
        let oldVersionKey = "oldVersionKey"
        let oldVersion = NSUserDefaults.standardUserDefaults().doubleForKey(oldVersionKey)
        
        NSUserDefaults.standardUserDefaults().setDouble(newVersion!, forKey: oldVersionKey)
        
        return newVersion != oldVersion
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    


}

