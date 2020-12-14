//
//  UIImage+CalculateFractionalSize.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/14.
//

import UIKit

extension UIImage {
    // widthを1.0としたときのheightの相対的な高さ
    func fractionalSize() -> TweetCellImageSize {
        let width  = self.size.width
        let height = self.size.height
        
        guard width != 0,
              height != 0 else {
            return .zero
        }
        let fractionalHeight = height / width
        
        return TweetCellImageSize(fractionalWidth: 1.0, fractionlHeight: fractionalHeight)
    }
    
    // ![image](https://i.imgur.com/ER3agrp.png)
    static func calculateFractionalHeightOfTwoImage(withImages images: [UIImage]) -> [TweetCellImageSize] {
        let size1 = images[0].size
        let size2 = images[1].size
        
        // 高さを揃えて幅の割合を計算
        let w2_dash = size1.width * (size1.height / size2.height)
        let w2_dash_dash = 1.0 * (w2_dash / (size1.width + w2_dash))
        let resultHeight = size2.height * (w2_dash_dash / size2.width)
        
        let w1_dash_dash = 1.0 - w2_dash_dash
        
        return [TweetCellImageSize(fractionalWidth: w1_dash_dash, fractionlHeight: resultHeight),
                TweetCellImageSize(fractionalWidth: w2_dash_dash, fractionlHeight: resultHeight)]
    }
}
