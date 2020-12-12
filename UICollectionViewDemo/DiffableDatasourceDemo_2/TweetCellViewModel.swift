//
//  TweetCellViewModel.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/12.
//


import UIKit


struct TweetCellViewModel {
    
    // MARK: - Properties
    
    let tweet: Tweet
    
    private let imageInsetsConstant: CGFloat = 2
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
    }
    
    // MARK: - Helpers
    
    func calculateImageSizes(withCellWidth width: CGFloat) -> TweetCellImageSizes {
        let netCellWidth = width - imageInsetsConstant * 2
        let size0     = calculateImageSize(withImage: tweet.images[0], width: netCellWidth)
        let size1and2 = calculateTwoImageSizes(withImages: [tweet.images[1], tweet.images[2]], width: netCellWidth)
        let size3     = calculateImageSize(withImage: tweet.images[3], width: netCellWidth)
        
        return TweetCellImageSizes(sizeOfFirstImage: size0,
                                   sizeOfSecondImage: size1and2[0],
                                   sizeOfThirdImage: size1and2[1],
                                   sizeOfFourthImage: size3,
                                   heightOfCell: size0.height + size1and2[0].height + size3.height + imageInsetsConstant * 4)
    }
    
    
    private func calculateImageSize(withImage image: UIImage, width: CGFloat) -> CGSize {

        let widthOfView = width
        let ratio = widthOfView / image.size.width
        
        return CGSize(width: widthOfView, height: image.size.height * ratio)
    }
    
    private func calculateTwoImageSizes(withImages images: [UIImage], width: CGFloat) -> [CGSize] {
//        let netWidth = view.frame.width - imageInsetsConstant * 2  // いるのかわからん
        let netWidth = width
        
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
    
    private func sizeAspectFittingView(image: UIImage, width: CGFloat) -> CGSize {
        let widthOfView = width
        let heightOfView = width
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

