//
//  ComposeViewController.swift
//  菜菜微博
//
//  Created by 张鹏 on 15/8/5.
//  Copyright © 2015年 张鹏. All rights reserved.
//

import UIKit
import SVProgressHUD

private let kStatusTextMaxLength = 140

class ComposeViewController: UIViewController, UITextViewDelegate {
    
    /// 发微博
    func sendStatus() {
        
        let text = textView.emoticonText
        
        if text.characters.count > kStatusTextMaxLength {
            SVProgressHUD.showInfoWithStatus("输入的文本太长!", maskType: SVProgressHUDMaskType.Gradient)
            
            return
        }
        
        NetworkTools.sharedNetworkToos.sendStatus(text, image: nil) { (json, error) -> () in
            
            if error != nil {
                print(error)
            }
            
            self.close()
        }
        
    }
    
    /// 输入图片
    func inputPhoto() {
        
        perparePhotoVc()
        
    }
    
    /// 输入表情
    func inputEmoticon() {
        
        textView.resignFirstResponder()
        
        textView.inputView = textView.inputView == nil ? emoticonVc.view : nil
        
        textView.becomeFirstResponder()
    
    }
    
    func textViewDidChange(textView: UITextView) {
        
        placeholderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
        
        let text = textView.emoticonText
        
        let length = kStatusTextMaxLength - text.characters.count
        
        lengthTipLabel.text = "\(length)"
        
        lengthTipLabel.textColor = length < 0 ? UIColor.redColor() : UIColor.grayColor()
        
    }
    
    /// 关闭控制器和键盘
    func close() {
        
        textView.resignFirstResponder()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func loadView() {
        
        view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        
        perpareItemBarUI()
        
        perpareTextView()
        
        perpareToolBar()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addKeyboardObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        removeKeyboardObserver()
    }
    
    /// 添加键盘通知
    private func addKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardFrameChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /// 键盘frame改变执行方法
    func keyboardFrameChange(noti:NSNotification) {
        
        let curve = noti.userInfo![UIKeyboardAnimationCurveUserInfoKey]!.integerValue
        
        let rect = noti.userInfo![UIKeyboardFrameEndUserInfoKey]!.CGRectValue
        
        let duration = noti.userInfo![UIKeyboardAnimationDurationUserInfoKey]!.doubleValue
        
        toolbarBottomCons?.constant = UIScreen.mainScreen().bounds.height - rect!.origin.y
        
        UIView.animateWithDuration(duration) { () -> Void in
            
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: curve)!)
            
            self.view.layoutIfNeeded()
            
        }
        
    }
    
    // MARK: - 准备itemBar
    private func perpareItemBarUI() {
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200 , height: 35 ))
        let nameLabel = UILabel(fontSize: 12 , fontColor: UIColor.darkGrayColor())
        let desLabel = UILabel(fontSize: 14, fontColor: UIColor.blackColor())
        
        titleView.addSubview(nameLabel)
        titleView.addSubview(desLabel)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Plain, target: self, action: "sendStatus")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")

        nameLabel.text = userAccount.loadAccount?.name ?? ""
        nameLabel.sizeToFit()
        
        desLabel.text = "发微博"
        desLabel.sizeToFit()

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: nameLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))

        desLabel.translatesAutoresizingMaskIntoConstraints = false
        titleView.addConstraint(NSLayoutConstraint(item: desLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0))
        titleView.addConstraint(NSLayoutConstraint(item: desLabel, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        
        navigationItem.titleView = titleView
  
    }
    
    // MARK: - 准备底部toolBar
    private var toolbarBottomCons:NSLayoutConstraint?
    private func perpareToolBar() {
        
        view.addSubview(toolBar)
        
        toolBar.backgroundColor = UIColor(white: 0.8, alpha: 1)
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[toolBar]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["toolBar":toolBar]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[toolBar(44)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["toolBar":toolBar]))
        toolbarBottomCons = view.constraints.last
        
        let itemSettings = [["imageName": "compose_toolbar_picture", "action": "inputPhoto"],
            ["imageName": "compose_mentionbutton_background"],
            ["imageName": "compose_trendbutton_background"],
            ["imageName": "compose_emoticonbutton_background", "action": "inputEmoticon"],
            ["imageName": "compose_addbutton_background"]]
        
        var items = [UIBarButtonItem]()
        
        for dict in itemSettings {
            
            items.append(UIBarButtonItem(imageNmae: dict["imageName"]!, traget: self, action: dict["action"]))

            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
            
        }
        items.removeLast()
        
        toolBar.items = items
    }
    
    // MARK: - 准备textView
    private func perpareTextView() {
        
        view.addSubview(textView)
        textView.addSubview(placeholderLabel)
        view.addSubview(lengthTipLabel)
        
        placeholderLabel.sizeToFit()
        placeholderLabel.text = "分享新鲜事..."
        
        lengthTipLabel.sizeToFit()
        lengthTipLabel.text = String(kStatusTextMaxLength)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[textView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textView":textView]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[textView][toolBar]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textView":textView,"toolBar":toolBar]))
        
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-5-[placeholderLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["placeholderLabel":placeholderLabel]))
        textView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-8-[placeholderLabel]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["placeholderLabel":placeholderLabel]))
        
        lengthTipLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[lengthTipLabel]-8-[toolBar]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["lengthTipLabel":lengthTipLabel,"toolBar":toolBar]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[lengthTipLabel]-8-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["lengthTipLabel":lengthTipLabel]))
        
    }
    
    private func perparePhotoVc() {
        
//        view.addSubview(photoVc.view)
//        
//        addChildViewController(photoVc)
////        presentViewController(photoVc, animated: true, completion: nil)
//        
//        var s = UIScreen.mainScreen().bounds.size
//        
////        s.height = 0.6 * s.height
//        
////        photoVc.view.bounds.size = s
//        
//        photoVc.view.backgroundColor = UIColor.redColor()
//        
//        photoVc.view.translatesAutoresizingMaskIntoConstraints = false
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[photoVc.view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["photoVc.view":photoVc.view]))
//        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[photoVc.view(400)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["photoVc.view":photoVc.view]))
        
        
    }
    
    
    // MARK: - 懒加载
    private lazy var textView:UITextView = {
        
        let textView = UITextView()
        
        textView.delegate = self
        
        textView.font = UIFont.systemFontOfSize(15)
        textView.alwaysBounceVertical = true
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        return textView
    }()
    
    private lazy var toolBar = UIToolbar()
    
    private lazy var placeholderLabel = UILabel(fontSize: 15 , fontColor: UIColor.grayColor())
    
    private lazy var emoticonVc:EmoticonViewController = EmoticonViewController { [weak self] (emoticon) -> () in
        
        self?.textView.insertEmoticon(emoticon)
        
    }
    
    private lazy var lengthTipLabel = UILabel(fontSize: 10, fontColor: UIColor.grayColor())
    
    private lazy var photoVc:PhotoSelectorViewController = PhotoSelectorViewController()

}
