//
//  UIImage+Extension.swift
//  图片选择器
//
//  Created by 张鹏 on 15/8/8.
//  Copyright © 2015年 cabbage. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 对image进行缩放
    ///
    /// :param: width 指定缩放后的宽度
    ///
    /// :returns: 返回缩放后的图片
    func scaleImage(width:CGFloat) -> UIImage {
        
        if size.width < width {
            return self
        }
        
        let scale = size.height / size.width
        
        let height = width * scale
        
        let newSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(newSize)
        
        drawInRect(CGRect(origin: CGPointZero, size: newSize))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image

    }
}
