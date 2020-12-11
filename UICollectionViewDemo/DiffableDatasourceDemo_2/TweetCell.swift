//
//  TweetCell.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/10.
//



//class TweetCell: UICollectionViewCell {
//
//    // MARK: - Properties
//
//    static let reuseIdentifer = "tweet-cell-reuse-identifier"
//
//    var tweet: Tweet? {
//        didSet { configureUI() }
//    }
//
//    lazy var imageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 20
//        return iv
//    }()
//
//    // MARK: - Lifecycle
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .yellow
//        initializeUI()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
////    // TODO: reuseされるときのbugfix
////    override func prepareForReuse() {
////        self.removeFromSuperview()
////    }
//
//    // MARK: - Selectors
//
//    // MARK: - Helpers
//
//    private func initializeUI() {
//        addSubview(imageView)
////        imageView.setDimensions(width: self.frame.width, height: self.frame.width)
//        imageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
//    }
//
//    private func configureUI() {
//        guard let tweet = tweet else { return }
//        imageView.image = tweet.images[0]
//    }
//}

import UIKit

protocol TweetCellDelegate: class {
    func handleAddListTapped(_ cell: TweetCell)
    func handleRetweetTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
    func handleMediaTapped(_ cell: TweetCell, atIndex index: Int)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // TODO: RealmSwift対応
    var tweet: Tweet? {
        didSet { configureUI() }
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
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: reuseされるときのbugfix
    override func prepareForReuse() {
        self.removeFromSuperview()
    }
    
    // MARK: - Selectors
    
    @objc func handleMediaTapped(_ sender: TweetMediaTapGestureRecognizer) {
        guard let index = sender.tag else { return }
        delegate?.handleMediaTapped(self, atIndex: index)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        
        guard let tweet = tweet else { return }
        
        let imageStack: UIStackView
        
        switch tweet.images.count {
        case 1:
            imageStack = UIStackView(arrangedSubviews: [mediaImageView_01])
        case 2:
            imageStack = UIStackView(arrangedSubviews: [mediaImageView_01, mediaImageView_02])
            imageStack.axis = .horizontal
            imageStack.distribution = .fillEqually
            imageStack.spacing = 4
        case 3:
            let rightImageStack = UIStackView(arrangedSubviews: [mediaImageView_02, mediaImageView_03])
            rightImageStack.axis = .vertical
            rightImageStack.distribution = .fillEqually
            rightImageStack.spacing = 4

            imageStack = UIStackView(arrangedSubviews: [mediaImageView_01, rightImageStack])
            imageStack.axis = .horizontal
            imageStack.distribution = .fillEqually
            imageStack.spacing = 4
        case 4:
            let topImageStack = UIStackView(arrangedSubviews: [mediaImageView_01, mediaImageView_02])
            topImageStack.axis = .horizontal
            topImageStack.distribution = .fillEqually
            topImageStack.spacing = 4

            let bottomImageStack = UIStackView(arrangedSubviews: [mediaImageView_03, mediaImageView_04])
            bottomImageStack.axis = .horizontal
            bottomImageStack.distribution = .fillEqually
            bottomImageStack.spacing = 4

            imageStack = UIStackView(arrangedSubviews: [topImageStack, bottomImageStack])
            imageStack.axis = .vertical
            imageStack.distribution = .fillEqually
            imageStack.spacing = 4
        default:
            fatalError()
        }
        
        addSubview(imageStack)
//        imageStack.setDimensions(width: self.frame.width, height: self.frame.width)
        imageStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        /*
        let actionStack = UIStackView(arrangedSubviews: [addListButton, retweetButton, likeButton])
        actionStack.axis = .horizontal
        actionStack.distribution = .fillEqually
        actionStack.spacing = 2
        addSubview(actionStack)
//        actionStack.anchor(top: imageStack.bottomAnchor, left: leftAnchor,bottom: bottomAnchor, right: rightAnchor,
//                           paddingTop: 4)
        actionStack.anchor(top: imageStack.bottomAnchor, left: leftAnchor, right: rightAnchor,
                           paddingTop: 4)
        */
        
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
