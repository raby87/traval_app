//
//  NewFeatureViewController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/7/31.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NewFeatureViewController: UICollectionViewController {
    
    private let imageCount = 4
    
    private var layout = NewFeatureLayout()
    
    init() {
        super.init(collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.registerClass(NewFeatureCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // MARK: - UICollectionView数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return imageCount
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! NewFeatureCell
        
        cell.imageIndex = indexPath.item
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let path = collectionView.indexPathsForVisibleItems().last!
        
        if path.item == imageCount - 1 {
            
            let cell = collectionView.cellForItemAtIndexPath(path) as! NewFeatureCell
            
            cell.statBtnAnimation()
            
        }
 
    }

}

//自定义CollectionViewCell
class NewFeatureCell:UICollectionViewCell {
    
    private var imageIndex: Int? = 0  {
        didSet {
            
            image?.image = UIImage(named:"new_feature_\(imageIndex! + 1)")
            image?.frame = self.contentView.bounds
            
            newBtn!.hidden = true
            
            self.contentView.addSubview(image!)
            self.contentView.addSubview(newBtn!)
        }
    }
    
    //开始进入Btn的执行动画
    func statBtnAnimation() {
        
        newBtn?.hidden = false
        newBtn?.userInteractionEnabled = false
        
        newBtn?.transform = CGAffineTransformMakeScale(0.0, 0.0)
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: { () -> Void in
            
            self.newBtn?.transform = CGAffineTransformIdentity
            self.newBtn?.layoutIfNeeded()
        
        }) { (_) -> Void in
                
            self.newBtn?.userInteractionEnabled = true
        }
        
        
    }
    
    //懒加载新特性的image和button
    private var image:UIImageView? = UIImageView()
    
    private lazy var newBtn:UIButton? = {
        
        let newBtn = UIButton()
        
        newBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        newBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        
        newBtn.setTitle("立即进入", forState: UIControlState.Normal)
        newBtn.sizeToFit()
        
        newBtn.center.x = self.contentView.bounds.width * 0.5
        newBtn.center.y = self.contentView.bounds.height - 160
        
        return newBtn
    }()
    
}

//自定义CollectionViewFlowLayout
private class NewFeatureLayout:UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        itemSize = collectionView!.bounds.size
        scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        collectionView?.bounces = false
        collectionView?.pagingEnabled = true
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
  
    }
    
}


