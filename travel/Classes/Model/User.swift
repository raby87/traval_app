//
//  user.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/1.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class User: NSObject {
    
    /// 用户昵称
    var name:String?
    /// 用户头像地址（中图），50×50像素
    var profile_image_url:String?
    /// 用户vip等级 1-6级
    var mbrank:Int = -1
    /// 根据用户vip等级来显示vip等级图标
    var vipImage:UIImage? {
            if mbrank > 0 && mbrank < 7 {
                return UIImage(named: "common_icon_membership_level\(mbrank)")
            } else {
                return UIImage(named: "common_icon_membership_expired")
            }
    }

    /// 认证用户
    var verified_type:Int = -1
    
    var verifiedImage:UIImage? {
        switch verified_type {
            
        case 0:     return UIImage(named: "avatar_vip")
        case 2,3,5: return UIImage(named: "avatar_enterprise_vip")
        case 220:   return UIImage(named: "avatar_grassroot")
        default:    return nil
        }
    }
    
    init(dict:[String:AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)   
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}

}
