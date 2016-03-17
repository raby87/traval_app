//
//  PhotoSelectorViewController.swift
//  图片选择器
//
//  Created by 张鹏 on 15/8/8.
//  Copyright © 2015年 cabbage. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PhotoSelectorCell"

class PhotoSelectorViewController: UICollectionViewController, PhotoSelectorCellDelegate {
    
    lazy var photos:[UIImage] = [UIImage]()
    
    private var currentIndex = 0
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()

        self.collectionView!.registerClass(PhotoSelectorCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        
        layout?.itemSize = CGSize(width: 80 , height: 80 )
        layout?.sectionInset = UIEdgeInsets(top: 10 , left: 10 , bottom: 10 , right: 10 )


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }



    // MARK: UICollectionView数据源方法
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count + 1
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoSelectorCell
        
        cell.image = indexPath.item < photos.count ? photos[indexPath.item] : nil
        
        cell.delegate = self
    
        return cell
    }
    // MARK: - cell的代理方法,执行添加/移除方法
    /// 添加图片
    private func PhotoSelectorCellSelectPhoto(cell: PhotoSelectorCell) {
        
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            return
        }
        
        let indexPath = collectionView?.indexPathForCell(cell)
        
        currentIndex = indexPath!.item
        
        let imagePickerVc = UIImagePickerController()
        
        imagePickerVc.delegate = self
        
        
        
        presentViewController(imagePickerVc, animated: true, completion: nil)
        
    }
    /// 移除图片
    private func PhotoSelectorCellselectRemove(cell: PhotoSelectorCell) {
        
        let indexPath = collectionView?.indexPathForCell(cell)
        
        photos.removeAtIndex(indexPath!.item)
        
        collectionView?.reloadData()
        
    }


}

// MARK: - imagePicker的代理方法
extension PhotoSelectorViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        if currentIndex < photos.count {
            
            photos[currentIndex] = image.scaleImage(300)
            
        } else {
            
            photos.append(image.scaleImage(300))
        }
        
        

        collectionView?.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }  
    
}

/// 选择图片的cell代理协议
private protocol PhotoSelectorCellDelegate:NSObjectProtocol {
    
    func PhotoSelectorCellSelectPhoto(cell:PhotoSelectorCell)
    func PhotoSelectorCellselectRemove(cell:PhotoSelectorCell)
 
}

// MARK: - 图片选择器的cell
private class PhotoSelectorCell:UICollectionViewCell {
    
    var delegate:PhotoSelectorCellDelegate?
    var image:UIImage? {
        didSet {
            
            if image == nil {
                photoButton.setImage("compose_pic_add")
                
            } else {
                photoButton.setImage(image, forState: UIControlState.Normal)
            }
            
            removeButton.hidden = (image == nil)
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        perpareUI()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 点击选择图片
    @objc func clickPhotoButton() {
        
        delegate?.PhotoSelectorCellSelectPhoto(self)
        
    }
    /// 点击移除图片
    @objc func clickRemoveButton() {
        
        delegate?.PhotoSelectorCellselectRemove(self)
    }
    
    /// 准备图片选择框的UI
    private func perpareUI() {
        
        contentView.addSubview(photoButton)
        contentView.addSubview(removeButton)
        
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[photoButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["photoButton":photoButton]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[photoButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["photoButton":photoButton]))
        
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[removeButton]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton":removeButton]))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[removeButton]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["removeButton":removeButton]))
        
        photoButton.addTarget(self, action: "clickPhotoButton", forControlEvents: UIControlEvents.TouchUpInside)
        removeButton.addTarget(self, action: "clickRemoveButton", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    // MARK: - 懒加载
    private lazy var photoButton:UIButton = UIButton(imageName: "compose_pic_add")
    private lazy var removeButton:UIButton = UIButton(imageName: "compose_photo_close")
    
    
    
    
}
