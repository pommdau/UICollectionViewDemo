//
//  Tweet.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/05.
//

import UIKit

struct Tweet: Hashable {
    
    // MARK: - Properties
    
    var id = UUID().uuidString
    var text     : String
    var images   : [UIImage]
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
}

// MARK: - Static Methods

extension Tweet {
    
    static func demoTweets() -> [Tweet] {
        var tweets = [Tweet]()
        
        for _ in 0..<2 {
            tweets.append(Tweet.randomTweet())
        }
        
        return tweets
    }
    
    static func randomTweet() -> Tweet {
        return Tweet(text: randomText(), images: randomImages(numberOfImages: 4))
    }
    
    private static func randomUserName() -> String {
        let userNameList = ["Taro",
                            "Jiro",
                            "Saburo",
                            "Shiro",
                            "Goro"
        ]
        
        return userNameList[Int.random(in: 0...userNameList.count - 1)]
    }
    
    private static func randomText() -> String {
        let textList = [
            "Good morning!",
            "Good afternoon!",
            "Good evening!"
        ]
        
        return textList[Int.random(in: 0...textList.count - 1)]
    }
    
//    private static func randomImages(numberOfImages: Int = 0) -> [UIImage] {
//        let imageList      = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"]
//        let imageIndexes   = [0, 1, 2, 3]
//        let images = imageIndexes.map({ index in UIImage(named: imageList[index])! })
//        return images
//    }
    
    private static func randomImages(numberOfImages: Int = 0) -> [UIImage] {
        
        let numberOfImages = 0 < numberOfImages ? numberOfImages : Int.random(in: 1...4)
        var imageIndexes   = [Int]()

        while imageIndexes.count < numberOfImages  {
            let index = Int.random(in: 0..<13)
            guard !imageIndexes.contains(index) else { continue }
            imageIndexes.append(index)
        }

        let images = imageIndexes.map({ index in image(atIndex: index) })
        return images
    }
    
    private static func image(atIndex index: Int) -> UIImage {
        let imageList = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13"]
        return UIImage(named: imageList[index])!
    }
}
