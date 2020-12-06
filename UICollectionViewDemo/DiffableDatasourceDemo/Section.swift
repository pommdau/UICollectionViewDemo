//
//  Section.swift
//  UICollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/06.
//

import UIKit

class Section: Hashable {
    
    var id = UUID()
    var userName: String
    var tweets: [Tweet]
    
    init(userName: String, tweets: [Tweet]) {
        self.userName = userName
        self.tweets = tweets
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
}

extension Section {
    static var allSections: [Section] =  [
        Section(userName: "Taro",
                tweets: Tweet.demoTweets()),
        Section(userName: "Jiro",
                tweets: Tweet.demoTweets()),
        Section(userName: "Saburo",
                tweets: Tweet.demoTweets()),
        Section(userName: "Shiro",
                tweets: Tweet.demoTweets()),
        Section(userName: "Goro",
                tweets: Tweet.demoTweets())
    ]
}
