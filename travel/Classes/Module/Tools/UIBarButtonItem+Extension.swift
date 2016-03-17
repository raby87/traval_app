//
//  UIBarButtonItem+Extension.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/5.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    convenience init(imageNmae:String, traget:AnyObject?, action:String?) {
        
        let button = UIButton()
        
        button.setImage(UIImage(named: imageNmae), forState: UIControlState.Normal)
        button.setImage(UIImage(named:imageNmae + "_highlighted"), forState: UIControlState.Highlighted)
        button.sizeToFit()
        
        if let actionName = action {
            
            button.addTarget(traget, action: Selector(actionName), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        self.init(customView:button)
    }
    
    
    
}