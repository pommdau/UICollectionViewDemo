//
//  SimpleCollectionViewCell.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/16.
//

import UIKit

class SimpleCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configureUI() }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 5
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .blue
        initializeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    // TODO: reuseされるときのbugfix
//    override func prepareForReuse() {
//        self.removeFromSuperview()
//    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    /// AutoLayoutの設定をinitにて行う
    private func initializeUI() {
        addSubview(imageView)
//        imageView.setDimensions(width: self.frame.width, height: self.frame.width)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    private func configureUI() {
        guard let tweet = tweet else { return }
        imageView.image = tweet.images[0]
    }
}
