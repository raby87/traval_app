//
//  StatusTopView.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/1.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SDWebImage

class StatusTopView: UIView {
    
    /// 设置控件的属性
    var weiboStatus:WeiboStatus? {
        didSet {
            
            if let iconURL = weiboStatus?.user?.profile_image_url {
                
                iconImage.sd_setImageWithURL(NSURL(string: iconURL))
            }
            
            vipView.image = weiboStatus?.user?.vipImage
            verifiedView.image = weiboStatus?.user?.verifiedImage
            
            nameLabel.text = weiboStatus?.user?.name
            timeLabel.text = NSDate.sinaDate(weiboStatus?.created_at ?? "")?.dateDescription
            sourceLabel.text = weiboStatus?.source
            
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 安装UI到topView
    private func setupUI() {
        
        addSubview(iconImage)
        addSubview(nameLabel)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(vipView)
        addSubview(verifiedView)
 
        layout()
  
    }
    
    /// 自动布局子控件
    private func layout() {
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconImage, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 8))
        addConstraint(NSLayoutConstraint(item: iconImage, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 8))
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: iconImage, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 12))
        addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconImage, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        
        vipView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: vipView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: nameLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 8))
        addConstraint(NSLayoutConstraint(item: vipView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: nameLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        verifiedView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: verifiedView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconImage, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: verifiedView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: iconImage, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 12))
        addConstraint(NSLayoutConstraint(item: timeLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: iconImage, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: -2))
        
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: sourceLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: timeLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 12))
        addConstraint(NSLayoutConstraint(item: sourceLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: timeLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
  
    }
    
    // MARK: - 懒加载子控件
    private lazy var iconImage:UIImageView = UIImageView()
    
    private lazy var nameLabel:UILabel = UILabel(fontSize: 18, fontColor: UIColor.blackColor())
    
    private lazy var timeLabel:UILabel = UILabel(fontSize: 12, fontColor: UIColor.orangeColor())
    
    private lazy var sourceLabel:UILabel = UILabel(fontSize: 12, fontColor: UIColor.grayColor())
    
    private lazy var vipView:UIImageView = UIImageView()
    
    private lazy var verifiedView:UIImageView = UIImageView()
    
}
