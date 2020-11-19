//
//  PinterestCollectionViewCell.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/17.
//


import UIKit

class PinterestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var photo: Photo? {
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
    
    private func initializeUI() {
        addSubview(imageView)
//        imageView.setDimensions(width: self.frame.width, height: self.frame.width)
        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    private func configureUI() {
        guard let photo = photo else { return }
        imageView.image = photo.image
    }
}
