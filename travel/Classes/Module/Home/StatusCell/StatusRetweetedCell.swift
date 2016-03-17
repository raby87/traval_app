//
//  StatusRetweetedCell.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/3.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class StatusRetweetedCell: WeiboStatusCell {
    
    override var weiboStatus:WeiboStatus? {
        didSet {
            
            let name = weiboStatus?.retweeted_status?.user?.name ?? ""
            let desc = weiboStatus?.retweeted_status?.text ?? ""
            
            retweetedLabel.text = "@" + "\(name)" + ":" + "\(desc)"
            
            
        }
    }
    
    /// 准备转发微博的cell里面的UI
    override func prepareUI() {
        super.prepareUI()
        
        contentView.insertSubview(backButton, belowSubview: statusPictureView)
        contentView.insertSubview(retweetedLabel, aboveSubview: statusPictureView)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[backButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["backButton":backButton]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[mainTextLabel]-8-[backButton]-0-[statusBottomView]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["mainTextLabel":mainTextLabel,"backButton":backButton,"statusBottomView":statusBottomView]))
        
        retweetedLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: retweetedLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: backButton, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: retweetedLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: backButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 8))

        
        /// 配图的约束
        statusPictureView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: retweetedLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
        statusPictureViewTopCons = contentView.constraints.last
        
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: backButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil , attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 280))
        statusPictureViewWidthCons = contentView.constraints.last
        
        contentView.addConstraint(NSLayoutConstraint(item: statusPictureView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil , attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 280))
        statusPictureViewHeightCons = contentView.constraints.last
        
        
    }
    
    // MARK: - 懒加载
    private lazy var retweetedLabel:UILabel = {
        
        let retweetedLabel = UILabel(fontSize: 14, fontColor: UIColor.darkGrayColor())
        
        retweetedLabel.numberOfLines = 0
        retweetedLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 16
        
        return retweetedLabel
    }()
    
    private lazy var backButton:UIButton = {
        
        let backButton = UIButton()
        
        backButton.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        return backButton
   
    }()
}
