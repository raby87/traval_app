//
//  NSDate+Extension.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/11.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

extension NSDate {
    
    class func sinaDate(string:String) -> NSDate? {
        
        let formatter = NSDateFormatter()
        
        formatter.locale = NSLocale(localeIdentifier: "en")
        
        formatter.dateFormat = "EEE MMM dd HH:mm:ss zzz yyyy"
        
        return formatter.dateFromString(string)
    }
    
    var dateDescription:String {
        
        let calendar = NSCalendar.currentCalendar()
        
        if calendar.isDateInToday(self) {
            
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            
            if delta < 60 {
                return "刚刚"
            }
            if delta < 3600 {
                return "\(delta/60)分钟前"
            }
            return "\(delta/3600)小时前"
        }
        
        var fmString = "HH:mm"
        
        if calendar.isDateInYesterday(self) {
            
            fmString = "昨天" + fmString
            
        } else {
            
            fmString = "MM-dd" + fmString
            
            let coms = calendar.components(NSCalendarUnit.Year, fromDate: self, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            
            if coms.year > 0 {
                fmString = "yyyy" + fmString
            }
        }
        
        let format = NSDateFormatter()
        
        format.locale = NSLocale(localeIdentifier: "en")
        
        format.dateFormat = fmString
        
        return format.stringFromDate(self)
    }
    
    
    
}
