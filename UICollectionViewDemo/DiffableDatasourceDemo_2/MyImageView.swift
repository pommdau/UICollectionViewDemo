//
//  MyImageView.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/12.
//

import UIKit

class MyImageView: UIImageView {
    
    @IBOutlet weak var widthConstraint  : NSLayoutConstraint?
    @IBOutlet weak var heightConstraint : NSLayoutConstraint?
    @IBOutlet weak var topConstraint    : NSLayoutConstraint?
    @IBOutlet weak var leftConstraint   : NSLayoutConstraint?
    @IBOutlet weak var rightConstraint  : NSLayoutConstraint?
    @IBOutlet weak var bottomConstraint : NSLayoutConstraint?
    
    // UICollectionViewのreusable cellのためにAutoLayoutの関数を別に用意する
    // 保存していたプロパティを使って、引数で指定されていないものを非アクティブにする
    
    func myAnchor(top: NSLayoutYAxisAnchor? = nil,
                  left: NSLayoutXAxisAnchor? = nil,
                  bottom: NSLayoutYAxisAnchor? = nil,
                  right: NSLayoutXAxisAnchor? = nil,
                  paddingTop: CGFloat = 0,
                  paddingLeft: CGFloat = 0,
                  paddingBottom: CGFloat = 0,
                  paddingRight: CGFloat = 0,
                  width: CGFloat? = nil,
                  height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topConstraint = topAnchor.constraint(equalTo: top, constant: paddingTop)
            topConstraint?.isActive = true
        } else {
            topConstraint?.isActive = false
        }
        
        if let left = left {
            leftConstraint = leftAnchor.constraint(equalTo: left, constant: paddingLeft)
            leftConstraint?.isActive = true
        } else {
            leftConstraint?.isActive = false
        }
        
        if let bottom = bottom {
            bottomConstraint = bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom)
            bottomConstraint?.isActive = true
        } else {
            bottomConstraint?.isActive = false
        }
        
        if let right = right {
            rightConstraint = rightAnchor.constraint(equalTo: right, constant: -paddingRight)
            rightConstraint?.isActive = true
        } else {
            rightConstraint?.isActive = false
        }
        
        if let width = width {
            widthConstraint = widthAnchor.constraint(equalToConstant: width)
            widthConstraint?.isActive = true
        } else {
            widthConstraint?.isActive = false
        }
        
        if let height = height {
            heightConstraint = heightAnchor.constraint(equalToConstant: height)
            heightConstraint?.isActive = true
        } else {
            heightConstraint?.isActive = false
        }
    }
    
    func mySetDimensions(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint?.isActive = true
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
    }

}
