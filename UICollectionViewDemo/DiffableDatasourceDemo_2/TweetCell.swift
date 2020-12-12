//
//  TweetCell.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/10.
//


import UIKit

protocol TweetCellDelegate: class {
    func handleAddListTapped(_ cell: TweetCell)
    func handleRetweetTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleMediaTapped(_ cell: TweetCell, atIndex index: Int)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let imageInsetsConstant: CGFloat = 2
    
    // TODO: RealmSwift対応
    var tweet: Tweet? {
        didSet {
            initializeUI()
            configureUI()
        }
    }
    
    static let reuseIdentifer = "tweet-cell-reuse-identifier"
    
    weak var delegate: TweetCellDelegate?
    
    private lazy var mediaImageView_01: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        let tap = TweetMediaTapGestureRecognizer(target: self, action: #selector(handleMediaTapped(_:)))
        tap.tag = 0
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var mediaImageView_02: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        let tap = TweetMediaTapGestureRecognizer(target: self, action: #selector(handleMediaTapped(_:)))
        tap.tag = 1
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var mediaImageView_03: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        let tap = TweetMediaTapGestureRecognizer(target: self, action: #selector(handleMediaTapped(_:)))
        tap.tag = 2
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var mediaImageView_04: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        let tap = TweetMediaTapGestureRecognizer(target: self, action: #selector(handleMediaTapped(_:)))
        tap.tag = 3
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .random()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleMediaTapped(_ sender: TweetMediaTapGestureRecognizer) {
        guard let index = sender.tag else { return }
        delegate?.handleMediaTapped(self, atIndex: index)
    }
    
    // MARK: - Helpers
    
    private func initializeUI() {
        guard let tweet = tweet else { return }
 
        addSubview(mediaImageView_01)
        addSubview(mediaImageView_02)
        addSubview(mediaImageView_03)
        addSubview(mediaImageView_04)
        
        var imageSizes = TweetCellImageSizes()
        
        switch tweet.images.count {
        case 1:
            break
        case 2:
            break
        case 3:
            break
        case 4:
            let viewModel = TweetCellViewModel(tweet: tweet)
            imageSizes = viewModel.calculateImageSizes(withCellWidth: self.frame.width)
            
            mediaImageView_01.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor,
                                     paddingTop: imageInsetsConstant, paddingLeft: imageInsetsConstant, paddingRight: imageInsetsConstant)
            mediaImageView_02.anchor(top: mediaImageView_01.bottomAnchor, left: leftAnchor,
                                     paddingTop: imageInsetsConstant, paddingLeft: imageInsetsConstant)
            mediaImageView_03.anchor(top: mediaImageView_01.bottomAnchor, left: mediaImageView_02.rightAnchor, right: rightAnchor,
                                     paddingTop: imageInsetsConstant, paddingLeft: imageInsetsConstant, paddingRight: imageInsetsConstant)
            mediaImageView_04.anchor(top: mediaImageView_02.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                     paddingTop: imageInsetsConstant, paddingLeft: imageInsetsConstant, paddingRight: imageInsetsConstant)
        default:
            break
        }
        
        mediaImageView_01.setDimensions(width: imageSizes.sizeOfFirstImage.width,
                                        height: imageSizes.sizeOfFirstImage.height)
        mediaImageView_02.setDimensions(width: imageSizes.sizeOfSecondImage.width,
                                        height: imageSizes.sizeOfSecondImage.height)
        mediaImageView_03.setDimensions(width: imageSizes.sizeOfThirdImage.width,
                                        height: imageSizes.sizeOfThirdImage.height)
        mediaImageView_04.setDimensions(width: imageSizes.sizeOfFourthImage.width,
                                        height: imageSizes.sizeOfFourthImage.height)
    }
    
    private func configureUI() {
        configureImageViewContent()
    }
    
    /// 画像をセットするためのメソッド
    private func configureImageViewContent() {
        guard let tweet = tweet else { return }
        let count = tweet.images.count
        
        mediaImageView_01.image = tweet.images[0]
        
        if 2 <= count {
            mediaImageView_02.image = tweet.images[1]
        }
        
        if 3 <= count {
            mediaImageView_03.image = tweet.images[2]
        }
        
        if 4 == count {
            mediaImageView_04.image = tweet.images[3]
        }
    }
}

class TweetMediaTapGestureRecognizer: UITapGestureRecognizer {
    var tag: Int?
}


