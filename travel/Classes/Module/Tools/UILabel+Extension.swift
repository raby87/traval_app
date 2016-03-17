//
//  UILabel+Extension.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/1.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(fontSize:CGFloat,fontColor:UIColor) {
        self.init()
        
        textColor = fontColor
        font = UIFont.systemFontOfSize(fontSize)
  
    }
    
}

