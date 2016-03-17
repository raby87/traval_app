//
//  StatusRefreshControl.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/4.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

class StatusRefreshControl: UIRefreshControl {

    override init() {
        super.init()
        
        setupUI()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        addSubview(statusRefreshView)
        
        self.addObserver(self, forKeyPath: "frame", options: NSKeyValueObservingOptions(rawValue: 0), context: nil)
        
        self.tintColor = UIColor.clearColor()
        
        statusRefreshView.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: statusRefreshView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: -statusRefreshView.bounds.width * 0.5))
        addConstraint(NSLayoutConstraint(item: statusRefreshView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: -statusRefreshView.bounds.height * 0.5))
        
}
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if frame.origin.y > 0 {
            return
        }
        
        if refreshing {
            
            statusRefreshView.startLoading()
        }
        
        if frame.origin.y < -60 && statusRefreshView.rotateFlag == false {
            
            statusRefreshView.rotateFlag = true
            
        } else if frame.origin.y > -60 && statusRefreshView.rotateFlag {
            
            statusRefreshView.rotateFlag = false
            
        }
    }
    
    override func endRefreshing() {
        super.endRefreshing()
        
        statusRefreshView.stopLoading()
    }
    
    private lazy var statusRefreshView:StatusRefreshView = {
        
        let statusRefreshView = StatusRefreshView.loadRefreshView()
        
        return statusRefreshView
    }()

}


class StatusRefreshView:UIView {
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var loading: UIImageView!
    @IBOutlet weak var refreshView: UIView!
    
    var rotateFlag = false {
        didSet {
            changeArrowDirection()
        }
    }
    
    class func loadRefreshView() -> StatusRefreshView {
        
        return NSBundle.mainBundle().loadNibNamed("StatusRefreshControl", owner: nil, options: nil).last as! StatusRefreshView
    }
    
    private func changeArrowDirection() {
        
        let angle = rotateFlag ? CGFloat(M_PI - 0.01) : CGFloat(M_PI + 0.01)
        
        UIView.animateWithDuration(0.25) { () -> Void in
            
            self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, angle)
        }
    }
    
    private func startLoading() {
        
        if loading.layer.animationForKey("loading") != nil {
            return
        }
        
        refreshView.hidden = true
        
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        
        anim.toValue = 2 * M_PI
        anim.duration = 1
        anim.repeatCount = MAXFLOAT
        
        loading.layer.addAnimation(anim, forKey: "loading")
    }
    
    private func stopLoading() {
        
        refreshView.hidden = false
        
        loading.layer.removeAllAnimations()
    }
    
    
}