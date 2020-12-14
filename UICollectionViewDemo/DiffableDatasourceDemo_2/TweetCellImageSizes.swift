//
//  TweetCellImageSizes.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/12.
//

import UIKit

struct TweetCellImageSizes {
    var fractionSizeOfFirstImage  : TweetCellImageSize
    var fractionSizeOfSecondImage : TweetCellImageSize
    var fractionSizeOfThirdImage  : TweetCellImageSize
    var fractionSizeOfFourthImage : TweetCellImageSize
    var fractionaHeightOfCell       : CGFloat  // cellの幅を1としたときのCellのHeight
    
    init(fractionSizeOfFirstImage  : TweetCellImageSize = .zero,
         fractionSizeOfSecondImage : TweetCellImageSize = .zero,
         fractionSizeOfThirdImage  : TweetCellImageSize = .zero,
         fractionSizeOfFourthImage : TweetCellImageSize = .zero,
         fractionaHeightOfCell     : CGFloat = 0.0) {
        self.fractionSizeOfFirstImage  = fractionSizeOfFirstImage
        self.fractionSizeOfSecondImage = fractionSizeOfSecondImage
        self.fractionSizeOfThirdImage  = fractionSizeOfThirdImage
        self.fractionSizeOfFourthImage = fractionSizeOfFourthImage
        self.fractionaHeightOfCell     = fractionaHeightOfCell
    }
}

struct TweetCellImageSize {
    
    // MARK: - Properties
    
    var fractionalWidth : CGFloat  // cellの幅を1としたときのWidth
    var fractionlHeight : CGFloat  // cellの幅を1としたときのHeight
    
    // MARK: - Lifecycle
    
    init(fractionalWidth: CGFloat = 0.0, fractionlHeight: CGFloat = 0.0) {
        self.fractionalWidth = fractionalWidth
        self.fractionlHeight = fractionlHeight
    }
    
    // MARK: - Static Methods
    
    static var zero: TweetCellImageSize {
        return TweetCellImageSize()
    }
}
