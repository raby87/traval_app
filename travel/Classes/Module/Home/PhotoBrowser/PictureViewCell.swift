//
//  PictureViewCell.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/9.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SDWebImage

class PictureViewCell: UICollectionViewCell {
    
    var imageURL:NSURL? {
        didSet {
            
            indicator.startAnimating()
            
            imageView.image = nil
            
            resetScroll()
            
            imageView.sd_setImageWithURL(imageURL) { (image, _, _ , _ ) -> Void in
                
                self.indicator.stopAnimating()
                
                if image == nil {
                    return
                }
                
                self.setSetupImage(image)
                
            }

        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        perpareUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置图像的大小和位置
    private func setSetupImage(image:UIImage) {
        
        let imageScale = image.size.width / image.size.height
        
        if imageScale > 1 {
            
            let imageW = UIScreen.mainScreen().bounds.width
            let imageH = imageW / imageScale
            let imageX:CGFloat = 0
            let imageY = (UIScreen.mainScreen().bounds.height - imageH) * 0.5
            
            resetScroll()
            
            self.imageView.frame = CGRect(origin: CGPointMake(imageX, imageY), size: CGSizeMake(imageW, imageH))
            
            
        } else {
            
            let imageW = UIScreen.mainScreen().bounds.width
            let imageH = imageW / imageScale
            let imageX:CGFloat = 0
            let imageY:CGFloat = imageH < UIScreen.mainScreen().bounds.height ? (UIScreen.mainScreen().bounds.height - imageH) * 0.5 : 0

            self.imageView.frame = CGRect(origin: CGPointMake(imageX, imageY), size: CGSizeMake(imageW, imageH))
            self.scrollView.contentSize = CGSizeMake(imageW, imageH)
        }
        
    }
    
    /// 重置scrollView的属性
    private func resetScroll() {
        
        scrollView.zoomScale = 1
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentOffset = CGPointZero
        scrollView.contentSize = CGSizeZero
        
    }
    
    /// 准备UI
    private func perpareUI() {
        
        contentView.addSubview(scrollView)
        scrollView.addSubview(imageView)
        contentView.addSubview(indicator)
        
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.0
        scrollView.maximumZoomScale = 2.0
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView":scrollView]))
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        contentView.addConstraint(NSLayoutConstraint(item: indicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        
    }
    
    // MARK: - 懒加载
    private lazy var scrollView:UIScrollView = UIScrollView()
    lazy var imageView:UIImageView = UIImageView()
    private lazy var indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
}

extension PictureViewCell: UIScrollViewDelegate {
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return imageView
    }
    
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        print(scale)
        
        UIView.animateWithDuration(0.1) { () -> Void in
            
            let imageW = self.imageView.frame.width
            let imageH = self.imageView.frame.height
            
            let imageScale = imageW / imageH

            if imageW < UIScreen.mainScreen().bounds.width {
                
                self.setSetupImage(self.imageView.image!)
                
            } else {
                
                if imageScale > 1 {
                    
                    let imageY = ((UIScreen.mainScreen().bounds.height - imageH) * 0.5 < 0) ? 0 : (UIScreen.mainScreen().bounds.height - imageH) * 0.5
                    
                    self.imageView.frame = CGRectMake(0, imageY, imageW, imageH)
                    
                    scrollView.contentSize = CGSizeMake(imageW, imageH)
                    
                } else {
                    
                    self.imageView.frame = CGRect(origin: CGPointMake(0, 0), size: CGSizeMake(imageW, imageH))
                    self.scrollView.contentSize = CGSizeMake(imageW, imageH)
                    
                }
                
            }
 
        }
 
    }
    
    
    
    
    
}
