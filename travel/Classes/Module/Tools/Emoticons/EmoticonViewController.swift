//
//  EmoticonViewController.swift
//  EmoticonKeyboard
//
//  Created by 张鹏 on 15/8/5.
//  Copyright © 2015年 cabbage. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController {
    
    var selectedEmoticonCallBack:(emoticon:Emoticons) -> ()
    
    init(selectEmoticon:(emoticon:Emoticons) -> ()) {
    
        selectedEmoticonCallBack = selectEmoticon
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        
        setupUI()
    }

    private func setupUI() {
        
        view.addSubview(toolBar)
        view.addSubview(emoticonView)
        
        perpareToolBar()
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        emoticonView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolBar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["toolBar":toolBar]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[emoticonView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["emoticonView":emoticonView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[emoticonView][toolBar(44)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["toolBar":toolBar,"emoticonView":emoticonView]))
    }
    
    private func perpareToolBar() {
        
        var items = [UIBarButtonItem]()
        
        var index = 0
        
        for name in ["最近", "默认", "Emoji","浪小花"] {
            
            let toolBtn = UIBarButtonItem(title: name, style: UIBarButtonItemStyle.Plain, target: self, action: "clickItemBtn:")
            
            toolBtn.tag = index++
            
            items.append(toolBtn)
            
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))

        }
        items.removeLast()
        
        toolBar.items = items
    }
    
    func clickItemBtn(toolBtn:UIBarButtonItem) {
        
        let indexPath = NSIndexPath(forItem: 0, inSection: toolBtn.tag)
        
        emoticonView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        
        
    }
    // MARK: - 懒加载
    private lazy var emoticonPackage = EmoticonPackage.package()
    
    private lazy var emoticonView:UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        
        let itemW = UIScreen.mainScreen().bounds.width / 7
        
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: itemW, height: itemW)
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        let emoticonView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        
        emoticonView.backgroundColor = UIColor.whiteColor()
        
        emoticonView.pagingEnabled = true
        emoticonView.dataSource = self
        emoticonView.delegate = self
        
        emoticonView.registerClass(emoticonCell.self, forCellWithReuseIdentifier: "emoticonCell")
        
        return emoticonView
        
        }()
    
    private lazy var toolBar:UIToolbar = {
        
        let toolBar = UIToolbar()
        
        return toolBar
        
    }()
}

/// EmoticonView 的数据源方法
extension EmoticonViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        return emoticonPackage.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return emoticonPackage[section].emoticons!.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emoticonCell", forIndexPath: indexPath) as! emoticonCell
        
        cell.emoticons = emoticonPackage[indexPath.section].emoticons![indexPath.item]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let emoticon = emoticonPackage[indexPath.section].emoticons![indexPath.item]
        
        selectedEmoticonCallBack(emoticon: emoticon)
    }
    
}

/// 自定义emoticonCell
private class emoticonCell:UICollectionViewCell {
    
    var emoticons:Emoticons? {
        didSet {
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticons!.imagePath),forState: UIControlState.Normal)
            emoticonBtn.setImage(UIImage(contentsOfFile: emoticons!.imagePath),forState: UIControlState.Highlighted)
            
            emoticonBtn.setTitle(emoticons?.emoji, forState: UIControlState.Normal)
            
            if emoticons!.removeEmoticon {
                
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: UIControlState.Normal)
                emoticonBtn.setImage(UIImage(named: "compose_emotion_delete_highlighted"), forState: UIControlState.Highlighted)
                
            }
        }
    }
    
    private lazy var emoticonBtn:UIButton = {
        
        let emoticonBtn = UIButton()
        
        emoticonBtn.userInteractionEnabled = false
        emoticonBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
        
        return emoticonBtn
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        emoticonBtn.frame = CGRectInset(bounds, 4, 4)
        
        contentView.addSubview(emoticonBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
    
}
