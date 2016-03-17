//
//  Emoticons.swift
//  EmoticonKeyboard
//
//  Created by 张鹏 on 15/8/6.
//  Copyright © 2015年 cabbage. All rights reserved.
//

import UIKit

class EmoticonPackage:NSObject {
    
    /// 表情包的id
    var id:String?
    /// 表情包的组名
    var groupName:String = ""
    /// 表情组
    var emoticons:[Emoticons]?
    
    init(id:String,groupName:String = "") {
        self.id = id
    }
    
    class func package() -> [EmoticonPackage] {
        
        let packagePath = (bundlePath as NSString).stringByAppendingPathComponent("emoticons.plist")
        
        let dict = NSDictionary(contentsOfFile: packagePath)!
        
        let array = dict["packages"] as! [[String:AnyObject]]
        
        var arrayM = [EmoticonPackage]()
        
        arrayM.append (EmoticonPackage(id: "", groupName: "最近").loadEmptyEmoticons())
        
        for dic in array {
            
            let id = dic["id"] as! String
            arrayM.append( EmoticonPackage(id: id).loadEmoticons().loadEmptyEmoticons() )
        }
        return arrayM
    }
    
    /// 把表情模型转换成表情字符串
    class func emoticonString(string:String,font:UIFont) -> NSMutableAttributedString {
        
        let pattern = "\\[.*?\\]"
        
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        let results = regular.matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, string.characters.count))
        
        var count = results.count
        
        let stringM = NSMutableAttributedString(string: string)
        
        while count > 0 {
            
            let result = results[--count]
            let range = result.rangeAtIndex(0)
            
            let emString = (string as NSString).substringWithRange(range)
            
            if let emoticon = EmoticonPackage.emoticon(string: emString) {
                
                let imageText = EmoticonAttachment.imageText(emoticon, font:font )
                
                stringM.replaceCharactersInRange(range, withAttributedString: imageText)
            }
        }
        
        return stringM
    }
    
    /// 根据字符串返回对应的表情模型
    private class func emoticon(string string:String) -> Emoticons? {
        
        var emoticon:Emoticons?
        
        for p in EmoticonPackage.package() {
            
            emoticon = p.emoticons!.filter { $0.chs == string }.last
            
            if emoticon != nil {
                break
            }
        }
        
        return emoticon
        
        
    }
    
    /// 加载表情数组
    private func loadEmoticons() -> Self {
    
        let emoticonsPath = (EmoticonPackage.bundlePath.stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent("info.plist")
    
        let dict = NSDictionary(contentsOfFile: emoticonsPath)!
        
        groupName = dict["group_name_cn"] as! String
        let array = dict["emoticons"] as! [[String:String]]
        
        emoticons = [Emoticons]()
        
        var index = 0
        for dic in array {
            
            emoticons?.append(Emoticons(id: id!, dict: dic))
            
            if ++index == 20 {
                emoticons?.append(Emoticons(remove: true))
                index = 0
            }
        }
        
        return self
    }
    
    /// 添加空的表情
    private func loadEmptyEmoticons() -> Self {
        
        if emoticons == nil {
            emoticons = [Emoticons]()
        }
        
        let count = emoticons!.count % 21
        
        if count > 0 || emoticons?.count == 0 {
            for _ in count ..< 20 {
                emoticons?.append(Emoticons(remove: false))
            }
            
            emoticons?.append(Emoticons(remove: true))
        }
        return self
        
    }
    
    
    static let bundlePath:NSString = (NSBundle.mainBundle().bundlePath as NSString).stringByAppendingPathComponent("Emoticons.bundle")
}


class Emoticons: NSObject {
    
    /// 表情包id
    var id:String?
    /// 发送给服务器的表情字符串
    var chs:String?
    /// 本地的表情名称
    var png:String?
    /// 本地表情的路径
    var imagePath:String {
        if png == nil {
            return ""
        }
       return (EmoticonPackage.bundlePath.stringByAppendingPathComponent(id!) as NSString).stringByAppendingPathComponent(png!)
    
    }
    /// Emoji表情的code
    var code:String? {
        didSet {
            
            let scanner = NSScanner(string: code!)
            var value:UInt32 = 0
            scanner.scanHexInt(&value)
            
            emoji = String(Character(UnicodeScalar(value)))
        }
    }
    /// Emoji表情的Unicode的编码String
    var emoji:String?
    
    var removeEmoticon:Bool = false
    
    init(remove:Bool) {
        removeEmoticon = remove
    }
    
    init(id:String,dict:[String:String]) {
        self.id = id
        
        super.init()
        
        setValuesForKeysWithDictionary(dict)
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
}
