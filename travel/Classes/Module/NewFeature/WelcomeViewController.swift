//
//  WelcomeViewController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/31.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SDWebImage

class WelcomeViewController: UIViewController {
    
    var iconConstraint:NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        if let iconURL = userAccount.loadAccount!.avatar_large {
            
            userIcon.sd_setImageWithURL(NSURL(string: iconURL))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        iconConstraint?.constant = -(UIScreen.mainScreen().bounds.height + self.iconConstraint!.constant)
        
        UIView.animateWithDuration(2, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            self.view.layoutIfNeeded()
            
        }) { (Bool) -> Void in
                
            NSNotificationCenter.defaultCenter().postNotificationName(rootViewControllerDisplay, object: true)
        }
        
    }
    
    // MARK: - 准备欢迎界面的UI
    func prepareUI() {
        
        view.addSubview(backImage)
        view.addSubview(userIcon)
        view.addSubview(descLabel)
        
        backImage.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[backImage]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["backImage" : backImage]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[backImage]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["backImage" : backImage]))
        
        userIcon.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: userIcon, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 85))
        view.addConstraint(NSLayoutConstraint(item: userIcon, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 85))
        view.addConstraint(NSLayoutConstraint(item: userIcon, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: userIcon, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -160))
        iconConstraint = view.constraints.last
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: descLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: userIcon, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: descLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: userIcon, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 25))
        
        
    }
    
    // MARK: - 懒加载控件
    private lazy var backImage:UIImageView = {
        
        let backImage = UIImageView(image: UIImage(named: "ad_background"))
        
        return backImage
    }()
    
    private lazy var userIcon:UIImageView = {
        
        let userIcon = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        userIcon.layer.masksToBounds = true
        userIcon.layer.cornerRadius = userIcon.bounds.width * 0.5
        
        return userIcon
    }()
    
    private lazy var descLabel:UILabel = {
        
        let descLabel = UILabel()
        
        descLabel.text = "英雄归来"
        descLabel.sizeToFit()
        
        return descLabel
    }()
}
