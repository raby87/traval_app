//
//  StatusNormalCell.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/3.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class StatusNormalCell: WeiboStatusCell {
    
    override func prepareUI() {
        super.prepareUI()
        
        /// 配图的约束
        statusPictureView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: mainTextLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
        statusPictureViewTopCons = contentView.constraints.last
        
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil , attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 280))
        statusPictureViewWidthCons = contentView.constraints.last
        
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil , attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 280))
        statusPictureViewHeightCons = contentView.constraints.last
        

        
    }
    
}
