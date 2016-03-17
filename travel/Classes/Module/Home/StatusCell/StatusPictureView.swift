//
//  PictureView.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/3.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SDWebImage

let StatusCellSelectedPictureNotification = "StatusCellSelectedPictureNotification"
let StatusCellSelectedPictureURLs = "StatusCellSelectedPictureURLs"
let StatusCellSelectedPictureIndexPath = "StatusCellSelectedPictureIndexPath"

private let statusPictureViewCellReuseID = "statusPictureViewCellReuseID"

class StatusPictureView:UICollectionView {
    
    var weiboStatus:WeiboStatus? {
        didSet {
            
            sizeToFit()
            
            reloadData()
            
        }
    }
    
    override func sizeThatFits(size: CGSize) -> CGSize {
        
        return calcSize()
    }
    
    /// 计算pictureView的大小
    ///
    /// :returns: 返回picture的size
    private func calcSize() -> CGSize {
        
        let itemSize = CGSize(width: 90 , height: 90 )
        
        let rowCount = 3
        
        let margin:CGFloat = 5
        
        StatusPictureViewLayout.itemSize = itemSize
        
        let imageCount = weiboStatus?.pictureURL?.count ?? 0
        
        if imageCount == 0 {
            return CGSizeZero
        }
        
        if imageCount == 1 {
            
            let key = weiboStatus?.pictureURL![0].absoluteString
            
            let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(key)
            
            var size = CGSize(width: 110 , height: 90 )
            
            if image != nil {
                size = image.size
            }
            
            size.width = size.width < 40 ? 60 : size.width
            size.width = size.width > UIScreen.mainScreen().bounds.width ? 150 : size.width
            
            StatusPictureViewLayout.itemSize = size

        return size
        }
        
        if imageCount == 4 {
            return CGSize(width: 2.0 * itemSize.width + 2.0 * margin, height: 2.0 * itemSize.width + 2.0 * margin)
        }
        
        let row = (imageCount - 1) / rowCount + 1
        
        let w = itemSize.width * CGFloat(rowCount) + margin * CGFloat(rowCount - 1)
        let h = itemSize.height * CGFloat(row) + margin * CGFloat(row - 1)

        return CGSize(width: w , height:h )
    }
    
    private let StatusPictureViewLayout = UICollectionViewFlowLayout() 

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: StatusPictureViewLayout)
        
        StatusPictureViewLayout.minimumLineSpacing = 5
        StatusPictureViewLayout.minimumInteritemSpacing = 5
        backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        
        registerClass(StatusPictureViewCell.self, forCellWithReuseIdentifier: statusPictureViewCellReuseID)
        
        self.dataSource = self
        self.delegate = self
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   

}

/// pictureView数据源方法
extension StatusPictureView: UICollectionViewDataSource ,UICollectionViewDelegate{
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        NSNotificationCenter.defaultCenter().postNotificationName(StatusCellSelectedPictureNotification, object: self, userInfo: [StatusCellSelectedPictureURLs:weiboStatus!.largePictureURL!, StatusCellSelectedPictureIndexPath:indexPath])
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return weiboStatus?.pictureURL?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(statusPictureViewCellReuseID, forIndexPath: indexPath) as! StatusPictureViewCell
        
        cell.picURL = weiboStatus!.pictureURL![indexPath.item]

        return cell
    }
}

/// 微博配图collectionView的cell类
class StatusPictureViewCell:UICollectionViewCell {
    
    var picURL:NSURL? {
        didSet {
            iconView.sd_setImageWithURL(picURL)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 准备cell里面的UI
    private func setupUI() {
        
        contentView.addSubview(iconView)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconView":iconView]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[iconView]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["iconView":iconView]))

    }
    
    private lazy var iconView:UIImageView = {
        
        let iconView = UIImageView()
        
        iconView.contentMode = UIViewContentMode.ScaleAspectFill
        
        iconView.clipsToBounds = true
        
        return iconView
        
    }()
    
    
    
}