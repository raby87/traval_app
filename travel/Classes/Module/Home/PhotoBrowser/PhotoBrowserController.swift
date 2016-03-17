//
//  PhotoBrowserController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/9.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SVProgressHUD

class PhotoBrowserController: UIViewController {
    
    var imageURLs:[NSURL]
    
    var index:Int
    
    var flag:Bool = false
    
    init(imageURLs:[NSURL],index:Int) {
        
        self.imageURLs = imageURLs
        self.index = index
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        
        view = UIView(frame: UIScreen.mainScreen().bounds)
        
        perpareUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if flag == true {
            return
        }
        
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        pictureView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
        flag = true
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func perpareUI() {
        
        view.addSubview(pictureView)
        view.addSubview(closeButton)
        view.addSubview(saveButton)
        
        pictureView.registerClass(PictureViewCell.self, forCellWithReuseIdentifier: "PhotoBrowser")
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[closeButton]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton":closeButton]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[saveButton]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["saveButton":saveButton]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[closeButton(100)]-(>=0)-[saveButton(100)]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton":closeButton,"saveButton":saveButton]))
        
        closeButton.addTarget(self, action: "closePhotoBrowser", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton.addTarget(self, action: "savePicture", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        perparePictureView()
        
    }
    
    func closePhotoBrowser() {
        
        dismissViewControllerAnimated(true , completion: nil)
    }
    
    func savePicture() {
        
        let indexPath = pictureView.indexPathsForVisibleItems().last!
        let cell = pictureView.cellForItemAtIndexPath(indexPath) as! PictureViewCell
        
        guard let image = cell.imageView.image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, "image:didFinishSavingWithError:contextInfo:", nil)
        
        
    }
    
    
    func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject?) {
        
        (error == nil) ? SVProgressHUD.showSuccessWithStatus("保存成功") : SVProgressHUD.showErrorWithStatus("保存失败")
        
    }
    
    private func perparePictureView() {
        
        let layout = pictureView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = self.view.bounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        
        pictureView.frame = view.bounds
        pictureView.pagingEnabled = true
        
        pictureView.dataSource = self
        
    }

    private lazy var pictureView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var closeButton:UIButton = UIButton(imageName: "", title: "关闭", fontSize: 14, fontColor: UIColor.whiteColor())
    private lazy var saveButton:UIButton = UIButton(imageName: "", title: "保存", fontSize: 14, fontColor: UIColor.whiteColor())

}

extension PhotoBrowserController:UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return imageURLs.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoBrowser", forIndexPath: indexPath) as! PictureViewCell
        
        cell.imageURL = imageURLs[indexPath.item]
        
        return cell
    }
    
    
    
    
}

