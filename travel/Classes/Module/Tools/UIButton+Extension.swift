//
//  UIButton+Extension.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/2.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

extension UIButton {
    
    convenience init(imageName:String,title:String,fontSize:CGFloat = 14,fontColor:UIColor = UIColor.darkGrayColor()) {
        self.init()
        
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setTitle(title, forState: UIControlState.Normal)
        setTitleColor(fontColor, forState: UIControlState.Normal)
        titleLabel?.font = UIFont.systemFontOfSize(fontSize)  
    }
    
    convenience init(imageName:String) {
        self.init()
        
        setImage(imageName)
        
    }
    
    func setImage(imageName:String) {
        
        setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        setImage(UIImage(named: imageName + "_highlighted"), forState: UIControlState.Highlighted)
    }
    
}
