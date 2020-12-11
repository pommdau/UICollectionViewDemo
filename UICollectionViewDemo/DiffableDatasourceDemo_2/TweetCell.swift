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
            print("DEBUG: 🍏")
        default:
            fatalError()
        }
        
//        imageStack.setDimensions(width: self.frame.width, height: self.frame.width)
        let imageView01Size = calculateImageSize(withImage: tweet.images[0])
        let imageVIew02and03Sizes = calculateTwoImageSizes(withImages: [tweet.images[1], tweet.images[2]])
        let imageView02Size = imageVIew02and03Sizes[0]
        let imageView03Size = imageVIew02and03Sizes[1]
        let imageView04Size = calculateImageSize(withImage: tweet.images[3])
        mediaImageView_01.setDimensions(width: imageView01Size.width,
                                        height: imageView01Size.height)
        mediaImageView_02.setDimensions(width: imageView02Size.width,
                                        height: imageView02Size.height)
        mediaImageView_03.setDimensions(width: imageView03Size.width,
                                        height: imageView03Size.height)
        mediaImageView_04.setDimensions(width: imageView04Size.width,
                                        height: imageView04Size.height)
        
        addSubview(mediaImageView_01)
        addSubview(mediaImageView_02)
        addSubview(mediaImageView_03)
        addSubview(mediaImageView_04)
        
        mediaImageView_01.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor)
        mediaImageView_02.anchor(top: mediaImageView_01.bottomAnchor, left: leftAnchor)
        mediaImageView_03.anchor(top: mediaImageView_01.bottomAnchor, left: mediaImageView_02.rightAnchor,
                                 right: rightAnchor)
        mediaImageView_04.anchor(top: mediaImageView_02.bottomAnchor, left: leftAnchor, right: rightAnchor)
        
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

extension TweetCell {
    
    func calculateImageSize(withImage image: UIImage) -> CGSize {

        let widthOfView = self.frame.width
        let ratio = widthOfView / image.size.width
        
        return CGSize(width: widthOfView, height: image.size.height * ratio)
    }
    
    func calculateTwoImageSizes(withImages images: [UIImage]) -> [CGSize] {
//        let netWidth = view.frame.width - imageInsetsConstant * 2  // いるのかわからん
        let netWidth = self.frame.width
        
        let size1 = images[0].size
        let size2 = images[1].size
        
        // 高さを揃えて幅の割合を計算
        let w2_dash = size1.width * (size1.height / size2.height)
        let w2_dash_dash = netWidth * (w2_dash / (size1.width + w2_dash))
        let resultHeight = size2.height * (w2_dash_dash / size2.width)
        
//        let w1_dash_dash = netWidth * (size1.width / (size1.width + w2_dash))
        let w1_dash_dash = netWidth - w2_dash_dash
        
        return [CGSize(width: w1_dash_dash, height: resultHeight),
                CGSize(width: w2_dash_dash, height: resultHeight)]
    }
    
    
//    func calculateWidthFraction(withImages images: [UIImage], atIndex index: Int) -> CGFloat {
//        var sizes = [CGSize]()
//        images.forEach { image in
//            sizes.append(sizeAspectFittingView(image: image))
//        }
//
//        return sizes[index].width / sizes.reduce(0, { result, element in result + element.width })
//    }
//
//    func calculateHeightFraction(withImages images: [UIImage], atIndex index: Int) -> CGFloat {
//        var sizes = [CGSize]()
//        images.forEach { image in
//            sizes.append(sizeAspectFittingView(image: image))
//        }
//
//        return sizes[index].height / sizes.reduce(0, { result, element in result + element.height })
//    }
    
    func sizeAspectFittingView(image: UIImage) -> CGSize {
        let widthOfView = self.frame.width
        let heightOfView = self.frame.height
        let widthOfImage = image.size.width
        let heightOfImage = image.size.height
        
        guard widthOfView != 0,
              heightOfView != 0,
              widthOfImage != 0,
              heightOfImage != 0 else { return CGSize(width: 100, height: 100) }
        
        let ratio = widthOfView / widthOfImage

        let newWidthOfImage = widthOfView - imageInsetsConstant * 2
        let newHeightOfImage = heightOfImage * ratio - imageInsetsConstant * 2
        
        return CGSize(width: newWidthOfImage, height: newHeightOfImage)
    }
    
}

class TweetMediaTapGestureRecognizer: UITapGestureRecognizer {
    var tag: Int?
}


