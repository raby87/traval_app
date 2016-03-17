//
//  NSString+Extension.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/11.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

extension String {
    
    func herfLink() ->String? {
        
        //"<a href=\"http://weibo.com/\" rel=\"nofollow\">微博 weibo.com</a>"
        
        let pattern = "<a.*?>(.*?)</a>"
        
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        if let results = regular.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) {
            
            let range = results.rangeAtIndex(1)
            
            let text = (self as NSString).substringWithRange(range)
            
            return text
        }
        
        return nil
        
    }
  
}
