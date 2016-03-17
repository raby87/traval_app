//
//  StatusBottomView.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/2.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class StatusBottomView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        
        addSubview(retweetButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        self.backgroundColor = UIColor(white: 0.98, alpha: 1.0)
    
        layout()
    }
    
    /// 添加子控件自动布局
    private func layout() {
        
        retweetButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[retweetButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["retweetButton":retweetButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[commentButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["commentButton":commentButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[likeButton]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["likeButton":likeButton]))
        
        addConstraint(NSLayoutConstraint(item: retweetButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: retweetButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: commentButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: commentButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: retweetButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: commentButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: likeButton, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: commentButton, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))

        
        addConstraint(NSLayoutConstraint(item: retweetButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: commentButton, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: commentButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: likeButton, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: likeButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: retweetButton, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
    }
    
    // MARK: - 懒加载控件
    private lazy var retweetButton:UIButton = UIButton(imageName: "timeline_icon_retweet", title: " 转发")
    
    private lazy var commentButton:UIButton = UIButton(imageName: "timeline_icon_comment", title: " 评论")
    
    private lazy var likeButton:UIButton = UIButton(imageName: "timeline_icon_unlike", title: " 赞")
}
