//
//  weiboStatus.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/1.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SDWebImage

class WeiboStatus: NSObject {
    
     /// 微博创建时间
    var created_at:String? {
        didSet {
            
            print(created_at)
            
        }
    }
     /// 微博ID
    var id:Int = 0
     /// 微博信息内容
    var text:String?
     /// 微博来源
    var source:String? {
        didSet {
            
            source = source?.herfLink()

            //"<a href=\"http://weibo.com/\" rel=\"nofollow\">微博 weibo.com</a>"
        }
    }
     /// 配图数组
    var pic_urls:[[String:AnyObject]]? {
        didSet {
            
            if pic_urls!.count == 0 {
                return
            }
            
            normal_picURL = [NSURL]()
            large_picURL = [NSURL]()
            
            for dic in pic_urls! {
                
                if let stringURL = dic["thumbnail_pic"] as? String {
                    normal_picURL?.append(NSURL(string: stringURL)!)
                    
                    let largeURl = stringURL.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                    large_picURL?.append(NSURL(string: largeURl)!)
                    
                }
            }
        }
    }
    
    /// 配图的URL地址
    var pictureURL:[NSURL]? {
        return retweeted_status == nil ? normal_picURL : retweeted_status?.normal_picURL

    }
    /// 配图的大图的URL地址
    var largePictureURL:[NSURL]? {
        return retweeted_status == nil ? large_picURL : retweeted_status?.large_picURL
    }
    /// 微博的配图
    var normal_picURL:[NSURL]?
    /// 微博大图
    var large_picURL:[NSURL]?
    /// 转发的weibo模型
    var retweeted_status: WeiboStatus?
    /// 用户信息模型
    var user:User?
    /// 保存行高
    var rowHeight:CGFloat?
    
    
    
    init(dict:[String:AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if key == "user" {
            
            if let userDic = value as? [String:AnyObject] {
                
                user = User(dict: userDic)
            }
            return
        }
        
        if key == "retweeted_status" {
            
            if let retweetedDic = value as? [String:AnyObject] {
                
                retweeted_status = WeiboStatus(dict: retweetedDic)
            }
            return    
        }
        
        super.setValue(value, forKey: key)
        
    }
    
    class func getWeiboStatus(since_id:Int, max_id:Int,completion:(weiboStatus:[WeiboStatus]?,error:NSError?) -> ()) {
        
        NetworkTools.sharedNetworkToos.getWeiboStatus(since_id, max_id: max_id) { (json, error) -> () in
            if error != nil {
                
                completion(weiboStatus: nil, error: error)
                return
            }
            
            if let array = json?["statuses"] as? [[String:AnyObject]] {
                
                var list = [WeiboStatus]()
                
                for dic in array {
                    
                    list.append(WeiboStatus(dict: dic))
                }
                
                completion(weiboStatus: list, error: nil)
                
            }
        }

        }
        

    
    private func cacheImage(list:[WeiboStatus],completion:(weiboStatus:[WeiboStatus]?,error:NSError?) -> ()) {
        
        let group = dispatch_group_create()
        
        for status in list {
            
            guard let urls = status.pictureURL else {
                continue
            }
            
            for imageURL in urls {
                
                dispatch_group_enter(group)
                
                SDWebImageManager.sharedManager().downloadImageWithURL(imageURL, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _ , _ , _ , _ ) -> Void in
                    
                })
                dispatch_group_leave(group)
   
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            
            completion(weiboStatus: list, error: nil)
        }  
    }
    
    
}
