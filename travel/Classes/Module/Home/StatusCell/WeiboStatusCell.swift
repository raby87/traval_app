//
//  weiboStatusCell.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/1.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

/// 枚举微博cell的reuseID
///
/// - StatusRetweetedCell: 转发的微博的cell的reuseID
/// - StatusNormalCell:    原创的微博的cell的reuseID
enum WeiboStatusCellID:String {
    case StatusRetweetedCell = "StatusRetweetedCell"
    case StatusNormalCell = "StatusNormalCell"
    
    static func cellID(weiboStatus:WeiboStatus) -> String {
        
        return weiboStatus.retweeted_status == nil ? WeiboStatusCellID.StatusNormalCell.rawValue : WeiboStatusCellID.StatusRetweetedCell.rawValue
        
    }
}

class WeiboStatusCell: UITableViewCell {
    
    var weiboStatus:WeiboStatus? {
        didSet {
            
            spaceView.backgroundColor = UIColor(white: 0.90, alpha: 1.0)
            
            statusTopView.weiboStatus = weiboStatus
            
            mainTextLabel.attributedText = EmoticonPackage.emoticonString(weiboStatus!.text!, font: mainTextLabel.font)
            
            statusPictureView.weiboStatus = weiboStatus
            
            statusPictureViewWidthCons?.constant = statusPictureView.bounds.width
            statusPictureViewHeightCons?.constant = statusPictureView.bounds.height
            statusPictureViewTopCons?.constant = statusPictureView.bounds.height == 0 ? 0 : 8
        }
    }
    
    var statusPictureViewWidthCons:NSLayoutConstraint?
    
    var statusPictureViewHeightCons:NSLayoutConstraint?
    
    var statusPictureViewTopCons:NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        prepareUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// cell准备UI里面的子控件
    func prepareUI() {
        
        contentView.addSubview(statusTopView)
        contentView.addSubview(mainTextLabel)
        contentView.addSubview(statusPictureView)
        contentView.addSubview(statusBottomView)
        contentView.addSubview(spaceView)

        layout()
        
    }
    
    /// 计算微博cell行高
    func rowHeight(weiboStatus: WeiboStatus) -> CGFloat {

        self.weiboStatus = weiboStatus

        layoutIfNeeded()

        return CGRectGetMaxY(spaceView.frame)
    }
    
    /// 添加自动布局约束
    private func layout() {
        
        statusTopView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: statusTopView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: statusTopView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: statusTopView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 70))
        
        mainTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: mainTextLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: statusTopView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: mainTextLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 8))
        
        statusBottomView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: statusBottomView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: statusPictureView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 8))
        contentView.addConstraint(NSLayoutConstraint(item: statusBottomView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: statusBottomView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 44))
        
        spaceView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: spaceView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: statusBottomView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: spaceView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: spaceView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 8))

        
    }
    
    // MARK: - 懒加载顶部视图,底部视图以及正文
    lazy var spaceView:UIView = UIView()
    
    private lazy var statusTopView:StatusTopView = StatusTopView()
    
    lazy var mainTextLabel:FFLabel = {
        let mainTextLabel = FFLabel(fontSize: 15, fontColor: UIColor.darkGrayColor())
        mainTextLabel.numberOfLines = 0
        
        mainTextLabel.preferredMaxLayoutWidth = UIScreen.mainScreen().bounds.width - 16
        
        return mainTextLabel
    }()
    
    lazy var statusPictureView:StatusPictureView = StatusPictureView()
    
    lazy var statusBottomView:StatusBottomView = StatusBottomView()
    

}
