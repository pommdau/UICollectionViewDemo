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
    
    func calculateImageSizes() -> TweetCellImageSizes {
        let sizeOfFirstImage           = tweet.images[0].fractionalSize()
        let sizeOfSecondAndThirdImages = UIImage.calculateFractionalHeightOfTwoImage(withImages: [tweet.images[1], tweet.images[2]])
        let sizeOfSecondImage          = sizeOfSecondAndThirdImages[0]
        let sizeOfThirdImage           = sizeOfSecondAndThirdImages[1]
        let sizeOfFourthImage          = tweet.images[3].fractionalSize()
        let fractionaHeightOfCell      = sizeOfFirstImage.fractionlHeight
            + sizeOfSecondImage.fractionlHeight
            + sizeOfFourthImage.fractionlHeight
        
        return TweetCellImageSizes(fractionSizeOfFirstImage  : sizeOfFirstImage,
                                   fractionSizeOfSecondImage : sizeOfSecondImage,
                                   fractionSizeOfThirdImage  : sizeOfThirdImage,
                                   fractionSizeOfFourthImage : sizeOfFourthImage,
                                   fractionaHeightOfCell     : fractionaHeightOfCell)
    }
}

