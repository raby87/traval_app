//
//  emoticonAttachment.swift
//  EmoticonKeyboard
//
//  Created by 张鹏 on 15/8/7.
//  Copyright © 2015年 cabbage. All rights reserved.
//

import UIKit

class EmoticonAttachment: NSTextAttachment {
    
    var chs:String?
    
    class func imageText(emoticon:Emoticons,font:UIFont) -> NSMutableAttributedString {
        
        let attachment = EmoticonAttachment()
        
        attachment.chs = emoticon.chs
        
        attachment.image = UIImage(contentsOfFile: emoticon.imagePath)
        
        let lineH = font.lineHeight
        
        attachment.bounds = CGRect(x: 0, y: -3.5, width: lineH, height: lineH)
        
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSMakeRange(0, 1))
        
        return imageText
    }
    
}
