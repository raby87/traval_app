//
//  userAccount.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/30.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class userAccount: NSObject,NSCoding {
    
    var access_token: String?
    var expires_in: NSTimeInterval = 0
    var uid: String?
    var name: String?
    var avatar_large: String?
    
    class var isLogin:Bool {
        
        return loadAccount != nil
    }
    
    init(dict:[String:AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        userAccount.userAccountInfo = self
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    

    // 归档路径
    static private let archiverPath = (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last! as NSString).stringByAppendingPathComponent("userAccount.data")
    
    /// 保存用户信息
    func saveAccount() {
        
        NSKeyedArchiver.archiveRootObject(self, toFile:userAccount.archiverPath)
        
    }
    
    /// 使用令牌从服务器获取用户的信息,并且给自己赋值并归档
    func loadUserInfo(completion:(error:NSError?) -> ()) {
        
        NetworkTools.sharedNetworkToos.getUserInfo { (json, error) -> () in
            
            if error != nil {
                
                completion(error: error)
                return
            }
            
            self.name = json!["name"] as? String
            self.avatar_large = json!["avatar_large"] as? String
            
            self.saveAccount()

            completion(error: nil)
            
        }
    }
    
    //提供一个外部访问的接口,如果内存中没有用户信息,则从沙盒中读取,沙盒中也没的话,返回是nil
    private static var userAccountInfo:userAccount?
    class var loadAccount:userAccount? {
//        print(userAccount.archiverPath)
        
        if userAccountInfo == nil {
            
            userAccountInfo = NSKeyedUnarchiver.unarchiveObjectWithFile(archiverPath) as? userAccount
        }
        
        return userAccountInfo
    }
    
    // MARK: - 归档解档
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(access_token, forKey: "access_token")
        aCoder.encodeDouble(expires_in, forKey: "expires_in")
        aCoder.encodeObject(uid, forKey: "uid")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(avatar_large, forKey: "avatar_large")
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        access_token = aDecoder.decodeObjectForKey("access_token") as? String
        expires_in = aDecoder.decodeDoubleForKey("expires_in")
        uid = aDecoder.decodeObjectForKey("uid") as? String
        name = aDecoder.decodeObjectForKey("name") as? String
        avatar_large = aDecoder.decodeObjectForKey("avatar_large") as? String
    }
    
}
