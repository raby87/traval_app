//
//  UITextView+Extension.swift
//  EmoticonKeyboard
//
//  Created by 张鹏 on 15/8/7.
//  Copyright © 2015年 cabbage. All rights reserved.
//

import UIKit

extension UITextView {
    
    /// textView里面插入一个表情
    ///
    /// :param: emoticon 表情模型
    func insertEmoticon(emoticon:Emoticons) {
        
        if emoticon.removeEmoticon {
            
            deleteBackward()
        }
        
        /// 插入Emoji表情
        if emoticon.emoji != nil {
            replaceRange(selectedTextRange!, withText: emoticon.emoji!)
            
            return
        }
        
        /// 插入png表情
        if emoticon.chs != nil {
            
            let imageText = EmoticonAttachment.imageText(emoticon, font: font!)
            
            let attrString = NSMutableAttributedString(attributedString: attributedText)
            
            attrString.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
            
            let range = selectedRange
            
            attributedText = attrString
            
            selectedRange = NSRange(location: range.location + 1, length: 0)
            
            /// 执行代理方法,隐藏textView的占位文字
            delegate?.textViewDidChange!(self)
        }
  
    }

    
    var emoticonText: String {
        
        let attrString = attributedText
        
        var stringM = String()
        
        attrString.enumerateAttributesInRange(NSMakeRange(0, attrString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict , range , _ ) -> Void in
            
            if let attachment = dict["NSAttachment"] as? EmoticonAttachment {
                
                stringM += attachment.chs!
                
            } else {
                let str = (attrString.string as NSString).substringWithRange(range)
                
                stringM += str
            }
            
        }
        return stringM   
    }
  
}
