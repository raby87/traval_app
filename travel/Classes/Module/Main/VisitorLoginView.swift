//
//  VisitorLoginView.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/27.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

protocol VisitorLoginViewDelegate {
    
    func visitorLoginViewWillRegisitor()
    func visitorLoginViewWillLogin()
}

class VisitorLoginView: UIView {
    
    var isHome:Bool?
    var delegate:VisitorLoginViewDelegate?
    
    // MARK: - 加载UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /// 加载UI界面
    private func setupUI() {
        
        addSubview(iconView)
        addSubview(maskIconView)
        addSubview(houseView)
        addSubview(desLabel)
        addSubview(registerBtn)
        addSubview(loginBtn)
        
        backgroundColor = UIColor(white: 0.93, alpha: 1)
        
        layoutUI()
    }
    
    //判断是不是首页视图
    func setupInfo(isHome:Bool, imageName:String, desString:String) {
        
        desLabel.text = desString
        iconView.image = UIImage(named: imageName)
        
        houseView.hidden = !isHome
        
        isHome ? starAnimation() : sendSubviewToBack(maskIconView)
    }
    
    // MARK: - 给首页添加动画
    private func starAnimation() {
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue             = 2 * M_PI
        anim.duration            = 20.0
        anim.repeatCount         = MAXFLOAT
        anim.removedOnCompletion = false
        
        iconView.layer.addAnimation(anim, forKey: nil)
    
    }
    
    // MARK: - 按钮监听方法
    func clickLoginButton() {
        delegate?.visitorLoginViewWillLogin()
    }
    
    func clickRegisterButton() {
        delegate?.visitorLoginViewWillRegisitor()
    }
    
    // MARK: - 添加自动布局约束
    private func layoutUI() {
        
        //给iconView添加约束
        iconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: iconView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -100))
        
        //给houseView
        houseView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: houseView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: houseView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        //给描述Label添加约束
        desLabel.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: desLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: desLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: iconView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: desLabel, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 225))
        
        //给注册按钮添加约束
        registerBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: desLabel, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: desLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: registerBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 40))
        
        //给登录按钮添加约束
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: desLabel, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: desLabel, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 16))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 100))
        addConstraint(NSLayoutConstraint(item: loginBtn, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 40))
        
        //给遮罩图片添加约束
        maskIconView.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[maskIconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["maskIconView" : maskIconView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[maskIconView]-(-40)-[loginBtn]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["maskIconView" : maskIconView,"loginBtn":loginBtn]))
    }
    
    // MARK: - 懒加载控件
    /// 懒加载访客视图的图标
    lazy private var iconView:UIImageView = {
        
        let iconView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
        
        return iconView
    }()
    
    /// 懒加载遮罩视图
    lazy private var maskIconView:UIImageView = {
        
        let maskIconView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
        
        return maskIconView
    }()
    
    /// 懒加载home页的小房子图标
    lazy private var houseView:UIImageView = {
        
        let houseView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
        
        return houseView
    }()
    
    /// 懒加载描述文本
    lazy private var desLabel:UILabel = {
        
        let desLabel = UILabel()
        
        desLabel.text = "这是一个添加描述的文本Label"
        desLabel.textColor = UIColor.darkGrayColor()
        desLabel.textAlignment = NSTextAlignment.Center
        desLabel.numberOfLines = 0
        desLabel.sizeToFit()
        
        return desLabel
    }()
    
    /// 懒加载注册按钮
    lazy private var registerBtn:UIButton = {
        
        let registerBtn = UIButton()
        
        registerBtn.setTitle("注册", forState: UIControlState.Normal)
        registerBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        registerBtn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        registerBtn.addTarget(self, action:"clickRegisterButton" , forControlEvents: UIControlEvents.TouchUpInside)
        
        return registerBtn
    }()
    
    /// 懒加载登录按钮
    lazy private var loginBtn:UIButton = {
        
        let loginBtn = UIButton()
        
        loginBtn.setTitle("登录", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        loginBtn.setBackgroundImage(UIImage(named: "common_button_white_disable"), forState: UIControlState.Normal)
        
        loginBtn.addTarget(self, action:"clickLoginButton" , forControlEvents: UIControlEvents.TouchUpInside)
        
        return loginBtn
        
    }()
    
    
    
    
}
