//
//  AlbumCollectionViewCell.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/11/20.
//


import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "photo-item-cell-reuse-identifier"
    
    var photo: Photo? {
        didSet { configureUI() }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 10
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        initializeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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

